#import "/load.typ": est-corrige, est-presentation
#import "/load.typ": slide
#import "/load.typ": (
  PP, article-only, automate, colonnes-cours, completer, cours-et-presentation, hp, lien, liste-cours, pause, sep,
  slides-only, solution, theoremes, tp,
)
#import theoremes: algorithme, definition, exercice, lemme, methode, theoreme
#import automate: LL, Lrec, cetz, dessiner-automate, finite, style-automates, unite-automates
#import "@preview/touying:0.8.0": touying-reducer

#show: cours-et-presentation.with(titre: "Automates", niveau: "MPI")

#let colonnes-definition = (1.5fr, 1fr)
#let LA = $cal(L)(A)$
#let timess = $#h(0.08em) class(#"normal", ×) #h(0.08em)$

= Automate non déterministe
#slide(titre: false, saut: false)

#colonnes-cours(
  columns: colonnes-definition,
  definition([Automate non déterministe])[
    Un _automate_ est un $5$-uplet $A = (Σ, Q, I, F, T)$ où :
    - $Σ$ est un alphabet.
    - $Q$ est un ensemble fini d'_états_.
    - $I ⊂ Q$ est l'ensemble des _états initiaux_.
    - $F ⊂ Q$ est l'ensemble des _états finaux_, ou acceptants.
    - $T ⊂ Q timess Σ timess Q$ est l'ensemble des _transitions_.
  ],
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
    caption: [
      $Σ = {a, b}, Q = {0, 1, 2}, I = {0}, F = {2}$\
      $T = {(0, a, 0), (0, b, 1), (1, a, 0), (1, a, 2), (2, b, 2)}$
    ],
  ),
)

#slide()
#exercice[
  Combien y a t-il d'automates à $Σ$ et $Q$ fixés, en fonction de $n = |Q|$ et $p = |Σ|$ ? #completer()
]

#slides-only[== Fonction de transition]

#colonnes-cours(
  columns: colonnes-definition,
  definition([Fonction de transition $δ$])[
    On peut remplacer $T$ par  $δ : Q timess Σ → PP(Q)$ tel que :
    $ δ(q, a) = {q' ∈ Q ∣ (q, a, q') ∈ T} $
  ],
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

#colonnes-cours(
  columns: colonnes-definition,
  align: center + horizon,
  definition[Fonction de transition étendue $δ^*$][
    On définit récursivement l'ensemble $δ^*(q, m)$ des états atteignables par un chemin d'étiquette $m ∈ Σ^*$ depuis $q ∈ Q$ :
    $ δ^*(q, ε) = {q} quad "et" quad δ^*(q, a m) = ⋃_(q' ∈ δ(q, a)) δ^*(q', m) $
  ],
  [
    #exercice[Donner $δ^*(1, a b)$ pour l'automate ci-dessus.\ #completer()]
  ],
)

// #definition[Chemin][
//   Un chemin est une suite de transitions $q_0 limits(⟶)^(a_1) q_1 limits(⟶)^(a_2) … limits(⟶)^(a_n) q_n$. Son _étiquette_ est le mot $m = a_1 … a_n$.\
// ]

// #lemme([$δ^*$ et chemins])[
//   $δ^*(q, m)$ est l'ensemble des états atteignables par un chemin d'étiquette $m$ partant de $q$.
// ]

#slide()
#colonnes-cours(
  columns: colonnes-definition,
  align: center + horizon,
  [
    #definition[Fonction de transition sur un ensemble][
      On peut aussi étendre $δ$ et $δ^*$ à un ensemble d'états $X ⊂ Q$ : $ δ(X, a) = display(⋃_(q ∈ X)) δ(q, a) quad "et" quad δ^*(X, m) = display(⋃_(q ∈ X)) δ^*(q, m) $
    ] <def-delta-ens>
  ],
  align(center, cetz.canvas(length: unite-automates * 0.9, {
    import cetz.draw: circle, content, line, set-style
    import finite.draw: state
    set-style(..style-automates, state: (radius: 0.2))
    circle((0, 0), radius: (0.85, 1.35), stroke: rgb("#16716b"), fill: rgb("#16716b").lighten(94%))
    circle((4, 0), radius: (0.85, 1.8), stroke: rgb("#16716b"), fill: rgb("#16716b").lighten(94%))
    content((-1.5, 0), $X$)
    content((6.2, 0), $δ^*(X, m)$)
    state((0, 0.5), "q1", label: none)
    state((0, -0.5), "q2", label: none)
    state((4, 1.1), "r1", label: none)
    state((4, 0), "r2", label: none)
    state((4, -1.1), "r3", label: none)
    for (depart, arrivee, hauteur) in (("q1", "r1", 1), ("q1", "r2", 0.35), ("q2", "r2", -0.35), ("q2", "r3", -1)) {
      cetz.decorations.wave(
        line(depart + ".state.east", arrivee + ".state.west"),
        amplitude: 0.15,
        segments: 3,
        start: 5%,
        stop: 90%,
        mark: (end: ")>", fill: black),
      )
      content((2, hauteur + 0.35), $m$)
    }
  })),
)

