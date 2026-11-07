#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Deux termes divergents, une différence convergente",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 1,
  ),
)[
  #question[Étudier la convergence de $∫_0^(+∞) 1 / ((t + 1)(t + 2)) dif t$, puis calculer sa valeur.][L'intégrande est continue sur $[0, +∞[$ et équivalente à $1 / t^2$ en $+∞$, donc l'intégrale converge.
    Sur un segment $[0, R]$, écrire
    $ 1 / ((t + 1)(t + 2)) = 1 / (t + 1) - 1 / (t + 2). $
    L'intégrale partielle vaut $ln((R + 1) / (R + 2)) + ln 2$ et tend vers $ln 2$.]

  #question[Peut-on appliquer directement la linéarité aux intégrales de $1 / (t + 1)$ et de $1 / (t + 2)$ sur $[0, +∞[$ ? Justifier.][Non : chacune diverge vers $+∞$, puisque son intégrale partielle est un logarithme qui tend vers $+∞$.
    La différence de leurs intégrales n'est donc pas définie. Il faut effectuer la soustraction sur le même segment $[0, R]$ avant de passer à la limite.]
]
