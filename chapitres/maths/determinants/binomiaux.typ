#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Déterminant de coefficients binomiaux",
      chapitres: ("determinants",),
      difficulte: 2,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Pour $n >= 1$, on note $binom(i, k)$ le nombre de combinaisons de $k$ éléments parmi $i$ :
  $binom(i, k) = i! / (k! (i - k)!)$ pour $0 <= k <= i$, et $binom(i, k) = 0$ sinon.
  On pose
  $
    D_(n) = det ((binom(i, j))_(1 <= i <= n, 0 <= j <= n - 1)) = mat(
      delim: "|",
      binom(1, 0), binom(1, 1), 0, dots.h, 0;
      binom(2, 0), binom(2, 1), binom(2, 2), dots.h, 0;
      dots.v, dots.v, dots.v, dots.down, dots.v;
      binom(n, 0), binom(n, 1), binom(n, 2), dots.h, binom(n, n - 1)
    )
  $

  #question[Calculer $D_(n)$.][Pour $n >= 2$, effectuer $L_(i) arrow.l L_(i) - L_(i - 1)$ dans l'ordre $i = n, n - 1, dots, 2$.
          La formule de Pascal donne $binom(i, j) - binom(i - 1, j) = binom(i - 1, j - 1)$.
          On obtient donc
          $
            D_(n) = mat(
              delim: "|",
              1, 1, 0, dots.h, 0;
              0, binom(1, 0), binom(1, 1), dots.h, 0;
              dots.v, dots.v, dots.v, dots.down, dots.v;
              0, binom(n - 1, 0), binom(n - 1, 1), dots.h, binom(n - 1, n - 2)
            )
          $
          Le développement suivant la première colonne ne conserve que le coefficient $1$, en première position.
          Le déterminant restant a ses lignes indexées de $1$ à $n - 1$ et ses colonnes de $0$ à $n - 2$ : c'est $D_(n - 1)$.
          Ainsi $D_(n) = D_(n - 1)$ et, comme $D_(1) = binom(1, 0) = 1$, on a $D_(n) = 1$.]
]
