import assert from 'node:assert/strict';
import test from 'node:test';
import { bankFile, commitPrivateFile, loadPrivateFiles, privateId, privateRepositories, sourceKind, sourceType } from '../src/lib/privateBank.ts';
import { createSearch } from '../src/lib/search.ts';
import type { Resource } from '../../shared/src/index.ts';

const signal = new AbortController().signal;
const repo = { full_name: 'alice/banque-privee', private: true, default_branch: 'cours/2026' };
const sha = 'a'.repeat(40);
const entry = { type: 'blob', mode: '100644', path: 'chapitres/exercice.typ', sha, size: 100 };

test('les dépôts privés sont paginés et aucune autorisation ne part vers une URL du résultat GitHub', async () => {
  const calls: string[] = [];
  const request: typeof fetch = async (url, init) => {
    calls.push(String(url));
    assert.equal(init?.headers && new Headers(init.headers).get('Authorization'), 'Bearer test-token');
    assert.equal(init?.cache, 'no-store');
    assert.equal(init?.redirect, 'error');
    return Response.json(calls.length === 1 ? Array.from({ length: 100 }, () => repo) : [{ ...repo, private: false }]);
  };
  const repos = await privateRepositories('test-token', signal, request);
  assert.equal(repos.length, 100);
  assert.ok(calls[1].endsWith('page=2'));
});

test('le chargement lit uniquement le dépôt choisi, fige un commit et conserve Unicode et fichiers binaires en mémoire', async () => {
  const source = '#let ex = exercice(meta: (titre: "Exemple", chapitres: (), difficulte: 1))[Énoncé Σ]\n';
  const calls: string[] = [];
  const request: typeof fetch = async (url, init) => {
    const path = new URL(String(url)).pathname;
    assert.equal(init?.method, undefined);
    calls.push(path);
    if (path.endsWith('/commits/cours%2F2026')) return Response.json({ sha: 'revision', commit: { tree: { sha: 'tree' } } });
    if (path.endsWith('/git/trees/tree')) return Response.json({ truncated: false, tree: [entry, { ...entry, path: '.env' }, { ...entry, path: 'web/token.json' }, { ...entry, path: 'image.svg', sha: 'b'.repeat(40) }, { ...entry, path: 'chapitres/corrige.ml', sha: 'c'.repeat(40) }, { ...entry, path: 'symlink.typ', mode: '120000' }] });
    assert.ok(path.startsWith('/repos/alice/banque-privee/git/blobs/'));
    return Response.json({ encoding: 'base64', content: Buffer.from(path.endsWith(sha) ? source : path.endsWith('c'.repeat(40)) ? 'let réponse = 42' : '<svg/>').toString('base64') });
  };
  const bank = await loadPrivateFiles(repo, 'test-token', signal, () => {}, request);
  assert.equal(bank.sources[entry.path], source);
  assert.equal(bank.revision, 'revision');
  assert.equal(bank.branch, repo.default_branch);
  assert.equal(Object.keys(bank.bundle).length, 3);
  assert.equal(Buffer.from(bank.bundle['/@memory/workspace/chapitres/corrige.ml'], 'base64').toString(), 'let réponse = 42');
  assert.equal(bank.drafts.size, 0);
  assert.equal(calls.length, 5);
});

const originalSource = '#let ex = [Énoncé Σ]\n';
const commitBank = { repository: repo.full_name, branch: repo.default_branch, sources: { [entry.path]: originalSource } };
const draft = { file: entry.path, title: 'Énoncé Σ', original: originalSource, source: originalSource + '// modification\n' };

test('le commit privé écrit exactement le brouillon Unicode sur la branche chargée avec le SHA du fichier vérifié', async () => {
  const calls: string[] = [];
  const request: typeof fetch = async (url, init) => {
    calls.push(String(url));
    assert.equal(new Headers(init?.headers).get('Authorization'), 'Bearer test-token');
    assert.equal(init?.redirect, 'error');
    assert.equal(init?.cache, 'no-store');
    if (calls.length === 1) return Response.json({ private: true, permissions: { push: true } });
    if (calls.length === 2) {
      assert.ok(String(url).endsWith('/contents/chapitres/exercice.typ?ref=cours%2F2026'));
      return Response.json({ type: 'file', encoding: 'base64', content: Buffer.from(originalSource).toString('base64'), sha });
    }
    assert.equal(init?.method, 'PUT');
    assert.equal(String(url), 'https://api.github.com/repos/alice/banque-privee/contents/chapitres/exercice.typ');
    const body = JSON.parse(String(init?.body));
    assert.equal(Buffer.from(body.content, 'base64').toString(), draft.source);
    assert.equal(body.sha, sha);
    assert.equal(body.branch, repo.default_branch);
    assert.equal(body.message, 'Modifier Énoncé Σ');
    return Response.json({ commit: { sha } });
  };
  assert.equal(await commitPrivateFile(commitBank, draft, 'test-token', signal, request), sha);
  assert.equal(calls.length, 3);
});

