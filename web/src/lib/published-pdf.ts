import type { Variant } from '@mpi-informatique/exercices-core';

type PublishedPdf = { id: string; pdfs: Partial<Record<Variant, string>> };

export async function loadPublishedPdf(resource: PublishedPdf, variant: Variant, baseUrl: URL, signal: AbortSignal): Promise<Uint8Array<ArrayBuffer>> {
  const path = resource.pdfs[variant];
  if (!path) throw new Error('Cette version du PDF n’est pas disponible.');
  let response = await fetch(new URL(path, baseUrl), { signal });
  // Une page ouverte avant une publication peut encore référencer un ancien nom de PDF.
  if (response.status === 404) {
    const catalogue = await fetch(new URL('banque/catalogue.json', baseUrl), { signal, cache: 'no-store' });
    if (!catalogue.ok) throw new Error(`Chargement impossible (${catalogue.status}).`);
    const entries: PublishedPdf[] = await catalogue.json();
    const current = entries.find(entry => entry.id === resource.id)?.pdfs[variant];
    if (current) response = await fetch(new URL(current, baseUrl), { signal, cache: 'no-store' });
  }
  if (!response.ok) throw new Error(`Chargement impossible (${response.status}).`);
  return new Uint8Array(await response.arrayBuffer());
}
