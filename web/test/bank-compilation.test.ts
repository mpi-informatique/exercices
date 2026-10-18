import assert from 'node:assert/strict';
import test from 'node:test';
import { availableVariants } from '../../shared/src/index.ts';
import { engine, resources, source } from './compiler-fixture.ts';

// Un processus distinct libère la mémoire WASM après la compilation exhaustive de la banque.
test('toute la banque compile avec le moteur WASM du navigateur dans ses formats disponibles', async () => {
  for (const resource of resources) {
    const code = await source(resource);
    for (const variant of availableVariants(resource.type)) {
      const result = await engine.compile(resource, code, variant);
      assert.equal(new TextDecoder().decode(result.pdf.slice(0, 5)), '%PDF-', `${resource.id} / ${variant}`);
      assert.ok(result.pdf.length > 1000, `${resource.id} / ${variant}`);
    }
  }
});
