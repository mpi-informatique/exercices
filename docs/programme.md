# Programmes d'informatique et de mathématiques

Synthèse du périmètre : les programmes font foi. Les étiquettes disponibles sont dans [lib/meta.typ](../lib/meta.typ) ; les acquis de première année restent mobilisables en deuxième année.

## Mathématiques MPSI–MP2I

| Semestre | Domaines | Pages |
| --- | --- | --- |
| S1 | Raisonnement, ensembles ; calcul algébrique, trigonométrie, complexes | 6–9 |
| S1 | Calcul différentiel et intégral, primitives, équations différentielles linéaires | 10–11 |
| S1 | Réels, suites ; limites, continuité, dérivabilité, convexité | 12–16 |
| S1 | Arithmétique, structures algébriques, calcul matriciel, systèmes linéaires, polynômes, fractions rationnelles | 16–20 |
| S2 | Analyse asymptotique, espaces vectoriels, applications linéaires, matrices | 21–27 |
| S2 | Groupe symétrique, déterminants, intégration, dénombrement, probabilités finies | 28–32 |
| S2 | Espaces préhilbertiens réels, séries numériques, familles sommables, fonctions de deux variables | 33–36 |

Les déterminants comprennent les opérations élémentaires, cofacteurs, développements, Vandermonde et comatrice. Utiliser `determinants` pour les exercices actuels.
Les séries semi-convergentes se limitent aux exemples des séries alternées ;
le critère de Cauchy est hors programme. Les fonctions de deux variables introduisent le calcul différentiel repris en deuxième année.

## Mathématiques MP–MPI

| Domaines | Pages |
| --- | --- |
| Structures algébriques ; réduction des endomorphismes et matrices ; endomorphismes euclidiens | 6–10 |
| Topologie des espaces vectoriels normés ; séries numériques et vectorielles | 11–14 |
| Suites et séries de fonctions, séries entières, fonctions vectorielles | 15–17 |
| Intégration sur un intervalle quelconque, variables aléatoires discrètes | 18–24 |
| Équations différentielles linéaires, calcul différentiel et optimisation | 25–28 |

La réduction inclut polynômes annulateurs, polynôme minimal, décomposition des noyaux,
Cayley-Hamilton et sous-espaces caractéristiques. La démonstration de Cayley-Hamilton
n'est pas exigible ; la pratique de la trigonalisation n'est pas un objectif.
La topologie couvre compacité et connexité par arcs ; l'intégration inclut convergence dominée et intégrales à paramètre. Les probabilités utilisent notamment les séries
génératrices. Les équations différentielles étudiées sont linéaires.
Les déterminants triangulaires par blocs et les transvections par blocs prolongent le chapitre `determinants` de première année.

## Informatique MP2I–MPI

### Comment décider

- **Au programme** : notions et algorithmes ci-dessous, sous les limites indiquées. S1/S2 = MP2I ; S3–4 = MPI. Les acquis restent mobilisables ensuite.
- **Après rappel** : outils des annexes A.2/B.2 ; fournir un rappel et la documentation utile, ne pas supposer leur syntaxe connue.
- **Exemple** : illustration possible d'une méthode ; ne pas en faire une connaissance obligatoire. Les exemples de §4.3 ne sont ni imposés ni limitatifs.
- **Hors programme / non exigible** : respecter la restriction exacte ; une structure peut être au programme sans que toute son implémentation ou sa preuve de complexité le soit.
- **Absent de cette synthèse** : vérifier le programme avant de conclure. Une solution dérivable des méthodes du programme n'est pas interdite parce que son nom n'y figure pas ; ne pas la supposer connue.

### Notions, structures et algorithmes

