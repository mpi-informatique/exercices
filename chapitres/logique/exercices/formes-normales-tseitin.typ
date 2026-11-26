#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Formes normales et variables auxiliaires",
  chapitres: ("logique",),
  difficulte: 3,
  niveaux: ("MPI",),
))[
  #question[
    Pour $k ≥ 1$, donner une FND de $φ_k = and.big_(i=1)^k (x_i ∨ y_i)$, où les $2k$ variables sont distinctes. Comparer sa taille à celle de $φ_k$.
  ][
    Par distributivité généralisée, on obtient la FND
    $ φ_k ≡ or.big_(a_1 ∈ {x_1, y_1}, …, a_k ∈ {x_k, y_k}) (a_1 ∧ … ∧ a_k), $
    composée de $2^k$ termes de $k$ littéraux chacun. En comptant le nombre de nœuds de l'arbre d'une formule, cette FND a pour taille $Θ(k 2^k)$, tandis que $abs(φ_k) = 4k - 1$.
  ]

  #question[
    Montrer que toute FND équivalente à $φ_k$ possède au moins $2^k$ termes. En déduire qu'une mise en FNC peut elle aussi produire une formule de taille exponentielle.

    _Indication._ Considérer les valuations où exactement une variable de chaque paire ${x_i, y_i}$ est vraie.
  ][
    Il existe $2^k$ telles valuations, qui satisfont toutes $φ_k$. Un terme insatisfiable ne couvre aucune valuation. Un terme satisfiable $T$ d'une FND de $φ_k$ doit contenir le littéral positif $x_i$ ou le littéral positif $y_i$ pour chaque $i ∈ {1, …, k}$ : sinon, en modifiant un modèle de $T$ pour mettre $x_i$ et $y_i$ à $0$, on conserverait $T$ vrai (donc la FND vraie) tout en rendant $φ_k$ fausse.

    Si $T$ satisfait l'une des $2^k$ valuations choisies, ce littéral positif dans chaque paire impose la variable qui vaut $1$, donc aussi celle qui vaut $0$. Ainsi $T$ couvre au plus une de ces $2^k$ valuations. Il faut donc au moins $2^k$ termes dans toute FND équivalente à $φ_k$.

    Enfin, une FNC équivalente à $¬ φ_k$ donne, par négation et lois de De Morgan, une FND équivalente à $φ_k$ ayant autant de termes que de clauses. Toute FNC équivalente à $¬ φ_k$ possède donc au moins $2^k$ clauses.
  ]

  On cherche maintenant à éviter un tel développement pour obtenir une FNC. Soit $φ$ une formule construite avec des variables et les connecteurs $¬$, $∧$, $∨$, sans constante. À chaque nœud interne $t$ de son arbre, on associe une nouvelle variable $z_t$, distincte des variables initiales et des autres nouvelles variables. On pose $a_t = x$ si $t$ est une feuille étiquetée par $x$, et $a_t = z_t$ si $t$ est un nœud interne.

  #question[
    Donner des FNC de $z ↔ ¬ a$, de $z ↔ (a ∧ b)$ et de $z ↔ (a ∨ b)$, avec des clauses de taille au plus $3$.
  ][
    En traduisant les deux sens de chaque équivalence et en distribuant (par exemple $z ↔ (a ∧ b) ≡ (¬ z ∨ (a ∧ b)) ∧ (¬ (a ∧ b) ∨ z)$), on obtient respectivement :
    $
      & (¬ z ∨ ¬ a) ∧ (z ∨ a), \
      & (¬ z ∨ a) ∧ (¬ z ∨ b) ∧ (z ∨ ¬ a ∨ ¬ b), \
      & (z ∨ ¬ a) ∧ (z ∨ ¬ b) ∧ (¬ z ∨ a ∨ b).
    $
  ]

  #question[
    Pour chaque nœud interne $t$, on ajoute les clauses de la question précédente traduisant l'équivalence entre $z_t$ et le connecteur de $t$ appliqué aux variables $a_u$ (et $a_v$) de son ou ses fils. On ajoute enfin la clause unitaire $a_(t_0)$, où $t_0$ est la racine de l'arbre. On note $C_φ$ la FNC obtenue.

    Montrer que chaque modèle de $φ$ se prolonge en un unique modèle de $C_φ$, et que la restriction de tout modèle de $C_φ$ aux variables initiales satisfait $φ$. En déduire que $φ$ et $C_φ$ sont _équisatisfiables_ ($φ$ est satisfiable si et seulement si $C_φ$ l'est).
  ][
    Soit $v$ une valuation sur les variables initiales et notons $φ_t$ la sous-formule enracinée en un nœud $t$. Une induction sur l'arbre de $φ$ montre que les clauses locales imposent exactement $v'(a_t) = v(φ_t)$ pour tout prolongement $v'$ de $v$ qui les satisfait (pour une feuille $t$, c'est immédiat ; pour un nœud interne, la FNC locale traduit l'équivalence entre $z_t$ et l'opération sur les fils). Il existe donc un unique prolongement $v'$ de $v$ satisfaisant toutes les clauses locales.

    La clause unitaire $a_(t_0)$ est alors satisfaite par $v'$ si et seulement si $v(φ) = 1$. Ainsi, tout modèle de $φ$ se prolonge en un unique modèle de $C_φ$, et la restriction de tout modèle de $C_φ$ aux variables initiales est un modèle de $φ$. En particulier, $φ$ est satisfiable si et seulement si $C_φ$ l'est.
  ]

  #question[
    Si l'arbre de $φ$ a $r$ nœuds internes, majorer le nombre de variables nouvelles et le nombre de clauses. Cette construction, appelée _transformation de Tseitin_, donne-t-elle une formule équivalente à $φ$ sur l'ensemble des variables élargi ?
  ][
    On ajoute $r$ variables et au plus $3r + 1$ clauses, toutes de taille au plus $3$. La taille de $C_φ$ et le temps de construction par parcours de l'arbre sont en $O(abs(φ))$.

    Les formules ne sont pas équivalentes sur l'ensemble des variables élargi : pour $φ = x ∧ y$, la valuation $v(x) = v(y) = 1$, $v(z_(t_0)) = 0$ satisfait $φ$ mais pas $C_φ$. La transformation préserve uniquement la satisfiabilité, en autorisant un choix convenable des variables auxiliaires.

    _Remarque._ Comme toutes les clauses ont au plus trois littéraux, la transformation de Tseitin est au cœur de la réduction polynomiale de SAT vers 3-SAT.
  ]
]
