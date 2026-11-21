#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une somme qui retrouve les nombres harmoniques",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 3,
))[

  Pour $x ≥ 0$, on pose $F(x) = ∑_(n = 1)^(+∞) 1 / (n(n + x))$.
  #question[Justifier la définition de $F$, sa continuité et sa décroissance sur $[0, +∞[$.][$0 < 1 / (n(n + x)) ≤ 1 / n^2$ donne la convergence normale sur tout l'intervalle. La somme est continue. Chaque terme décroît en $x$, donc $F$ décroît, et même strictement car le premier terme décroît strictement.]
  #question[Pour un entier $m ≥ 1$, exprimer $m F(m)$ à l'aide de $H_m = ∑_(n = 1)^m 1 / n$.
    #linebreak()
    _Indication : décomposer $1 / (n(n + m))$ en deux fractions._][$m / (n(n + m)) = 1 / n - 1 / (n + m)$. Pour $N ≥ m$, la somme de $1$ à $N$ vaut $H_m - ∑_(n = N + 1)^(N + m) 1 / n$. Le dernier terme est compris entre $0$ et $m / (N + 1)$ et tend vers $0$. Ainsi $m F(m) = H_m$.]
  #question[Montrer que $H_m ∼ ln m$, puis déterminer un équivalent de $F(x)$ lorsque $x ⟶ +∞$.][La comparaison avec l'intégrale de $1 / t$ donne $ln(m + 1) ≤ H_m ≤ 1 + ln m$, donc $H_m ∼ ln m$.
    Pour $m ≤ x < m + 1$, la décroissance donne $H_(m + 1) / (m + 1) ≤ F(x) ≤ H_m / m$. Comme $m ∼ x$ et $ln m ∼ ln x$, les deux bornes sont équivalentes à $(ln x) / x$. Ainsi $F(x) ∼ (ln x) / x$.]

]
