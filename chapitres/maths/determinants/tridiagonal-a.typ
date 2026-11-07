#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Déterminant tridiagonal à diagonale double",
      chapitres: ("determinants",),
      difficulte: 3,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soit $a in RR^*$. On pose $D_(0) = 1$ et, pour $n >= 1$ :
  $ D_(n) = lr(
    mat(
      delim: "|",
      2a, a, 0, dots.h, 0;
      a, 2a, a, dots.down, dots.v;
      0, a, dots.down, dots.down, 0;
      dots.v, dots.down, dots.down, 2a, a;
      0, dots.h, 0, a, 2a
    ) brace.r
  ) n $.

  #question[Calculer $D_(n)$.][On a $D_(1) = 2a$.
        Pour $n >= 2$, développer suivant la première colonne.
        Le terme diagonal vaut $2a D_(n - 1)$.
        L'autre terme porte le signe $-1$ : son mineur a pour première ligne $(a, 0, dots, 0)$ et son développement donne $a D_(n - 2)$.
        Ainsi $D_(n) = 2a D_(n - 1) - a^2 D_(n - 2)$.
        Comme $a != 0$, poser $u_(n) = D_(n) / a^n$.
        Alors $u_(n) - u_(n - 1) = u_(n - 1) - u_(n - 2)$, avec $u_(0) = 1$ et $u_(1) = 2$.
        Les différences successives valent toutes $1$, d'où $u_(n) = n + 1$, puis $D_(n) = (n + 1) a^n$.]
]
