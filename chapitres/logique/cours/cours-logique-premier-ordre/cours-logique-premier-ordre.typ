#import "/load.typ": (
  article-only, colonnes-cours, cours-et-presentation, article-only, formules-reparties, hp, liste-cours, paragraphe,
  pause, slide, slides-only, solution, tableau, taille-presentation, theoremes,
)
#import "@preview/curryst:0.6.0": prooftree, rule
#import "/load.typ": logique
#import logique: PA, arbre, tableau-regles
#import theoremes: definition, exercice, theoreme

#show: cours-et-presentation.with(titre: "Logique du premier ordre", niveau: "MPI")

La logique du premier ordre permet de raisonner sur d'autres objets que les booléens de la logique propositionnelle.

= Syntaxe : signature du premier ordre

#definition[Signature du premier ordre][
  Une _signature du premier ordre_ $Σ$ est la donnée de _symboles de fonctions_ et de _symboles de relations_, chacun muni d'une _arité_ (nombre d'arguments). Un symbole de fonction d'arité $0$ est une _constante_.
]

Dans la suite, $Σ$ désigne une signature du premier ordre.

#slides-only[== Termes]

#definition[Terme][
  Soit $V$ un ensemble de _variables_. Les _termes_ de $Σ$ sont définis par la grammaire :
  $ T ⟶ x | c | f(T, …, T) $
  où $x ∈ V$, $c$ est un symbole de constante et $f$ un symbole de fonction d'arité $n > 0$, appliqué à exactement $n$ termes.
]

#underline[Attention] : en premier ordre, les variables ne sont pas forcément booléennes.

#slides-only[== Formules du premier ordre]

#definition[Formule du premier ordre][
  Les _formules_ de la logique du premier ordre sont définies par la grammaire :
  $ F ⟶ ⊤ | ⊥ | R(T, …, T) | ¬ F | (F ∧ F) | (F ∨ F) | (F → F) | ∃ x F | ∀ x F $
  où $R$ est un symbole de relation d'arité $n > 0$, appliqué à $n$ termes, $T$ est un terme et $x ∈ V$.
]
#slide()
#tableau(
  columns: (auto, 1fr, auto),
  align: (center + horizon, center + horizon, center + horizon),
  table.header([*Exemple*], [*Signature $Σ$*], [*Exemple de formule*]),
  [Groupes],
  [Constante $e$, fonction unaire $attach(#[], tr: -1)$, fonction binaire $⋆$, relation binaire $=$],
  [$∀ x ∃ y (x ⋆ y = e)$],
  [Ensembles],
  [Constante $∅$, fonction unaire $attach(#[], tr: c)$, fonctions binaires $∩$, $∪$, relations $=$, $∈$, $⊂$],
  [$∀ x ∀ y ((x ∪ y)^c = x^c ∩ y^c)$],
  [Listes],
  [Constante `[]`, fonction binaire `@` (concaténation), relation binaire $=$],
  [$∀ l (l #math.class("binary", raw("@")) #raw("[]") = l)$],
)

#slides-only[== Occurrences libres et liées]

#definition[Occurrence libre, occurrence liée][
  Une occurrence d'une variable $x$ dans une formule $φ$ est _liée_ si elle est dans la portée d'un quantificateur $∃ x$ ou $∀ x$. Sinon, elle est _libre_. Une formule sans variable libre est dite _close_.
]

#underline[Exemple] : dans $∀ x (x = y)$, l'occurrence de $x$ est liée et celle de $y$ est libre.
#slides-only[== Substitution]

#definition[Substitution][
  On note $φ[x := t]$ la formule obtenue en remplaçant toutes les occurrences libres de $x$ par $t$ dans $φ$, après renommage des variables si nécessaire pour éviter les captures.
]

#underline[Exemple] : si $A = (∀ x (x = x)) ∧ ∃ y (x = y)$ alors
$A[x := y ⋆ y] = (∀ x (x = x)) ∧ ∃ z (y ⋆ y = z).$

#slides-only[== Théorie]
#definition[Théorie][
  Une _théorie_ $T$ sur $Σ$ est un ensemble de formules closes, appelées _axiomes_.
]

#slides-only[== Théorie des groupes]
#taille-presentation(0.85em)[
  #definition(marge: true)[Théorie des groupes][
    Sur la signature $Σ = {⋆, e, i, =}$, avec une constante $e$, une fonction binaire $⋆$ et une fonction unaire $i$ notée $i(x) = x^(-1)$, la _théorie des groupes_ est donnée par les axiomes :
    #formules-reparties(
      $∀ x (x ⋆ e = x)$,
      $∀ x (e ⋆ x = x)$,
      $∀ x (x ⋆ x^(-1) = e)$,
      $∀ x (x^(-1) ⋆ x = e)$,
      $∀ x ∀ y ∀ z ((x ⋆ y) ⋆ z = x ⋆ (y ⋆ z))$,
    )
  ] <groupes>
]

