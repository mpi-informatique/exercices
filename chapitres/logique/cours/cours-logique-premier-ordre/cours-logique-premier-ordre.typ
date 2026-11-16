#import "/load.typ": (
  article-only, colonnes-cours, cours-et-presentation, formules-reparties, hp, liste-cours, paragraphe, pause, slide, slides-only,
  solution, taille-presentation, theoremes,
)
#import "@preview/curryst:0.6.0": prooftree, rule
#import "/load.typ": logique
#import logique: arbre, tableau-regles
#import theoremes: definition, exercice, theoreme

#show: cours-et-presentation.with(titre: "Logique du premier ordre", niveau: "MPI")

Comme pour la logique propositionnelle, il y a 3 points de vue sur les formules :
- Syntaxe : construction des formules à partir de symboles.
- Sémantique : interprétation des formules avec une valuation/structure.
- Preuve : arbre de preuve utilisant des règles de déduction.

= Syntaxe : signature du premier ordre

Contrairement à la logique propositionnelle qui ne traite que des variables booléennes, la logique du premier ordre utilise des symboles de fonctions et de relations pour construire des termes et des formules.

#definition[Signature du premier ordre][
  Une _signature du premier ordre_ $Σ$ est la donnée de _symboles de fonctions_ et de _symboles de relations_, chacun muni d'une _arité_ (nombre d'arguments). Un symbole de fonction d'arité $0$ est une _constante_.
]

#slide()
#underline[Exemples] :
- Théorie des groupes : constante $e$, fonction $attach(#[], tr: -1)$ d'arité $1$, fonction $⋆$ d'arité $2$ et relation $=$ d'arité $2$.
- Théorie des ensembles : constante $∅$, fonction $attach(#[], tr: c)$ d'arité $1$, fonctions $∩$ et $∪$ d'arité $2$ et relations $=$, $∈$, $⊂$ d'arité $2$.

#slides-only[== Termes]

#definition[Terme][
  Soit $cal(V)$ un ensemble de _variables_. Les _termes_ sont définis par la grammaire :
  $ T ⟶ x | c | f(T, …, T) $
  où $x ∈ cal(V)$, $c$ est un symbole de constante et $f$ un symbole de fonction d'arité $n > 0$, appliqué à exactement $n$ termes.
]

#underline[Remarque] : contrairement à la logique propositionnelle, les variables ne sont pas forcément booléennes.

#slides-only[== Formules du premier ordre]

#definition[Formule du premier ordre][
  Soit $Σ$ une signature du premier ordre. Les _formules de la logique du premier ordre_ sont définies par la grammaire :
  $ F ⟶ ⊤ | ⊥ | R(T, …, T) | ¬ F | (F ∧ F) | (F ∨ F) | (F → F) | ∃ x F | ∀ x F $
  où $R$ est un symbole de relation d'arité $n > 0$, appliqué à $n$ termes, $T$ est un terme et $x ∈ cal(V)$.
]
#slide()
#underline[Exemples] :
- Théorie des groupes : $∀ x ∃ y (x ⋆ y = e)$ est une formule.
- Théorie des ensembles : $∀ x ∀ y ((x ∪ y)^c = x^c ∩ y^c)$ est une formule.

#slides-only[== Occurrences libres et liées]

#definition[Occurrence libre, occurrence liée][
  Une occurrence d'une variable $x$ dans une formule $φ$ est _liée_ si elle est dans la portée d'un quantificateur $∃ x$ ou $∀ x$. Sinon, elle est _libre_. Une variable est libre dans $φ$ si elle y possède une occurrence libre. Une formule sans variable libre est dite _close_.
]

#underline[Exemple] : dans $∀ x (x = y)$, l'occurrence de $x$ est liée et celle de $y$ est libre.
#slides-only[== Substitution]

#definition[Substitution][
  On note $φ[x := t]$ la formule obtenue en remplaçant toutes les occurrences libres de $x$ par $t$ dans $φ$, après renommage des variables si nécessaire pour éviter les captures.
]

#underline[Exemple] : si $A = (∀ x (x = x)) ∧ ∃ y (x = y)$ alors
$ A[x := y ⋆ y] = (∀ x (x = x)) ∧ ∃ z (y ⋆ y = z) $

#slides-only[== Théorie]
#definition[Théorie][
  Une _théorie_ $T$ est un ensemble de formules closes sur une même signature, appelées _axiomes_.
]

