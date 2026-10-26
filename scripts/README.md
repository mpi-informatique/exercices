# Scripts Python

Depuis la racine, `python3 scripts/build.py <action>` remplace `just <action>` ; Nix fournit les outils verrouillés :

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

## Tests des copies

Placer le code OCaml et ses tests dans `corrige.ml`, avec les vérifications réutilisables dans un module `Tests`. Le lanceur `scripts/test_copies.py` du dépôt privé lit la configuration suivante :

```ocaml
(* TESTS COPIES
{
  "verifications": "Tests",
  "tests": {
    "1.8": {"code": "{1.6}\n{1.7}\n{1.8}", "appel": "Tests.test_partie_accessible partie_accessible"}
  },
  "references": {"1.7": "etats_accessibles"}
}
*)
```

`code` assemble les réponses aux questions entre accolades, y compris celle testée ; `appel` lance la vérification. `references` autorise le remplacement annoncé d'une dépendance absente par une déclaration du corrigé. Une réponse présente reste utilisée telle quelle. Le lanceur isole chaque question et vérifie aussi les attentes `TEST`, sans modifier ni noter les copies.
