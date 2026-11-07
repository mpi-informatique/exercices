#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
      titre: "Spectre d'une rotation",
      chapitres: ("reduction",),
      difficulte: 1,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  On considère $R = mat(0, -1; 1, 0)$.

  #question[Calculer le polynôme caractéristique de $R$. La matrice est-elle trigonalisable ou diagonalisable sur $RR$ ?][On a $χ_R (X) = X^2 + 1$, qui n'a pas de racine réelle.
          Ce polynôme n'est pas scindé sur $RR$, donc $R$ n'est pas trigonalisable sur $RR$. Elle n'y est donc pas diagonalisable non plus.]

  #question[Déterminer les sous-espaces propres de $R$ sur $CC$ et donner une base de $CC^2$ dans laquelle sa matrice est diagonale.][Sur $CC$, les valeurs propres sont $i$ et $-i$.
          La résolution donne $E_i (R) = "Vect"((1, -i))$ et $E_(-i) (R) = "Vect"((1, i))$.
          Ces deux vecteurs propres associés à des valeurs propres distinctes forment une base, dans laquelle la matrice vaut $"diag"(i, -i)$.]
]
