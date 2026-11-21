#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une série géométrique sur un segment",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 1,
))[

  On pose $u_n (x) = (x / 2)^n$ pour $n ≥ 1$ et $x ∈ [-1, 1]$.
  #question[Montrer que $∑_(n ≥ 1) u_n$ converge normalement et calculer sa somme $S$.][$abs(u_n (x)) ≤ 2^(-n)$, et la série numérique géométrique converge. La convergence est normale, donc uniforme. Pour tout $x ∈ [-1, 1]$, la somme géométrique donne $S(x) = x / (2 - x)$.]
  #question[Justifier une intégration terme à terme sur $[-1, 1]$ et en déduire la valeur de $∑_(k = 1)^(+∞) 1 / (4^k (2k + 1))$.][Les termes sont continus et la convergence est uniforme sur le segment, donc
    $ ∫_(-1)^1 S(x) dif x = ∑_(n = 1)^(+∞) ∫_(-1)^1 (x / 2)^n dif x = 2∑_(k = 1)^(+∞) 1 / (4^k (2k + 1)). $
    Or $x / (2 - x) = 2 / (2 - x) - 1$, donc l'intégrale vaut $2 ln 3 - 2$. La série cherchée vaut $ln 3 - 1$.]

]
