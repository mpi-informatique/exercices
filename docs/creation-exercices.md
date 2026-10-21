# Créer des exercices et des devoirs

Ce fichier fait autorité pour la création et la reformulation des exercices, TD, devoirs et sujets de concours, y compris par une IA. Il regroupe les choix pédagogiques, éditoriaux et les procédures propres à ces contenus. Pour utiliser les outils, consulter le [guide utilisateur](utilisation.md).

Les consignes portent sur les choix que le code ne contraint pas déjà. Pour les validations, valeurs par défaut, styles et comportements automatiques, consulter les commentaires de l'API et les modèles.

Avant toute modification, lire l'API actuelle dans [lib/exercice.typ](../lib/exercice.typ), partir des modèles et comparer les exercices existants pour éviter les doublons. Ne pas ajouter de références de provenance aux exercices ou à leur documentation.

## Organisation et réutilisation

Les contenus sont regroupés dans `chapitres/<chapitre>/` : `langages`, `graphes`, `structures`, etc. Les exercices autonomes sont dans le sous-dossier `exercices/` ; les feuilles (TD et devoirs) sont directement dans leur chapitre, par exemple `chapitres/langages/td-automate.typ`.
Les mathématiques conservent leurs sous-dossiers dans `chapitres/maths/`, notamment `determinants/` et `reduction/`. Leurs feuilles sont directement dans `chapitres/maths/`.
Les sujets écrits de concours sont dans `devoirs/concours/`, avec leur classement par année. Les exercices oraux sont dans `devoirs/concours/oral/<concours>/`, où `<concours>` est le nom en minuscules de l'une des valeurs de `concours-possibles`. Les cours et présentations sont dans leur chapitre, avec leurs ressources dans un sous-dossier voisin.

Partir des modèles [exercice](../templates/exercice.typ), [TD](../templates/feuille.typ), [devoir](../templates/devoir.typ) ou [sujet de concours](../templates/sujet-concours.typ).
Avant de créer un exercice, vérifier qu'il n'existe pas déjà dans la banque.

- Réutiliser un exercice par import direct de son fichier, sans créer de fichier relais dans les chapitres : les métadonnées permettent de le retrouver par chapitre. Réutiliser une partie en exportant une variable puis en l'important, sans copier le sujet ni rechercher une partie par numéro.
- Placer les introductions et définitions dans `contenu`. Reprendre explicitement les rappels de `contexte` dans un exercice autonome.
- Pour ajouter un type de document, partir d'un modèle dans `templates/`. Garder `feuille.with` et un `titre` littéral (ou `ex.meta.titre` pour un sujet monolithique) pour permettre la recherche sans évaluation Typst.
- Conserver le suivi individuel dans des copies séparées, liées au sujet.

Les sujets de colle sont conservés dans le dépôt privé `exercices-prive`, sous `chapitres/<chapitre>/colles/` (avec un sous-dossier annuel si nécessaire). Les exercices publics qu'ils réutilisent restent dans la banque publique et sont chargés avec `public`.

## Imports et déplacement entre dépôts

Dans les sujets, exercices, cours et modèles, importer l'API commune avec `#import "/load.typ": exercice, feuille, question` (en choisissant les noms utiles). Le dépôt public expose directement son API à ce chemin ; le dépôt privé possède un relais vers le package public verrouillé par Nix. Réserver l'import `@mpi-informatique/exercices:0.1.0` à ce relais dans le dépôt privé.

Pour les modules spécialisés, écrire par exemple :

```typst
#import "/load.typ": automate, code, theoremes
#import automate: dessiner-automate
#import code: code-extrait
#import theoremes: definition, theoreme
```

Pour afficher du code testé, extraire les déclarations par leur nom avec `code-extrait(read("corrige.ml"), "fonction")`. Un tuple de noms réunit plusieurs déclarations dans le même bloc, par exemple `code-extrait(read("corrige.ml"), ("regle", "grammaire"))`. Pour le C, ajouter `language: "c"`. `code-texte` renvoie uniquement le texte. Le package externe `code-extract` est verrouillé dans `flake.lock` et fourni par l'environnement Nix, l'installation locale et le site.

Conserver les ressources propres au sujet (images, code, tests) à côté de celui-ci et les référencer par des chemins relatifs. Lors d'un passage du privé au public demandé par l'utilisateur, déplacer le fichier ou son dossier complet : l'import de l'API commune reste identique. Vérifier les autres imports de contenus, adapter les chemins des feuilles qui réutilisent le sujet, puis lancer `just check` dans les deux dépôts. Les copies nominatives, évaluations et scans restent privés.

