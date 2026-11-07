#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
      titre: "Un endomorphisme de polynômes",
      chapitres: ("reduction",),
      difficulte: 2,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Sur $E = RR_3 [X]$, on définit $u(P) = (X + 1)P' - 2P$.

  #question[Vérifier que $u$ est un endomorphisme de $E$ et donner sa matrice dans la base $(1, X, X^2, X^3)$. En déduire son polynôme caractéristique.][L'application est linéaire et ne fait pas augmenter le degré.
          Les images des quatre vecteurs de base sont $-2$, $1 - X$, $2X$ et $X^3 + 3X^2$. La matrice vaut donc
          $ A = mat(-2, 1, 0, 0; 0, -1, 2, 0; 0, 0, 0, 3; 0, 0, 0, 1). $
          Elle est triangulaire, d'où $χ_u (X) = (X + 2)(X + 1)X(X - 1)$.]

  #question[Calculer $u((X + 1)^k)$ pour $0 ≤ k ≤ 3$, puis déterminer les sous-espaces propres et une base de vecteurs propres de $u$.][Pour $1 ≤ k ≤ 3$, la dérivation donne $u((X + 1)^k) = (k - 2)(X + 1)^k$. Pour $k = 0$, on vérifie directement $u(1) = -2$.
          Les quatre polynômes $(X + 1)^k$ sont des vecteurs propres non nuls pour les quatre valeurs propres distinctes $k - 2$.
          Ils forment une base de $E$, donc $E_(k - 2) (u) = RR (X + 1)^k$.]
]
