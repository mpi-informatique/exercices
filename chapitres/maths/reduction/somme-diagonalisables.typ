#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "La somme peut perdre la diagonalisabilité",
    chapitres: ("reduction",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 2,
  ),
)[
  On pose $A = mat(1, 0; 0, 0)$ et $B = mat(-1, 1; 0, 0)$.

  #question[Montrer que $A$ et $B$ sont diagonalisables sur $RR$.][La matrice $A$ est déjà diagonale.
    La matrice triangulaire $B$ a deux valeurs propres distinctes, $-1$ et $0$ : elle est donc diagonalisable.]

  #question[La matrice $A + B$ est-elle diagonalisable ? Les matrices $A$ et $B$ commutent-elles ?][On a $A + B = mat(0, 1; 0, 0)$, matrice non nulle de carré nul.
    Sa seule valeur propre est $0$ : si elle était diagonalisable, elle serait nulle, contradiction.
    Enfin $A B = B$ tandis que $B A = -A$, donc $A$ et $B$ ne commutent pas.]

  #question[Soit $E$ un espace réel de dimension $n ≥ 1$. Soient $f, g ∈ cal(L)(E)$ tels que $f$ ait $n$ valeurs propres distinctes et $f ∘ g = g ∘ f$.
    Montrer que $f + g$ est diagonalisable.][Les $n$ valeurs propres distinctes de $f$ donnent une base propre $(e_1, …, e_n)$ et des droites propres $E_(λ_i) (f) = RR e_i$.
    La commutation impose $f(g(e_i)) = g(f(e_i)) = λ_i g(e_i)$.
    Ainsi $g(e_i) ∈ RR e_i$, donc $g(e_i) = μ_i e_i$ pour un réel $μ_i$.
    On en déduit $(f + g)(e_i) = (λ_i + μ_i)e_i$ : cette même base diagonalise $f + g$, même si certaines sommes de valeurs propres coïncident.]
]
