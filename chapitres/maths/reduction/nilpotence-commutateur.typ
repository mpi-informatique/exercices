#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
      titre: "Un commutateur impose la nilpotence",
      chapitres: ("reduction",),
      difficulte: 3,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soient $n ≥ 1$ et $A, B ∈ cal(M)_n (RR)$ tels que $A B - B A = A$. On veut montrer que $A$ est nilpotente, c'est-à-dire qu'une de ses puissances d'exposant strictement positif est nulle.

  #question[Montrer que, pour tout $k ∈ NN$, $A^k B - B A^k = k A^k$.][Pour $k = 0$, les deux membres sont nuls. Si l'égalité est vraie au rang $k$, alors
          $
            A^(k + 1) B - B A^(k + 1) & = A(A^k B - B A^k) + (A B - B A)A^k \
                                      & = k A^(k + 1) + A^(k + 1) = (k + 1)A^(k + 1).
          $
          La récurrence est établie.]

  On définit $φ_B : cal(M)_n (RR) → cal(M)_n (RR)$ par $φ_B (M) = M B - B M$.

  #question[Vérifier que $φ_B$ est un endomorphisme.][Les produits sont des matrices de taille $n$ et, pour $M, N ∈ cal(M)_n (RR)$ et $α, β ∈ RR$,
          $ φ_B (α M + β N) = α φ_B (M) + β φ_B (N). $]

  #question[Pour $k ∈ NN$, montrer que si $A^k ≠ 0$, alors $k$ est une valeur propre de $φ_B$.][La première question donne $φ_B (A^k) = k A^k$. Si $A^k ≠ 0$, cette matrice est donc un vecteur propre associé à $k$.]

  #question[En déduire qu'il existe $k ≥ 1$ tel que $A^k = 0$.][L'espace $cal(M)_n (RR)$ est de dimension $n^2$, donc $φ_B$ a au plus $n^2$ valeurs propres distinctes. Si toutes les puissances $A^k$, pour $k ≥ 1$, étaient non nulles, tous les entiers strictement positifs seraient des valeurs propres de $φ_B$, ce qui est impossible.]
]
