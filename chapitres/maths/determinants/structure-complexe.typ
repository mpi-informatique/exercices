#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Endomorphisme de carré moins l'identité",
      chapitres: ("determinants",),
      difficulte: 1,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  #question[Soit $E$ un espace vectoriel réel de dimension finie et $f in cal(L)(E)$ tel que $f^2 = -"Id"_(E)$. Montrer que $dim E$ est pair.][En posant $n = dim E$ et en prenant les déterminants, on obtient
          $det(f)^2 = det(-"Id"_(E)) = (-1)^n$.
          Le membre de gauche est positif ou nul. Si $n$ était impair, le membre de droite vaudrait $-1$, ce qui est impossible.]
]
