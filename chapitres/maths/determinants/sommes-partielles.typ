#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Déterminant des sommes partielles",
      chapitres: ("determinants",),
      difficulte: 1,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soit $n >= 1$ et, pour $1 <= k <= n$, $S_(k) = sum_(i = 1)^k i$.

  #question[Calculer
          $ D_(n) = mat(
            delim: "|",
            S_(1), S_(1), dots.h, S_(1);
            S_(1), S_(2), dots.h, S_(2);
            dots.v, dots.v, dots.down, dots.v;
            S_(1), S_(2), dots.h, S_(n)
          ) $.][Effectuer $L_(i) arrow.l L_(i) - L_(i - 1)$ dans l'ordre $i = n, n - 1, dots, 2$.
          Les $i - 1$ premiers coefficients de la ligne $i$ deviennent nuls, et les suivants valent $S_(i) - S_(i - 1) = i$.
          On obtient
          $ D_(n) = mat(
            delim: "|",
            1, 1, dots.h, 1;
            0, 2, dots.h, 2;
            dots.v, dots.down, dots.down, dots.v;
            0, dots.h, 0, n
          ) = product_(i = 1)^n i = n! $.]
]
