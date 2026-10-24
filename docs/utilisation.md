# Utiliser la banque

Ce guide décrit les outils et leur utilisation. Les choix pédagogiques et éditoriaux sont regroupés dans les [consignes de création](creation-exercices.md). Pour les contraintes, les valeurs par défaut et les comportements automatiques, consulter le code, les commentaires de l'API et les modèles plutôt que les recopier dans les consignes.

## Démarrage

Installer Nix avec les fonctionnalités `nix-command` et `flakes` activées.
`nix develop .` ouvre un terminal avec Typst, Just, Python et OCaml ;
`flake.lock` fixe leurs versions. Pour vérifier la banque sans ouvrir ce terminal :
`nix develop . -c just check`.
Dans un dépôt Git, Nix utilise les fichiers suivis avec leurs modifications locales et exclut les fichiers non suivis, notamment les sorties ignorées. Ajouter les nouveaux fichiers nécessaires au package avec `git add` avant de relancer Nix ; un commit n'est pas nécessaire. Éviter `path:.`, qui inclut aussi les fichiers ignorés et peut multiplier les copies volumineuses dans le store. Pour plusieurs commandes successives, ouvrir une seule fois `nix develop .`, puis lancer les commandes dans ce terminal.
Pour lancer la banque web, utiliser `just web` (ou `nix develop . -c just web`) ; `just web-stop` arrête le serveur. Voir le [guide du site](../web/README.md) pour les options et la construction statique.
L'extension [Exercices MPI](https://github.com/mpi-informatique/vscode-mpi-exercices) permet aussi de rechercher, composer et compiler les documents dans VS Code.

Ce dépôt fournit le package `@mpi-informatique/exercices:0.1.0`.
`nix develop . -c just install` installe facultativement une copie pour Tinymist et les autres outils hors de Nix. Réinstaller après une modification et changer la version dans `typst.toml` pour conserver une ancienne copie installée.
Dans un dépôt consommateur, fixer une révision de ce dépôt dans `flake.lock`.
Depuis un dépôt consommateur, importer l'API depuis le package (ou son relais local), puis `public("chemin.typ")` pour accéder aux exports d'un exercice, d'un sujet ou d'une feuille.
Lire les fichiers associés depuis le sujet avec un chemin relatif, par exemple `read("corrige.ml")`.

Les consignes de création et de reformulation sont regroupées dans [Créer des exercices et des devoirs](creation-exercices.md) : organisation des contenus, imports, métadonnées, pédagogie, rédaction, code, figures, barème et vérifications des sujets.

## Cours et présentations

Préfixer les sources de cours par `cours-`, y compris lorsqu'elles génèrent aussi une présentation : `cours-kleene.typ`, par exemple. Les PDF sont nommés `cours-kleene.pdf`, `cours-kleene-cor.pdf` et `presentation-kleene.pdf`. Un cours sans présentation produit également sa variante `-cor.pdf`.

Partir de [templates/cours.typ](../templates/cours.typ) pour un cours A4, de [templates/presentation.typ](../templates/presentation.typ) pour des diapositives, ou de [templates/cours-presentation.typ](../templates/cours-presentation.typ) pour produire les deux à partir du même contenu.

Pour personnaliser le [thème Touying Madrid](../lib/themes/madrid.typ), passer les options à `presentation.with` ou `cours-et-presentation.with`, par exemple `couleur: rgb("#233e6a"), palette: (exercise: rgb("#9a5b13"))`. Consulter la palette et les options dans [lib/presentation.typ](../lib/presentation.typ). Hors de Nix, installer New Computer Modern Sans ou choisir une police disponible avec `police: "Nom de la police"`.

```typst
#import "/load.typ": cours-et-presentation, pause, article-only, slides-only
#import "/load.typ": theoremes
#import theoremes: definition, theoreme, algorithme, exercice

#show: cours-et-presentation.with(titre: "Titre du cours", niveau: "MPI")

= Section

== Notion

#definition[
  Définition commune aux deux sorties.
]
#pause
#theoreme[
  Énoncé commun aux deux sorties.
]

== Application

#exercice[
  Appliquer le théorème.
]
#slides-only[
  #pause
  Indication à révéler pendant la présentation.
]
```

Les titres `=` structurent les grandes parties. Les titres `==` ouvrent les diapositives et deviennent des sous-sections du cours. Limiter les sous-sections du polycopié aux regroupements utiles, sans reprendre chaque titre de diapositive. Pour un titre utile uniquement à la projection, écrire :

```typst
#slides-only[== Titre]
Contenu commun aux deux formats.
```

`#slide()` ouvre une nouvelle diapositive en conservant le titre courant. Utiliser `#slide(afficher-titre: false)` pour masquer le bandeau de titre sur cette seule diapositive. Ces appels ne provoquent aucun saut dans le cours.

Utiliser `article-only[...]` pour les détails destinés au polycopié, et `slides-only[...]` pour les compléments projetés.
Ces commandes peuvent aussi entourer une section entière.

