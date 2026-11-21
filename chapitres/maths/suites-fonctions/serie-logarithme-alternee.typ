#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Uniforme sans être normale",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 2,
))[

  On considère $∑_(n ≥ 1) (-1)^(n - 1) x^n / n$ sur $[0, 1]$.
  #question[Montrer la convergence simple, puis uniforme, et décider si la convergence est normale.][Pour chaque $x ∈ [0, 1]$, $x^n / n$ décroît vers $0$. Le critère des séries alternées donne la convergence et un reste de valeur absolue au plus $x^(N + 1) / (N + 1) ≤ 1 / (N + 1)$. La convergence est donc uniforme. Elle n'est pas normale puisque le supremum du terme en valeur absolue vaut $1 / n$.]
  #question[Calculer la somme pour $0 ≤ x < 1$, puis en $x = 1$.
    #linebreak()
    _Indication : intégrer une série géométrique sur $[0, x]$._][Pour $x < 1$, la série $∑_(k ≥ 0) (-t)^k$ converge uniformément sur $[0, x]$ et a pour somme $1 / (1 + t)$. L'intégration terme à terme donne $S(x) = ln(1 + x)$. La somme $S$ est continue sur $[0, 1]$, par convergence uniforme de fonctions continues. Ainsi $S(1) = ln 2$.]

]
