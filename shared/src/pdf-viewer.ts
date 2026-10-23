import type { Variant } from './index';
export const escapeHtml = (text: string) => text.replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]!);

// HTML et protocole communs aux aperçus Typst et aux TP téléchargés.
export function pdfViewerHtml(options: {
  nonce: string; channel: string; cspSource: string; pdfjs: string;
  uri: (file: string) => string; variants: Variant[]; labels: Record<Variant, string>;
  variant: Variant; scrollbarStyle?: string; hiddenVariants?: Variant[];
}): string {
  const { nonce, channel, pdfjs, uri, variants, labels, variant, scrollbarStyle = '', hiddenVariants = [] } = options;
  const webview = { cspSource: options.cspSource };
  const escape = escapeHtml;
  return `<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
      <meta http-equiv="Content-Security-Policy" content="default-src 'none'; script-src 'nonce-${nonce}' ${webview.cspSource} 'wasm-unsafe-eval'; style-src ${webview.cspSource} 'unsafe-inline'; font-src ${webview.cspSource} data: blob:; worker-src ${webview.cspSource} blob:; connect-src ${webview.cspSource}; img-src data: blob: ${webview.cspSource}; frame-src http://127.0.0.1:* https:;">
      <link rel="stylesheet" href="${uri('viewer.css')}"><style>${scrollbarStyle}</style></head><body data-channel="${channel}" data-pdfjs="${escape(pdfjs)}/">
      <nav aria-label="Outils de l'aperçu">${variants.map(value => `<button id="${value}" data-variant${hiddenVariants.includes(value) ? ' hidden' : ''} aria-pressed="${value === variant}">${escape(labels[value])}</button>`).join('')}
      <span class="spacer" aria-hidden="true"></span>
      <button id="code" title="Ouvrir les codes associés" aria-label="Ouvrir les codes associés" hidden><svg viewBox="0 0 24 24"><path d="m8 7-5 5 5 5m8-10 5 5-5 5m-3-13-2 16"/></svg></button>
      <div id="page-progress" role="group" aria-label="Pagination">
      <button id="previous-page" title="Page précédente (←)" aria-label="Page précédente" disabled>‹</button>
      <input id="page-number" type="number" min="1" step="1" aria-label="Page actuelle" title="Choisir une page et valider avec Entrée" disabled>
      <span aria-hidden="true">/</span><span id="page-total" aria-label="Nombre total de pages">—</span>
      <button id="next-page" title="Page suivante (→)" aria-label="Page suivante" disabled>›</button></div>
      <button id="jumps" title="Sauts source ↔ aperçu" aria-label="Sauts source ↔ aperçu" aria-pressed="true"><svg viewBox="0 0 24 24"><path d="M4 8h16m-4-4 4 4-4 4M20 16H4m4-4-4 4 4 4"/></svg></button>
      <button id="theme" title="Mode sombre" aria-label="Mode sombre" aria-pressed="false"><svg viewBox="0 0 24 24"><path d="M20 14A8 8 0 0 1 10 4a8 8 0 1 0 10 10Z"/></svg></button>
      <button id="fullscreen" title="Agrandir l'aperçu" aria-label="Agrandir l'aperçu"><svg viewBox="0 0 24 24"><path d="M8 3H3v5m13-5h5v5M8 21H3v-5m18 0v5h-5"/></svg></button>
      <button id="restart" title="Redémarrer l'aperçu" aria-label="Redémarrer l'aperçu"><svg viewBox="0 0 24 24"><path d="M20 8a9 9 0 1 0 1 8M20 2v6h-6"/></svg></button>
      <button id="save" title="Exporter le PDF…" aria-label="Exporter le PDF"><svg width="16" height="16" viewBox="0 0 21 21" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M3 3h12l3 3v12H3zM6 3v6h8V3M6 18v-6h9v6"/></svg></button></nav>
      <p id="compile-error" role="alert" hidden></p><p id="status" role="status">Chargement…</p><main id="viewers"></main>
      <script nonce="${nonce}" src="${uri('viewer.mjs')}" type="module"></script></body></html>`;
}
