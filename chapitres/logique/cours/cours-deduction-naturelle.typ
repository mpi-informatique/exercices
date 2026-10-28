#import "/load.typ": cours, solution, espace-reponse, theoremes
#import theoremes: definition, exercice, probleme, theoreme

#show: cours.with(titre: "Déduction naturelle", niveau: "MPI")

// Source : cours-src/logique/deduction/cours/poly_deduction.tex.
#let masquer(body) = if sys.inputs.at("corrige", default: "false") == "true" { body } else { hide(body) }
#let reponse(n) = if sys.inputs.at("corrige", default: "false") != "true" { espace-reponse(n) }

// Arbres natifs : prémisses au-dessus du trait, conclusion et nom de règle dessous/à droite.
#let inference(conclusion, premisses, regle: []) = context {
  let haut = if premisses.len() == 0 { h(0pt) } else {
    grid(columns: premisses.len(), column-gutter: 1em, align: center + bottom, ..premisses)
  }
  let largeur = calc.max(measure(haut).width, measure(conclusion).width)
  box(stack(dir: ttb, spacing: 0.25em,
    align(center, box(width: largeur, haut)),
    grid(columns: (largeur, auto), column-gutter: 0.3em,
      line(length: largeur, stroke: 0.5pt), []),
    grid(columns: (largeur, auto), column-gutter: 0.3em,
      align(center, conclusion), text(size: 0.8em, regle)),
  ))
}
#let arbre(body) = context layout(size => {
  let largeur = measure(body).width
  align(center, if largeur > size.width { scale(x: size.width / largeur * 100%, reflow: true, body) } else { body })
})

TODO : https://www.youtube.com/watch?v=hrl9Q68dIfQ

TODO : logique et typage

= Rappel de logique propositionnelle

Soit $V$ un ensemble de variables propositionnelles.
Les formules logiques peuvent aussi être définies par une grammaire :

#definition(titre: [Formule logique])[
  L'ensemble des formules logiques $cal(F)$ sur $V$ est le langage engendré par la grammaire :
      $ S → ⊤ ∣ ⊥ ∣ x ∈ V ∣ ¬ S ∣ (S ∨ S) ∣ (S ∧ S) ∣ (S → S) $
]

#exercice[
  Cette grammaire est-elle ambiguë ? $cal(F)$ est-il régulier ?

  #reponse(5)
]

#theoreme(titre: [Induction sur les formules])[
  Soit $P$ une propriété sur $cal(F)$. Si les conditions suivantes sont vérifiées, alors $P$ est vraie pour toute formule de $cal(F)$ :

  - $P(⊤)$, $P(⊥)$, et $∀ x ∈ V, P(x)$
  - $P(φ) = = > P(¬ φ)$
  - $P(φ_1) "et" P(φ_2) = = > P(φ_1 ∨ φ_2)$
  - $P(φ_1) "et" P(φ_2) = = > P(φ_1 ∧ φ_2)$
  - $P(φ_1) "et" P(φ_2) = = > P(φ_1 → φ_2)$
]

#definition(titre: [Valuation])[
  Une valuation sur $V$ est une fonction de $V$ vers ${0, 1}$ (faux, vrai).
]

#definition(titre: [Évaluation])[
  Soit $v$ une valuation sur $V$. On étend $v$ aux formules logiques inductivement :

  - $v(⊤)$ = $1$, $v(⊥)$ = $0$
  - $v(¬ φ) = 1 - v(φ)$
  - $v(φ ∧ ψ)$ = $min (v(φ), v(ψ))$
  - $v(φ ∨ ψ)$ = $max (v(φ), v(ψ))$
  - $v(φ → ψ)$ = $v(¬ φ ∨ ψ)$

  Si $v(φ) = 1$, on dit que $v$ est un modèle pour $φ$. On dit que $φ$ est satisfiable s'il existe une valuation $v$ telle que $v(φ) = 1$.
]

#definition(titre: [Équivalence])[
  Deux formules $φ$ et $ψ$ sont équivalentes (et on note $φ ≡ ψ$) si, pour toute valuation $v$, $v(φ) = v(ψ)$.
]

#underline[Remarque] : Deux formules sont équivalentes si et seulement si leur table de vérité est identique. On peut donc démontrer l'équivalence de deux formules avec leurs tables de vérité, en revenant à la définition, ou par induction.

