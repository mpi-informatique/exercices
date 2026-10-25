# Consignes pour les assistants

Lire et appliquer les [consignes de création d'exercices et de devoirs](docs/creation-exercices.md) pour concevoir ou reformuler un sujet. Consulter le [guide utilisateur](docs/utilisation.md) pour les outils. Ne pas recopier leurs règles ici.

Les consignes doivent porter uniquement sur les choix et procédures que le code ne contraint pas déjà. Ne pas recopier les validations, valeurs par défaut, styles ou comportements automatiques : renvoyer aux sources, aux commentaires de l'API ou aux modèles. Appliquer ce principe à toute mise à jour des instructions.

## Travail avec l'utilisateur

- Poser les questions nécessaires ; ne pas choisir silencieusement en cas d'ambiguïté.
- Expliquer brièvement les choix importants, rester concis et refactoriser les abstractions inutiles.
- Avertir l'utilisateur des changements de présentation ou de contenu.

## Commandes utiles

Depuis la racine du dépôt `exercices/`, utiliser les recettes du [justfile](justfile). Si Just n'est pas disponible dans le terminal, remplacer `just …` par `nix develop . -c just …`.

| Commande | Usage |
| --- | --- |
| `just --list` | Afficher les commandes disponibles. |
| `just web --open` | Lancer le site local et l'ouvrir dans le navigateur. |
| `just web --port 4322 --open` | Choisir un autre port et ouvrir le site. |
| `just web-stop` | Arrêter le serveur local. |
| `just web-install` | Actualiser les dépendances du site après une modification de celles-ci. |
| `just c chemin/source.typ` | Compiler les variantes d'un exercice ou d'un document. |
| `just w chemin/source.typ corrige` | Surveiller une source et recompiler son corrigé à chaque modification. |
| `just docs` | Générer la référence de l'API. |

Voir le [guide du site](web/README.md) pour les autres options web et la [documentation des scripts](scripts/README.md) pour la compilation.

## Vérification et livraison

- Réserver la vérification dans le navigateur aux changements du site, de l'export des ressources ou de la compilation dans le navigateur. Pour ces changements, arrêter puis relancer le serveur local avec les recettes `web-stop` et `web`, et ouvrir son URL locale dans le navigateur intégré de Codex. Conserver si possible l'exercice et la variante affichés et vérifier le comportement modifié avant de livrer.
- Pour une modification locale d'un exercice, d'un cours ou d'un sujet, compiler uniquement les variantes concernées et exécuter les éventuels tests du code modifié. Il n'est pas nécessaire de relancer le serveur ni de tester le site dans le navigateur.
- Réserver `nix develop . -c just check` aux modifications de la bibliothèque (`lib/`). Une modification locale de contenu ou d'instructions ne nécessite pas de vérification du dépôt entier. Annoncer les vérifications réellement effectuées.
- N'inspecter les PDF générés que si c'est vraiment utile.
- Communiquer les fichiers modifiés et les corrections, avec des liens cliquables vers les PDF d'énoncé et de corrigé lorsqu'ils ont été générés.
- Pour chaque modification, faire un commit directement sur la branche principale, puis synchroniser avec le dépôt distant : récupérer et intégrer les éventuels commits distants, puis pousser les commits locaux, sans push forcé.
