import assert from 'node:assert/strict';
import test from 'node:test';
import { readFile } from 'node:fs/promises';
import { createEngine } from '../src/compiler/engine.ts';
import { engine, json, manifest, publicPath, resources, source } from './compiler-fixture.ts';

test('une erreur Typst ne bloque pas les compilations suivantes ni les imports', async () => {
  const resource = resources.find(resource => resource.id === 'residuels-minimisation')!;
  await assert.rejects(engine.compile(resource, '#let ex = inconnu', 'enonce'), /unknown variable/);
  const sheet = resources.find(resource => resource.id === 'td-automate')!;
  const result = await engine.compile(sheet, await source(sheet), 'corrige');
  assert.ok(result.pdf.length > 1000);
  await assert.doesNotReject(engine.compile(resource, await source(resource), 'enonce'));
});

test('le modèle Touying compile avec les polices et le thème exportés pour le navigateur', async () => {
  const fichier = 'templates/presentation.typ';
  const code = await readFile(new URL(`banque/${fichier}`, publicPath), 'utf8');
  const result = await engine.compile({ fichier, kind: 'document' }, code, 'enonce');
  assert.equal(new TextDecoder().decode(result.pdf.slice(0, 5)), '%PDF-');
  assert.deepEqual(result.diagnostics, []);
});

test('Typst extrait les métadonnées sans catalogue et isole les fichiers privés de la banque publique', async () => {
  const resource = resources.find(resource => resource.id === 'binomiaux')!;
  const original = await source(resource);
  const privateSource = original.replace('Déterminant de coefficients binomiaux', 'Exercice privé Σ');
  const bundle = await json('banque/bundle.json');
  const privateEngine = await createEngine({
    bundle: {
      ...bundle,
      '/@memory/workspace/load.typ': Buffer.from('#import "@mpi-informatique/exercices:0.1.0": *').toString('base64'),
      [`/@memory/workspace/${resource.fichier}`]: Buffer.from(privateSource).toString('base64'),
    },
    fonts: await Promise.all(manifest.fonts.map(async (font: string) => new Uint8Array(await readFile(new URL(`fonts/${font}`, publicPath))))),
    wasm: new Uint8Array(await readFile(new URL('typst/compiler.wasm', publicPath))),
  });
  const metadata = await privateEngine.inspect(resource.fichier, 'exercice');
  assert.equal(metadata.titre, 'Exercice privé Σ');
  assert.deepEqual(metadata.chapitres, resource.chapitres);
  assert.equal(metadata.nombreExercices, 1);
  const pdf = await privateEngine.compile(resource, privateSource, 'corrige');
  assert.ok(pdf.pdf.length > 1000);
  assert.equal((await engine.inspect(resource.fichier, 'exercice')).titre, resource.titre);
  const sheet = resources.find(resource => resource.id === 'td-automate')!;
  const document = await engine.inspect(sheet.fichier, 'document');
  assert.equal(document.titre, sheet.titre);
  assert.equal(document.nombreExercices, sheet.nombreExercices);
});


test('les trois variantes des cours respectent leurs paramètres et produisent des PDF distincts', async () => {
  const resource = resources.find(resource => resource.id === 'cours-kleene')!;
  assert.equal(resource.type, 'cours-presentation');
  const code = await source(resource);
  const normal = '#assert(sys.inputs.at("corrige") == "false")\n' + code;
  const course = await engine.compile(resource, normal, 'enonce');
  const corrected = await engine.compile(resource, '#assert(sys.inputs.at("corrige") == "true")\n' + code, 'corrige');
  const slides = await engine.compile(resource, normal, 'presentation');
  assert.notDeepEqual(course.pdf, corrected.pdf);
  assert.notDeepEqual(course.pdf, slides.pdf);
  assert.notDeepEqual(corrected.pdf, slides.pdf);
  const metadata = await engine.inspect(resource.fichier, 'document', resource.type);
  assert.equal(metadata.titre, resource.titre);
  assert.equal(metadata.type, 'cours-presentation');
});

test('les documents à un seul format exposent leurs métadonnées', async () => {
  for (const type of ['cours', 'presentation']) {
    const metadata = await engine.inspect(`templates/${type}.typ`, 'document');
    assert.equal(metadata.type, type);
    assert.ok(metadata.titre);
  }
});

test('le titre compilé pointe vers la page publique de la ressource', async () => {
  const resource = resources.find(resource => resource.id === 'cours-kleene')!;
  const url = 'https://mpi-informatique.github.io/exercices/cours-kleene/';
  const code = `#import "/load.typ": cours-et-presentation
#show: cours-et-presentation.with(titre: "Titre lié")
Contenu.
#context {
  assert(sys.inputs.at("url-document") == "${url}")
  assert(query(link).any(it => it.dest == "${url}"))
}`;
  for (const variant of ['enonce', 'corrige', 'presentation'] as const) {
    await assert.doesNotReject(engine.compile(resource, code, variant));
  }
  const sansLien = `#import "/load.typ": cours
#show: cours.with(titre: "Document local")
Contenu.
#context { assert(sys.inputs.at("url-document") == "") }`;
  await assert.doesNotReject(engine.compile({ ...resource, id: 'private:depot:cours-kleene' }, sansLien, 'enonce'));
  await assert.doesNotReject(engine.compile({ fichier: 'templates/cours.typ', kind: 'document' }, sansLien, 'enonce'));
});
