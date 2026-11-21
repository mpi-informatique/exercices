#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Dériver une série seulement uniformément convergente",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 2,
))[

  Pour $x ≥ 0$, on pose $F(x) = ∑_(n = 1)^(+∞) (-1)^n / (n + x)$.
  #question[Montrer la convergence uniforme sur $[0, +∞[$. Est-elle normale ?][Pour chaque $x ≥ 0$, la suite $1 / (n + x)$ décroît vers $0$. Le critère alterné donne un reste de valeur absolue au plus $1 / (N + 1 + x) ≤ 1 / (N + 1)$, donc la convergence uniforme. Elle n'est pas normale car le supremum du terme en valeur absolue vaut $1 / n$.]
  #question[Justifier la dérivation terme à terme et montrer que $F$ est strictement croissante.][La série des dérivées $∑_(n ≥ 1) (-1)^(n + 1) / (n + x)^2$ converge normalement, car les valeurs absolues sont majorées par $1 / n^2$. Ainsi $F$ est de classe $C^1$ et cette série représente $F'$.
    En regroupant par paires, ce qui est licite puisque les sommes partielles paires ont la même limite,
    $ F'(x) = ∑_(k = 1)^(+∞) (1 / (2k - 1 + x)^2 - 1 / (2k + x)^2) > 0. $
    Donc $F$ est strictement croissante.]
  #question[Déterminer la limite de $F(x)$ en $+∞$ et le signe de $F$.][Le critère alterné donne $abs(F(x)) ≤ 1 / (1 + x)$, donc $F(x) ⟶ 0$. La stricte croissance et cette limite imposent $F(x) < 0$ pour tout $x ≥ 0$.]

]
