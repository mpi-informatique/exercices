#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
    titre: "Une symétrie sur les polynômes",
    chapitres: ("reduction",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 2,
  ),
)[
  On considère l'endomorphisme $s$ de $RR_3 [X]$ défini par $s(P)(X) = P(1 - X)$.

  #question[Calculer $s((X - 1 / 2)^k)$ pour $k ∈ {0, 1, 2, 3}$. En déduire une base de vecteurs propres de $s$.][On a $s((X - 1 / 2)^k) = (-1)^k (X - 1 / 2)^k$.
    Les quatre polynômes $(X - 1 / 2)^k$ forment une base, car leurs degrés sont distincts.
    Dans cette base, la matrice de $s$ est $"diag"(1, -1, 1, -1)$.]

  #question[Déterminer les sous-espaces propres de $s$ et leurs dimensions.][Les deux valeurs propres sont $1$ et $-1$, avec
    $ E_1 (s) = "Vect"(1, (X - 1 / 2)^2), #sep E_(-1) (s) = "Vect"(X - 1 / 2, (X - 1 / 2)^3). $
    Chacun de ces espaces est de dimension $2$.]

  #question[Déterminer tous les $P ∈ RR_3 [X]$ tels que $P(X) + P(1 - X) = X(1 - X)$.][Écrire $P = P_+ + P_-$ dans la somme directe $E_1 (s) ⊕ E_(-1) (s)$.
    Alors $P + s(P) = 2P_+$.
    Le polynôme $X(1 - X)$ appartient à $E_1 (s)$, donc les solutions sont exactement
    $ P = 1 / 2 X(1 - X) + a(X - 1 / 2) + b(X - 1 / 2)^3, #sep (a, b) ∈ RR^2. $]
]
