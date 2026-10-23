#!/usr/bin/env python3
"""Exporter la banque publique et ses dépendances pour un hébergement statique."""

import base64
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tomllib
from urllib.request import urlopen

WEB = Path(__file__).resolve().parents[1]
ROOT = WEB.parent
sys.path.insert(0, str(ROOT / "scripts"))
from catalogue import catalogue
from sources import sources, variants, pdf_filename
from build import compiler, empreinte


def published_pages():
    """Lire le menu voisin, ou sa version distante pour un clone autonome."""
    local = Path(os.environ.get("COURS_PAGES_TYPST", ROOT.parent / "cours/pages-typst.md"))
    if local.is_file() or "COURS_PAGES_TYPST" in os.environ:
        markdown = local.read_text()
    else:
        with urlopen("https://raw.githubusercontent.com/mpi-informatique/cours/main/pages-typst.md", timeout=30) as response:
            markdown = response.read().decode("utf-8")
    return parse_published_pages(markdown)


def parse_published_pages(markdown):
    # Syntaxe des feuilles Typst de cours/scripts/typst-pages.mjs.
    pages = {}
    lines = [line for line in markdown.splitlines() if line.strip() and not line.startswith("#")]
    for index, line in enumerate(lines):
        item = re.fullmatch(r"( *)- (.+?)\s*", line)
        if not item or not item[1]:
            continue
        if index + 1 < len(lines) and len(lines[index + 1]) - len(lines[index + 1].lstrip()) > len(item[1]):
            continue
        entry = re.fullmatch(r"(?:\[[^\]]+\]\(([a-z0-9][a-z0-9-]*)\)|([a-z0-9][a-z0-9-]*))(?:\s*:\s*(cor))?", item[2])
        if entry:
            pages[entry[1] or entry[2]] = entry[3] == "cor"
        elif not re.fullmatch(r"\[[^\]]+\]\((?:doc:|https?://)[^\s)]+\)", item[2]):
            raise ValueError(f"Entrée de menu Typst invalide : {line}")
    if not pages:
        raise ValueError("Aucune ressource Typst dans le menu du cours.")
    return pages


def export_pdfs(entries, bank, signature, pages):
    """Compiler uniquement les versions utilisées par le menu du cours."""
    missing = pages.keys() - {entry['id'] for entry in entries}
    if missing:
        raise ValueError(f"Documents du cours absents de la banque : {', '.join(sorted(missing))}")
    kinds = dict(sources())
    for entry in entries:
        entry['pdfs'] = {}
        if entry['id'] not in pages and entry.get('type') != 'tp':
            continue
        source = entry['fichier']
        kind = kinds[source]
        for variant, inputs in variants(kind).items():
            if variant == 'corrige' and entry.get('type') != 'tp' and not pages.get(entry['id'], True):
                continue
            filename = pdf_filename(source, variant, kind)
            output = Path('build') / Path(source).with_suffix('') / filename
            compiler(source, output, signature, *inputs, exercice=kind == 'exercice')
            # Le nom change avec les sources et dépendances : un ancien cache ne
            # peut pas masquer la dernière version publiée.
            public_name = f'{Path(filename).stem}-{signature[:16]}.pdf'
            destination = bank / 'pdf' / entry['id'] / public_name
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / output, destination)
            entry['pdfs']['enonce' if variant == 'cours' else variant] = destination.relative_to(WEB / 'public').as_posix()


