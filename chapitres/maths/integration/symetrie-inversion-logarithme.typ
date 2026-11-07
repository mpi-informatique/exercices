#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Une symétrie par inversion",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 2,
  ),
)[
  #question[Montrer que $t ⟼ (ln t) / (1 + t^2)$ est intégrable sur $]0, +∞[$.][En $0$, $abs(ln t) / (1 + t^2) ∼ -ln t$, dont l'intégrale converge.
    À l'infini, la fonction est équivalente à $(ln t) / t^2$, et $(ln t) / t^2 = o(t^(-3 / 2))$.
    Les comparaisons à chacune des deux bornes donnent l'intégrabilité.]

  #question[Relier les intégrales sur $]0, 1]$ et $[1, +∞[$ avec $t = 1 / u$. En déduire $∫_0^(+∞) (ln t) / (1 + t^2) dif t$.][Pour $0 < ε < 1$, le changement de variable sur le segment donne
    $ ∫_ε^1 (ln t) / (1 + t^2) dif t = -∫_1^(1 / ε) (ln u) / (1 + u^2) dif u. $
    L'intégrabilité justifie les limites : les deux intégrales sont opposées. Leur somme vaut $0$.]

  #question[Le raisonnement prouve-t-il aussi la convergence de $∫_0^(+∞) (ln t) / t dif t$ ? Justifier.][Non. Les intégrales aux deux bornes divergent séparément, car une primitive est $(ln t)^2 / 2$.
    On a pourtant $∫_ε^(1 / ε) (ln t) / t dif t = 0$.
    Une compensation obtenue en liant les deux bornes ne définit pas une intégrale généralisée convergente.]
]
