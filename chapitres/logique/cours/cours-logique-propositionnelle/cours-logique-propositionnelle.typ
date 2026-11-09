#import "/load.typ": (
  code, colonnes-cours, completer, cours-et-presentation, equation-slide, est-corrige, est-presentation,
  formules-reparties, item-by-item, liste-cours, pb, saut-page-cours, sep, slide, slides-only, solution, substituer,
  taille-presentation, theoremes,
)
#import theoremes: algorithme, commentaire, corollaire, definition, exercice, probleme, propriete, theoreme
#import code: code-extrait
#import "@preview/tdtr:0.6.1": tidy-tree-graph

#let arbre(encadrer: false, ..args) = tidy-tree-graph.with(
  text-size: 1em,
  spacing: (1.5em, 1.2em),
  node-inset: if encadrer { 0.4em } else { 0.15em },
  draw-node: if encadrer { (stroke: 0.5pt + black, fill: white) } else { (stroke: none) },
  draw-edge: (marks: "-", stroke: 0.05em),
)(..args)

#let ocaml = read("corrige.ml")

#show: cours-et-presentation.with(titre: "Logique propositionnelle (MP2I)", niveau: "MPI")
#set text(size: 10.5pt) if not est-presentation()
#show <syntaxe>: set block(above: 0pt) if not est-presentation()
#show <formes-normales>: set block(below: 0.4em) if not est-presentation()
#show <forme-normale-negative>: set block(above: 0.4em) if not est-presentation()

= Syntaxe <syntaxe>

#colonnes-cours(
  columns: (1.89fr, 1fr),
  [
    #definition[Formule propositionnelle][
      Soit $V$ un ensemble fini de _variables propositionnelles_.
      L'ensemble $cal(F)(V)$ des _formules logiques_ est le langage engendré par la grammaire $G$ :
      $ S ⟶ ⊤ ∣ ⊥ ∣ x ∣ ¬ S ∣ (S ∧ S) ∣ (S ∨ S) ∣ (S → S) ∣ (S ↔ S) quad (x ∈ V) $
    ]
  ],
  [
    #exercice[
      1. Montrer que $G$ est non ambiguë.
      2. Le langage $cal(F)(V)$ est-il régulier ?
    ]
  ],
)

#solution[
  Pour $n ≥ 1$, posons $H(n) =$ « Toute formule de longueur $n$ possède un unique arbre de dérivation ».

  - $H(1)$ est vraie : une formule de longueur $1$ est $⊤$, $⊥$ ou une variable $x ∈ V$.

  - Soit $n ≥ 2$. Supposons $H(k)$ vraie pour tout $1 ≤ k < n$ et considérons une formule $φ$ de longueur $n$.
    - Si $φ$ commence par $¬$, seule la production $S ⟶ ¬ S$ est possible à la racine. La sous-formule qui suit $¬$ est déterminée, de longueur $n - 1$. Son arbre est unique d'après $H(n - 1)$.
    - Si $φ$ commence par une parenthèse, son connecteur principal est le seul connecteur binaire à profondeur de parenthésage $1$ : ceux des deux sous-formules sont entourés de parenthèses supplémentaires. Il détermine donc la production utilisée et la découpe en deux sous-formules. Leurs longueurs sont strictement inférieures à $n$, donc leurs arbres sont uniques par hypothèse de récurrence.
    Dans les deux cas, l'arbre de dérivation de $φ$ est unique, donc $H(n)$ est vraie.
]
#solution[
  Lemme de l'étoile avec $u = (...(⊤ ∧ ⊤) ... ⊤) ∧ ⊤)$.
]

#slides-only[== Arbre d'une formule]

#colonnes-cours(
  columns: (1.26fr, 1fr),
  saut-slide: true,
  [
    #definition[Arbre d'une formule][
      L'_arbre d'une formule_ $φ$ est l'arbre enraciné où :
      - Les feuilles sont les variables et constantes.
      - Les nœuds internes sont les connecteurs logiques.

      Une _sous-formule_ de $φ$ est une formule correspondant à un sous-arbre de l'arbre de $φ$.
    ]<arbre-formule>
  ],
  [
    #align(center, figure(
      arbre(encadrer: true)[
        - $∨$
          - $∧$
            - $x$
            - $¬$
              - $y$
          - $z$
      ],
      caption: [Arbre de $φ_1 = (x ∧ ¬ y) ∨ z$],
    ))
  ],
)
#v(-0.5em)
#exercice[
  Dessiner l'arbre de dérivation du mot $φ_1 ∈ cal(F)(V)$ et comparer à @arbre-formule.
]

