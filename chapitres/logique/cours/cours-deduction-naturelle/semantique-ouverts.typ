#import "/load.typ": exercice, question
#import "@preview/curryst:0.6.0": prooftree, rule
#import "regles.typ": arbre

#let ex = exercice(
  meta: (
    titre: "Sémantique des ouverts et incomplétude de la logique intuitionniste",
    chapitres: ("logique",),
    difficulte: 3,
    niveaux: ("MPI",),
    source: "ups-mpi/mpi_gluher/Exercices/Semantique_Heyting.tex et Corriges/Semantique_Heyting_corrige.tex",
  ),
)[
  On note $cal(F)$ l'ensemble des formules propositionnelles sur les variables $V = {x_1, …, x_n}$, avec $n ≥ 2$, et les connecteurs $⊥$, $⊤$, $¬$, $∧$, $∨$, $→$. L'objectif est de montrer qu'il existe des séquents prouvables en logique classique qui ne le sont pas en logique intuitionniste.

  On considère la _sémantique des ouverts_. Une valuation est ici une application $v : V → cal(O)(ℝ)$, où $cal(O)(ℝ)$ est l'ensemble des ouverts de $ℝ$. On note $upright("Int")(X)$ l'intérieur de $X$, c'est-à-dire le plus grand ouvert contenu dans $X$. On note $X^c$ le complémentaire de $X$ dans $ℝ$. On étend $v$ aux formules par induction :
  - $v(⊥) = ∅$ et $v(⊤) = ℝ$
  - $v(¬ A) = upright("Int")(v(A)^c)$
  - $v(A ∧ B) = v(A) ∩ v(B)$
  - $v(A ∨ B) = v(A) ∪ v(B)$
  - $v(A → B) = upright("Int")(v(A)^c ∪ v(B))$

  Tous les contextes considérés dans cet exercice sont *finis*. Pour un contexte $Γ$, on pose $v(Γ) = inter.big_(A ∈ Γ) v(A)$, avec $v(∅) = ℝ$. Ainsi $v(Γ)$ est un ouvert.

  Un séquent $Γ ⊢ A$ est _valide_ pour cette sémantique si, pour toute valuation $v$, $v(Γ) ⊂ v(A)$. Une règle est _valide_ si la validité de ses prémisses entraîne celle de sa conclusion.

  Dans les questions 2 à 4, $A$ et $B$ désignent deux variables propositionnelles distinctes.

  #question[
    Quelle sémantique obtient-on si les valuations sont à valeurs dans ${∅, ℝ}$ ?
  ][
    On retrouve la sémantique booléenne standard en identifiant $∅$ à $0$ et $ℝ$ à $1$. L'intersection représente la conjonction, l'union la disjonction, et $upright("Int")(v(A)^c ∪ v(B))$ donne la valeur usuelle de l'implication.
  ]

  #question[
    Le séquent $⊢ ((A ∨ B) ∧ ¬ A) → B$ est-il valide pour cette sémantique ? Justifier.
  ][
    Pour toute valuation $v$, on a $v(¬ A) = upright("Int")(v(A)^c) ⊆ v(A)^c$. Donc :
    $ v((A ∨ B) ∧ ¬ A) = (v(A) ∪ v(B)) ∩ upright("Int")(v(A)^c) = v(B) ∩ upright("Int")(v(A)^c) ⊆ v(B). $
    Le complémentaire de cet ensemble, réuni à $v(B)$, est donc $ℝ$. Ainsi $v(((A ∨ B) ∧ ¬ A) → B) = upright("Int")(ℝ) = ℝ$ et le séquent est valide.
  ]

  #question[
    Prouver $scripts(⊢)_c (A → B) → (¬ A ∨ B)$.
  ][
    Posons $C = A → B$. On utilise le tiers exclu et une disjonction de cas :
    #arbre[#prooftree(rule(
      name: [$scripts(→)_i$],
      rule(
        name: [$∨_e$],
        rule(
          name: [$∨_i^d$],
          rule(
            name: [$scripts(→)_e$],
            rule(name: [ax], [$C, A ⊢ C$]),
            rule(name: [ax], [$C, A ⊢ A$]),
            [$C, A ⊢ B$],
          ),
          [$C, A ⊢ ¬ A ∨ B$],
        ),
        rule(name: [$∨_i^g$], rule(name: [ax], [$C, ¬ A ⊢ ¬ A$]), [$C, ¬ A ⊢ ¬ A ∨ B$]),
        rule(name: [te], [$C ⊢ A ∨ ¬ A$]),
        [$C ⊢ ¬ A ∨ B$],
      ),
      [$⊢ (A → B) → (¬ A ∨ B)$],
    ))]
  ]

  #question[
    Le séquent $⊢ (A → B) → (¬ A ∨ B)$ est-il valide pour cette sémantique ? Justifier.
  ][
    Non. Prenons $v(A) = v(B) = {0}^c$. Alors :
    - $v(A → B) = upright("Int")({0} ∪ {0}^c) = ℝ$
    - $v(¬ A) = upright("Int")({0}) = ∅$, donc $v(¬ A ∨ B) = {0}^c$
    - $v((A → B) → (¬ A ∨ B)) = upright("Int")({0}^c) = {0}^c ≠ ℝ$

    Le séquent n'est donc pas valide.
  ]

  #question[
    Montrer que les règles $scripts(→)_i$ et $scripts(→)_e$ sont valides.
  ][
    Pour $scripts(→)_i$, supposons $Γ, A ⊢ B$ valide. Pour toute valuation $v$, on a $v(Γ) ∩ v(A) ⊆ v(B)$, donc $v(Γ) ⊆ v(A)^c ∪ v(B)$.
    Comme $v(Γ)$ est ouvert, on obtient $v(Γ) ⊆ upright("Int")(v(A)^c ∪ v(B)) = v(A → B)$. La conclusion est valide.

    Pour $scripts(→)_e$, supposons $Γ ⊢ A → B$ et $Γ ⊢ A$ valides. Pour toute valuation $v$ :
    $ v(Γ) ⊆ v(A) ∩ upright("Int")(v(A)^c ∪ v(B)) ⊆ v(A) ∩ (v(A)^c ∪ v(B)) = v(A) ∩ v(B) ⊆ v(B). $
    La conclusion $Γ ⊢ B$ est donc valide.
  ]

  #question[
    On admet que les autres règles intuitionnistes sont valides. En déduire que la déduction naturelle en logique intuitionniste est correcte pour cette sémantique.
  ][
    Montrons par induction sur l'arbre de preuve la propriété : « le séquent à la racine est valide ».

    Une feuille est une application d'une règle sans prémisse, qui est valide par hypothèse. Supposons la propriété vraie pour les sous-arbres immédiats d'un arbre. Les prémisses de sa dernière règle sont donc valides. Comme cette règle est valide, sa conclusion l'est aussi.

    On conclut par induction : si $Γ scripts(⊢)_i A$ alors, pour toute valuation $v$, $v(Γ) ⊆ v(A)$.
  ]

  #question[
    Montrer que la règle du tiers exclu n'est pas valide. Qu'en déduire concernant la complétude de la déduction naturelle en logique intuitionniste pour la sémantique booléenne standard ?
  ][
    Prenons $v(x_1) = {0}^c$. On a $v(¬ x_1) = upright("Int")({0}) = ∅$, donc $v(x_1 ∨ ¬ x_1) = {0}^c ≠ ℝ$. Le séquent $⊢ x_1 ∨ ¬ x_1$ n'est pas valide et la règle du tiers exclu ne l'est donc pas non plus.

    Par la question précédente, $scripts(⊬)_i x_1 ∨ ¬ x_1$. Pourtant $x_1 ∨ ¬ x_1$ est une tautologie pour la sémantique booléenne standard. La déduction naturelle en logique intuitionniste n'est donc pas complète pour cette dernière.
  ]
]
