import { typeLabel, type Resource } from '@mpi-informatique/exercices-core';
import { resourceBadgeLabel } from './labels';

export const bankTitle = 'Banque d’exercices de prépa · MP2I, MPI et MP';
export const bankDescription = 'Exercices, cours, TD, TP et sujets de concours de prépa : informatique et mathématiques en MP2I, MPI et MP. Sources Typst, corrigés et PDF.';

export function resourceDescription(resource: Resource): string {
  const levels = resource.niveaux.length ? ` — ${resource.niveaux.join(', ')}` : '';
  const contest = resource.concours ? ` (${resourceBadgeLabel(resource)})` : '';
  const languages = resource.langages.length ? ` Programmation : ${resource.langages.join(', ')}.` : '';
  return `${typeLabel(resource.type)} « ${resource.titre} »${contest}${levels}.${languages} Consulter et modifier la source Typst, compiler le document en PDF.`;
}
