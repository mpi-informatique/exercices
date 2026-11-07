import assert from 'node:assert/strict';
import test from 'node:test';
import { loadPublishedPdf } from '../src/lib/published-pdf.ts';

test('une page ancienne retrouve le PDF courant après une publication', async t => {
  const requests: { url: string; cache?: RequestCache }[] = [];
  t.mock.method(globalThis, 'fetch', async (url: URL, options: RequestInit) => {
    requests.push({ url: url.href, cache: options.cache });
    if (url.pathname.endsWith('old.pdf')) return new Response(null, { status: 404 });
    if (url.pathname.endsWith('catalogue.json')) return Response.json([{ id: 'document', pdfs: { corrige: 'banque/pdf/current.pdf' } }]);
    if (url.pathname.endsWith('current.pdf')) return new Response('%PDF-test');
    throw new Error(`URL inattendue : ${url.href}`);
  });
  const pdf = await loadPublishedPdf({ id: 'document', pdfs: { corrige: 'banque/pdf/old.pdf' } }, 'corrige', new URL('https://example.org/exercices/'), new AbortController().signal);
  assert.equal(new TextDecoder().decode(pdf), '%PDF-test');
  assert.deepEqual(requests, [
    { url: 'https://example.org/exercices/banque/pdf/old.pdf', cache: undefined },
    { url: 'https://example.org/exercices/banque/catalogue.json', cache: 'no-store' },
    { url: 'https://example.org/exercices/banque/pdf/current.pdf', cache: 'no-store' },
  ]);
});

test('un PDF toujours absent reste signalé sans boucle de rechargement', async t => {
  t.mock.method(globalThis, 'fetch', async (url: URL) => url.pathname.endsWith('catalogue.json') ? Response.json([]) : new Response(null, { status: 404 }));
  await assert.rejects(loadPublishedPdf({ id: 'document', pdfs: { corrige: 'absent.pdf' } }, 'corrige', new URL('https://example.org/exercices/'), new AbortController().signal), /Chargement impossible \(404\)/);
});
