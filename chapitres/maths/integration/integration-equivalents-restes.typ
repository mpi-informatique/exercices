#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Quel intervalle faut-il intégrer ?",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 2,
  ),
)[
  Sur $[1, +∞[$, poser $f(t) = 1 / (1 + t^2)$ et $g(t) = 1 / t^2$.

  #question[Vérifier que $f ∼ g$ à l'infini. Les fonctions $x ⟼ ∫_1^x f$ et $x ⟼ ∫_1^x g$ sont-elles équivalentes ?][$f(t) / g(t) = t^2 / (1 + t^2) ⟶ 1$.
    Pourtant $∫_1^x f = arctan x - π / 4 ⟶ π / 4$, tandis que $∫_1^x g = 1 - 1 / x ⟶ 1$.
    Le quotient des intégrales partielles tend vers $π / 4 ≠ 1$.]

  #question[Donner un équivalent de chacun des deux restes à l'infini. Expliquer la différence avec la première question.][$g$ est positive et intégrable, donc le théorème d'intégration des équivalents s'applique aux restes :
    $ ∫_x^(+∞) f(t) dif t ∼ ∫_x^(+∞) g(t) dif t = 1 / x. $
    Un comportement au voisinage de l'infini détermine celui des restes, mais pas la valeur totale des intégrales, qui dépend aussi des valeurs près de $1$.]

  #question[Comparer maintenant $∫_1^x t / (1 + t^2) dif t$ et $∫_1^x 1 / t dif t$.][Les intégrandes sont équivalentes et l'intégrale de référence diverge : l'intégration des équivalents donne cette fois l'équivalence des intégrales partielles.
    On le vérifie directement : $∫_1^x t / (1 + t^2) dif t = 1 / 2 ln((1 + x^2) / 2) ∼ ln x$.]
]