Quelques équivalences importantes :
$ ¬ (φ ∨ ψ) ≡ ¬ φ ∧ ¬ ψ $
$ ¬ (φ ∧ ψ) ≡ ¬ φ ∨ ¬ ψ $
$ φ_1 ∨ (φ_2 ∧ φ_3) ≡ (φ_1 ∨ φ_2) ∧ (φ_1 ∨ φ_3) $
$ φ_1 ∧ (φ_2 ∨ φ_3) ≡ (φ_1 ∧ φ_2) ∨ (φ_1 ∧ φ_3) $

#pagebreak(weak: true)

#exercice[
  À quelles formules sont équivalentes $(or.big _i φ_i) ∧ (or.big _j ψ_j)$ et $(and.big _i φ_i) ∨ (and.big _j ψ_j)$ ?

  #reponse(3)
]

#exercice[
  Montrer que $→$ n'est pas associatif : $A → (B → C)$ n'est pas forcément équivalent à $(A → B) → C$.

  #reponse(2)
]

#underline[Remarque] : on parenthèse l'implication à droite par défaut ($A → B → C$ est une abréviation de $A → (B → C)$).

#exercice[
  Montrer que toute formule est équivalente à une forme normale négative, où les $¬$ ne sont que sur des variables.

  #reponse(5)
]

#underline[Remarque] : Pour une formule $φ$ sous forme normale négative sans constantes, on peut montrer que $¬ φ$ est équivalente à $φ$ dans laquelle on inverse $∨$ et $∧$, et chaque littéral avec sa négation.

#theoreme(titre: [Formes normales disjonctives et conjonctives])[
  - Toute formule logique est équivalente à une formule sous forme normale disjonctive : $c_1 ∨ … ∨ c_k$ où chaque $c_i$ est une clause conjonctive (un $∧$ de littéraux).
  - Toute formule logique est équivalente à une formule sous forme normale conjonctive : $c_1 ∧ … ∧ c_n$ où chaque $c_i$ est une clause disjonctive (un $∨$ de littéraux).
]

#reponse(6)

#exercice[
  + Montrer que le problème `SAT` restreint aux formes normales disjonctives appartient à P.
  + Existe-t-il un algorithme polynomial pour transformer une formule logique en une formule équivalente sous forme normale disjonctive ?

  #reponse(3)
]

#exercice[
  Combien existe-t-il de formules logiques sur un ensemble de $n$ variables, à équivalence près ?

  #reponse(2)
]

#definition(titre: [Modèle])[
  Soit $Γ$ un ensemble de formules. On note $Γ ⊨ A$, et on dit que $A$ est une conséquence de $Γ$, si toute valuation satisfaisant les formules de $Γ$ satisfait aussi $A$.
]

#underline[Cas particulier $Γ = ∅$] : $⊨ A$ est correct si et seulement si $A$ est une tautologie (toujours vraie).

#exercice[
  Montrer :
      $A ⊨ B ⟺ ⊨ A ⟶ B$

  #reponse(2)
]

= Déduction naturelle

La logique propositionnelle de la partie précédente permet de définir la vérité d'une formule alors que la déduction naturelle formalise la notion de preuve. Ces deux notions sont équivalentes mais ce n'est pas évident et seule une implication (correction de la déduction naturelle) est au programme.

#definition(titre: [Séquent])[
  Un séquent, noté $Γ ⊢ A$ et prononcé $Γ$ thèse $A$, est formé d'un ensemble $Γ$ de formules logiques et d'une formule logique $A$.
]

Intuitivement :

- $Γ ⊢ A$ signifie que sous les hypothèses $Γ$, on peut déduire $A$.
- $Γ$ est l'ensemble des hypothèses à un instant donné d'une démonstration.

#definition(titre: [Règle d'inférence])[
  Une règle d'inférence est constituée :

  - d'un ensemble de séquents $Γ_1 ⊢ A_1, …, Γ_n ⊢ A_n$ appelés prémisses
  - d'un séquent $Γ ⊢ A$ appelé conclusion.

  On le représente :

  #arbre[#inference([$Γ ⊢ A$], ([$Γ_1 ⊢ A_1$], [$Γ_2 ⊢ A_2$], [$…$], [$Γ_n ⊢ A_n$], ), regle: [])]

  Une règle sans prémisse est appelée axiome.
]

