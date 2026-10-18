export interface Exercise {
  titre: string; fichier: string; chapitres: string[]; algorithmes: string[];
  structures: string[]; langages: string[]; niveaux: string[]; difficulte: number;
  duree: [number, number] | null;
  concours: { nom?: string; annee?: number; filiere?: string; oral?: boolean } | null;
}
export type Variant = 'enonce' | 'corrige' | 'presentation';
export const facets = ['chapitres', 'algorithmes', 'structures', 'langages', 'niveaux', 'concours'] as const;
export type Facet = typeof facets[number];
export type Filters = Partial<Record<Facet, string>> & { difficulteMax?: number; type?: string };
export const labels: Record<Facet, string> = { chapitres: 'Chapitre', algorithmes: 'Algorithme', structures: 'Structure', langages: 'Langage', niveaux: 'Niveau', concours: 'Concours' };

export function safeSource(file: string): string {
  // Garder des chemins relatifs simples, communs à la banque et aux scripts Python.
  if (!/^(?:[\p{L}\p{N}_-]+\/)*[\p{L}\p{N}_-]+\.typ$/u.test(file)) {
    throw new Error(`Chemin de source non pris en charge : ${file}`);
  }
  return file;
}

export function availableVariants(documentType?: string): Variant[] {
  if (documentType === 'cours-presentation') return ['enonce', 'corrige', 'presentation'];
  return documentType === 'presentation' ? ['enonce'] : ['enonce', 'corrige'];
}

export function outputVariant(variant: Variant, documentType?: string): string {
  if (documentType === 'cours-presentation') return variant === 'presentation' ? 'presentation' : variant === 'corrige' ? 'corrige' : 'cours';
  return documentType === 'cours' && variant === 'enonce' ? 'cours' : documentType === 'presentation' ? 'presentation' : variant;
}

export function variantLabels(documentType?: string): Record<Variant, string> {
  if (documentType === 'cours-presentation') return { enonce: 'Cours', corrige: 'Cours corrigé', presentation: 'Présentation' };
  if (documentType === 'cours') return { enonce: 'Cours', corrige: 'Cours corrigé', presentation: '' };
  if (documentType === 'presentation') return { enonce: 'Présentation', corrige: '', presentation: '' };
  return { enonce: 'Énoncé', corrige: 'Corrigé', presentation: '' };
}

export function compilationInputs(variant: Variant, documentType?: string): Record<string, string> {
  return {
    ...(documentType === 'cours-presentation' ? { format: variant === 'presentation' ? 'presentation' : 'cours' } : {}),
    corrige: String(variant === 'corrige'),
  };
}

export function pdfFilename(source: string, variant: Variant, documentType?: string): string {
  safeSource(source);
  if (documentType === 'cours-presentation') {
    const prefix = variant === 'presentation' ? 'presentation' : 'cours';
    return `${prefix}-${sourceId(source).replace(/^cours-/, '')}${variant === 'corrige' ? '-cor' : ''}.pdf`;
  }
  return `${sourceId(source)}${variant === 'corrige' ? '-cor' : ''}.pdf`;
}


export function normalize(text: string): string {
  return text.normalize('NFD').replace(/\p{M}/gu, '').toLocaleLowerCase('fr').replace(/[’']/g, ' ');
}

export function parseCatalogue(text: string): Exercise[] {
  const data: unknown = JSON.parse(text);
  if (!Array.isArray(data)) throw new Error('Le catalogue doit être un tableau JSON.');
  const identifiers = new Set<string>();
  return data.map((item: unknown) => {
    if (!item || typeof item !== 'object') throw new Error('Entrée de catalogue invalide.');
    const ex = item as Exercise;
    if (typeof ex.titre !== 'string' || !ex.titre || typeof ex.fichier !== 'string') throw new Error('Titre ou fichier manquant.');
    safeSource(ex.fichier);
    const id = sourceId(ex.fichier);
    if (identifiers.has(id)) throw new Error(`Identifiant dupliqué : ${id}`);
    identifiers.add(id);
    for (const field of ['chapitres', 'algorithmes', 'structures', 'langages', 'niveaux'] as const) {
      if (!Array.isArray(ex[field]) || !ex[field].every(value => typeof value === 'string')) throw new Error(`Champ ${field} invalide : ${id}`);
    }
    if (!Number.isInteger(ex.difficulte) || ex.difficulte < 1 || ex.difficulte > 5) throw new Error(`Difficulté invalide : ${id}`);
    if (ex.duree !== null && (!Array.isArray(ex.duree) || ex.duree.length !== 2 || !ex.duree.every(Number.isInteger) || ex.duree[0] < 0 || ex.duree[1] < 0 || ex.duree[1] >= 60 || ex.duree[0] + ex.duree[1] === 0)) throw new Error(`Durée invalide : ${id}`);
    if (ex.concours !== null && (typeof ex.concours !== 'object' || Array.isArray(ex.concours))) throw new Error(`Concours invalide : ${id}`);
    if (ex.concours) {
      for (const key of ['nom', 'filiere'] as const) if (ex.concours[key] !== undefined && typeof ex.concours[key] !== 'string') throw new Error(`Concours invalide : ${id}`);
      if (ex.concours.annee !== undefined && !Number.isInteger(ex.concours.annee)) throw new Error(`Année invalide : ${id}`);
    }
    return ex;
  });
}

export function matches(ex: Exercise, query: string, filters: Filters): boolean {
  const haystack = normalize([ex.titre, ex.fichier, ...ex.chapitres, ...ex.algorithmes, ...ex.structures, ...ex.langages, ...ex.niveaux, ...Object.values(ex.concours ?? {})].join(' '));
  return normalize(query).split(/\s+/).filter(Boolean).every(word => haystack.includes(word))
    && facets.every(key => !filters[key] || (key === 'concours' ? ex.concours?.nom === filters[key] : ex[key].includes(filters[key]!)))
    && (filters.difficulteMax === undefined || ex.difficulte <= filters.difficulteMax);
}

export function duration(ex: Pick<Exercise, 'duree'>): string {
  if (!ex.duree) return '';
  const [h, m] = ex.duree;
  return [h ? `${h} h` : '', m ? `${m} min` : ''].filter(Boolean).join(' ');
}


export function sourceId(source: string): string {
  return source.slice(source.lastIndexOf('/') + 1, -4);
}

export const typeLabels: Record<string, string> = { exercice: 'Exercice', td: 'TD', devoir: 'Devoir', concours: 'Concours', colle: 'Colle', copie: 'Copie', cours: 'Cours', tp: 'TP', algorithme: 'Algorithme', poly: 'Polycopié', presentation: 'Présentation', 'cours-presentation': 'Cours' };
export const typeLabel = (type: string): string => typeLabels[type] ?? type;

export interface Resource extends Omit<Exercise, 'difficulte'> {
  id: string;
  kind: 'exercice' | 'document';
  type: string;
  difficulte: number | null;
  nombreExercices: number;
}
