#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une somme périodique de moyenne nulle",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 1,
))[

  Pour $x ∈ RR$, on pose $S(x) = ∑_(n = 1)^(+∞) cos(n x) / 2^n$.
  #question[Montrer que $S$ est bien définie, continue et $2π$-périodique.][$abs(cos(n x) / 2^n) ≤ 2^(-n)$ donne la convergence normale sur $RR$. La somme de fonctions continues est donc continue. La périodicité de chaque terme se conserve par passage à la limite dans les sommes partielles.]
  #question[Calculer $S(0)$, $S(π)$ et $∫_0^(2π) S(x) dif x$. En déduire l'existence d'un zéro dans $]0, π[$.][Les séries géométriques donnent $S(0) = 1$ et $S(π) = -1 / 3$. La convergence uniforme sur $[0, 2π]$ autorise l'intégration terme à terme. Chaque cosinus a une intégrale nulle sur ce segment, donc l'intégrale de $S$ vaut $0$. Enfin, la continuité et les valeurs de signes opposés donnent un zéro dans $]0, π[$ par le théorème des valeurs intermédiaires.]

]
