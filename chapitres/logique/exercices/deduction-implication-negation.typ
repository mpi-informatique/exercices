#import "/load.typ": exercice, logique, question
#import logique: arbre
#import "@preview/curryst:0.6.0": prooftree, rule

#let ex = exercice(
  meta: (
    titre: "Implication, négation et correction",
    chapitres: ("logique",),
    difficulte: 1,
    niveaux: ("MPI",),
  ),
)[
  Dans les deux premières questions, $A$ et $B$ désignent deux formules propositionnelles quelconques.

  #question[
    Prouver en déduction naturelle intuitionniste le séquent $¬ A ∨ B scripts(⊢)_i A → B$.
  ][
    Posons $Γ = {¬ A ∨ B, A}$. On introduit l'implication puis on raisonne par disjonction de cas sur $¬ A ∨ B$ :
    #arbre[#prooftree(rule(
      name: [$scripts(→)_i$],
      rule(
        name: [$∨_e$],
        rule(
          name: [$⊥_e$],
          rule(
            name: [$¬_e$],
            rule(name: [ax], [$Γ, ¬ A ⊢ A$]),
            rule(name: [ax], [$Γ, ¬ A ⊢ ¬ A$]),
            [$Γ, ¬ A ⊢ ⊥$],
          ),
          [$Γ, ¬ A ⊢ B$],
        ),
        rule(name: [ax], [$Γ, B ⊢ B$]),
        rule(name: [ax], [$Γ ⊢ ¬ A ∨ B$]),
        [$Γ ⊢ B$],
      ),
      [$¬ A ∨ B ⊢ A → B$],
    ))]
  ]

  #question[
    Prouver en déduction naturelle intuitionniste le séquent $A → B, A → ¬ B scripts(⊢)_i ¬ A$.
  ][
    Posons $Γ = {A → B, A → ¬ B, A}$ :
    #arbre[#prooftree(rule(
      name: [$¬_i$],
      rule(
        name: [$¬_e$],
        rule(
          name: [$scripts(→)_e$],
          rule(name: [ax], [$Γ ⊢ A → B$]),
          rule(name: [ax], [$Γ ⊢ A$]),
          [$Γ ⊢ B$],
        ),
        rule(
          name: [$scripts(→)_e$],
          rule(name: [ax], [$Γ ⊢ A → ¬ B$]),
          rule(name: [ax], [$Γ ⊢ A$]),
          [$Γ ⊢ ¬ B$],
        ),
        [$Γ ⊢ ⊥$],
      ),
      [$A → B, A → ¬ B ⊢ ¬ A$],
    ))]
  ]

  #question[
    Soient $x$ et $y$ deux variables propositionnelles distinctes. Le séquent $x → y ⊢ y → x$ est-il prouvable en logique classique ? Justifier rigoureusement.
  ][
    Non. Considérons la valuation $v$ définie par $v(x) = 0$ et $v(y) = 1$. On a $v(x → y) = 1$ et $v(y → x) = 0$, donc $v$ est un modèle de $x → y$ qui ne satisfait pas $y → x$. Ainsi $x → y ⊭ y → x$.

    Si l'on avait $x → y scripts(⊢)_c y → x$, le théorème de correction entraînerait $x → y ⊨ y → x$, ce qui est absurde. On a donc $x → y scripts(⊬)_c y → x$.
  ]
]