Pour disposer des contenus en colonnes dans le cours et les afficher à la suite dans la présentation, utiliser `colonnes-cours`, exporté par `/load.typ`. Les contenus ne sont écrits qu'une fois :

```typst
#colonnes-cours(
  columns: (1.15fr, 1fr),
  [Contenu de gauche.],
  [Contenu de droite.],
)
```

Passer `saut-slide: true` pour séparer les contenus par un saut de diapositive. Par défaut, ils restent sur la même diapositive.

Pour placer les deux contenus dans un même cadre, ajouter `encadrer: theoremes.exercice` à `colonnes-cours(...)`, plutôt que placer cet appel à l'intérieur du cadre : Touying doit résoudre les variantes avant le rendu du cadre.

Les fonctions des cadres utilisent des noms français (`theoreme`, `lemme`, `corollaire`, `propriete`, `exemple`, `exercice`, `probleme`, `algorithme`). Un titre se passe avec `titre: [Texte]`. Les variantes sans numéro portent le suffixe `-sans-numero`.

Les cadres de `lib/theoremes.typ` acceptent les pauses et commandes d'animation dans leur contenu : Touying les résout avant le rendu du cadre. Conserver la syntaxe à un seul bloc de contenu :

```typst
#definition[
  - Un alphabet est un ensemble fini de lettres.
  #pause
  - Un mot est une suite finie de lettres.
]
```

La présentation révèle la suite après la pause, tandis que le cours imprimé affiche la définition complète. Le numéro du cadre reste identique pendant l'animation. Pour révéler automatiquement chaque élément d'une liste, importer `item-by-item` depuis `/load.typ` et écrire `#definition(item-by-item[ ... ])` avec les éléments `- ...` dans le bloc : aucune répétition de `#pause` n'est nécessaire.

```sh
nix develop . -c just c chapitres/langages/cours/cours-langages-reguliers.typ
nix develop . -c just w chapitres/langages/cours/cours-langages-reguliers.typ cours
nix develop . -c just w chapitres/langages/cours/cours-langages-reguliers.typ corrige
nix develop . -c just w chapitres/langages/cours/cours-langages-reguliers.typ presentation
```

Pour réduire un passage uniquement dans la présentation, importer `taille-presentation` depuis `/load.typ` et écrire `#taille-presentation(0.92em)[Texte]`. La fonction utilise l'entrée `format` de la source commune ; le cours et le corrigé conservent la taille du texte environnant.

Pour compiler directement, utiliser `typst compile --root . --input format=cours source.typ cours.pdf`, ajouter `--input corrige=true` pour le corrigé, ou choisir `--input format=presentation` pour les diapositives.

Placer les réponses et preuves dans `solution[...]`, importé depuis `/load.typ` :

```typst
#exercice[Résoudre le problème.]
#solution[
  Donner la résolution et sa justification.
]
```

Ce contenu est masqué dans le cours normal et dans la présentation. Il est affiché après l'énoncé dans le cours corrigé avec le même environnement que les solutions des feuilles (`bloc-solution`). Pour afficher une solution aussi dans le cours non corrigé, écrire `#solution(cours: true)[…]` ; pour l'afficher aussi dans la présentation, écrire `#solution(presentation: true)[…]`. Les deux options peuvent se combiner. Les pauses et titres propres à la projection peuvent rester dans `slides-only[...]` à l'intérieur de la solution. Les cours ne renseignent pas automatiquement les solutions manquantes.

## Renvois aux blocs et aux questions

Utiliser une étiquette stable et la référence native `@etiquette`. Le type de bloc et son numéro sont calculés automatiquement, avec un lien vers l'énoncé, dans le cours, le corrigé et la présentation :

```typst
#theoreme[Énoncé du théorème.] <thm-concatenation>
D'après le @thm-concatenation, on obtient…
```

Pour une question construite avec l'API de la banque, fournir l'étiquette au paramètre `label` :

```typst
question([Décrire l'algorithme.], label: <q-algorithme>, solution: [Solution.]),
question([Justifier l'algorithme de la @q-algorithme.], solution: [Justification.]),
```

Le renvoi suit la numérotation après déplacement de la question, y compris dans une partie ou une feuille en colonnes. Chaque étiquette doit être unique dans le document, et sa cible doit être présente dans la variante compilée. Pour un texte de lien personnalisé, conserver `#link(<q-algorithme>)[cet algorithme]`.

## Aide de l'API

[Tinymist](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) est recommandé, mais facultatif : survoler les fonctions importées pour consulter leurs commentaires et signatures. Le code et les modèles fonctionnent sans Tinymist.

Les commentaires `///` de [lib/exercice.typ](../lib/exercice.typ) documentent les fonctions publiques, leurs paramètres et le comportement des corrigés. [lib/meta.typ](../lib/meta.typ) contient les valeurs autorisées, sans copie dans ce guide.

Générer la référence PDF avec `nix develop . -c just docs`. Consulter aussi les commentaires de [lib/presentation.typ](../lib/presentation.typ) et la mise en page commune de [lib/document.typ](../lib/document.typ).
