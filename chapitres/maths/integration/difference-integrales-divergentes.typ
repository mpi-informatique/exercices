#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Soustraire avant de comparer",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 2,
  ),
)[
  Pour $t ≥ 1$, poser $f(t) = 1 / t - 1 / sqrt(1 + t^2)$.

  #question[Sans développement limité, établir un équivalent de $f$ à l'infini. En déduire son intégrabilité.][En rationalisant,
    $ f(t) = 1 / (t sqrt(1 + t^2)(sqrt(1 + t^2) + t)) ∼ 1 / (2t^3). $
    La fonction est positive et continue sur $[1, +∞[$. La comparaison avec une intégrale de Riemann donne son intégrabilité.]

  #question[Calculer $∫_1^(+∞) f(t) dif t$ en utilisant la primitive $ln(t + sqrt(1 + t^2))$ de $1 / sqrt(1 + t^2)$.][Pour $R ≥ 1$,
    $ ∫_1^R f(t) dif t = ln(R / (R + sqrt(1 + R^2))) + ln(1 + sqrt(2)). $
    Le quotient tend vers $1 / 2$, donc l'intégrale vaut $ln((1 + sqrt(2)) / 2)$.
    Les deux termes de $f$ ont séparément des intégrales divergentes : il fallait conserver leur différence.]

  #question[Donner un équivalent de $∫_x^(+∞) f(t) dif t$ lorsque $x ⟶ +∞$.][L'intégration de l'équivalent, dans le cas convergent, donne
    $ ∫_x^(+∞) f(t) dif t ∼ ∫_x^(+∞) 1 / (2t^3) dif t = 1 / (4x^2). $]
]