#slides-only[== Priorités et parenthèses]
Pour alléger les écritures, on omet certaines parenthèses : $¬$ est prioritaire sur $∧$, puis viennent $∨$, $→$ et $↔$, dans cet ordre.
Par convention : #equation-slide($φ → ψ → χ = φ → (ψ → χ).$)

#slides-only[== Induction sur les formules]
#colonnes-cours(
  columns: (1.26fr, 1fr),
  [
    #theoreme(coeur: true)[Induction sur les formules][
      Soit $P(φ)$ une propriété sur les formules $φ ∈ cal(F)(V)$ telle que :
      - $P(⊤)$, $P(⊥)$ et $P(x)$ pour $x ∈ V$
      - Si $P(φ)$ alors $P(¬ φ)$
      - Si $P(φ)$ et $P(ψ)$ alors $P(φ ⋆ ψ)$ pour #box[$⋆ ∈ {∧, ∨, →, ↔}$]
      #v(-0.5em)
      Alors $P(φ)$ est vraie pour toute formule $φ ∈ cal(F)(V)$.
    ]
  ],
  [
    #exercice[
      Exprimer $abs(φ)$ en fonction du nombre $b(φ)$ de connecteurs binaires et $n(φ)$ de négations.
    ]
  ],
)

= Sémantique
#v(-0.5em)
== Valuations et modèles

#definition[Valuation, évaluation][
  Une _valuation_ est une fonction $v : V ⟶ {0, 1}$, qu'on prolonge sur les formules $φ ∈ cal(F)(V)$ par :#v(-0.5em)
  #formules-reparties(
    empiler-presentation: false,
    $v(⊤) = 1$,
    $v(⊥) = 0$,
    $v(¬ φ) = 1 - v(φ)$,
  )#v(-0.5em)
  #formules-reparties(
    empiler-presentation: false,
    $v(φ ∧ ψ) = min(v(φ), v(ψ))$,
    $v(φ ∨ ψ) = max(v(φ), v(ψ))$,
  )
  Avant l'évaluation, on remplace récursivement $φ → ψ$ par $¬ φ ∨ ψ$ et $φ ↔ ψ$ par $(¬ φ ∨ ψ) ∧ (¬ ψ ∨ φ)$.
  On note ${0, 1}^V$ l'ensemble des valuations sur $V$.
]
Une valuation peut aussi être vue comme un ensemble (des variables évaluées à $1$) ou un mot de ${0, 1}^(|V|)$.

#slides-only[== Évaluation en OCaml]
Pour les exemples OCaml, on se limite aux connecteurs $¬$, $∧$ et $∨$.
#colonnes-cours(
  columns: (1fr, 1fr),
  code-extrait(ocaml, "formule"),
  code-extrait(ocaml, "eval"),
)

#slides-only[== Modèles]
#v(-0.5em)
#definition(title: [Modèle et contre-modèle], item-by-item[
  Soit $v$ une valuation et $φ$ une formule.
  - $v$ est un _modèle_ de $φ$, noté $v ⊨ φ$, si $v$ satisfait $φ$, c'est-à-dire $v(φ) = 1$.
  - $v$ est un _contre-modèle_ de $φ$, noté $v ⊭ φ$, si $v(φ) = 0$.
  - On note $cal(M)(φ)$ l'_ensemble des modèles_ de $φ$.
])

#slides-only[== Conséquence logique]
#definition[Conséquence logique][
  Soit $Γ ⊆ cal(F)(V)$ un ensemble de formules.
  - On note $cal(M)(Γ) = ⋂_(φ ∈ Γ) cal(M)(φ)$ l'ensemble des valuations satisfaisant toutes les formules de $Γ$.
  - On dit qu'une formule $φ$ est une _conséquence logique_ de $Γ$, noté $Γ ⊨ φ$, si $cal(M)(Γ) ⊂ cal(M)(φ)$.
  - On note $Γ ⊭ φ$ lorsqu'il existe un modèle de $Γ$ qui est un contre-modèle de $φ$.
  On note simplement $ψ ⊨ φ$ si $Γ = {ψ}$ et $⊨ φ$ si $Γ = ∅$.
]

