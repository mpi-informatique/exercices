# Utiliser la banque

## Démarrage

Les [commandes essentielles](../README.md#démarrer) se lancent depuis la racine, dans `nix develop .`. `flake.lock` verrouille les outils et les packages Typst.

Sans ouvrir le terminal Nix, préfixer la commande par `nix develop . -c`. Les [scripts Python](../scripts/README.md) fonctionnent aussi sans Just. Hors de Nix, installer Typst, Python 3.11+, OCaml et, facultativement, Just.

Nix inclut les fichiers suivis avec leurs modifications locales : ajouter les nouveaux fichiers nécessaires avec `git add` avant de compiler. Éviter `path:.` en usage courant, car il inclut aussi les sorties ignorées. Pour plusieurs commandes, garder le même terminal Nix.

## Package et dépendances

Dans les contenus et modèles, importer les fonctions utiles depuis `/load.typ`. Le dépôt privé utilise ce même chemin comme relais vers le package public.

Dans un autre dépôt, verrouiller cette banque comme entrée Nix et utiliser sa sortie `packages.<system>.typst-packages`. Pour réutiliser un contenu public :

```typst
#import "@mpi-informatique/exercices:0.1.0": feuille, public
#let sujet = public("devoirs/concours/19/mines-ponts-2019-mp-informatique/mines-ponts-2019-mp-informatique.typ").sujet
#show: feuille.with(titre: sujet.titre, exercices: sujet.exercices)
```

`just install` installe facultativement une copie pour Tinymist et les outils hors de Nix. Réinstaller après modification ; changer la version pour conserver une ancienne installation.

Pour ajouter un package Typst, fixer sa version dans l'import et enregistrer son archive, son empreinte et ses dépendances dans [nix/typst-packages.json](../nix/typst-packages.json), puis vérifier avec `nix flake check path:.`.

## Cours et présentations

Partir des modèles [cours A4](../templates/cours.typ), [présentation](../templates/presentation.typ) ou [source commune](../templates/cours-presentation.typ). Nommer les sources `cours-<nom>.typ` : elles produisent le cours, son corrigé et, si disponible, `presentation-<nom>.pdf`.

```typst
#import "/load.typ": cours-et-presentation, pause, solution, slides-only
#import "/load.typ": theoremes
#import theoremes: definition, exercice

#show: cours-et-presentation.with(titre: "Titre du cours", niveau: "MPI")

= Section
== Notion
#definition[
  Première propriété.
  #pause
  Deuxième propriété.
]
#slides-only[== Application]
#exercice[Résoudre le problème.]
#solution[Résolution et justification.]
```

Les titres `=` structurent les parties ; `==` ouvre une diapositive. Réserver les sous-sections du polycopié aux regroupements utiles. `article-only` et `slides-only` isolent les contenus propres à un format.

Consulter [lib/presentation.typ](../lib/presentation.typ) pour les sauts, animations, colonnes et options du thème ; [lib/cours.typ](../lib/cours.typ) pour les solutions et espaces de réponse. Ces fonctions sont aussi décrites dans la référence générée par `just docs`.

## Algorithmes

Les listes imbriquées de `theoremes.algorithme` représentent les blocs du pseudocode :

```typst
#algorithme[
  + $s ← 0$
  + *Pour chaque* $x ∈ X$ :
    + $s ← s + x$
  + *Renvoyer* $s$.
]
```

## Renvois aux blocs et aux questions

Utiliser des étiquettes stables et les références natives :

```typst
#theoreme[Énoncé.] <thm-concatenation>
D'après le @thm-concatenation…
```

Pour une question, passer `label: <q-algorithme>` à `question(...)`, puis écrire `@q-algorithme`. L'étiquette doit être unique et sa cible présente dans la variante compilée. `link(<q-algorithme>)[cet algorithme]` personnalise le texte du lien.

## Références

Les commentaires `///` de [lib/](../lib/) décrivent les fonctions et sont accessibles au survol dans Tinymist. Les valeurs autorisées des métadonnées sont dans [lib/meta.typ](../lib/meta.typ). Les choix pédagogiques et éditoriaux sont dans les [consignes de création](creation-exercices.md).
