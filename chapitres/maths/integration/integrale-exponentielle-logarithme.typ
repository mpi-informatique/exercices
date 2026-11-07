#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Une exponentielle déguisée",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 1,
  ),
)[
  #question[Justifier la convergence de $∫_0^(+∞) 1 / (1 + e^t) dif t$, puis calculer cette intégrale avec le changement de variable $u = e^(-t)$.][La fonction est continue et $0 ≤ 1 / (1 + e^t) ≤ e^(-t)$, donc l'intégrale converge.
    Sur $[0, R]$, le changement de variable donne
    $ ∫_0^R 1 / (1 + e^t) dif t = ∫_(e^(-R))^1 1 / (1 + u) dif u = ln 2 - ln(1 + e^(-R)). $
    La valeur cherchée est $ln 2$.]

  #question[Donner un équivalent du reste $∫_x^(+∞) 1 / (1 + e^t) dif t$ à l'infini, puis vérifier avec une expression exacte.][Comme $1 / (1 + e^t) ∼ e^(-t)$, l'intégration des équivalents donne un reste équivalent à $e^(-x)$.
    Le calcul précédent donne exactement $ln(1 + e^(-x))$, bien équivalent à $e^(-x)$.]
]
