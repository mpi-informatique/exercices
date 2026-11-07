#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
      titre: "Diagonalisabilité en rang un",
      chapitres: ("reduction",),
      difficulte: 3,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soient $n ≥ 2$ et $A ∈ cal(M)_n (KK)$ de rang $1$.

  #question[Montrer que $A$ est diagonalisable si et seulement si $"Tr"(A) ≠ 0$.][Le théorème du rang donne $dim ker A = n - 1$. Ainsi, $0$ est racine de $χ_A$ de multiplicité au moins $n - 1$, donc
          $ χ_A (X) = X^(n - 1)(X - c). $
          En comparant le coefficient de $X^(n - 1)$, on obtient $c = "Tr"(A)$.
          - Si $c ≠ 0$, $c$ est une valeur propre et $dim E_c (A) = 1$. Avec $dim E_0 (A) = n - 1$, cela donne une base propre de $KK^n$.
          - Si $c = 0$, la seule valeur propre est $0$. Si $A$ était diagonalisable, elle serait semblable à la matrice nulle, donc nulle, contrairement à son rang.
        ]
]
