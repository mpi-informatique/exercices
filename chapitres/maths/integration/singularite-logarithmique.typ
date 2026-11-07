#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Une singularité logarithmique",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 1,
  ),
)[
  #question[Pour $0 < ε < 1$, calculer $∫_ε^1 -ln t dif t$ par intégration par parties.
    En déduire la nature et la valeur de $∫_0^1 -ln t dif t$.][L'intégration par parties sur $[ε, 1]$ donne
    $ ∫_ε^1 -ln t dif t = [-t ln t + t]_ε^1 = 1 + ε ln ε - ε. $
    Comme $ε ln ε → 0$, l'intégrale converge et vaut $1$.
    Une fonction peut donc tendre vers $+∞$ à une borne et avoir une intégrale convergente.]

  #question[En posant $t = u^2$, étudier la convergence et calculer $∫_0^1 (-ln t) / sqrt(t) dif t$.][Pour $0 < ε < 1$, le changement de variable donne
    $ ∫_ε^1 (-ln t) / sqrt(t) dif t = 4 ∫_(sqrt(ε))^1 -ln u dif u. $
    La première question permet de passer à la limite : l'intégrale converge et vaut $4$.]
]
