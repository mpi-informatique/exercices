#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Un calcul par encadrements",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 3,
  ),
)[
  Pour $t > 0$, on pose $f(t) = (e^(-t) - e^(-2t)) / t$.

  #question[Montrer que $f$ se prolonge par continuité en $0$ et que $∫_0^(+∞) f(t) dif t$ converge.][On écrit $f(t) = e^(-t)(1 - e^(-t)) / t$, d'où $f(t) → 1$ en $0$ par dérivabilité de l'exponentielle.
    Il n'y a donc pas de singularité après prolongement.
    Pour $t ≥ 1$, on a $0 ≤ f(t) ≤ e^(-t) / t ≤ e^(-t)$.
    L'intégrale converge en $+∞$ par comparaison, donc sur tout $]0, +∞[$.]

  #question[Pour $0 < ε < R$, exprimer $∫_ε^R f(t) dif t$ à l'aide de deux intégrales de $u ↦ e^(-u) / u$, l'une sur $[ε, 2ε]$ et l'autre sur $[R, 2R]$.
    _Indication :_ transformer le terme contenant $e^(-2t)$ avant d'utiliser Chasles.][Sur le segment $[ε, R]$, on peut séparer les deux termes.
    Le changement de variable $u = 2t$ transforme le second en $∫_(2ε)^(2R) e^(-u) / u dif u$.
    Pour une primitive $H$ de $u ↦ e^(-u) / u$ sur $]0, +∞[$, la différence vaut
    $ H(R) - H(ε) - H(2R) + H(2ε), $
    d'où
    $ ∫_ε^R f(t) dif t = ∫_ε^(2ε) e^(-u) / u dif u - ∫_R^(2R) e^(-u) / u dif u, $
    quel que soit l'ordre de $R$ et de $2ε$.]

  #question[Encadrer l'intégrale sur $[ε, 2ε]$ à l'aide de $e^(-2ε) ln 2$ et de $e^(-ε) ln 2$.
    Majorer celle sur $[R, 2R]$, puis calculer $∫_0^(+∞) f(t) dif t$.][Sur $[ε, 2ε]$, $e^(-2ε) ≤ e^(-u) ≤ e^(-ε)$, donc
    $ e^(-2ε) ln 2 ≤ ∫_ε^(2ε) e^(-u) / u dif u ≤ e^(-ε) ln 2. $
    Ce terme tend vers $ln 2$ lorsque $ε → 0^+$.
    De même,
    $ 0 ≤ ∫_R^(2R) e^(-u) / u dif u ≤ e^(-R) ln 2 → 0. $
    La convergence aux deux bornes ayant été établie, on peut passer à leurs limites séparées dans l'identité précédente : $∫_0^(+∞) f(t) dif t = ln 2$.]
]
