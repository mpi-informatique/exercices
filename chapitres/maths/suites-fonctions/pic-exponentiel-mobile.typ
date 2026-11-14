#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Un pic qui se rapproche de zéro",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 2,
))[
  Pour $n ≥ 1$ et $x ≥ 0$, poser $f_n (x) = n x e^(-n x)$.

  #question[Étudier la convergence simple, puis la convergence uniforme sur $[0, +∞[$.][Pour $x > 0$, la décroissance exponentielle donne $f_n (x) ⟶ 0$, et $f_n (0) = 0$.
    Le changement d'échelle $u = n x$ donne $sup_(x ≥ 0) f_n (x) = max_(u ≥ 0) u e^(-u) = 1 / e$, atteint en $x = 1 / n$.
    La convergence vers $0$ est simple mais pas uniforme.]

  #question[Fixer $a > 0$. La convergence est-elle uniforme sur $[a, +∞[$ ?][$f'_n (x) = n e^(-n x)(1 - n x)$. Dès que $n a ≥ 1$, $f_n$ est décroissante sur $[a, +∞[$.
    Ainsi $sup_(x ≥ a) f_n (x) = n a e^(-n a) ⟶ 0$ : la convergence y est uniforme.]

  #question[Calculer $∫_0^1 f_n (x) dif x$. La convergence des intégrales vers l'intégrale de la limite permet-elle de conclure à la convergence uniforme sur $[0, 1]$ ?][Une intégration par parties donne
    $ ∫_0^1 n x e^(-n x) dif x = (1 - (n + 1)e^(-n)) / n ⟶ 0. $
    C'est bien l'intégrale de la limite nulle, alors que le maximum sur $[0, 1]$ vaut encore $1 / e$.
    La convergence des intégrales n'implique donc pas la convergence uniforme.]
]