| Domaine et référence | Au programme | Limites importantes |
| --- | --- | --- |
| Programmation, §1, p. 5–6, S1 | Impératif, fonctionnel ; compilation/interprétation ; flottants et précision ; terminaison, corrections partielle/totale, variants, invariants ; complexités pire cas, moyenne, amortie ; spécifications, assertions, tests, flot de contrôle et couverture. | Moyenne/amorti : exemples simples. Pas de théorie générale des paradigmes, ni GOTO. Paradigme logique seulement à propos des bases de données. Génération automatique de tests non exigible. |
| Récursivité et induction, §2, p. 7, S1/S2 | Récursivité simple/croisée, arbre d'appels, pile ; récurrences de complexité usuelles ; ordres produit, lexicographique, bien fondé ; ensembles inductifs, induction structurelle. | Justifier les récurrences par des encadrements élémentaires ; éviter le théorème-maître général. Théorie générale de la dérécursification hors programme. |
| Types, §3.1, p. 8, S1 | Types de base, pointeurs, tableaux, types composés/paramétrés ; allocation/libération ; structures abstraites et implémentations ; mutable/immuable. | Théorie du typage, classes et programmation orientée objet hors programme. |
| Structures séquentielles, §3.2, p. 8 | S1 : listes, tableaux, maillons chaînés, piles, files. S2 : tableaux associatifs par tables de hachage, sérialisation. | Construction des fonctions de hachage et gestion des collisions non exigibles. Tableaux de capacité fixée ; redimensionnement seulement évoqué. |
| Arbres, §3.3, p. 9 | S2 : arbres binaires/d'arité quelconque, conversion en binaire ; parcours préfixe/infixe/postfixe ; ABR, arbres bicolores ; tas, files de priorité, tri par tas. S3–4 : unir et trouver (Union-Find), implémentations naïves puis par arbres. | Hauteur de l'arbre vide : −1. Complexité d'Union-Find admise. Écriture technique d'arbres mutables à pointeurs non exigible, utilisation attendue. Tries, arbres de décision et dendrogrammes : exemples possibles. |
| Graphes, §3.4, p. 9, S2 | G = (S, A), orientés/non orientés, boucles, degrés, chemins, cycles, connexité/forte connexité, DAG, arbres, forêts, bipartition, poids/étiquettes ; matrices/listes d'adjacence. | Les multi-arcs ne sont pas abordés. Présentation en C à travers des tableaux statiques. |
| Probabilités et approximation, §4.1, p. 10, S3–4 | Déterministe/probabiliste, Las Vegas/Monte Carlo ; décision/optimisation, instance, coût ; notion d'algorithme d'approximation. | Définitions et exemples ; techniques générales d'approximation hors programme. |
| Exploration, §4.2, p. 10 | S2 : force brute, retour sur trace. S3–4 : séparation et évaluation. | Balayage et relaxation : illustrations possibles, pas une théorie à supposer connue. |
| Décomposition, §4.3, p. 10–11 | S2 : glouton exact, diviser pour régner, rencontre au milieu, dichotomie, programmation dynamique (mémoïsation/bas en haut, reconstruction). S3–4 : exemple d'approximation gloutonne. | Tri partition-fusion, inversions, points proches, somme d'un sous-ensemble, ordonnancement, sous-suite commune, Levenshtein, couverture et sac à dos : exemples, pas une liste d'algorithmes obligatoires. |
| Textes, §4.4, p. 11, S2 | Boyer-Moore, Rabin-Karp ; compression/décompression Huffman et Lempel-Ziv-Welch. | Boyer-Moore peut être limité à une seule fonction de décalage. Complexité précise des recherches de texte non exigible. |
| Algorithmes de graphes, §4.5, p. 11–12 | S2 : largeur/profondeur, accessibilité, tri topologique par DFS, composantes connexes ; Dijkstra avec file de priorité, Floyd-Warshall. S3–4 : Kosaraju (lien avec 2-SAT), Kruskal, couplage maximum biparti par chemins augmentants. | Couplage : approche élémentaire, **Hopcroft-Karp hors programme**. Les flots peuvent être introduits, sans imposer un algorithme de flot nommé. Ne pas substituer un catalogue d'algorithmes alternatifs à ceux cités. |
| IA et jeux, §4.6, p. 12, S3–4 | k plus proches voisins (distance euclidienne), arbres k-dimensionnels, ID3 pour arbres binaires, matrice de confusion/surapprentissage ; classification hiérarchique ascendante, k-moyennes ; jeux d'accessibilité, attracteurs, stratégies gagnantes ; min-max, alpha-bêta ; A* et heuristique admissible/monotone. | Stratégies sans mémoire. Preuve de convergence des k-moyennes hors programme. Théories sous-jacentes non attendues ; modélisation et implémentation guidées. |
| Mémoire et fichiers, §5.1–5.2, p. 13, S1 | Pile/tas mémoire, portée/durée de vie, blocs d'activation, allocation dynamique ; fichiers, blocs/inodes, liens, droits ; flux standard, redirections, tubes. | Pour les fichiers, seules ouverture/fermeture et opérations d'accès des annexes sont exigibles ; le reste relève de l'expérience pratique. Matériel, architecture, conception des systèmes, protocoles et virtualisation hors programme. |
| Concurrence, §5.3, p. 14, S3–4 | Threads, création/attente, non-déterminisme, atomicité ; Peterson à deux threads, boulangerie de Lamport ; mutex, sémaphores ; rendez-vous, producteur-consommateur, interblocage, équité. | Threads d'un même processus sur une seule machine. Algorithmes répartis, réseaux et communication asynchrone hors programme. API après rappel. |
| Logique, §6.1–6.2, p. 15, S2 | Formules, arbres, connecteurs ; quantificateurs, variables libres/liées, substitution ; valuations propositionnelles, satisfiabilité, modèles, tautologies, équivalence/conséquence ; FNC/FND ; SAT, n-SAT, Quine. | Sémantique de vérité et implémentation limitées au propositionnel. Unification et compacité hors programme. |
| Déduction naturelle, §6.3, p. 16, S3–4 | Séquents, inférence, arbres de preuve ; introduction/élimination pour ∧, ∨, ¬, → et quantificateurs ; correction dans le cas propositionnel. | Petites preuves, sans technicité ; pas d'implémentation des règles attendue. |
| Langages réguliers, §8.1, p. 18, S3–4 | Alphabet, mots, préfixe/suffixe, facteur/sous-mot ; union, concaténation, étoile ; définition inductive des langages réguliers, expressions régulières et dénotation. | Expressions étendues/POSIX : lien présenté, sans théorie supplémentaire ni connaissance de la norme exigible. |
| Automates, §8.2, p. 18, S3–4 | Déterministes/non déterministes, ε-transitions, accessibilité/coaccessibilité, émondage, déterminisation ; Glushkov par Berry-Sethi ; élimination des états, théorème de Kleene ; stabilités union/intersection finies et complément ; lemme de l'étoile. | Élimination des ε-transitions et construction de Thompson : exemples sans formalisation complète. Élimination des états : petits automates. Langages locaux et expressions linéaires seulement pour Berry-Sethi. |
| Grammaires, §8.3, p. 19, S3–4 | Non-contextuelles, productions/dérivations, langage engendré ; langages réguliers non-contextuels ; arbres d'analyse, dérivations gauche/droite, ambiguïté, équivalence faible ; exemple d'analyse syntaxique. | Descente récursive ad hoc possible. Automates à pile, grammaires générales, hiérarchie de Chomsky hors programme ; pas d'analyseurs LL/LR ni de théorie générale de l'analyse syntaxique. |
| Décidabilité/complexité, §9, p. 20, S3–4 | Décision, taille d'instance, coût temporel, P ; réductions polynomiales élémentaires ; certificats, NP, P ⊂ NP, NP-complétude ; SAT NP-complet (Cook-Levin admis) ; optimisation ramenée à la décision par seuil ; machine universelle, problème de l'arrêt. | Machines de Turing et modèles de calcul non déterministes hors programme. Modèle intuitif : programme C/OCaml sur machine à mémoire infinie. Pas de catalogue de problèmes NP-complets à mémoriser. |

