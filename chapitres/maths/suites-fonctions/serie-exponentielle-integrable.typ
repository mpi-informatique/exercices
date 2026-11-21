#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une somme continue qui perd la dérivabilité",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 3,
))[

  On pose $u_n (x) = x e^(-n x) / n$ pour $n ≥ 1$ et $x ≥ 0$.
  #question[Montrer que $∑ u_n$ converge normalement sur $[0, +∞[$. On note $F$ sa somme.][$u_n$ est positive et son maximum est atteint en $x = 1 / n$, avec $norm(u_n)_∞ = 1 / (e n^2)$. La série de ces normes converge. La somme $F$ est donc continue sur $[0, +∞[$, et $F(0) = 0$.]
  #question[Pour $x > 0$, montrer que $F(x) = -x ln(1 - e^(-x))$. La fonction $F$ est-elle dérivable à droite en $0$ ?
    #linebreak()
    _Indication : intégrer une série géométrique pour calculer $∑_(n ≥ 1) r^n / n$._][Pour $0 ≤ r < 1$, l'intégration de la série géométrique sur $[0, r]$ donne $∑_(n = 1)^(+∞) r^n / n = -ln(1 - r)$. On prend $r = e^(-x)$, puis on multiplie par $x$.
    Comme $1 - e^(-x) ∼ x$ en $0^+$, $F(x) / x = -ln(1 - e^(-x)) ⟶ +∞$. La fonction est continue mais n'a pas de dérivée à droite finie en $0$. D'ailleurs $u'_n (0) = 1 / n$, donc la série des dérivées ne converge même pas en ce point.]
  #question[Montrer que $F$ est intégrable sur $[0, +∞[$ et exprimer son intégrale à l'aide d'une série numérique convergente.][Les fonctions $u_n$ sont positives et continues. Une intégration par parties donne $∫_0^(+∞) x e^(-n x) dif x = 1 / n^2$, donc $∫_0^(+∞) u_n = 1 / n^3$.
    La série de ces intégrales converge. Le théorème d'intégration terme à terme des fonctions positives assure que $F$ est intégrable et que
    $ ∫_0^(+∞) F(x) dif x = ∑_(n = 1)^(+∞) 1 / n^3. $
    La convergence normale sur un intervalle non borné n'aurait pas suffi à elle seule à justifier cette intégration.]

]
