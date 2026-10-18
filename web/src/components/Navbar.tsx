import { CodeXml, Command, LockKeyhole, Moon, PanelLeft, Sun } from 'lucide-react';
import { repositoryUrl } from '../lib/github';
import { GitHubIcon } from './GitHubIcon';

interface Props {
  title: string;
  details?: string;
  dark: boolean;
  sidebarOpen: boolean;
  editorOpen: boolean;
  onThemeChange: () => void;
  onSidebarToggle: () => void;
  onEditorToggle: () => void;
  onCommands: () => void;
  onPrivateBank: () => void;
  connected: boolean;
  privateResource: boolean;
}

export function Navbar({ title, details, dark, sidebarOpen, editorOpen, onThemeChange, onSidebarToggle, onEditorToggle, onCommands, onPrivateBank, connected, privateResource }: Props) {
  return <header className="navbar topbar">
    <button className="btn btn-ghost btn-sm btn-square" aria-label={sidebarOpen ? 'Masquer la recherche' : 'Afficher la recherche'} title="Recherche (/)" aria-expanded={sidebarOpen} aria-controls="search-sidebar" onClick={onSidebarToggle}><PanelLeft size={17} /></button>
    <a className="brand" href={import.meta.env.BASE_URL} aria-label="Exercices MPI — accueil" title="Exercices MPI"><span>MPI</span></a>
    <h1 className="document-title" title={details ?? title}>{title}</h1>
    {privateResource && <span className="private-badge">Privé</span>}
    <div className="topbar-actions">
      <button className={`btn btn-ghost btn-sm ${connected ? 'active' : ''}`} aria-label="Exercices privés" title="Connexion GitHub et dépôt privé" onClick={onPrivateBank}><LockKeyhole size={16} /><span className="private-button-label">{connected ? 'Mon dépôt privé' : 'Se connecter'}</span></button>
      <button className={`btn btn-ghost btn-sm btn-square code-toggle ${editorOpen ? 'active' : ''}`} aria-label="Code Typst" title="Afficher / masquer le code Typst" aria-expanded={editorOpen} aria-controls="editor-panel" onClick={onEditorToggle}><CodeXml size={17} /></button>
      <button className="btn btn-ghost btn-sm palette-toggle" aria-label="Palette de commandes" title="Palette de commandes (⌘K / Ctrl+K)" aria-keyshortcuts="Meta+k Control+k" onClick={onCommands}><Command size={16} /><kbd>⌘/Ctrl K</kbd></button>
      <button className="btn btn-ghost btn-sm btn-square theme-toggle" aria-label={dark ? 'Activer le thème clair' : 'Activer le thème sombre'} title={dark ? 'Thème clair' : 'Thème sombre'} onClick={onThemeChange}>
        {dark ? <Sun size={18} /> : <Moon size={18} />}
      </button>
      <a className="btn btn-ghost btn-sm btn-square" aria-label="Dépôt GitHub" title="Dépôt GitHub" href={repositoryUrl} target="_blank" rel="noreferrer"><GitHubIcon size={17} /></a>
    </div>
  </header>;
}