### SQL : périmètre exact (§7, p. 17, S2)

- Modèle relationnel : tables, attributs, domaines simples (entier/flottant/chaîne), schémas, enregistrements ; clés primaires/étrangères, associations 1–1, 1–n, n–n.
- Requêtes : SELECT, WHERE, AS, DISTINCT, LIMIT, OFFSET, ORDER BY ; UNION, INTERSECT, EXCEPT, produit cartésien ; JOIN … ON, LEFT JOIN … ON ; MIN, MAX, SUM, AVG, COUNT, GROUP BY, HAVING ; exemples de requêtes imbriquées.
- Opérateurs : +, −, *, / ; =, <>, <, <=, >, >= ; AND, OR, NOT, IS NULL, IS NOT NULL.
- Hors programme : algèbre/calcul relationnels, index, types propres aux moteurs, dates/collations, bases non relationnelles, modèles logique/physique, méthodes formelles de modélisation, DDL/TCL/ACL, création/suppression/modification de tables, optimisation par algèbre relationnelle. Récupération des résultats depuis un programme non attendue.

### Langages et bibliothèques : ne pas supposer toute l'API connue

Le texte officiel enseigne **C et OCaml**, ainsi que **SQL** pour les données (p. 4).
Python y apparaît comme acquis du lycée, pas comme troisième langage enseigné.
La permission d'utiliser Python dans cette banque est une **convention locale**, distincte du programme.

