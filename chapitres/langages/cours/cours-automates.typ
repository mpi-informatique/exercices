#import "/load.typ": est-presentation
#import "/load.typ": slide
#import "/load.typ": (
  article-only, automate, colonnes-cours, completer, cours-et-presentation, pause, sep, slides-only, solution,
  theoremes,
)
#import theoremes: algorithme, definition, exercice, lemme, theoreme
#import automate: cetz, dessiner-automate, finite, style-automates, unite-automates
#import "@preview/touying:0.8.0": touying-reducer

#show: cours-et-presentation.with(titre: "Automates", niveau: "MPI")

#let colonnes-definition = (1.3fr, 1fr)

= Automate non déterministe
#slide(titre: false, saut: false)

#let definition-automate = definition(marge: false, [Automate non déterministe])[
  Un _automate_ est un $5$-uplet $A = (Σ, Q, I, F, T)$ où :
  - $Σ$ est un alphabet.
  - $Q$ est un ensemble fini d'_états_.
  - $I ⊂ Q$ est l'ensemble des _états initiaux_.
  - $F ⊂ Q$ est l'ensemble des _états finaux_, ou acceptants.
  - $T ⊂ Q × Σ × Q$ est l'ensemble des _transitions_.
]

#colonnes-cours(
  columns: colonnes-definition,
  definition-automate,
  figure(
    dessiner-automate(
      (("0", (0, 0), true, false), ("1", (3, 0), false, false), ("2", (6, 0), false, true)),
      (
        ("0", "0", "a", (:)),
        ("0", "1", "b", (curve: 0.4)),
        ("1", "0", "a", (curve: 0.4)),
        ("1", "2", "a", (curve: 0)),
        ("2", "2", "b", (:)),
      ),
    ),
    numbering: none,
    caption: [
      $Σ = {a, b}, Q = {0, 1, 2}, I = {0}, F = {2}$\
      $T = {(0, a, 0), (0, b, 1), (1, a, 0), (1, a, 2), (2, b, 2)}$
    ],
  ),
)

#slide()
#exercice[
  En notant $n = |Q|$ et $p = |Σ|$, combien existe t-il d'automates à $Σ$ et $Q$ fixés ?
]

== Fonction de transition

#let definition-transition = [
  #definition(marge: false, [Fonction de transition $δ$])[
    On peut remplacer $T$ par  $δ : Q × Σ → cal(P)(Q)$ tel que :
    $ δ(q, a) = {q' ∈ Q ∣ (q, a, q') ∈ T}. $
  ]
]
#colonnes-cours(
  columns: colonnes-definition,
  definition-transition,
  align(center, figure(
    table(
      columns: (auto, ..(4em,) * 3),
      rows: 1.75em,
      table.header($q$, ..range(0, 3).map(str)),
      [$δ(q, a)$], ..(completer(),) * 3,
      [$δ(q, b)$], ..(completer(),) * 3,
    ),
    caption: none,
  )),
)
Il y a un _blocage_ lorsque $δ(q, a) = ∅$. $δ(q, a)$ est aussi noté $q ⋅ a$.

#slides-only[== Implémentation]

#exercice[Implémentation][
  1. Rappeler la définition des structures de données abstraites de dictionnaire et d'ensemble.
  2. Comment s'en servir pour représenter un automate ?
  3. Proposer deux implémentations de ces structures de données.
]

#slides-only[== Fonction de transition étendue]

