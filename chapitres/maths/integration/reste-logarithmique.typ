#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Un logarithme à l'infini",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 1,
  ),
)[
  #question[Par intégration par parties sur $[1, R]$, étudier la convergence et calculer $∫_1^(+∞) (ln t) / t^2 dif t$.][L'intégration par parties donne
    $ ∫_1^R (ln t) / t^2 dif t = [- (ln t) / t]_1^R + ∫_1^R 1 / t^2 dif t = 1 - (ln R + 1) / R. $
    La limite vaut $1$. L'intégrande étant positive, l'intégrale converge absolument.]

  #question[Calculer le reste à partir de $x ≥ 1$, puis en donner un équivalent à l'infini.][Par Chasles, $∫_x^(+∞) (ln t) / t^2 dif t = (ln x + 1) / x ∼ (ln x) / x$.]
]
