import { TerminalSquare } from 'lucide-react';
import type { Resource } from '@mpi-informatique/exercices-core';
import { isPrivate } from '../lib/privateBank';

export function TpCodespaceButton({ resource }: { resource?: Pick<Resource, 'id' | 'type'> }) {
  if (resource?.type !== 'tp' || isPrivate(resource)) return null;
  return <a className="btn btn-ghost btn-sm" href="https://codespaces.new/mpi-informatique/tp-environnement?quickstart=1" target="_blank" rel="noopener noreferrer" aria-label="Ouvrir le TP dans Codespaces" title="Ouvrir ou reprendre Codespaces, puis choisir le TP dans le panneau TP MPI"><TerminalSquare size={17} /><span>TP</span></a>;
}
