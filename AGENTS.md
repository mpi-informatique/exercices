# Consignes communes aux deux dépôts

Ces consignes s'appliquent à `exercices` et `exercices-prive`. Le `AGENTS.md` du dépôt privé les complète pour la correction des copies. Les liens ci-dessous sont relatifs au dépôt public.

- Pour concevoir ou reformuler un sujet, suivre les [consignes de création](docs/creation-exercices.md). Pour les outils du dépôt public, consulter le [guide utilisateur](docs/utilisation.md).
- Garder les Markdown concis : une information à un seul endroit, avec des liens depuis les autres guides. Documenter les fonctions dans les commentaires `///` de `lib/` plutôt que recopier leur fonctionnement dans les consignes. La référence de l'API publique [docs/api.typ](docs/api.typ) exploite ces commentaires.
- S'inspirer du style d'écriture du professeur pour rédiger ou reformuler un contenu. Lire des passages comparables dans les cours et corrigés existants, puis en reprendre les formulations, les notations, la concision et le niveau de détail, notamment pour les solutions.
- Poser les questions nécessaires en cas d'ambiguïté. Expliquer brièvement les choix importants et les changements de contenu ou de présentation.
- Ne fixer aucune longueur maximale aux lignes de code. Choisir les retours selon la structure et la lisibilité.
- Avant toute modification, vérifier que la branche correspond au travail demandé. Prévenir l'utilisateur en cas de décalage, notamment pour du cours, de la bibliothèque ou du site sur une branche d'exercice, et proposer la branche adaptée.
- Pour travailler sur une branche différente de la branche courante, utiliser un worktree séparé. Conserver la branche et les modifications locales de l'espace de travail initial ; ne pas y changer de branche, sauf demande explicite de l'utilisateur.

## Vérification et livraison

- Pour les changements de contenu pédagogique, compiler uniquement les fichiers et variantes concernés et tester le code modifié. Pour la documentation et les consignes seules, contrôler le diff et les liens modifiés. Réserver `just check` aux changements de bibliothèque ou d'outillage. Annoncer les vérifications effectuées ; inspecter les PDF seulement si utile.
- Site, export ou compilation dans le navigateur : arrêter puis relancer le serveur avec `just web-stop` et `just web`, puis vérifier le comportement dans le navigateur intégré de Codex, en conservant si possible la ressource et la variante affichées.
- Fournir les liens vers les PDF générés utiles à la demande.
- Après les vérifications adaptées, contrôler le diff et faire un commit sur la branche adaptée au travail (`main` par défaut), récupérer et intégrer les commits distants de cette branche, puis pousser sans forcer. Préserver les modifications de l'utilisateur.

Les commandes se lancent depuis la racine du dépôt. Si Just manque, utiliser `nix develop . -c just …` ; `just --list` décrit les recettes.
