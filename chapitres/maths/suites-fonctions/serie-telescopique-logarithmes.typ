#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Des fractions à une série de logarithmes",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 1,
))[

  Pour $x ∈ [0, 1]$, on pose $u_n (x) = 1 / ((n + x)(n + x + 1))$, avec $n ≥ 1$.
  #question[Montrer la convergence normale de $∑ u_n$ et calculer sa somme.][$0 ≤ u_n (x) ≤ 1 / (n(n + 1))$, dont la série converge par télescopage. De plus,
    $ ∑_(n = 1)^N u_n (x) = ∑_(n = 1)^N (1 / (n + x) - 1 / (n + x + 1)) = 1 / (1 + x) - 1 / (N + x + 1). $
    La somme vaut donc $1 / (1 + x)$.]
  #question[En intégrant terme à terme sur $[0, 1]$, calculer $∑_(n = 1)^(+∞) ln((n + 1)^2 / (n(n + 2)))$.][Les termes sont continus et la convergence est uniforme sur le segment, donc on peut intégrer terme à terme. Or
    $ ∫_0^1 u_n (x) dif x = ln((n + 1)^2 / (n(n + 2))). $
    La somme des intégrales vaut $∫_0^1 1 / (1 + x) dif x = ln 2$.]

]
