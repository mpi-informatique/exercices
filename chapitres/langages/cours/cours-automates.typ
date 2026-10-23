#import "/load.typ": slide
#import "/load.typ": (
  article-only, automate, colonnes-cours, cours-et-presentation, pause, completer, sep, slides-only, solution, theoremes,
)
#import theoremes: algorithme, definition, exercice, lemme, theoreme
#import automate: cetz, dessiner-automate, finite, style-automates, unite-automates
#import "@preview/touying:0.8.0": touying-reducer

#show: cours-et-presentation.with(titre: "Automates", niveau: "MPI")

#let exemple = dessiner-automate(
  (("0", (0, 0), true, false), ("1", (3, 0), false, false), ("2", (6, 0), false, true)),
  (
    ("0", "0", "a", (:)),
    ("0", "1", "b", (curve: 0.4)),
    ("1", "0", "a", (curve: 0.4)),
    ("1", "2", "a", (curve: 0)),
    ("2", "2", "b", (:)),
  ),
)
#let impair = dessiner-automate(
  (("0", (0, 0), true, false), ("1", (3, 0), false, true)),
  (("0", "0", "b", (:)), ("1", "1", "b", (:)), ("0", "1", "a", (curve: 0.5)), ("1", "0", "a", (curve: 0.5))),
)
#let deux-initiaux = dessiner-automate(
  (("0", (0, 0.9), true, false), ("1", (0, -0.9), true, false), ("2", (3, 0), false, true)),
  (
    ("0", "0", "a", (:)),
    ("1", "1", "b", (anchor: bottom)),
    ("0", "2", "b", (curve: 0)),
    ("1", "2", "a", (curve: 0)),
  ),
)
#let facteur = dessiner-automate(
  (("0", (0, 0), true, false), ("1", (3, 0), false, false), ("2", (6, 0), false, false), ("3", (9, 0), false, true)),
  (
    ("0", "0", "a, b", (:)),
    ("0", "1", "a", (curve: 0)),
    ("1", "2", "b", (curve: 0)),
    ("2", "3", "b", (curve: 0)),
    ("3", "3", "a, b", (:)),
  ),
)

= Automate non déterministe

#let definition-automate = definition(marge-haute: false)[
  Un automate est un $5$-uplet $A = (Σ, Q, I, F, E)$ où :
  - $Σ$ est un alphabet.
  - $Q$ est un ensemble fini d'états.
  - $I ⊂ Q$ est l'ensemble des états initiaux.
  - $F ⊂ Q$ est l'ensemble des états finaux, ou acceptants.
  - $E ⊂ Q × Σ × Q$ est l'ensemble des transitions.
]

#let exemple-automate = figure(exemple, numbering: none, caption: [
  $Σ = {a, b}, Q = {0, 1, 2}, I = {0}, F = {2}$\
  $E = {(0, a, 0), (0, b, 1), (1, a, 0), (1, a, 2), (2, b, 2)}$
])

#article-only[
  #grid(columns: (1.2fr, 1fr), column-gutter: 1.5em, align: top, definition-automate, exemple-automate)
]
#slides-only[
  #definition-automate
  #slide()
  #exemple-automate
]

// #exercice[
//   En notant $n = |Q|$ et $p = |Σ|$, combien existe t-il d'automates à $Σ$ et $Q$ fixés ?
// ]

== Fonction de transition
#let definition-transition = [
  #definition(marge-haute: false)[
    On peut remplacer $E$ par  $δ : Q × Σ → cal(P)(Q)$ tel que :
    $ δ(q, a) = {q' ∈ Q ∣ (q, a, q') ∈ E}. $
  ]
  On dit qu'il y a un blocage lorsque $δ(q, a) = ∅$.
]
#let exercice-transition = align(center, figure(
  table(
    columns: (auto, ..(3em,)*3),
    rows: 1.75em,
    align: center + horizon,
    table.header($q$, ..range(0, 3).map(str)),
    [$δ(q, a)$], ..(completer(),)*3,
    [$δ(q, b)$], ..(completer(),)*3,
  ),
  caption: none,
))

#colonnes-cours(
  columns: (1.2fr, 1fr),
  definition-transition,
  exercice-transition,
)

== Implémentation

