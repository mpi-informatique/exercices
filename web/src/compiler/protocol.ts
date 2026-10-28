import type { Resource, Variant } from '@mpi-informatique/exercices-core';

export interface CompileRequest {
  id: number;
  resource: Pick<Resource, 'fichier' | 'kind'> & Partial<Pick<Resource, 'type' | 'id'>>;
  source: string;
  variant: Variant;
  bundle?: Record<string, string>;
}

export type CompileResponse =
  | { id: number; type: 'progress'; message: string }
  | { id: number; type: 'success'; pdf: Uint8Array<ArrayBuffer>; diagnostics: string[]; duration: number }
  | { id: number; type: 'error'; message: string };