#slide()
#lemme[Concaténation de chemins][
  Avec $u, v ∈ Σ^*$, $X ⊂ Q$ et en notant $⋅$ au lieu de $δ^*$ :
  $ X ⋅ u v = X ⋅ u ⋅ v $
  #grid(
    columns: (1fr, auto, 1fr),
    align: left + horizon,
    [Cas particulier $X = {q}$ :], [$q ⋅ u v = q ⋅ u ⋅ v$], [],
  )
] <lem-delta-etoile>

= Langage reconnaissable

#definition([Langage reconnaissable], marge: false)[
  Un mot $m$ est _accepté_ par $A$ si $δ^*(I, m) ∩ F ≠ ∅$, c'est-à-dire s'il est étiquette d'un _chemin acceptant_ de $I$ à $F$.\
  Le _langage_ $LA$ _reconnu_ par $A$ est l'ensemble des mots acceptés par $A$.\
  On note $Lrec(Σ)$ l'ensemble des _langages reconnaissables_ par automate.
]

#slide()
#exercice[Déterminer les langages reconnus par les automates ci-dessous.]
#context {
  let automates = (
    dessiner-automate(
      (("0", (0, 0), true, false), ("1", (3, 0), false, true)),
      (("0", "0", "b", (:)), ("1", "1", "b", (:)), ("0", "1", "a", (curve: 0.5)), ("1", "0", "a", (curve: 0.5))),
    ),
    dessiner-automate(
      (("0", (0, 0), true, false), ("1", (6, 0), right, false), ("2", (3, 0), false, true)),
      (
        ("0", "0", "a", (:)),
        ("1", "1", "b", (:)),
        ("0", "2", "b", (curve: 0)),
        ("1", "2", "a", (curve: 0)),
      ),
    ),
  )
  let hauteur = calc.max(..automates.map(automate => measure(automate).height))
  grid(
    columns: if est-presentation() { (auto, 1fr) } else { (1fr, 1fr) },
    column-gutter: 1em,
    align: horizon,
    figure(
      block(height: hauteur, align(horizon, automates.at(0))),
      caption: [$LL(A_1)$ = #completer(taille: 10em)],
    ),
    figure(
      block(height: hauteur, align(horizon, automates.at(1))),
      caption: [$LL(A_2)$ = #completer(taille: 10em)],
    ),
  )
}

#slide()

#liste-cours(
  encadrer: contenu => exercice[
    Montrer que les langages suivants sont reconnaissables :
    #contenu
  ],
  [$a b | a b c | c$],
  [Mots de taille paire sur $Σ = {a, b}$.],
  [$(b | a b | a b a)^*$],
  [Mots sur $Σ = {a, b}$ dont l'avant-dernière lettre est $a$.],
)

Pour déterminer si $m = m_1 … m_n ∈ LA$, on peut calculer itérativement l'ensemble $Q_k$ des états atteignables après lecture de $m_1 … m_k$ : $Q_0 = I$ et $Q_k = δ(Q_(k-1), m_k)$.
Alors $Q_k = δ^*(I, m_1 … m_k)$ et $m ∈ LA <==> Q_n ∩ F ≠ ∅$.

#slide()
#exercice[
  + Proposer une structure de données pour représenter $Q_k$ et donner la complexité en temps et mémoire.
  + Proposer une autre méthode par mémoïsation. Comparer.
]
#solution[
]

