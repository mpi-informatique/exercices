#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Le logarithme décide au seuil",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 3,
  ),
)[
  #question[Étudier la nature de $∫_e^(+∞) 1 / (t ln t) dif t$ en calculant ses intégrales partielles.][Pour $R > e$, l'intégrale sur $[e, R]$ vaut $ln(ln R)$.
    Elle tend vers $+∞$ : l'intégrale diverge.]

  #question[Pour $α ∈ RR$, déterminer la nature de
    $ J_α = ∫_e^(+∞) 1 / (t(ln t)^α) dif t. $
    Calculer $J_α$ lorsqu'elle converge.

    _Indication :_ poser $u = ln t$.][Le changement de variable sur $[e, R]$ donne $∫_1^(ln R) u^(-α) dif u$.
    L'intégrale de référence converge exactement pour $α > 1$, et alors $J_α = 1 / (α - 1)$.]

  #question[L'hypothèse $f(t) = o(1 / t)$ en $+∞$, pour $f : [e, +∞[ → RR_+$ continue, suffit-elle à assurer la convergence de $∫_e^(+∞) f$ ?
    Donner, parmi les fonctions précédentes, un exemple dont l'intégrale converge et un exemple dont l'intégrale diverge, tous deux négligeables devant $1 / t$.][Pour tout $α > 0$, le quotient de $1 / (t(ln t)^α)$ par $1 / t$ vaut $1 / (ln t)^α$ et tend vers $0$.
    Pourtant $α = 1$ donne une intégrale divergente, tandis que $α = 2$ donne une intégrale convergente.
    Être négligeable devant une fonction d'intégrale divergente ne suffit donc pas à conclure.]
]