## Métadonnées

Consulter le [résumé du programme](programme.md) pour choisir les étiquettes définies dans [lib/meta.typ](../lib/meta.typ).

- Retenir uniquement les chapitres, structures, algorithmes et langages de programmation effectivement utilisés dans l'énoncé ou le corrigé. Utiliser `()` pour les langages lorsqu'il n'y a que du pseudocode.
- Choisir les niveaux selon les connaissances nécessaires pour résoudre l'exercice, et non selon son dossier ou la seule compatibilité des étiquettes.
- Pour un exercice de maths, renseigner `matiere: "mathématiques"`.
- N'inventer ni année ni attribution de concours. Renseigner la filière visée lorsqu'elle est connue.

## Sujets de concours et rapports du jury

- Partir de `templates/sujet-concours.typ`, dans le dossier souhaité. Garder les questions, définitions et figures dans un seul sujet.
- Nommer les exercices oraux `<concours>-oral-<filiere>-<theme>.typ`, par exemple `ens-oral-mp-automates-monoides.typ`. La filière peut être omise pour la MPI, par exemple `ccinp-oral-langages-automates.typ`. Conserver l'année dans les métadonnées. Pour un exercice avec des ressources associées, utiliser un sous-dossier du même nom sans extension.
- Comparer le corrigé au sujet original, notamment les figures et les hypothèses. Corriger directement les erreurs importantes de l'énoncé, consigner les parties/questions corrigées dans le champ `corrections` du `.typ` et expliquer brièvement le problème et/ou le changement pour chacune. Ne pas conserver deux versions contradictoires du code.
- Placer les commentaires généraux du jury dans `jury`, sous forme de liste, sans ajouter de titre ni de référence. Associer les observations locales au paramètre `jury` de la partie ou de la question concernée.
- Placer les consignes destinées au correcteur dans `notation` : celles communes à l'épreuve dans `exercice(...)`, celles propres à une question dans `question(...)`. Rester concis et préciser surtout les pourcentages de réussite, les pénalités selon les erreurs et les tolérances. Ne pas résumer le corrigé ni répéter les règles générales ; omettre ce champ sans consigne particulière. Garder les décisions nominatives dans les copies privées.
- Regrouper le sujet `<identifiant>.typ`, le code du corrigé et ses tests dans un même dossier `<identifiant>/` sous `devoirs/concours/`. Afficher le code depuis ces mêmes fichiers pour tester exactement le code publié.


## Contenu et rédaction

### Création de devoirs et d'exercices

- Créer par défaut les nouveaux exercices produits par une IA dans le dépôt privé `mpi-informatique/exercices-prive` s'il existe, sauf instruction explicite de l'utilisateur de les placer dans le dépôt public `mpi-informatique/exercices`.
- Consulter les cours correspondants dans `chapitres/`, ou dans le dépôt de cours existant pour les chapitres non encore intégrés, pour reprendre leurs notations, définitions et termes. Introduire explicitement les notions nouvelles et les résultats admis.
- Énoncer dès l'introduction les hypothèses et conventions communes à tout le sujet. Éviter « sauf mention contraire » lorsqu'aucune exception n'est prévue. Pour une généralisation ponctuelle, préciser sa portée et utiliser une notation distincte si nécessaire.
- Construire une progression : exemples, résultats intermédiaires, caractérisation, applications. Vérifier que chaque question dispose des résultats nécessaires et que les transitions entre parties sont explicites.
- Privilégier les questions qui demandent de trouver une méthode ou un résultat, puis de le démontrer ou d'en justifier la correction. Doser les indications selon la difficulté et la progression du sujet.
- Pour les relations entre objets ou opérations, demander de trouver des relations sans fournir les égalités, inclusions ou équivalences attendues dans l'énoncé.
- Rédiger le corrigé en même temps que les questions pour vérifier les hypothèses, les cas limites et la difficulté. Distinguer les deux sens d'une équivalence et préciser celui qui relève d'une récurrence ou d'une induction structurelle. Pour un algorithme, distinguer les opérations d'initialisation des itérations des boucles.
- Utiliser des exemples et contre-exemples pour éclairer les limites des résultats, notamment les réciproques fausses. Lors d'une relecture, proposer séparément les questions supplémentaires avant de les intégrer.
- Après un ajout ou un déplacement de question, vérifier les renvois dans tout le sujet, corrigé et champ `corrections` compris. Attribuer un barème aux nouvelles questions d'un devoir noté et réévaluer l'adéquation de la longueur à la durée annoncée.
- Pour les renvois internes, utiliser des étiquettes stables et `@etiquette`, plutôt qu'un numéro ou un texte de lien écrit à la main. Voir les [renvois aux blocs et aux questions](utilisation.md#renvois-aux-blocs-et-aux-questions).

