const vscode = acquireVsCodeApi();
window.addEventListener('error', event => vscode.postMessage({ type: 'clientError', error: event.message }));
window.addEventListener('unhandledrejection', event => vscode.postMessage({ type: 'clientError', error: String(event.reason) }));
const status = document.getElementById('status');
const compileError = document.getElementById('compile-error');
const frames = new Map();
const pagination = new Map();
const pageProgress = document.getElementById('page-progress');
const pageNumber = document.getElementById('page-number');
const pageTotal = document.getElementById('page-total');
const previousPage = document.getElementById('previous-page');
const nextPage = document.getElementById('next-page');
const host = document.getElementById('viewers');
let pdfPages = 0;
let progressFrame;
let currentProgress = { current: 0, total: 0 };
let requestedPdfPage;
function showProgress(progress) {
  const { current = 0, total = 0 } = progress ?? {};
  const changed = current !== currentProgress.current || total !== currentProgress.total;
  currentProgress = { current, total };
  if (document.activeElement !== pageNumber || !total) pageNumber.value = total ? String(current) : '';
  pageNumber.disabled = !total;
  pageNumber.max = String(total);
  pageTotal.textContent = total ? String(total) : '—';
  previousPage.disabled = !total || current <= 1;
  nextPage.disabled = !total || current >= total;
  pageProgress.setAttribute('aria-label', total ? `Page ${current} sur ${total}` : 'Pagination indisponible');
  if (changed) vscode.postMessage({ type: 'pageProgress', current, total });
}
function goToPage(value) {
  if (!currentProgress.total || !Number.isInteger(value)) return;
  const page = Math.max(1, Math.min(value, currentProgress.total));
  if (state?.native) {
    const frame = frames.get(state.variant);
    frame?.contentWindow?.postMessage({ token: state.tokens?.[state.variant], type: 'goToPage', page }, new URL(frame.src).origin);
  } else {
    requestedPdfPage = page;
    const target = host.querySelector(`.page[data-page="${page}"]`);
    if (target) {
      host.scrollTo({ top: host.scrollTop + target.getBoundingClientRect().top - host.getBoundingClientRect().top });
      requestedPdfPage = undefined;
      schedulePdfProgress();
    }
  }
}
function choosePage() {
  const value = pageNumber.value === '' ? NaN : Number(pageNumber.value);
  if (Number.isInteger(value) && currentProgress.total) {
    pageNumber.value = String(Math.max(1, Math.min(value, currentProgress.total)));
    goToPage(Number(pageNumber.value));
  } else pageNumber.value = currentProgress.total ? String(currentProgress.current) : '';
}
pageNumber.addEventListener('change', choosePage);
pageNumber.addEventListener('blur', () => { pageNumber.value = currentProgress.total ? String(currentProgress.current) : ''; });
pageNumber.addEventListener('keydown', event => {
  if (event.key === 'Enter') { event.preventDefault(); choosePage(); pageNumber.blur(); }
  if (event.key === 'Escape') { event.preventDefault(); pageNumber.value = String(currentProgress.current || ''); pageNumber.blur(); }
});
previousPage.onclick = () => goToPage(currentProgress.current - 1);
nextPage.onclick = () => goToPage(currentProgress.current + 1);
function updatePdfProgress() {
  if (state?.native) return;
  const bounds = host.getBoundingClientRect();
  let current = 1, visible = -1;
  for (const page of host.querySelectorAll('.page')) {
    const rect = page.getBoundingClientRect();
    const height = Math.max(0, Math.min(rect.bottom, bounds.bottom) - Math.max(rect.top, bounds.top));
    if (height > visible) { visible = height; current = Number(page.dataset.page); }
  }
  showProgress({ current, total: pdfPages });
}
function schedulePdfProgress() {
  cancelAnimationFrame(progressFrame);
  progressFrame = requestAnimationFrame(updatePdfProgress);
}
host.addEventListener('scroll', schedulePdfProgress, { passive: true });
new ResizeObserver(schedulePdfProgress).observe(host);
let state;
let epoch = 0;
let rendered;
let workerSource;
const controls = frame => {
  const style = getComputedStyle(document.body);
  const scrollbarForeground = style.getPropertyValue('--vscode-foreground').trim();
  frame.contentWindow?.postMessage({ token: state.tokens?.[frame.dataset.variant], jumps: state.jumps, scrollbarForeground }, new URL(frame.src).origin);
};
new MutationObserver(() => { for (const frame of frames.values()) controls(frame); }).observe(document.body, { attributes: true, attributeFilter: ['class', 'style'] });
async function pdf(data) {
  if (rendered === data) return;
  rendered = data;
  const revision = ++epoch;
  pdfPages = 0;
  requestedPdfPage = undefined;
  showProgress();
  host.replaceChildren();
  host.scrollTop = 0;
  const base = document.body.dataset.pdfjs;
  const pdfjs = await import(base + 'pdf.mjs');
  workerSource ??= fetch(base + 'pdf.worker.mjs').then(response => { if (!response.ok) throw new Error('Chargement du lecteur PDF impossible.'); return response.text(); });
  // Workers loaded from a Blob and font outlines avoid webview origin/font-loading stalls.
  const url = URL.createObjectURL(new Blob([await workerSource], { type: 'text/javascript' }));
  const port = new Worker(url, { type: 'module' });
  const worker = new pdfjs.PDFWorker({ port });
  const loading = pdfjs.getDocument({ worker, useWorkerFetch: false, disableFontFace: true, data: Uint8Array.from(atob(data), c => c.charCodeAt(0)), cMapUrl: base + 'cmaps/', cMapPacked: true, standardFontDataUrl: base + 'standard_fonts/', wasmUrl: base + 'wasm/' });
  try {
    const doc = await loading.promise;
    if (revision !== epoch) return;
    pdfPages = doc.numPages;
    for (let n = 1; n <= doc.numPages && revision === epoch; n++) {
      const page = await doc.getPage(n);
      const scale = Math.max(0.2, (host.clientWidth - 24) / page.getViewport({ scale: 1 }).width);
      const viewport = page.getViewport({ scale });
      const pageView = document.createElement('div'); pageView.className = 'page';
      pageView.dataset.page = String(n);
      const canvas = document.createElement('canvas'); canvas.width = viewport.width; canvas.height = viewport.height;
      const textLayer = document.createElement('div'); textLayer.className = 'textLayer';
      if (revision !== epoch) break;
      pageView.append(canvas, textLayer); host.append(pageView);
      if (requestedPdfPage === n) goToPage(n);
      schedulePdfProgress();
      await Promise.all([
        page.render({ canvasContext: canvas.getContext('2d'), canvas, viewport, intent: 'print' }).promise,
        new pdfjs.TextLayer({ textContentSource: page.streamTextContent(), container: textLayer, viewport }).render()
      ]);
    }
    if (revision === epoch) vscode.postMessage({ type: 'pdfReady', pages: doc.numPages });
  } finally { await loading.destroy(); worker.destroy(); port.terminate(); URL.revokeObjectURL(url); }
}
const variants = [...document.querySelectorAll('[data-variant]')].map(button => button.id);
for (const id of [...variants, 'save', 'code', 'jumps', 'theme', 'fullscreen', 'restart']) {
  document.getElementById(id).onclick = () => vscode.postMessage({ type: id });
}
window.addEventListener('message', ({ data }) => {
  if (data?.channel !== document.body.dataset.channel) return;
  if (data.type === 'reset') { ++epoch; rendered = undefined; pdfPages = 0; requestedPdfPage = undefined; pagination.clear(); showProgress(); for (const frame of frames.values()) frame.remove(); frames.clear(); }
  if (data.type === 'status') { status.textContent = data.message; status.hidden = false; }
  if (data.type === 'compileError') { compileError.textContent = data.message; compileError.hidden = !data.message; }
  if (data.type !== 'show') return;
  state = data;
  if (data.allowedVariants) for (const variant of variants) document.getElementById(variant).hidden = !data.allowedVariants.includes(variant);
  document.body.classList.toggle('native-preview', !!data.native);
  document.getElementById('code').hidden = !data.hasCode;
  if (data.native) showProgress(pagination.get(data.variant));
  document.body.classList.toggle('pdf-dark', !data.native && data.dark);
  document.getElementById('jumps').disabled = !data.native;
  if (data.pdf) { status.hidden = true; void pdf(data.pdf).catch(error => { rendered = undefined; status.textContent = String(error); status.hidden = false; vscode.postMessage({ type: 'pdfError', error: String(error) }); }); }
  for (const [variant, url] of Object.entries(data.sessions)) {
    if (!frames.has(variant)) {
      const frame = document.createElement('iframe');
      frame.title = `${data.labels[variant]} — Tinymist`;
      frame.src = url;
      frame.dataset.variant = variant;
      frame.addEventListener('load', () => { controls(frame); vscode.postMessage({ type: 'frameReady', variant }); });
      frames.set(variant, frame);
      document.getElementById('viewers').append(frame);
    }
  }
  for (const [variant, frame] of frames) { frame.hidden = variant !== data.variant; controls(frame); }
  for (const variant of variants) document.getElementById(variant).setAttribute('aria-pressed', String(variant === data.variant));
  document.getElementById('jumps').setAttribute('aria-pressed', String(data.jumps));
  document.getElementById('theme').setAttribute('aria-pressed', String(data.dark));
  status.hidden = !!data.pdf || frames.has(data.variant);
});
window.addEventListener('message', event => {
  const data = event.data;
  if (!['pageProgress', 'pageStep', 'pageBoundary', 'selectVariant'].includes(data?.type)) return;
  for (const [variant, frame] of frames) {
    if (event.source !== frame.contentWindow || event.origin !== new URL(frame.src).origin || data.token !== state.tokens?.[variant]) continue;
    if (data.type === 'selectVariant') {
      if (state.variant === variant && variants.includes(data.variant)) vscode.postMessage({ type: data.variant });
      return;
    }
    if (data.type === 'pageBoundary') {
      if (state.variant === variant && ['start', 'end'].includes(data.boundary)) goToPage(data.boundary === 'start' ? 1 : currentProgress.total);
      return;
    }
    if (data.type === 'pageStep') {
      if (state.variant === variant && [1, -1].includes(data.delta)) goToPage(currentProgress.current + data.delta);
      return;
    }
    if (!Number.isInteger(data.current) || !Number.isInteger(data.total) || data.total < 1 || data.current < 1 || data.current > data.total) return;
    pagination.set(variant, { current: data.current, total: data.total });
    if (state.variant === variant) showProgress(data);
  }
});
window.addEventListener('keydown', event => {
  if (event.defaultPrevented || event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) return;
  if (['F5', 'F6', 'F7'].includes(event.key)) {
    event.preventDefault();
    event.stopImmediatePropagation();
    vscode.postMessage({ type: event.key === 'F5' ? 'enonce' : event.key === 'F6' ? 'corrige' : 'presentation' });
    return;
  }
  if (event.target.closest?.('input, textarea, [contenteditable="true"]')) return;
  if (['Home', 'End'].includes(event.key)) {
    event.preventDefault();
    goToPage(event.key === 'Home' ? 1 : currentProgress.total);
    return;
  }
  if (['ArrowLeft', 'ArrowRight'].includes(event.key)) {
    event.preventDefault();
    goToPage(currentProgress.current + (event.key === 'ArrowRight' ? 1 : -1));
    return;
  }
  if (state?.native || !['ArrowDown', 'ArrowUp', 'PageDown', 'PageUp'].includes(event.key)) return;
  event.preventDefault();
  const host = document.getElementById('viewers');
  host.scrollBy({ top: (event.key.endsWith('Down') ? 1 : -1) * (event.key.startsWith('Page') ? host.clientHeight * .9 : 60) });
}, true);
vscode.postMessage({ type: 'ready' });
