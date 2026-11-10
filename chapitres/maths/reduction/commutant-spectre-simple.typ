#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
      titre: "Commuter avec un spectre simple",
      chapitres: ("reduction",),
      difficulte: 3,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soit $E$ un espace vectoriel réel de dimension $n ≥ 2$. On considère $f ∈ cal(L)(E)$ ayant $n$ valeurs propres distinctes $λ_1, …, λ_n$.
  Pour chaque $j$, on choisit $e_j ∈ E_(λ_j) (f) - {0}$.
  On note $cal(C)(f) = {g ∈ cal(L)(E) | g ∘ f = f ∘ g}$.

  #question[Montrer que $(e_1, …, e_n)$ est une base de $E$ et caractériser les éléments de $cal(C)(f)$ par leur matrice dans cette base.][Les $n$ vecteurs propres associés à des valeurs propres distinctes sont libres, donc forment une base.
          Si $g$ commute avec $f$, chaque droite $E_(λ_j) (f) = RR e_j$ est stable par $g$. Il existe donc $μ_j ∈ RR$ tel que $g(e_j) = μ_j e_j$.
          La matrice de $g$ dans cette base est diagonale. Réciproquement, deux matrices diagonales commutent, donc cette condition est suffisante.]

  #question[Montrer que $cal(C)(f)$ est un espace vectoriel, calculer sa dimension et montrer que ses éléments commutent deux à deux.][L'équation $g ∘ f = f ∘ g$ est conservée par combinaison linéaire, donc $cal(C)(f)$ est un sous-espace de $cal(L)(E)$.
          L'application qui associe à $g$ le tuple $(μ_1, …, μ_n)$ de sa diagonale est un isomorphisme de $cal(C)(f)$ sur $RR^n$ : sa dimension vaut $n$.
          Les matrices de deux éléments de $cal(C)(f)$ sont diagonales dans la même base, donc elles commutent.]

  #question[Si $f$ est seulement supposé diagonalisable, tout endomorphisme qui commute avec $f$ est-il diagonalisable ?][Non. Sur $RR^2$, prendre $f = "Id"$ et $g$ de matrice $mat(0, 1; 0, 0)$.
          Alors $g$ commute avec $f$, mais $g$ est nilpotent non nul, donc n'est pas diagonalisable.]
]
