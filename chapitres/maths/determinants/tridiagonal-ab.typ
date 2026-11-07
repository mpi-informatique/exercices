#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Déterminant tridiagonal à deux paramètres",
      chapitres: ("determinants",),
      difficulte: 3,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soient $a, b in RR$. On pose $D_(0) = 1$ et, pour $n >= 1$ :
  $ D_(n) = lr(
    mat(
      delim: "|",
      a + b, b, 0, dots.h, 0;
      a, a + b, b, dots.down, dots.v;
      0, a, dots.down, dots.down, 0;
      dots.v, dots.down, dots.down, a + b, b;
      0, dots.h, 0, a, a + b
    ) brace.r
  ) n $.

  #question[Calculer $D_(n)$.][On a $D_(1) = a + b$.
        Pour $n >= 2$, développer suivant la première colonne. Le terme en $a + b$ vaut $(a + b) D_(n - 1)$.
        Le terme en $a$ a un signe négatif, et son mineur a pour première ligne $(b, 0, dots, 0)$ : un second développement donne $b D_(n - 2)$.
        Ainsi
        $D_(n) = (a + b) D_(n - 1) - a b D_(n - 2)$.
        L'équation caractéristique est $(r - a) (r - b) = 0$.
        Si $a != b$, les conditions initiales conduisent à la suite $D_(n) = (a^(n + 1) - b^(n + 1)) / (a - b)$.
        En effet, cette expression vérifie la récurrence et vaut $1$ pour $n = 0$, puis $a + b$ pour $n = 1$.
        Cette vérification reste valable si l'un des paramètres est nul.
        Si $a = b != 0$, poser $u_(n) = D_(n) / a^n$.
        La récurrence devient $u_(n) = 2 u_(n - 1) - u_(n - 2)$, donc les différences successives sont constantes.
        Comme $u_(0) = 1$ et $u_(1) = 2$, on obtient $D_(n) = (n + 1) a^n$.
        Si $a = b = 0$, la matrice est nulle, donc $D_(n) = 0$ pour $n >= 1$ : la même formule reste valable.]
]
