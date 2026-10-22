import { useEffect, useRef, useState, type ReactNode } from 'react';
import { ChevronLeft, ChevronRight, Maximize, Minimize, Minus, Plus } from 'lucide-react';
import { getDocument, GlobalWorkerOptions, TextLayer, type PDFDocumentProxy, type PDFPageProxy } from 'pdfjs-dist';
import 'pdfjs-dist/web/pdf_viewer.css';
import { assetUrl } from '../lib/urls';

GlobalWorkerOptions.workerSrc = assetUrl('pdfjs/pdf.worker.min.mjs');

function PdfPage({ document, number, width, dark }: { document: PDFDocumentProxy; number: number; width: number; dark: boolean }) {
  const container = useRef<HTMLDivElement>(null);
  const canvas = useRef<HTMLCanvasElement>(null);
  const text = useRef<HTMLDivElement>(null);
  const [page, setPage] = useState<PDFPageProxy>();
  const [visible, setVisible] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    let cancelled = false;
    document.getPage(number).then(page => { if (!cancelled) setPage(page); }).catch(error => { if (!cancelled) setError(String(error)); });
    const observer = new IntersectionObserver(entries => setVisible(entries[0]!.isIntersecting), { rootMargin: '600px 0px' });
    observer.observe(container.current!);
    return () => { cancelled = true; observer.disconnect(); };
  }, [document, number]);

  useEffect(() => {
    if (!page || !visible || !width) return;
    const viewport = page.getViewport({ scale: width / page.getViewport({ scale: 1 }).width });
    const ratio = Math.min(window.devicePixelRatio || 1, 2);
    const element = canvas.current!;
    element.width = Math.ceil(viewport.width * ratio);
    element.height = Math.ceil(viewport.height * ratio);
    element.style.width = `${viewport.width}px`;
    element.style.height = `${viewport.height}px`;
    const render = page.render({ canvas: element, viewport, pageColors: dark ? { background: '#172129', foreground: '#e2e9ec' } : undefined, transform: ratio === 1 ? undefined : [ratio, 0, 0, ratio, 0, 0] });
    text.current!.replaceChildren();
    const layer = new TextLayer({ textContentSource: page.streamTextContent(), container: text.current!, viewport });
    Promise.all([render.promise, layer.render()]).catch(error => { if (error?.name !== 'RenderingCancelledException' && error?.name !== 'AbortException') setError(String(error)); });
    return () => { render.cancel(); layer.cancel(); };
  }, [page, visible, width, dark]);

  const viewport = page?.getViewport({ scale: 1 });
  return <div ref={container} className="pdf-page" id={`pdf-page-${number}`} role="region" aria-label={`Page ${number}`} style={{ width, height: viewport ? width * viewport.height / viewport.width : width * Math.SQRT2, '--scale-factor': viewport ? width / viewport.width : 1 } as React.CSSProperties}>
    <canvas ref={canvas} aria-hidden="true" /><div ref={text} className="textLayer" />{error && <p role="alert">{error}</p>}
  </div>;
}

interface Props {
  pdf?: Uint8Array<ArrayBuffer>;
  pending: boolean;
  dark: boolean;
  toolbar: ReactNode;
  actions: ReactNode;
  onReady: () => void;
}

