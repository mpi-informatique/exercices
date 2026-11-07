#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Un endomorphisme de carré nul",
    chapitres: ("reduction",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 2,
  ),
)[
  On considère $u : RR^3 → RR^3$ défini par $u(x, y, z) = (y, 0, 0)$.

  #question[Déterminer les valeurs propres et les sous-espaces propres de $u$. L'endomorphisme $u$ est-il diagonalisable ?][Comme $u^2 = 0$, une valeur propre $λ$ vérifie $λ^2 = 0$, donc $λ = 0$.
    Le sous-espace propre est $ker u = {(x, 0, z) : (x, z) ∈ RR^2}$, de dimension $2$.
    Ainsi $u$ n'est pas diagonalisable.]

  Soit désormais $v$ un endomorphisme non nul de $RR^3$ tel que $v^2 = 0$.

  #question[Comparer $"Im" v$ et $ker v$, puis déterminer le rang de $v$.][Pour tout $x$, $v(v(x)) = 0$ : ainsi $"Im" v ⊂ ker v$.
    Si $r = "rg" v$, le théorème du rang donne $r ≤ 3 - r$, donc $r ≤ 1$.
    Puisque $v ≠ 0$, on a $r = 1$ et $dim ker v = 2$.]

  #question[Construire une base dans laquelle la matrice de $v$ est celle de $u$ dans la base canonique.

    _Indication :_ partir d'un vecteur $a$ tel que $v(a) ≠ 0$.][Choisir $a$ tel que $b = v(a) ≠ 0$. Alors $v(b) = 0$.
    Compléter $b$ en une base $(b, c)$ de $ker v$.
    Comme $a ∉ ker v$, la famille $(b, a, c)$ est une base de $RR^3$.
    Les images sont respectivement $0$, $b$ et $0$ : la matrice est
    $ mat(0, 1, 0; 0, 0, 0; 0, 0, 0). $
    Tous les endomorphismes non nuls de carré nul de $RR^3$ ont donc des matrices semblables.]
]
