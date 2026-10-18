# Toutes les commandes se lancent depuis la racine du dépôt.
set positional-arguments

python := env_var_or_default("PYTHON", "python3")

# Afficher les commandes disponibles.
default:
    @just --list

# Compiler les exercices, documents et catalogue.
all:
    {{python}} scripts/build.py all

# Compiler les exercices autonomes.
exercices:
    {{python}} scripts/build.py exercices

# Compiler les feuilles, devoirs et concours.
documents:
    {{python}} scripts/build.py documents

# Générer le catalogue JSON.
catalogue:
    {{python}} scripts/build.py catalogue

# Compiler les variantes d'une source : énoncé/corrigé ou cours/cours corrigé/présentation.
c source:
    {{python}} scripts/build.py c "$1"

# Surveiller une source, éventuellement avec une variante explicite.
w source variante="":
    {{python}} scripts/build.py w "$1" ${2:+--variant "$2"}

# Générer la documentation de l'API.
docs:
    {{python}} scripts/build.py docs

# Exécuter les tests de l'API, du package et des programmes.
test:
    {{python}} scripts/build.py test

# Tout compiler et vérifier, modèles inclus.
check:
    {{python}} scripts/build.py check

# Installer une copie du package pour les outils hors de Nix, dont Tinymist.
install:
    {{python}} scripts/package.py

# Supprimer les sorties générées.
clean:
    {{python}} scripts/build.py clean

# Lancer le site local (installe les dépendances au premier lancement).
[working-directory: 'web']
web *args:
    #!/usr/bin/env sh
    set -eu
    if [ ! -d node_modules ]; then
        nix develop ..#web -c npm ci
    fi
    exec nix develop ..#web -c npm run dev -- "$@"

# Installer ou actualiser les dépendances npm du site.
[working-directory: 'web']
web-install:
    nix develop ..#web -c npm ci

# Arrêter le serveur de développement Astro.
[working-directory: 'web']
web-stop:
    nix develop ..#web -c npx astro dev stop