export default function PdfViewer({ pdf, pending, dark, toolbar, actions, onReady }: Props) {
  const [loaded, setLoaded] = useState<{ pdf: Uint8Array<ArrayBuffer>; document: PDFDocumentProxy }>();
  // Retirer les pages précédentes dès que les données changent, avant de détruire leur transport PDF.js.
  const document = loaded?.pdf === pdf ? loaded?.document : undefined;
  const [error, setError] = useState('');
  const [width, setWidth] = useState(600);
  const [zoom, setZoom] = useState(1);
  const [current, setCurrent] = useState(1);
  const [fullscreen, setFullscreen] = useState(false);
  const [fullscreenError, setFullscreenError] = useState('');
  const [height, setHeight] = useState(600);
  const [aspect, setAspect] = useState(1);
  const viewer = useRef<HTMLDivElement>(null);
  const scroll = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!pdf) { setLoaded(undefined); return; }
    let cancelled = false;
    setError('');
    const loading = getDocument({ data: pdf.slice(), cMapUrl: `${assetUrl('pdfjs/cmaps')}/`, cMapPacked: true, standardFontDataUrl: `${assetUrl('pdfjs/standard_fonts')}/`, wasmUrl: `${assetUrl('pdfjs/wasm')}/` });
    loading.promise.then(document => { if (!cancelled) { setLoaded({ pdf, document }); setCurrent(page => Math.min(page, document.numPages)); } }).catch(error => { if (!cancelled) setError(String(error)); });
    return () => { cancelled = true; void loading.destroy(); };
  }, [pdf]);
  useEffect(() => {
    const observer = new ResizeObserver(entries => {
      setWidth(Math.max(1, entries[0]!.contentRect.width));
      setHeight(Math.max(1, entries[0]!.contentRect.height));
    });
    observer.observe(scroll.current!);
    onReady();
    return () => observer.disconnect();
  }, []);
  useEffect(() => {
    const changed = () => setFullscreen(globalThis.document.fullscreenElement === viewer.current);
    globalThis.document.addEventListener('fullscreenchange', changed);
    return () => globalThis.document.removeEventListener('fullscreenchange', changed);
  }, []);
  useEffect(() => {
    if (!document || !fullscreen) return;
    let cancelled = false;
    document.getPage(current).then(page => {
      const viewport = page.getViewport({ scale: 1 });
      if (!cancelled) setAspect(viewport.width / viewport.height);
    }).catch(() => {});
    return () => { cancelled = true; };
  }, [document, current, fullscreen]);
  useEffect(() => {
    if (!fullscreen) scroll.current?.querySelector(`#pdf-page-${current}`)?.scrollIntoView({ block: 'start' });
  }, [fullscreen]);
  useEffect(() => { updateCurrentPage(); }, [document, width, zoom, fullscreen]);
  function updateCurrentPage() {
    if (fullscreen) return;
    const container = scroll.current!;
    const pages = [...container.querySelectorAll<HTMLElement>('.pdf-page')];
    if (!pages.length) return;
    const bottom = container.scrollTop + container.clientHeight;
    // Au bas du document, sélectionner aussi la dernière page lorsqu'elle est courte.
    if (container.scrollTop > 0 && bottom >= container.scrollHeight - 1) { setCurrent(pages.length); return; }
    let best = 0;
    let visible = -1;
    pages.forEach((page, index) => {
      const height = Math.min(bottom, page.offsetTop + page.offsetHeight) - Math.max(container.scrollTop, page.offsetTop);
      if (height > visible) { visible = height; best = index; }
    });
    setCurrent(best + 1);
  }
  function goTo(page: number) {
    if (!document || page < 1 || page > document.numPages) return;
    setCurrent(page);
    if (!fullscreen) scroll.current?.querySelector(`#pdf-page-${page}`)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  async function toggleFullscreen() {
    setFullscreenError('');
    try {
      if (fullscreen) await globalThis.document.exitFullscreen();
      else { setZoom(1); await viewer.current!.requestFullscreen(); scroll.current?.focus(); }
    } catch {
      setFullscreenError('Le navigateur a refusé le plein écran. Réessayer depuis l’onglet actif.');
    }
  }

  const pageWidth = fullscreen ? Math.min(width, height * aspect) * zoom : width * zoom;
  const pages = document ? fullscreen ? [current] : Array.from({ length: document.numPages }, (_, index) => index + 1) : [];

  return <div ref={viewer} className={`pdf-viewer${fullscreen ? ' pdf-fullscreen' : ''}`}>
    <div className="pdf-controls pane-toolbar">
      {toolbar}
      <div className="pdf-navigation">
        <div className="page-controls"><button className="btn btn-ghost btn-sm btn-square" aria-label="Page précédente" title="Page précédente (← dans l’aperçu)" disabled={!document || current <= 1} onClick={() => goTo(current - 1)}><ChevronLeft size={17} /></button><span aria-live="polite">{document ? `${current} / ${document.numPages}` : '— / —'}</span><button className="btn btn-ghost btn-sm btn-square" aria-label="Page suivante" title="Page suivante (→ dans l’aperçu)" disabled={!document || current >= document.numPages} onClick={() => goTo(current + 1)}><ChevronRight size={17} /></button></div>
        <div className="zoom-controls"><button className="btn btn-ghost btn-sm btn-square" aria-label="Réduire le zoom" title="Réduire le zoom (− dans l’aperçu)" disabled={zoom <= 0.5} onClick={() => setZoom(zoom => Math.max(0.5, zoom - 0.1))}><Minus size={17} /></button><button className="btn btn-ghost btn-sm zoom-reset" aria-label="Ajuster à la largeur" title="Ajuster à la largeur (0 dans l’aperçu)" onClick={() => setZoom(1)}>{Math.round(zoom * 100)} %</button><button className="btn btn-ghost btn-sm btn-square" aria-label="Agrandir le zoom" title="Agrandir le zoom (+ dans l’aperçu)" disabled={zoom >= 2} onClick={() => setZoom(zoom => Math.min(2, zoom + 0.1))}><Plus size={17} /></button></div>
      </div>
      {actions}
      <button className="btn btn-ghost btn-sm btn-square" aria-label={fullscreen ? 'Quitter le plein écran' : 'Présenter en plein écran'} title={fullscreen ? 'Quitter le plein écran (Échap)' : 'Présenter en plein écran'} disabled={!document} onClick={toggleFullscreen}>{fullscreen ? <Minimize size={17} /> : <Maximize size={17} />}</button>
    </div>
    {fullscreenError && <p className="viewer-error" role="alert">{fullscreenError}</p>}
    <div ref={scroll} className="pdf-scroll" id="pdf-preview" role="tabpanel" tabIndex={0} aria-label="Aperçu PDF" aria-busy={pending} onScroll={updateCurrentPage} onKeyDown={event => {
      if (event.target !== event.currentTarget || event.metaKey || event.ctrlKey || event.altKey) return;
      if (event.key === 'ArrowLeft' || event.key === 'ArrowRight') { event.preventDefault(); goTo(Math.max(1, Math.min(document?.numPages ?? 1, current + (event.key === 'ArrowRight' ? 1 : -1)))); }
      if (event.key === '+' || event.key === '=' || event.key === '-') { event.preventDefault(); setZoom(zoom => Math.max(0.5, Math.min(2, zoom + (event.key === '-' ? -0.1 : 0.1)))); }
      if (event.key === '0') { event.preventDefault(); setZoom(1); }
      if (fullscreen && [' ', 'PageDown', 'PageUp', 'Home', 'End'].includes(event.key)) {
        event.preventDefault();
        goTo(event.key === 'Home' ? 1 : event.key === 'End' ? document?.numPages ?? 1 : current + (event.key === 'PageUp' || event.shiftKey ? -1 : 1));
      }
    }}>
      {document && pages.map(number => <PdfPage key={`${document.loadingTask.docId}-${number}`} document={document} dark={dark} number={number} width={pageWidth} />)}
      {!document && !error && <div className="preview-placeholder">{(pending || pdf) && <span className="loading loading-spinner loading-sm" />}<span>{pending ? 'Compilation…' : pdf ? 'Chargement…' : 'Aucun aperçu'}</span></div>}
      {error && <p className="viewer-error" role="alert">Impossible d’afficher le PDF : {error}</p>}
    </div>
  </div>;
}
