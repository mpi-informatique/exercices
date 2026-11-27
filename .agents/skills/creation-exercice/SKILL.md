---
name: creation-exercice
description: Créer, adapter ou transférer un exercice, TD, TP, devoir ou sujet de concours (écrit ou oral) en Typst pour la banque mpi-informatique. Couvre l'organisation des fichiers, le circuit todo, les imports, les métadonnées, les sujets de concours et les barèmes.
---

# Création d'exercices et de devoirs

Appliquer ce skill en complément de [AGENTS.md](../../../AGENTS.md) et du skill commun [redaction-pedagogique](../redaction-pedagogique/SKILL.md) (pédagogie, français naturel, pagination, Typst, code, figures, tests et notations). Pour la relecture ou l'amélioration d'un contenu existant, utiliser [relecture-contenu](../relecture-contenu/SKILL.md).

## Organisation et circuit de relecture

- **Vérifier les doublons** dans `exercices` et `exercices-prive/todo/` avant toute création.
- **Brouillons à relire** : préparer les nouveaux contenus dans `exercices-prive/todo/`, directement sur `main` du dépôt privé (sans branche ni worktree sauf demande explicite). Regrouper les fichiers d'un exercice ou lot avec ses variantes de TD. La présence dans `todo/` ne vaut pas autorisation de publication.
- **Intégration publique** (après validation explicite du professeur) :
  - exercices : `chapitres/<chapitre>/exercices/` (maths : sous-dossiers et feuilles sous `chapitres/maths/`)
  - TD / TP : `chapitres/<chapitre>/td/` et `chapitres/<chapitre>/tp/<id>/`
  - concours : écrits dans `devoirs/concours/<aa>/`, oraux dans `devoirs/concours/oral/<concours>/<concours>-oral-[<filiere>-]<theme>.typ` (filière MPI omise, année en métadonnées)
- **Structure** : un fichier pour un exercice simple, un dossier `<id>/` avec `<id>.typ`, code et tests s'il possède des ressources. Partir du modèle adapté dans `templates/`.
- **Réutilisation** : importer directement sans copie ni relais. Pour un extrait, exporter une partie et lire ses données avec `donnees(partie-exportee)`. Garder les introductions dans le corps et reprendre explicitement les rappels de `contexte` dans un extrait autonome.

## Imports, ressources et transfert

- Importer l'API commune via `/load.typ` dans les deux dépôts :

```typst
#import "/load.typ": exercice, question, automate, code, theoremes
#import automate: dessiner-automate
#import code: code-extrait
#import theoremes: definition, theoreme
```

- Lire les ressources voisines par chemin relatif. Extraire du code testé avec `code-extrait(read("sujet-cor.ml"), "fonction")` (tuple de noms pour plusieurs déclarations, `language: "c"` pour le C).
- Depuis le dépôt privé, charger les contenus publics avec `public(...)` et les brouillons voisins par import relatif.
- Lors d'un transfert demandé entre dépôts, déplacer le dossier complet, adapter les imports de contenus et compiler les documents concernés dans les deux dépôts (`/load.typ` reste inchangé).

## TP : squelette et tests

- **Fichier squelette** (`tp-<id>.ml`) : fournir les types, des prototypes typés (`failwith "TODO: ..."`, ou un squelette de `match` sur les questions structurantes) et une fonction `test_<nom> ()` non commentée par question de programmation (à base d'`assert`, sans imposer un détail d'implémentation comme la numérotation interne). Le squelette doit charger sans erreur dans `ocaml` / `utop`.
- **Énoncé Typst** (`tp-<id>.typ`) : indiquer en tête comment lancer `utop`, charger le fichier (`#use "tp-<id>.ml";;`) et exécuter `test_<nom> ();;`. Afficher la fonction de test juste après chaque question avec `#code-extrait(squelette, "test_<nom>")`.
- **Corrigé** (`tp-<id>-cor.ml`) : inclure un module `Tests` exécuté en fin de fichier et extrait dans l'énoncé corrigé via `#code-extrait(corrige, ...)`.

## Métadonnées, concours et barème

- En mathématiques, renseigner `matiere: "mathématiques"`. Les vocabulaires autorisés sont dans `lib/meta.typ`.
- **Sujets de concours** : conserver questions, définitions et figures ensemble. Comparer le corrigé à l'original, corriger les erreurs importantes et les signaler brièvement dans `corrections`. Placer les remarques du jury dans `jury` au niveau le plus précis. Réserver `notation` aux consignes pour le correcteur (critères, pourcentages, pénalités, tolérances) sans répéter le corrigé.
- **Ordre des champs** (devoirs et concours) : énoncé, `jury`, `solution`, `bareme`, `notation`.
- **Barème indicatif** : évidence `0.25`, facile `0.5`, moyen `1`, assez difficile `2`, difficile `3`, très difficile `4` (affiner en `.5`). Répartir librement les pourcentages dans `notation` (`100 / 3` pour un tiers).
