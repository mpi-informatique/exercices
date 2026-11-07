#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
      titre: "Calcul de puissances par diagonalisation",
      chapitres: ("reduction",),
      difficulte: 2,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  On considère
  $ A = mat(3, 0, -1; 2, 4, 2; -1, 0, 3). $

  #question[Diagonaliser $A$ en donnant une matrice inversible $P$ et une matrice diagonale $D$ telles que $A = P D P^(-1)$. En déduire $A^n$ pour tout $n ∈ NN$.][On calcule $χ_A (X) = (X - 2)(X - 4)^2$, puis
          $ E_2 (A) = "Vect"((1, -2, 1)), #sep E_4 (A) = "Vect"((0, 1, 0), (1, 0, -1)). $
          La somme des dimensions vaut $3$, donc $A$ est diagonalisable. On peut prendre
          $ P = mat(1, 0, 1; -2, 1, 0; 1, 0, -1), #sep D = mat(2, 0, 0; 0, 4, 0; 0, 0, 4), $
          $ P^(-1) = 1/2 mat(1, 0, 1; 2, 2, 2; 1, 0, -1). $
          Pour tout $n ∈ NN$, $A^n = P D^n P^(-1)$, d'où
          $ A^n = 1/2 mat(2^n + 4^n, 0, 2^n - 4^n; 2(4^n - 2^n), 2 ⋅ 4^n, 2(4^n - 2^n); 2^n - 4^n, 0, 2^n + 4^n). $]
]