### Principes de rédaction

- Lorsqu'un nouveau terme est défini, mettre ce terme en italique : par exemple, `On appelle _commutant_ de $u$…` en Typst.
- Rédiger les énoncés, corrigés et commentaires dans un français naturel, direct et concis. Éviter les tournures stéréotypées et les points-virgules dans la prose : préférer des phrases courtes ou des deux-points.
- Privilégier les formulations concises et les notations usuelles lorsqu'elles préservent la clarté : écrire « Soit $u ∈ Σ^+$ » plutôt que « Soit $u$ un mot non vide ».
- Préférer l'infinitif à l'impératif dans les consignes et commentaires : « Donner… » plutôt que « Donnez… ». Préférer « On considère… » à « Considérer… », et « Pour… : $…$ » à « Pour…, $…$ ».
- Dans les preuves et corrigés, rédiger le raisonnement avec des verbes conjugués : « Supposons… et soit $m$… », « Prenons… », « Montrons… », plutôt qu'avec des infinitifs de consigne (« Supposer… et choisir… », « Prendre… », « Montrer… »).
- Distinguer clairement les objets, les hypothèses et la conclusion à établir. Pour une implication, préférer « Montrer que si … alors … » ou « Soit … On suppose que … Montrer que … ». Éviter de présenter une hypothèse comme une affirmation générale dont le rôle n'est pas explicite.
- Écrire « si … alors … » sans virgule avant « alors ».
- Respecter le [programme](programme.md) ; de nouvelles notions peuvent être introduites dans le sujet.
- Corriger les erreurs importantes : hypothèse indispensable, énoncé faux, preuve invalide, code incorrect ou faute d'orthographe manifeste.
- Pour déterminiser, dessiner l'automate plutôt que donner seulement une table.
- Justifier les complexités, sauf mention contraire ou évidence ; poser les récurrences et séparer visuellement les implications et inclusions.
- Essayer d'obtenir un nombre pair de pages sans altérer le contenu.
- Privilégier des noms courts pour les variables et fonctions, en les commentant brièvement si leur utilité n'est pas évidente ou non introduites dans l'énoncé. Par exemple, `let c = ... (* c.(i) est la couleur du sommet i, -1 si non coloré *)` au lieu de `let couleur = ...`.

## Présentation du code

- Dans les structures de données du code (tuples, listes, tableaux, etc.), toujours mettre un espace après chaque virgule ou point-virgule séparant des éléments sur une même ligne. Préserver les retours à la ligne structurels.

- Dans tout le dépôt, ne pas imposer de longueur maximale aux lignes de code, quel que soit le langage, notamment Typst. Ne pas couper une ligne uniquement pour respecter un nombre de colonnes ou de caractères (80, 100, 120, etc.), ni ajouter une telle contrainte à un outil de formatage ou de vérification.
- Choisir les retours à la ligne selon la lisibilité et la structure logique. Préserver les retours structurels et les contraintes syntaxiques du langage.

### Code Typst

- Utiliser `question([...], solution: [...], bareme: ..., notation: [...])` pour les questions.
- Formater les sources avec Typstyle via Tinymist. La configuration VS Code du dépôt active le formatage à l'enregistrement, avec une indentation de deux espaces et sans redistribution des lignes de prose. Laisser Typstyle disposer les appels et les crochets ; ne pas fixer de largeur de ligne dans la configuration.
- Dans les fichiers `.typ`, revenir à la ligne lorsque cela facilite la lecture ou marque une articulation logique du paragraphe. Préserver les retours structurels (paragraphes, listes, titres, code et formules).
- Préférer la syntaxe Typst native pour le contenu fixe (`== Titre`, listes…) ; réserver les appels de fonctions aux éléments calculés ou réutilisables.
- Délimiter les extraits de code Typst, inline ou en bloc, par des accents graves avec le langage adéquat, par exemple ```ocaml arbre_a_mot``` ; ne pas les entourer d'apostrophes.
- Utiliser exclusivement l'apostrophe ASCII `'`, y compris dans les textes français.
- Préférer la concision sans perdre en précision. Dans les listes de conditions mathématiques courtes et les blocs de règles de grammaire, omettre les points-virgules en fin de ligne et le point final. Ponctuer les phrases rédigées.
- Commenter brièvement les éventuelles parties importantes et non évidentes du code. En particulier, commenter l'intérêt d'une nouvelle fonction/variable introduite si cela aide à la compréhension :
```ocaml
let f x = (* f x renvoie ... *)
  ...
