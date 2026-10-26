import { execFile } from 'node:child_process';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import { fileURLToPath } from 'node:url';
import { promisify } from 'node:util';
import type { Resource } from '../../shared/src/index.ts';

const compile = promisify(execFile);
const runner = fileURLToPath(new URL('./compile-resource.ts', import.meta.url));
const resources: Resource[] = JSON.parse(await readFile(new URL('../src/generated/catalogue.json', import.meta.url), 'utf8'));
const files = process.env.CI_RESOURCES ? new Set<string>(JSON.parse(process.env.CI_RESOURCES)) : null;
const selected = !files || process.env.CI_FULL_WASM === 'true' ? resources : resources.filter(resource => files.has(resource.fichier));

// Libérer l'instance WASM entre les ressources, y compris ses caches globaux.
test('les ressources concernées compilent avec le moteur WASM dans leurs formats disponibles', { skip: selected.length === 0 && 'Aucune ressource affectée.' }, async t => {
  for (const resource of selected) {
    await t.test(resource.id, () => compile(process.execPath, ['--experimental-strip-types', runner, resource.id]));
  }
});
