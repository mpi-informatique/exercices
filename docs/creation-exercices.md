# Créer des exercices et des devoirs

Choix pédagogiques et éditoriaux de la banque. Les commandes sont dans le [guide utilisateur](utilisation.md) ; les paramètres et comportements automatiques dans les commentaires de [lib/](../lib/) et les [modèles](../templates/).

## Organisation et réutilisation

- Vérifier qu'un exercice n'existe pas déjà avant de le créer. Choisir le dépôt et la branche selon le [circuit de relecture](#relecture-et-intégration), y compris pour les créations par IA.
- Ranger les contenus par chapitre : exercices dans `chapitres/<chapitre>/exercices/`, cours et TD de langages dans `cours/` et `td/`, TP dans `tp/<identifiant>/`. Les mathématiques conservent leurs sous-dossiers et leurs feuilles à la racine de `chapitres/maths/`.
- Ranger les écrits dans `devoirs/concours/` par année, les oraux dans `devoirs/concours/oral/<concours>/`. Nommer un oral `<concours>-oral-<filiere>-<theme>.typ` ; la filière MPI peut être omise. Conserver l'année dans les métadonnées.
- Garder un exercice simple dans un fichier. S'il possède des ressources, les regrouper dans un dossier `<identifiant>/` avec `<identifiant>.typ`, le code et les tests. Partir du modèle adapté.
- Réutiliser les fichiers par import direct, sans relais ni copie. Exporter une variable pour une partie réutilisable, plutôt que la chercher par numéro. Conserver les introductions dans `contenu` ; reprendre explicitement les rappels de `contexte` dans un extrait autonome.
- Garder les colles, copies nominatives, évaluations et scans dans le dépôt privé. Les contenus publics s'y chargent avec `public`.

## Relecture et intégration

- Créer les exercices destinés au public dans une branche du dépôt public dès lors que leur version provisoire peut être publique. Le dépôt privé ne sert plus de zone d'attente pour leur relecture. Une branche publique et une pull request en brouillon sont publiques.
- Réserver le dépôt privé aux contenus confidentiels et aux sujets dont la diffusion doit attendre une date ou une validation, même s'ils seront publics ensuite.
- Partir de `main` à jour et utiliser une branche par unité de travail cohérente : un exercice indépendant avec son corrigé et ses ressources, ou un lot à relire ensemble, par exemple un TD. Nommer la branche `exo/<identifiant>` ou `td/<identifiant>` et poursuivre sur la même branche pendant la relecture.
- Si plusieurs sessions travaillent simultanément, utiliser un worktree distinct par branche. Préserver les modifications en cours de l'utilisateur.
- Compiler les variantes concernées et tester le code du corrigé, puis committer et pousser la branche sans forcer. Fournir son nom, les PDF utiles et les points à relire ; si une pull request est créée avant validation, la laisser en brouillon.
- Garder `main` pour les contenus relus et validés. La compilation ne remplace pas la relecture mathématique et pédagogique. Attendre la validation explicite du professeur avant de fusionner ; supprimer ensuite la branche devenue inutile.

## Imports et ressources

Importer l'API commune par `/load.typ` dans les deux dépôts :

```typst
#import "/load.typ": exercice, question, automate, code, theoremes
#import automate: dessiner-automate
#import code: code-extrait
#import theoremes: definition, theoreme
```

Lire les ressources voisines par chemin relatif. Pour afficher du code testé, utiliser `code-extrait(read("corrige.ml"), "fonction")` ; un tuple de noms extrait plusieurs déclarations. Le C demande `language: "c"`.

Lors d'un transfert entre dépôts demandé par l'utilisateur, déplacer le dossier complet, adapter les imports de contenus et compiler les documents concernés dans les deux dépôts. L'import `/load.typ` reste identique.

## Métadonnées et concours

- Consulter le [programme](programme.md). 
- Pour les mathématiques, renseigner `matiere: "mathématiques"`. 
- Pour un sujet de concours, conserver questions, définitions et figures ensemble. Comparer le corrigé à l'original, corriger les erreurs importantes et les expliquer brièvement dans `corrections`, avec les parties ou questions concernées.
- Placer les observations du jury dans `jury`, au niveau le plus précis. Réserver `notation` aux consignes utiles au correcteur : critères, pourcentages, pénalités et tolérances, sans répéter le corrigé. Garder les décisions nominatives dans les copies privées.

## Construction et rédaction

- Reprendre les notations et termes des cours correspondants. Introduire les notions nouvelles et les résultats admis ; préciser dès l'introduction les hypothèses communes et la portée des généralisations.
- Construire une progression : exemples, résultats intermédiaires, caractérisation, applications. Demander de trouver puis de justifier les méthodes et relations, sans donner systématiquement le résultat attendu.
- Rédiger le corrigé avec l'énoncé. Vérifier hypothèses, cas limites, réciproques et dépendances entre questions ; distinguer les sens d'une équivalence et les étapes d'un algorithme.
- Après déplacement ou ajout, vérifier tous les renvois, adapter le barème et la durée. Lors d'une relecture, proposer les questions supplémentaires avant de les intégrer.
- Écrire un français direct et concis. Consignes à l'infinitif (« Donner… »), preuves avec des verbes conjugués (« Supposons… », « Montrons… »). Mettre les nouveaux termes en italique et éviter les points-virgules dans la prose.
- Distinguer hypothèses et conclusions ; écrire « si … alors … » sans virgule avant « alors ». Préférer les notations usuelles lorsqu'elles restent claires.
- Corriger les erreurs importantes. Justifier les complexités sauf évidence, séparer les implications et poser les récurrences utiles. Pour déterminiser, dessiner l'automate plutôt que donner seulement une table.
- Utiliser des étiquettes stables pour les [renvois](utilisation.md#renvois-aux-blocs-et-aux-questions). Chercher un nombre pair de pages seulement sans altérer le contenu.

## Code et Typst

- Préserver les retours structurels des paragraphes, listes, formules et du code. Mettre une espace après les séparateurs d'éléments sur une même ligne.
- Formater le Typst avec Typstyle via Tinymist, sans largeur de ligne imposée. Préférer la syntaxe native pour le contenu fixe et écrire les blocs à leur emplacement d'utilisation, sauf réutilisation.
- Utiliser `question(...)` pour les questions. Pour un titre déjà numéroté, désactiver sa numérotation automatique. Dans les cours, choisir les cadres numérotés de `theoremes` et marquer les résultats à connaître avec `coeur: true`.
- Employer des noms courts et commenter les choix ou invariants non évidents. Tester le code du corrigé avec quelques cas ciblés, une dizaine au besoin. Utiliser C, OCaml, Python, SQL ou du pseudocode, dans le périmètre précisé par le programme.
- En OCaml, indenter de deux espaces ; ouvrir les enregistrements et tableaux sur la ligne de déclaration, puis garder un champ ou élément par ligne s'ils sont multilignes. Garder les types variants et signatures courts sur une ligne ; couper avant `->` si leur structure le justifie.
- Délimiter les extraits par des accents graves et indiquer leur langage. Utiliser l'apostrophe ASCII `'`. Ponctuer les phrases, mais omettre les points finaux dans les courtes listes de conditions ou règles.

## Notations

| Objet | Convention |
| --- | --- |
| Mot | « taille », y compris pour les préfixes, suffixes et facteurs. |
| Langage | `cal(L)(A)` pour l'automate, `cal(L)(e)` pour l'expression ; « régulier », « non-contextuel », union d'expressions par `\|`. |
| Composition | `∘`, sans juxtaposition. |
| Formules | Espaces autour des opérateurs et après les virgules, aussi dans les indices et légendes ; préserver exposants et indices. Écrire `RR_n [X]`. |
| Conditions successives | `#sep` après la virgule ; espacement ordinaire dans les arguments, tuples, ensembles et indices. |
| Flèches | `⟶`, `⟼`, `==>` pour l'implication, `⟺` pour l'équivalence ; préserver la syntaxe des langages de programmation. |
| Symboles | Unicode (`Σ`, `ε`, `∀`, `∃`…) ; `union.big` et `inter.big` pour les opérations indexées, `∪` et `∩` pour les opérations binaires. |
| Automate déterministe complet | ADC, et `adc` pour le type dans le code. |
| Graphe | `G = (S, A)`. |
| Déterminant et combinaison | Indiquer la taille seulement si utile, par une accolade à droite ; `binom(n, k)`. |

## Barème

Dans les devoirs et concours, ordonner les champs : énoncé, `jury`, `solution`, `bareme`, `notation`. Donner les points dans `bareme` et, si utile, leur répartition en pourcentages dans `notation`. Adapter les parts aux critères sans imposer des multiples de 25 % ; conserver les pourcentages dans les copies (`100 / 3` pour un tiers).

Échelle indicative : évidence 0.25, facile 0.5, moyen 1, assez difficile 2, difficile 3, très difficile 4 ; affiner avec 1.5, 2.5 ou 3.5 selon la longueur et la difficulté.

## Figures et tests

- Dessiner en Typst avec CeTZ, finite ou un package adapté, dans le fichier du sujet.
- Pour les automates, employer le style de [lib/automate.typ](../lib/automate.typ), placer boucles et étiquettes vers l'extérieur et éviter les croisements. Préserver toutes les informations et fixer les versions des packages.
- Conserver le code OCaml et ses tests dans `corrige.ml`, les tests Python dans `test.py`, à côté du sujet. Les tests d'outillage restent dans `lib/tests/` ; ne pas ajouter de `test.typ` aux sujets de concours.
- Regrouper les vérifications OCaml dans `Tests`, avec les appels du corrigé hors de ce module.
- Choisir les vérifications selon [AGENTS.md](../AGENTS.md#vérification-et-livraison). Ajouter un test ciblé si les lanceurs habituels ne couvrent pas le nouveau code.