#underline[Intuitivement] : $Γ ⊨ φ$ signifie « quand $Γ$ est vrai, $φ$ est vraie ».

#slide()
#exercice[
  Soient $Γ = {x ∨ y, x → z, y → z}$.
  Que vaut $cal(M)(Γ)$ ? A-t-on $Γ ⊨ z$ ? $Γ ⊨ x$ ?
]
#solution[
  En représentant $v$ par $(v(x), v(y), v(z))$, on obtient $cal(M)(Γ) = {(0, 1, 1), (1, 0, 1), (1, 1, 1)}$.

  Tous ces modèles satisfont $z$, donc $Γ ⊨ z$. Le modèle $(0, 1, 1)$ ne satisfait pas $x$, donc $Γ ⊭ x$.
]

// #theoreme[
//   #taille-presentation(0.8em)[
//     #formules-reparties(
//       $cal(M)(¬ φ) = overline(cal(M)(φ))$,
//       $cal(M)(φ ∧ ψ) = cal(M)(φ) ∩ cal(M)(ψ)$,
//       $cal(M)(φ ∨ ψ) = cal(M)(φ) ∪ cal(M)(ψ)$,
//     )
//   ]
// ]

#slides-only[== Satisfiabilité]

#definition[Satisfiabilité][
  Une formule $φ$ est _satisfiable_ si $cal(M)(φ) ≠ ∅$, _antilogie_ si $cal(M)(φ) = ∅$, et une _tautologie_ si $cal(M)(φ) = {0, 1}^V$.
]
#underline[Exemples] : $x ∧ y$ est satisfiable, $x ∨ ¬ x$ est une tautologie et $x ∧ ¬ x$ est une antilogie.\
#underline[Remarque] : $φ$ est une tautologie $<==>$ $⊧ φ$ $<==>$  $¬ φ$ est une antilogie.

== Équivalence et conséquence logique

#colonnes-cours(
  columns: (2fr, 1fr),
  [
    #definition[Équivalence sémantique][
      On dit que $φ$ et $ψ$ sont _équivalentes_, noté $φ ≡ ψ$, si $cal(M)(φ) = cal(M)(ψ)$.
    ]
  ],
  [
    #exercice[
      $→$ est-elle associative ?
    ]
  ],
)
#solution[
  Si $φ$, $ψ$ et $χ$ sont fausses, $(φ → ψ) → χ$ est fausse, mais $φ → (ψ → χ)$ est vraie.
]

#propriete[
  #formules-reparties(
    empiler-presentation: true,
    $φ → ψ ≡ ¬ φ ∨ ψ$,
    $φ ↔ ψ ≡ (φ → ψ) ∧ (ψ → φ)$,
  )
]
Ces équivalences permettent d'éliminer $→$ et $↔$ pour obtenir une formule équivalente utilisant seulement $¬$, $∧$ et $∨$.

#slides-only[== Compatibilité de l'équivalence]
#theoreme[Compatibilité de l'équivalence avec les connecteurs][
  Si $φ ≡ φ'$, $ψ ≡ ψ'$ et $⋆ ∈ {∧, ∨, →, ↔}$ alors $¬ φ ≡ ¬ φ'$ et $φ ⋆ ψ ≡ φ' ⋆ ψ'$.
]

#corollaire[Remplacement d'une sous-formule][
  Soit $φ$ une formule, $ψ$ une sous-formule de $φ$ et $ψ' ≡ ψ$. \
  Alors la formule $φ'$ obtenue en remplaçant $ψ$ par $ψ'$ dans $φ$ est équivalente à $φ$.
]
#solution[
  Par induction sur le nombre de connecteurs entre l'occurrence remplacée et la racine de l'arbre, en appliquant le théorème précédent à chaque étape.
]