#slides-only[== Arithmétique de Peano]
// Source : Robert Atkey, CS208, Arithmetic and Induction, sections sur les axiomes et la récurrence.
// https://personal.cis.strath.ac.uk/robert.atkey/cs208/induction.html ; les opérations sont ici définies sur le second argument.
#taille-presentation(0.8em)[
  #definition(hp: true)[Arithmétique de Peano][
    Sur la signature $Σ = {0, 1, +, ×, =}$, on considère la théorie $PA$ de l'_arithmétique de Peano_ :
    #formules-reparties($∀ x ¬ (x + 1 = 0)$, $∀ x (x + 0 = x)$, $∀ x (x × 0 = 0)$)
    #formules-reparties(
      $∀ x ∀ y (x + 1 = y + 1 → x = y)$,
      $∀ x ∀ y (x + (y + 1) = (x + y) + 1)$,
      $∀ x ∀ y (x × (y + 1) = x × y + x)$,
    )
    et le _schéma de récurrence_ : pour toute formule $A$, on ajoute l'axiome :
    $ (A[x := 0] ∧ ∀ x (A → A[x := x + 1])) → ∀ x A. $
  ] <pa>
]

#hp[= Sémantique : structures et modèles]

#definition[Structure et interprétation][
  Une _structure_ $cal(M)$ pour une signature $Σ$ est donnée par :
  - un _domaine_ $D ≠ ∅$
  - pour chaque constante $c$, un élément $c^cal(M) ∈ D$
  - pour chaque symbole de fonction $f$ d'arité $n > 0$, une fonction $f^cal(M) : D^n → D$
  - pour chaque symbole de relation $R$ d'arité $n$, une relation $R^cal(M) ⊂ D^n$
]
#underline[Convention] : dans une structure avec égalité, le symbole $=$ est toujours interprété par $\{(a, a) | a ∈ D\}$.

#slides-only[== Affectations et valeur des termes]
#definition[Affectation][
  Une _affectation_ $ρ : V → D$ donne une valeur aux variables. La _valeur_ $⟦t⟧_(cal(M), ρ) ∈ D$ d'un terme $t$ est définie par :
  #formules-reparties(
    $⟦x⟧_(cal(M), ρ) = ρ(x)$,
    $⟦c⟧_(cal(M), ρ) = c^cal(M)$,
    $⟦f(t_1, …, t_n)⟧_(cal(M), ρ) = f^cal(M)(⟦t_1⟧_(cal(M), ρ), …, ⟦t_n⟧_(cal(M), ρ))$,
  )
  On note $ρ[x := a]$ l'affectation qui coïncide avec $ρ$ sur toutes les variables sauf $x$, pour laquelle elle donne la valeur $a$.
]#pause

#slides-only[== Valeur de vérité]
#definition[Valeur de vérité][
  La valeur de vérité $⟦A⟧_(cal(M), ρ) ∈ {0, 1}$ est définie inductivement :
  #taille-presentation(0.65em)[
    #align(center, tableau(
      columns: 6,
      inset: (x: 0.3em, y: 0.4em),
      table.header([$A$], [$⊤$], [$⊥$], [$R(t_1, …, t_n)$], [$∀ x B$], [$∃ x B$]),
      [$⟦A⟧_(cal(M), ρ) = 1$],
      [Toujours],
      [Jamais],
      [$(⟦t_1⟧_(cal(M), ρ), …, ⟦t_n⟧_(cal(M), ρ)) ∈ R^cal(M)$],
      [$∀ a ∈ D, ⟦B⟧_(cal(M), ρ[x := a]) = 1$],
      [$∃ a ∈ D, ⟦B⟧_(cal(M), ρ[x := a]) = 1$],
    ))
  ]
  Les connecteurs logiques sont définis comme en logique propositionnelle.
]

