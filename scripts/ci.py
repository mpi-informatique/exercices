#!/usr/bin/env python3
"""Sélectionner les vérifications CI à partir des fichiers modifiés et des dépendances locales."""

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys

from sources import ROOT, mask, sources


def changed_files(root, base):
    if not base or set(base) == {'0'}:
        return None
    try:
        commit = subprocess.check_output(['git', 'rev-parse', '--verify', '--end-of-options', base + '^{commit}'], cwd=root, stderr=subprocess.PIPE, text=True).strip()
        output = subprocess.check_output(['git', 'diff', '--name-only', '--no-renames', '-z', commit, 'HEAD', '--'], cwd=root)
    except subprocess.CalledProcessError:
        print('Base Git indisponible : vérification complète.', file=sys.stderr)
        return None
    return set(output.decode().split('\0')) - {''}


def references(root, source):
    """Inclure aussi les images et codes passés à des fonctions de la banque."""
    path = root / source
    if path.suffix != '.typ' or not path.is_file():
        return set()
    result = set()
    for match in re.finditer(r'"(?:\\.|[^"\\])*"', mask(path.read_text(), strings=False)):
        try:
            value = json.loads(match[0])
            if not value or value.startswith('@') or '://' in value or '\0' in value:
                continue
            dependency = (root / value.lstrip('/') if value.startswith('/') else path.parent / value).resolve()
            if dependency.is_relative_to(root.resolve()):
                result.add(dependency.relative_to(root.resolve()).as_posix())
        except (ValueError, OSError):
            continue
    return result


def selection(root, changed, entries):
    common = ('lib/', 'templates/', 'scripts/', 'nix/', 'docs/api.typ', 'load.typ', 'typst.toml', 'flake.nix', 'flake.lock', 'justfile', '.github/workflows/')
    browser = ('web/src/compiler/', 'web/scripts/', 'web/test/', 'web/package.json', 'web/package-lock.json', 'shared/')
    native_full = changed is None or any(path.startswith(common) for path in changed)
    wasm_full = native_full or any(path.startswith(browser) for path in changed)
    selected = []
    parsed = {}
    for source, _ in entries:
        if native_full:
            selected.append(source)
            continue
        pending = [source]
        visited = set()
        while pending:
            dependency = pending.pop()
            if dependency in changed:
                selected.append(source)
                break
            if dependency in visited:
                continue
            visited.add(dependency)
            if dependency not in parsed:
                parsed[dependency] = references(root, dependency)
            pending.extend(parsed[dependency] - visited)
    return {'native_full': native_full, 'wasm_full': wasm_full, 'resources': selected}


def native(plan, changed, entries):
    from build import OCAML, documents, empreinte, run

    if plan['native_full']:
        run([sys.executable, ROOT / 'scripts/build.py', 'check'])
        return
    selected = [(source, kind) for source, kind in entries if source in plan['resources']]
    print(f'Vérification native ciblée : {len(selected)} ressource(s).', flush=True)
    if selected:
        documents(selected, empreinte())
    related = [Path(path) for path in changed | set(plan['resources'])]
    for directory in ('chapitres', 'devoirs'):
        for pattern in ('corrige.ml', 'test.py'):
            for script in sorted((ROOT / directory).rglob(pattern)):
                folder = script.parent.relative_to(ROOT)
                if any(folder in path.parents for path in related):
                    run([OCAML, '-I', script.parent, script] if pattern == 'corrige.ml' else [sys.executable, script])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('plan', 'native'))
    parser.add_argument('--base', default=os.environ.get('CI_BASE', ''))
    args = parser.parse_args()
    changed = changed_files(ROOT, args.base)
    entries = list(sources())
    plan = selection(ROOT, changed, entries)
    if args.action == 'native':
        native(plan, changed, entries)
    else:
        print(json.dumps(plan, ensure_ascii=False, indent=2))
        if output := os.environ.get('GITHUB_OUTPUT'):
            with open(output, 'a') as stream:
                stream.write(f"native_full={str(plan['native_full']).lower()}\nwasm_full={str(plan['wasm_full']).lower()}\nresources={json.dumps(plan['resources'])}\n")


if __name__ == '__main__':
    main()