#solution[
  On note $n = |m|$, $s = |Q|$ et $t = |Δ|$. Les mémoires indiquées sont auxiliaires, hors stockage de l'automate et du mot.

  + *Par ensembles (parcours en largeur).* On calcule les états atteignables après chaque préfixe :
    $ Q_0 = I, quad Q_(k+1) = δ(Q_k, m_(k+1)). $
    On accepte si $Q_n ∩ F ≠ ∅$. Deux tableaux de booléens de taille $s$ représentent les ensembles courant et suivant, sans doublons. À chaque étape, on réinitialise le tableau suivant et parcourt les transitions sortant des états courants, en gardant celles étiquetées par la lettre lue. Temps : $O((n+1)(s+t))$ ; mémoire : $O(s)$. On peut rejeter dès que l'ensemble courant est vide.
  + *DFS sans mémoïsation.* Une configuration $(q, k)$ signifie que l'on est dans l'état $q$ après avoir lu $k$ lettres. Depuis chaque état initial, on explore récursivement les configurations $(q', k+1)$ pour $q' ∈ δ(q, m_(k+1))$. Si $k = n$, on teste $q ∈ F$. On accepte dès qu'un appel réussit. Des chemins différents peuvent rejoindre la même configuration et refaire les mêmes calculs : le temps peut être exponentiel en $n$. Mémoire : $O(n+1)$ pour la pile, si l'on parcourt les successeurs sans recopier les listes d'adjacence.
  + *DFS avec mémoïsation.* On mémorise le résultat booléen de chaque configuration $(q, k)$. Chaque configuration est traitée au plus une fois ; la position augmente strictement à chaque appel. Temps : $O((n+1)(s+t))$ ; mémoire : $O((n+1)s)$, pile comprise, pour un automate non vide.

  La méthode par ensembles déduplique déjà les configurations à chaque position et oublie les couches précédentes : elle est généralement préférable pour sa simplicité et sa mémoire $O(s)$. Le DFS mémoïsé peut trouver un chemin acceptant sans explorer toutes les configurations atteignables. La mémoïsation évite les calculs répétés du DFS, mais n'apporte rien à la méthode par ensembles pour un seul mot.

  *Exemple de temps exponentiel.* Considérons l'automate suivant et le mot $m = a^n$ :
  #dessiner-automate(
    (("q_0", (0, 0), true, false), ("q_1", (3, 0), false, false), ("f", (6, 0), false, true)),
    (
      ("q_0", "q_0", "a", (:)),
      ("q_0", "q_1", "a", (curve: 0.4)),
      ("q_1", "q_0", "a", (curve: 0.4)),
      ("q_1", "q_1", "a", (:)),
      ("q_1", "f", "b", (:)),
    ),
  )
  À chaque lettre $a$, chacun des états $q_0$ et $q_1$ offre deux choix. Le mot est rejeté, car atteindre l'état final exige de lire un $b$ : aucun appel ne réussit et le DFS sans mémoïsation explore tous les choix. Son arbre d'appels est binaire complet, avec $2^k$ appels à la profondeur $k$, donc
  $ T(n) = 1 + 2 + 2^2 + dots + 2^n = 2^(n+1) - 1 = Θ(2^n). $
  Par exemple, pour $m = a^3$, il effectue $15$ appels alors qu'il n'y a que $7$ configurations distinctes : $(q_0, 0)$, puis $(q_0, k)$ et $(q_1, k)$ pour $1 ≤ k ≤ 3$. Avec mémoïsation, seules $2n+1$ configurations sont calculées, d'où un temps $Θ(n+1)$ pour cet automate fixé. La méthode par ensembles obtient aussi ce temps : $Q_0 = {q_0}$, puis $Q_k = {q_0, q_1}$ pour $1 ≤ k ≤ n$.
]

= Automate complet

#definition[Automates équivalents][
  Deux automates sont _équivalents_ s'ils reconnaissent le même langage.
]

#definition[Automate complet][
  Un automate $A = (Q, Σ, I, F, δ)$ est _complet_ s'il n'a pas de blocage : $∀ q ∈ Q, a ∈ Σ, #sep δ(q, a) ≠ ∅$.
]

#theoreme[Complétion d'un automate][Tout automate est équivalent à un automate complet.]<thm-complet>

= Automate déterministe

