# Scripts Python

La logique des commandes est en Python. Just fournit des raccourcis : `just check` appelle `python3 scripts/build.py check`. Nix fournit les outils et les packages Typst aux versions verrouillées. Utiliser directement Python permet donc de se passer de Just pour compiler, sans changer le fonctionnement.

Depuis la racine du dépôt :

```sh
nix develop .
python3 scripts/build.py c chapitres/langages/exercices/residuels-minimisation.typ
python3 scripts/build.py check
```

Sans ouvrir l'environnement : `nix develop . -c python3 scripts/build.py c chemin.typ`.

## Vue d'ensemble

| Script | Rôle |
| --- | --- |
| [build.py](build.py) | Point d'entrée : compiler, générer le catalogue et la documentation, lancer les tests, nettoyer les sorties. |
| [sources.py](sources.py) | Découverte, compilation et surveillance des sources. |
| [ci.py](ci.py) | Sélection des ressources affectées par un changement Git et vérifications natives ciblées pour la CI. |
| [catalogue.py](catalogue.py) | Évaluation des métadonnées et export du catalogue JSON. |
| [package.py](package.py) | Copier l'API, les modèles et les contenus dans le répertoire des packages Typst. Utilisé aussi par Nix pour construire le package. |

Placer les tests Python de l'outillage dans `lib/tests/` et les tests des corrigés à côté des sujets. Consulter les scripts pour leur fonctionnement et `--help` pour les options disponibles.

## Commandes utiles

Préfixer les commandes suivantes par `python3 scripts/build.py` :

| Arguments | Résultat |
| --- | --- |
| `c chemin.typ` | Variantes dans `build/<chemin-sans-extension>/` : `chemin.pdf` et `chemin-cor.pdf` pour l'énoncé et le corrigé. Les cours avec présentation conservent les noms `cours-<nom>.pdf`, `cours-<nom>-cor.pdf` et `presentation-<nom>.pdf`. |
| `w chemin.typ --variant enonce` | Actualiser en continu le même PDF que `c` pour la variante choisie. Choisir explicitement `enonce`, `corrige`, `cours` ou `presentation` selon le document à relire. |
| `all` | Tous les exercices et documents, puis le catalogue. |
| `exercices` / `documents` | Seulement les exercices autonomes / les documents composés. |
| `catalogue` / `docs` | `build/catalogue.json` / `build/docs/api.pdf`. |
| `test` | Tests de l'API, du package, de la découverte et des programmes. |
| `check` | Tous les contenus, catalogue, documentation, tests et modèles. |
| `clean` | Supprimer `build/`. |

Pour les outils spécialisés :

```sh
python3 scripts/sources.py --list all
python3 scripts/catalogue.py --niveau MPI --sortie build/catalogue-mpi.json
python3 scripts/package.py
```

La dernière commande installe une copie pour Tinymist et les outils hors de Nix. Elle n'est pas nécessaire aux compilations dans l'environnement Nix. Chaque script fournit ses options avec `--help`. Les variables `TYPST` et `OCAML` permettent de choisir les exécutables utilisés par `build.py`.


## Tests des codes de copies

Un sujet conserve son code et tous ses tests dans `corrige.ml`. Ce fichier est exécuté par `just check` et peut aussi déclarer les tests des copies, exécutés par le script commun `scripts/test_copies.py` du dépôt privé. Aucun lanceur Python propre au sujet n'est nécessaire.

Placer les vérifications OCaml réutilisables dans un module `Tests`, extrait par nom. Garder les appels aux tests du corrigé en dehors de ce module. Ajouter un commentaire JSON, par exemple :

```ocaml
(* TESTS COPIES
{
  "verifications": "Tests",
  "tests": {
    "1.6": {"code": "{1.6}", "appel": "Tests.test_numero numero"},
    "1.8": {"code": "{1.6}\n{1.7}\n{1.8}", "appel": "Tests.test_partie_accessible partie_accessible"}
  },
  "references": {"1.7": "etats_accessibles"}
}
*)
```

Chaque clé désigne une question. `code` assemble les régions de la copie, indiquées entre accolades, dans l'ordre nécessaire à leur compilation ; il doit inclure la question testée. Il peut aussi ajouter une liaison, par exemple `let a2 = {1.5}`, pour une réponse qui est une expression. `appel` exécute la vérification OCaml commune au corrigé et à la copie.

`references`, facultatif, autorise explicitement le remplacement d'une dépendance absente par une déclaration nommée de `corrige.ml`. Le lanceur annonce ce remplacement ; une réponse présente est toujours utilisée telle quelle. Il compile et exécute chaque question séparément et vérifie les attentes `TEST` des copies, sans modifier leur code. Ces résultats ne constituent pas une notation automatique.