#slides-only[== Théorie des groupes]
#taille-presentation(0.85em)[
  #definition[Théorie des groupes][
    Sur la signature $Σ = {⋆, e, i, =}$, avec une constante $e$, une fonction binaire $⋆$ et une fonction unaire $i$ notée $i(x) = x^(-1)$, la _théorie des groupes_ est donnée par les axiomes :
    #formules-reparties($∀ x ∀ y ∀ z ((x ⋆ y) ⋆ z = x ⋆ (y ⋆ z))$)
    #formules-reparties($∀ x (x ⋆ e = x),$, $∀ x (e ⋆ x = x)$)
    #formules-reparties($∀ x (x ⋆ x^(-1) = e)$, $∀ x (x^(-1) ⋆ x = e)$)
  ] <groupes>
]

#slides-only[== Arithmétique de Peano]
// Source : Robert Atkey, CS208, Arithmetic and Induction, sections sur les axiomes et la récurrence.
// https://personal.cis.strath.ac.uk/robert.atkey/cs208/induction.html ; les opérations sont ici définies sur le second argument.
#taille-presentation(0.85em)[
  #definition[Arithmétique de Peano][
    Sur la signature avec égalité, une constante $0$, une fonction unaire $S$ (successeur) et deux fonctions binaires $+$ et $×$, l'_arithmétique de Peano_, notée $upright("PA")$, est la théorie donnée par les axiomes :
    #formules-reparties($∀ x ¬ (S(x) = 0),$, $∀ x ∀ y (S(x) = S(y) → x = y),$)
    #formules-reparties($∀ x (x + 0 = x),$, $∀ x ∀ y (x + S(y) = S(x + y)),$)
    #formules-reparties($∀ x (x × 0 = 0),$, $∀ x ∀ y (x × S(y) = x × y + x),$)
    et le _schéma de récurrence_ : pour toute formule $A$, on ajoute l'axiome
    $ (A[x := 0] ∧ ∀ x (A → A[x := S(x)])) → ∀ x A, $
    où les autres variables libres sont quantifiées universellement. Il s'agit donc d'une famille infinie d'axiomes, un pour chaque formule $A$.

    On note $1 = S(0)$.
  ] <pa>
]

#hp[= Sémantique : structures et modèles]

#definition[Structure et interprétation][
  Une _structure_ $cal(M)$ pour une signature $Σ$ est donnée par :
  - un ensemble non vide $D$, appelé _domaine_
  - pour chaque constante $c$, un élément $c^cal(M) ∈ D$
  - pour chaque symbole de fonction $f$ d'arité $n > 0$, une fonction $f^cal(M) : D^n → D$
  - pour chaque symbole de relation $R$ d'arité $n$, une relation $R^cal(M) ⊂ D^n$
]
#underline[Convention] : dans une structure avec égalité, le symbole $=$ est toujours interprété par l'égalité du domaine $D$, c'est-à-dire la relation $\{(a, a) | a ∈ D\}$.

#slides-only[== Affectations et valeur des termes]
#definition[Affectation][
  Une _affectation_ $ρ : cal(V) → D$ donne une valeur aux variables. La _valeur_ $⟦t⟧_(cal(M), ρ) ∈ D$ d'un terme $t$ est définie par :
  $ ⟦x⟧_(cal(M), ρ) = ρ(x), quad ⟦c⟧_(cal(M), ρ) = c^cal(M) $
  $ ⟦f(t_1, …, t_n)⟧_(cal(M), ρ) = f^cal(M)(⟦t_1⟧_(cal(M), ρ), …, ⟦t_n⟧_(cal(M), ρ)) $
]#pause

#underline[Remarque] : en logique propositionnelle, une valuation attribue une valeur de vérité à chaque variable propositionnelle. Au premier ordre, une affectation attribue un élément du domaine à chaque variable, tandis que la structure interprète les symboles de la signature.