Une règle comme ci-dessus est valable pour toutes formules $A_1$, ..., $A_n$, $A$ et tout ensemble de formules $Γ_1$, ..., $Γ_n$, $Γ$.

#definition(titre: [Preuve])[
  On définit inductivement une preuve (ou arbre de preuve, dérivation) d'un séquent $Γ ⊢ A$ par :

  - si #inference([$Γ ⊢ A$], (), regle: []) est un axiome, alors #inference([$Γ ⊢ A$], (), regle: []) est une preuve de $Γ ⊢ A$
  - si la règle

    #arbre[#inference([$Γ ⊢ A$], ([$Γ_1 ⊢ A_1$], [$Γ_2 ⊢ A_2$], [$…$], [$Γ_k ⊢ A_k$], ), regle: [$R$])]

    est une règle d'inférence et que $P_1, P_2, …, P_k$ sont des preuves de $Γ_1 ⊢ A_1$, $Γ_2 ⊢ A_2$, ..., $Γ_k ⊢ A_k$ respectivement, alors

    #arbre[#inference([$Γ ⊢ A$], ([$P_1$], [$P_2$], [$…$], [$P_k$], ), regle: [])]

    est une preuve de $Γ ⊢ A$.

  On dit que $Γ ⊢ A$ est prouvable s'il existe une preuve de $Γ ⊢ A$.
]

#underline[Attention] : Vous devez utiliser uniquement les règles autorisées pour construire une preuve. Par exemple, vous ne pouvez pas remplacer $¬ ¬ A$ par $A$.

== Axiome

#arbre[#inference(masquer([$Γ, X ⊢ X$]), (), regle: [ax])]

Si $X$ appartient à l'ensemble des hypothèses alors $X$ est prouvable.

== Vrai $⊤$ et faux $⊥$

#arbre[#inference(masquer([$Γ ⊢ ⊤$]), (), regle: [$⊤_i$])]

#arbre[#inference(masquer([$Γ ⊢ X$]), (masquer([$Γ ⊢ ⊥$]), ), regle: [$⊥_e$])]

- $⊤_i$ : $⊤$ est prouvable.
- $⊥_e$ : Si $⊥$ est prouvable, alors n'importe quelle formule $X$ est prouvable.

== Implication $→$

#arbre[#inference(masquer([$Γ ⊢ X → Y$]), (masquer([$Γ, X ⊢ Y$]), ), regle: [$→_i$])]

#arbre[#inference(masquer([$Γ ⊢ Y$]), (masquer([$Γ ⊢ X → Y$]), masquer([$Γ ⊢ X$]), ), regle: [$→_e$])]

- $→_i$ : Si sous l'hypothèse $X$ on peut prouver $Y$, alors on peut prouver $X → Y$.
- $→_e$ : Si on peut prouver $X → Y$ et $X$, alors on peut prouver $Y$.

#exercice[
  Prouver $⊢ A → A$.

  #reponse(3)
]

#exercice[
  Prouver  $A → (B → C) ⊢ (B → A) → (B → C)$.

  #reponse(10)
]

== Conjonction $∧$

#arbre[#inference(masquer([$Γ ⊢ X ∧ Y$]), (masquer([$Γ ⊢ X$]), masquer([$Γ ⊢ Y$]), ), regle: [$∧_i$])]

#arbre[#inference(masquer([$Γ ⊢ X$]), (masquer([$Γ ⊢ X ∧ Y$]), ), regle: [$∧_e^g$])#h(1em)
    #inference(masquer([$Γ ⊢ Y$]), (masquer([$Γ ⊢ X ∧ Y$]), ), regle: [$∧_e^d$])]

- $∧_i$ : Si on peut prouver $X$ et $Y$, alors on peut prouver $X ∧ Y$.
- $∧_e^g$ : Si on peut prouver $X ∧ Y$, alors on peut prouver $X$.

#exercice[
  + Prouver $(A ∧ B) → C ⊢ A → (B → C)$.
  + Prouver $A → (B → C) ⊢ (A ∧ B) → C$.

  #reponse(16)
]

#solution[
On note $Γ = {(A ∧ B) → C, A, B}$.

