#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Système complet de connecteurs",
  chapitres: ("logique",),
  difficulte: 2,
  niveaux: ("MPI",),
))[
  Un système de connecteurs $C$ est _complet_ si toute formule est équivalente à une formule n'utilisant que des connecteurs de $C$, des variables et $⊤$, $⊥$.

  #question[
    Montrer que ${¬, ∧}$ est complet.
  ][
    Comme vu en cours, on commence par éliminer $→$ et $↔$ grâce aux équivalences $φ → ψ ≡ ¬ φ ∨ ψ$ et $φ ↔ ψ ≡ (φ → ψ) ∧ (ψ → φ)$. Il suffit ensuite de remplacer chaque disjonction $φ ∨ ψ$ par $¬ (¬ φ ∧ ¬ ψ)$ (loi de De Morgan). Par induction structurelle et compatibilité de l'équivalence avec les connecteurs, toute formule est équivalente à une formule n'utilisant que $¬$ et $∧$.
  ]

  #question[
    On définit NAND par $φ ↑ ψ := ¬ (φ ∧ ψ)$ et NOR par $φ ↓ ψ := ¬ (φ ∨ ψ)$. Montrer que ${↑}$ et ${↓}$ sont complets.
  ][
    Pour NAND : $¬ φ ≡ φ ↑ φ$ et $φ ∧ ψ ≡ (φ ↑ ψ) ↑ (φ ↑ ψ)$.
    Pour NOR : $¬ φ ≡ φ ↓ φ$ et $φ ∧ ψ ≡ (φ ↓ φ) ↓ (ψ ↓ ψ)$.
    Les deux systèmes permettent donc d'exprimer $¬$ et $∧$, et sont complets d'après la question précédente.

    _Remarque._ Les constantes $⊤$ et $⊥$ ne sont même pas nécessaires ici : pour toute variable $x$, on a $⊤ ≡ x ↑ (x ↑ x)$ et $⊥ ≡ ¬ ⊤$, et de même avec $↓$.
  ]

  #question[
    Montrer que ${∧, ∨}$ n'est pas complet.
  ][
    On définit un ordre partiel sur les valuations en posant $v ≤ w$ si $v(x) ≤ w(x)$ pour toute variable $x$. Une induction structurelle montre que toute formule $φ$ construite avec ${∧, ∨}$, des variables et $⊤$, $⊥$ est croissante : $v ≤ w$ entraîne $v(φ) ≤ w(φ)$. C'est vrai pour les variables et les constantes, et les fonctions $min$ et $max$ conservent l'ordre. Or $¬ x$ n'est pas croissante : pour $v(x) = 0 ≤ 1 = w(x)$, on a $v(¬ x) = 1 > 0 = w(¬ x)$.

    _Autre preuve._ Supposons par l'absurde que $¬ x$ soit équivalente à une formule $φ$ construite avec ${∧, ∨}$, des variables et $⊤$, $⊥$. En remplaçant dans $φ$ toute variable autre que $x$ par $⊥$, la formule $φ'$ obtenue reste équivalente à $¬ x$ et n'utilise que $x$, $⊤$, $⊥$, $∧$ et $∨$. Or une induction structurelle montre que toute telle formule est équivalente à $⊥$, $⊤$ ou $x$ : c'est vrai pour les feuilles, et l'ensemble ${⊥, ⊤, x}$ est stable par $∧$ et $∨$ ($⊥$ est absorbant pour $∧$ et neutre pour $∨$, $⊤$ est neutre pour $∧$ et absorbant pour $∨$, et $x ∧ x ≡ x ∨ x ≡ x$). Comme aucune des trois formules $⊥$, $⊤$, $x$ n'est équivalente à $¬ x$, on obtient une contradiction.
  ]

  #question[
    Le « ou exclusif » $a ⊕ b$ vaut $1$ si et seulement si $a ≠ b$. Montrer que ${⊕, ¬}$ n'est pas complet.
  ][
    Supposons par l'absurde que $x ∧ y$ (où $x$ et $y$ sont deux variables distinctes) soit équivalente à une formule $φ$ construite avec ${⊕, ¬}$, des variables et $⊤$, $⊥$. En remplaçant dans $φ$ toute variable autre que $x$ et $y$ par $⊥$, on obtient une formule $φ'$ équivalente à $x ∧ y$ qui n'utilise que les variables $x$ et $y$.

    Il existe quatre valuations sur ${x, y}$. Montrons par induction sur la structure d'une formule $ψ$, construite avec $x$, $y$, les constantes et les connecteurs $⊕$ et $¬$, que le nombre de valuations sur ${x, y}$ qui la satisfont est pair.

    - Si $ψ$ est une variable alors exactement deux valuations la satisfont. Si $ψ$ est une constante alors ce nombre vaut $0$ ou $4$.
    - Si $ψ = ¬ χ$, on note $N$ le nombre de valuations satisfaisant $χ$. Par hypothèse d'induction, $N$ est pair. Le nombre de valuations satisfaisant $ψ$ est $4 - N$, donc est pair.
    - Si $ψ = χ_1 ⊕ χ_2$, on note $M_1$ et $M_2$ les ensembles de valuations sur ${x, y}$ satisfaisant respectivement $χ_1$ et $χ_2$. Les valuations satisfaisant $ψ$ sont celles de $(M_1 ∖ M_2) ∪ (M_2 ∖ M_1)$. Leur nombre est
      $ abs(M_1) + abs(M_2) - 2 abs(M_1 ∩ M_2), $
      qui est pair puisque $abs(M_1)$ et $abs(M_2)$ sont pairs par hypothèse d'induction.

    Or $x ∧ y$ est satisfaite par une seule valuation sur ${x, y}$, ce qui contredit l'équivalence $φ' ≡ x ∧ y$. Ainsi ${⊕, ¬}$ n'est pas complet, même en autorisant les constantes.

    _Autre preuve._ Sur le corps $𝔽_2$, $a ⊕ b = a + b$ et $¬ a = 1 + a$. On montre par induction sur la structure d'une formule que toute fonction représentable est affine, c'est-à-dire de la forme
    $ (a_1, …, a_n) ⟼ c + sum_(i=1)^n c_i a_i, quad c, c_i ∈ {0, 1}. $
    Les variables et les constantes ont cette forme. La somme de deux fonctions affines est affine, tout comme l'ajout de $1$. La propriété est donc conservée par $⊕$ et par $¬$.

    La conjonction n'est pas affine : ses valeurs en $(0, 0)$, $(1, 0)$ et $(0, 1)$ imposeraient $c = c_1 = c_2 = 0$, ce qui contredit sa valeur en $(1, 1)$. On retrouve donc que ${⊕, ¬}$ n'est pas complet, même en autorisant les constantes.
  ]
]
