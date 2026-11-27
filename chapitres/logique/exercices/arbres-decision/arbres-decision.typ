#import "/load.typ": code, exercice, question
#import "/chapitres/logique/cours/cours-logique-propositionnelle/cours-logique-propositionnelle.typ" as cours
#import code: code-extrait
#import "@preview/tdtr:0.6.1": tidy-tree-graph
#let ocaml = read("arbres-decision-cor.ml")
#let arbre(encadrer: false, ..args) = tidy-tree-graph.with(
  text-size: 1em,
  spacing: (1.8em, 1.3em),
  node-inset: if encadrer { 0.4em } else { 0.15em },
  draw-node: if encadrer { (stroke: 0.5pt + black, fill: white) } else { (stroke: none) },
  draw-edge: (marks: "-", stroke: 0.04em),
)(..args)

#let ex = exercice(meta: (
  titre: "Arbres de décision et fonctions booléennes",
  chapitres: ("logique", "structures"),
  structures: ("arbre-binaire",),
  langages: ("OCaml",),
  difficulte: 3,
  niveaux: ("MPI",),
  source: "Adapté de l'oral ENS MP 2019",
))[
  Un _arbre de décision ordonné_ sur les variables $x_0, …, x_(n - 1)$ est un arbre binaire dont les feuilles sont étiquetées par $0$ ou $1$, dont chaque nœud interne est étiqueté par une variable et tel que, sur chaque chemin de la racine à une feuille, les indices des variables testées soient strictement croissants. Certaines variables peuvent ne pas être testées.

  Pour une valuation $v$, au nœud $x_i$, on suit le fils gauche si $v(x_i) = 0$ et le fils droit si $v(x_i) = 1$. On note $v(T)$ l'étiquette de la feuille atteinte dans l'arbre $T$, $abs(T)$ le nombre de nœuds de $T$ et $h(T)$ sa hauteur.

  On utilise les types suivants :
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    align: left + top,
    code-extrait(ocaml, "decision"), code-extrait(cours.ocaml, "formule"),
  )

  #question[
    Soit $φ = (x_0 ∨ x_1) ∧ (¬ x_1 ∨ x_2)$. Appliquer l'algorithme de Quine en explorant les deux branches à chaque test, dans l'ordre $x_0, x_1, x_2$. Dessiner l'arbre de décision obtenu et en déduire le nombre de modèles de $φ$.
  ][
    Après substitution de $x_0$ et simplification des constantes, il reste $x_1 ∧ (¬ x_1 ∨ x_2)$ dans la branche $x_0 = 0$ et $¬ x_1 ∨ x_2$ dans la branche $x_0 = 1$. Le test de $x_1$ donne ensuite $⊥$ ou $x_2$ à gauche, et $⊤$ ou $x_2$ à droite (fils gauche pour $0$, fils droit pour $1$) :
    #align(center, arbre[
      - $x_0$
        - $x_1$
          - $0$
          - $x_2$
            - $0$
            - $1$
        - $x_1$
          - $1$
          - $x_2$
            - $0$
            - $1$
    ])
    La feuille $1$ atteinte par $x_0 = 1, x_1 = 0$ ne teste pas $x_2$ : elle correspond à deux modèles, $(1, 0, 0)$ et $(1, 0, 1)$. Avec $(0, 1, 1)$ et $(1, 1, 1)$, la formule $φ$ admet donc exactement quatre modèles.
  ]
  #question[
    Écrire `non : decision -> decision` construisant, à partir de $T_1$, un arbre $T_2$ tel que $v(T_2) = ¬ v(T_1)$ pour toute valuation $v$. Justifier la correction et donner les complexités en temps et en espace auxiliaire.
  ][
    #code-extrait(ocaml, "non")
    On inverse les étiquettes des feuilles. Par induction sur $T_1$, l'arbre obtenu $T_2$ est ordonné et vérifie $v(T_2) = ¬ v(T_1)$ pour toute valuation $v$ : c'est immédiat pour une feuille et, à un nœud interne $x_i$, les deux arbres suivent le même fils, où l'hypothèse d'induction s'applique, et l'ordre des variables est conservé.\
    Chaque nœud est visité une fois en temps constant : le temps de calcul et la taille de l'arbre construit sont $Θ(abs(T_1))$, et l'espace auxiliaire (pile d'appels) est $Θ(h(T_1) + 1)$.
  ]

  #question[
    Écrire `decision_vers_formule : decision -> formule` convertissant un arbre de décision en une formule équivalente. Donner le temps, la taille de sortie et l'espace auxiliaire.
  ][
    #code-extrait(ocaml, "decision_vers_formule")
    On raisonne par induction sur $T$. Les feuilles $0$ et $1$ sont traduites par $⊥$ et $⊤$. Pour un nœud étiqueté par $x_i$, de fils $T_g$ et $T_d$, on utilise la décomposition de Shannon :
    $ v(T) = (¬ v(x_i) ∧ v(T_g)) ∨ (v(x_i) ∧ v(T_d)). $
    Par hypothèse d'induction, les formules obtenues pour $T_g$ et $T_d$ leur sont équivalentes, donc la formule $ψ$ renvoyée vérifie $v(ψ) = v(T)$ pour toute valuation $v$.\
    Chaque nœud est visité une fois et produit un nombre borné de nœuds de formule ($1$ par feuille, $6$ par nœud interne). Le temps et la taille de sortie sont $Θ(abs(T))$, et l'espace auxiliaire (pile d'appels) est $Θ(h(T) + 1)$.
  ]

  #question[
    Écrire `et : decision -> decision -> decision` construisant, à partir de $T_1$ et $T_2$, un arbre ordonné $T_3$ tel que $v(T_3) = v(T_1) ∧ v(T_2)$ pour toute valuation $v$. Justifier la correction et la conservation de l'ordre des variables.
    Majorer le temps de calcul et la taille du résultat en fonction de $abs(T_1)$ et $abs(T_2)$.
  ][
    #code-extrait(ocaml, "et")
    Les cas de feuilles utilisent $0 ∧ b = 0$ et $1 ∧ b = b$. Sinon, on note $x_i$ et $x_j$ les variables aux racines.
    Si $i = j$, les deux arbres suivent le même choix : on combine leurs fils gauches, puis leurs fils droits.
    Si $i < j$, l'évaluation de $T_2$ ne dépend pas de $v(x_i)$, puisque tous les indices de $T_2$ sont au moins $j$. On teste donc $x_i$ et on combine chacun des fils de $T_1$ avec $T_2$. Le cas $i > j$ est symétrique.

    On raisonne par induction sur $abs(T_1) + abs(T_2)$ pour établir l'équivalence et la conservation de l'ordre. Les cas de feuilles sont immédiats. Dans les autres cas, la somme des tailles décroît strictement dans chaque appel récursif. Les hypothèses d'induction donnent des fils ordonnés représentant les bonnes conjonctions, dont tous les indices sont strictement supérieurs à $min(i, j)$, qui est l'indice de la nouvelle racine. Le résultat $T_3$ est donc ordonné et vérifie $v(T_3) = v(T_1) ∧ v(T_2)$.

    Montrons de même par induction sur $abs(T_1) + abs(T_2)$ que $abs(T_3) ≤ abs(T_1) abs(T_2)$, en notant $T_(k, g)$ et $T_(k, d)$ les fils de $T_k$ :
    - si $T_1$ ou $T_2$ est une feuille (de taille $1$), $T_3$ est soit une feuille, soit l'autre arbre, donc $abs(T_3) ≤ abs(T_1) abs(T_2)$ ;
    - si $i < j$, alors $abs(T_2) ≥ 1$ et
      $
        abs(T_3) = 1 + abs("et"(T_(1, g), T_2)) + abs("et"(T_(1, d), T_2)) ≤ 1 + (abs(T_1) - 1) abs(T_2) ≤ abs(T_1) abs(T_2)
      $
      (le cas $i > j$ est symétrique) ;
    - si $i = j$, en utilisant $abs(T_k) = 1 + abs(T_(k, g)) + abs(T_(k, d))$ :
      $ abs(T_3) ≤ 1 + abs(T_(1, g)) abs(T_(2, g)) + abs(T_(1, d)) abs(T_(2, d)) ≤ abs(T_1) abs(T_2). $

    Chaque appel récursif crée un nœud de $T_3$ ou renvoie un sous-arbre de taille au moins $1$ : le nombre total d'appels est donc au plus $abs(T_3) ≤ abs(T_1) abs(T_2)$ (on peut aussi remarquer qu'un même couple de nœuds de $T_1 × T_2$ est visité au plus une fois). Chaque appel s'effectuant en temps constant, la complexité en temps est $O(abs(T_1) abs(T_2))$.

    _Remarque._ En OCaml, les cas de feuille vraie renvoient directement `t` par partage sans recopier ce sous-arbre : la mémoire allouée est donc majorée par le nombre d'appels, et reste en $O(abs(T_1) abs(T_2))$. À chaque appel récursif, $h(T_1) + h(T_2)$ décroît d'au moins $1$, donc la pile d'appels occupe $O(h(T_1) + h(T_2) + 1)$ cases.
  ]

  #question[
    Écrire `compter : int -> decision -> int` pour compter les modèles sur les $n$ variables en temps linéaire en la taille de l'arbre, sans énumérer les valuations.
  ][
    #code-extrait(ocaml, "compter")
    L'appel `aux p a` compte les valuations des variables $x_p, …, x_(n - 1)$ qui satisfont le sous-arbre $a$, lequel ne teste aucune variable d'indice inférieur à $p$.
    On prouve cette propriété par induction sur $a$. Une feuille $0$ donne $0$. Pour une feuille $1$, les $n - p$ variables restantes sont libres, d'où $2^(n - p)$ valuations.
    Au nœud $x_i$, de fils $T_g$ et $T_d$, les $i - p$ variables sautées ($x_p, …, x_(i - 1)$) sont libres. Pour chaque choix de leurs valeurs, les cas $x_i = 0$ et $x_i = 1$ sont disjoints et les hypothèses d'induction donnent leurs nombres de prolongements. On obtient
    $ 2^(i - p) ("aux"(i + 1, T_g) + "aux"(i + 1, T_d)). $
    L'appel initial `aux 0 arbre` donne donc le nombre de modèles. Pour un arbre $T$, chaque nœud est traité une fois en temps constant (`1 lsl k` calcule $2^k$ en $O(1)$ dans la limite des entiers machine), donc le temps est $Θ(abs(T))$ et l'espace auxiliaire (pile d'appels) est $Θ(h(T) + 1)$.
  ]

  #question[
    Écrire `ou : decision -> decision -> decision`, puis `formule_vers_decision : formule -> decision`. Justifier que l'arbre obtenu est ordonné et représente la formule donnée.
  ][
    Par les lois de De Morgan, $v(T_1) ∨ v(T_2) = ¬ (¬ v(T_1) ∧ ¬ v(T_2))$, ce qui permet d'écrire `ou` à l'aide de `non` et `et` (qui préservent le caractère ordonné), puis de traduire récursivement la formule :
    #code-extrait(ocaml, ("ou", "formule_vers_decision"))
    On raisonne par induction sur la formule $φ$. Les constantes $⊤$ et $⊥$ donnent des feuilles (ordonnées, de valeur $1$ et $0$), et une variable $x_i$ donne un nœud $x_i$ de fils $0$ et $1$, ordonné et évalué à $v(x_i)$. Pour une négation, une conjonction ou une disjonction, les hypothèses d'induction et la correction de `non`, `et` et `ou` donnent un arbre ordonné représentant $φ$.

    _Remarque._ Une écriture directe de `ou` (calquée sur `et`) éviterait les trois appels à `non`. Par ailleurs, la taille de l'arbre produit par `formule_vers_decision` peut croître exponentiellement avec la taille de la formule, à cause du produit dans `et` et `ou`.
  ]

  #question[
    Donner une autre construction d'un arbre ordonné représentant une formule $φ$, par substitutions successives comme dans l'algorithme de Quine. Majorer la taille de l'arbre en fonction du nombre $n$ de variables.
    Si l'on savait toujours construire un arbre équivalent en temps polynomial en $abs(φ)$, que pourrait-on en déduire pour le problème SAT ?
  ][
    On simplifie la formule. Si elle est constante, on renvoie la feuille correspondante. Sinon, on choisit la variable de plus petit indice encore présente et on construit récursivement les arbres des deux formules obtenues par substitution de $0$ et de $1$. On les réunit sous un nœud étiqueté par cette variable.
    La décomposition de Shannon justifie la correction. Le nombre de variables restantes décroît strictement, ce qui assure la terminaison, et les indices testés croissent strictement sur chaque chemin.

    La hauteur est au plus $n$, donc l'arbre possède au plus $2^(n + 1) - 1$ nœuds. Cette borne est exponentielle et les simplifications ne garantissent pas une petite sortie.
    Si l'on savait toujours construire en temps polynomial en $abs(φ)$ un arbre de décision ordonné représentant $φ$, la taille de l'arbre produit serait nécessairement polynomiale. Comme les indices sont strictement croissants sur chaque chemin, chaque feuille est atteinte par au moins une valuation : $φ$ est satisfiable si et seulement si l'arbre contient une feuille $1$. Il suffirait donc de le parcourir pour décider SAT en temps polynomial. Comme SAT est NP-complet, cela impliquerait $"P" = "NP"$.
  ]
]
