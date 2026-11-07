#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Où se concentre un reste ?",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 3,
  ),
)[
  Pour $x ≥ 1$, noter $R(x) = ∫_x^(+∞) e^(-t^2) dif t$.

  #question[Justifier l'existence et la stricte positivité de $R(x)$.][Pour $t ≥ 1$, $0 < e^(-t^2) ≤ e^(-t)$. La comparaison prouve la convergence.
    L'intégrale sur $[x, x + 1]$ est strictement positive, donc $R(x) > 0$.]

  #question[En écrivant $e^(-t^2) = (1 / (2t)) 2t e^(-t^2)$, intégrer par parties pour établir
    $ (e^(-x^2) / (2x)) / (1 + 1 / (2x^2)) ≤ R(x) ≤ e^(-x^2) / (2x). $
    En déduire un équivalent de $R(x)$ à l'infini.][L'intégration par parties sur $[x, A]$, puis la limite $A ⟶ +∞$, donnent
    $ R(x) = e^(-x^2) / (2x) - 1 / 2 ∫_x^(+∞) e^(-t^2) / t^2 dif t. $
    Le terme de bord en $A$ tend vers $0$, et la dernière intégrale converge par comparaison.
    Elle est comprise entre $0$ et $R(x) / x^2$. Ainsi
    $ R(x) ≤ e^(-x^2) / (2x) ≤ (1 + 1 / (2x^2))R(x). $
    L'encadrement demandé suit, puis $R(x) ∼ e^(-x^2) / (2x)$.]

  #question[Fixer $c > 0$. Déterminer la limite de $R(x + c / x) / R(x)$, puis celle de
    $ (∫_x^(x + c / x) e^(-t^2) dif t) / R(x). $
    Quelle fraction du reste se trouve dans un intervalle de longueur $c / x$ ?][Comme $x + c / x ⟶ +∞$, l'équivalent précédent donne
    $ R(x + c / x) / R(x) ∼ x / (x + c / x) e^(-((x + c / x)^2 - x^2)) ⟶ e^(-2c). $
    Par Chasles, le second quotient vaut $1 - R(x + c / x) / R(x)$ et tend vers $1 - e^(-2c)$.
    Une fraction non nulle du reste est donc contenue dans un intervalle dont la longueur tend vers $0$.]
]