def export_tp(entries, bank):
    """Publier les fichiers déclarés dans les métadonnées Typst des TP."""
    exported = set()
    for entry in entries:
        if entry['type'] != 'tp':
            continue
        directory = Path(entry['fichier']).parent
        data = entry.get('tp')
        if not isinstance(data, dict):
            raise ValueError(f"Métadonnées tp absentes ou invalides : {entry['fichier']}")

        def relative(value):
            if not isinstance(value, str) or not value or '\\' in value or ':' in value or any(part in ('', '.', '..') or part.startswith('.') for part in value.split('/')):
                raise ValueError(f"Chemin TP invalide : {value}")
            return value

        def files(items):
            if not isinstance(items, list):
                raise ValueError(f"Liste de ressources TP invalide : {entry['fichier']}")
            result = []
            for item in items:
                if not isinstance(item, dict) or 'source' not in item:
                    raise ValueError(f"Ressource TP invalide : {item}")
                source = relative(item['source'])
                path = ROOT / directory / source
                if not path.is_file() or not path.resolve().is_relative_to((ROOT / directory).resolve()):
                    raise ValueError(f"Ressource TP absente ou hors du dossier : {path}")
                resource = {'url': f'banque/{directory}/{source}', 'chemin': relative(item.get('destination', source))}
                if 'extraire' in item:
                    if path.suffix.lower() != '.zip':
                        raise ValueError(f"Seuls les ZIP peuvent être extraits : {path}")
                    resource['extraire'] = relative(item['extraire'])
                target = bank / directory / source
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(path, target)
                exported.add((directory / source).as_posix())
                result.append(resource)
            return result

        skeleton = files(data.get('squelette'))
        opening = relative(data.get('ouvrir'))
        if opening not in [item['chemin'] for item in skeleton]:
            raise ValueError(f"Le fichier à ouvrir doit appartenir au squelette : {opening}")
        entry['tp'] = {
            'ouvrir': opening,
            'fichiers': skeleton + files(data.get('ressources', [])),
            'corrige': files(data.get('corrige', [])),
        }
    return sorted(exported)


def document(typst, source, kind="document"):
    # Interroger la même API que les PDF, sans réinterpréter le code Typst.
    result = subprocess.run(
        [typst, "eval", "--root", str(ROOT), "--ignore-system-fonts", "--in", str(ROOT / source),
         '(document: query(<document-meta>).map(m => m.value).first(), exercices: query(<exercice-meta>).map(m => m.value))'],
        check=True, capture_output=True, text=True,
    )
    data = json.loads(result.stdout)
    meta, exercises = data["document"], data["exercices"]
    return {
        "fichier": source, "titre": meta["titre"], "type": kind if kind != "document" else meta["type"],
        "concours": meta.get("concours"), "duree": None,
        "difficulte": max((ex["difficulte"] for ex in exercises), default=None),
        "nombreExercices": len(exercises),
        **({'tp': meta['tp']} if 'tp' in meta else {}),
        **{field: sorted({value for ex in exercises for value in ex.get(field, [])})
           for field in ("chapitres", "algorithmes", "structures", "langages", "niveaux")},
    }


def resources(typst):
    entries = []
    for ex in catalogue(typst):
        kind = "concours" if ex.get("concours") else "exercice"
        entries.append({**ex, "kind": "exercice", "type": kind, "nombreExercices": 1})
    for source, kind in sources():
        if kind != "exercice":
            entries.append({**document(typst, source, kind), "kind": "document"})
    identifiers = set()
    for entry in entries:
        entry["id"] = Path(entry["fichier"]).stem
        if entry["id"] in identifiers:
            raise ValueError(f"Identifiant dupliqué : {entry['id']}")
        identifiers.add(entry["id"])
    return sorted(entries, key=lambda entry: entry["titre"].casefold())


def copy_tree(source, destination, exclude_tests=True):
    """Conserver les chemins et fichiers associés, jamais les sorties ou tests."""
    files = []
    for path in sorted(source.rglob("*")):
        relative = path.relative_to(source)
        if any(part.startswith(".") or part in {"__pycache__", "node_modules"} or (exclude_tests and part == "tests") for part in relative.parts):
            continue
        if not path.is_file() or path.suffix.lower() in {".pdf", ".pyc", ".cmi", ".cmo", ".exe"}:
            continue
        if exclude_tests and path.name.startswith("test."):
            continue
        if not path.resolve().is_relative_to(source.resolve()):
            raise ValueError(f"Ressource hors de la banque : {path}")
        target = destination / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, target)
        files.append(relative.as_posix())
    return files


