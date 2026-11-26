#import "/load.typ": exercice, question

#let ex = exercice(meta: (titre: "Calcul propositionnel", chapitres: ("logique",), difficulte: 1, niveaux: ("MP2I",)))[
  #question[
    Simplifier $φ = ¬ y ∨ (y ∧ ¬ x)$, puis donner une FNC et une FND de $ψ = (x → y) ∧ (y → z)$.
  ][
    Par distributivité,
    $ φ ≡ (¬ y ∨ y) ∧ (¬ y ∨ ¬ x) ≡ ⊤ ∧ (¬ x ∨ ¬ y) ≡ ¬ x ∨ ¬ y ≡ ¬ (x ∧ y). $
    En remplaçant chaque implication $a → b$ par $¬ a ∨ b$, on obtient directement une FNC de $ψ$ :
    $ ψ ≡ (¬ x ∨ y) ∧ (¬ y ∨ z). $
    En distribuant et en éliminant le terme $y ∧ ¬ y ≡ ⊥$, on obtient une FND :
    $ ψ ≡ (¬ x ∧ ¬ y) ∨ (¬ x ∧ z) ∨ (y ∧ z). $
    On peut même supprimer le terme $¬ x ∧ z$ (qui implique $¬ x ∧ ¬ y$ si $y$ est fausse et $y ∧ z$ si $y$ est vraie), d'où la FND simplifiée $(¬ x ∧ ¬ y) ∨ (y ∧ z)$.
  ]

  #question[
    Soient $φ, ψ, χ$ des formules propositionnelles. Pour chaque affirmation, donner une preuve ou un contre-exemple :
    + si $φ ∨ ψ$ est une tautologie alors $φ$ ou $ψ$ est une tautologie
    + si $φ$ et $ψ$ sont satisfiables alors $φ ∧ ψ$ est satisfiable
    + $(φ ∧ ψ) → χ ≡ φ → (ψ → χ)$
    + $⊨ (φ → ψ) ∨ (ψ → φ)$
  ][
    + Faux : on prend $φ = x$ et $ψ = ¬ x$. La disjonction $x ∨ ¬ x$ est une tautologie, alors que ni $x$ ni $¬ x$ n'en est une.
    + Faux : avec le même choix $φ = x$ et $ψ = ¬ x$, les deux formules sont satisfiables, mais $x ∧ ¬ x$ est une antilogie.
    + Vrai : en éliminant les implications puis en appliquant une loi de De Morgan,
      $ (φ ∧ ψ) → χ ≡ ¬ (φ ∧ ψ) ∨ χ ≡ ¬ φ ∨ ¬ ψ ∨ χ ≡ ¬ φ ∨ (¬ ψ ∨ χ) ≡ φ → (ψ → χ). $
    + Vrai : $(φ → ψ) ∨ (ψ → φ) ≡ (¬ φ ∨ ψ) ∨ (¬ ψ ∨ φ) ≡ (φ ∨ ¬ φ) ∨ (ψ ∨ ¬ ψ) ≡ ⊤$.
  ]

  #question[
    Soit $Γ = {x → y, y → z, ¬ z}$. Déterminer si $Γ ⊨ ¬ x$, puis si $Γ ⊨ z → x$. A-t-on $Γ ⊨ x$ ? Comment expliquer que $Γ ⊨ z → x$ alors que $Γ ⊨ ¬ x$ ?
  ][
    Soit $v$ un modèle de $Γ$. Comme $v(¬ z) = 1$, on a $v(z) = 0$. L'implication $y → z$ impose alors $v(y) = 0$, puis $x → y$ impose $v(x) = 0$. Ainsi $v(¬ x) = 1$, donc $Γ ⊨ ¬ x$.

    On a aussi $Γ ⊨ z → x$, puisque $v(z) = 0$ rend l'implication $z → x$ vraie quelle que soit la valeur de $x$. En revanche, $Γ ⊭ x$ : l'unique modèle de $Γ$ est $(v(x), v(y), v(z)) = (0, 0, 0)$, qui ne satisfait pas $x$. Il n'y a aucune contradiction entre $Γ ⊨ z → x$ et $Γ ⊨ ¬ x$ car l'hypothèse $z$ est fausse dans tous les modèles de $Γ$.
  ]
]
