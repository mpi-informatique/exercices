#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Ce qui se passe près de zéro",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 2,
))[

  On considère $S(x) = ∑_(n = 1)^(+∞) e^(-n x) / n$ pour $x > 0$.
  #question[Montrer la convergence simple et la convergence normale sur chaque $[a, +∞[$ avec $a > 0$.][Pour $x > 0$, $e^(-n x) / n ≤ e^(-n x)$ donne la convergence. Sur $[a, +∞[$, les termes sont majorés par $e^(-n a) / n ≤ e^(-n a)$, dont la série converge.]
  #question[Établir $∑_(n = 1)^(+∞) r^n / n = -ln(1 - r)$ pour $0 ≤ r < 1$, puis calculer $S(x)$.][Sur $[0, r]$, la série géométrique $∑_(k ≥ 0) t^k$ converge uniformément vers $1 / (1 - t)$. Son intégration terme à terme donne l'identité. Avec $r = e^(-x)$, on obtient $S(x) = -ln(1 - e^(-x))$.]
  #question[La convergence de la série définissant $S$ est-elle uniforme sur $]0, +∞[$ ?][Non. Quand $x ⟶ 0^+$, $S(x) ⟶ +∞$, tandis que chaque somme partielle est bornée par $∑_(n = 1)^N 1 / n$. Si la convergence était uniforme, il existerait une somme partielle à distance au plus $1$ de $S$ sur tout l'intervalle. Cette somme étant bornée, $S$ serait bornée, contradiction.]

]
