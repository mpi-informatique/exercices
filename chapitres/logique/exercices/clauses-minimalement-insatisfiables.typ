#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
    titre: "Clauses minimalement insatisfiables et littéraux purs",
    chapitres: ("logique", "algorithmique"),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
)[
  On représente une formule en forme normale conjonctive (FNC) par un ensemble fini $S$ de clauses, chaque clause étant un ensemble fini de littéraux. Une valuation satisfait $S$ si elle satisfait au moins un littéral dans chaque clause de $S$.

  On dit qu'un littéral $ℓ$ est _pur_ dans $S$ si $ℓ$ appartient à au moins une clause de $S$ et son opposé $overline(ℓ)$ n'appartient à aucune clause de $S$. On dit que $S$ est _minimalement insatisfiable_ si $S$ est insatisfiable et tout sous-ensemble strict $S' ⊊ S$ est satisfiable.

  #question[
    Donner un exemple d'ensemble minimalement insatisfiable contenant trois clauses sur deux variables $x$ et $y$, puis un exemple d'ensemble insatisfiable qui n'est pas minimalement insatisfiable. Justifier.
  ][
    L'ensemble $S_1 = {{x, y}, {¬ x}, {¬ y}}$ est minimalement insatisfiable :
    - Toute valuation satisfaisant ${¬ x}$ et ${¬ y}$ vérifie $v(x) = 0$ et $v(y) = 0$, donc ne satisfait pas ${x, y}$. Ainsi $S_1$ est insatisfiable.
    - Chaque sous-ensemble à deux clauses est satisfiable : sans ${x, y}$ par $v(x) = v(y) = 0$, sans ${¬ x}$ par $v(x) = 1, v(y) = 0$, et sans ${¬ y}$ par $v(x) = 0, v(y) = 1$. Tout sous-ensemble strict de $S_1$ est donc satisfiable.

    L'ensemble $S_2 = {{x}, {¬ x}, {y}}$ est insatisfiable, mais n'est pas minimalement insatisfiable car son sous-ensemble strict ${{x}, {¬ x}}$ est déjà insatisfiable.
  ]

  #question[
    Soit $ℓ$ un littéral pur dans $S$, et soit $S'$ l'ensemble obtenu en retirant de $S$ toutes les clauses contenant $ℓ$. Montrer que $S$ est satisfiable si et seulement si $S'$ est satisfiable.
  ][
    *Sens direct.* Si une valuation $v$ satisfait $S$, alors elle satisfait en particulier son sous-ensemble $S' ⊆ S$, donc $S'$ est satisfiable.

    *Sens réciproque.* Supposons qu'il existe une valuation $v'$ satisfaisant $S'$. Notons $x$ la variable propositionnelle du littéral $ℓ$, et définissons la valuation $v$ qui coïncide avec $v'$ sur toutes les variables sauf éventuellement $x$, où l'on choisit $v(x)$ de sorte que $v(ℓ) = 1$ (c'est-à-dire $v(x) = 1$ si $ℓ = x$ et $v(x) = 0$ si $ℓ = ¬ x$).
    - Comme $ℓ$ est pur dans $S$, le littéral $overline(ℓ)$ n'apparaît dans aucune clause de $S$. Comme toutes les clauses contenant $ℓ$ ont été retirées, la variable $x$ n'apparaît pas dans $S'$. Ainsi $v$ coïncide avec $v'$ sur les variables de $S'$, donc $v$ satisfait $S'$.
    - De plus, $v(ℓ) = 1$, donc $v$ satisfait toutes les clauses de $S ∖ S'$, qui contiennent toutes $ℓ$.
    La valuation $v$ satisfait donc $S$, ce qui montre que $S$ est satisfiable.
  ]

  #question[
    En déduire qu'un ensemble minimalement insatisfiable ne contient aucun littéral pur. La réciproque est-elle vraie ? Justifier.
  ][
    Supposons par l'absurde qu'un ensemble minimalement insatisfiable $S$ contienne un littéral pur $ℓ$. Notons $S'$ l'ensemble obtenu en retirant de $S$ les clauses contenant $ℓ$. Comme $ℓ$ figure dans au moins une clause de $S$, on a $S' ⊊ S$. Par minimalité de $S$, l'ensemble $S'$ est satisfiable. D'après la question précédente, $S$ est alors satisfiable, ce qui est absurde.

    La réciproque est fausse : l'ensemble $S = {{x}, {¬ x}, {y}, {¬ y}}$ est insatisfiable et ne contient aucun littéral pur, mais il n'est pas minimalement insatisfiable car ${{x}, {¬ x}} ⊊ S$ est déjà insatisfiable.
  ]

  #question[
    Expliquer comment la propriété de la question 2 et la simplification par clause unitaire peuvent être utilisées dans l'algorithme de Quine. Appliquer cette démarche à l'ensemble :
    $ S = {{x, y}, {¬ x, z}, {¬ y, ¬ z}, {¬ z, w}}. $
  ][
    Avant de brancher sur une variable dans l'algorithme de Quine, on peut répéter deux règles qui préservent la satisfiabilité sans créer de branchement :
    - *Clause unitaire* : si une clause est réduite à un unique littéral ${ℓ}$, on impose $v(ℓ) = 1$, on supprime les clauses contenant $ℓ$ et on retire $overline(ℓ)$ des autres clauses.
    - *Littéral pur* : si un littéral $ℓ$ est pur, on impose $v(ℓ) = 1$ et on supprime toutes les clauses contenant $ℓ$ (d'après la question 2).

    Sur l'ensemble $S = {{x, y}, {¬ x, z}, {¬ y, ¬ z}, {¬ z, w}}$ :
    1. Le littéral $w$ est pur dans $S$. On fixe $v(w) = 1$ et on retire ${¬ z, w}$, ce qui donne $S_1 = {{x, y}, {¬ x, z}, {¬ y, ¬ z}}$.
    2. Dans $S_1$, il n'y a ni clause unitaire ni littéral pur. On branche sur $x$ en essayant d'abord $v(x) = 1$ : la clause ${x, y}$ est satisfaite et ${¬ x, z}$ devient la clause unitaire ${z}$, d'où ${{z}, {¬ y, ¬ z}}$.
    3. La clause unitaire ${z}$ impose $v(z) = 1$, ce qui réduit ${¬ y, ¬ z}$ à la clause unitaire ${¬ y}$. On impose alors $v(y) = 0$ et il ne reste plus aucune clause.
    L'ensemble $S$ est donc satisfiable, par exemple par la valuation $v(x) = 1$, $v(y) = 0$, $v(z) = 1$, $v(w) = 1$.
  ]
]
