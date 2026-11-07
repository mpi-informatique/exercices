#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
      titre: "Une première diagonalisation",
      chapitres: ("reduction",),
      difficulte: 1,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  On considère $A = mat(2, 1; 1, 2) ∈ M_2 (RR)$.

  #question[Déterminer le polynôme caractéristique, les valeurs propres et les sous-espaces propres de $A$.][On trouve $χ_A (X) = (X - 2)^2 - 1 = (X - 1)(X - 3)$.
          Les équations donnent $E_1 (A) = "Vect"((1, -1))$ et $E_3 (A) = "Vect"((1, 1))$.]

  #question[Donner une matrice inversible $P$ et une matrice diagonale $D$ telles que $A = P D P^(-1)$, puis calculer $A^k$ pour $k ∈ NN$.][Les deux vecteurs propres forment une base. On peut prendre
          $ P = mat(1, 1; -1, 1), #sep D = mat(1, 0; 0, 3), #sep P^(-1) = 1/2 mat(1, -1; 1, 1). $
          Ainsi, pour tout $k ∈ NN$ :
          $ A^k = P D^k P^(-1) = 1/2 mat(1 + 3^k, 3^k - 1; 3^k - 1, 1 + 3^k). $]
]
