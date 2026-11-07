#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Des pics de plus en plus hauts",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 3,
  ),
)[
  Pour chaque entier $n ≥ 2$, poser $a_n = 1 / (4n^3)$ et $I_n = [n - a_n, n + a_n]$.
  Définir $f : [1, +∞[ ⟶ RR_+$ par
  $
    f(t) = cases(
      n(1 - abs(t - n) / a_n) & "si " t ∈ I_n,
      0 & "si " t ∉ union.big_(n ≥ 2) I_n
    ).
  $
  Les intervalles $I_n$ sont disjoints.

  #question[Dessiner le graphe de $f$ sur $I_n$. Justifier la continuité de $f$ et calculer $∫_(I_n) f(t) dif t$.][Le graphe sur $I_n$ est un triangle de base $2a_n$ et de hauteur $n$.
    Aux extrémités, $f$ vaut $0$ : les raccords sont continus.
    Tout segment ne rencontre qu'un nombre fini de pics, donc $f$ est continue sur $[1, +∞[$.
    L'aire du triangle vaut $n a_n = 1 / (4n^2)$.]

  #question[Montrer que $f$ est intégrable. A-t-elle une limite en $+∞$ ? Est-elle bornée ?
    #linebreak()
    _Indication : $1 / n^2 ≤ 1 / (n - 1) - 1 / n$ pour $n ≥ 2$._][Pour $R ≥ 1$, choisir un entier $N > R + 1$. Par positivité et avec l'indication,
    $ 0 ≤ ∫_1^R f(t) dif t ≤ 1 / 4 ∑_(n = 2)^N 1 / n^2 ≤ 1 / 4 (1 - 1 / N) ≤ 1 / 4. $
    Les intégrales partielles sont croissantes et majorées, donc $f$ est intégrable.
    Pourtant $f(n) = n$ et $f(n + 1 / 2) = 0$. Elle n'est ni bornée ni convergente à l'infini.]

  #question[La fonction $f^2$ est-elle intégrable ? Comparer avec le cas d'une fonction continue, intégrable et bornée.][Le calcul sur chaque demi-triangle donne
    $ ∫_(I_n) f(t)^2 dif t = 2n^2 ∫_0^(a_n) (1 - u / a_n)^2 dif u = 2n^2 a_n / 3 = 1 / (6n). $
    Ainsi $∫_1^(N + 1 / 2) f(t)^2 dif t = 1 / 6 ∑_(n = 2)^N 1 / n$ diverge, puisque
    $ ∑_(n = 2)^N 1 / n ≥ ∫_2^(N + 1) 1 / t dif t ⟶ +∞. $
    Au contraire, si $g$ est bornée par $M$ et intégrable, $abs(g)^2 ≤ M abs(g)$ prouve l'intégrabilité de $g^2$.]
]
