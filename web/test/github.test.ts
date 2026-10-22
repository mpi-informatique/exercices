import assert from 'node:assert/strict';
import test from 'node:test';
import { encodeSource, githubEditUrl, prepareContribution } from '../src/lib/github.ts';

const draft = { file: 'chapitres/maths/exercices/énoncé.typ', original: '# Énoncé\n$x > 0$', source: '# Énoncé corrigé\n$x ≥ 0$\n', title: 'Énoncé' };

function githubMock(push: boolean, original = draft.original, failure?: string) {
  const calls: { path: string; method: string; body: any }[] = [];
  const request: typeof fetch = async (input, init) => {
    const path = new URL(String(input)).pathname;
    const method = init?.method ?? 'GET';
    const body = init?.body ? JSON.parse(String(init.body)) : undefined;
    calls.push({ path, method, body });
    assert.equal(new Headers(init?.headers).get('Authorization'), 'Bearer test-token');
    if (path.endsWith(failure ?? 'never')) return Response.json({}, { status: 403 });
    if (path === '/user') return Response.json({ login: 'contributeur' });
    if (path === '/repos/mpi-informatique/exercices') return Response.json({ permissions: { push } });
    if (path.endsWith('/git/ref/heads/main')) return Response.json({ object: { sha: 'base-commit' } });
    if (path.includes('/contents/')) {
      assert.equal(new URL(String(input)).searchParams.get('ref'), 'base-commit');
      return Response.json({ type: 'file', encoding: 'base64', content: encodeSource(original) });
    }
    if (path.endsWith('/forks')) return Response.json({ owner: { login: 'contributeur' }, fork: true, full_name: 'contributeur/banque-renommee' });
    if (path.endsWith('/git/commits/base-commit')) return Response.json({ tree: { sha: 'base-tree' } });
    if (path.endsWith('/git/blobs')) return Response.json({ sha: 'new-blob' });
    if (path.endsWith('/git/trees')) return Response.json({ sha: 'new-tree' });
    if (path.endsWith('/git/commits')) return Response.json({ sha: 'new-commit' });
    if (path.endsWith('/git/refs')) return Response.json({ ref: body.ref });
    throw new Error(`Requête inattendue : ${path}`);
  };
  return { request, calls };
}

test('le contributeur sans accès en écriture propose exactement son brouillon depuis son fork', async () => {
  const { request, calls } = githubMock(false);
  const url = new URL(await prepareContribution(draft, 'test-token', undefined, request));
  assert.match(url.pathname, /^\/mpi-informatique\/exercices\/compare\/main\.\.\.contributeur:banque-renommee:contribution-/);
  assert.equal(url.searchParams.get('expand'), '1');
  assert.equal(url.searchParams.get('title'), 'Modifier Énoncé');
  const writes = calls.filter(call => call.method === 'POST');
  assert.equal(writes[0]!.path, '/repos/mpi-informatique/exercices/forks');
  assert.ok(writes.slice(1).every(call => call.path.startsWith('/repos/contributeur/banque-renommee/')));
  assert.equal(Buffer.from(writes.find(call => call.path.endsWith('/git/blobs'))!.body.content, 'base64').toString(), draft.source);
  assert.deepEqual(writes.find(call => call.path.endsWith('/git/trees'))!.body, { base_tree: 'base-tree', tree: [{ path: draft.file, mode: '100644', type: 'blob', sha: 'new-blob' }] });
  assert.deepEqual(writes.find(call => call.path.endsWith('/git/commits'))!.body.parents, ['base-commit']);
  assert.equal(writes.at(-1)!.path, '/repos/contributeur/banque-renommee/git/refs');
  assert.equal(writes.at(-1)!.body.sha, 'new-commit');
  assert.ok(!calls.some(call => call.path.endsWith('/pulls')));
});

test('un mainteneur utilise une nouvelle branche du dépôt sans fork ni écriture dans main', async () => {
  const { request, calls } = githubMock(true);
  await prepareContribution({ ...draft, source: '' }, 'test-token', undefined, request);
  assert.ok(!calls.some(call => call.path.endsWith('/forks')));
  const writes = calls.filter(call => call.method === 'POST');
  assert.ok(writes.every(call => call.path.startsWith('/repos/mpi-informatique/exercices/')));
  assert.equal(writes.find(call => call.path.endsWith('/git/blobs'))!.body.content, '');
  assert.match(writes.at(-1)!.body.ref, /^refs\/heads\/contribution-/);
});

test('un fichier modifié sur GitHub est signalé avant toute écriture', async () => {
  const { request, calls } = githubMock(false, 'Source distante plus récente');
  await assert.rejects(prepareContribution(draft, 'test-token', undefined, request), /Le fichier a changé/);
  assert.ok(calls.every(call => call.method === 'GET'));
});

test('une erreur GitHub ne crée pas de branche vide', async () => {
  const { request, calls } = githubMock(true, draft.original, '/git/trees');
  await assert.rejects(prepareContribution(draft, 'test-token', undefined, request), /GitHub refuse/);
  assert.ok(!calls.some(call => call.path.endsWith('/git/refs')));
});

test('les noms de fichiers sont encodés sans devenir des paramètres ou des fragments', () => {
  const url = new URL(githubEditUrl('chapitres/maths/exercices/énoncé #1?.typ'));
  assert.equal(url.search, '');
  assert.equal(url.hash, '');
  assert.equal(decodeURIComponent(url.pathname), '/mpi-informatique/exercices/edit/main/chapitres/maths/exercices/énoncé #1?.typ');
});
