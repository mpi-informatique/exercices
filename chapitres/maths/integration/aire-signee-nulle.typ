#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
    titre: "Une aire peut en cacher une autre",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 1,
  ),
)[
  #question[Étudier le signe de $f(t) = (t - 1)e^(-t)$ sur $[0, +∞[$ et trouver une primitive de $f$.][$f$ est négative sur $[0, 1]$ et positive sur $[1, +∞[$. Une primitive est $F(t) = -t e^(-t)$.]

  #question[Montrer que $f$ est intégrable, puis calculer $∫_0^(+∞) f(t) dif t$ et $∫_0^(+∞) abs(f(t)) dif t$.
    Que montre cet exemple sur l'hypothèse de positivité dans le théorème de l'intégrale nulle ?][Comme $F(0) = 0$, $F(1) = -1 / e$ et $F(t) ⟶ 0$ à l'infini,
    $ ∫_0^1 f = -1 / e, #sep ∫_1^(+∞) f = 1 / e. $
    Le changement de signe permet donc de calculer l'intégrale de $abs(f)$ : elle converge et vaut $2 / e$.
    Par linéarité, $∫_0^(+∞) f = 0$, alors que $f$ n'est pas nulle. La positivité est essentielle.]
]