#slide()
#theoreme[
  Soit $Γ = {φ_1, …, φ_k}$ un ensemble fini de formules.
  #formules-reparties(
    empiler-presentation: false,
    $φ ⊨ ψ quad & ⟺ quad ⊨ φ → ψ$,
    $Γ ⊨ ψ quad & ⟺ quad ⊨ φ_1 ∧ … ∧ φ_k → ψ$,
  )
  $
    φ ≡ ψ quad ⟺ quad (φ ⊨ ψ & " et " ψ ⊨ φ) quad ⟺ quad ⊨ φ ↔ ψ \
  $
]

== Table de vérité
#definition[Table de vérité][
  La _table de vérité_ d'une formule $φ ∈ cal(F)(V)$ est un tableau donnant $v(φ)$ pour chaque valuation $v ∈ {0, 1}^V$, en ligne.
]

#colonnes-cours(
  columns: (1fr, 1fr),
  saut-slide: true,
  [
    #figure(
      align(center, table(
        columns: 7,
        align: center,
        inset: (x: 0.4em, y: 0.3em),
        stroke: 0.4pt,
        [$x$], [$y$], [$¬ x$], [$x ∧ y$], [$x ∨ y$], [$x → y$], [$x ↔ y$],
        [0], [0], [1], [0], [0], [1], [1],
        [0], [1], [1], [0], [1], [1], [0],
        [1], [0], [0], [0], [1], [0], [0],
        [1], [1], [0], [1], [1], [1], [1],
      )),
      caption: [Table de vérité des connecteurs logiques],
    )
  ],
  [
    #figure(
      align(center, table(
        columns: 4,
        align: center,
        inset: (x: 0.6em, y: 0.3em),
        stroke: 0.4pt,
        [$x$], [$y$], [$x → y$], [$φ$],
        [0], [0], [1], [0],
        [0], [1], [1], [0],
        [1], [0], [0], [1],
        [1], [1], [1], [1],
      )),
      caption: [Table de vérité de $φ = (x → y) → x$],
    )
  ],
)

#slide()
#colonnes-cours(
  columns: (1fr, 1fr),
  [
    #theoreme(coeur: true)[
      $ φ ≡ ψ <==> φ "et" ψ "ont la même table de vérité" $
    ]
  ],
  [
    #align(center, pad(top: 1em)[#underline[Exemple] : $(x → y) → x ≡ x$.])
  ],
)

#exercice[
  Soit $V$ un ensemble de $n$ variables. Combien existe-t-il de formules sur $V$, à équivalence près ?
]

#solution[
  Une table de vérité comporte $2^n$ lignes, chacune portant une valeur dans ${0, 1}$ : il existe donc $2^(2^n)$ tables possibles. Toute table est réalisable par une formule, comme le montrera la construction d'une FND au @thm-fnd-fnc. Il existe donc exactement $2^(2^n)$ classes d'équivalence.
]

== Substitution

#definition[Substitution][
  On note $substituer(φ, x, ψ)$ la formule obtenue en remplaçant chaque occurrence d'une variable $x$ dans $φ$ par $ψ$.
]

#underline[Exemple] : $substituer((x ∧ ¬ y), x, (y ∨ z)) = (y ∨ z) ∧ ¬ y$.

== Quantificateurs

#definition[Quantificateurs][
  On définit les _quantificateurs propositionnels_ $∃$ et $∀$ par :
  #formules-reparties(
    empiler-presentation: true,
    $∃ x thin φ := substituer(φ, x, ⊥) ∨ substituer(φ, x, ⊤)$,
    $∀ x thin φ := substituer(φ, x, ⊥) ∧ substituer(φ, x, ⊤)$,
  )
  La variable $x$ prend les valeurs $0$ et $1$.
]

#slides-only[== Élimination des quantificateurs]
Ces notations peuvent être imbriquées. On élimine les quantificateurs de l'intérieur vers l'extérieur en les remplaçant par leur définition, puis on simplifie.

#underline[Exemple] :
$ ∃ x thin (x ∧ y) ≡ (⊥ ∧ y) ∨ (⊤ ∧ y) ≡ y. $

Chaque élimination peut doubler la taille de la formule. Le développement peut donc être exponentiel en le nombre de quantificateurs.

