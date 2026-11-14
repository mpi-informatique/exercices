#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une puissance amortie",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 2,
))[
  Pour $n ≥ 1$ et $x ∈ [0, 1]$, poser $f_n (x) = x^n (1 - x)$.

  #question[Étudier la convergence simple de $(f_n)$ sur $[0, 1]$.][Pour $0 ≤ x < 1$, $x^n ⟶ 0$, donc $f_n (x) ⟶ 0$. Pour $x = 1$, $f_n (1) = 0$. La limite simple est la fonction nulle.]

  #question[Calculer $norm(f_n)_∞$ sur $[0, 1]$. La convergence est-elle uniforme ? Donner un équivalent de cette norme.][$f_n$ est positive et sa dérivée vaut $x^(n - 1)(n - (n + 1)x)$. Le maximum est atteint en $n / (n + 1)$ et vaut
    $ norm(f_n)_∞ = 1 / (n + 1) (n / (n + 1))^n ∼ 1 / (e n). $
    En effet, $n ln(1 - 1 / (n + 1)) ⟶ -1$. La norme tend vers $0$ : la convergence est uniforme.]

  #question[Comparer $f'_n (1)$ et la dérivée de la limite. Quelle hypothèse faut-il contrôler avant d'intervertir limite et dérivée ?][$f'_n (1) = -1$ pour tout $n$, alors que la dérivée de la limite est nulle.
    La convergence uniforme des fonctions ne suffit pas. Il faut notamment contrôler la convergence uniforme des dérivées sur les segments adaptés. Ici les dérivées tendent vers $0$ sur $[0, 1[$ et valent $-1$ en $1$ : leur limite discontinue exclut leur convergence uniforme sur $[0, 1]$.]
]
