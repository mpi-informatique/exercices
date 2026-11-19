#import "/load.typ": exercice, question

#let ex = exercice(meta: (titre: "Calcul propositionnel", chapitres: ("logique",), difficulte: 1, niveaux: ("MP2I",)))[
  #question[
    Simplifier $φ = ¬ y ∨ (y ∧ ¬ x)$, puis donner une FNC et une FND de $ψ = x ∧ (y ∨ z) ∧ (¬ x ∨ y)$.
  ][
    Par distributivité, $φ ≡ (¬ y ∨ y) ∧ (¬ y ∨ ¬ x) ≡ ¬ (x ∧ y)$.
    La formule $ψ$ est déjà en FNC. Comme $x ∧ (¬ x ∨ y) ≡ x ∧ y$, on obtient $ψ ≡ x ∧ y$, à la fois une FNC et une FND.
  ]

  #question[
    Pour chaque affirmation, donner une preuve ou un contre-exemple :
    + si $φ ∨ ψ$ est une tautologie alors $φ$ ou $ψ$ est une tautologie
    + si $φ$ et $ψ$ sont satisfiables alors $φ ∧ ψ$ est satisfiable
    + $(φ ∧ ψ) → χ ≡ φ → (ψ → χ)$
  ][
    Les deux premières sont fausses : prendre $φ = x$ et $ψ = ¬ x$.
    La troisième est vraie, les deux formules étant équivalentes à $¬ φ ∨ ¬ ψ ∨ χ$.
  ]

  #question[
    Soit $Γ = {x → y, y → z, ¬ z}$. Déterminer si $Γ ⊨ ¬ x$, puis si $Γ ⊨ z → x$. Peut-on en déduire $Γ ⊨ x$ ?
  ][
    Dans un modèle de $Γ$, $z = 0$, puis $y = 0$ et $x = 0$ par les deux implications. Donc $Γ ⊨ ¬ x$.
    On a aussi $Γ ⊨ z → x$, puisque l'antécédent $z$ est faux dans chaque modèle de $Γ$.
    On n'a pas $Γ ⊨ x$ : la valuation $(x, y, z) = (0, 0, 0)$ satisfait les hypothèses et rend $x$ fausse.
  ]
]