#slides-only[== Satisfaction et modèles]
#definition[Satisfaction et modèle][
  - $A$ est _vraie_ dans $cal(M)$ pour $ρ$, noté $(cal(M), ρ) ⊨ A$, si $⟦A⟧_(cal(M), ρ) = 1$.
  - $cal(M)$ est un _modèle_ de $A$, noté $cal(M) ⊨ A$, si $(cal(M), ρ) ⊨ A$ pour toute affectation $ρ$.
  - $cal(M)$ est un _modèle_ d'une théorie $T$, noté $cal(M) ⊨ T$, si elle satisfait tous ses axiomes : $∀ A ∈ T, cal(M) ⊨ A.$
]

// Source : Andrew Marks, Computability theory (2024), §10.1, p. 47.
// https://math.berkeley.edu/~marks/notes/computability_notes_v1.pdf
#paragraphe([Exemples], trait: true)[
  - Tout groupe est un modèle de la #link(<groupes>)[théorie des groupes]. Par exemple, la structure de domaine $ℤ$ qui interprète $⋆$ par $+$, $e$ par $0$ et $n^(-1)$ par $-n$ est un modèle qui correspond au groupe $(ℤ, +)$.
  - Le _modèle standard_ $cal(N)$ de #link(<pa>)[$PA$] a pour domaine $ℕ$, avec $0^cal(N) = 0$, $1^cal(N) = 1$ et les opérations usuelles $+$ et $×$.
  - L'ensemble des entiers pairs $2 ℕ$ donne un autre modèle $cal(E)$ de $PA$ avec :
    $0^cal(E) = 0, quad 1^cal(E) = 2, quad x +_cal(E) y = x + y, quad x ×_cal(E) y = (x y)/2.$
  - Il existe aussi des modèles non standards de $PA$ dont le domaine contient un élément $a$ différent de tous les éléments
  $ 0^cal(M), quad (0 + 1)^cal(M), quad ((0 + 1) + 1)^cal(M), quad … $
]

#slides-only[== Conséquence logique]
#definition[Conséquence logique][
  Soit $Γ$ un ensemble de formules.
  - On note $(cal(M), ρ) ⊨ Γ$ si $(cal(M), ρ) ⊨ B$ pour toute formule $B ∈ Γ$.\
  - $A$ est une _conséquence_ de $Γ$, noté $Γ ⊨ A$, si, pour toute structure $cal(M)$ et toute affectation $ρ$ : $(cal(M), ρ) ⊨ Γ ==> (cal(M), ρ) ⊨ A$.\
  - Si $T$ est une théorie, on note $Γ ⊨_T A$ si $T ∪ Γ ⊨ A$.
]

#underline[Attention] : $∀ x ∃ y (x + y = 0)$ est vraie dans $ℤ$ avec l'addition usuelle, mais n'est pas valide car fausse dans $ℕ$.

#slides-only[== Exprimer des propriétés]
// Sources : Lassaigne, Logique du premier ordre, §2 ; Dowek, Les démonstrations et les algorithmes, §2.1.
#exercice[Exprimer des propriétés][
  Exprimer les propriétés suivantes par des formules du premier ordre.
  + Dans un graphe, avec la relation $R(u, v) <==>$ « $u$ et $v$ sont adjacents » :
    #enum(
      numbering: "a)",
      [« aucun sommet n'est isolé ».],
      [« un sommet est adjacent à tous les autres ».],
      [« les sommets $x$ et $y$ sont reliés par un chemin de longueur au plus deux ».],
    )
  + Sur $ℕ$, avec $0$, $1$, $+$, $×$ et $=$ : « $p$ est premier ».
  + Sur une signature d'ensembles, avec seulement $∈$ et $=$ :
    #enum(numbering: "a)", [« $A ⊂ B$ ».], [« $A$ et $B$ sont disjoints ».])
]
#solution[
  + #enum(
      numbering: "a)",
      [$∀ x ∃ y R(x, y)$.],
      [
        $∃ x ∀ y (¬ (y = x) → R(x, y))$.
        L'ordre des quantificateurs distingue un voisin dépendant de $x$ d'un sommet commun à tous les autres.
      ],
      [$x = y ∨ R(x, y) ∨ ∃ z (R(x, z) ∧ R(z, y))$.],
    )
  + $¬ (p = 0) ∧ ¬ (p = 1) ∧ ∀ a ∀ b (p = a × b → (a = 1 ∨ b = 1))$.
  + #enum(numbering: "a)", [$∀ z (z ∈ A → z ∈ B)$.], [$¬ ∃ z (z ∈ A ∧ z ∈ B)$.])
]