#exercice[
  1. Rappeler la définition des structures de données abstraites de dictionnaire et d'ensemble.
  2. Comment s'en servir pour représenter un automate ?
  3. Proposer deux implémentations de ces structures de données.
]

= Langage reconnaissable

#definition[
  Un chemin $C$ dans un automate $A$ est une suite de transitions consécutives :
  $q_0 limits(arrow.long)^(a_1) q_1 limits(arrow.long)^(a_2) … limits(arrow.long)^(a_n) q_n.$\
  L'étiquette de $C$ est le mot $a_1 … a_n$.
  On dit que $C$ est acceptant si $q_0 ∈ I$ et $q_n ∈ F$.
]

#underline[Remarque] : il suffit d'un chemin acceptant pour que $m in cal(L)(A)$, même si un autre chemin d'étiquette $m$ n'est pas acceptant.

#slide()
#definition[
  Un mot est accepté par $A$ s'il est l'étiquette d'un chemin acceptant.
  Le langage $cal(L)(A)$ reconnu par $A$ est l'ensemble des mots acceptés.
  Un langage est reconnaissable s'il est reconnu par un automate.
]

#slide()
#exercice[Déterminer les langages reconnus par les automates suivants.]
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  align: horizon,
  figure(impair, numbering: none, gap: 0.4em, caption: [$A_1$]),
  figure(deux-initiaux, numbering: none, gap: 0.4em, caption: [$A_2$]),
)

#slides-only[
  #slide()
  À gauche : les mots contenant un nombre impair de $a$, par exemple $b b a b$.

  À droite : $a^* b | b^* a$.
  Chaque état initial correspond à l'une des deux branches de l'union.
]

#slide()

#colonnes-cours(
  encadrer: contenu => exercice[
    Montrer que les langages suivants sont reconnaissables :
    #contenu
  ],
  [
    + $a b | a b c | c$
    + Mots de taille paire sur $Σ = {a, b}$.
  ],
  [
    #set enum(start: 3)
    + $(b | a b | a b a)^*$
    + Mots sur $Σ = {a, b}$ dont l'avant-dernière lettre est $a$.
  ],
)

= Test d'appartenance

Pour déterminer si $m = m_1 … m_n in cal(L)(A)$, on peut calculer l'ensemble des états atteignables après lecture de $m[:k]$ :
$ Q_0 = I, quad Q_k = union.big_(q ∈ Q_(k - 1)) δ(q, m_k). $
Alors $m ∈ cal(L)(A)$ si et seulement si $Q_n ∩ F ≠ ∅$.

#slide()
#exercice[
  + Quelle est la complexité de cette méthode, en temps et mémoire ?
  + Proposer une autre méthode par mémoïsation. Comparer les deux méthodes.
]
#solution[
]

= Automate complet

#definition[
  Deux automates sont équivalents s'ils reconnaissent le même langage.
  Un automate est complet si :
  $ ∀ q ∈ Q, #sep ∀ a ∈ Σ, #sep ∃ q' ∈ Q, #sep (q, a, q') ∈ E. $
]
Un automate complet n'a pas de blocage.
#slide()
#theoreme[Tout automate est équivalent à un automate complet.]

= Automate déterministe (AD)

#grid(
  columns: (1.6fr, 1fr),
  column-gutter: 1.5em,
  align: horizon,
  definition(coeur: true, marge-haute: false)[
    Un automate est déterministe si :
    + Il possède un unique état initial
    + $(q, a, q_1) ∈ E ∧ (q, a, q_2) ∈ E ==> q_1 = q_2$
  ],
  figure(
    dessiner-automate(
      (("q", (0, 0), false, false), ("q_1", (2.5, 1), false, false), ("q_2", (2.5, -1), false, false)),
      (("q", "q_1", "a", (curve: 0)), ("q", "q_2", "a", (curve: 0))),
    ),
    numbering: none,
    caption: [Automate non déterministe],
  ),
)

Un ADC (automate déterministe complet) a $|Q| × |Σ|$ transitions et une fonction de transition de la forme $δ : Q × Σ → Q$.

#slide()
#exercice[
  Soient $A = (Q, Σ, q_0, F, E)$ un AD, $q ∈ Q$, $m ∈ Σ^*$. Quelles sont les propositions vraies ?
  + $(q_1, a, q) ∈ E ∧ (q_2, a, q) ∈ E ==> q_1 = q_2.$
  + $A$ contient au plus un chemin d'étiquette $m$ partant de $q$.
  + $A$ contient au plus un chemin de $q_0$ à $q$.
  + $A$ est non ambigu : un mot de $cal(L)(A)$ a un unique chemin acceptant.
  + Si $A'$ est non ambigu alors $A'$ est déterministe.
]

