#!/usr/bin/env python3
"""Repérer et compiler les sources par leur contenu, sans classement imposé."""

import argparse
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
IGNORED = {"build", "lib", "templates", "ressources", "docs", "scripts", "tmp", "node_modules", "web", "shared"}


def mask(text):
    """Ignorer commentaires, chaînes et code brut sans déplacer les lignes."""
    result = list(text)
    i = 0
    while i < len(text):
        start = i
        if text.startswith("//", i):
            end = text.find("\n", i)
            i = len(text) if end < 0 else end
        elif text.startswith("/*", i):
            i += 2
            depth = 1
            while i < len(text) and depth:
                if text.startswith("/*", i):
                    depth += 1
                    i += 2
                elif text.startswith("*/", i):
                    depth -= 1
                    i += 2
                else:
                    i += 1
        elif text[i] == '`':
            while i < len(text) and text[i] == '`':
                i += 1
            fence = text[start:i]
            end = text.find(fence, i)
            i = len(text) if end < 0 else end + len(fence)
        elif text[i] == '"':
            i += 1
            while i < len(text):
                if text[i] == '\\':
                    i += 2
                elif text[i] == '"':
                    i += 1
                    break
                else:
                    i += 1
        else:
            i += 1
            continue
        result[start:i] = ['\n' if c == '\n' else ' ' for c in text[start:i]]
    return ''.join(result)


def classify(text, source):
    code = mask(text)
    # Le contenu détermine le type, quel que soit le dossier.
    for template, kind in (("cours-et-presentation", "cours-presentation"), ("cours", "cours"), ("presentation", "presentation")):
        if re.search(r'#show\s*:\s*' + template + r'\.with\s*\(', code):
            return kind
    if re.search(r'#show\s*:\s*feuille\.with\s*\(', code):
        return "document"
    reexports = any(re.fullmatch(r'(?:ex|[\w-]+\s+as\s+ex)', member.strip())
                    for match in re.finditer(r'#import\s+:\s*([^\n]+)', code)
                    for member in match[1].split(','))
    if re.search(r'#let\s+ex\s*=', code) or reexports:
        return "exercice"
    return None


def variants(kind):
    """Les sorties d'une source et les paramètres de compilation correspondants."""
    if kind == 'cours-presentation':
        return {'cours': ('format=cours', 'corrige=false'), 'corrige': ('format=cours', 'corrige=true'), 'presentation': ('format=presentation', 'corrige=false')}
    if kind == 'cours':
        return {'cours': ('corrige=false',), 'corrige': ('corrige=true',)}
    if kind == 'presentation':
        return {'presentation': ()}
    return {'enonce': ('corrige=false',), 'corrige': ('corrige=true',)}


def pdf_filename(source, variant, kind=None):
    """Nom de PDF commun à la compilation, à la surveillance et aux exports."""
    stem = Path(source).stem
    if kind == 'cours-presentation':
        prefix = 'presentation' if variant == 'presentation' else 'cours'
        return f'{prefix}-{stem.removeprefix("cours-")}' + ('-cor' if variant == 'corrige' else '') + '.pdf'
    return stem + ('-cor' if variant == 'corrige' else '') + '.pdf'


def sources():
    for file in sorted(ROOT.rglob("*.typ")):
        relative = file.relative_to(ROOT)
        if any(p.startswith('.') or p in IGNORED for p in relative.parts[:-1]):
            continue
        if not file.resolve().is_relative_to(ROOT):
            raise ValueError(f"Source hors de la banque : {relative}")
        kind = classify(file.read_text(), relative.as_posix())
        if kind:
            yield relative.as_posix(), kind


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--list', choices=['exercices', 'documents', 'all'])
    parser.add_argument('--source')
    parser.add_argument('--output')
    parser.add_argument('--variant', choices=['enonce', 'corrige', 'cours', 'presentation'])
    parser.add_argument('--typst', default='typst')
    parser.add_argument('--watch', action='store_true')
    args = parser.parse_args()
    if args.list:
        for source, kind in sources():
            if args.list == 'all' or (args.list == 'exercices') == (kind == 'exercice'):
                print(source)
        return
    source = (ROOT / args.source).resolve()
    if not source.is_relative_to(ROOT) or not source.is_file():
        parser.error('La source doit rester dans la banque.')
    kind = classify(source.read_text(), source.relative_to(ROOT).as_posix())
    if not kind:
        parser.error('Source non reconnue : exporter ex ou utiliser un modèle de document.')
    available = variants(kind)
    variant = args.variant or next(iter(available))
    if variant not in available:
        parser.error('Variantes disponibles : ' + ', '.join(available))
    output = ROOT / args.output
    output.parent.mkdir(parents=True, exist_ok=True)
    command = [args.typst, 'watch' if args.watch else 'compile', '--root', str(ROOT), '--ignore-system-fonts']
    for value in available[variant]:
        command += ['--input', value]
    if kind != 'exercice':
        command.append(str(source))
    else:
        command += ['--input', 'exercice=/' + source.relative_to(ROOT).as_posix(), str(ROOT / 'templates/fiche.typ')]
    return subprocess.call(command + [str(output)])


if __name__ == '__main__':
    raise SystemExit(main())