#grid(
  columns: colonnes-definition,
  column-gutter: 1.5em,
  align: center + horizon,
  definition[Fonction de transition étendue $δ^*$][
    On peut définir récursivement l'ensemble $δ^*(q, m)$ des états atteignables après lecture de $m ∈ Σ^*$ depuis $q ∈ Q$ :
    #text(size: 0.9em)[$ δ^*(q, ε) = {q} quad "et" quad δ^*(q, a u) = ⋃_(q' ∈ δ(q, a)) δ^*(q', u) $]
  ],
  [
    #exercice[Pour l'automate d'exemple, calculer $δ^*(1, a b)$.]
    #solution[
      $δ(1, a) = {0, 2}$, donc $δ^*(1, a b) = δ(0, b) ∪ δ(2, b) = {1, 2}$.
    ]
  ],
)
#slide()
#grid(
  columns: colonnes-definition,
  column-gutter: 1.5em,
  align: center + horizon,
  [
    #definition[Fonction de transition sur un ensemble][
      On peut aussi étendre $δ$ et $δ^*$ à un ensemble d'états $X ⊂ Q$ : $ δ(X, a) = display(⋃_(q ∈ X)) δ(q, a) quad "et" quad δ^*(X, m) = display(⋃_(q ∈ X)) δ^*(q, m) $
    ] <def-delta-ens>
  ],
  figure(
    cetz.canvas(length: unite-automates, {
      import cetz.draw: circle, content, line, set-style
      import finite.draw: state
      set-style(..style-automates, state: (radius: 0.2))
      circle((0, 0), radius: (0.85, 1.35), stroke: rgb("#16716b"), fill: rgb("#16716b").lighten(94%))
      circle((4, 0), radius: (0.85, 1.95), stroke: rgb("#16716b"), fill: rgb("#16716b").lighten(94%))
      content((0, 1.75), $Q'$)
      content((4, 2.35), $δ^*(Q', m)$)
      state((0, 0.7), "q1", label: none)
      state((0, -0.7), "q2", label: none)
      state((4, 1.3), "r1", label: none)
      state((4, 0), "r2", label: none)
      state((4, -1.3), "r3", label: none)
      for (depart, arrivee, hauteur) in (("q1", "r1", 1), ("q1", "r2", 0.35), ("q2", "r2", -0.35), ("q2", "r3", -1)) {
        cetz.decorations.wave(
          line(depart + ".state.east", arrivee + ".state.west"),
          amplitude: 0.16,
          segments: 7,
          start: 5%,
          stop: 90%,
          mark: (end: ">", fill: black),
        )
        content((2, hauteur + 0.35), $m$)
      }
    }),
    numbering: none,
    caption: [Les flèches représentent des chemins d'étiquette $m$.],
  ),
)

#lemme[Concaténation de chemins][
  Avec $u, v ∈ Σ^*$, $Q' ⊂ Q$ et en notant $⋅$ au lieu de $δ^*$ :
  $ Q' ⋅ u v = Q' ⋅ u ⋅ v $
  #grid(
    columns: (1fr, auto, 1fr),
    align: left + horizon,
    [Cas particulier $Q' = {q}$ :],
    [$q ⋅ u v = q ⋅ u ⋅ v$],
    [],
  )
] <lem-delta-etoile>

= Langage reconnaissable

#definition[Chemin acceptant][
  Un _chemin_ $C$ dans un automate $A$ est une suite de transitions consécutives :
  $q_0 limits(⟶)^(a_1) q_1 limits(⟶)^(a_2) … limits(⟶)^(a_n) q_n.$\
  L'_étiquette_ de $C$ est le mot $a_1 … a_n$.
  On dit que $C$ est _acceptant_ si $q_0 ∈ I$ et $q_n ∈ F$.
]

#underline[Remarque] : il suffit d'un chemin acceptant pour que $m in cal(L)(A)$, même si un autre chemin d'étiquette $m$ n'est pas acceptant.

#slide()
#definition[Langage reconnaissable][
  Un mot est _accepté_ par $A$ s'il est l'étiquette d'un chemin acceptant.
  Le _langage_ $cal(L)(A)$ reconnu par $A$ est l'ensemble des mots acceptés.
  Un langage est _reconnaissable_ s'il est reconnu par un automate.
]

#slide()
#exercice[Déterminer les langages reconnus par les automates ci-dessous.]
#grid(
  columns: if est-presentation() { (auto, 1fr) } else { (1fr, 1fr) },
  column-gutter: 1em,
  align: horizon,
  figure(
    dessiner-automate(
      (("0", (0, 0), true, false), ("1", (3, 0), false, true)),
      (("0", "0", "b", (:)), ("1", "1", "b", (:)), ("0", "1", "a", (curve: 0.5)), ("1", "0", "a", (curve: 0.5))),
    ),
    numbering: none,
    caption: [$A_1$],
  ),
  figure(
    dessiner-automate(
      (("0", (0, 0), true, false), ("1", (6, 0), right, false), ("2", (3, 0), false, true)),
      (
        ("0", "0", "a", (:)),
        ("1", "1", "b", (:)),
        ("0", "2", "b", (curve: 0)),
        ("1", "2", "a", (curve: 0)),
      ),
    ),
    numbering: none,
    caption: [$A_2$],
  ),
)

#slides-only[
  #slide()
  À gauche : les mots contenant un nombre impair de $a$, par exemple $b b a b$.

  À droite : $a^* b | b^* a$.
  Chaque état initial correspond à l'une des deux branches de l'union.
]

#slide()

#colonnes-cours(
  align: left + top,
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

Pour déterminer si $m = m_1 … m_n ∈ cal(L)(A)$, on peut calculer itérativement l'ensemble $Q_k$ des états atteignables après lecture de $m_1 … m_k$ : $Q_0 = I$ et $Q_k = δ(Q_(k-1), m_k)$.
Alors $m ∈ cal(L)(A) <==> Q_n ∩ F ≠ ∅$.