```
- Tester le code proposé en corrigé, mais sans utiliser trop de tests. Une dizaine suffit.

### Présentation du code OCaml

- Indenter de deux espaces. Pour un enregistrement ou un tableau multiligne, placer `{` ou `[|` sur la ligne de la déclaration, puis un champ ou un élément par ligne et le délimiteur fermant sur sa propre ligne.
- Dans un enregistrement court sur une ligne, laisser une espace après `{` et avant `}`.
- Écrire les types variants courts sur une seule ligne, par exemple `type arc = Rien | Vide | Arc of etat * lettre`.
- Garder les signatures courtes sur une ligne. Si leur structure gagne à être répartie, couper avant une flèche `->` en alignant les lignes de continuation, sans seuil de longueur.

## Syntaxe

- Employer « taille » pour le nombre de lettres d'un mot, y compris pour ses préfixes, suffixes et facteurs, dans les cours, énoncés, corrigés et commentaires.

- Noter `cal(L)(A)` le langage reconnu par un automate $A$ et `cal(L)(e)` le langage dénoté par une expression régulière $e$. Appliquer cette convention dans les cours, énoncés, corrigés et commentaires.

- Noter les compositions de fonctions ou d'endomorphismes avec `∘`, par exemple `$g ∘ f = f ∘ g$`, plutôt que par juxtaposition.
- `RR_n[X]` met `[X]` en indice : utiliser plutôt `RR_n [X]`.
- Dans toutes les formules mathématiques, toujours insérer des espaces autour des opérateurs binaires et après les virgules, y compris dans les arguments et les indices : `$k + 1$`, `$n - 1$`, `$j > i$`, `$L(i, j, k + 1)$`, `$a_(i, j)$`. Cette règle concerne aussi les formules des légendes et des étiquettes de schémas. Préserver la syntaxe des exposants et des indices (`$n^3$`, `$a_i$`).
- Indiquer le nombre de colonnes d'un déterminant dessiné seulement lorsque cela clarifie sa taille : préférer une accolade à droite, par exemple `lr(mat(delim: "|", ...) brace.r) n`. Omettre cette indication si les indices rendent déjà la taille explicite ou si elle répète une indication précédente. Noter les combinaisons avec `binom(n, k)`, lu « k parmi n ».
- Noter un graphe `G = (S, A)`, où `S` est l'ensemble des sommets et `A` l'ensemble des arcs (ou des arêtes pour un graphe non orienté). Utiliser ces notations de façon cohérente dans les énoncés, corrigés et modèles.
- Pour la programmation en MP2I ou MPI, utiliser C, OCaml, Python ou SQL, dans les questions comme dans les solutions. Le pseudocode reste possible lorsqu'une question demande seulement de décrire un algorithme.
- Après une virgule séparant des conditions ou des formules, utiliser par défaut `#sep`, exporté par l'API. Importer `sep` depuis l'API commune : `#import "/load.typ": sep`, puis écrire `$∀x ∈ E, #sep P(x)$`. Conserver l'espacement ordinaire dans les arguments, tuples, ensembles et indices : `$δ(q, x)$`, `$q_(i, j)$`.
- Pour les implications, préférer la flèche longue : écrire `==>` plutôt que `=>` ou `⇒` dans les formules Typst, et `⟹` dans le texte.
- Pour les équivalences, utiliser systématiquement la flèche longue Unicode `⟺`, dans les formules Typst comme dans le texte, plutôt que `⇔` ou `<==>`.
- Utiliser les caractères Unicode pour les symboles mathématiques, par exemple `Σ` pour l'alphabet, `ε` pour le mot vide, `∪` pour l'union, `∩` pour l'intersection, `*` pour l'étoile de Kleene, `→` pour la flèche d'une fonction (sauf en programmation), `∀` et `∃` pour les quantificateurs.
- Pour les unions et intersections indexées par un ensemble, utiliser `union.big` et `inter.big`, par exemple `$union.big_(i = 1)^n A_(i)$` ou `$inter.big_(i ∈ I) A_(i)$`. Réserver `∪` et `∩` aux opérations binaires.
- Utiliser régulier au lieu de rationnel pour un langage ou expression régulière. Utiliser « non-contextuel » pour les langages et « non-contextuelle » pour les grammaires, avec les accords nécessaires, plutôt que « hors-contexte » ou « algébrique ». Utiliser | au lieu de + sur les expressions régulières.
- Utiliser si possible uniquement les fonctions autorisées par le programme dans docs/programme.md. En particulier, éviter List.fold.
- Utiliser la syntaxe OCaml au lieu de Caml light utilisé par les anciens sujets de concours. Exemple : array au lieu de vect.
- Utiliser ⊂ au lieu de ⊆.

## Présentation

Partir des modèles et utiliser les fonctions communes de `lib/` pour les documents, les blocs de code et les cadres.

- Pour un titre déjà numéroté dans la source, utiliser `heading(numbering: none, ...)`.

### Théorèmes, lemmes et définitions

Utiliser les environnements de [lib/theoremes.typ](../lib/theoremes.typ). Dans les cours, choisir les environnements numérotés (`theoreme`, `lemme`, `definition`, `algorithme`, etc.). Un titre optionnel se passe avec `titre: [Texte]`. Réserver les variantes `*-sans-numero` aux cadres volontairement sans numéro. Marquer les résultats à connaître par cœur avec `coeur: true`.

### Barème

Dans les devoirs et concours, ordonner les champs des questions ainsi : énoncé, `jury`, `solution`, `bareme`, `notation`. Placer les points dans `bareme` et détailler leur attribution en pourcentages dans `notation` lorsque la question s'y prête. Les questions ouvertes peuvent conserver des repères plus libres. Adapter les parts au nombre et au poids des critères, sans imposer des multiples de 25 % : par exemple un tiers pour chacune des trois propriétés d'une relation d'équivalence. Dans les copies, conserver les réussites en pourcentage et utiliser une expression telle que `100 / 3` pour un tiers.

```typst
question([Justifier la complexité.], solution: [ ... ], bareme: 1.5)
```

Échelle pédagogique : évidence 0.25, facile 0.5, moyen 1, assez difficile 2, difficile 3, très difficile 4. Tenir aussi compte de la longueur de la preuve ou du code ;
1.5, 2.5 et 3.5 permettent d'affiner.

## Figures

- Générer les figures (automates, arbres, graphes, schémas…) en Typst avec [CeTZ](https://typst.app/universe/package/cetz/), [finite](https://typst.app/universe/package/finite/) pour les automates, ou un autre paquet adapté.
- Conserver le code des figures dans le même fichier si possible.
- Pour les automates, utiliser l'échelle et le style communs de `lib/automate.typ`. Placer les boucles, arcs de retour et étiquettes vers l'extérieur lorsqu'il y a le choix, et éviter les croisements.
- Fixer les versions des paquets dans les imports. Préserver les informations de la figure : étiquettes, transitions, états initiaux et finaux, structure des arbres.

## Compilation et tests

```sh
nix develop . -c just check
nix develop . -c just c chapitres/langages/exercices/residuels-minimisation.typ
nix develop . -c just docs
```

Lancer `just check` avant livraison. Utiliser `just w <chemin> corrige` pour travailler sur un corrigé, ou `enonce` pour son énoncé. Les commandes directes sont décrites dans [scripts/README.md](../scripts/README.md).

Conserver les exercices simples dans un fichier `.typ`. Pour un exercice ou sujet avec des fichiers associés, créer un dossier `<identifiant>/` dans `chapitres/<chapitre>/exercices/` ou `devoirs/concours/`, en conservant le nom `<identifiant>.typ` : son nom reste l'identifiant de l'exercice. Placer le code et ses tests à côté et afficher ce même code dans le corrigé. Ajouter une vérification ciblée à `just check` si les lanceurs habituels ne la couvrent pas. Une dizaine de tests ciblés suffit.

Placer le code OCaml et tous ses tests dans `corrige.ml`, exécuté directement par `just check`. Regrouper les vérifications dans un module `Tests` pour éviter de masquer les noms du corrigé. L'extraction par nom affiche uniquement les déclarations demandées.

Pour tester aussi les copies, ajouter la configuration `TESTS COPIES` dans ce même fichier, avec `"verifications": "Tests"` et des appels `Tests.test_…`. Le lanceur extrait le module et les fonctions de référence par leur nom, sans balises `BEGIN` / `END` dans le corrigé.

Nommer les lanceurs Python `test.py`. Placer les tests généraux de l'API, de la découverte et de l'installation dans `lib/tests/`. Ne pas ajouter de `test.typ` aux sujets de
concours : conserver les tests OCaml ou Python qui vérifient le code publié dans
leurs corrigés.
