import { createTypstCompiler } from '@myriaddreamin/typst.ts/compiler';
import { loadFonts, withAccessModel, withPackageRegistry } from '@myriaddreamin/typst.ts/options.init';
import { MemoryAccessModel } from '@myriaddreamin/typst.ts/fs/memory';
import type { WebAssemblyModuleRef } from '@myriaddreamin/typst.ts/wasm';
import { compilationInputs, sourceId, type Resource, type Variant } from '@mpi-informatique/exercices-core';

interface Assets {
  bundle: Record<string, string>;
  fonts: (string | Uint8Array<ArrayBuffer>)[];
  wasm: WebAssemblyModuleRef;
}

export async function createEngine({ bundle, fonts, wasm }: Assets) {
  const memory = new MemoryAccessModel();
  for (const [path, encoded] of Object.entries(bundle)) {
    memory.insertFile(path, Uint8Array.from(atob(encoded), character => character.charCodeAt(0)), new Date(0));
  }
  const compiler = createTypstCompiler();
  await compiler.init({
    getModule: () => wasm,
    beforeBuild: [
      loadFonts(fonts, { assets: false }),
      withAccessModel(memory),
      withPackageRegistry({
        resolve: spec => {
          const path = `/@memory/packages/${spec.namespace}/${spec.name}/${spec.version}`;
          return memory.readAll(`${path}/typst.toml`) ? path : undefined;
        },
      }),
    ],
  });
  let previousSource: string | undefined;

  return {
    async inspect(file: string, kind: Resource['kind'], documentType?: string): Promise<Resource> {
      const options = {
        mainFilePath: kind === 'exercice' ? '/@memory/workspace/templates/fiche.typ' : `/@memory/workspace/${file}`,
        root: '/@memory/workspace', inputs: { format: 'cours', corrige: 'false', exercice: `/${file}` },
      };
      const meta = await compiler.runWithWorld(options, async world => {
        const result = await world.compile({ diagnostics: 'unix' });
        if (result.hasError) throw new Error(result.diagnostics?.join('\n') || 'Métadonnées Typst illisibles.');
        const exercises = await world.query({ selector: '<exercice-meta>', field: 'value' });
        const documents = kind === 'document' ? await world.query({ selector: '<document-meta>', field: 'value' }) : [];
        return { exercises, documents };
      });
      const exercise = meta.exercises[0];
      const document = meta.documents[0];
      const base = kind === 'exercice' ? exercise : document;
      if (!base || typeof base.titre !== 'string') throw new Error('Métadonnées de la banque absentes.');
      const fields = ['chapitres', 'algorithmes', 'structures', 'langages', 'niveaux'] as const;
      return {
        id: file, fichier: file, kind, titre: base.titre,
        type: kind === 'exercice' ? (base.concours ? 'concours' : 'exercice') : documentType && documentType !== 'document' ? documentType : base.type,
        concours: base.concours ?? null, duree: base.duree ?? null,
        difficulte: meta.exercises.length ? Math.max(...meta.exercises.map((ex: { difficulte: number }) => ex.difficulte)) : null,
        nombreExercices: meta.exercises.length,
        ...Object.fromEntries(fields.map(field => [field, [...new Set<string>(meta.exercises.flatMap((ex: Record<string, string[]>) => ex[field] ?? []))]])) as Pick<Resource, typeof fields[number]>,
      };
    },
    async compile(resource: Pick<Resource, 'fichier' | 'kind'> & Partial<Pick<Resource, 'type' | 'id'>>, source: string, variant: Variant) {
      const path = `/@memory/workspace/${resource.fichier}`;
      const id = sourceId(resource.fichier);
      // Une feuille peut importer l'exercice précédemment édité : restaurer sa source.
      if (previousSource && previousSource !== path) compiler.unmapShadow(previousSource);
      previousSource = path;
      compiler.addSource(path, source);
      const start = performance.now();
      const result = await compiler.runWithWorld({
        mainFilePath: resource.kind === 'exercice' ? '/@memory/workspace/templates/fiche.typ' : path,
        root: '/@memory/workspace',
        inputs: {
          ...compilationInputs(variant, resource.type), exercice: `/${resource.fichier}`,
          'url-document': resource.id === id ? `https://mpi-informatique.github.io/exercices/${encodeURIComponent(id)}/` : '',
        },
      }, world => world.pdf({ diagnostics: 'unix' }));
      if (!result.result) throw new Error(result.diagnostics?.join('\n') || 'La compilation a échoué.');
      return { pdf: new Uint8Array(result.result), diagnostics: result.diagnostics ?? [], duration: Math.round(performance.now() - start) };
    },
  };
}
