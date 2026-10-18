import { CodeXml, Command, LockKeyhole, Moon, PanelLeft, Sun } from 'lucide-react';
import { repositoryUrl } from '../lib/github';
import { GitHubIcon } from './GitHubIcon';

interface Props {
  dark: boolean;
  sidebarOpen: boolean;
  editorOpen: boolean;
  onThemeChange: () => void;
  onSidebarToggle: () => void;
  onEditorToggle: () => void;
  onCommands: () => void;
  onPrivateBank: () => void;
  connected: boolean;
}

export function SidebarActions({ dark, sidebarOpen, editorOpen, onThemeChange, onSidebarToggle, onEditorToggle, onCommands, onPrivateBank, connected }: Props) {
  return <div className="sidebar-actions" role="group" aria-label="Commandes de l’application">
    <button className="btn btn-ghost btn-sm btn-square" aria-label={sidebarOpen ? 'Masquer la recherche' : 'Afficher la recherche'} title="Recherche (/)" aria-expanded={sidebarOpen} aria-controls="search-panel" onClick={onSidebarToggle}><PanelLeft size={17} /></button>
    <button className={`btn btn-ghost btn-sm btn-square ${connected ? 'active' : ''}`} aria-label="Exercices privés" title={connected ? 'Mon dépôt privé' : 'Connexion GitHub et dépôt privé'} onClick={onPrivateBank}><LockKeyhole size={16} /></button>
    <button className={`btn btn-ghost btn-sm btn-square code-toggle ${editorOpen ? 'active' : ''}`} aria-label="Code Typst" title="Afficher / masquer le code Typst" aria-expanded={editorOpen} aria-controls="editor-panel" onClick={onEditorToggle}><CodeXml size={17} /></button>
    <button className="btn btn-ghost btn-sm btn-square" aria-label="Palette de commandes" title="Palette de commandes (⌘K / Ctrl+K)" aria-keyshortcuts="Meta+k Control+k" onClick={onCommands}><Command size={16} /></button>
    <button className="btn btn-ghost btn-sm btn-square theme-toggle" aria-label={dark ? 'Activer le thème clair' : 'Activer le thème sombre'} title={dark ? 'Thème clair' : 'Thème sombre'} onClick={onThemeChange}>
      {dark ? <Sun size={18} /> : <Moon size={18} />}
    </button>
    <a className="btn btn-ghost btn-sm btn-square" aria-label="Dépôt GitHub" title="Dépôt GitHub" href={repositoryUrl} target="_blank" rel="noreferrer"><GitHubIcon size={17} /></a>
  </div>;
}
