import { useEffect, useRef, useState } from 'react';
import { connectPrivateBank } from '../lib/githubAuth';
import { commitPrivateFile, githubRead, loadPrivateFiles, privateRepositories, type PrivateBank, type PrivateRepository } from '../lib/privateBank';
import { encodeSource, type Contribution } from '../lib/github';

export function usePrivateBank() {
  const token = useRef<string | undefined>(undefined);
  const controller = useRef<AbortController | undefined>(undefined);
  const indexer = useRef<Worker | undefined>(undefined);
  const generation = useRef(0);
  const committing = useRef(false);
  const [commitPending, setCommitPending] = useState(false);
  const [account, setAccount] = useState('');
  const [repositories, setRepositories] = useState<PrivateRepository[]>([]);
  const [bank, setBank] = useState<PrivateBank>();
  const [busy, setBusy] = useState(false);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  const clear = () => {
    generation.current++;
    controller.current?.abort();
    indexer.current?.terminate();
    indexer.current = undefined;
    bank?.drafts.clear();
    setBank(undefined);
  };
  useEffect(() => () => { generation.current++; controller.current?.abort(); indexer.current?.terminate(); token.current = undefined; }, []);

  async function connect() {
    clear();
    const current = generation.current;
    setBusy(true); setError(''); setMessage('Connexion à GitHub…');
    try {
      const access = await connectPrivateBank();
      if (current !== generation.current) return;
      token.current = access;
      const signal = (controller.current = new AbortController()).signal;
      const user = await githubRead('/user', access, signal);
      const repos = await privateRepositories(access, signal);
      if (current !== generation.current) return;
      setAccount(user.login); setRepositories(repos);
      setMessage(repos.length ? 'Choisir un dépôt privé à ajouter à la banque.' : 'Aucun dépôt privé accessible. Vérifier les autorisations GitHub et celles de l’organisation.');
    } catch (error) {
      if (current === generation.current) { token.current = undefined; setError(error instanceof Error ? error.message : 'Connexion impossible.'); }
    } finally { if (current === generation.current) setBusy(false); }
  }

  async function select(repository: string) {
    clear();
    setError('');
    if (!repository) { setBusy(false); setMessage('Les exercices publics restent disponibles.'); return; }
    const selected = repositories.find(repo => repo.full_name === repository);
    if (!selected || !token.current) return;
    const current = generation.current;
    const signal = (controller.current = new AbortController()).signal;
    setBusy(true); setMessage('Chargement du dépôt privé…');
    try {
      const files = await loadPrivateFiles(selected, token.current, signal, text => { if (current === generation.current) setMessage(text); });
      signal.throwIfAborted();
      const worker = indexer.current = new Worker(new URL('../compiler/private-index.worker.ts', import.meta.url), { type: 'module' });
      const indexed = await new Promise<Pick<PrivateBank, 'resources' | 'warnings'>>((resolve, reject) => {
        let timeout: ReturnType<typeof setTimeout>;
        const fail = (error: Error) => { clearTimeout(timeout); reject(error); };
        const arm = () => { clearTimeout(timeout); timeout = setTimeout(() => fail(new Error('L’indexation dépasse 120 secondes pour un exercice. Vérifier les sources du dépôt.')), 120_000); };
        arm();
        signal.addEventListener('abort', () => fail(new Error('Chargement annulé.')), { once: true });
        worker.onerror = () => fail(new Error('Le compilateur n’a pas pu indexer le dépôt.'));
        worker.onmessage = ({ data }) => {
          if (current !== generation.current) return;
          if (data.type === 'progress') { arm(); setMessage(data.message); }
          if (data.type === 'error') fail(new Error(data.message));
          if (data.type === 'success') { clearTimeout(timeout); resolve(data); }
        };
        worker.postMessage({ repository: files.repository, sources: files.sources, bundle: files.bundle });
      });
      if (current !== generation.current) return;
      setBank({ ...files, ...indexed });
      setMessage(`${indexed.resources.length} ressource${indexed.resources.length !== 1 ? 's' : ''} privée${indexed.resources.length !== 1 ? 's' : ''} ajoutée${indexed.resources.length !== 1 ? 's' : ''}.`);
      if (!indexed.resources.length) setError('Aucun exercice compatible trouvé. Les fichiers doivent exporter « ex » ou utiliser le modèle « feuille » de la banque.');
    } catch (error) { if (current === generation.current) { controller.current?.abort(); setError(error instanceof Error ? error.message : 'Chargement impossible.'); } }
    finally {
      if (current === generation.current) { indexer.current?.terminate(); indexer.current = undefined; setBusy(false); }
    }
  }

  function disconnect() {
    clear(); token.current = undefined; setAccount(''); setRepositories([]); setBusy(false); setError(''); setMessage('Déconnecté. Les exercices privés et leurs brouillons ont été retirés de cet onglet.');
  }

  async function commit(draft: Contribution) {
    if (!bank || !token.current || committing.current || busy) return;
    committing.current = true; setCommitPending(true);
    const current = generation.current;
    try {
      const sha = await commitPrivateFile(bank, draft, token.current, controller.current!.signal);
      if (current !== generation.current) return;
      // Conserver aussi les éditions effectuées pendant la requête, y compris une réinitialisation.
      const latest = bank.drafts.get(draft.file) ?? bank.sources[draft.file];
      if (latest === draft.source) bank.drafts.delete(draft.file);
      else bank.drafts.set(draft.file, latest);
      setBank({ ...bank, sources: { ...bank.sources, [draft.file]: draft.source }, bundle: { ...bank.bundle, [`/@memory/workspace/${draft.file}`]: encodeSource(draft.source) } });
      return sha;
    } catch (error) { if (current === generation.current) throw error; }
    finally { committing.current = false; setCommitPending(false); }
  }
  return { account, repositories, bank, busy, message, error, connect, select, disconnect, commit, commitPending };
}