#arbre[#inference([$(A ∧ B) → C ⊢ A → (B → C)$], (inference([$(A ∧ B) → C, A ⊢ B → C$], (inference([$Γ ⊢ C$], (inference([$Γ ⊢ (A ∧ B) → C$], (), regle: [ax]), inference([$Γ ⊢ A ∧ B$], (inference([$Γ ⊢ A$], (), regle: [ax]), inference([$Γ ⊢ B$], (), regle: [ax]), ), regle: [$∧_i$]), ), regle: [$→_e$]), ), regle: [$→_i$]), ), regle: [$→_i$])]
]

== Disjonction $∨$

#arbre[#inference(masquer([$Γ ⊢ X ∨ Y$]), (masquer([$Γ ⊢ X$]), ), regle: [$∨_i^g$])#h(1em)
    #inference(masquer([$Γ ⊢ X ∨ Y$]), (masquer([$Γ ⊢ Y$]), ), regle: [$∨_i^d$])]

#arbre[#inference(masquer([$Γ ⊢ Z$]), (masquer([$Γ ⊢ X ∨ Y$]), masquer([$Γ, X ⊢ Z$]), masquer([$Γ, Y ⊢ Z$]), ), regle: [$∨_e$])]

- $∨_i^g$ : Si on peut prouver $X$, alors on peut prouver $X ∨ Y$.
- $∨_e$ : Si on peut prouver $X ∨ Y$ et que $Z$ est prouvable à partir de $X$ et à partir de $Y$, alors $Z$ est prouvable.

#exercice[
  + Prouver $A ∨ (B ∧ C) ⊢ A ∨ B$
  + En déduire $⊢ A ∨ (B ∧ C) → (A ∨ B) ∧ (A ∨ C)$.

  #reponse(16)
]

#solution[
On note $Δ = {A ∨ (B ∧ C)}$.

On peut décomposer une preuve longue en plusieurs parties, pour plus de lisibilité. Par exemple pour prouver $⊢ A ∨ (B ∧ C) → (A ∨ B) ∧ (A ∨ C)$ :

  #arbre[#inference([$A ∨ (B ∧ C) ⊢ A ∨ B (*)$], (inference([$Δ, A ⊢ A ∨ B$], (inference([$Δ, A ⊢ A$], (), regle: [ax]), ), regle: [$∨_i^g$]), inference([$Δ, B ∧ C ⊢ A ∨ B$], (inference([$Δ, B ∧ C ⊢ B$], (inference([$Δ, B ∧ C ⊢ B ∧ C$], (), regle: [ax]), ), regle: [$∧_e^g$]), ), regle: [$∨_i^d$]), inference([$A ∨ (B ∧ C) ⊢ A ∨ (B ∧ C)$], (), regle: [ax]), ), regle: [$∨_e$])]

  On montre de même $A ∨ (B ∧ C) ⊢ A ∨ C (**)$ et finalement :

  #arbre[#inference([$⊢ A ∨ (B ∧ C) → (A ∨ B) ∧ (A ∨ C)$], (inference([$A ∨ (B ∧ C) ⊢ (A ∨ B) ∧ (A ∨ C)$], ([$A ∨ (B ∧ C) ⊢ A ∨ B$ ($*$)], [$A ∨ (B ∧ C) ⊢ A ∨ C$ ($**$)], ), regle: [$∧_i$]), ), regle: [$→_i$])]
]

== Négation $¬$

#arbre[#inference(masquer([$Γ ⊢ ¬ X$]), (masquer([$Γ, X ⊢ ⊥$]), ), regle: [$¬_i$])]

#arbre[#inference(masquer([$Γ ⊢ ⊥$]), (masquer([$Γ ⊢ ¬ X$]), masquer([$Γ ⊢ X$]), ), regle: [$¬_e$])]

- $¬_i$ : Si sous l'hypothèse $X$ on peut prouver $⊥$, alors on peut prouver $¬ X$.
- $¬_e$ : Si on peut prouver $¬ X$ et $X$, alors on peut prouver $⊥$.

#exercice[
  Prouver  $A ⊢ ¬ ¬ A$.

  #reponse(6)
]