= Preuves : déduction naturelle du premier ordre

#article-only[== Quantificateurs]

#tableau-regles(conditions-dessus: true, rempli: true, progressif: false, (
  (
    titre: [$∀$],
    condition-introduction: [Si $x$ n'est pas une variable libre de $Γ$ :],
    introduction: (rule(name: [$∀_i$], [$Γ ⊢ X$], [$Γ ⊢ ∀ x X$]),),
    elimination: (rule(name: [$∀_e$], [$Γ ⊢ ∀ x X$], [$Γ ⊢ X[x := t]$]),),
  ),
  (
    titre: [$∃$],
    condition-elimination: [Si $x$ n'est une variable libre ni de $Y$ ni de $Γ$ :],
    introduction: (rule(name: [$∃_i$], [$Γ ⊢ X[x := t]$], [$Γ ⊢ ∃ x X$]),),
    elimination: (rule(name: [$∃_e$], [$Γ ⊢ ∃ x X$], [$Γ, X ⊢ Y$], [$Γ ⊢ Y$]),),
  ),
))

#slides-only[== Quantificateurs – exercices]
#exercice[
  #liste-cours(
    [Prouver $¬ (∃ x A) ⊢ ∀ x ¬ A$.],
    [Prouver $∃ x (A ∨ B) ⊢ (∃ x A) ∨ (∃ x B)$.],
  )
]
#solution[
  + Posons $Γ = {¬ (∃ x A)}$.
    #arbre[#prooftree(rule(
      name: [$∀_i$],
      rule(
        name: [$¬_i$],
        rule(
          name: [$¬_e$],
          rule(name: [$∃_i$], rule(name: [ax], [$Γ, A ⊢ A$]), [$Γ, A ⊢ ∃ x A$]),
          rule(name: [ax], [$Γ, A ⊢ ¬ (∃ x A)$]),
          [$Γ, A ⊢ ⊥$],
        ),
        [$Γ ⊢ ¬ A$],
      ),
      [$Γ ⊢ ∀ x ¬ A$],
    ))]
    La règle $∃_i$ utilise le terme $x$ comme témoin. La règle $¬_i$ décharge l'hypothèse $A$. Enfin, $∀_i$ est valide car $x$ n'est pas libre dans $¬ (∃ x A)$.

  + Posons $Γ = {∃ x (A ∨ B)}$ et $C = (∃ x A) ∨ (∃ x B)$.
    Choisissons une variable $y$ absente de $A$ et $B$, et notons $A_y = A[x := y]$, $B_y = B[x := y]$ et $Δ = Γ ∪ {A_y ∨ B_y}$.
    #arbre[#prooftree(rule(
      name: [$∃_e$],
      rule(name: [ax], [$Γ ⊢ ∃ x (A ∨ B)$]),
      rule(
        name: [$∨_e$],
        rule(
          name: [$∨_i^g$],
          rule(name: [$∃_i$], rule(name: [ax], [$Δ, A_y ⊢ A_y$]), [$Δ, A_y ⊢ ∃ x A$]),
          [$Δ, A_y ⊢ C$],
        ),
        rule(
          name: [$∨_i^d$],
          rule(name: [$∃_i$], rule(name: [ax], [$Δ, B_y ⊢ B_y$]), [$Δ, B_y ⊢ ∃ x B$]),
          [$Δ, B_y ⊢ C$],
        ),
        rule(name: [ax], [$Δ ⊢ A_y ∨ B_y$]),
        [$Δ ⊢ C$],
      ),
      [$Γ ⊢ C$],
    ))]
    La règle $∨_e$ décharge les hypothèses $A_y$ et $B_y$ dans leurs branches respectives. La règle $∃_e$ décharge $A_y ∨ B_y$. Elle est valide car $y$ n'est libre ni dans $Γ$ ni dans $C$.
]

#article-only[== Égalité]

L'égalité est une relation qui appartient à la plupart des signatures du premier ordre, avec les règles suivantes :
#tableau-regles((
  (
    titre: [Égalité],
    introduction: (rule(name: [$scripts(=)_i$], [$Γ ⊢ t = t$]),),
    elimination: (rule(name: [$scripts(=)_e$], [$Γ ⊢ s = t$], [$Γ ⊢ A[x := s]$], [$Γ ⊢ A[x := t]$]),),
  ),
))

