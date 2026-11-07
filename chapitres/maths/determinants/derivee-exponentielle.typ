#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Déterminant de la dérivation sur un espace de fonctions",
      chapitres: ("determinants",),
      difficulte: 1,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soit $n in NN$ et $V = \{x |-> e^x P(x) | P in RR_(n)[X]\}$.

  #question[Montrer que $V$ est un sous-espace vectoriel de l'espace des fonctions de $RR$ dans $RR$ et déterminer sa dimension.][L'application $P mapsto (x mapsto e^x P(x))$, définie sur $RR_(n)[X]$, est linéaire et injective, car $e^x$ ne s'annule jamais. Son image est $V$.
          Ainsi $V$ est un sous-espace de dimension $n + 1$.
          En posant $f_(k)(x) = x^k e^x$, l'image de la base $(1, X, dots, X^n)$ est la base $cal(B) = (f_(0), dots, f_(n))$ de $V$.]

  #question[Montrer que $D : f mapsto f'$ est un endomorphisme de $V$ et calculer son déterminant.][Si $f(x) = e^x P(x)$, alors $f'(x) = e^x (P(x) + P'(x))$.
          Comme $P + P'$ appartient à $RR_(n)[X]$, la dérivation envoie $V$ dans lui-même. Elle est linéaire, donc $D in cal(L)(V)$.
          De plus, $D(f_(0)) = f_(0)$ et, pour $1 <= k <= n$, $D(f_(k)) = f_(k) + k f_(k - 1)$.
          Pour $n >= 1$, sa matrice dans $cal(B)$ est
          $ "Mat"_(cal(B))(D) = mat(
            1, 1, 0, dots.h, 0;
            0, 1, 2, dots.down, dots.v;
            dots.v, dots.down, dots.down, dots.down, 0;
            dots.v, dots.v, dots.down, 1, n;
            0, dots.h, dots.h, 0, 1
          ) $.
          Elle est triangulaire supérieure, de diagonale constante égale à $1$, donc $det D = 1$.
          Pour $n = 0$, sa matrice est $(1)$ et le résultat reste vrai.]
]
