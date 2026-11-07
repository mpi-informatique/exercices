#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
      titre: "Dominance diagonale stricte",
      chapitres: ("determinants",),
      difficulte: 3,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soit $A = (a_(i, j)) in M_(n)(RR)$, où $n >= 1$, telle que $forall i in \{1, dots, n\}, #sep abs(a_(i, i)) > sum_(j = 1, j != i)^n abs(a_(i, j))$.

  #question[Montrer que $A$ est inversible.][Supposer $A X = 0$ et choisir $i$ tel que $abs(x_(i)) = max_(1 <= j <= n) abs(x_(j))$.
          Si $X != 0$, alors $abs(x_(i)) > 0$, tandis que la ligne $i$ de $A X = 0$ donne $abs(a_(i, i)) abs(x_(i)) <= sum_(j != i) abs(a_(i, j)) abs(x_(j)) <= abs(x_(i)) sum_(j != i) abs(a_(i, j))$.
          Après division par $abs(x_(i))$, cela contredit l'hypothèse. Le noyau de $A$ est nul : $A$ est donc inversible.]

  #question[On suppose en outre $a_(i, i) > 0$ pour tout $i$. Montrer que $det A > 0$.][Pour $t >= 0$, les coefficients diagonaux de $A + t I_(n)$ sont $a_(i, i) + t > 0$ et la dominance diagonale stricte est conservée.
          D'après la question précédente, $det(A + t I_(n)) != 0$ pour tout $t >= 0$.
          Ce déterminant est un polynôme réel en $t$, de coefficient dominant $1$ : il est donc positif pour $t$ assez grand.
          Par le théorème des valeurs intermédiaires, ce polynôme ne peut changer de signe sans s'annuler. Son signe est donc constant sur $[0, + infinity[$, d'où $det A > 0$.]
]