#slides-only[== Involution et égalité]
#exercice[Involution][
  Soit $f$ un symbole de fonction unaire et $I = ∀ x (f(f(x)) = x)$. En supposant $I$, prouver que $f$ est bijective :
  $ I ⊢ ∀ x ∀ y (f(x) = f(y) → x = y) quad "et" quad I ⊢ ∀ y ∃ x (f(x) = y). $
]
#solution[
  Pour l'injectivité, posons $H = (f(x) = f(y))$ et $Γ = {I, H}$. Pour alléger l'arbre, notons $s = f(f(x))$ et $t = f(f(y))$ : ce sont des abréviations de termes.
  Les étiquettes sym, trans et cong désignent la symétrie, la transitivité et la compatibilité de $f$ avec l'égalité.
  #arbre[#prooftree(rule(
    name: [$∀_i$],
    rule(
      name: [$∀_i$],
      rule(
        name: [$scripts(→)_i$],
        rule(
          name: [trans],
          rule(
            name: [trans],
            rule(
              name: [sym],
              rule(name: [$∀_e$], rule(name: [ax], [$Γ ⊢ I$]), [$Γ ⊢ s = x$]),
              [$Γ ⊢ x = s$],
            ),
            rule(name: [cong], rule(name: [ax], [$Γ ⊢ f(x) = f(y)$]), [$Γ ⊢ s = t$]),
            [$Γ ⊢ x = t$],
          ),
          rule(name: [$∀_e$], rule(name: [ax], [$Γ ⊢ I$]), [$Γ ⊢ t = y$]),
          [$Γ ⊢ x = y$],
        ),
        [$I ⊢ f(x) = f(y) → x = y$],
      ),
      [$I ⊢ ∀ y (f(x) = f(y) → x = y)$],
    ),
    [$I ⊢ ∀ x ∀ y (f(x) = f(y) → x = y)$],
  ))]
  La règle $scripts(→)_i$ décharge l'hypothèse $H$. Les deux applications de $∀_i$ sont valides car l'hypothèse $I$ est une formule close.

  Pour la surjectivité, on choisit le terme $f(y)$ comme témoin de $x$ :
  #arbre[#prooftree(rule(
    name: [$∀_i$],
    rule(
      name: [$∃_i$],
      rule(name: [$∀_e$], rule(name: [ax], [$I ⊢ I$]), [$I ⊢ f(f(y)) = y$]),
      [$I ⊢ ∃ x (f(x) = y)$],
    ),
    [$I ⊢ ∀ y ∃ x (f(x) = y)$],
  ))]
  La dernière application de $∀_i$ est valide car $y$ n'est pas libre dans l'hypothèse $I$.
]

== Assistants de preuve

Les _assistants de preuve_ comme #link("https://rocq-prover.org/")[Rocq] (anciennement Coq) et #link("https://lean-lang.org/")[Lean] aident à construire des preuves formelles.
Leur logique est fondée sur les types. On fixe un type $D$ et un prédicat $P$. Les deux scripts prouvent $∀ x (P(x) → ∃ y P(y))$ :
#taille-presentation(0.7em)[
  #colonnes-cours(
    columns: 2,
    empiler-presentation: false,
    align: left + top,
    [
      ```coq
      Theorem exemple (D : Type) (P : D -> Prop) :
        forall x : D, P x -> exists y : D, P y.
      Proof.
        intros x h.
        exists x.
        exact h.
      Qed.
      ```
    ],
    [
      ```lean
      theorem exemple (D : Type) (P : D → Prop) :
          ∀ x : D, P x → ∃ y : D, P y := by
        intro x h
        exact ⟨x, h⟩
      ```
    ],
  )
]
`intros x h` et `intro x h` introduisent $x$ et l'hypothèse $P(x)$ nommée `h`, comme les règles $∀_i$ et $scripts(→)_i$.
En Rocq, `exists x` applique $∃_i$ et `exact h` utilise l'hypothèse. En Lean, `exact ⟨x, h⟩` combine les deux.

== Démontrabilité dans une théorie

#definition[Démontrabilité][
  On note $Γ ⊢_T A$ si $T ∪ Γ scripts(⊢)_c A$, où $scripts(⊢)_c$ désigne la déduction naturelle classique avec les règles des quantificateurs et de l'égalité : $A$ est démontrable à partir des axiomes de $T$ et des hypothèses de $Γ$.
  Si $Γ$ est vide, on écrit $⊢_T A$.

  $T$ est _cohérente_ si $⊬_T ⊥$.
]

