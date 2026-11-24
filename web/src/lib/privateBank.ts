import { sourceType, type Resource } from '@mpi-informatique/exercices-core';
export { sourceType };
import { encodeSource, type Contribution } from './github.ts';
import { isCodeFile } from './source-links.ts';

export interface PrivateRepository { full_name: string; default_branch: string; private: boolean }
export interface PrivateBank {
  repository: string;
  revision: string;
  branch: string;
  bundle: Record<string, string>;
  sources: Record<string, string>;
  resources: Resource[];
  drafts: Map<string, string>;
  warnings: string[];
}
export const isPrivate = (resource: Pick<Resource, 'id'> | undefined): boolean => resource?.id.startsWith('private:') ?? false;
export const privateId = (repository: string, file: string): string => `private:${repository}:${file}`;
export const decodeBlob = (content: string): string => new TextDecoder().decode(Uint8Array.from(atob(content.replace(/\s/g, '')), value => value.charCodeAt(0)));

/** Toutes les requêtes privées restent entre le navigateur et l'API GitHub. */
export async function githubRead(path: string, token: string, signal: AbortSignal, request: typeof fetch = fetch): Promise<any> {
  const response = await request(`https://api.github.com${path}`, {
    headers: { Accept: 'application/vnd.github+json', Authorization: `Bearer ${token}`, 'X-GitHub-Api-Version': '2022-11-28' },
    signal: AbortSignal.any([signal, AbortSignal.timeout(30_000)]), cache: 'no-store', redirect: 'error', referrerPolicy: 'no-referrer',
  });
  if (!response.ok) throw new Error(response.status === 401 ? 'La connexion GitHub a expiré. Se reconnecter.' : response.status === 403 ? 'GitHub refuse l’accès : vérifier les droits du compte et l’autorisation de l’organisation, ou réessayer après la limite de requêtes.' : response.status === 404 ? 'Dépôt inaccessible ou fichier introuvable. Vérifier l’autorisation GitHub.' : `Lecture GitHub impossible (${response.status}).`);
  return response.json();
}

export async function privateRepositories(token: string, signal: AbortSignal, request: typeof fetch = fetch): Promise<PrivateRepository[]> {
  const repositories: PrivateRepository[] = [];
  for (let page = 1; ; page++) {
    const entries = await githubRead(`/user/repos?visibility=private&sort=full_name&per_page=100&page=${page}`, token, signal, request);
    if (!Array.isArray(entries)) throw new Error('Liste des dépôts GitHub invalide.');
    repositories.push(...entries.filter(repo => repo.private === true));
    if (entries.length < 100) break;
  }
  return repositories;
}

const ignored = new Set(['node_modules', 'web', 'worker', 'shared', 'build', 'dist', 'tests', 'scripts', 'docs', 'tmp', 'corrections']);
export function bankFile(path: string): boolean {
  return !path.split('/').some(part => !part || part === '..' || part.startsWith('.') || ignored.has(part))
    && !path.includes('\\') && (/\.(typ|json|csv|svg|png|jpe?g|gif|webp|toml|ya?ml|txt|bib)$/i.test(path) || isCodeFile(path));
}

export function sourceKind(source: string): 'exercice' | 'document' | undefined {
  const type = sourceType(source);
  return type === undefined ? undefined : type === 'exercice' ? 'exercice' : 'document';
}

