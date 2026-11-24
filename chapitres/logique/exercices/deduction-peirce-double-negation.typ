#import "/load.typ": exercice, logique, question
#import logique: arbre, rappel-regles, regles
#import "@preview/curryst:0.6.0": prooftree, rule

#let ex = exercice(
  meta: (
    titre: "Loi de Peirce et logique intuitionniste",
    chapitres: ("logique",),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
)[
  Dans tout l'exercice, $A$, $B$ et $C$ désignent des formules propositionnelles quelconques.

  #rappel-regles(
    selection: (regles.implication, regles.disjonction, regles.negation, ..regles.constantes.elimination),
    classique: true,
  )

  #question[
    Prouver en déduction naturelle intuitionniste le séquent $scripts(⊢)_i (A → (B → C)) → ((A → B) → (A → C))$.
  ][
    Posons $Γ = {A → (B → C), A → B, A}$ :
    #arbre[#prooftree(rule(
      name: [$scripts(→)_i$],
      rule(
        name: [$scripts(→)_i$],
        rule(
          name: [$scripts(→)_i$],
          rule(
            name: [$scripts(→)_e$],
            rule(
              name: [$scripts(→)_e$],
              rule(name: [ax], [$Γ ⊢ A → (B → C)$]),
              rule(name: [ax], [$Γ ⊢ A$]),
              [$Γ ⊢ B → C$],
            ),
            rule(
              name: [$scripts(→)_e$],
              rule(name: [ax], [$Γ ⊢ A → B$]),
              rule(name: [ax], [$Γ ⊢ A$]),
              [$Γ ⊢ B$],
            ),
            [$Γ ⊢ C$],
          ),
          [$A → (B → C), A → B ⊢ A → C$],
        ),
        [$A → (B → C) ⊢ (A → B) → (A → C)$],
      ),
      [$⊢ (A → (B → C)) → ((A → B) → (A → C))$],
    ))]
  ]

  #question[
    Prouver en déduction naturelle intuitionniste le séquent $scripts(⊢)_i ¬ ¬ (A ∨ ¬ A)$.
  ][
    Posons $Γ = {¬ (A ∨ ¬ A)}$ :
    #arbre[#prooftree(rule(
      name: [$¬_i$],
      rule(
        name: [$¬_e$],
        rule(
          name: [$∨_i^d$],
          rule(
            name: [$¬_i$],
            rule(
              name: [$¬_e$],
              rule(name: [$∨_i^g$], rule(name: [ax], [$Γ, A ⊢ A$]), [$Γ, A ⊢ A ∨ ¬ A$]),
              rule(name: [ax], [$Γ, A ⊢ ¬ (A ∨ ¬ A)$]),
              [$Γ, A ⊢ ⊥$],
            ),
            [$Γ ⊢ ¬ A$],
          ),
          [$Γ ⊢ A ∨ ¬ A$],
        ),
        rule(name: [ax], [$Γ ⊢ ¬ (A ∨ ¬ A)$]),
        [$Γ ⊢ ⊥$],
      ),
      [$⊢ ¬ ¬ (A ∨ ¬ A)$],
    ))]
  ]

  #question[
    Prouver en déduction naturelle classique la _loi de Peirce_ :
    $ scripts(⊢)_c ((A → B) → A) → A. $
  ][
    Posons $D = (A → B) → A$ et $Γ = {D, ¬ A}$. On utilise le raisonnement par l'absurde :
    #arbre[#prooftree(rule(
      name: [$scripts(→)_i$],
      rule(
        name: [raa],
        rule(
          name: [$¬_e$],
          rule(
            name: [$scripts(→)_e$],
            rule(name: [ax], [$Γ ⊢ D$]),
            rule(
              name: [$scripts(→)_i$],
              rule(
                name: [$⊥_e$],
                rule(
                  name: [$¬_e$],
                  rule(name: [ax], [$Γ, A ⊢ A$]),
                  rule(name: [ax], [$Γ, A ⊢ ¬ A$]),
                  [$Γ, A ⊢ ⊥$],
                ),
                [$Γ, A ⊢ B$],
              ),
              [$Γ ⊢ A → B$],
            ),
            [$Γ ⊢ A$],
          ),
          rule(name: [ax], [$Γ ⊢ ¬ A$]),
          [$Γ ⊢ ⊥$],
        ),
        [$D ⊢ A$],
      ),
      [$⊢ ((A → B) → A) → A$],
    ))]
  ]

  #question[
    On ajoute aux règles de la logique intuitionniste l'axiome de Peirce, qui permet de dériver $Γ ⊢ ((X → Y) → X) → X$ pour toutes formules $X$ et $Y$. Montrer que l'on peut alors dériver $¬ ¬ A ⊢ A$, et en déduire que l'on retrouve la logique classique.
  ][
    Posons $Γ = {¬ ¬ A}$ et $Δ = {¬ ¬ A, A → ⊥}$. En appliquant l'axiome de Peirce avec $X = A$ et $Y = ⊥$ :
    #arbre[#prooftree(rule(
      name: [$scripts(→)_e$],
      rule(name: [peirce], [$Γ ⊢ ((A → ⊥) → A) → A$]),
      rule(
        name: [$scripts(→)_i$],
        rule(
          name: [$⊥_e$],
          rule(
            name: [$¬_e$],
            rule(
              name: [$¬_i$],
              rule(
                name: [$scripts(→)_e$],
                rule(name: [ax], [$Δ, A ⊢ A → ⊥$]),
                rule(name: [ax], [$Δ, A ⊢ A$]),
                [$Δ, A ⊢ ⊥$],
              ),
              [$Δ ⊢ ¬ A$],
            ),
            rule(name: [ax], [$Δ ⊢ ¬ ¬ A$]),
            [$Δ ⊢ ⊥$],
          ),
          [$Δ ⊢ A$],
        ),
        [$Γ ⊢ (A → ⊥) → A$],
      ),
      [$¬ ¬ A ⊢ A$],
    ))]

    On retrouve alors le raisonnement par l'absurde : si $Γ', ¬ A ⊢ ⊥$, l'introduction de la négation donne $Γ' ⊢ ¬ ¬ A$, puis la construction précédente (par affaiblissement) permet de déduire $Γ' ⊢ A$. On obtient donc exactement toutes les preuves de la logique classique.
  ]
]
