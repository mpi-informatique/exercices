#import "/load.typ": (
  article-only, colonnes-cours, cours-et-presentation, formules-reparties, hp, liste-cours, pause, slide, slides-only, solution,
  taille-presentation, theoremes,
)
#import "@preview/curryst:0.6.0": prooftree, rule
#import "/load.typ": logique
#import logique: arbre, tableau-regles
#import theoremes: definition, exercice, theoreme

#show: cours-et-presentation.with(titre: "Logique du premier ordre", niveau: "MPI")

Comme pour la logique propositionnelle, il y a 3 points de vue sur les formules :
- Syntaxe : construction des formules à partir de symboles, sans leur donner de sens.
- Sémantique : interprétation des formules avec une valuation.
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
  $ F ⟶ R(T, …, T) | ¬ F | (F ∧ F) | (F ∨ F) | (F → F) | ∃ x F | ∀ x F $
  où $R$ est un symbole de relation d'arité $n > 0$, appliqué à $n$ termes, $T$ est un terme et $x ∈ cal(V)$.
]
#slide()
#underline[Exemples] :
- Théorie des groupes : $∀ x ∃ y (x ⋆ y = e)$ est une formule.
- Théorie des ensembles : $∀ x ∀ y ((x ∪ y)^c = x^c ∩ y^c)$ est une formule.

#pause
#underline[Attention] : ne pas confondre variable (terme décrivant un objet du domaine étudié), par exemple un nombre réel, et variable propositionnelle (objet qui possède une valeur de vérité).

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
$A[x := y ⋆ y] = (∀ x (x = x)) ∧ ∃ z (y ⋆ y = z)$.

#hp[= Sémantique : structures et modèles]

#definition[Structure et interprétation][
  Une _structure_ $cal(M)$ pour une signature $Σ$ est donnée par :
  - un ensemble non vide $D$, appelé _domaine_
  - pour chaque constante $c$, un élément $c^cal(M) ∈ D$
  - pour chaque symbole de fonction $f$ d'arité $n > 0$, une fonction $f^cal(M) : D^n → D$
  - pour chaque symbole de relation $R$ d'arité $n$, une relation $R^cal(M) ⊂ D^n$
]

#slides-only[== Affectations et valeur des termes]
#definition[Affectation][
  Une _affectation_ $ρ : cal(V) → D$ donne une valeur aux variables. La valeur $⟦t⟧_(cal(M), ρ) ∈ D$ d'un terme $t$ est définie par :
  $ ⟦x⟧_(cal(M), ρ) = ρ(x), quad ⟦c⟧_(cal(M), ρ) = c^cal(M) $
  $ ⟦f(t_1, …, t_n)⟧_(cal(M), ρ) = f^cal(M)(⟦t_1⟧_(cal(M), ρ), …, ⟦t_n⟧_(cal(M), ρ)) $
]

#slides-only[== Valeur de vérité]
#definition[Valeur de vérité][
  Pour $a ∈ D$, on note $ρ[x := a]$ l'affectation qui donne à $x$ la valeur $a$ et qui coïncide avec $ρ$ pour les autres variables.

  La valeur de vérité $⟦A⟧_(cal(M), ρ) ∈ {0, 1}$ d'une formule $A$ est définie par :
  - $⟦R(t_1, …, t_n)⟧_(cal(M), ρ) = 1$ si et seulement si $(⟦t_1⟧_(cal(M), ρ), …, ⟦t_n⟧_(cal(M), ρ)) ∈ R^cal(M)$.
  - les connecteurs suivent les mêmes tables de vérité qu'en logique propositionnelle.
  - $⟦∀ x A⟧_(cal(M), ρ) = 1$ si et seulement si $⟦A⟧_(cal(M), ρ[x := a]) = 1$ pour tout $a ∈ D$.
  - $⟦∃ x A⟧_(cal(M), ρ) = 1$ si et seulement si $⟦A⟧_(cal(M), ρ[x := a]) = 1$ pour au moins un $a ∈ D$.
]

#slides-only[== Satisfaction et modèles]
#definition[Satisfaction et modèle][
  On note $(cal(M), ρ) ⊨ A$ si $⟦A⟧_(cal(M), ρ) = 1$ : $A$ est alors vraie dans $cal(M)$ pour $ρ$.

  On note $cal(M) ⊨ A$ si $(cal(M), ρ) ⊨ A$ pour toute affectation $ρ$ : $cal(M)$ est alors un _modèle_ de $A$.
]

#slides-only[== Exemples]
#underline[Exemples] :
- Arithmétique de Peano : sur la signature $Σ = {0, S, +, ×}$, la structure de domaine $ℕ$ interprète $0$ par $0$, $S(n)$ par $n + 1$, et $+$ et $×$ par les opérations usuelles. C'est un modèle des axiomes de Peano ; par exemple, $cal(M) ⊨ ∀ x (x + 0 = x)$.
- Théorie des groupes : sur la signature $Σ = {⋆, e, i}$, la structure de domaine $ℤ$ interprète $⋆$ par l'addition, $e$ par $0$ et $n^(−1)$ par $-n$. C'est un modèle des axiomes des groupes : l'addition sur $ℤ$ est associative, possède $0$ pour élément neutre et chaque entier $n$ a pour inverse $-n$.

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
    [Prouver $¬ (∃ x φ) ⊢ ∀ x ¬ φ$.],
    [Prouver $∃ x (A ∨ B) ⊢ (∃ x A) ∨ (∃ x B)$.],
  )
]
#solution[
  + Posons $Γ = {¬ (∃ x φ)}$.
    #arbre[#prooftree(rule(
      name: [$∀_i$],
      rule(
        name: [$¬_i$],
        rule(
          name: [$¬_e$],
          rule(name: [$∃_i$], rule(name: [ax], [$Γ, φ ⊢ φ$]), [$Γ, φ ⊢ ∃ x φ$]),
          rule(name: [ax], [$Γ, φ ⊢ ¬ (∃ x φ)$]),
          [$Γ, φ ⊢ ⊥$],
        ),
        [$Γ ⊢ ¬ φ$],
      ),
      [$Γ ⊢ ∀ x ¬ φ$],
    ))]
    La règle $∃_i$ utilise le terme $x$ comme témoin. La règle $¬_i$ décharge l'hypothèse $φ$. Enfin, $∀_i$ est valide car $x$ n'est pas libre dans $¬ (∃ x φ)$.

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

