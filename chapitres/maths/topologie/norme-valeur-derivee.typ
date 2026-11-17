#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une valeur et une dérivée pour mesurer une fonction",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 3,
))[
  Sur $E = C^1 ([0, 1], RR)$, on note $norm(f)_∞ = max_(t ∈ [0, 1]) abs(f(t))$ et on pose
  $ N(f) = abs(f(0)) + norm(f')_∞, quad M(f) = norm(f)_∞ + norm(f')_∞. $

  #question[Montrer que $N$ et $M$ sont des normes sur $E$.][Les expressions sont positives, homogènes et vérifient l'inégalité triangulaire.
    Si $N(f) = 0$ alors $f' = 0$ et $f(0) = 0$. La fonction $f$ est donc constante et nulle.
    Si $M(f) = 0$ alors $norm(f)_∞ = 0$, donc $f = 0$. Les deux expressions sont des normes.]

  #question[Montrer que $norm(f)_∞ ≤ N(f)$, puis comparer $N$ et $M$. Les constantes obtenues sont-elles optimales ?][Pour $t ∈ [0, 1]$, le théorème fondamental donne
    $ abs(f(t)) = abs(f(0) + ∫_0^t f'(s) dif s) ≤ abs(f(0)) + t norm(f')_∞ ≤ N(f). $
    Ainsi $norm(f)_∞ ≤ N(f)$. D'autre part, $abs(f(0)) ≤ norm(f)_∞$, d'où
    $ N(f) ≤ M(f) ≤ 2N(f). $
    Les normes sont équivalentes. La constante $1$ dans la première inégalité est optimale pour une fonction constante non nulle. La constante $2$ dans la seconde est optimale pour $f(t) = t$.]

  #question[Ces deux normes sont-elles équivalentes à $norm(·)_∞$ sur $E$ ?
    #linebreak()
    _Indication : chercher des fonctions de petite amplitude dont la dérivée est grande._][Pour chaque entier $n ≥ 1$, on pose $f_n (t) = sin(n t)$. Alors $norm(f_n)_∞ ≤ 1$, tandis que $f_n (0) = 0$ et $norm(f'_n)_∞ = n$, car $f'_n (t) = n cos(n t)$.
    On a donc $N(f_n) = n$. Il n'existe aucune constante $C$ telle que $N(f) ≤ C norm(f)_∞$ pour tout $f ∈ E$.
    La norme $N$ n'est pas équivalente à la norme uniforme. Puisque $N ≤ M$, la même obstruction vaut pour $M$.]
]