#slide()
#definition[
  Pour un automate déterministe complet, on définit $δ^* : Q × Σ^* → Q$ récursivement, pour $q ∈ Q$ :
  - $δ^*(q, ε) = q$
  - $∀ a ∈ Σ, m ∈ Σ^* : #sep δ^*(q, a m) = δ^*(δ(q, a), m)$
]
$δ^*(q, u)$ est l'état atteint après lecture de $u$ depuis $q$.
On a $u ∈ cal(L)(A) <==> δ^*(q_i, u) ∈ F$.
#slide()
#theoreme[$∀q ∈ Q, u, v ∈ Σ^* : #sep δ^*(q, u v) = δ^*(δ^*(q, u), v)$.] <thm-delta-etoile>

#slide()
#exercice[
  Soit $A$ un automate déterministe complet à $n$ états sur un alphabet $Σ$.
  Montrer que si $A$ accepte tous les mots de taille strictement inférieure à $n$, alors $cal(L)(A) = Σ^*$.
  La borne est-elle optimale ?
]
#solution[
  #slide()
  Supposons $cal(L)(A) ≠ Σ^*$ et soit $m ∈ Σ^* \\ cal(L)(A)$ de taille minimale.
  Par hypothèse, $abs(m) ≥ n$.
  Parmi les états atteints après lecture de ses $n + 1$ premiers préfixes, deux sont égaux.
  On peut donc écrire $m = x y z$, avec $y ≠ ε$, et
  $ δ^*(q_0, x) = δ^*(q_0, x y). $
  @thm-delta-etoile donne $ δ^*(q_0, x z) = δ^*(δ^*(q_0, x), z) = δ^*(δ^*(q_0, x y), z) = δ^*(q_0, m). $
  Donc $x z ∉ cal(L)(A)$ et $|x z| < |m|$, ce qui contredit la minimalité de $m$.

  #slide()
  La borne est optimale sur $Σ = {a}$.
  En effet, soit $Q = {0, …, n - 1}$, l'état initial $0$, les états finaux $Q ∖ {n - 1}$ et
  $ δ(i, a) = min(i + 1, n - 1). $
  Cet automate accepte tous les mots de taille strictement inférieure à $n - 1$, mais pas $a^(n - 1)$.
]

== Implémentation déterministe complet

En codant chaque lettre par un entier :
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  align: top,
  [
```ocaml
type adc = {
  initial : int;
  finaux : int list;
  delta : int array array; (* delta.(q).(a) = q' *)
}
```
  ],
  [
```ocaml
let accepte a m =
  let etat = ref a.initial in
  for i = 0 to String.length m - 1 do
    etat := a.delta.(!etat).(m.[i])
  done;
  List.mem !etat a.finaux
```
  ],
)
#underline[Complexité] : #completer()

== Déterminisation
#theoreme(coeur: true)[Tout automate est équivalent à un automate déterministe complet.]
#solution(cours: true)[
  L'automate des parties est $A' = (Σ, cal(P)(Q), {I}, F', δ')$, où :
  $ F' = {X ⊂ Q ∣ X ∩ F ≠ ∅}, quad δ'(X, a) = union.big_(q ∈ X) δ(q, a). $
]

#slide()
#underline[Invariant] : après lecture d'un mot $u$, l'état atteint dans $A'$ est exactement l'ensemble des états atteignables dans $A$ depuis $I$ en lisant $u$.

#slide()
#algorithme(coeur: true)[
  + Initialiser la liste d'attente à ${I}$.
  + Tant que la liste n'est pas vide, extraire un ensemble $X$.
  + Pour chaque $a ∈ Σ$, calculer $X' = union.big_(q ∈ X) δ(q, a)$, mettre $X'$ dans $δ(q, X)$ et ajouter $X'$ s'il est nouveau.
  + Marquer finaux les ensembles rencontrant $F$.
]
L'automate des parties possède $2^(abs(Q))$ états. En pratique, ne construire que les états accessibles. L'ensemble vide joue le rôle d'un puits.