== Théorie

#definition[Théorie][
  Une _théorie_ $T$ est un ensemble de formules closes sur une même signature, appelées _axiomes_.

  On note $Γ ⊢_T A$ si $T ∪ Γ ⊢ A$ : la formule $A$ est démontrable à partir des axiomes de $T$ et des hypothèses de $Γ$.
]

On peut introduire des règles propres à $T$ lorsqu'elles se déduisent de ses axiomes et des règles logiques. Ce sont des raccourcis de preuve valables dans les modèles de $T$, mais pas nécessairement dans toutes les structures. En particulier, les règles de l'égalité sont des règles logiques générales, contrairement aux propriétés propres aux groupes ou aux ordres.

#slides-only[== Groupes]
#taille-presentation(0.85em)[
  #exercice[Groupes][
    Sur la signature avec égalité, une constante $e$, une fonction binaire $⋆$ et une fonction unaire notée $x ↦ x^(-1)$, on considère la théorie $T$ des groupes, donnée par les axiomes :
    #formules-reparties($∀ x ∀ y ∀ z ((x ⋆ y) ⋆ z = x ⋆ (y ⋆ z))$)
    #formules-reparties($∀ x (x ⋆ e = x),$, $∀ x (e ⋆ x = x)$)
    #formules-reparties($∀ x (x ⋆ x^(-1) = e)$, $∀ x (x^(-1) ⋆ x = e)$)
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

#slides-only[== Involution et égalité]
#exercice[Involution][
  Sur la signature avec égalité et un symbole de fonction unaire $f$, on considère la théorie $T = {I}$ où $I = ∀ x (f(f(x)) = x)$. On utilise la symétrie, la transitivité et la compatibilité $s = t ==> f(s) = f(t)$ pour tous termes $s, t$.\ Prouver que $f$ est bijective :
  $ ⊢_T ∀ x ∀ y (f(x) = f(y) → x = y) quad "et" quad ⊢_T ∀ y ∃ x (f(x) = y). $
]
#solution[
  Pour l'injectivité, posons $H = (f(x) = f(y))$ et $Γ = {H}$. Pour alléger l'arbre, notons $s = f(f(x))$ et $t = f(f(y))$ : ce sont des abréviations de termes.
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
              rule(name: [$∀_e$], rule(name: [ax], [$Γ ⊢_T I$]), [$Γ ⊢_T s = x$]),
              [$Γ ⊢_T x = s$],
            ),
            rule(name: [cong], rule(name: [ax], [$Γ ⊢_T f(x) = f(y)$]), [$Γ ⊢_T s = t$]),
            [$Γ ⊢_T x = t$],
          ),
          rule(name: [$∀_e$], rule(name: [ax], [$Γ ⊢_T I$]), [$Γ ⊢_T t = y$]),
          [$Γ ⊢_T x = y$],
        ),
        [$⊢_T f(x) = f(y) → x = y$],
      ),
      [$⊢_T ∀ y (f(x) = f(y) → x = y)$],
    ),
    [$⊢_T ∀ x ∀ y (f(x) = f(y) → x = y)$],
  ))]
  La règle $scripts(→)_i$ décharge l'hypothèse $H$. Les deux applications de $∀_i$ sont valides car ni $x$ ni $y$ n'est libre dans l'unique axiome $I$ de $T$.

  Pour la surjectivité, on choisit le terme $f(y)$ comme témoin de $x$ :
  #arbre[#prooftree(rule(
    name: [$∀_i$],
    rule(
      name: [$∃_i$],
      rule(name: [$∀_e$], rule(name: [ax], [$⊢_T I$]), [$⊢_T f(f(y)) = y$]),
      [$⊢_T ∃ x (f(x) = y)$],
    ),
    [$⊢_T ∀ y ∃ x (f(x) = y)$],
  ))]
  La dernière application de $∀_i$ est valide car $y$ n'est pas libre dans l'unique axiome $I$ de $T$.
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

#underline[Exemple] : soit $T$ la théorie des groupes et $A = ∀ x ∀ y (x ⋆ y = y ⋆ x).$ Alors :
- Le groupe $(ℤ, +)$ est un modèle de $T$ dans lequel $A$ est vraie.
- Le groupe $S_3$ des permutations de ${1, 2, 3}$, muni de la composition, est un modèle de $T$ dans lequel $A$ est fausse : échanger $1$ et $2$, puis $2$ et $3$, ne donne pas la même permutation que dans l'ordre inverse.
#v(-0.5em)
Par correction, une preuve de $A$ à partir de $T$ imposerait que $A$ soit vraie dans $S_3$. Une preuve de $¬ A$ imposerait que $¬ A$ soit vraie dans $(ℤ, +)$. Ainsi :
$ ⊬_T A quad "et" quad ⊬_T ¬ A. $

#slides-only[== Tiers exclu]
#underline[Remarque] : cet exemple ne contredit pas le tiers exclu. Dans chaque modèle de $T$, $A$ est soit vraie, soit fausse.\
On a donc simultanément :
$ ⊢_T (A ∨ ¬ A), quad ⊬_T A, quad ⊬_T ¬ A. $
