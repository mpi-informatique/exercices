#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Système complet de connecteurs",
  chapitres: ("logique",),
  difficulte: 2,
  niveaux: ("MPI",),
))[
  Un système de connecteurs $C$ est _complet_ si toute formule est équivalent à une formule n'utilisant que des connecteurs de $C$, des variables et $⊤$, $⊥$.

  #question[
    Montrer que ${¬, ∧}$ est complet.
  ][
    On peut remplacer chaque $φ ∨ ψ$ par $¬ (¬ φ ∧ ¬ ψ)$.
  ]

  #question[
    On définit NAND par $φ ↑ ψ := ¬ (φ ∧ ψ)$ et NOR par $φ ↓ ψ := ¬ (φ ∨ ψ)$. Montrer que {↑} et {↓} sont complets.
  ][
    Pour NAND : $¬ φ ≡ φ ↑ φ$ et $φ ∧ ψ ≡ (φ ↑ ψ) ↑ (φ ↑ ψ)$.
    Pour NOR : $¬ φ ≡ φ ↓ φ$ et $φ ∧ ψ ≡ (φ ↓ φ) ↓ (ψ ↓ ψ)$.
    Les deux systèmes permettent donc d'exprimer $¬$ et $∧$, donc sont complets par la question précédente.
  ]

  #question[
    Montrer que ${∧, ∨}$ n'est pas complet.
  ][
    Une induction montre que chaque fonction représentable est croissante : $v ≤ w$ entraîne $v(φ) ≤ w(φ)$. C'est vrai pour les feuilles, et le minimum comme le maximum conservent l'ordre. Or la négation n'est pas croissante.
  ]

  #question[
    Le « ou exclusif » $a ⊕ b$ vaut $1$ si seulement si $a ≠ b$. Montrer que ${⊕, ¬}$ n'est pas complet.
  ][
    On fixe deux variables distinctes $x$ et $y$. Il existe quatre valuations sur ${x, y}$. Montrons par induction sur la structure d'une formule $φ$, construite avec ces variables, les constantes et les connecteurs $⊕$ et $¬$, que le nombre de valuations qui la satisfont est pair.

    - Si $φ$ est une variable alors exactement deux valuations la satisfont. Si $φ$ est une constante alors ce nombre vaut $0$ ou $4$.
    - Si $φ = ¬ ψ$, on note $N$ le nombre de valuations satisfaisant $ψ$. Par hypothèse d'induction, $N$ est pair. Le nombre de valuations satisfaisant $φ$ est $4 - N$, donc est pair.
    - Si $φ = ψ_1 ⊕ ψ_2$, on note $M_1$ et $M_2$ les ensembles de valuations sur ${x, y}$ satisfaisant respectivement $ψ_1$ et $ψ_2$. Les valuations satisfaisant $φ$ sont celles de $(M_1 ∖ M_2) ∪ (M_2 ∖ M_1)$. Leur nombre est
      $ abs(M_1) + abs(M_2) - 2 abs(M_1 ∩ M_2), $
      qui est pair puisque $abs(M_1)$ et $abs(M_2)$ sont pairs par hypothèse d'induction.

    Or $x ∧ y$ est satisfaite par une seule valuation sur ${x, y}$. Elle n'est donc équivalente à aucune formule construite avec ces variables, les constantes et les connecteurs $⊕$ et $¬$. Ainsi ${⊕, ¬}$ n'est pas complet, même en autorisant les constantes.

    _Autre preuve._ Sur le corps $𝔽_2$, $a ⊕ b = a + b$ et $¬ a = 1 + a$. On montre par induction sur la structure d'une formule que toute fonction représentable est affine, c'est-à-dire de la forme
    $ (a_1, …, a_n) ⟼ c + sum_(i=1)^n c_i a_i, quad c, c_i ∈ {0, 1}. $
    Les variables et les constantes ont cette forme. La somme de deux fonctions affines est affine, tout comme l'ajout de $1$. La propriété est donc conservée par $⊕$ et par $¬$.

    La conjonction n'est pas affine : ses valeurs en $(0, 0)$, $(1, 0)$ et $(0, 1)$ imposeraient $c = c_1 = c_2 = 0$, ce qui contredit sa valeur en $(1, 1)$. On retrouve donc que ${⊕, ¬}$ n'est pas complet, même en autorisant les constantes.
  ]
]
