#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une limite avec un angle",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 2,
))[
  Pour $n ≥ 1$ et $x ∈ RR$, poser $f_n (x) = sqrt(x^2 + 1 / n)$.

  #question[Déterminer la limite simple $f$ de $(f_n)$ sur $RR$. Calculer $sup_(x ∈ RR) abs(f_n (x) - f(x))$.][$f(x) = abs(x)$. En rationalisant,
    $ 0 ≤ f_n (x) - abs(x) = (1 / n) / (sqrt(x^2 + 1 / n) + abs(x)) ≤ 1 / sqrt(n). $
    L'égalité est atteinte en $0$. Le supremum vaut donc $1 / sqrt(n)$ et la convergence est uniforme sur $RR$, bien que les fonctions soient non bornées.]

  #question[Étudier la convergence simple de $(f'_n)$. Est-elle uniforme sur $[-1, 1]$ ? Comparer la régularité des $f_n$ à celle de $f$.][$f'_n (x) = x / sqrt(x^2 + 1 / n)$ tend vers $1$ pour $x > 0$, $-1$ pour $x < 0$ et vaut $0$ en $0$.
    Cette limite est discontinue en $0$, donc la convergence des dérivées continues n'est pas uniforme sur $[-1, 1]$.
    Chaque $f_n$ est de classe $C^1$, alors que $f(x) = abs(x)$ n'est pas dérivable en $0$. La convergence uniforme conserve la continuité, pas la dérivabilité à elle seule.]

  #question[Pour $a > 0$, justifier la convergence uniforme des dérivées sur $[a, +∞[$.][Sur cet intervalle,
    $ abs(f'_n (x) - 1) = (f_n (x) - x) / f_n (x) ≤ 1 / (a sqrt(n)) ⟶ 0. $
    L'obstacle à la convergence uniforme sur un intervalle contenant $0$ se situe donc près de ce point.]
]