#slide()
#exercice(coeur: true)[Déterminiser l'automate suivant.]
#facteur
#solution[
  == Automate déterminisé
  // Les éléments masqués gardent leurs dimensions et leurs ancres entre les étapes.
  #text(size: 0.6em)[
    #facteur
    #v(0.5em)
    #align(center, touying-reducer(
      reduce: cetz.canvas,
      cover: cetz.draw.hide.with(bounds: true),
      length: unite-automates,
      {
        import finite.draw: state, transition
        cetz.draw.set-style(..style-automates, state: (radius: 0.9))
        state((0, 2), "0", label: ${0}$, initial: (label: none))
        (pause,)
        state((3, 2), "1", label: ${0, 1}$)
        transition("0", "1", label: (text: $a$))
        (pause,)
        transition("0", "0", label: (text: $b$))
        (pause,)
        transition("1", "1", label: (text: $a$))
        (pause,)
        state((6, 2), "2", label: ${0, 2}$)
        transition("1", "2", label: (text: $b$), curve: 0.4)
        (pause,)
        transition("2", "1", label: (text: $a$), curve: 0.4)
        (pause,)
        state((6, -2), "3", label: ${0, 3}$, final: true)
        transition("2", "3", label: (text: $b$))
        (pause,)
        state((3, -2), "4", label: ${0, 1, 3}$, final: true)
        transition("3", "4", label: (text: $a$))
        (pause,)
        transition("3", "3", label: (text: $b$), anchor: bottom)
        (pause,)
        transition("4", "4", label: (text: $a$), anchor: bottom)
        (pause,)
        state((0, -2), "5", label: ${0, 2, 3}$, final: true)
        transition("4", "5", label: (text: $b$), curve: 0.4)
        (pause,)
        transition("5", "4", label: (text: $a$), curve: 0.4)
        (pause,)
        transition("5", "3", label: (text: $b$, dist: -style-automates.transition.label.dist), curve: -3)
      },
    ))
  ]
]

#slide()
#exercice[
  Soit $L_n = Σ^* a Σ^n$ sur $Σ = {a, b}$, avec $n ∈ ℕ$.
  + Construire un automate non déterministe à $n + 2$ états reconnaissant $L_n$.
  + En déduire un automate déterministe à $2^(n + 2)$ états.
  + Montrer que tout automate déterministe reconnaissant $L_n$ possède au moins $2^n$ états.
]

= Stabilité des langages reconnaissables

== Complémentaire
#theoreme(coeur: true)[Si $L ⊂ Σ^*$ est reconnaissable, $Σ^* ∖ L$ est reconnaissable.]
#article-only[*Preuve* :]
#solution[
  #pause
  Prendre un automate déterministe complet reconnaissant $L$ et remplacer $F$ par $Q ∖ F$.
  Chaque mot possède un unique chemin, qui aboutit dans un état final exactement lorsque le mot n'appartient pas à $L$.
]
#slide()
#exercice[
  + Montrer pourquoi la preuve nécessite un automate déterministe complet.
  + Dessiner un automate reconnaissant les mots contenant le facteur $a a a$, puis un automate reconnaissant les mots ne le contenant pas.
]

== Automate produit
#theoreme(
  coeur: true,
)[Les langages reconnaissables sur un même alphabet sont stables par intersection, union et différence.]
Pour deux automates déterministes complets $A_1$, $A_2$, utiliser les états $Q_1 × Q_2$, l'état initial $(i_1, i_2)$ et :
$ δ((q_1, q_2), a) = (δ_1(q_1, a), δ_2(q_2, a)). $

#slide()
Le produit simule les deux lectures en parallèle. Compléter l'ensemble des états finaux :
#solution[
  - Pour $L_1 ∩ L_2$ : $F_1 × F_2$.
  - Pour $L_1 ∪ L_2$ : $(F_1 × Q_2) ∪ (Q_1 × F_2)$.
  - Pour $L_1 ∖ L_2$ : $F_1 × (Q_2 ∖ F_2)$.
]
#article-only[
  - Pour $L_1 ∩ L_2$ : $F =$ #line(length: 5cm)
  - Pour $L_1 ∪ L_2$ : $F =$ #line(length: 5cm)
  - Pour $L_1 ∖ L_2$ : $F =$ #line(length: 5cm)
]

