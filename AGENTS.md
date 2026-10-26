# Consignes pour les assistants

- Pour concevoir ou reformuler un sujet, suivre les [consignes de création](docs/creation-exercices.md). Pour les outils, consulter le [guide utilisateur](docs/utilisation.md).
- Garder les Markdown concis : une information à un seul endroit, avec des liens depuis les autres guides. Documenter les fonctions dans les commentaires `///` de `lib/`, exploités par `docs/api.typ`, plutôt que recopier leur fonctionnement dans les consignes.
- Poser les questions nécessaires en cas d'ambiguïté. Expliquer brièvement les choix importants et les changements de contenu ou de présentation.
- Ne fixer aucune longueur maximale aux lignes de code. Choisir les retours selon la structure et la lisibilité.

## Vérification et livraison

- Contenu local : compiler uniquement les variantes concernées et tester le code modifié. Bibliothèque : lancer `just check`. Annoncer les vérifications effectuées ; inspecter les PDF seulement si utile.
- Site, export ou compilation dans le navigateur : arrêter puis relancer le serveur avec `just web-stop` et `just web`, puis vérifier le comportement dans le navigateur intégré de Codex, en conservant si possible la ressource et la variante affichées.
- Fournir les liens vers les PDF générés utiles à la demande.
- Faire un commit sur la branche principale, récupérer et intégrer les commits distants, puis pousser sans forcer. Préserver les modifications de l'utilisateur.

Les commandes se lancent depuis la racine du dépôt. Si Just manque, utiliser `nix develop . -c just …` ; `just --list` décrit les recettes.
