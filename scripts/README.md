# Scripts Python

Pour compiler sans Just, lancer `build.py` depuis la racine dans l'environnement Nix :

```sh
nix develop . -c python3 scripts/build.py c chemin.typ
```

| Script | Rôle |
| --- | --- |
| [build.py](build.py) | Compilation, cache, catalogue, documentation et tests. |
| [sources.py](sources.py) | Découverte des sources, variantes et surveillance. |
| [ci.py](ci.py) | Sélection des documents affectés par un changement Git et vérification ciblée. |
| [catalogue.py](catalogue.py) | Évaluation des métadonnées et export JSON. |
| [package.py](package.py) | Installation du package, également utilisée par Nix. |

Chaque script fournit `--help`. `TYPST` et `OCAML` choisissent les exécutables. Les commandes usuelles sont dans le [guide utilisateur](../docs/utilisation.md#démarrage) ; les recettes complètes dans le [justfile](../justfile).
