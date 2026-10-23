import { cp, mkdir, copyFile } from 'node:fs/promises';

// Chaque extension embarque les mêmes ressources, sans accès réseau à l'exécution.
export async function buildViewer(pdfjsRoot, output = 'dist') {
  await mkdir(`${output}/pdfjs`, { recursive: true });
  for (const file of ['pdf.mjs', 'pdf.worker.mjs']) await copyFile(`${pdfjsRoot}/build/${file}`, `${output}/pdfjs/${file}`);
  for (const dir of ['cmaps', 'standard_fonts', 'wasm']) await cp(`${pdfjsRoot}/${dir}`, `${output}/pdfjs/${dir}`, { recursive: true });
  await copyFile(`${pdfjsRoot}/LICENSE`, `${output}/pdfjs/LICENSE`);
  await cp(new URL('./viewer', import.meta.url), `${output}/viewer`, { recursive: true });
}
