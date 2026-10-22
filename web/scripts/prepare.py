#!/usr/bin/env python3
"""Exporter la banque publique et ses dépendances pour un hébergement statique."""

import base64
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tomllib

WEB = Path(__file__).resolve().parents[1]
ROOT = WEB.parent
sys.path.insert(0, str(ROOT / "scripts"))
from catalogue import catalogue
from sources import sources, variants, pdf_filename
from build import compiler, empreinte


def export_pdfs(entries, bank, signature):
    """Compiler les versions publiées avec le cache commun à Just."""
    kinds = dict(sources())
    for entry in entries:
        source = entry['fichier']
        kind = kinds[source]
        entry['pdfs'] = {}
        for variant, inputs in variants(kind).items():
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
    export_pdfs(entries, bank, empreinte())
    (bank / 'catalogue.json').write_text(json.dumps(entries, ensure_ascii=False))
    files = []
    shutil.copyfile(ROOT / "load.typ", bank / "load.typ")
    files.append("load.typ")
    for directory in ("chapitres", "devoirs", "lib", "templates"):
        files.extend(f"{directory}/{file}" for file in copy_tree(ROOT / directory, bank / directory))
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