#slides-only[== Ordre des quantificateurs]
#exercice[
  Simplifier $∀ x thin ∃ y thin (x ↔ y)$ et $∃ y thin ∀ x thin (x ↔ y)$. Expliquer pourquoi l'ordre des quantificateurs compte.
]
#solution[
  On élimine d'abord le quantificateur intérieur :
  $ ∃ y thin (x ↔ y) ≡ ¬ x ∨ x ≡ ⊤, $
  $ ∀ x thin (x ↔ y) ≡ ¬ y ∧ y ≡ ⊥. $
  Ainsi, $∀ x thin ∃ y thin (x ↔ y) ≡ ⊤$, tandis que $∃ y ∀ x thin (x ↔ y) ≡ ⊥$.

  Dans la première formule, on peut choisir $y = x$ pour chaque valeur de $x$. Dans la seconde, il faudrait choisir une même valeur de $y$ convenant aux deux valeurs de $x$, ce qui est impossible.
]

== Équivalences usuelles

#colonnes-cours(
  columns: (1fr, 1fr),
  saut-slide: true,
  encadrer: propriete.with(coeur: true),
  [
    $
        φ ∧ ⊤ & ≡ φ &      φ ∨ ⊥ & ≡ φ \
        φ ∧ ⊥ & ≡ ⊥ &      φ ∨ ⊤ & ≡ ⊤ \
        φ ∧ φ & ≡ φ &      φ ∨ φ & ≡ φ \
      φ ∧ ¬ φ & ≡ ⊥ &    φ ∨ ¬ φ & ≡ ⊤ \
        ¬ ¬ φ & ≡ φ & wide φ → ψ & ≡ ¬ ψ → ¬ φ
    $
  ],
  [
    #grid(
      columns: (auto, 1fr),
      column-gutter: 0em,
      row-gutter: 0.7em,
      align: left + horizon,
      [_De Morgan_ :],
      [$
        ¬ (φ ∧ ψ) & ≡ ¬ φ ∨ ¬ ψ \
        ¬ (φ ∨ ψ) & ≡ ¬ φ ∧ ¬ ψ
      $],

      [_Quantificateurs_ :],
      [$
        ¬ (∃ x thin φ) & ≡ ∀ x thin ¬ φ \
        ¬ (∀ x thin φ) & ≡ ∃ x thin ¬ φ
      $],

      [_Distributivité_ :],
      [$
        φ ∧ (ψ ∨ χ) & ≡ (φ ∧ ψ) ∨ (φ ∧ χ) \
        φ ∨ (ψ ∧ χ) & ≡ (φ ∨ ψ) ∧ (φ ∨ χ)
      $],
    )
  ],
)

== Algèbre de Boole

En algèbre de Boole, on note $overline(a)$ pour $¬ a$, $a + b$ pour $a ∨ b$ et $a b$ pour $a ∧ b$. \
On peut alors faire l'analogie entre formules et réels : $a(b + c) = a b + a c$ se traduit en $φ ∧ (ψ ∨ χ) ≡ (φ ∧ ψ) ∨ (φ ∧ χ)$.

#theoreme[
  Soient $I$ et $J$ deux ensembles finis.
  #formules-reparties(
    $ (or.big_(i ∈ I) φ_i) ∧ (or.big_(j ∈ J) ψ_j) ≡ or.big_((i, j) ∈ I × J) φ_i ∧ ψ_j $,
    $ (and.big_(i ∈ I) φ_i) ∨ (and.big_(j ∈ J) ψ_j) ≡ and.big_((i, j) ∈ I × J) φ_i ∨ ψ_j $,
  )
]
#solution[
  En appliquant successivement les distributivités :
  $ (or.big_(i ∈ I) φ_i) ∧ (or.big_(j ∈ J) ψ_j) ≡ or.big_((i, j) ∈ I × J) φ_i ∧ ψ_j, $
  $ (and.big_(i ∈ I) φ_i) ∨ (and.big_(j ∈ J) ψ_j) ≡ and.big_((i, j) ∈ I × J) φ_i ∨ ψ_j. $
]

= Formes normales <formes-normales>

== Forme normale négative <forme-normale-negative>