#solution[
On note $Γ = {A, ¬ A}$.

  #arbre[#inference([$A ⊢ ¬ ¬ A$], (inference([$A, ¬ A ⊢ ⊥$], (inference([$Γ ⊢ A$], (), regle: [ax]), inference([$Γ ⊢ ¬ A$], (), regle: [ax]), ), regle: [$¬_e$]), ), regle: [$¬_i$])]
]

== Raisonnement par l'absurde, tiers-exclu

Les règles précédentes forment la logique intuitioniste. On peut ajouter le raisonnement par l'absurde (raa) ou le tiers-exclu (te) pour obtenir la logique classique :

#arbre[#inference(masquer([$Γ ⊢ X$]), (masquer([$Γ, ¬ X ⊢ ⊥$]), ), regle: [raa])]

#arbre[#inference(masquer([$Γ ⊢ X ∨ ¬ X$]), (), regle: [te])]

#exercice(titre: [te à partir de raa])[
  On ajoute raa à la logique intuitioniste.

  + Prouver $¬ (A ∨ ¬ A) ⊢ ¬ A$.
  + Prouver $⊢ A ∨ ¬ A$.

  #reponse(15)
]

Inversement, on peut démontrer raa à partir de te et les règles de la logique intuitioniste.

#underline[Remarques] :

+ La logique intuitionniste peut être considérée comme plus satisfaisante que la logique classique, car elle donne des preuves constructives, qui sont en bijection avec les programmes informatiques par la correspondance de Curry-Howard.

    Par exemple, le principe du tiers exclu permet de montrer qu'il existe $x, y$ irrationnels tels que $x^y$ est rationnel (soit $sqrt(2) ^(sqrt(2)) ∈ QQ$, soit $sqrt(2) ^(sqrt(2)) ∉ QQ$ et, dans ce cas, $(sqrt(2) ^(sqrt(2)))^(sqrt(2)) = sqrt(2) ^2 ∈ QQ$), mais il ne permet pas de construire de tels $x$ et $y$.
+ $⊥_e$ peut être déduit de raa, donc on peut s'en passer dans la logique classique.

= Méthodes

- Pour prouver un séquent, on peut commencer par appliquer la règle la plus proche de ce que l'on souhaite obtenir.
- Essayer de faire apparaître les hypothèses de $Γ$ : si $A ∨ B ∈ Γ$, on peut essayer d'appliquer $∨_e$ pour utiliser
  #inference([$Γ ⊢ A ∨ B$], (), regle: [ax]).
- Réfléchir à une preuve intuitive : pour prouver $A → B, A ∧ C ⊢ B$, on peut utiliser le fait que $A ∧ C$ implique $A$ et, comme $A → B$, on obtient $B$. On applique ensuite les règles correspondantes à l'envers dans l'arbre de preuve.
- Parfois, on peut être bloqué dans une preuve :

  #arbre[#inference([$¬ (A ∧ B) ⊢ ¬ A ∨ ¬ B$], (inference([$¬ (A ∧ B) ⊢ ¬ A$], (inference([$?$], (), regle: []), ), regle: []), ), regle: [$∨_i^g$])]

    On voit qu'à partir de l'hypothèse $¬ (A ∧ B)$, on ne va pas pouvoir prouver $¬ A$. Il faut donc utiliser une autre règle que $∨_i^g$.

= Lien entre prouvabilité et vérité

#theoreme(titre: [Correction de la déduction naturelle])[
  Si $Γ ⊢ A$ est prouvable alors $Γ ⊨ A$.
]

#reponse(12)

#solution[

  #underline[Preuve] : Soit $P(h)$ : « si $T$ est un arbre de preuve de hauteur $h$ pour $Γ ⊢ A$ alors $Γ ⊨ A$ ».

  $P(0)$ est vraie : un arbre de hauteur $0$ est une application de ax, de $⊤_i$ ou de te. Dans le premier cas, $A ∈ Γ$, donc $Γ ⊨ A$. Dans les deux autres cas, la conclusion est une tautologie.

  Soit $T$ un arbre de preuve pour $Γ ⊢ A$ de hauteur $h + 1$. Considérons la règle appliquée à la racine de $T$.

