#!/usr/bin/env python3
"""Exporter les métadonnées Typst, sans base de données ni dépendance Python."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import subprocess
import sys
from sources import sources

ROOT = Path(__file__).resolve().parents[1]


def catalogue(typst):
    exercices = [relative for relative, kind in sources() if kind == "exercice"]

    def evaluer(relative):
        result = subprocess.run(
            [typst, "eval", "--root", str(ROOT), "--ignore-system-fonts",
             "--input", f"exercice=/{relative}", "--in", str(ROOT / "templates/fiche.typ"),
             "query(<exercice-meta>).map(m => m.value).first()"],
            check=True, capture_output=True, text=True,
        )
        return relative, json.loads(result.stdout), result.stderr

    entries = []
    identifiers = set()
    with ThreadPoolExecutor(max_workers=4) as executor:
        for relative, meta, stderr in executor.map(evaluer, exercices):
            if stderr:
                print(stderr, end="", file=sys.stderr)
            # Le constructeur Typst valide les champs communs ; ici, on contrôle
            # l'unicité à l'échelle de toute la banque, même en cas de filtrage.
            identifier = Path(relative).stem
            if identifier in identifiers:
                raise ValueError(f"Identifiant dupliqué : {identifier} ({relative})")
            identifiers.add(identifier)
            entries.append({**meta, "fichier": relative})
    return entries


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--typst", default="typst", help="Exécutable Typst")
    parser.add_argument("--sortie", type=Path, help="Fichier JSON ; sinon sortie standard")
    parser.add_argument("--chapitre")
    parser.add_argument("--algorithme")
    parser.add_argument("--structure")
    parser.add_argument("--niveau")
    parser.add_argument("--langage", help="Langage de programmation (casse exacte)")
    parser.add_argument("--concours", help="Nom exact du concours")
    parser.add_argument("--difficulte-max", type=int, choices=range(1, 6))
    args = parser.parse_args()
    try:
        entries = catalogue(args.typst)
        for attribute, field in (("chapitre", "chapitres"), ("algorithme", "algorithmes"),
                                 ("structure", "structures"), ("niveau", "niveaux"),
                                 ("langage", "langages")):
            value = getattr(args, attribute)
            if value is not None:
                entries = [entry for entry in entries if value in entry[field]]
        if args.concours is not None:
            entries = [entry for entry in entries
                       if (entry["concours"] or {}).get("nom") == args.concours]
        if args.difficulte_max is not None:
            entries = [entry for entry in entries if entry["difficulte"] <= args.difficulte_max]
        output = json.dumps(entries, ensure_ascii=False, indent=2) + "\n"
        if args.sortie:
            args.sortie.parent.mkdir(parents=True, exist_ok=True)
            # Ne pas remplacer un catalogue valide avant la fin de l'export.
            temporary = args.sortie.with_suffix(args.sortie.suffix + ".tmp")
            temporary.write_text(output, encoding="utf-8")
            temporary.replace(args.sortie)
        else:
            print(output, end="")
    except subprocess.CalledProcessError as error:
        print(error.stderr, file=sys.stderr, end="")
        return 1
    except (OSError, ValueError, KeyError) as error:
        print(f"Erreur de catalogue : {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
