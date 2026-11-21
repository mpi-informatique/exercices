#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Compenser un terme divergent",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 3,
))[

  On étudie $F(x) = ∑_(n = 1)^(+∞) (arctan(x / n) - x / n)$ pour $x ∈ RR$.
  #question[Montrer que $abs(arctan y - y) ≤ abs(y)^3 / 3$ pour $y ∈ RR$. En déduire la convergence normale sur chaque segment de $RR$.][On a $arctan y - y = -∫_0^y t^2 / (1 + t^2) dif t$. Pour $y ≥ 0$, la valeur absolue est majorée par $∫_0^y t^2 dif t = y^3 / 3$. L'imparité étend l'inégalité à $y < 0$.
    Sur $[-A, A]$, les termes sont donc majorés par $A^3 / (3n^3)$, terme général d'une série convergente.]
  #question[Montrer que $F$ est de classe $C^1$ et donner sa dérivée sous forme de série.][Le terme dérivé vaut $1 / (n(1 + x^2 / n^2)) - 1 / n = -x^2 / (n(n^2 + x^2))$. Sur $[-A, A]$, sa valeur absolue est au plus $A^2 / n^3$. La série des dérivées converge donc normalement sur tout segment. Le théorème de dérivation terme à terme donne
    $ F'(x) = -∑_(n = 1)^(+∞) x^2 / (n(n^2 + x^2)). $]
  #question[Déterminer la limite de $F(x) / x^3$ lorsque $x ⟶ 0$.
    #linebreak()
    _Indication : utiliser $t^2 / (1 + t^2) = t^2 - t^4 / (1 + t^2)$ dans la première question._][L'identité de l'indication donne $abs(arctan y - y + y^3 / 3) ≤ abs(y)^5 / 5$. En sommant cette estimation, on obtient
    $ abs(F(x) + x^3 / 3 ∑_(n = 1)^(+∞) 1 / n^3) ≤ abs(x)^5 / 5 ∑_(n = 1)^(+∞) 1 / n^5. $
    Après division par $abs(x)^3$ pour $x ≠ 0$, le majorant tend vers $0$. La limite cherchée vaut $-1 / 3 ∑_(n = 1)^(+∞) 1 / n^3$.]

]
