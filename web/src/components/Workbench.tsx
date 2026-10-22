import { lazy, Suspense, useEffect, useMemo, useRef, useState, type CSSProperties } from 'react';
import { Download, FileCode, RotateCcw, CircleAlert, CircleDot, GitPullRequest, GitCommitHorizontal, X } from 'lucide-react';
import { availableVariants, variantLabels, pdfFilename, type Resource, type Variant } from '@mpi-informatique/exercices-core';
import SearchSidebar from './SearchSidebar';
import { ResizeHandle } from './ResizeHandle';
import { useCompiler } from '../hooks/useCompiler';
import { useSource } from '../hooks/useSource';
import { useCodeFiles } from '../hooks/useCodeFiles';
import { SidebarActions } from './SidebarActions';
import { GitHubIcon } from './GitHubIcon';
import { VariantTabs } from './VariantTabs';
import CommandPalette, { type Command } from './CommandPalette';
import type { SearchFilters } from '../lib/filters';
import { createSearch } from '../lib/search';
import { exerciseUrl, routeId, routeVariant } from '../lib/urls';
import { stored, store } from '../lib/storage';
import { githubEditUrl, githubFileUrl, githubIssueUrl, repositoryUrl } from '../lib/github';
import { authUrl, startContribution } from '../lib/githubAuth';
import { usePrivateBank } from '../hooks/usePrivateBank';
import PrivateBankPanel from './PrivateBankPanel';
import { isPrivate } from '../lib/privateBank';

const TypstEditor = lazy(() => import('./TypstEditor'));
const PdfViewer = lazy(() => import('./PdfViewer'));
interface Props { resources: Resource[]; initialId?: string }

function download(data: BlobPart, name: string, type: string) {
  const url = URL.createObjectURL(new Blob([data], { type }));
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = name;
  anchor.click();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
}

