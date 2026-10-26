import assert from 'node:assert/strict';
import { availableVariants } from '../../shared/src/index.ts';
import { engine, resources, source } from './compiler-fixture.ts';

const id = process.argv[2];
const resource = resources.find(resource => resource.id === id);
assert.ok(resource, `Ressource inconnue : ${id}`);
const code = await source(resource);
for (const variant of availableVariants(resource.type)) {
  const result = await engine.compile(resource, code, variant).catch(cause => {
    throw new Error(`Échec de compilation : ${resource.id} / ${variant}`, { cause });
  });
  assert.equal(new TextDecoder().decode(result.pdf.slice(0, 5)), '%PDF-', `${resource.id} / ${variant}`);
  assert.ok(result.pdf.length > 1000, `${resource.id} / ${variant}`);
}