#slides-only[== Groupes]
#taille-presentation(0.85em)[
  #exercice[Groupes][
    On considère la #link(<groupes>)[théorie des groupes] $T$.
    + Prouver $⊢_T ∀ x ∃ y (x ⋆ y = x)$.
    + On pose $T' = T ∪ {∀ u (u ⋆ u = e)}$. Prouver que tout groupe dont chaque élément est son propre inverse est commutatif : $⊢_(T') ∀ x ∀ y (x ⋆ y = y ⋆ x)$.
  ]
]
#solution[
  + On prend $e$ comme témoin :
    #arbre[#prooftree(rule(
      name: [$∀_i$],
      rule(
        name: [$∃_i$],
        rule(name: [neutre], [$⊢_T x ⋆ e = x$]),
        [$⊢_T ∃ y (x ⋆ y = x)$],
      ),
      [$⊢_T ∀ x ∃ y (x ⋆ y = x)$],
    ))]

  + Posons $E = ∀ u (u ⋆ u = e)$, $s = x ⋆ y$ et $t = y ⋆ x$.
    Par associativité, puis avec les instances de $E$ en $y$ et en $x$, on obtient
    $ s ⋆ t = (x ⋆ (y ⋆ y)) ⋆ x = (x ⋆ e) ⋆ x = x ⋆ x = e. $
    L'instance de $E$ en $t$ donne alors
    $ s = s ⋆ e = s ⋆ (t ⋆ t) = (s ⋆ t) ⋆ t = e ⋆ t = t. $
    Ces deux chaînes d'égalités justifient les raccourcis « calcul » ci-dessous. Ils utilisent les règles de l'égalité, l'associativité et l'élément neutre.
    #arbre[#prooftree(rule(
      name: [$∀_i$],
      rule(
        name: [$∀_i$],
        rule(
          name: [calcul],
          rule(
            name: [calcul],
            rule(name: [$∀_e$], rule(name: [ax], [$⊢_(T') E$]), [$⊢_(T') x ⋆ x = e$]),
            rule(name: [$∀_e$], rule(name: [ax], [$⊢_(T') E$]), [$⊢_(T') y ⋆ y = e$]),
            [$⊢_(T') s ⋆ t = e$],
          ),
          rule(name: [$∀_e$], rule(name: [ax], [$⊢_(T') E$]), [$⊢_(T') t ⋆ t = e$]),
          [$⊢_(T') x ⋆ y = y ⋆ x$],
        ),
        [$⊢_(T') ∀ y (x ⋆ y = y ⋆ x)$],
      ),
      [$⊢_(T') ∀ x ∀ y (x ⋆ y = y ⋆ x)$],
    ))]
    Les introductions de $∀$ sont valides car les axiomes de $T'$ sont des formules closes.
]

#slides-only[== Exercice sur PA]
#exercice[Arithmétique de Peano][
  On considère l'#link(<pa>)[arithmétique de Peano $PA$].
  + Prouver $⊢_PA ∀ x (0 + x = x)$ en utilisant le schéma de récurrence.
  + En déduire $⊢_PA ∀ x (x × 1 = x)$.
]
#solution[
  + Notons $P(t)$ la formule $0 + t = t$ et posons $D = ∀ x (P(x) → P(x + 1))$. L'instance du schéma de récurrence pour $P(x)$ est $I = (P(0) ∧ D) → ∀ x P(x)$.

    L'axiome $∀ u (u + 0 = u)$, instancié en $0$ par $∀_e$, donne $P(0)$.
    Pour l'hérédité, supposons $P(y)$. Le deuxième axiome de l'addition, instancié en $0$ et $y$, puis la compatibilité de l'addition avec l'égalité donnent :
    $ 0 + (y + 1) = (0 + y) + 1 = y + 1. $
    On obtient donc $P(y + 1)$. Ce calcul justifie le raccourci « calcul » dans l'arbre suivant :
    #arbre[#prooftree(rule(
      name: [$scripts(→)_e$],
      rule(name: [ax], [$⊢_PA I$]),
      rule(
        name: [$∧_i$],
        rule(
          name: [$∀_e$],
          rule(name: [ax], [$⊢_PA ∀ u (u + 0 = u)$]),
          [$⊢_PA P(0)$],
        ),
        rule(
          name: [$∀_i$],
          rule(
            name: [$scripts(→)_i$],
            rule(
              name: [calcul],
              rule(name: [ax], [$P(y) ⊢_PA P(y)$]),
              [$P(y) ⊢_PA P(y + 1)$],
            ),
            [$⊢_PA P(y) → P(y + 1)$],
          ),
          [$⊢_PA D$],
        ),
        [$⊢_PA P(0) ∧ D$],
      ),
      [$⊢_PA ∀ x P(x)$],
    ))]
    La règle $scripts(→)_i$ décharge l'hypothèse $P(y)$. L'introduction de $∀$ est valide car les axiomes de $PA$ sont clos et il ne reste aucune autre hypothèse.

  + Pour une variable $x$ quelconque, les axiomes de la multiplication et le résultat de la première question donnent :
    $ x × 1 = x × (0 + 1) = x × 0 + x = 0 + x = x. $
    Les axiomes sont instanciés par $∀_e$, les égalités sont composées avec les règles de l'égalité et le résultat de la première question est instancié en $1$ et en $x$. On conclut par $∀_i$, car les axiomes de $PA$ sont clos.
]

#hp[== Théorèmes de correction et complétude de Gödel]

// Sources : Dowek, Les démonstrations et les algorithmes, §2.2–2.4 ; Lassaigne, §3.
Les théorèmes de correction et de complétude du calcul propositionnel restent valables en logique du premier ordre :

#colonnes-cours(
  empiler-presentation: false,
  align: left + top,
  [
    #theoreme[Correction][
      Si $Γ ⊢_T A$ alors $Γ ⊨_T A$.
    ]
  ],
  [
    #theoreme[Complétude][
      Si $Γ ⊨_T A$ alors $Γ ⊢_T A$.
    ]
  ],
)

