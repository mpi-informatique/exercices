#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
      titre: "Un endomorphisme de suites",
      chapitres: ("reduction",),
      difficulte: 2,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Sur $E = CC^NN$, on considère l'endomorphisme $φ$ qui à $u = (u_n)_(n ∈ NN)$ associe la suite $v$ définie par
  $ v_0 = u_0, #sep ∀n ≥ 1, #sep v_n = (u_n + u_(n - 1))/2. $

  #question[Déterminer les valeurs propres de $φ$ et les sous-espaces propres associés.][L'équation $φ(u) = λ u$ équivaut à
          $ (1 - λ)u_0 = 0, #sep ∀n ≥ 1, #sep (2λ - 1)u_n = u_(n - 1). $
          - Si $λ = 1$, les solutions sont les suites constantes.
          - Si $λ = 1/2$, la seconde relation impose $u_(n - 1) = 0$ pour tout $n ≥ 1$, donc $u = 0$.
          - Sinon, $u_0 = 0$ et la récurrence $u_n = u_(n - 1)/(2λ - 1)$ donne $u = 0$.

          Ainsi, la seule valeur propre est $1$, son sous-espace propre est la droite des suites constantes, et les vecteurs propres sont les suites constantes non nulles.]
]
