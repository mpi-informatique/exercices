#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Convergence sans convergence absolue",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 3,
  ),
)[
  #question[À l'aide d'une intégration par parties sur $[1, R]$, montrer que $∫_1^(+∞) (sin t) / t dif t$ converge.][Pour $R ≥ 1$,
    $ ∫_1^R (sin t) / t dif t = cos 1 - (cos R) / R - ∫_1^R (cos t) / t^2 dif t. $
    Le terme de bord tend vers $0$ et la dernière intégrale converge absolument puisque $abs(cos t) / t^2 ≤ 1 / t^2$.]

  #question[Pour $x ≥ 1$, noter $r(x) = ∫_x^(+∞) (sin t) / t dif t$. Montrer que $abs(r(x)) ≤ 2 / x$.][La même intégration par parties donne
    $ r(x) = (cos x) / x - ∫_x^(+∞) (cos t) / t^2 dif t. $
    Ainsi $abs(r(x)) ≤ 1 / x + ∫_x^(+∞) 1 / t^2 dif t = 2 / x$.]

  #question[L'intégrale est-elle absolument convergente ?
    #linebreak()
    _Indication : comparer $abs(sin t)$ à $sin^2 t$, puis utiliser $sin^2 t = (1 - cos(2t)) / 2$._][Une intégration par parties, comme à la première question, montre que $∫_1^(+∞) cos(2t) / t dif t$ converge :
    $ ∫_1^R cos(2t) / t dif t = [(sin(2t)) / (2t)]_1^R + 1 / 2 ∫_1^R (sin(2t)) / t^2 dif t. $
    Comme $abs(sin t) ≥ sin^2 t$,
    $ ∫_1^R abs(sin t) / t dif t ≥ 1 / 2 ln R - 1 / 2 ∫_1^R cos(2t) / t dif t ⟶ +∞. $
    L'intégrale de $(sin t) / t$ est donc convergente mais pas absolument convergente.]
]
