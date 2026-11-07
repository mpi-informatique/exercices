#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
      titre: "Diagonalisation simultanée",
      chapitres: ("reduction",),
      difficulte: 3,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soit $E$ un $KK$-espace vectoriel de dimension finie.

  #question[Soient $u, v ∈ cal(L)(E)$ diagonalisables et tels que $u ∘ v = v ∘ u$. Montrer qu'il existe une base de $E$ formée de vecteurs propres communs à $u$ et $v$.][Chaque sous-espace propre $E_λ (u)$ est stable par $v$. La restriction de $v$ à cet espace est diagonalisable : un polynôme scindé à racines simples qui annule $v$ annule aussi sa restriction.
          On choisit donc dans chaque $E_λ (u)$ une base de vecteurs propres de $v$. Tous ces vecteurs sont aussi propres pour $u$. Puisque $E$ est la somme directe des $E_λ (u)$, la réunion de ces bases est une base de $E$ qui convient.]

  #question[Généraliser à une famille $u_1, …, u_m ∈ cal(L)(E)$ d'endomorphismes diagonalisables qui commutent deux à deux, avec $m ≥ 1$.][On raisonne par récurrence sur $m$, pour tout espace de dimension finie. Le cas $m = 1$ est la définition de la diagonalisabilité.
          Pour $m ≥ 2$, chaque $E_λ (u_1)$ est stable par $u_2, …, u_m$. Leurs restrictions y sont diagonalisables et commutent deux à deux. L'hypothèse de récurrence fournit une base propre commune à ces restrictions. Cette base est aussi propre pour $u_1$, qui agit sur cet espace par multiplication par $λ$.
          La réunion des bases ainsi obtenues est une base propre commune aux $m$ endomorphismes.]
]