#slides-only[== Application à une théorie]
Il y a donc, comme en logique propositionnelle, équivalence entre prouvable et vrai.

#slides-only[== Exemple : commutativité des groupes]

#paragraphe([Exemple], trait: true)[
  soit $T$ la théorie des groupes et $A = ∀ x ∀ y (x ⋆ y = y ⋆ x)$ qui exprime la commutativité. Alors :
  - Le groupe $(ℤ, +)$ est un modèle de $T$ dans lequel $A$ est vraie.
  - Le groupe $S_3$ (permutations de ${1, 2, 3}$ composées de droite à gauche) est un modèle de $T$ où $A$ est fausse : $ (1 2)(2 3) = (1 2 3) ≠ (2 3)(1 2) = (1 3 2) $
  #v(-0.5em)
  Par correction, une preuve de $A$ à partir de $T$ imposerait que $A$ soit vraie dans $S_3$. Une preuve de $¬ A$ imposerait que $¬ A$ soit vraie dans $(ℤ, +)$. Ainsi :
  $ ⊬_T A quad "et" quad ⊬_T ¬ A. $
  Cet exemple ne contredit pas le tiers exclu. Dans chaque modèle de $T$, $A$ est soit vraie, soit fausse.\
  On a donc simultanément :
  $ ⊢_T A ∨ ¬ A, quad ⊬_T A, quad ⊬_T ¬ A. $
]

#hp[== Incomplétude de l'arithmétique]

Un ensemble d'axiomes est _énumérable_ si un programme peut les produire tous, éventuellement sans s'arrêter.

#slides-only[== Premier théorème d'incomplétude]
// Sources : Florian Rabe, Logic, § Incompleteness, https://github.com/florian-rabe/Teaching/blob/master/logic/fol-proofs_models.tex ;
// UniMath, Symmetry Book, Metamathematical remarks, https://github.com/UniMath/SymmetryBook/blob/master/metamath.tex.
#theoreme[Premier théorème d'incomplétude de Gödel][
  Soit $T$ une théorie cohérente contenant l'#link(<pa>)[arithmétique de Peano $PA$] et dont les axiomes sont énumérables. \
  Il existe une formule close $A$ telle que :
  $ ⊬_T A quad "et" quad ⊬_T ¬ A. $
]

On peut donc trouver une formule close $A$ vraie dans le modèle standard $ℕ$ mais qu'il est impossible de démontrer dans $PA$. Par le théorème de complétude, il existe des modèles non standard de $PA$ où $A$ est fausse.
