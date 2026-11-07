# Créer des exercices et des devoirs

Choix pédagogiques et éditoriaux de la banque. Les commandes sont dans le [guide utilisateur](utilisation.md) ; les paramètres et comportements automatiques dans les commentaires de [lib/](../lib/) et les [modèles](../templates/).

## Organisation et réutilisation

- Vérifier qu'un exercice n'existe pas déjà avant de le créer, notamment dans `exercices-prive/todo`. Choisir son emplacement selon le [circuit de relecture](#relecture-et-intégration), y compris pour les créations par IA.
- Après validation, ranger les contenus publics par chapitre : exercices dans `chapitres/<chapitre>/exercices/`, cours et TD de langages dans `cours/` et `td/`, TP dans `tp/<identifiant>/`. Les mathématiques conservent leurs sous-dossiers et leurs feuilles à la racine de `chapitres/maths/`.
- Ranger les écrits dans `devoirs/concours/` par année, les oraux dans `devoirs/concours/oral/<concours>/`. Nommer un oral `<concours>-oral-<filiere>-<theme>.typ` ; la filière MPI peut être omise. Conserver l'année dans les métadonnées.
- Garder un exercice simple dans un fichier. S'il possède des ressources, les regrouper dans un dossier `<identifiant>/` avec `<identifiant>.typ`, le code et les tests. Partir du modèle adapté.
- Réutiliser les fichiers par import direct, sans relais ni copie. Pour une réutilisation ponctuelle, exporter une partie et extraire ses données avec `donnees(partie-exportee)`. Conserver les introductions dans le corps de l’exercice ; reprendre explicitement les rappels de `contexte` dans un extrait autonome.

## Relecture et intégration

- Préparer les nouveaux exercices et les autres contenus pédagogiques en attente de relecture dans `exercices-prive/todo/`, directement sur `main` du dépôt privé. Ne pas créer de branche ni de worktree pour leur relecture, sauf demande explicite du professeur.
- Garder ensemble les fichiers d'un exercice ou d'un lot à relire, avec les éventuelles variantes de TD. Appliquer les règles d'organisation ci-dessus et les [règles d'import et de transfert](#imports-et-ressources).
- Appliquer les [consignes communes de vérification et de livraison](../AGENTS.md#vérification-et-livraison) et signaler les points à relire.
- Après validation explicite du professeur, transférer le contenu dans le chapitre ou le TD approprié du dépôt public. La compilation ne remplace pas la relecture mathématique et pédagogique.

## Colles MP

- Pour chaque préparation de colle MP, ajouter systématiquement les exercices réutilisables et leurs solutions dans le dépôt public `exercices`, sous `chapitres/maths/<theme>/`, un exercice par fichier exportant `ex`. Vérifier les doublons et réutiliser les exercices déjà présents.
- Conserver la feuille de colle dans `exercices-prive/chapitres/maths/colles/<annee>/`. Elle compose les sujets en chargeant les exercices publics avec `public("chapitres/maths/<theme>/<exercice>.typ").ex` : ne pas recopier les énoncés ni les solutions dans la feuille.
- Cette organisation, demandée par le professeur, s'applique dès la préparation des colles MP et constitue une exception à leur classement initial dans `todo/`. Les questions de cours propres à la colle, le programme reçu, l'identité du mail et le suivi restent privés. Respecter la confidentialité des contenus dont la diffusion n'est pas autorisée.
- Avant de déclarer la préparation réussie, vérifier les exercices dans le dépôt public et les imports de la feuille privée, compiler les deux variantes des fichiers concernés et consigner les chemins, révisions et vérifications dans le suivi privé. Pousser d'abord les exercices publics, actualiser la dépendance verrouillée du privé, puis pousser la feuille et son suivi.

## Confidentialité

Conserver dans le dépôt privé les identités, colles, copies nominatives, évaluations, scans et sujets dont la diffusion n'est pas autorisée. Leur présence dans `todo/` ne vaut pas autorisation de publication.

## Imports et ressources

Importer l'API commune par `/load.typ` dans les deux dépôts :

```typst
#import "/load.typ": exercice, question, automate, code, theoremes
#import automate: dessiner-automate
#import code: code-extrait
#import theoremes: definition, theoreme
```

Lire les ressources voisines par chemin relatif. Pour afficher du code testé, utiliser `code-extrait(read("corrige.ml"), "fonction")` ; un tuple de noms extrait plusieurs déclarations. Le C demande `language: "c"`.

Dans le dépôt privé, charger les contenus déjà publics avec `public(...)` et les brouillons voisins par des imports relatifs.

Lors d'un transfert entre dépôts demandé par l'utilisateur, déplacer le dossier complet, adapter les imports de contenus et compiler les documents concernés dans les deux dépôts. L'import `/load.typ` reste identique.

## Métadonnées et concours

- Consulter le [programme](programme.md). 
- Pour les mathématiques, renseigner `matiere: "mathématiques"`. 
- Pour un sujet de concours, conserver questions, définitions et figures ensemble. Comparer le corrigé à l'original, corriger les erreurs importantes et les expliquer brièvement dans `corrections`, avec les parties ou questions concernées.
- Placer les observations du jury dans `jury`, au niveau le plus précis. Réserver `notation` aux consignes utiles au correcteur : critères, pourcentages, pénalités et tolérances, sans répéter le corrigé. Garder les décisions nominatives dans les copies privées.

## Construction et rédaction

- Lors de la création d'un document pédagogique, réinvestir si possible des notions et méthodes du programme de MP2I–MPI, y compris les acquis de première année, lorsque cela sert la progression. Chercher des liens entre chapitres sans imposer de rapprochement artificiel ; consulter le [programme](programme.md) et introduire les outils non exigibles.
- Reprendre les notations et termes des cours correspondants. Introduire les notions nouvelles et les résultats admis ; préciser dès l'introduction les hypothèses communes et la portée des généralisations.
- Poser les notations avant de les utiliser dans une construction ou une preuve : objets, ensembles, fonctions, propriétés et composantes. Nommer explicitement les objets donnés et construits, par exemple $A = (Σ, Q, q_0, F, δ)$ pour un automate ou $G = (Σ, V, R, S)$ pour une grammaire, et définir leurs composantes.
- Construire une progression : exemples, résultats intermédiaires, caractérisation, applications. Demander de trouver puis de justifier les méthodes et relations, sans donner systématiquement le résultat attendu.
- Rédiger le corrigé avec l'énoncé. Vérifier hypothèses, cas limites, réciproques et dépendances entre questions ; distinguer les sens d'une équivalence et les étapes d'un algorithme.
- Pour une récurrence ou une induction, expliciter la propriété démontrée, le paramètre ou la structure sur lesquels porte la preuve et les hypothèses de récurrence ou d'induction, puis traiter les cas de base et l'hérédité.
- Après déplacement ou ajout, vérifier tous les renvois, adapter le barème et la durée. Lors d'une relecture, proposer les questions supplémentaires avant de les intégrer.
- Écrire un français direct et concis. Consignes à l'infinitif (« Donner… »), preuves avec des verbes conjugués (« Supposons… », « Montrons… »). Mettre les nouveaux termes en italique et éviter les points-virgules dans la prose.
- Distinguer hypothèses et conclusions ; écrire « si … alors … » sans virgule avant « alors ». Préférer les notations usuelles lorsqu'elles restent claires.
- Corriger les erreurs importantes. Justifier les complexités sauf évidence, séparer les implications et poser les récurrences utiles. Pour déterminiser, dessiner l'automate plutôt que donner seulement une table.
- Utiliser des étiquettes stables pour les [renvois](utilisation.md#renvois-aux-blocs-et-aux-questions). Chercher un nombre pair de pages seulement sans altérer le contenu.

## Conversion de cours

- Dans toutes les conversions de cours, placer les démonstrations et les corrigés dans `#solution[...]`, sans ajouter de titre « Preuve ».
- Ne pas réserver plusieurs lignes à compléter. Utiliser `#completer()` uniquement si la réponse tient sur une seule ligne dans le document rendu. Pour une réponse plus longue, utiliser `#solution[...]`, sans espace de réponse multiligne.

## Code et Typst

- Préserver les retours structurels des paragraphes, listes, formules et du code. Mettre une espace après les séparateurs d'éléments sur une même ligne.
- Formater le Typst avec Typstyle via Tinymist en respectant les [consignes communes sur les retours à la ligne](../AGENTS.md). Préférer la syntaxe native pour le contenu fixe et écrire les blocs à leur emplacement d'utilisation, sauf réutilisation.
- Utiliser `#question(bareme: 1)[Énoncé][Solution]` pour les questions, avec un second bloc facultatif. Écrire le corps de `exercice` et de `partie` dans un bloc `[...]`. Le style général se règle dans le modèle ; les styles locaux se placent dans l’énoncé, la solution ou un bloc de texte libre. Les titres ordinaires héritent de la numérotation du document. `#partie("Titre")[...]` est numérotée automatiquement ; `numero:` impose un repère explicite. Pour un autre titre déjà numéroté ou une introduction sans numéro, utiliser `heading(numbering: none)` ou une règle `set heading(numbering: none)` limitée au bloc concerné. Dans les cours, choisir les cadres numérotés de `theoremes` et marquer les résultats à connaître avec `coeur: true`.
- Employer des noms courts et commenter les choix ou invariants non évidents. Tester le code du corrigé avec quelques cas ciblés, une dizaine au besoin. Utiliser C, OCaml, Python, SQL ou du pseudocode, dans le périmètre précisé par le programme.
- En OCaml, indenter de deux espaces ; ouvrir les enregistrements et tableaux sur la ligne de déclaration, puis garder un champ ou élément par ligne s'ils sont multilignes. Garder les types variants et signatures courts sur une ligne ; couper avant `->` si leur structure le justifie.
- Délimiter les extraits par des accents graves et indiquer leur langage. Utiliser l'apostrophe ASCII `'`. Ponctuer les phrases, mais omettre les points finaux dans les courtes listes de conditions ou règles.

## Notations

| Objet | Convention |
| --- | --- |
| Mot | « taille », y compris pour les préfixes, suffixes et facteurs. Noter `m` un mot considéré seul ; conserver `u`, `v`, etc. pour plusieurs mots ou facteurs en jeu, et éviter les collisions avec une autre quantité déjà notée `m`. |
| Langage | `cal(L)(A)` pour l'automate, `cal(L)(e)` pour l'expression ; « régulier », « non-contextuel », union d'expressions par `\|`. |
| Composition | `∘`, sans juxtaposition. |
| Formules | Espaces autour des opérateurs et après les virgules, aussi dans les indices et légendes ; préserver exposants et indices. Parenthéser les indices et séparer par une espace la parenthèse qui introduit l'argument d'une fonction : `δ_(B) (·, σ)`. Écrire `RR_n [X]`. |
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
- Pour les arbres, utiliser [tdtr](https://typst.app/universe/package/tdtr/) avec une version fixée. Décrire la structure par une liste à puces imbriquée et les étiquettes d'arêtes par des éléments de liste numérotée avant les fils concernés, plutôt que placer manuellement les nœuds et les arêtes. Régler `text-size: 1em` pour suivre la taille du texte du cours ou de la présentation.
- Pour les preuves de déduction naturelle, utiliser [curryst](https://typst.app/universe/package/curryst/) avec une version fixée (`@preview/curryst:0.6.0`). Construire les arbres avec des appels imbriqués à `rule`, les prémisses avant la conclusion et le nom de règle dans `name`, puis les afficher avec `prooftree`.
- Pour les automates, employer le style de [lib/automate.typ](../lib/automate.typ), placer boucles et étiquettes vers l'extérieur et éviter les croisements. Préserver toutes les informations et fixer les versions des packages.
- Conserver le code OCaml et ses tests dans `corrige.ml`, les tests Python dans `test.py`, à côté du sujet. Les tests d'outillage restent dans `lib/tests/` ; ne pas ajouter de `test.typ` aux sujets de concours.
- Regrouper les vérifications OCaml dans `Tests`, avec les appels du corrigé hors de ce module.
- Choisir les vérifications selon [AGENTS.md](../AGENTS.md#vérification-et-livraison). Ajouter un test ciblé si les lanceurs habituels ne couvrent pas le nouveau code.