#definition[Forme normale négative][
  Une formule logique, éventuellement écrite avec des quantificateurs, est en _forme normale négative_ (FNN) si elle n'utilise que les connecteurs $∧$, $∨$, $¬$, les quantificateurs $∃$, $∀$ et les constantes $⊤$, $⊥$, et si ses négations ne portent que sur des variables.
]

#slides-only[== Passage en FNN]
#colonnes-cours(
  columns: (1fr, 1fr),
  [
    #theoreme[Toute formule est équivalente à une FNN.]
  ],
  [
    #underline[Exemples] :
    $ ¬ (x ∨ (¬ y ∧ z)) ≡ ¬ x ∧ (y ∨ ¬ z), $
    $ ¬ (∃ x thin (x ∧ ¬ y)) ≡ ∀ x thin (¬ x ∨ y). $
  ],
)

#solution[
  Après élimination des connecteurs $→$ et $↔$ à l'aide des équivalences précédentes, on montre simultanément, par induction sur l'écriture obtenue, que celle-ci et sa négation sont équivalentes à des FNN, en conservant les quantificateurs.

  Pour une variable ou une constante, le résultat est immédiat, avec $¬ ⊤ ≡ ⊥$ et $¬ ⊥ ≡ ⊤$. Le cas $¬ ψ$ échange les deux formes obtenues pour $ψ$, en utilisant $¬ ¬ ψ ≡ ψ$. Pour $ψ ∧ χ$ et $ψ ∨ χ$, on combine les formes obtenues pour les sous-formules, en appliquant les lois de De Morgan pour la négation.

  Pour $∃ x thin ψ$ et $∀ x thin ψ$, on conserve le quantificateur et on utilise la FNN obtenue pour $ψ$. Pour leur négation, on échange $∃$ et $∀$ et on utilise la FNN obtenue pour $¬ ψ$.
]


== FND et FNC

#definition[Formes normales][
  - Un _littéral_ est une variable ou sa négation : $x$ ou $¬ x$.
  - Une _clause_ est une disjonction $∨$ de littéraux, un _terme_ est une conjonction $∧$ de littéraux.
  - Une _forme normale conjonctive_ (FNC) est une conjonction de clauses : #box[$(x ∨ z) ∧ (¬ y ∨ z)$].
  - Une _forme normale disjonctive_ (FND) est une disjonction de termes : #box[$(x ∧ ¬ y) ∨ z$].
  #v(-0.4em)
  Une conjonction vide vaut $⊤$, une disjonction vide vaut $⊥$.
]

#slides-only[== Existence des FND et FNC]
Les FNC et FND ci-dessus ne contiennent pas de quantificateur. Pour une formule quantifiée, on élimine d'abord les quantificateurs à l'aide de leur définition.

#theoreme(coeur: true)[Toute formule est équivalente à une FND et à une FNC.]<thm-fnd-fnc>

#solution[
  Soit $V = {x_1, …, x_n}$. Pour chaque valuation $v$, posons :
  $ T_v = and.big_(i=1)^n ℓ_i, quad ℓ_i = cases(x_i & "si " v(x_i) = 1, ¬ x_i & "si " v(x_i) = 0). $
  $T_v$ est vrai exactement pour la valuation $v$. La disjonction des $T_v$ tels que $v(φ) = 1$ est une FND de $φ$. Pour la FNC, prendre la conjonction des clauses $¬ ℓ_1 ∨ … ∨ ¬ ℓ_n$ associées aux lignes où $φ$ est fausse, en supprimant les doubles négations.

  On peut aussi déduire l'existence d'une FNC de celle d'une FND : écrire $¬ φ ≡ T_1 ∨ … ∨ T_k$, où chaque $T_i$ est une conjonction de littéraux. Alors $φ ≡ ¬ T_1 ∧ … ∧ ¬ T_k$. Par De Morgan, chaque $¬ T_i$ est équivalente à une clause.
]

