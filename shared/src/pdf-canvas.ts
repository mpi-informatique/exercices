// Le lecteur choisit son interface et sa couche d'annotations. Les deux sites
// utilisent les mêmes ressources, le même viewport et le même rendu HiDPI.
export function pdfSource(data: Uint8Array<ArrayBuffer> | ArrayBuffer, assets: string) {
  return { data: data.slice(0), cMapUrl: assets + 'cmaps/', cMapPacked: true, standardFontDataUrl: assets + 'standard_fonts/', wasmUrl: assets + 'wasm/' };
}

type Viewport = { width: number; height: number };
type Page<V extends Viewport, Task> = {
  getViewport(options: { scale: number }): V;
  render(options: { canvas: HTMLCanvasElement; viewport: V; transform: number[]; pageColors?: { background: string; foreground: string } }): Task;
};

export function renderPdfPage<V extends Viewport, Task>(page: Page<V, Task>, canvas: HTMLCanvasElement, width: number, dark = false) {
  const viewport = page.getViewport({ scale: width / page.getViewport({ scale: 1 }).width });
  const ratio = Math.min(window.devicePixelRatio || 1, 2);
  canvas.width = Math.ceil(viewport.width * ratio);
  canvas.height = Math.ceil(viewport.height * ratio);
  canvas.style.width = viewport.width + 'px';
  canvas.style.height = viewport.height + 'px';
  const task = page.render({ canvas, viewport, transform: [ratio, 0, 0, ratio, 0, 0], pageColors: dark ? { background: '#172129', foreground: '#e2e9ec' } : undefined });
  return { viewport, task };
}
