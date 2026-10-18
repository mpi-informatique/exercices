import { readFile } from 'node:fs/promises';
import { createEngine } from '../src/compiler/engine.ts';
import type { Resource } from '../../shared/src/index.ts';

export const publicPath = new URL('../public/', import.meta.url);
export const json = async (path: string) => JSON.parse(await readFile(new URL(path, publicPath), 'utf8'));
export const resources: Resource[] = JSON.parse(await readFile(new URL('../src/generated/catalogue.json', import.meta.url), 'utf8'));
export const manifest = await json('banque/manifest.json');
export const engine = await createEngine({
  bundle: await json('banque/bundle.json'),
  fonts: await Promise.all(manifest.fonts.map(async (font: string) => new Uint8Array(await readFile(new URL(`fonts/${font}`, publicPath))))),
  wasm: new Uint8Array(await readFile(new URL('typst/compiler.wasm', publicPath))),
});
export const source = (resource: Resource) => readFile(new URL(`banque/${resource.fichier}`, publicPath), 'utf8');
