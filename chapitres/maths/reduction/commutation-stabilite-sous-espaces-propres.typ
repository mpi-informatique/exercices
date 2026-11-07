#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
      titre: "Commutation et sous-espaces propres",
      chapitres: ("reduction",),
      difficulte: 2,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soient $f, g ∈ cal(L)(E)$, où $E$ est un $KK$-espace vectoriel de dimension finie. On suppose $f$ diagonalisable.

  #question[Montrer que $f ∘ g = g ∘ f$ si et seulement si chaque sous-espace propre de $f$ est stable par $g$.][Si $f ∘ g = g ∘ f$ et $x ∈ E_λ (f)$, alors
          $ f(g(x)) = g(f(x)) = λ g(x), $
          donc $g(x) ∈ E_λ (f)$.

          Réciproquement, la stabilité donne, pour $x ∈ E_λ (f)$,
          $ f(g(x)) = λ g(x) = g(f(x)). $
          Comme $f$ est diagonalisable, ses sous-espaces propres engendrent $E$. Par linéarité, l'égalité s'étend à tout $E$.]
]
