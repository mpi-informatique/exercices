import { useEffect, useRef, useState } from 'react';
import type { Resource, Variant } from '@mpi-informatique/exercices-core';
import type { CompileRequest, CompileResponse } from '../compiler/protocol';

export interface Compilation {
  pdf?: Uint8Array<ArrayBuffer>;
  pending: boolean;
  message: string;
  error?: string;
  warnings?: string[];
}

export function useCompiler(resource: Resource | undefined, source: string | undefined, variant: Variant, retry: number, bundle?: Record<string, string>): Compilation {
  const [state, setState] = useState<Compilation>({ pending: false, message: 'Choisir une ressource' });
  const queue = useRef<(request: CompileRequest) => void>(() => {});
  const sequence = useRef(0);
  const previousResource = useRef<string | undefined>(undefined);

  useEffect(() => {
    let worker: Worker | undefined;
    let active = false;
    let pending: CompileRequest | undefined;
    let timeout: ReturnType<typeof setTimeout>;
    const fail = (message: string) => {
      clearTimeout(timeout);
      worker?.terminate();
      worker = undefined;
      active = false;
      pending = undefined;
      setState(state => ({ ...state, pending: false, error: message, message: 'Compilation interrompue' }));
    };
    const start = (request: CompileRequest) => {
      worker ??= new Worker(new URL('../compiler/typst.worker.ts', import.meta.url), { type: 'module' });
      worker.onerror = () => fail('Le compilateur a rencontré une erreur. Relancer la compilation.');
      worker.onmessage = ({ data }: MessageEvent<CompileResponse>) => {
        if (data.id === sequence.current) {
          if (data.type === 'progress') setState(state => ({ ...state, message: data.message }));
          if (data.type === 'success') setState({ pdf: data.pdf, pending: false, message: `À jour · ${data.duration} ms`, warnings: data.diagnostics });
          if (data.type === 'error') setState(state => ({ ...state, pending: false, error: data.message, message: 'Erreur de compilation' }));
        }
        if (data.type !== 'progress') {
          clearTimeout(timeout);
          active = false;
          if (pending) { const next = pending; pending = undefined; start(next); }
        }
      };
      active = true;
      timeout = setTimeout(() => fail('La compilation dépasse 120 secondes. Vérifier le code puis réessayer.'), 120_000);
      worker.postMessage(request);
    };
    queue.current = request => { if (active) pending = request; else start(request); };
    return () => { clearTimeout(timeout); worker?.terminate(); };
  }, [bundle]);

  useEffect(() => {
    const id = ++sequence.current;
    const changed = previousResource.current !== resource?.id;
    previousResource.current = resource?.id;
    setState(state => ({ ...(changed ? {} : state), pending: source !== undefined, message: 'En attente…', error: undefined }));
    if (!resource || source === undefined) return;
    const timer = setTimeout(() => queue.current({ id, resource, source, variant, bundle }), 450);
    return () => clearTimeout(timer);
  }, [resource, source, variant, retry, bundle]);

  return state;
}