#slide()
#exercice[
  + Quelle est la complexité de cette méthode, en temps et mémoire ?
  + Proposer une autre méthode par mémoïsation. Comparer les deux méthodes.
]
#solution[
]

= Automate complet

#definition[Automates équivalents][
  Deux automates sont équivalents s'ils reconnaissent le même langage.
]

#definition[Automate complet][
  Un automate est complet s'il n'a pas de blocage :
  $∀ q ∈ Q, #sep ∀ a ∈ Σ, #sep ∃ q' ∈ Q, #sep (q, a, q') ∈ T.$
]

#slide()
#theoreme[Tout automate est équivalent à un automate complet.]

= Automate déterministe (AD)

#grid(
  columns: colonnes-definition,
  column-gutter: 1.5em,
  align: horizon,
  definition(coeur: true, marge: false)[
    Un automate est déterministe si :
    + Il possède un unique état initial.
    + $(q, a, q_1) ∈ T ∧ (q, a, q_2) ∈ T ==> q_1 = q_2$
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
  Soient $A = (Q, Σ, q_0, F, T)$ un AD, $q ∈ Q$, $m ∈ Σ^*$. Quelles sont les propositions vraies ?
  + $(q_1, a, q) ∈ T ∧ (q_2, a, q) ∈ T ==> q_1 = q_2.$
  + $A$ contient au plus un chemin d'étiquette $m$ partant de $q$.
  + $A$ contient au plus un chemin de $q_0$ à $q$.
  + $A$ est non ambigu : un mot de $cal(L)(A)$ a un unique chemin acceptant.
  + Si $A'$ est non ambigu alors $A'$ est déterministe.
]

#slide()
#definition[
  Si $A = (Q, Σ, q_0, F, T)$ est un ADC, on définit $δ^* : Q × Σ^* → Q$ récursivement, pour $q ∈ Q$ :
  - $δ^*(q, ε) = q$
  - $∀ a ∈ Σ, m ∈ Σ^* : #sep δ^*(q, a m) = δ^*(δ(q, a), m)$
]
$δ^*(q, u)$, noté parfois $q ⋅ u$, est l'état atteint après lecture de $u$ depuis $q$.
On a $u ∈ cal(L)(A) <==> δ^*(q_i, u) ∈ F$.
#slide()
#theoreme[$∀q ∈ Q, u, v ∈ Σ^* : #sep δ^*(q, u v) = δ^*(δ^*(q, u), v)$.] <thm-delta-etoile>

#slide()
#exercice[
  Soit $A$ un ADC à $n$ états sur un alphabet $Σ$.
  Montrer que si $A$ accepte tous les mots de taille strictement inférieure à $n$, alors $cal(L)(A) = Σ^*$.
  La borne est-elle optimale ?
]
#solution[
  #slide()
  Supposons $cal(L)(A) ≠ Σ^*$ et soit $m ∈ Σ^* \\ cal(L)(A)$ de taille minimale.
  Par hypothèse, $abs(m) ≥ n$.
  Parmi les états atteints après lecture de ses $n + 1$ premiers préfixes, deux sont égaux.
  On peut donc écrire $m = x y z$, avec $y ≠ ε$, et
  $δ^*(q_0, x) = δ^*(q_0, x y).$
  @lem-delta-etoile donne $ δ^*(q_0, x z) = δ^*(δ^*(q_0, x), z) = δ^*(δ^*(q_0, x y), z) = δ^*(q_0, m). $
  Donc $x z ∉ cal(L)(A)$ et $|x z| < |m|$, ce qui contredit la minimalité de $m$.

  #slide()
  La borne est optimale sur $Σ = {a}$.
  En effet, soit $Q = {0, …, n - 1}$, l'état initial $0$, les états finaux $Q ∖ {n - 1}$ et
  $ δ(i, a) = min(i + 1, n - 1). $
  Cet automate accepte tous les mots de taille strictement inférieure à $n - 1$, mais pas $a^(n - 1)$.
]