export async function loadPrivateFiles(repository: PrivateRepository, token: string, signal: AbortSignal, status: (text: string) => void, request: typeof fetch = fetch): Promise<Omit<PrivateBank, 'resources' | 'warnings'>> {
  if (!/^[\w.-]+\/[\w.-]+$/.test(repository.full_name) || repository.private !== true) throw new Error('Choisir un dépôt privé valide.');
  const prefix = `/repos/${repository.full_name}`;
  // Fixer un commit pour que toutes les dépendances proviennent du même état du dépôt.
  const commit = await githubRead(`${prefix}/commits/${encodeURIComponent(repository.default_branch)}`, token, signal, request);
  const tree = await githubRead(`${prefix}/git/trees/${commit.commit.tree.sha}?recursive=1`, token, signal, request);
  if (tree.truncated) throw new Error('Le dépôt est trop volumineux pour être chargé intégralement. Utiliser un dépôt dédié à la banque.');
  const files = tree.tree.filter((entry: { type: string; path: string; mode: string }) => entry.type === 'blob' && entry.mode !== '120000' && bankFile(entry.path));
  if (files.reduce((size: number, file: { size: number }) => size + file.size, 0) > 50 * 1024 * 1024) throw new Error('Les sources et ressources dépassent 50 Mo. Utiliser un dépôt dédié à la banque.');
  const bundle: Record<string, string> = Object.create(null);
  const sources: Record<string, string> = Object.create(null);
  let next = 0;
  let completed = 0;
  await Promise.all(Array.from({ length: Math.min(6, files.length) }, async () => {
    while (next < files.length) {
      signal.throwIfAborted();
      const file = files[next++];
      if (!/^[a-f\d]{40,64}$/i.test(file.sha)) throw new Error('Identifiant de fichier GitHub invalide.');
      const blob = await githubRead(`${prefix}/git/blobs/${file.sha}`, token, signal, request);
      if (blob.encoding !== 'base64' || typeof blob.content !== 'string') throw new Error('Format de fichier GitHub non pris en charge.');
      bundle[`/@memory/workspace/${file.path}`] = blob.content.replace(/\s/g, '');
      if (file.path.endsWith('.typ')) sources[file.path] = decodeBlob(blob.content);
      status(`Chargement du dépôt privé… ${++completed}/${files.length} fichiers`);
    }
  }));
  return { repository: repository.full_name, branch: repository.default_branch, revision: commit.sha, bundle, sources, drafts: new Map() };
}

/** Modifier seulement le fichier affiché, sans écraser une version distante plus récente. */
export async function commitPrivateFile(bank: Pick<PrivateBank, 'repository' | 'branch' | 'sources'>, draft: Contribution, token: string, signal: AbortSignal, request: typeof fetch = fetch): Promise<string> {
  if (!/^[\w.-]+\/[\w.-]+$/.test(bank.repository) || !bank.branch || !bankFile(draft.file) || !draft.file.endsWith('.typ') || bank.sources[draft.file] !== draft.original) throw new Error('Le fichier ne correspond pas à la banque privée chargée.');
  if (draft.source === draft.original) throw new Error('Modifier le fichier avant de créer un commit.');
  const prefix = `/repos/${bank.repository}`;
  const repository = await githubRead(prefix, token, signal, request);
  if (repository.private !== true) throw new Error('Le dépôt n’est plus privé. Aucun commit créé.');
  if (!repository.permissions?.push) throw new Error('Votre compte n’a pas le droit d’écrire dans ce dépôt privé.');
  const file = draft.file.split('/').map(encodeURIComponent).join('/');
  const original = await githubRead(`${prefix}/contents/${file}?ref=${encodeURIComponent(bank.branch)}`, token, signal, request);
  if (original.type !== 'file' || original.encoding !== 'base64' || typeof original.content !== 'string' || !/^[a-f\d]{40,64}$/i.test(original.sha) || decodeBlob(original.content) !== draft.original) throw new Error('Le fichier a changé sur GitHub. Votre brouillon est conservé : télécharger une copie puis recharger le dépôt pour comparer les versions.');
  const response = await request(`https://api.github.com${prefix}/contents/${file}`, {
    method: 'PUT',
    headers: { Accept: 'application/vnd.github+json', Authorization: `Bearer ${token}`, 'X-GitHub-Api-Version': '2022-11-28', 'Content-Type': 'application/json' },
    body: JSON.stringify({ message: `Modifier ${draft.title}`, content: encodeSource(draft.source), sha: original.sha, branch: bank.branch }),
    signal: AbortSignal.any([signal, AbortSignal.timeout(30_000)]), cache: 'no-store', redirect: 'error', referrerPolicy: 'no-referrer',
  });
  if (!response.ok) throw new Error(response.status === 409 ? 'Le fichier ou la branche a changé pendant l’enregistrement. Votre brouillon est conservé : recharger le dépôt pour comparer les versions.' : response.status === 401 ? 'La connexion GitHub a expiré. Se reconnecter.' : [403, 422].includes(response.status) ? 'GitHub refuse le commit. Vérifier les droits d’écriture et les règles de protection de la branche. Votre brouillon est conservé.' : `Enregistrement GitHub impossible (${response.status}). Votre brouillon est conservé.`);
  const result = await response.json();
  if (!/^[a-f\d]{40,64}$/i.test(result.commit?.sha)) throw new Error('Réponse GitHub inattendue. Vérifier le dépôt avant de recommencer.');
  return result.commit.sha;
}