#slides-only[== Valeur de vérité]
#definition[Valeur de vérité][
  La valeur de vérité $⟦A⟧_(cal(M), ρ) ∈ {0, 1}$ d'une formule $A$ est définie par :
  - $⟦⊤⟧_(cal(M), ρ) = 1$ et $⟦⊥⟧_(cal(M), ρ) = 0$.
  - $⟦R(t_1, …, t_n)⟧_(cal(M), ρ) = 1$ si et seulement si $(⟦t_1⟧_(cal(M), ρ), …, ⟦t_n⟧_(cal(M), ρ)) ∈ R^cal(M)$.
  - En particulier, $⟦s = t⟧_(cal(M), ρ) = 1$ si et seulement si $⟦s⟧_(cal(M), ρ) = ⟦t⟧_(cal(M), ρ)$.
  - Les connecteurs suivent les mêmes tables de vérité qu'en logique propositionnelle.
  - $⟦∀ x A⟧_(cal(M), ρ) = 1$ si et seulement si $⟦A⟧_(cal(M), ρ[x := a]) = 1$ pour tout $a ∈ D$.
  - $⟦∃ x A⟧_(cal(M), ρ) = 1$ si et seulement si $⟦A⟧_(cal(M), ρ[x := a]) = 1$ pour au moins un $a ∈ D$.
]

#slides-only[== Satisfaction et modèles]
#definition[Satisfaction et modèle][
  On note $(cal(M), ρ) ⊨ A$ si $⟦A⟧_(cal(M), ρ) = 1$ : $A$ est alors _vraie_ dans $cal(M)$ pour $ρ$.

  On note $cal(M) ⊨ A$ si $(cal(M), ρ) ⊨ A$ pour toute affectation $ρ$ : $cal(M)$ est alors un _modèle_ de $A$.
]

#slides-only[== Modèle d'une théorie]
#definition[Modèle d'une théorie][
  Une structure $cal(M)$ est un _modèle_ d'une théorie $T$, noté $cal(M) ⊨ T$, si elle satisfait tous ses axiomes :
  $ cal(M) ⊨ T quad ⟺ quad ∀ A ∈ T, cal(M) ⊨ A. $
  Les axiomes étant des formules closes, leur vérité ne dépend pas de l'affectation des variables.
]

#underline[Exemple] : la structure de domaine $ℤ$ qui interprète $⋆$ par $+$, $e$ par $0$ et $i(n)$ par $-n$ est un modèle de la #link(<groupes>)[théorie des groupes] : elle satisfait l'associativité, les deux axiomes du neutre et les deux axiomes de l'inverse.

#slides-only[== Deux modèles de PA]
// Source : Andrew Marks, Computability theory (2024), §10.1, p. 47.
// https://math.berkeley.edu/~marks/notes/computability_notes_v1.pdf
#paragraphe([Exemples], trait: true)[
  - Le _modèle standard_ $cal(N)$ de #link(<pa>)[$upright("PA")$] a pour domaine $ℕ$, avec $0^cal(N) = 0$, $S^cal(N)(n) = n + 1$ et les opérations usuelles $+$ et $×$. Tous les axiomes de $upright("PA")$, y compris chaque instance de récurrence, y sont vrais.
  - Il existe aussi un _modèle non standard_ $cal(M) ⊨ upright("PA")$ dont le domaine contient un élément $a$ différent de tous les éléments
    $ 0^cal(M), quad S^cal(M)(0^cal(M)), quad S^cal(M)(S^cal(M)(0^cal(M))), quad … $
    Autrement dit, $a ≠ overline(n)^cal(M)$ pour tout $n ∈ ℕ$, où $overline(n)$ est le terme obtenu en appliquant $n$ fois $S$ à $0$. L'existence d'un tel modèle est admise ; elle résulte du théorème de compacité du premier ordre.
]

#slides-only[== Conséquence logique]
#definition[Conséquence logique][
  On note $Γ ⊨ A$ si, pour toute structure $cal(M)$ et toute affectation $ρ$, lorsque $(cal(M), ρ)$ satisfait toutes les formules de $Γ$, il satisfait aussi $A$.
  Si $Γ$ est vide, on dit que $A$ est _valide_, et on note $⊨ A$.
]

#underline[Attention] : être vraie dans une structure particulière ne signifie pas être valide. Par exemple, $∀ x ∃ y (x + y = 0)$ est vraie dans $ℤ$ avec l'addition usuelle, mais fausse dans $ℕ$.

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