def prepare():
    typst = os.environ.get("TYPST", "typst")
    pages = published_pages()
    entries = resources(typst)
    chapters = subprocess.run(
        [typst, "eval", "--root", str(ROOT),
         'import "lib/meta.typ": chapitres-informatique, chapitres-maths; (Informatique: chapitres-informatique, Mathématiques: chapitres-maths)'],
        cwd=ROOT, check=True, capture_output=True, text=True,
    )
    public = WEB / "public"
    bank = public / "banque"
    shutil.rmtree(bank, ignore_errors=True)
    bank.mkdir(parents=True)
    export_pdfs(entries, bank, empreinte(), pages)
    tp_files = export_tp(entries, bank)
    (bank / 'catalogue.json').write_text(json.dumps(entries, ensure_ascii=False))
    files = []
    shutil.copyfile(ROOT / "load.typ", bank / "load.typ")
    files.append("load.typ")
    for directory in ("chapitres", "devoirs", "lib", "templates"):
        files.extend(f"{directory}/{file}" for file in copy_tree(ROOT / directory, bank / directory))
    # Les fichiers explicitement fournis aux élèves restent publiés, y compris
    # les annexes PDF et les ressources normalement exclues de la copie générale.
    files = sorted(set(files) | set(tp_files))
    packages = []
    package_path = os.environ.get("TYPST_PACKAGE_PATH")
    if not package_path:
        raise RuntimeError("TYPST_PACKAGE_PATH absent : lancer depuis nix develop ..#web.")
    for dependency in json.loads((ROOT / "nix/typst-packages.json").read_text()):
        name = f"{dependency.get('namespace', 'preview')}/{dependency['name']}/{dependency['version']}"
        source = Path(package_path) / name
        if not source.is_dir():
            raise FileNotFoundError(f"Package Typst manquant : {source}")
        # Certains packages importent test.typ dans leur API (notamment t4t).
        files_in_package = copy_tree(source, bank / "packages" / name, exclude_tests=False)
        packages.extend(f"{name}/{file}" for file in files_in_package)
    # Servir aussi la variante sans empattements utilisée par les présentations.
    fonts = public / "fonts"
    shutil.rmtree(fonts, ignore_errors=True)
    fonts.mkdir(parents=True)
    wanted = {"NewCM10-Regular.otf", "NewCM10-Bold.otf", "NewCM10-Italic.otf", "NewCM10-BoldItalic.otf", "NewCMMath-Regular.otf", "NewCMSans10-Regular.otf", "NewCMSans10-Bold.otf", "NewCMSans10-Oblique.otf", "NewCMSans10-BoldOblique.otf", "DejaVuSansMono.ttf"}
    for directory in os.environ.get("EXERCICES_FONT_PATHS", "").split(os.pathsep):
        if directory:
            for path in Path(directory).rglob("*"):
                if path.name in wanted:
                    shutil.copyfile(path, fonts / path.name)
    missing = wanted - {path.name for path in fonts.iterdir()}
    if missing:
        raise RuntimeError(f"Polices manquantes : {', '.join(sorted(missing))}")
    (bank / "manifest.json").write_text(json.dumps({"files": files, "packages": packages, "fonts": sorted(wanted)}, ensure_ascii=False))
    bundle = {f"/@memory/workspace/{file}": base64.b64encode((bank / file).read_bytes()).decode() for file in files}
    bundle.update({f"/@memory/packages/{file}": base64.b64encode((bank / "packages" / file).read_bytes()).decode() for file in packages})
    # Les banques privées importent cette API comme package, sans clone public voisin.
    package_manifest = (ROOT / 'typst.toml').read_bytes()
    package = tomllib.loads(package_manifest.decode())['package']
    package_root = f"/@memory/packages/mpi-informatique/{package['name']}/{package['version']}"
    bundle.update({f"{package_root}/{file}": bundle[f"/@memory/workspace/{file}"] for file in files})
    bundle[f"{package_root}/typst.toml"] = base64.b64encode(package_manifest).decode()
    (bank / "bundle.json").write_text(json.dumps(bundle))
    generated = WEB / "src/generated"
    generated.mkdir(parents=True, exist_ok=True)
    (generated / "files.json").write_text(json.dumps(files, ensure_ascii=False))
    (generated / "catalogue.json").write_text(json.dumps(entries, ensure_ascii=False))
    (generated / "chapitres.json").write_text(chapters.stdout)
    print(f"Banque web : {len(entries)} ressources, {len(files)} fichiers et {len(packages)} fichiers de packages.")


if __name__ == "__main__":
    prepare()