export default function Workbench({ resources: publicResources, initialId }: Props) {
  const library = usePrivateBank();
  const resources = useMemo(() => [...publicResources, ...(library.bank?.resources ?? [])], [publicResources, library.bank]);
  const [privatePanelOpen, setPrivatePanelOpen] = useState(false);
  const [selected, setSelected] = useState(initialId ?? 'residuels-minimisation');
  const selectedRef = useRef(selected);
  selectedRef.current = selected;
  const resource = resources.find(resource => resource.id === selected);
  const privateResource = isPrivate(resource);
  const [query, setQuery] = useState('');
  const [filters, setFilters] = useState<SearchFilters>({});
  const [requestedVariant, setVariant] = useState<Variant>('enonce');
  const variants = availableVariants(resource?.type);
  const variant = variants.includes(requestedVariant) ? requestedVariant : variants[0]!;
  const labels = variantLabels(resource?.type);
  const [dark, setDark] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [editorOpen, setEditorOpen] = useState(true);
  const [openedCode, setOpenedCode] = useState<{ id: string; path: string }>();
  const [paletteOpen, setPaletteOpen] = useState(false);
  const [sidebarWidth, setSidebarWidth] = useState(280);
  const [editorWidth, setEditorWidth] = useState(440);
  const [retry, setRetry] = useState(0);
  const [contributionNotice, setContributionNotice] = useState('');
  const [contributionPending, setContributionPending] = useState(false);
  const app = useRef<HTMLDivElement>(null);
  const focusTarget = useRef<'search' | 'editor' | 'pdf' | undefined>(undefined);
  const search = useMemo(() => createSearch(resources), [resources]);
  const { code, loadError, notice, modified, changeSource, reload, reset, dismissNotice } = useSource(resource, privateResource ? library.bank : undefined);
  const codePath = openedCode && openedCode.id === resource?.id ? openedCode.path : undefined;
  const codeFiles = useCodeFiles(resource?.fichier, code?.source, codePath, privateResource ? library.bank : undefined);
  const editorPath = codePath ?? resource?.fichier;
  const editorSource = codePath ? codeFiles.file?.source : code?.source;
  const editorRepository = privateResource ? `https://github.com/${library.bank!.repository}` : repositoryUrl;
  const editorBranch = privateResource ? library.bank!.branch : 'main';
  const associatedFiles = codePath && !codeFiles.associated.includes(codePath) ? [...codeFiles.associated, codePath] : codeFiles.associated;
  const compilation = useCompiler(resource, code?.source, variant, retry, privateResource ? library.bank?.bundle : undefined);

  useEffect(() => {
    if (isPrivate({ id: selected }) && !library.bank?.resources.some(item => item.id === selected)) {
      setSelected('residuels-minimisation');
      history.replaceState({}, '', exerciseUrl('residuels-minimisation', variant));
    }
  }, [library.bank]);

  useEffect(() => {
    setDark(document.documentElement.dataset.theme === 'exercices-dark');
    const themeObserver = new MutationObserver(() => setDark(document.documentElement.dataset.theme === 'exercices-dark'));
    themeObserver.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    setVariant(routeVariant(location.search));
    setSidebarOpen(window.innerWidth > 900);
    setEditorOpen(window.innerWidth > 1100 && stored('editor-open') !== 'false');
    const side = Number(stored('sidebar-width'));
    const editor = Number(stored('editor-width'));
    if (side >= 240 && side <= 520) setSidebarWidth(side);
    if (editor >= 280 && editor <= 900) setEditorWidth(editor);
    const pop = () => {
      setSelected(routeId(location.pathname, location.hash) ?? 'residuels-minimisation');
      setVariant(routeVariant(location.search));
    };
    window.addEventListener('popstate', pop);
    return () => { themeObserver.disconnect(); window.removeEventListener('popstate', pop); };
  }, []);

  useEffect(() => {
    const keys = (event: KeyboardEvent) => {
      if (event.isComposing || event.defaultPrevented) return;
      if ((event.metaKey || event.ctrlKey) && !event.altKey && event.key.toLowerCase() === 'k') {
        event.preventDefault(); setPaletteOpen(open => !open); return;
      }
      if (paletteOpen) return;
      const target = event.target as HTMLElement;
      if (event.key === '/' && !event.metaKey && !event.ctrlKey && !event.altKey && !target.closest('input, textarea, select, [contenteditable="true"]')) {
        event.preventDefault(); focusPanel('search');
      }
      if (event.key === 'Escape' && !target.closest('.facet-select[open]') && sidebarOpen && window.innerWidth <= 900) closeSidebar();
    };
    // La capture rend la palette accessible même lorsque l'éditeur traite les touches.
    window.addEventListener('keydown', keys, true);
    return () => window.removeEventListener('keydown', keys, true);
  }, [paletteOpen, sidebarOpen]);
  useEffect(() => { focusPending(); }, [sidebarOpen, editorOpen]);
  useEffect(() => {
    if (resource) document.title = `${resource.titre} · Exercices MPI`;
    setContributionNotice('');
  }, [resource]);

  function navigate(resource: Resource, nextVariant: Variant = variant) {
    if (!availableVariants(resource.type).includes(nextVariant)) nextVariant = 'enonce';
    history.pushState({}, '', exerciseUrl(resource.id, nextVariant));
    if (resource.id !== selected) setOpenedCode(undefined);
    setSelected(resource.id); setVariant(nextVariant);
    if (window.innerWidth <= 900) {
      if (app.current?.querySelector('#search-sidebar')?.contains(document.activeElement)) focusPanel('pdf');
      setSidebarOpen(false);
    }
  }
  function toggleTheme() {
    const next = !dark;
    setDark(next); store('theme', next ? 'dark' : 'light');
    document.documentElement.dataset.theme = next ? 'exercices-dark' : 'exercices';
  }
  function toggleEditor() {
    setEditorOpen(!editorOpen); store('editor-open', String(!editorOpen));
    if (editorOpen && app.current?.querySelector('#editor-panel')?.contains(document.activeElement)) focusPanel('pdf');
  }
  function openCode(path: string) {
    setOpenedCode({ id: selected, path });
    focusPanel('editor');
  }
  function showTypst() {
    setOpenedCode(undefined);
    focusPanel('editor');
  }
  function closeSidebar() {
    setSidebarOpen(false);
    app.current?.querySelector<HTMLButtonElement>('[aria-controls="search-panel"]')?.focus();
  }
  function focusPending() {
    const selector = { search: 'input[type="search"]', editor: '.cm-content', pdf: '.pdf-scroll' };
    const target = focusTarget.current && app.current?.querySelector<HTMLElement>(selector[focusTarget.current]);
    if (target) { target.focus(); focusTarget.current = undefined; }
  }
  function focusPanel(panel: 'search' | 'editor' | 'pdf') {
    focusTarget.current = panel;
    if (panel === 'search') setSidebarOpen(true);
    if (panel === 'editor') { setEditorOpen(true); store('editor-open', 'true'); }
    if (panel === 'pdf' && window.innerWidth <= 1100) setEditorOpen(false);
    requestAnimationFrame(focusPending);
  }
  function downloadSource() { if (code && resource) download(code.source, resource.fichier.split('/').at(-1)!, 'text/plain;charset=utf-8'); }
  function downloadEditor() { if (editorSource !== undefined && editorPath) download(editorSource, editorPath.split('/').at(-1)!, 'text/plain;charset=utf-8'); }
  async function copyContribution() {
    if (!code || !modified || privateResource) return;
    try {
      await navigator.clipboard.writeText(code.source);
      setContributionNotice('Brouillon copié : coller dans GitHub, puis créer une branche et une pull request.');
    } catch {
      setContributionNotice('Copie impossible. Télécharger le fichier Typst pour reporter le brouillon dans GitHub, puis créer une branche et une pull request.');
    }
  }
  async function proposeContribution() {
    if (!resource || !code || !modified || contributionPending || privateResource) return;
    setContributionPending(true);
    setContributionNotice('Connexion à GitHub pour préparer votre modification…');
    try {
      await startContribution({ file: resource.fichier, source: code.source, original: code.original, title: resource.titre });
    } catch (error) {
      setContributionNotice(error instanceof Error ? error.message : 'Connexion GitHub impossible. Votre brouillon est conservé.');
      setContributionPending(false);
    }
  }
  async function commitPrivate() {
    if (!resource || !code || !privateResource || !modified || library.commitPending) return;
    const id = resource.id;
    setContributionNotice('Enregistrement sur GitHub…');
    try {
      const sha = await library.commit({ file: resource.fichier, source: code.source, original: code.original, title: resource.titre });
      if (sha && selectedRef.current === id) setContributionNotice(`Commit ${sha.slice(0, 7)} enregistré sur ${library.bank!.branch}.`);
    } catch (error) {
      if (selectedRef.current === id) setContributionNotice(error instanceof Error ? error.message : 'Enregistrement impossible. Votre brouillon est conservé.');
    }
  }
  const canDownloadPdf = !!resource && !!compilation.pdf && !compilation.pending && !compilation.error;
  function downloadPdf() {
    if (!resource || !compilation.pdf || !canDownloadPdf) return;
    const stem = resource.fichier.split('/').at(-1)!.slice(0, -4);
    const suffix = variant === 'corrige' ? '-cor' : '';
    const privateFilename = resource.type === 'cours-presentation'
      ? `${variant === 'presentation' ? 'presentation' : 'cours'}-${stem.replace(/^cours-/, '')}${suffix}.pdf`
      : `${stem}${suffix}.pdf`;
    download(compilation.pdf, privateResource ? privateFilename : pdfFilename(resource.fichier, variant, resource.type), 'application/pdf');
  }
  const commands: Command[] = [
    { id: 'search', label: 'Rechercher un exercice', shortcut: '/', keywords: 'banque filtre', run: () => focusPanel('search') },
    { id: 'editor-focus', label: 'Modifier le code Typst', keywords: 'éditeur source focus', disabled: !code, run: showTypst },
    ...codeFiles.associated.map(path => ({ id: `code:${path}`, label: `Voir le code : ${path.split('/').at(-1)}`, keywords: path, run: () => openCode(path) })),
    { id: 'pdf-focus', label: 'Afficher l’aperçu PDF', keywords: 'document focus', run: () => focusPanel('pdf') },
    { id: 'sidebar', label: sidebarOpen ? 'Masquer la recherche' : 'Afficher la recherche', keywords: 'panneau latéral', run: () => sidebarOpen ? closeSidebar() : focusPanel('search') },
    { id: 'editor', label: editorOpen ? 'Masquer le code Typst' : 'Afficher le code Typst', keywords: 'panneau éditeur source', run: toggleEditor },
    ...variants.map(value => ({ id: value, label: `Voir : ${labels[value]}`, keywords: 'version solution correction cours présentation', disabled: !resource, run: () => { if (resource) navigate(resource, value); focusPanel('pdf'); } })),
    { id: 'pdf-download', label: 'Télécharger le PDF', keywords: 'export document', disabled: !canDownloadPdf, run: downloadPdf },
    { id: 'source-download', label: 'Télécharger le fichier Typst', keywords: 'export source', disabled: !code, run: downloadSource },
    { id: 'theme', label: dark ? 'Activer le thème clair' : 'Activer le thème sombre', keywords: 'apparence dark mode', run: toggleTheme },
    { id: 'filters-reset', label: 'Effacer la recherche et les filtres', keywords: 'réinitialiser', run: () => { setQuery(''); setFilters({}); focusPanel('search'); } },
    { id: 'compile', label: 'Recompiler le document', keywords: 'réessayer compilation', disabled: !code || compilation.pending, run: () => setRetry(n => n + 1) },
    { id: 'source-reset', label: 'Réinitialiser le code Typst', keywords: 'brouillon annuler', disabled: !modified, run: reset },
  ];
  const status = loadError || compilation.message;

  return <div ref={app} className={`workbench ${sidebarOpen ? 'sidebar-open' : ''} ${editorOpen ? 'editor-open' : ''}`} style={{ '--sidebar-width': `${sidebarWidth}px`, '--editor-width': `${editorWidth}px` } as CSSProperties}>
    <div className="app-body">
      {sidebarOpen && <button className="sidebar-backdrop" aria-label="Fermer la recherche" tabIndex={-1} onClick={closeSidebar} />}
      <aside className="search-sidebar" id="search-sidebar" aria-label="Rechercher dans la banque">
        <SidebarActions dark={dark} sidebarOpen={sidebarOpen} editorOpen={editorOpen} onThemeChange={toggleTheme} onSidebarToggle={() => sidebarOpen ? closeSidebar() : focusPanel('search')} onEditorToggle={toggleEditor} onCommands={() => setPaletteOpen(true)} onPrivateBank={() => setPrivatePanelOpen(true)} connected={!!library.account} />
        {sidebarOpen && <SearchSidebar resources={resources} search={search} selected={selected} query={query} filters={filters} onQuery={setQuery} onFilters={setFilters} onSelect={navigate} />}
      </aside>
      {sidebarOpen && <ResizeHandle label="Largeur de la recherche" value={sidebarWidth} min={240} max={520} onChange={value => { setSidebarWidth(value); store('sidebar-width', String(value)); }} />}
      <main className="main-panel" id="main" tabIndex={-1}>
        <h1 className="sr-only">{resource?.titre ?? 'Ressource introuvable'}</h1>
        <div className="document-workspace">
          {editorOpen && <section className="editor-panel" id="editor-panel" aria-label={codePath ? 'Code associé' : 'Éditeur Typst'}>
            <div className="pane-toolbar">
              <span className="source-filename" title={editorPath}><FileCode size={17} />{associatedFiles.length ? <select aria-label="Fichier affiché dans l’éditeur" value={editorPath} onChange={event => event.target.value === resource?.fichier ? showTypst() : openCode(event.target.value)}>
                <option value={resource?.fichier}>{resource?.fichier.split('/').at(-1)}</option>
                {associatedFiles.map(path => <option key={path} value={path}>{path.slice(0, path.lastIndexOf('/')) === resource?.fichier.slice(0, resource.fichier.lastIndexOf('/')) ? path.split('/').at(-1) : path}</option>)}
              </select> : <span>{editorPath?.split('/').at(-1)}</span>}{privateResource && <span className="private-badge">Privé</span>}{!codePath && modified && <span className="modified-dot" role="img" aria-label="Brouillon modifié" title={privateResource ? 'Brouillon privé, conservé dans cet onglet' : 'Brouillon modifié, enregistré localement'} />}</span>
              <div>
                {editorPath && resource && <>
                  <a className="btn btn-ghost btn-sm btn-square" aria-label="Voir le fichier sur GitHub" title="Voir le fichier sur GitHub" href={githubFileUrl(editorPath, editorRepository, editorBranch)} target="_blank" rel="noreferrer"><GitHubIcon size={17} /></a>
                  <a className="btn btn-ghost btn-sm btn-square" aria-label="Signaler un problème sur GitHub" title="Créer une issue pour le fichier affiché" href={githubIssueUrl(editorPath, resource.titre, editorRepository, editorBranch)} target="_blank" rel="noreferrer"><CircleDot size={17} /></a>
                </>}
                {!codePath && privateResource && library.account && <button className="btn btn-ghost btn-sm btn-square" aria-label="Créer un commit sur GitHub" title={`Enregistrer les modifications dans ${library.bank?.repository}, branche ${library.bank?.branch}`} disabled={!modified || library.commitPending || library.busy} onClick={commitPrivate}>{library.commitPending ? <span className="loading loading-spinner loading-xs" /> : <GitCommitHorizontal size={17} />}</button>}
                {!codePath && resource && !privateResource && (authUrl && modified
                  ? <button className="btn btn-ghost btn-sm btn-square" aria-label="Ouvrir une pull request sur GitHub" title="Se connecter à GitHub et proposer le brouillon modifié" disabled={contributionPending} onClick={proposeContribution}>{contributionPending ? <span className="loading loading-spinner loading-xs" /> : <GitPullRequest size={17} />}</button>
                  : <a className="btn btn-ghost btn-sm btn-square" aria-label="Ouvrir une pull request sur GitHub" title={modified ? 'Copier le brouillon et ouvrir GitHub pour proposer une pull request' : 'Modifier le fichier sur GitHub pour proposer une pull request'} href={githubEditUrl(resource.fichier)} target="_blank" rel="noreferrer" onClick={copyContribution}><GitPullRequest size={17} /></a>)}
                <button className="btn btn-ghost btn-sm btn-square" aria-label={codePath ? 'Télécharger le fichier de code' : 'Télécharger le fichier Typst'} title={codePath ? 'Télécharger le fichier de code' : 'Télécharger le fichier Typst'} disabled={editorSource === undefined} onClick={downloadEditor}><Download size={17} /></button>
                {codePath ? <button className="btn btn-ghost btn-sm btn-square" aria-label="Revenir au fichier Typst" title="Revenir au fichier Typst" onClick={showTypst}><X size={17} /></button> : <button className="btn btn-ghost btn-sm btn-square" aria-label="Réinitialiser le code" title="Réinitialiser le code (annulable dans l’éditeur)" disabled={!modified} onClick={reset}><RotateCcw size={17} /></button>}
              </div>
            </div>
            {contributionNotice && <div className="draft-notice" role="status"><span>{contributionNotice}</span><button className="btn btn-ghost btn-xs btn-square" aria-label="Fermer le message GitHub" title="Fermer" onClick={() => setContributionNotice('')}><X size={13} /></button></div>}
            {codePath && <div className="code-readonly">Lecture seule</div>}
            {editorSource !== undefined && editorPath ? <Suspense fallback={<div className="pane-loading">Chargement de l’éditeur…</div>}><TypstEditor key={`${selected}:${editorPath}`} source={editorSource} sourcePath={editorPath} resources={privateResource ? library.bank!.resources : publicResources} availableFiles={codeFiles.available} privateResource={privateResource} onNavigate={navigate} onOpenCode={openCode} readOnly={!!codePath} dark={dark} onChange={codePath ? () => {} : changeSource} onReady={focusPending} /></Suspense> : <div className="pane-loading" role={codeFiles.file?.error ? 'alert' : undefined}>{codePath ? codeFiles.file?.error || 'Chargement du code…' : loadError || 'Chargement de la source…'}{codePath && codeFiles.file?.error && <button className="btn btn-sm" onClick={codeFiles.reload}>Réessayer</button>}</div>}
          </section>}
          {editorOpen && <ResizeHandle label="Largeur de l’éditeur" value={editorWidth} min={280} max={900} onChange={value => { setEditorWidth(value); store('editor-width', String(value)); }} />}
          <section className="preview-panel" aria-label="Document PDF">
            <Suspense fallback={<div className="pane-loading">Chargement de l’aperçu…</div>}><PdfViewer dark={dark} pdf={compilation.pdf} pending={compilation.pending} onReady={focusPending} toolbar={<>
              <VariantTabs documentType={resource?.type} variant={variant} onChange={value => resource && navigate(resource, value)} />
              <span className={`compilation-status ${compilation.error || loadError ? 'has-error' : ''}`} title={status} role="status">{compilation.pending ? <span className="loading loading-spinner loading-xs" /> : compilation.error || loadError ? <CircleAlert size={13} /> : <span className="status-dot" />}<span className="sr-only">{status}</span></span>
            </>} actions={<>
              <button className="btn btn-ghost btn-sm btn-square" aria-label="Télécharger le PDF" title="Télécharger le PDF" disabled={!canDownloadPdf} onClick={downloadPdf}><Download size={17} /></button>
            </>} /></Suspense>
          </section>
        </div>
        {(loadError || compilation.error) && <div className="diagnostic alert alert-error" role="alert"><CircleAlert size={18} /><pre>{loadError || compilation.error}</pre><button className="btn btn-sm" onClick={() => loadError ? reload() : setRetry(n => n + 1)}>Réessayer</button></div>}
        {notice && <div className="draft-notice" role="status">{notice}<button className="btn btn-ghost btn-xs" onClick={dismissNotice}>Fermer</button></div>}
        {!!compilation.warnings?.length && <details className="compile-warnings"><summary>Avertissements Typst ({compilation.warnings.length})</summary><pre>{compilation.warnings.join('\n')}</pre></details>}
      </main>
    </div>
    {paletteOpen && <CommandPalette commands={commands} search={search} onSelect={resource => { navigate(resource); focusPanel('pdf'); }} onClose={() => setPaletteOpen(false)} />}
    {privatePanelOpen && <PrivateBankPanel library={library} onClose={() => setPrivatePanelOpen(false)} />}
  </div>;
}