#tableau-regles(conditions-dessus: true, (
  (
    titre: [$∀$],
    condition-introduction: [Si $x$ n'est pas une variable libre de $Γ$ :],
    intuition-introduction: [si $X$ est vraie sans faire d'hypothèse sur $x$, alors elle est vraie quelle que soit la valeur de cette variable.],
    intuition-elimination: [si $X$ est vraie pour toute valeur de $x$, alors elle est vraie en remplaçant $x$ par $t$.],
    introduction: (rule(name: [$∀_i$], [$Γ ⊢ X$], [$Γ ⊢ ∀ x X$]),),
    elimination: (rule(name: [$∀_e$], [$Γ ⊢ ∀ x X$], [$Γ ⊢ X[x := t]$]),),
  ),
  (
    titre: [$∃$],
    condition-elimination: [Si $x$ n'est une variable libre ni de $Y$ ni de $Γ$ :],
    intuition-introduction: [si $X$ est vraie dans un cas particulier, c'est qu'il existe une valeur pour laquelle elle est vraie.],
    intuition-elimination: [si $Y$ se déduit de $X$ pour un témoin dont on ne suppose rien d'autre et que $x$ n'est libre ni dans $Y$ ni dans $Γ$, alors $Y$ se déduit de l'existence d'un tel témoin.],
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

== Démontrabilité dans une théorie

#definition[Démontrabilité][
  On note $Γ ⊢_T A$ si $T ∪ Γ ⊢ A$ : la formule $A$ est démontrable à partir des axiomes de $T$ et des hypothèses de $Γ$.
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
  On considère l'#link(<pa>)[arithmétique de Peano $upright("PA")$].
  + Prouver $⊢_upright("PA") ∀ x (0 + x = x)$ en utilisant le schéma de récurrence.
  + En déduire $⊢_upright("PA") ∀ x (x × 1 = x)$.
]
#solution[
  + Notons $P(t)$ la formule $0 + t = t$ et posons $D = ∀ x (P(x) → P(S(x)))$. L'instance du schéma de récurrence pour $P(x)$ est $I = (P(0) ∧ D) → ∀ x P(x)$.

    L'axiome $∀ u (u + 0 = u)$, instancié en $0$ par $∀_e$, donne $P(0)$.
    Pour l'hérédité, supposons $P(y)$. L'axiome de l'addition avec un successeur, instancié en $0$ et $y$, puis la compatibilité de $S$ avec l'égalité donnent :
    $ 0 + S(y) = S(0 + y) = S(y). $
    On obtient donc $P(S(y))$. Ce calcul justifie le raccourci « calcul » dans l'arbre suivant :
    #arbre[#prooftree(rule(
      name: [$scripts(→)_e$],
      rule(name: [ax], [$⊢_upright("PA") I$]),
      rule(
        name: [$∧_i$],
        rule(
          name: [$∀_e$],
          rule(name: [ax], [$⊢_upright("PA") ∀ u (u + 0 = u)$]),
          [$⊢_upright("PA") P(0)$],
        ),
        rule(
          name: [$∀_i$],
          rule(
            name: [$scripts(→)_i$],
            rule(
              name: [calcul],
              rule(name: [ax], [$P(y) ⊢_upright("PA") P(y)$]),
              [$P(y) ⊢_upright("PA") P(S(y))$],
            ),
            [$⊢_upright("PA") P(y) → P(S(y))$],
          ),
          [$⊢_upright("PA") D$],
        ),
        [$⊢_upright("PA") P(0) ∧ D$],
      ),
      [$⊢_upright("PA") ∀ x P(x)$],
    ))]
    La règle $scripts(→)_i$ décharge l'hypothèse $P(y)$. L'introduction de $∀$ est valide car les axiomes de $upright("PA")$ sont clos et il ne reste aucune autre hypothèse.

  + Pour une variable $x$ quelconque, les axiomes de la multiplication et le résultat de la première question donnent :
    $ x × 1 = x × S(0) = x × 0 + x = 0 + x = x. $
    Les axiomes sont instanciés par $∀_e$, les égalités sont composées avec les règles de l'égalité et le résultat de la première question est instancié en $x$. On conclut par $∀_i$, car les axiomes de $upright("PA")$ sont clos.
]

== Correction et complétude

// Sources : Dowek, Les démonstrations et les algorithmes, §2.2–2.4 ; Lassaigne, §3.
Les théorèmes de correction et de complétude du calcul propositionnel restent valables en logique du premier ordre.

Ici, $scripts(⊢)_c$ désigne la déduction naturelle classique avec les règles des quantificateurs et de l'égalité. La relation $⊨$ porte sur toutes les structures de la signature considérée, de domaine non vide, fini ou infini.

