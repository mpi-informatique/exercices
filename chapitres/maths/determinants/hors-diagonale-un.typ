#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Zéros sur la diagonale, uns ailleurs",
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
      1, 0, dots.down, dots.v;
      dots.v, dots.down, dots.down, 1;
      1, dots.h, 1, 0
    ) brace.r
  ) n $.

  #question[Calculer $D_(n)$ en établissant une relation de récurrence.][Pour $n >= 3$, effectuer $C_(1) arrow.l C_(1) - C_(n)$, puis $L_(1) arrow.l L_(1) - L_(n)$.
          On obtient
          $ D_(n) = mat(
            delim: "|",
            -2, 0, dots.h, 0, 1;
            0, 0, 1, dots.h, 1;
            dots.v, 1, dots.down, dots.down, dots.v;
            0, dots.v, dots.down, 0, 1;
            1, 1, dots.h, 1, 0
          ) $.
          Dans le développement suivant la première ligne, le terme en $-2$ vaut $-2 D_(n - 1)$.
          Dans le terme en $1$, développer le mineur suivant sa première colonne : le seul coefficient non nul vaut $1$, en dernière position.
          Le produit des signes vaut $(-1)^(1 + n) (-1)^n = -1$, et le bloc restant définit $D_(n - 2)$.
          Par conséquent, $D_(n) = -2 D_(n - 1) - D_(n - 2)$.
          L'équation caractéristique est $(r + 1)^2 = 0$, donc $D_(n) = (alpha + beta n) (-1)^n$.
          Les valeurs $D_(1) = 0$ et $D_(2) = -1$ donnent $alpha = 1$ et $beta = -1$, d'où $D_(n) = (-1)^(n - 1) (n - 1)$.]
]
