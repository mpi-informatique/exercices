#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Déterminant antisymétrique à coefficients constants",
      chapitres: ("determinants",),
      difficulte: 2,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Pour $n >= 1$, on pose
  $ D_(n) = lr(
    mat(
      delim: "|",
      0, 1, dots.h, 1;
      -1, 0, dots.h, 1;
      dots.v, dots.v, dots.down, dots.v;
      -1, -1, dots.h, 0
    ) brace.r
  ) n $.

  #question[Calculer $D_(n)$ en établissant une relation de récurrence.][Pour $n >= 3$, effectuer $C_(1) arrow.l C_(1) + C_(n)$, puis $L_(1) arrow.l L_(1) + L_(n)$.
          Ces opérations conservent le déterminant et donnent
          $ D_(n) = mat(
            delim: "|",
            0, 0, dots.h, 0, 1;
            0, 0, 1, dots.h, 1;
            dots.v, -1, dots.down, dots.down, dots.v;
            0, dots.v, dots.down, 0, 1;
            -1, -1, dots.h, -1, 0
          ) $.
          Développer suivant la première ligne, puis suivant la première colonne du mineur obtenu.
          Le bloc restant est celui qui définit $D_(n - 2)$, et le produit des deux signes de cofacteurs et du coefficient $-1$ vaut $(-1)^(1 + n) (-1)^n (-1) = 1$.
          Ainsi $D_(n) = D_(n - 2)$.
          Comme $D_(1) = 0$ et $D_(2) = 1$, on obtient $D_(n) = cases(0 & "si " n " est impair", 1 & "si " n " est pair") = (1 + (-1)^n)/2$.]
]
