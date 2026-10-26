# Exercices MPI

Banque publique d'exercices, sujets, TD, TP, cours et présentations en Typst pour les classes préparatoires. Le [site](https://mpi-informatique.github.io/exercices/) permet de rechercher, modifier et compiler les ressources dans le navigateur.

## Démarrer

Installer Nix avec `nix-command` et `flakes`, puis compiler une ressource :

```sh
nix develop . -c just c chapitres/langages/exercices/residuels-minimisation.typ
```

| Besoin | Référence |
| --- | --- |
| Compiler, surveiller, utiliser le package | [Guide utilisateur](docs/utilisation.md) |
| Créer ou reformuler un sujet | [Consignes de rédaction](docs/creation-exercices.md) |
| Vérifier le périmètre du programme | [Programme](docs/programme.md) |
| Consulter les fonctions Typst | Commentaires de [lib/](lib/) ; PDF généré par `just docs` |
| Utiliser les scripts sans Just | [Scripts Python](scripts/README.md) |
| Développer ou déployer le site | [Site web](web/README.md) |
| Configurer la connexion GitHub | [Worker OAuth](worker/README.md) |

## Organisation

- `chapitres/` : contenus par chapitre ; `devoirs/concours/` : sujets écrits et oraux avec leurs ressources.
- `lib/`, `load.typ`, `templates/` : API et modèles Typst.
- `scripts/`, `nix/`, `lib/tests/` : compilation, dépendances verrouillées et tests.
- `web/`, `shared/`, `worker/` : site, socle commun avec VS Code et connexion GitHub.
- `build/` : sorties générées, exclues de Git.

Le dépôt fournit `@mpi-informatique/exercices:0.1.0`. L'extension [Exercices MPI](https://github.com/mpi-informatique/vscode-mpi-exercices) et Tinymist permettent de travailler dans VS Code ; [Codespaces](.devcontainer/devcontainer.json) prépare l'environnement.

Les copies nominatives et les évaluations restent dans le dépôt privé `exercices-prive`.
