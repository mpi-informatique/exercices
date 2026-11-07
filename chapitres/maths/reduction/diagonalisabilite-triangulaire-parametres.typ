#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
      titre: "Une valeur propre double",
      chapitres: ("reduction",),
      difficulte: 2,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Pour $a, b, c ∈ RR$, on considère $A = mat(1, a, b; 0, 1, c; 0, 0, 2)$.

  #question[Déterminer les valeurs propres de $A$ avec leurs multiplicités, puis les sous-espaces propres.][La matrice étant triangulaire, $χ_A (X) = (X - 1)^2 (X - 2)$.
          Pour la valeur propre $1$, les équations sont $z = 0$ et $a y = 0$.
          Ainsi $E_1 (A) = "Vect"((1, 0, 0))$ si $a ≠ 0$, et $E_1 (A) = "Vect"((1, 0, 0), (0, 1, 0))$ si $a = 0$.
          Pour la valeur propre $2$, on obtient $y = c z$ puis $x = (a c + b)z$, donc
          $E_2 (A) = "Vect"((a c + b, c, 1))$.]

  #question[Déterminer pour quels triplets $(a, b, c)$ la matrice $A$ est diagonalisable. Dans ce cas, donner une base de vecteurs propres.][La somme des dimensions des sous-espaces propres vaut $3$ exactement lorsque $a = 0$.
          Dans ce cas, $((1, 0, 0), (0, 1, 0), (b, c, 1))$ est une base de vecteurs propres.
          Si $a ≠ 0$, cette somme vaut $2$, donc $A$ n'est pas diagonalisable.]
]