#slides-only[== Conversion en FNC]
#exercice[X-ENS 2016 MP][
  Donner des formules équivalentes en FNC :
  #liste-cours(
    columns: 2,
    [
      $(x_1 ∨ ¬ x_0) ∧ ¬ (x_4 ∧ ¬ (x_3 ∧ x_2))$
    ],
    [
      $(x_0 ∧ x_1) ∨ (x_2 ∧ x_3) ∨ (x_4 ∧ x_5)$
    ],
  )

]
#solution[
  + $(x_1 ∨ ¬ x_0) ∧ (¬ x_4 ∨ x_3) ∧ (¬ x_4 ∨ x_2)$.
  + $
        & (x_0 ∨ x_2 ∨ x_4) ∧ (x_0 ∨ x_2 ∨ x_5) ∧ (x_0 ∨ x_3 ∨ x_4) ∧ (x_0 ∨ x_3 ∨ x_5) \
      ∧ & (x_1 ∨ x_2 ∨ x_4) ∧ (x_1 ∨ x_2 ∨ x_5) ∧ (x_1 ∨ x_3 ∨ x_4) ∧ (x_1 ∨ x_3 ∨ x_5).
    $
]

#slides-only[== Calcul d'une FNC en OCaml]
#exercice[Programmation][
  On veut calculer une FNC équivalente à une `formule` définie plus haut, sans construire sa table de vérité.
  + Écrire `fnn : formule -> formule` qui calcule une FNN équivalente.
  + Écrire `distribuer : formule -> formule -> formule` qui, étant données deux FNC `p` et `q`, calcule une FNC équivalente à `Ou (p, q)`.
  + En déduire `fnc : formule -> formule`. Justifier sa correction.
  + En utilisant `fnc` et les lois de De Morgan, écrire `fnd : formule -> formule` qui calcule une FND équivalente à son argument.
  On représentera $⊤$ et $⊥$ par `Top` et `Bot`, et on simplifiera les constantes lors des distributions. Il n'est pas demandé de minimiser les formes normales obtenues.
]
#solution[
  + On supprime les doubles négations et on applique les lois de De Morgan pour pousser les négations jusqu'aux variables :
    #code-extrait(ocaml, "fnn")
  + On distribue récursivement dès qu'un argument est une conjonction. Sinon, après traitement des constantes, les deux arguments sont des clauses.
    #code-extrait(ocaml, "distribuer")
  + Après passage en FNN, on procède par induction sur la formule : les littéraux et constantes conviennent déjà, une conjonction réunit deux FNC, et `distribuer` traite une disjonction en préservant l'équivalence.
    #code-extrait(ocaml, "fnc")
  + Si $¬ φ ≡ C_1 ∧ … ∧ C_k$ est en FNC alors $φ ≡ ¬ C_1 ∨ … ∨ ¬ C_k$. Le passage en FNN transforme chaque négation de clause en un terme.
    #code-extrait(ocaml, "fnd")
]

== Problème #pb("SAT")
#colonnes-cours(
  columns: (1fr, 1.3fr),
  [
    #probleme(pb("SAT"))[
      - #underline[Entrée] : une formule propositionnelle $φ$.
      - #underline[Question] : $φ$ est-elle satisfiable ?
    ]
  ],
  [
    #probleme([$k$-#pb("SAT") ($k$ fixé)])[
      - #underline[Entrée] : $φ$ FNC avec au plus $k$ littéraux par clause.
      - #underline[Question] : $φ$ est-elle satisfiable ?
    ]
  ],
)

= Algorithme de Quine

On considère dans cette partie des formules sans quantificateur.

== Arbre de décision

#definition[Arbre de décision][
  Un _arbre de décision_ sur $V$ est un arbre binaire $T$ tel que :
  - chaque nœud interne est étiqueté par une variable et possède deux fils, reliés par des arêtes étiquetées $0$ et $1$.
  - chaque feuille est étiquetée par $0$ ou $1$.
  - une variable est testée au plus une fois sur un chemin de la racine à une feuille.
  On note $T(v)$ l'étiquette de la feuille atteinte en suivant les arêtes étiquetées par $v(x)$ pour chaque nœud interne $x$ rencontré.\
  $T$ _représente_ une formule $φ$ s'il renvoie $v(φ)$ pour toute valuation $v$.
]
#underline[Attention] : Ne pas confondre arbre de dérivation (syntaxique) et arbre de décision (sémantique).

