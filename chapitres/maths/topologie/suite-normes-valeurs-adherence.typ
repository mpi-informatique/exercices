#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "La norme converge, mais pas le vecteur",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 1,
))[
  Pour $n ≥ 1$, on pose $u_n = (1 + (-1)^n / n, (-1)^n) ∈ RR^2$, muni de la norme $norm((x, y))_∞ = max(abs(x), abs(y))$.

  #question[Calculer $norm(u_n)_∞$ selon la parité de $n$. La suite $(u_n)$ est-elle bornée ? La suite de ses normes converge-t-elle ?][Pour $n$ pair, $norm(u_n)_∞ = 1 + 1 / n$. Pour $n$ impair, $0 ≤ 1 - 1 / n ≤ 1$, donc $norm(u_n)_∞ = 1$.
    Les normes sont majorées par $3 / 2$ et tendent vers $1$. La suite de vecteurs est donc bornée.]

  #question[La suite $(u_n)$ converge-t-elle ? Déterminer toutes ses valeurs d'adhérence.][La seconde coordonnée $(-1)^n$ ne converge pas, donc $(u_n)$ ne converge pas.
    Les sous-suites d'indices pairs et impairs tendent respectivement vers $(1, 1)$ et $(1, -1)$.
    Réciproquement, la première coordonnée de toute sous-suite tend vers $1$. Si la seconde coordonnée converge, sa limite est $1$ ou $-1$, puisqu'elle ne prend que ces deux valeurs. Les deux points trouvés sont donc les seules valeurs d'adhérence.
    La convergence des normes n'entraîne pas celle des vecteurs.]
]
