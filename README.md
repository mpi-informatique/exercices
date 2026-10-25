# Exercices MPI

Ressources pédagogiques publiques de [mpi-informatique](https://github.com/mpi-informatique) pour les classes préparatoires : exercices, sujets, feuilles, devoirs, cours et présentations en Typst. Le [site web](web/README.md) permet de rechercher les exercices, d'éditer leur source et de compiler leurs PDF dans le navigateur.

## Organisation

```text
chapitres/               Contenus regroupés par chapitre
  langages/              Cours dans cours/, TD dans td/, TP dans tp/, exercices dans exercices/
  graphes/               Exercices dans exercices/
  structures/ Exercices dans exercices/
  maths/                 Exercices dans determinants/ et reduction/, feuilles à côté
devoirs/concours/        Sujets complets avec leurs solutions, codes et tests
lib/                     API Typst, figures, code et métadonnées
lib/tests/               Tests de l'API et du package
templates/               Modèles de documents
docs/                    Guide utilisateur, programme et référence de l'API
scripts/                 Découverte, compilation, catalogue et installation
shared/                  Socle TypeScript partagé avec l'extension VS Code
web/                     Site Astro, recherche et compilation Typst en WASM
nix/                     Versions et empreintes des dépendances Typst
build/                   PDF et catalogue générés, exclus de Git
```

Les consignes de création et de rédaction sont centralisées dans [Créer des exercices et des devoirs](docs/creation-exercices.md) ; les contraintes et comportements automatiques restent documentés dans le code et les modèles.

## Utilisation

Installer Nix avec `nix-command` et `flakes`, puis lancer :

```sh
nix develop . -c just check
nix develop . -c just c chapitres/langages/exercices/residuels-minimisation.typ
nix develop . -c just w chapitres/langages/exercices/residuels-minimisation.typ
```

Pour les autres commandes, lancer `just` ou consulter la [documentation des scripts](scripts/README.md). Pour les paramètres et fonctions Typst, générer la référence de l'API avec `nix develop . -c just docs`.

Pour ajouter une dépendance Typst, fixer sa version dans l'import et ajouter son archive et son empreinte à [nix/typst-packages.json](nix/typst-packages.json), avec ses dépendances. Vérifier aussi la construction isolée avec `nix flake check path:.`.

Hors de Nix, installer Typst, Just, Python 3.11 ou ultérieur et OCaml : `just check` utilise alors l'installation et le cache Typst de la machine.

Just est facultatif pour compiler : `nix develop . -c python3 scripts/build.py c chemin.typ` équivaut à `nix develop . -c just c chemin.typ`. Voir la [vue d'ensemble des scripts Python](scripts/README.md) pour leurs rôles et les commandes directes.

## Cours et présentations

Partir des modèles [cours A4](templates/cours.typ), [présentation Touying](templates/presentation.typ) ou [source commune](templates/cours-presentation.typ).
Le cours sur les [langages réguliers](chapitres/langages/cours/cours-langages.typ) génère le cours, son corrigé et la présentation sans recopier les énoncés :

```sh
nix develop . -c just c chapitres/langages/cours/cours-langages.typ
nix develop . -c just w chapitres/langages/cours/cours-langages.typ presentation
```

Voir le [guide de rédaction](docs/utilisation.md#cours-et-présentations) pour les pauses et les contenus propres à un format.

## Package Typst

Ce dépôt fournit `@mpi-informatique/exercices:0.1.0` :

```typst
#import "@mpi-informatique/exercices:0.1.0": feuille, public
#let sujet = public("devoirs/concours/19/mines-ponts-2019-mp-informatique/mines-ponts-2019-mp-informatique.typ").sujet
#show: feuille.with(titre: sujet.titre, exercices: sujet.exercices)
```

Pour les exports et les paramètres, consulter [l'API](load.typ) et ses commentaires. Dans un dépôt consommateur, verrouiller ce dépôt comme entrée Nix et utiliser sa sortie `packages.<system>.typst-packages`.

`just install` installe facultativement une copie dans le répertoire utilisateur, pour Tinymist et les compilations hors de Nix. Réinstaller après modification, et changer de version pour conserver une ancienne installation.

## Contribuer

Pour créer ou reformuler un sujet, suivre les [consignes de création d'exercices et de devoirs](docs/creation-exercices.md).

Les données nominatives, copies et évaluations appartiennent au dépôt privé `mpi-informatique/exercices-prive` et ne doivent jamais être ajoutées ici.

## Éditeur et Codespaces

Tinymist reste utilisable pour les sources et aperçus Typst. L'extension [Exercices MPI](https://github.com/mpi-informatique/vscode-mpi-exercices) utilise les scripts de compilation de la banque et partage son socle TypeScript avec le [site web](web/README.md).

La configuration [Codespaces](.devcontainer/devcontainer.json) installe Nix et recommande Tinymist.