#slide()
#theoreme[
  Soit $T$ un arbre de décision représentant une formule $φ$.
  #colonnes-cours(
    empiler-presentation: false,
    [- $φ$ satisfiable $<==>$ #completer()],
    [- $φ$ tautologie $<==>$ #completer()],
  )
]

== Algorithme de Quine par backtracking

#theoreme[Simplification][
  Toute formule $φ$ est équivalente à une formule $ψ$ telle que $ψ ∈ {top, bot}$ ou $ψ$ ne contient ni $⊤$, ni $⊥$.
]<thm-simplification>

#solution[
  On procède par induction sur $φ$. Une variable ou une constante convient déjà. Pour une négation, une conjonction ou une disjonction, on simplifie d'abord les sous-formules, puis on applique les identités :
  $ ¬ ⊤ ≡ ⊥, quad ¬ ⊥ ≡ ⊤, $
  $ ⊤ ∧ ψ ≡ ψ, quad ⊥ ∧ ψ ≡ ⊥, $
  $ ⊤ ∨ ψ ≡ ⊤, quad ⊥ ∨ ψ ≡ ψ, $
  ainsi que les identités symétriques pour $∧$ et $∨$. Si aucune sous-formule n'est une constante, on conserve le connecteur. Dans tous les cas, la formule obtenue est équivalente à $φ$, sa taille n'augmente pas et elle vérifie la propriété annoncée.

  Pour $→$ et $↔$, on simplifie de même les sous-formules, puis on utilise :
  $ ⊤ → ψ ≡ ψ, quad ⊥ → ψ ≡ ⊤, quad ψ → ⊤ ≡ ⊤, quad ψ → ⊥ ≡ ¬ ψ, $
  $ ⊤ ↔ ψ ≡ ψ, quad ⊥ ↔ ψ ≡ ¬ ψ, $
  ainsi que les identités symétriques pour $↔$.

  Un parcours postfixe de l'arbre traite chaque nœud une seule fois, en temps constant par nœud, en réutilisant les sous-arbres conservés. Le coût total est donc $O(|φ|)$.
]

#theoreme[Décomposition de Shannon][
  Une formule $φ$ est satisfiable si et seulement si l'une des deux formules $substituer(φ, x, ⊥)$, $substituer(φ, x, ⊤)$ est satisfiable :
  $ φ ≡ (¬ x ∧ substituer(φ, x, ⊥)) ∨ (x ∧ substituer(φ, x, ⊤)). $
]

#slide()

#colonnes-cours(
  columns: (1fr, 1fr),
  saut-slide: true,
  [
    #algorithme(title: [Quine], coeur: true)[
      + Simplifier $φ$ avec @thm-simplification.
      + *Si* $φ = ⊤$: *renvoyer* vrai.
      + *Si* $φ = ⊥$: *renvoyer* faux.
      + Choisir une variable $x$ dans $φ$.
      + *renvoyer* `Quine`$(substituer(φ, x, ⊥))$ `||` `Quine`$(substituer(φ, x, ⊤))$.
    ]
  ],
  [
    #figure(
      align(center, arbre(spacing: (2.4em, 2.4em), encadrer: true)[
        - $(x ∨ y) ∧ (¬ x ∨ z)$
          + $x := 0$
          - $y$
            + $y := 0$
            - $⊥$
            + $y := 1$
            - $⊤$
          + $x := 1$
          - $z$
            + $z := 0$
            - $⊥$
            + $z := 1$
            - $⊤$
      ]),
      caption: [Exemple avec $φ = (x ∨ y) ∧ (¬ x ∨ z)$],
    )
  ],
)

#solution[
  Le nombre de variables restantes décroît strictement à chaque appel, ce qui assure la terminaison. La décomposition de Shannon justifie les deux branches et les simplifications préservent l'équivalence.
]

#slides-only[== Complexité de Quine]
#underline[Complexité] : #completer()
#solution[
  l'arbre a une hauteur au plus $n$ et au plus $2^(n + 1) - 1$ nœuds. Avec une simplification, une substitution et un choix de variable en $O(|φ|)$ par nœud, le coût est $O(2^n |φ|)$. Les simplifications peuvent arrêter l'exploration bien plus tôt.
]
