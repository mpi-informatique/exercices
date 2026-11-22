#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Des restes loin de zéro",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 2,
))[
  Pour $n ≥ 1$ et $x ≥ 0$, on pose $u_n (x) = x / (n^2 + x^2)$.

  #question[Montrer que $∑_(n ≥ 1) u_n$ converge simplement sur $[0, +∞[$ et normalement sur chaque segment $[0, A]$, avec $A > 0$.][Pour chaque $x ≥ 0$, on a $0 ≤ u_n (x) ≤ x / n^2$, d'où la convergence simple. Pour $x ∈ [0, A]$, on a de plus $u_n (x) ≤ A / n^2$. La série des normes uniformes sur $[0, A]$ converge donc.]

  #question[Pour tout entier $N ≥ 1$, montrer que $∑_(k = N + 1)^(2 N) u_k (N) ≥ 1 / 5$.][Pour $N + 1 ≤ k ≤ 2 N$, on a $k^2 + N^2 ≤ 5 N^2$, donc $u_k (N) ≥ 1 / (5 N)$. Il y a $N$ termes dans la somme.]

  #question[En étudiant le reste $R_N (x) = ∑_(k = N + 1)^(+∞) u_k (x)$ en $x = N$, montrer que la convergence n'est pas uniforme sur $[0, +∞[$.][Tous les termes étant positifs, $R_N (N) ≥ ∑_(k = N + 1)^(2 N) u_k (N) ≥ 1 / 5$ pour tout $N ≥ 1$. Les restes ne tendent donc pas uniformément vers $0$ sur $[0, +∞[$.]
]
