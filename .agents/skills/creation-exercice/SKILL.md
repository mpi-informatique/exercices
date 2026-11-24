---
name: creation-exercice
description: Créer, adapter, relire ou transférer un exercice, TD, TP, devoir ou sujet de concours (écrit ou oral) en Typst pour la banque mpi-informatique. Couvre l'organisation des fichiers, le circuit todo, les imports, la pédagogie, la rédaction, les notations, les barèmes, les figures et les tests.
---

# Création d'exercices et de devoirs

Appliquer ce skill en complément de [AGENTS.md](../../../AGENTS.md). Consulter les cours du thème et le [programme officiel](../../../docs/programme.md) avant de rédiger.

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

## Pédagogie et rédaction

- Réinvestir les notions du programme MP2I–MPI lorsque cela sert la progression, sans rapprochement artificiel. Introduire toute notion ou règle non exigible.
- Reprendre les notations et termes des cours du thème. Poser toutes les notations avant usage (objets, ensembles, fonctions, composantes), par exemple $A = (Σ, Q, q_0, F, δ)$ ou $G = (Σ, V, R, S)$.
- Construire une progression : exemples, résultats intermédiaires, caractérisation, applications. Demander de trouver puis justifier sans donner systématiquement le résultat attendu.
- Rédiger le corrigé avec l'énoncé. Vérifier hypothèses, cas limites, réciproques, dépendances, renvois, barème et durée. Distinguer les deux sens d'une équivalence et les étapes d'un algorithme.
- Pour une récurrence ou une induction, expliciter la propriété démontrée, le paramètre ou la structure, l'hypothèse, les cas de base et l'hérédité.
- **Exercices de mathématiques** : dans les corrigés, détailler les étapes intermédiaires non triviales des calculs et démonstrations sans sauter de grosse étape (par exemple expliciter les manipulations sur sommes partielles avant un passage à la limite ou détailler les transformations algébriques clés).
- Justifier les complexités sauf évidence. Pour une déterminisation, dessiner l'automate plutôt que donner seulement une table.
- **Français** : direct, concis, sans points-virgules dans la prose. Infinitif pour les tâches demandées à l'élève (« Donner… », « Montrer… »), verbes conjugués pour introduire objets/hypothèses/notations et rédiger les preuves (« On pose… », « Soit… », « Supposons… »). Nouveaux termes en italique. « si … alors … » sans virgule avant « alors ».
- Lors d'une relecture, proposer les questions supplémentaires avant de les intégrer. Chercher un nombre pair de pages seulement sans altérer le contenu.

## Métadonnées, concours et barème

- En mathématiques, renseigner `matiere: "mathématiques"`. Les vocabulaires autorisés sont dans `lib/meta.typ`.
- **Sujets de concours** : conserver questions, définitions et figures ensemble. Comparer le corrigé à l'original, corriger les erreurs importantes et les signaler brièvement dans `corrections`. Placer les remarques du jury dans `jury` au niveau le plus précis. Réserver `notation` aux consignes pour le correcteur (critères, pourcentages, pénalités, tolérances) sans répéter le corrigé.
- **Ordre des champs** (devoirs et concours) : énoncé, `jury`, `solution`, `bareme`, `notation`.
- **Barème indicatif** : évidence `0.25`, facile `0.5`, moyen `1`, assez difficile `2`, difficile `3`, très difficile `4` (affiner en `.5`). Répartir librement les pourcentages dans `notation` (`100 / 3` pour un tiers).

## Typst, code, figures et tests

- Utiliser `#question(bareme: 1)[Énoncé][Solution]` (second bloc facultatif) et `#partie("Titre")[...]` (`numero:` pour forcer un repère). Étiquettes stables pour les renvois (`label: <q-nom>`, puis `@q-nom`).
- Formater avec Typstyle (via Tinymist). Syntaxe native pour le contenu fixe, blocs écrits à leur emplacement d'utilisation. Apostrophe ASCII `'`, extraits délimités par accents graves avec langage indiqué, pas de point final dans les courtes listes de conditions.
- **Code** : C, OCaml, Python, SQL ou pseudocode selon le programme. Noms courts, commentaires limités aux choix ou invariants non évidents. En OCaml : indentation de 2 espaces, enregistrements et tableaux ouverts sur la ligne de déclaration (un élément par ligne si multilignes), variants et signatures courts sur une ligne (couper avant `->` si besoin).
- **Tests** : `sujet.ml` (squelette), `sujet-cor.ml` (corrigé + tests OCaml dans un module `Tests`, appels du corrigé hors de `Tests`), `sujet-test.ml` ou `sujet-test.py` si séparés. Tester quelques cas ciblés (une dizaine au besoin). Pas de `test.typ` dans les sujets de concours.
- **Figures** : dessiner en Typst avec des versions de packages fixées (`CeTZ`, `finite`, `lib/automate.typ` avec boucles et étiquettes vers l'extérieur, sans croisements).
  - Arbres : `@preview/tdtr` en liste à puces imbriquée (étiquettes d'arêtes en liste numérotée avant les fils), `text-size: 1em`.
  - Déduction naturelle : `@preview/curryst:0.6.0` (`rule` imbriqués, prémisses avant conclusion, `name:` pour la règle, `prooftree`).

## Notations

| Objet | Convention |
| --- | --- |
| Mot | « taille » (préfixes, suffixes, facteurs inclus). `m` pour un mot seul, `u`, `v` pour plusieurs mots/facteurs (sans collision). |
| Langage | `cal(L)(A)`, `cal(L)(e)`, « régulier », « non-contextuel », union d'expressions par `\|`. |
| Composition | `∘`, sans juxtaposition. |
| Formules | Espaces autour des opérateurs et après les virgules (indices et légendes inclus). Parenthéser les indices et espacer l'argument : `δ_(B) (·, σ)`, `RR_n [X]`. |
| Conditions successives | `#sep` après la virgule (espacement ordinaire dans arguments, tuples, ensembles, indices). |
| Flèches | `⟶`, `⟼`, `==>` (implication), `⟺` (équivalence). Préserver la syntaxe des langages de programmation. |
| Symboles | Unicode (`Σ`, `ε`, `∀`, `∃`…), `union.big` / `inter.big` (indexés), `∪` / `∩` (binaires). |
| Automate déterministe complet | ADC, type `adc` en code. |
| Graphe | `G = (S, A)`. |
| Déterminant / combinaison | Taille par accolade à droite seulement si utile, `binom(n, k)`. |