#article-only[
  Si les alphabets diffèrent, compléter les deux automates sur leur union.
  Ces résultats se généralisent aux unions et intersections finies.
  Pour une union, on peut aussi prendre l'union disjointe de deux automates non déterministes.
]
#slide()
#exercice[
  + La construction fonctionne-t-elle sans les hypothèses de déterminisme et de complétude ? Examiner chaque opération.
  + Construire un automate reconnaissant les mots sur ${a, b}$ contenant un nombre pair de $a$ et un nombre de $b$ congru à $2$ modulo $3$.
]

= Accessibilité et émondage

#definition[
  - Un état est accessible s'il existe un chemin depuis un état initial vers cet état.
  - Il est co-accessible s'il existe un chemin depuis cet état vers un état final.
  - Un automate est émondé si tous ses états sont accessibles et co-accessibles.
]
#slide()
#exercice[Décrire un algorithme de coût $O(abs(Q) + abs(E))$ déterminant ces deux ensembles.]
#solution[#pause Parcourir le graphe depuis $I$, puis le graphe transposé depuis $F$.]
#slide()
#theoreme[Tout automate est équivalent à un automate émondé.]
Supprimer les états inaccessibles et les états non co-accessibles : aucun chemin acceptant ne les utilise.
#exercice[Tout automate est-il équivalent à un automate émondé déterministe complet ?]

= Lemme de l'étoile

#lemme(coeur: true)[
  Soit $L$ reconnu par un automate à $n$ états. Pour tout $u ∈ L$ de taille au moins $n$, il existe $x, y, z$ tels que :
  $ u = x y z, quad abs(x y) ≤ n, quad y ≠ ε, quad ∀ k ∈ ℕ, #sep x y^k z ∈ L. $
]
#slide()
*Preuve* : prendre un chemin acceptant d'étiquette $u$.
Parmi ses $n + 1$ premiers états, deux sont égaux : $q_i = q_j$, avec $0 ≤ i < j ≤ n$.
Décomposer le mot en $x$, avant $q_i$, $y$, entre $q_i$ et $q_j$, et $z$, après $q_j$.

#dessiner-automate(
  (("q_0", (0, 0), true, false), ("q_i", (4, 0), false, false), ("q_p", (8, 0), false, true)),
  (("q_0", "q_i", "x", (curve: 0)), ("q_i", "q_i", "y", (:)), ("q_i", "q_p", "z", (curve: 0))),
)
#slide()
On a $abs(x y) = j ≤ n$ et $abs(y) = j - i > 0$.
Répéter le cycle $k$ fois donne un chemin acceptant d'étiquette $x y^k z$, y compris pour $k = 0$.

#slide()
*Attention* : la réciproque est fausse. On ne choisit pas la décomposition $x y z$.

Pour montrer que $L$ n'est pas reconnaissable :
+ Supposer qu'un automate à $n$ états reconnaît $L$.
+ Choisir $u ∈ L$ avec $abs(u) ≥ n$.
+ Pour toute décomposition respectant le lemme, trouver un $k$ tel que $x y^k z ∉ L$.

#slide()
#exercice[
  Montrer que les langages suivants ne sont pas reconnaissables :
  + $L_1 = {a^n b^n ∣ n ∈ ℕ}$
  + $L_2 = {a^n b^p ∣ n, p ∈ ℕ, #sep n ≠ p}$
]
#solution[
  == Correction : autant de a que de b
  Supposer que $L_1$ est reconnu par un automate à $n ≥ 1$ états.
  Prendre $u = a^n b^n$. Comme $abs(x y) ≤ n$, on a $y = a^j$ avec $j > 0$.
  Alors $x z = a^(n - j) b^n ∉ L_1$, contradiction pour $k = 0$.

  == Correction : des nombres différents
  Si $L_2$ était reconnaissable, $a^* b^* ∖ L_2 = L_1$ le serait aussi par stabilité par différence.
]

#underline[Remarque] :
- Les automates sont sans mémoire : le choix d'une transition dépend uniquement de l'état actuel et de la lettre lue, pas du chemin déjà parcouru. Ils ne peuvent donc pas compter.
- ${a^n b^p | n ≡ p mod 2}$ est reconnaissable car il suffit de mémoriser la parité du nombre de $a$ et de $b$ lus (2 états suffisent) et pas une infinité de valeurs possibles.