- ($∧_i$) Supposons $T$ de la forme :
        #inference([$Γ ⊢ A ∧ B$], (inference([$Γ ⊢ A$], ([$T_1$], ), regle: []), inference([$Γ ⊢ B$], ([$T_2$], ), regle: []), ), regle: [$∧_i$])

    Par hypothèse de récurrence sur $T_(1)$ et $T_(2)$, on obtient $Γ ⊨ A$ et $Γ ⊨ B$.

    Une valuation $v$ satisfaisant toutes les formules de
    $Γ$ satisfait donc à la fois $A$ et $B$,
    et donc $A ∧ B$. On a bien $Γ ⊨ A ∧ B$.
- ($∧_e$) Supposons $T$ de la forme :
    #inference([$Γ ⊢ A$], (inference([$Γ ⊢ A ∧ B$], ([$T_1$], ), regle: []), ), regle: [$(∧_e^g)$])
    Par récurrence sur $T_1$, $Γ ⊨ A ∧ B$ et donc $Γ ⊨ A$.
- Les autres cas sont similaires...

]

#exercice(titre: [Cohérence de la déduction naturelle])[
  Montrer que le séquent $⊢ ⊥$ n'est pas prouvable.

  #reponse(2)
]

#theoreme(titre: [Théorème de complétude (HP)])[
  En logique classique, si $Γ ⊨ A$ alors $Γ ⊢ A$ est prouvable.
]

#pagebreak(weak: true)

#exercice[
  On considère des ensembles finis $Γ$ et les deux problèmes suivants en logique classique :

  #probleme(titre: [`DNAT`])[
    $•$ Instance : un séquent $Γ ⊢ A$

        $•$ Question : $Γ ⊢ A$ est-il dérivable ?
  ]

  #probleme(titre: [`TAUTOLOGIE`])[
    $•$ Instance : une formule logique $A$

          $•$ Question : $A$ est-elle une tautologie ?
  ]

  On admet le théorème de complétude.

  + Montrer que `TAUTOLOGIE` se réduit polynomialement à `DNAT`.
  + Montrer que `DNAT` se réduit polynomialement à `TAUTOLOGIE`.
  + Montrer que `DNAT` est décidable.
  + Montrer que `DNAT` est co-NP complet.

  #reponse(15)
]

= Logique du premier ordre

#definition(titre: [Langage du premier ordre])[
  Un langage du premier ordre est la donnée de symboles de fonctions, ayant chacune une
  arité (nombre d'arguments), d'un nombre  de symboles de relation, doté chacun d'une
  arité strictement positive.

  Une fonction d'arité $0$ est dite constante.
]

  #underline[Exemples] :

- La théorie des groupes avec la constante $e$, la fonction $attach("", t: -1)$ d'arité $1$, la fonction $⋆$ d'arité 2 et la relation $=$ d'arité $2$.
- La théorie des ensembles avec la constante $∅$, la fonction $attach("", t: c)$ d'arité $1$, les fonctions $∩$ et $∪$ d'arité $2$ et les relations $=$, $∈$, $⊂$ d'arité $2$.

#definition(titre: [Terme])[
  Soit $cal(X)$ un ensemble de variables. On définit par induction l'ensemble des termes sur $cal(X)$ :

  - Une variable $x ∈ cal(X)$ est un terme.
  - Une constante est un terme.
  - Si $f$ est une fonction d'arité $n>0$ et $t_1, …, t_n$ des termes alors $f(t_1, …, t_n)$ est un terme.
]

#definition(titre: [Formule de la logique du premier ordre])[
  Soit $cal(L)$ un langage du premier ordre. L'ensemble des formules de la logique du premier ordre est défini par induction par :

  - si $R$ est une relation d'arité $n$ et $t_1, …, t_n$ des termes alors $R(t_1, t_2, …, t_n)$ est une formule de la logique du premier ordre.
  - si $A$ et $B$ sont des formules de la logique du premier ordre et $x ∈ cal(X)$, alors :

    - $¬ A$, $A ∧ B$, $A ∨ B$ et $A → B$ sont des formules de la logique du premier ordre.
    - $∃ x A$ et $∀ x A$ sont des formules de la logique du premier ordre.
]

#underline[Exemples] :

- Dans le langage de la théorie des groupes, $∀ x∃ y (x ⋆ y = e)$ est une formule.
- Dans le langage de la théorie des ensembles, $∀ x ∀ y ((x ∪ y)^c = x^c ∩ y^c)$ est une formule.

