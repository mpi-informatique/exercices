import { execFile } from 'node:child_process';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import { fileURLToPath } from 'node:url';
import { promisify } from 'node:util';
import type { Resource } from '../../shared/src/index.ts';

const compile = promisify(execFile);
const runner = fileURLToPath(new URL('./compile-resource.ts', import.meta.url));
const resources: Resource[] = JSON.parse(await readFile(new URL('../src/generated/catalogue.json', import.meta.url), 'utf8'));

// Libérer l'instance WASM entre les ressources, y compris ses caches globaux.
test('toute la banque compile avec le moteur WASM du navigateur dans ses formats disponibles', async t => {
  for (const resource of resources) {
    await t.test(resource.id, () => compile(process.execPath, ['--experimental-strip-types', runner, resource.id]));
  }
});