#article-only[Intuitivement, un automate est déterministe s'il n'y a jamais plusieurs possibilités de lecture.]
#colonnes-cours(
  columns: colonnes-definition,
  align: horizon,
  {
    definition(coeur: true, marge: false, [Automate déterministe (AD)])[
      Un automate $A = (Q, Σ, I, F, δ)$ est _déterministe_ si :
      - Il possède un unique état initial : $|I| = 1$
      - Il y a au plus une transition $q limits(⟶)^(a) …$ : $∀ q ∈ Q, a ∈ Σ, #sep |δ(q, a)| ≤ 1$
    ]
  },
  if not est-presentation() {
    figure(
      dessiner-automate(
        (("q", (0, 0), false, false), ("q_1", (2.5, 0.75), false, false), ("q_2", (2.5, -0.75), false, false)),
        (("q", "q_1", "a", (curve: 0)), ("q", "q_2", "a", (curve: 0))),
      ),
      caption: [Automate non déterministe],
    )
  },
)

Un automate déterministe complet (ADC) a une fonction de transition de la forme $δ : Q timess Σ → Q$ et $δ^* : Q timess Σ^* → Q$.

#slide()
#exercice[Propriétés des automates déterministes][
  Soient $A = (Q, Σ, q_0, F, δ)$ un AD, $q ∈ Q$, $m ∈ Σ^*$. Quelles sont les propositions vraies ?
  + $δ(q_1, a) = δ(q_2, a) ==> q_1 = q_2.$
  + $A$ contient au plus un chemin d'étiquette $m$ partant de $q$.
  + $A$ contient au plus un chemin de $q_0$ à $q$.
  + $A$ est _non ambigu_ : chaque mot de $LA$ a un unique chemin acceptant.
  + Si $A'$ est un automate non ambigu alors $A'$ est déterministe.
]

#slide()

#exercice[
  Soit $A = (Q, Σ, q_0, F, δ)$ un ADC à $n$ états.#slides-only[\ ]
  Montrer : $Σ^(< n) ⊂ LA ==> LA = Σ^*$.
  La borne est-elle optimale ?
]
#solution[
  Supposons $LA ≠ Σ^*$ et soit $m ∈ Σ^* \\ LA$ de taille minimale.
  Par hypothèse, $abs(m) ≥ n$.
  Parmi les états atteints après lecture de ses $n + 1$ premiers préfixes, deux sont égaux.
  On peut donc écrire $m = x y z$, avec $y ≠ ε$, et
  $δ^*(q_0, x) = δ^*(q_0, x y).$
  @lem-delta-etoile donne $ δ^*(q_0, x z) = δ^*(δ^*(q_0, x), z) = δ^*(δ^*(q_0, x y), z) = δ^*(q_0, m). $
  Donc $x z ∉ LA$ et $|x z| < |m|$, ce qui contredit la minimalité de $m$.

  La borne est optimale sur $Σ = {a}$.
  En effet, soit $Q = {0, …, n - 1}$, l'état initial $0$, les états finaux $Q ∖ {n - 1}$ et
  $ δ(i, a) = min(i + 1, n - 1). $
  Cet automate accepte tous les mots de taille strictement inférieure à $n - 1$, mais pas $a^(n - 1)$.
]

#slide()
#exercice(title: [Automates à permutations])[
  Soit $A = (Q, Σ, q_0, F, δ)$ un ADC. Pour $a ∈ Σ$, on note $δ_a (q) = δ(q, a)$.\
  On suppose que $A$ est un _automate à permutations_, c'est-à-dire que chaque $δ_a$ est bijective.
  + Peut-on remplacer « bijective » par « injective » ou « surjective » dans cette définition ?
  + Soit $m ∈ Σ^*$. Montrer que $δ^*(⋅, m)$ est une permutation de $Q$.
  + En déduire : $∀q ∈ Q, ∃k ≥ 1, #sep δ^*(q, m^k) = q$.
  + Soit $a ∈ Σ$. $Σ^* a Σ^*$ est-il reconnaissable par un automate à permutations ?
]
#solution[
  + Oui : une application de l'ensemble fini $Q$ dans lui-même est injective si et seulement si elle est surjective, donc bijective.
  + Notons $f_m = δ^*(⋅, m)$. On a $f_ε = id_Q$ et $f_(v a) = δ_a ∘ f_v$.
    Par récurrence sur la taille de $m$, $f_m$ est une permutation de $Q$, car composée de permutations.
  + Soit $q ∈ Q$. La finitude de $Q$ donne $0 ≤ i < j$ tels que $f_m^i (q) = f_m^j (q)$.
    Comme $f_m^i$ est injective, $f_m^(j - i) (q) = q$.
    D'après @lem-delta-etoile, $f_m^k (q) = δ^*(q, m^k)$ pour tout $k ∈ ℕ$. Prendre $k = j - i ≥ 1$.
  + Non. Supposons $LA = Σ^* a Σ^*$. Comme $ε ∉ LA$, l'état initial $q_0$ n'est pas final.
    La question précédente donne $k ≥ 1$ tel que $δ^*(q_0, a^k) = q_0$.
    Le mot $a^k$ est donc refusé, alors qu'il appartient à $Σ^* a Σ^*$ : contradiction.
]

