import { lazy, Suspense, useEffect, useState } from 'react';
import { Download, ExternalLink } from 'lucide-react';
import { availableVariants, pdfFilename, type Resource, type Variant } from '@mpi-informatique/exercices-core';
import { assetUrl, exerciseUrl, routeVariant } from '../lib/urls';
import { VariantTabs } from './VariantTabs';

const PdfViewer = lazy(() => import('./PdfViewer'));

export type PublishedResource = Resource & { pdfs: Partial<Record<Variant, string>> };

export default function DocumentPreview({ resource }: { resource: PublishedResource }) {
  const [loaded, setLoaded] = useState<{ variant: Variant; pdf: Uint8Array<ArrayBuffer> }>();
  const [loadError, setLoadError] = useState('');
  const [options] = useState(() => new URLSearchParams(location.search));
  const variants = availableVariants(resource.type).filter(value => value !== 'corrige' || options.get('cor') !== '0');
  const [variant, setVariant] = useState<Variant>(() => {
    const requested = options.has('vue') ? routeVariant(location.search) : 'presentation';
    return variants.includes(requested) ? requested : variants[0]!;
  });
  const [dark, setDark] = useState(false);
  const [retry, setRetry] = useState(0);
  const pdf = loaded?.variant === variant ? loaded.pdf : undefined;

  useEffect(() => {
    const applyTheme = (theme: string | null) => {
      if (theme === 'dark' || theme === 'light') document.documentElement.dataset.theme = theme === 'dark' ? 'exercices-dark' : 'exercices';
      setDark(document.documentElement.dataset.theme === 'exercices-dark');
    };
    applyTheme(options.get('theme'));
    const observer = new MutationObserver(() => setDark(document.documentElement.dataset.theme === 'exercices-dark'));
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    const parentOrigin = document.referrer ? new URL(document.referrer).origin : undefined;
    const receiveTheme = (event: MessageEvent) => {
      if (event.source === window.parent && event.origin === parentOrigin && event.data?.type === 'exercices:theme') applyTheme(event.data.theme);
    };
    window.addEventListener('message', receiveTheme);
    if (window.parent !== window && parentOrigin) window.parent.postMessage({ type: 'exercices:ready' }, parentOrigin);
    return () => { observer.disconnect(); window.removeEventListener('message', receiveTheme); };
  }, [options]);

  useEffect(() => {
    const controller = new AbortController();
    setLoadError('');
    const path = resource.pdfs[variant];
    if (!path) { setLoadError('Cette version du PDF n’est pas disponible.'); return; }
    fetch(assetUrl(path), { signal: controller.signal }).then(async response => {
      if (!response.ok) throw new Error(`Chargement impossible (${response.status}).`);
      const pdf = new Uint8Array(await response.arrayBuffer());
      if (!controller.signal.aborted) setLoaded({ variant, pdf });
    }).catch(error => { if (!controller.signal.aborted) setLoadError(String(error.message)); });
    return () => controller.abort();
  }, [resource, variant, retry]);

  useEffect(() => {
    const path = resource.pdfs.presentation;
    if (variant === 'presentation' || !path) return;
    const prefetch = document.createElement('link');
    prefetch.rel = 'prefetch';
    prefetch.href = assetUrl(path);
    prefetch.as = 'fetch';
    document.head.append(prefetch);
    return () => prefetch.remove();
  }, [resource, variant]);

  function changeVariant(next: Variant) {
    setVariant(next);
    const url = new URL(location.href);
    url.searchParams.set('vue', next);
    history.replaceState({}, '', url);
  }

  function download() {
    if (!pdf || loadError) return;
    const url = URL.createObjectURL(new Blob([pdf], { type: 'application/pdf' }));
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = pdfFilename(resource.fichier, variant, resource.type);
    anchor.click();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  }

  return <main id="main" className="document-preview" aria-label={resource.titre}>
    {loadError && <div className="document-preview-error" role="alert"><p>{loadError}</p><button className="btn btn-sm" onClick={() => setRetry(value => value + 1)}>Réessayer</button></div>}
    <Suspense fallback={<div className="preview-placeholder">Chargement du lecteur…</div>}><PdfViewer pdf={pdf} pending={!loadError && !pdf} pendingLabel="Chargement du PDF…" dark={dark} onReady={() => {}}
      toolbar={<VariantTabs variant={variant} documentType={resource.type} variants={variants} onChange={changeVariant} />}
      actions={<div>
        <button className="btn btn-ghost btn-sm btn-square" aria-label="Télécharger le PDF" title="Télécharger le PDF" onClick={download} disabled={!pdf || !!loadError}><Download size={17} /></button>
        <a className="btn btn-ghost btn-sm btn-square" href={exerciseUrl(resource.id, variant)} target="_blank" rel="noopener noreferrer" aria-label="Ouvrir dans la banque d’exercices" title="Ouvrir dans la banque d’exercices"><ExternalLink size={17} /></a>
      </div>} /></Suspense>
    <div className="sr-only" role="status">{loadError ? 'Chargement impossible' : pdf ? 'PDF prêt' : 'Chargement du PDF…'}</div>
  </main>;
}