#slide()
#exercice(titre: [Automates à permutations])[
  Soit $A = (Q, Σ, q_0, F, δ)$ un ADC. Pour $a ∈ Σ$, on note $δ_a (q) = δ(q, a)$.\
  On suppose que $A$ est un _automate à permutations_, c'est-à-dire que chaque $δ_a$ est bijective.
  + Peut-on remplacer « bijective » par « injective » ou « surjective » dans cette définition ?
  + Soit $u ∈ Σ^*$. Montrer que $δ^*(⋅, u)$ est une permutation de $Q$.
  + En déduire : $∀q ∈ Q, ∃k ≥ 1, #sep δ^*(q, u^k) = q$.
  + Soit $a ∈ Σ$. $Σ^* a Σ^*$ est-il reconnaissable par un automate à permutations ?
]
#solution[
  + Oui : une application de l'ensemble fini $Q$ dans lui-même est injective si et seulement si elle est surjective, donc bijective.
  + Notons $f_u = δ^*(⋅, u)$. On a $f_ε = id_Q$ et $f_(v a) = δ_a ∘ f_v$.
    Par récurrence sur la taille de $u$, $f_u$ est une permutation de $Q$, car composée de permutations.
  + Soit $q ∈ Q$. La finitude de $Q$ donne $0 ≤ i < j$ tels que $f_u^i (q) = f_u^j (q)$.
    Comme $f_u^i$ est injective, $f_u^(j - i) (q) = q$.
    D'après @lem-delta-etoile, $f_u^k (q) = δ^*(q, u^k)$ pour tout $k ∈ ℕ$. Prendre $k = j - i ≥ 1$.
  + Non. Supposons $cal(L)(A) = Σ^* a Σ^*$. Comme $ε ∉ cal(L)(A)$, l'état initial $q_0$ n'est pas final.
    La question précédente donne $k ≥ 1$ tel que $δ^*(q_0, a^k) = q_0$.
    Le mot $a^k$ est donc refusé, alors qu'il appartient à $Σ^* a Σ^*$ : contradiction.
]

== Implémentation déterministe complet

Si $A$ est un ADC et $m$ un mot, on peut tester $m ∈ cal(L)(A)$ en O($abs(m)$) en temps et O($1$) en mémoire :
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  align: top,
  [
    ```c
    #include <stdbool.h>

    typedef struct {
      int initial;
      bool *finaux; // finaux[q] : q est final
      int **delta; // delta[q][a] = q'
    } adc;
    ```
  ],
  [
    ```c
    bool accepte(const adc *a, const int m[], int n) {
      int etat = a->initial;
      for (int i = 0; i < n; i++) {
        etat = a->delta[etat][m[i]];
      }
      return a->finaux[etat];
    }
    ```
  ],
)
#underline[Complexité] : #completer()

== Déterminisation
#theoreme(
  coeur: true,
)[Soit $A = (Σ, Q, I, F, δ)$ un automate. Alors $A$ est équivalent à un automate déterministe complet.]
#solution(cours: true)[
  Soit $A' = (Σ, cal(P)(Q), {I}, F', δ')$ l'_automate des parties_, défini par :
  $ F' = {X ⊂ Q ∣ X ∩ F ≠ ∅} quad "et" quad δ'(X, a) = union.big_(q ∈ X) δ(q, a) $
  $ δ' : cal(P)(Q) × Σ ⟶ cal(P)(Q) $
  Pour $u = u_1 … u_n$, on montre l'invariant : $δ'^*({I}, u) = {δ^*(q, u) ∣ q ∈ I}$. Donc $u ∈ cal(L)(A) <==> δ'^*({I}, u) ∩ F ≠ ∅ <==> u ∈ cal(L)(A')$.
]

#slide()
#underline[Invariant] : après lecture d'un mot $u$, l'état atteint dans $A'$ est l'ensemble des états atteignables dans $A$ depuis $I$ en lisant $u$.

#slide()
#algorithme[
  + $D ← {I}$ ; initialiser une file $f$ contenant $I$.
  + *Tant que* $f$ n'est pas vide :
    + Défiler un ensemble $X$ de $f$.
    + *Pour chaque* $a ∈ Σ$ :
      + $X' ← δ(X, a)$
      + $δ'(X, a) ← X'$
      + *Si* $X' ∉ D$ :
        + Ajouter $X'$ à $D$ et l'enfiler dans $f$.
  + $F' ← {X ∈ D ∣ X ∩ F ≠ ∅}$
]
#slide()
L'automate des parties possède $2^(abs(Q))$ états. En pratique, ne construire que les états accessibles. L'ensemble vide joue le rôle d'un puits.

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

#colonnes-cours(
  columns: colonnes-definition,
  exercice(coeur: true)[Déterminiser l'automate suivant.],
  facteur,
)
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
#theoreme(coeur: true, titre: [Stabilité par complémentaire])[
  Si $L ⊂ Σ^*$ est reconnaissable, $Σ^* ∖ L$ est reconnaissable.
] <thm-complementaire>
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
  - Pour $L_1 ∩ L_2$ : $F =$ #completer()
  - Pour $L_1 ∪ L_2$ : $F =$ #completer()
  - Pour $L_1 ∖ L_2$ : $F =$ #completer()
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
#exercice[Décrire un algorithme de coût $O(abs(Q) + abs(T))$ déterminant ces deux ensembles.]
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