#slides-only[== Implémentation d'un ADC]

Si $A$ est un ADC et $m$ un mot, on peut tester $m ∈ LA$ en O($abs(m)$) en temps et O($1$) en mémoire :
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
      for (int i = 0; i < n; i++)
        etat = a->delta[etat][m[i]];
      return a->finaux[etat];
    }
    ```
  ],
)

#slides-only[== Déterminisation]

#theoreme(
  coeur: true,
)[Soit $A = (Σ, Q, I, F, δ)$ un automate. Alors $A$ est équivalent à un ADC.]
#solution(cours: true, coeur: true)[
  Soit $PP(A) = (Σ, PP(Q), {I}, F', δ)$ l'_automate des parties_, où chaque état est un ensemble d'états de $A$,\ $F' = {X ⊂ Q ∣ X ∩ F ≠ ∅}$ et $δ : PP(Q) timess Σ → PP(Q)$ est définie comme dans @def-delta-ens. \
  $PP(A)$ a un seul état initial $I$ et chaque $δ(X, a)$ est un unique ensemble d'états donc $A'$ est un ADC. \
  $PP(A)$ est équivalent à $A$ car :
  $ m ∈ cal(L)(PP(A)) <==> δ^*(I, m) ∈ F' <==> δ^*(I, m) ∩ F ≠ ∅ <==> m ∈ LA $
]

L'automate des parties possède $2^(abs(Q))$ états. En pratique, on ne construit que les états accessibles.

#let facteur = dessiner-automate(
  (
    ("0", (0, 0), true, false),
    ("1", (2.5, 0), false, false),
    ("2", (5, 0), false, false),
    ("3", (7.5, 0), false, true),
  ),
  (
    ("0", "0", "a, b", (:)),
    ("0", "1", "a", (curve: 0)),
    ("1", "2", "b", (curve: 0)),
    ("2", "3", "b", (curve: 0)),
    ("3", "3", "a, b", (:)),
  ),
)

#colonnes-cours(
  columns: (1fr, 1fr),
  exercice(coeur: true)[Déterminiser l'automate ci-contre.],
  facteur,
)
#solution(presentation: true)[
  #slides-only[== Algorithme de déterminisation]
  // Les éléments masqués gardent leurs dimensions et leurs ancres entre les étapes.
  #facteur
  #text(size: 1em)[
    #align(center, touying-reducer(
      reduce: cetz.canvas,
      cover: cetz.draw.hide.with(bounds: true),
      length: unite-automates,
      {
        import finite.draw: state, transition
        cetz.draw.set-style(..style-automates, state: (radius: 0.8))
        state((0, 0), "0", label: ${0}$, initial: (label: none))
        (pause,)
        state((2.5, 0), "1", label: ${0, 1}$)
        transition("0", "1", label: (text: $a$), curve: 0)
        (pause,)
        transition("0", "0", label: (text: $b$))
        (pause,)
        transition("1", "1", label: (text: $a$))
        (pause,)
        state((5, 0), "2", label: ${0, 2}$)
        transition("1", "2", label: (text: $b$), curve: 0.4)
        (pause,)
        transition("2", "1", label: (text: $a$), curve: 0.4)
        (pause,)
        state((7.5, 0), "3", label: ${0, 3}$, final: true)
        transition("2", "3", label: (text: $b$), curve: 0)
        (pause,)
        state((10, 0), "4", label: ${0, 1, 3}$, final: true)
        transition("3", "4", label: (text: $a$), curve: 0)
        (pause,)
        transition("3", "3", label: (text: $b$), anchor: bottom)
        (pause,)
        transition("4", "4", label: (text: $a$), anchor: bottom)
        (pause,)
        state((12.5, 0), "5", label: ${0, 2, 3}$, final: true)
        transition("4", "5", label: (text: $b$), curve: 0.4)
        (pause,)
        transition("5", "4", label: (text: $a$), curve: 0.4)
        (pause,)
        // Ce retour contourne l’éta 4, situé entre les états 5 et 3.
        transition("5", "3", label: (text: $b$, dist: -style-automates.transition.label.dist), curve: -2)
      },
    ))]
]

#slide()
#exercice[
  Soit $L_n = Σ^* a Σ^n$ sur $Σ = {a, b}$, avec $n ∈ ℕ$.
  + Montrer que $L_n$ est reconnu par un automate non déterministe à $n + 2$ états.
  + Montrer que $L_n$ est reconnu par un AD à $2^(n + 2)$ états.
  + Montrer que tout AD reconnaissant $L_n$ possède au moins $2^n$ états.
]


= Accessibilité et émondage

#colonnes-cours(
  columns: colonnes-definition,
  definition[Accessibilité][
    Soit $A = (Σ, Q, I, F, δ)$ un automate et $q ∈ Q$.
    - $q$ est _accessible_ s'il existe un chemin de $I$ à $q$ dans $A$.
    - $q$ est _co-accessible_ s'il existe un chemin de $q$ à $F$ dans $A$.
    - $A$ est _émondé_ si tous ses états sont accessibles et co-accessibles.
  ],
  exercice[Décrire un algorithme déterminant les états accessibles et co-accessibles.],
)
#slide()
#colonnes-cours(
  columns: colonnes-definition,
  theoreme[Tout automate est équivalent à un automate émondé.],
  exercice[Tout automate est-il équivalent à un ADC émondé ?],
)

= Stabilité des langages reconnaissables

== Complémentaire

#theoreme(coeur: true, title: [Stabilité par complémentaire])[
  Si $L ∈ Lrec(Σ)$ alors $Σ^* ∖ L ∈ Lrec(Σ)$.
] <thm-complementaire>

#solution[
  #pause
  Prendre un ADC reconnaissant $L$ et remplacer $F$ par $Q ∖ F$.
  Chaque mot possède un unique chemin, qui aboutit dans un état final exactement lorsque le mot n'appartient pas à $L$.
]
#slide()
#exercice[
  + Montrer que la preuve de @thm-complementaire nécessite un ADC.
  + Dessiner un automate reconnaissant les mots sur $Σ = {a, b}$ n'ayant pas $a a a$ comme facteur.
]

== Automate produit
#theoreme(
  coeur: true,
  title: [Stabilité par intersection, union et différence],
)[$Lrec(Σ)$ est stable par intersection, union et différence.] <thm-operations>
#solution(cours: true)[
  On considère deux ADC $A_k = (Q_k, Σ, i_k, F_k, δ_k)$ de langage $L_k$, pour $k ∈ {1, 2}$.\
  Leur _automate produit_ est $A_1 timess A_2 = (Q_1 timess Q_2, Σ, (i_1, i_2), F, δ)$ avec $δ((q_1, q_2), a) = (δ_1(q_1, a), δ_2(q_2, a)).$
  Le produit simule les deux lectures en parallèle. Chaque opérateur correspond à un choix de $F$ :
  #align(center, table(
    columns: (auto, ..(10em,) * 3),
    align: center + horizon,
    inset: (x: 0.5em, y: 0.5em),
    table.header(
      [], $L_1 ∩ L_2$,
      $L_1 ∪ L_2$, $L_1 ∖ L_2$,
    ),
    $F$,
    ..(
      $F_1 timess F_2$,
      $(F_1 timess Q_2) ∪ (Q_1 timess F_2)$,
      $F_1 timess (Q_2 ∖ F_2)$,
    ).map(reponse => if est-corrige() { reponse } else { completer() }),
  ))
]

#exercice[
  + Donner une construction plus simple pour reconnaître $L_1 ∪ L_2$.
  + En déduire que $Lrec(Σ)$ est stable par intersection et différence, sans utiliser l'automate produit.
]

#exercice[
  + Montrer que $L = {m | |m|_a ≡ 0 #sep mod #sep 2, #sep |m|_b ≡ 1 #sep mod #sep 3}$ est reconnaissable.
  + Est-il nécessaire de supposer que $A_1$ et $A_2$ sont des ADC dans la preuve de @thm-operations ?
]

= Lemme de l'étoile

#lemme(coeur: true, title: [Lemme de l'étoile])[
  Soit $L$ reconnu par un automate à $n$ états. Pour tout $m ∈ L$ de taille au moins $n$, il existe des mots $x, y, z$ tels que :
  $ m = x y z, quad abs(x y) ≤ n, quad y ≠ ε, quad x y^* z ⊂ L. $
]<lem-etoile>
// #solution[
//   prendre un chemin acceptant d'étiquette $m$.
//   Parmi ses $n + 1$ premiers états, deux sont égaux : $q_i = q_j$, avec $0 ≤ i < j ≤ n$.
//   Décomposer le mot en $x$, avant $q_i$, $y$, entre $q_i$ et $q_j$, et $z$, après $q_j$.

//   #dessiner-automate(
//     (("q_0", (0, 0), true, false), ("q_i", (4, 0), false, false), ("q_p", (8, 0), false, true)),
//     (("q_0", "q_i", "x", (curve: 0)), ("q_i", "q_i", "y", (:)), ("q_i", "q_p", "z", (curve: 0))),
//   )
// On a $abs(x y) = j ≤ n$ et $abs(y) = j - i > 0$.
// Répéter le cycle $k$ fois donne un chemin acceptant d'étiquette $x y^k z$, y compris pour $k = 0$.
// ]
//
#slide()
#underline[Attention] :
- La réciproque du lemme de l'étoile est fausse.
- On peut choisir $m$ mais pas sa décomposition $x y z$.

#methode(title: [Montrer que $L$ n'est pas reconnaissable.])[
  + Supposer par l'absurde que $L$ est reconnu par un automate à $n$ états.
  + Choisir $m ∈ L$ avec $abs(m) ≥ n$.
  + Appliquer le lemme de l'étoile pour obtenir une décomposition $m = x y z$.
  + Trouver $k$ tel que $x y^k z ∉ L$ pour aboutir à une contradiction.
]

#slide()
#exercice[
  Montrer que les langages suivants ne sont pas reconnaissables :
  #colonnes-cours(
    enum[$L_1 = {a^n b^n ∣ n ∈ ℕ}$],
    enum(start: 2)[$L_2 = {a^n b^p ∣ n, p ∈ ℕ, #sep n ≠ p}$],
  )
]
#solution[
  == Correction : autant de a que de b
  Supposer que $L_1$ est reconnu par un automate à $n ≥ 1$ états.
  Prendre $m = a^n b^n$. Comme $abs(x y) ≤ n$, on a $y = a^j$ avec $j > 0$.
  Alors $x z = a^(n - j) b^n ∉ L_1$, contradiction pour $k = 0$.

  == Correction : des nombres différents
  Si $L_2$ était reconnaissable, $a^* b^* ∖ L_2 = L_1$ le serait aussi par stabilité par différence.
]

#underline[Remarques] :
- Les automates sont sans mémoire : le choix d'une transition dépend uniquement de l'état actuel et de la lettre lue, pas du chemin déjà parcouru. Ils ne peuvent donc pas compter un nombre arbitraire, d'où $L_1, L_2 ∉ Lrec(Σ)$.
- Mais ${a^n b^p | n ≡ p mod 2} ∈ Lrec(Σ)$ car il suffit de mémoriser la parité du nombre de $a$ et de $b$ lus.

#hp[= Compléments]

- #lien("residuels-minimisation")[Théorème de Myhill-Nerode] : condition nécessaire et suffisante pour qu'un langage soit reconnaissable.
- #lien("residuels-minimisation")[Automate minimal] : un automate $A$ est équivalent à un unique ADC minimal $M(A)$. Les algorithmes de Moore et Hopcroft calculent une relation d'équivalence par raffinement de partition, Brzozowski calcule $M(A) = PP((PP(A^top))^top).$
- Machine de Turing : modélise un ordinateur avec un automate et une mémoire infinie.