test('aucune écriture privée sans modification, droit d’écriture, dépôt privé ou source distante identique', async () => {
  for (const situation of ['unchanged', 'readonly', 'public', 'changed', 'outside']) {
    let writes = 0;
    const request: typeof fetch = async (url, init) => {
      if (init?.method === 'PUT') writes++;
      return Response.json(String(url).includes('/contents/') ? { type: 'file', encoding: 'base64', sha, content: Buffer.from('nouvelle version distante').toString('base64') } : { private: situation !== 'public', permissions: { push: situation !== 'readonly' } });
    };
    const input = situation === 'unchanged' ? { ...draft, source: originalSource } : situation === 'outside' ? { ...draft, file: '../secret.typ' } : draft;
    await assert.rejects(commitPrivateFile(commitBank, input, 'test-token', signal, request));
    assert.equal(writes, 0, situation);
  }
});

test('un conflit pendant le PUT et une branche protégée conservent une erreur explicite sans nouvelle tentative', async () => {
  for (const status of [409, 403, 422, 401]) {
    let writes = 0;
    const request: typeof fetch = async (url, init) => {
      if (init?.method === 'PUT') { writes++; return new Response(null, { status }); }
      return Response.json(String(url).includes('/contents/') ? { type: 'file', encoding: 'base64', sha, content: Buffer.from(originalSource).toString('base64') } : { private: true, permissions: { push: true } });
    };
    await assert.rejects(commitPrivateFile(commitBank, draft, 'test-token', signal, request), status === 401 ? /expiré/ : /brouillon est conservé/);
    assert.equal(writes, 1);
  }
});

test('un arbre incomplet est refusé, sans présenter une banque partielle', async () => {
  let calls = 0;
  const request: typeof fetch = async () => Response.json(++calls === 1 ? { sha: 'revision', commit: { tree: { sha: 'tree' } } } : { truncated: true, tree: [] });
  await assert.rejects(loadPrivateFiles(repo, 'test-token', signal, () => {}, request), /volumineux/);
  await assert.rejects(loadPrivateFiles({ ...repo, private: false }, 'test-token', signal, () => {}, request), /privé valide/);
});

test('les fichiers non pertinents et chemins hors banque sont exclus ; la découverte ignore commentaires et chaînes', () => {
  for (const file of ['.env', '../secret.typ', 'web/source.typ', 'node_modules/data.json', 'corrections/2026/liste-classe.csv', 'devoirs/.secret/ex.typ', 'build/result.pdf', 'data\\secret.typ']) assert.equal(bankFile(file), false, file);
  assert.equal(bankFile('chapitres/privé/image.png'), true);
  assert.equal(sourceKind('// #let ex = faux\n#let texte = "#let ex = faux"'), undefined);
  assert.equal(sourceKind('/* bloc /* imbriqué */ #let ex = faux */'), undefined);
  assert.equal(sourceKind('#let ex = exercice(meta: (:))'), 'exercice');
  assert.equal(sourceKind('#show: feuille.with(titre: "TD")'), 'document');
  for (const [template, type] of [['cours', 'cours'], ['presentation', 'presentation'], ['cours-et-presentation', 'cours-presentation']]) {
    const source = `#show: ${template}.with(titre: "Cours")`;
    assert.equal(sourceKind(source), 'document');
    assert.equal(sourceType(source), type);
    assert.equal(sourceKind(`// ${source}`), undefined);
    assert.equal(sourceKind('```typst\n' + source + '\n```'), undefined);
  }
});

test('la recherche conserve les doublons public/privé et filtre le tag privé', () => {
  const base: Resource = { id: 'exercice', fichier: entry.path, titre: 'Exercice partagé', kind: 'exercice', type: 'exercice', chapitres: [], algorithmes: [], structures: [], langages: [], niveaux: [], difficulte: 2, duree: null, concours: null, nombreExercices: 1 };
  const privateResource = { ...base, id: privateId(repo.full_name, entry.path) };
  const search = createSearch([base, privateResource]);
  assert.equal(search('partagé', {}).length, 2);
  assert.deepEqual(search('tag:privé', {}), [privateResource]);
  assert.deepEqual(search('', { visibilite: ['public'] }), [base]);
});