#### C (annexe A, p. 21–22)

- **Sans rappel (A.1)** : typage statique, passage par valeur, portée, fonctions à arité fixe ; entiers signés/non signés (8/32/64 bits, int/unsigned int), double, bool, char ; opérations/comparaisons usuelles, % sur opérandes positifs ; const ; tableaux statiques et multidimensionnels ; accès aux champs de structures ; chaînes terminées par zéro, strlen/strcpy/strcat ; if/else, while, for, break ; pointeurs, adresse/déréférencement, NULL, malloc/sizeof/free, void* pour l'allocation, tableaux dynamiques et linéarisation ; assert, flux standard, printf/scanf élémentaires, include, commentaires.
- **Rappels même en A.1** : syntaxe de définition struct puis typedef lorsqu'elle doit être écrite ; formats printf/scanf non exigibles.
- **Après rappel et documentation (A.2)** : gardes d'inclusion define/ifndef/endif, argc/argv, conversions comme atoi, initialiseurs de tableaux/structures, compilation séparée ; fopen (r/w), fclose, fscanf/fprintf ; pthread_create/join (attributs par défaut, sans retour récupéré), pthread_mutex_lock/unlock/destroy ; sem_init/destroy/wait/post.
- **Limites** : pas d'arithmétique des pointeurs ; pas d'opérateurs d'incrémentation présentés ; ne pas confondre booléens et entiers ; constantes par const, pas define ; taille mémoire des structures et size_t non exigibles. Une fonction standard absente de l'annexe n'est pas automatiquement exigible.

#### OCaml (annexe B, p. 23–24)

- **Sans rappel (B.1)** : typage/inférence, polymorphisme élémentaire, portée lexicale, passage par valeur, curryfication/ordre supérieur ; let, let rec, récursivité mutuelle des fonctions, fun, if ; int/float/bool/char/string, opérations usuelles, mod positif, String.length, indexation et concaténation de chaînes ; n-uplets ; listes, constructeurs, concaténation, List.length ; tableaux, Array.length/make/copy (copie superficielle) ; option, types sommes récursifs/polymorphes, match ; unit, références, séquences, while, for … to ; begin/end ; print_int/float/string, read_int/float/line ; raise, try/with sur exceptions existantes, failwith ; accès à un module par M.f.
- **Après rappel et documentation (B.2)** : mod signé, ** ; enregistrements et champs mutables ; conversions ; List.mem/exists/for_all/filter/map/iter ; Array.make_matrix/init/mem/exists/for_all/map/iter ; types mutuellement récursifs ; alternatives de motifs, function, for … downto ; Queue/Stack.create/is_empty/push/pop et Empty ; Hashtbl.create/add/remove/mem/find/find_opt/iter, sans liaisons multiples ni randomisation ; Sys.argv ; ocamlc/ocamlopt ; open_in/out, close_in/out, input_line, output_string ; Thread.create/join ; Mutex.create/lock/unlock.
- **Attention** : Array.iteri et les fonctions fold ne figurent pas dans ces listes ; les documenter ou les définir si utilisées, ne pas les présenter comme exigibles. Une bibliothèque entière n'est jamais incluse par la seule mention de son module.

### Application à cette banque

- Consulter ce fichier avant de choisir un outil ; citer section/page lors d'une extension de [lib/meta.typ](../lib/meta.typ). Ce fichier Typst contient un vocabulaire initial, pas tout le programme. Ne pas ajouter automatiquement toutes les notions ci-dessus aux étiquettes.
- Un appel récursif seul ne justifie pas l'étiquette 'pile'. Les langages formels vont dans 'chapitres' ; les langages de programmation dans 'langages'. Les niveaux dépendent des connaissances nécessaires, pas des seules étiquettes.
- Classement : 'graphes' (§3.4/4.5), 'langages-reguliers' pour les mots et expressions (§8.1), 'recursivite-et-induction' pour l'induction structurelle (§2). Ne pas inventer d'étiquette décrivant simplement une tâche.