#colonnes-cours(
  empiler-presentation: false,
  align: left + top,
  [
    #theoreme[Correction][
      Si $Γ scripts(⊢)_c A$ alors $Γ ⊨ A$.
    ]
  ],
  [
    #theoreme[Complétude][
      Si $Γ ⊨ A$ alors $Γ scripts(⊢)_c A$.
    ]
  ],
)

#slides-only[== Application à une théorie]
Pour toute théorie $T$ du premier ordre, même infinie, on obtient en logique classique :
$ Γ ⊢_T A quad ⟺ quad T ∪ Γ scripts(⊢)_c A quad ⟺ quad T ∪ Γ ⊨ A. $
Autrement dit, $A$ est démontrable à partir des axiomes de $T$ et des hypothèses de $Γ$ si et seulement si, dans tout modèle de $T$, toute affectation qui satisfait $Γ$ satisfait aussi $A$.

Pour montrer $Γ ⊬_T A$, il suffit donc de trouver un modèle de $T$ et une affectation qui satisfait $Γ$ mais rend $A$ fausse.

#slides-only[== Exemple : commutativité des groupes]

#paragraphe([Exemple], trait: true)[
  soit $T$ la théorie des groupes et $A = ∀ x ∀ y (x ⋆ y = y ⋆ x).$ Alors :
  - Le groupe $(ℤ, +)$ est un modèle de $T$ dans lequel $A$ est vraie.
  - Le groupe $S_3$ des permutations de ${1, 2, 3}$, muni de la composition, est un modèle de $T$ dans lequel $A$ est fausse : échanger $1$ et $2$, puis $2$ et $3$, ne donne pas la même permutation que dans l'ordre inverse.
  #v(-0.5em)
  Par correction, une preuve de $A$ à partir de $T$ imposerait que $A$ soit vraie dans $S_3$. Une preuve de $¬ A$ imposerait que $¬ A$ soit vraie dans $(ℤ, +)$. Ainsi :
  $ ⊬_T A quad "et" quad ⊬_T ¬ A. $
]

#slides-only[== Tiers exclu]
#underline[Remarque] : cet exemple ne contredit pas le tiers exclu. Dans chaque modèle de $T$, $A$ est soit vraie, soit fausse.\
On a donc simultanément :
$ ⊢_T (A ∨ ¬ A), quad ⊬_T A, quad ⊬_T ¬ A. $

#hp[== Incomplétude de l'arithmétique]

On reprend l'arithmétique de Peano #link(<pa>)[$upright("PA")$] définie précédemment.

Une théorie $T$ contenant $upright("PA")$ est _cohérente_ si $⊬_T 0 = 1$. Ses axiomes sont _énumérables_ si un programme peut les produire tous, éventuellement sans s'arrêter.

Les deux théorèmes suivants sont admis.

#slides-only[== Premier théorème d'incomplétude]
// Sources : Florian Rabe, Logic, § Incompleteness, https://github.com/florian-rabe/Teaching/blob/master/logic/fol-proofs_models.tex ;
// UniMath, Symmetry Book, Metamathematical remarks, https://github.com/UniMath/SymmetryBook/blob/master/metamath.tex.
#theoreme(hp: true)[Premier théorème d'incomplétude de Gödel][
  Soit $T$ une théorie cohérente sur la signature de $upright("PA")$, contenant $upright("PA")$ et dont les axiomes sont énumérables. Il existe une formule close $A$ telle que :
  $ ⊬_T A quad "et" quad ⊬_T ¬ A. $
]

En particulier, comme les axiomes de $upright("PA")$ sont vrais dans $ℕ$, on peut choisir une formule $A$ vraie dans $ℕ$ que $upright("PA")$ ne démontre ni ne réfute.

#slides-only[== Cohérence et second théorème]
Les preuves peuvent être codées par des entiers. On peut ainsi construire une formule arithmétique $upright("Con")(T)$ exprimant, pour le codage usuel des preuves, qu'aucune preuve à partir de $T$ n'aboutit à $0 = 1$.

#theoreme(hp: true)[Second théorème d'incomplétude de Gödel][
  Si $T$ est une théorie cohérente sur la signature de $upright("PA")$, contenant $upright("PA")$ et dont les axiomes sont énumérables, alors $⊬_T upright("Con")(T)$.
]

Ce résultat n'exclut pas une preuve de la cohérence de $T$ dans une autre théorie. Il ne contredit pas non plus la complétude de la logique : celle-ci concerne les formules vraies dans *tous* les modèles de $T$, et non celles qui sont vraies dans la seule structure $ℕ$.
