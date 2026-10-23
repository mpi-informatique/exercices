#!/usr/bin/env python3
"""Compiler et vérifier la banque, en réutilisant les sorties à jour.

Point d'entrée utilisable directement ou depuis Just : déléguer la découverte
à sources.py, l'export à catalogue.py et lancer Typst et les tests.
"""

import argparse
import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import sys

from sources import ROOT, pdf_filename, sources, variants

TYPST = os.environ.get('TYPST', 'typst')
OCAML = os.environ.get('OCAML', 'ocaml')


def run(command):
    print(' '.join(map(str, command)), flush=True)
    subprocess.run(list(map(str, command)), cwd=ROOT, check=True)


def empreinte():
    digest = hashlib.sha256(subprocess.check_output([TYPST, '--version']))
    digest.update(os.environ.get('TYPST_PACKAGE_PATH', '').encode())
    for file in sorted(ROOT.rglob('*')):
        if any(part.startswith('.') or part in {'build', 'tmp', '__pycache__', 'node_modules', 'web', 'shared'} for part in file.relative_to(ROOT).parts):
            continue
        if file.is_file():
            digest.update(file.relative_to(ROOT).as_posix().encode())
            digest.update(file.read_bytes())
    return digest.hexdigest()


def compiler(source, output, signature, *inputs, exercice=False):
    output = ROOT / output
    cache = output.with_suffix('.sha256')
    cle = signature + repr((str(source), inputs, exercice))
    if output.is_file() and cache.is_file() and cache.read_text() == cle:
        return
    output.parent.mkdir(parents=True, exist_ok=True)
    command = [TYPST, 'compile', '--root', ROOT, '--ignore-system-fonts']
    for value in inputs:
        command += ['--input', value]
    if exercice:
        command += ['--input', 'exercice=/' + str(source), ROOT / 'templates/fiche.typ']
    else:
        command.append(ROOT / source)
    try:
        run(command + [output])
    except subprocess.CalledProcessError:
        output.unlink(missing_ok=True)
        cache.unlink(missing_ok=True)
        raise
    cache.write_text(cle)


def documents(selection, signature, categorie=None):
    for source, kind in selection:
        if categorie and (kind == 'exercice') != (categorie == 'exercices'):
            continue
        for variante, inputs in variants(kind).items():
            compiler(source, Path('build') / Path(source).with_suffix('') / pdf_filename(source, variante, kind),
                     signature, *inputs, exercice=kind == 'exercice')


def tests(signature):
    for script in ('test_package.py', 'test_sources.py'):
        run([sys.executable, ROOT / 'lib/tests' / script])
    for mode in ('feuille', 'sujet'):
        for corrige in (False, True):
            variante = 'corrige' if corrige else 'enonce'
            source = 'lib/tests/pagination-colle.typ'
            compiler(source, Path('build/lib/tests/pagination-colle') / mode / pdf_filename(source, variante), signature,
                     'mode=' + mode, 'corrige=' + str(corrige).lower())
    for source, inputs in (
        ('points', ()), ('points', ('corrige=true',)), ('test', ()),
        ('bareme', ()), ('bareme', ('corrige=true',)),
    ):
        suffixe = '-cor' if inputs else ''
        compiler(f'lib/tests/{source}.typ', f'build/lib/tests/{source}{suffixe}.pdf', signature, *inputs)
    # Les tests restent à côté du code publié, sans liste de chemins à maintenir.
    for test in sorted(test for dossier in ('chapitres', 'devoirs') for test in (ROOT / dossier).rglob('corrige.ml')):
        run([OCAML, '-I', test.parent, test])
    for test in sorted(test for dossier in ('chapitres', 'devoirs') for test in (ROOT / dossier).rglob('test.py')):
        run([sys.executable, test])


def modeles(signature):
    for nom, source, exercice in (
        ('exercice', 'templates/exercice.typ', True),
        ('feuille', 'templates/feuille.typ', False),
        ('tp', 'templates/tp.typ', False),
        ('colle', 'templates/colle.typ', False),
        ('devoir', 'templates/devoir.typ', False),
        ('sujet-concours', 'templates/sujet-concours.typ', False),
    ):
        for corrige in (False, True):
            suffixe = '-cor' if corrige else ''
            compiler(source, f'build/templates/{nom}{suffixe}.pdf', signature,
                     'corrige=' + str(corrige).lower(), exercice=exercice)
    for nom, kind in (('cours', 'cours'), ('presentation', 'presentation'), ('cours-presentation', 'cours-presentation')):
        for variante, inputs in variants(kind).items():
            source = f'templates/{nom}.typ'
            compiler(source, Path('build/templates') / nom / pdf_filename(source, variante, kind), signature, *inputs)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('all', 'exercices', 'documents', 'catalogue', 'c', 'w', 'docs', 'test', 'check', 'clean'))
    parser.add_argument('source', nargs='?')
    parser.add_argument('--variant', choices=('enonce', 'corrige', 'cours', 'presentation'))
    args = parser.parse_args()
    os.chdir(ROOT)
    if args.action == 'clean':
        shutil.rmtree(ROOT / 'build', ignore_errors=True)
        return
    if args.action in ('c', 'w'):
        if not args.source:
            parser.error('Indiquer le chemin du fichier Typst.')
        source = (ROOT / args.source).resolve()
        selection = [(s, k) for s, k in sources() if (ROOT / s).resolve() == source]
        if not selection:
            parser.error('Source absente du catalogue ou hors du dépôt.')
        if args.action == 'w':
            relative, kind = selection[0]
            available = variants(kind)
            variant = args.variant or ('corrige' if 'corrige' in available else next(iter(available)))
            if variant not in available:
                parser.error('Variantes disponibles : ' + ', '.join(available))
            run([sys.executable, ROOT / 'scripts/sources.py', '--typst', TYPST,
                 '--source', relative, '--output', str(Path('build') / Path(relative).with_suffix('') / pdf_filename(relative, variant, kind)),
                 '--variant', variant, '--watch'])
            return
    else:
        selection = list(sources())
    signature = empreinte()
    if args.action in ('all', 'exercices', 'documents', 'c', 'check'):
        documents(selection, signature, args.action if args.action in ('exercices', 'documents') else None)
    if args.action in ('all', 'catalogue', 'check'):
        run([sys.executable, ROOT / 'scripts/catalogue.py', '--typst', TYPST, '--sortie', 'build/catalogue.json'])
    if args.action in ('docs', 'check'):
        compiler('docs/api.typ', 'build/docs/api.pdf', signature)
    if args.action in ('test', 'check'):
        tests(signature)
    if args.action == 'check':
        modeles(signature)


if __name__ == '__main__':
    main()