#underline[Attention] : il ne faut pas confondre variable (terme décrivant un objet du langage du premier ordre étudié), par exemple un nombre réel, et variable propositionnelle (objet qui possède une valeur de vérité).

#definition(titre: [Variable libre, variable liée])[
  Une occurrence d'une variable $x$ dans une formule $A$ est liée si elle est dans la portée d'un quantificateur $∃ x$ ou $∀ x$. Sinon, elle est libre. Une variable est libre dans $A$ si elle y possède une occurrence libre.
]

#definition(titre: [Substitution])[
  Si $A$ est une formule du premier ordre, on note $A[x  := t]$ la formule obtenue en remplaçant toutes les occurrences libres de $x$ par $t$ dans $A$, après renommage des variables si nécessaire.
]

#underline[Exemple] :
Si $A = (∀ x (x = x)) ∧ ∃ y (x = y)$. Alors $A[x := y ⋆ y] = (∀ x (x = x)) ∧ ∃ z (y ⋆ y = z)$.

== Quantificateur universel $∀$

Si $x$ n'est pas une variable libre de $Γ$ :
#arbre[#inference([$Γ ⊢ ∀ x X$], ([$Γ ⊢ X$], ), regle: [$∀_i$])]

Si $X "n'a pas de variable liée en commun avec" t$ :
#arbre[#inference([$Γ ⊢ X[x := t]$], ([$Γ ⊢ ∀ x X$], ), regle: [$∀_e$])]

- $∀_i$ : Pour montrer $∀ x X$, on prend $x$ quelconque et on montre que $X$ est vraie.
- $∀_e$ : Si $X$ est vraie pour toute valeur de $x$, alors elle est vraie en remplaçant $x$ par $t$.

== Quantificateur existentiel $∃$

#arbre[#inference([$Γ ⊢ ∃ x X$], ([$Γ ⊢ X[x := t]$], ), regle: [$∃_i$])]

Si $x "n'est pas une variable libre de" Y "ni de" Γ$ :
#arbre[#inference([$Γ ⊢ Y$], ([$Γ ⊢ ∃ x X$], [$Γ, X ⊢ Y$], ), regle: [$∃_e$])]

- $∃_i$ : Pour montrer $∃ x X$, on trouve une valeur de $x$ telle que $X$ soit vraie.
- $∃_e$ : S'il existe $x$ tel que $X$ soit vraie et implique $Y$, alors $Y$ est vraie.

#pagebreak(weak: true)

#exercice[
  Montrer les séquents suivants (où $P$ est un symbole de relation unaire) :

  + $⊢ ∀ x ∃ y (P(x) → P(y))$
  + $¬ (∃ x A) ⊢ ∀ x ¬ A$
  + $∀ x (x ⋆ x^(-1) = e) ⊢ ∀ x∀ y∃ z (x ⋆ y) ⋆ z = e$ dans le langage de la théorie des groupes

  #reponse(16)

  #solution[

  + On choisit le témoin $y = x$.

    #arbre[#inference([$⊢ ∀ x ∃ y (P(x) → P(y))$], (inference([$⊢ ∃ y (P(x) → P(y))$], (inference([$⊢ P(x) → P(x)$], (inference([$P(x) ⊢ P(x)$], (), regle: [ax]), ), regle: [$→_i$]), ), regle: [$∃_i$]), ), regle: [$∀_i$])]
  + On note $Γ = {¬ (∃ x A), A}$. On a :

    #arbre[#inference([$¬ (∃ x A) ⊢ ∀ x ¬ A$], (inference([$¬ (∃ x A) ⊢ ¬ A$], (inference([$Γ ⊢ ⊥$], (inference([$Γ ⊢ ∃ x A$], (inference([$Γ ⊢ A$], (), regle: [ax]), ), regle: [$∃_i$]), inference([$Γ ⊢ ¬ (∃ x A)$], (), regle: [ax]), ), regle: [$¬_e$]), ), regle: [$¬_i$]), ), regle: [$∀_i$])]

    La dernière règle peut bien être appliquée, car $x$ n'est pas libre dans $¬ (∃ x A)$.
  + On note $A = ∀ x (x ⋆ x^(-1) = e)$. On a :

    #arbre[#inference([$A ⊢ ∀ x∀ y∃ z (x ⋆ y) ⋆ z = e$], (inference([$A ⊢ ∀ y∃ z (x ⋆ y) ⋆ z = e$], (inference([$A ⊢ ∃ z (x ⋆ y) ⋆ z = e$], (inference([$A ⊢ ((x ⋆ y) ⋆ z = e)[z := (x ⋆ y)^(-1)]$], (inference([$A ⊢ (x ⋆ y) ⋆ (x ⋆ y)^(-1) = e$], (inference([$A ⊢ (x ⋆ x^(-1) = e)[x := x ⋆ y]$], (inference([$A ⊢ ∀ x (x ⋆ x^(-1) = e)$], (), regle: [ax]), ), regle: [$∀_e$]), ), regle: []), ), regle: []), ), regle: [$∃_i$]), ), regle: [$∀_i$]), ), regle: [$∀_i$])
    ]

  ]
]

