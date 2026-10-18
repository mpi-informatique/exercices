export const repositoryUrl = 'https://github.com/mpi-informatique/exercices';

export const githubEditUrl = (file: string): string => `${repositoryUrl}/edit/main/${file.split('/').map(encodeURIComponent).join('/')}`;

export const githubFileUrl = (file: string, repository = repositoryUrl, branch = 'main'): string => `${repository}/blob/${encodeURIComponent(branch)}/${file.split('/').map(encodeURIComponent).join('/')}`;

export function githubIssueUrl(file: string, title: string, repository = repositoryUrl, branch = 'main'): string {
  const url = new URL(`${repository}/issues/new`);
  url.searchParams.set('title', `Signaler un problème : ${title}`);
  url.searchParams.set('body', `Fichier concerné : ${githubFileUrl(file, repository, branch)}\n\nDescription du problème :\n`);
  return url.href;
}

export interface Contribution { file: string; source: string; original: string; title: string }

export function encodeSource(source: string): string {
  return btoa(Array.from(new TextEncoder().encode(source), byte => String.fromCharCode(byte)).join(''));
}

function decodeSource(source: string): string {
  return new TextDecoder().decode(Uint8Array.from(atob(source.replace(/\s/g, '')), character => character.charCodeAt(0)));
}

class GitHubError extends Error {
  status: number;
  constructor(status: number) {
    super(status === 401 ? 'La connexion GitHub a expiré. Recommencer la proposition.' : status === 403 || status === 429 ? 'GitHub refuse cette opération : vérifier les autorisations ou réessayer plus tard.' : `GitHub ne peut pas préparer la proposition (${status}). Réessayer depuis le brouillon.`);
    this.status = status;
  }
}

/** Préparer un commit sur une nouvelle branche, puis laisser l'utilisateur soumettre la PR. */
export async function prepareContribution(draft: Contribution, token: string, status: (message: string) => void = () => {}, request: typeof fetch = fetch): Promise<string> {
  const upstream = 'mpi-informatique/exercices';
  const file = draft.file.split('/').map(encodeURIComponent).join('/');
  async function api(path: string, body?: unknown) {
    const response = await request(`https://api.github.com${path}`, {
      method: body === undefined ? 'GET' : 'POST',
      headers: { Accept: 'application/vnd.github+json', Authorization: `Bearer ${token}`, 'X-GitHub-Api-Version': '2022-11-28', ...(body === undefined ? {} : { 'Content-Type': 'application/json' }) },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
    if (!response.ok) throw new GitHubError(response.status);
    return response.json();
  }

  status('Vérification du fichier sur GitHub…');
  const user = await api('/user');
  const repo = await api(`/repos/${upstream}`);
  const head = await api(`/repos/${upstream}/git/ref/heads/main`);
  const base = head.object.sha;
  const original = await api(`/repos/${upstream}/contents/${file}?ref=${base}`);
  if (original.type !== 'file' || original.encoding !== 'base64' || decodeSource(original.content) !== draft.original) {
    throw new Error('Le fichier a changé sur GitHub depuis le chargement de la banque. Le brouillon est conservé : comparer avec la nouvelle source avant de proposer la modification.');
  }
  if (draft.source === draft.original) throw new Error('Modifier le fichier avant de proposer une pull request.');

  let target = upstream;
  if (!repo.permissions?.push) {
    status('Préparation du fork dans votre compte GitHub…');
    const fork = await api(`/repos/${upstream}/forks`, { default_branch_only: true });
    if (fork.owner.login !== user.login || !fork.fork) throw new Error('GitHub n’a pas renvoyé un fork dans votre compte.');
    target = fork.full_name;
  }
  // Un fork peut prendre quelques secondes à être disponible. Ne modifier aucune branche existante.
  let commit;
  for (let attempt = 0; ; attempt++) {
    try {
      commit = await api(`/repos/${target}/git/commits/${base}`);
      break;
    } catch (error) {
      if (target === upstream || !(error instanceof GitHubError) || ![404, 409].includes(error.status) || attempt >= 14) throw error;
      await new Promise(resolve => setTimeout(resolve, 2000));
    }
  }
  status('Enregistrement de votre modification sur une nouvelle branche…');
  const blob = await api(`/repos/${target}/git/blobs`, { content: encodeSource(draft.source), encoding: 'base64' });
  const tree = await api(`/repos/${target}/git/trees`, { base_tree: commit.tree.sha, tree: [{ path: draft.file, mode: '100644', type: 'blob', sha: blob.sha }] });
  const message = `Modifier ${draft.file.split('/').at(-1)}`;
  const change = await api(`/repos/${target}/git/commits`, { message, tree: tree.sha, parents: [base] });
  const branch = `contribution-${crypto.randomUUID()}`;
  await api(`/repos/${target}/git/refs`, { ref: `refs/heads/${branch}`, sha: change.sha });

  const url = new URL(`${repositoryUrl}/compare/main...${target.replace('/', ':')}:${branch}`);
  url.searchParams.set('expand', '1');
  url.searchParams.set('title', `Modifier ${draft.title}`);
  return url.href;
}