= Récapitulatif des règles

#set text(size: 8pt)
#table(
  columns: (auto, 1fr, 1.5fr),
  inset: 6pt, align: center + horizon,
  table.header([], [*Introduction*], [*Élimination*]),
  [Conjonction], [#arbre[#inference([$Γ ⊢ X ∧ Y$], ([$Γ ⊢ X$], [$Γ ⊢ Y$], ), regle: [$∧_i$])]], [#arbre[#inference([$Γ ⊢ X$], ([$Γ ⊢ X ∧ Y$], ), regle: [$∧_e^g$])
#inference([$Γ ⊢ Y$], ([$Γ ⊢ X ∧ Y$], ), regle: [$∧_e^d$])]],
  [Disjonction], [#arbre[#inference([$Γ ⊢ X ∨ Y$], ([$Γ ⊢ X$], ), regle: [$∨_i^g$])
#inference([$Γ ⊢ X ∨ Y$], ([$Γ ⊢ Y$], ), regle: [$∨_i^d$])]], [#arbre[#inference([$Γ ⊢ Z$], ([$Γ, X ⊢ Z$], [$Γ, Y ⊢ Z$], [$Γ ⊢ X ∨ Y$], ), regle: [$∨_e$])]],
  [Implication], [#arbre[#inference([$Γ ⊢ X → Y$], ([$Γ, X ⊢ Y$], ), regle: [$→_i$])]], [#arbre[#inference([$Γ ⊢ Y$], ([$Γ ⊢ X → Y$], [$Γ ⊢ X$], ), regle: [$→_e$])]],
  [Négation], [#arbre[#inference([$Γ ⊢ ¬ X$], ([$Γ, X ⊢ ⊥$], ), regle: [$¬_i$])]], [#arbre[#inference([$Γ ⊢ ⊥$], ([$Γ ⊢ X$], [$Γ ⊢ ¬ X$], ), regle: [$¬_e$])]],
  [Faux $⊥$], [#arbre[]], [#arbre[#inference([$Γ ⊢ X$], ([$Γ ⊢ ⊥$], ), regle: [$⊥_e$])]],
  [Universel], [#arbre[Si $x$ n'est pas libre dans $Γ$ :
#inference([$Γ ⊢ ∀ x X$], ([$Γ ⊢ X$], ), regle: [$∀_i$])]], [#arbre[#inference([$Γ ⊢ X[x := t]$], ([$Γ ⊢ ∀ x X$], ), regle: [$∀_e$])]],
  [Existentiel], [#arbre[#inference([$Γ ⊢ ∃ x X$], ([$Γ ⊢ X[x := t]$], ), regle: [$∃_i$])]], [#arbre[Si $x$ n'est libre ni dans $Y$ ni dans $Γ$ :
#inference([$Γ ⊢ Y$], ([$Γ ⊢ ∃ x X$], [$Γ, X ⊢ Y$], ), regle: [$∃_e$])]],
)

#table(columns: (1fr, 1fr), inset: 8pt, align: center,
  [*Axiome*], [*Réduction à l’absurde*],
  [#arbre[#inference([$Γ, X ⊢ X$], (), regle: [ax])]],
  [#arbre[#inference([$Γ ⊢ X$], ([$Γ, ¬ X ⊢ ⊥$], ), regle: [raa])]],
)
