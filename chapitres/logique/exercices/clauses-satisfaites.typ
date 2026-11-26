#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Satisfaire beaucoup de clauses",
  chapitres: ("logique", "algorithmique"),
  difficulte: 2,
  niveaux: ("MPI",),
))[
  Soit $φ$ une FNC de $m ≥ 1$ clauses sur $n ≥ 3$ variables. Dans cet exercice, chaque clause contient _exactement trois littéraux portant sur trois variables distinctes_. Pour une valuation $v$, on note $S_φ (v)$ le nombre de clauses satisfaites et $M(φ) = max_v S_φ (v)$.

  #question[
    Construire sur trois variables une formule insatisfiable de huit clauses. Calculer $M(φ)$ pour cette formule.
  ][
    On prend la conjonction des huit clauses obtenues en choisissant indépendamment le signe de chacune des trois variables $x_1, x_2, x_3$ :
    $ φ = (x_1 ∨ x_2 ∨ x_3) ∧ (x_1 ∨ x_2 ∨ ¬ x_3) ∧ … ∧ (¬ x_1 ∨ ¬ x_2 ∨ ¬ x_3). $
    Chaque valuation rend fausse exactement une clause (celle dont les trois littéraux sont faux) et satisfait les sept autres. La formule est donc insatisfiable et $M(φ) = 7$.
  ]

  #question[
    Pour une clause fixée, combien des $2^n$ valuations la satisfont ? En choisissant une valuation uniformément au hasard parmi les $2^n$ valuations possibles, en déduire l'espérance de $S_φ$.
  ][
    Une clause est fausse pour une seule affectation de ses trois variables, les $n - 3$ autres variables étant libres. Elle est donc satisfaite par $2^n - 2^(n - 3) = (7 / 8) 2^n$ valuations.

    On écrit $S_φ = sum_(i = 1)^m X_i$, où $X_i$ est la variable indicatrice qui vaut $1$ si la $i$-ème clause est satisfaite et $0$ sinon. Chaque $X_i$ a pour espérance $7 / 8$. Par linéarité de l'espérance (sans aucune hypothèse d'indépendance entre les clauses), on obtient $EE(S_φ) = 7m / 8$.
  ]

  #question[
    Minorer $M(φ)$ en fonction de $m$. En déduire le nombre minimum de clauses d'une formule insatisfiable sous les hypothèses de cet exercice. Pourquoi la condition sur les variables distinctes est-elle nécessaire ?
  ][
    Le maximum est au moins égal à la moyenne, donc $M(φ) ≥ 7m / 8$. Comme $M(φ)$ est un entier, on en déduit $M(φ) ≥ ceil(7m / 8)$.

    Si $m ≤ 7$, alors $7m / 8 > m - 1$, donc $ceil(7m / 8) = m$ et $φ$ est nécessairement satisfiable. Une formule insatisfiable comporte donc au moins huit clauses, borne atteinte à la première question.

    Sans la condition de variables distinctes, la formule $(x ∨ x ∨ x) ∧ (¬ x ∨ ¬ x ∨ ¬ x)$ est déjà insatisfiable avec deux clauses.
  ]

  #question[
    Proposer un algorithme déterministe qui construit une valuation satisfaisant au moins $ceil(7m / 8)$ clauses.

    _Indication._ Fixer les variables une par une en comparant les deux espérances obtenues selon que l'on affecte $0$ ou $1$ à la variable courante, les variables restantes étant tirées uniformément au hasard.
  ][
    Pour des valeurs déjà fixées $a_1, …, a_(k - 1) ∈ {0, 1}$ des $k - 1$ premières variables, notons $E(a_1, …, a_(k - 1))$ l'espérance du nombre de clauses satisfaites lorsque les variables restantes $x_k, …, x_n$ sont tirées uniformément et indépendamment. En conditionnant selon la valeur de $x_k$, on a :
    $ E(a_1, …, a_(k - 1)) = 1 / 2 (E(a_1, …, a_(k - 1), 0) + E(a_1, …, a_(k - 1), 1)). $
    L'une des deux valeurs $b ∈ {0, 1}$ vérifie donc $E(a_1, …, a_(k - 1), b) ≥ E(a_1, …, a_(k - 1))$. On choisit cette valeur pour $a_k$.

    Par récurrence, la suite des espérances est croissante : à l'issue des $n$ choix, toutes les variables sont fixées, donc $S_φ (a_1, …, a_n) = E(a_1, …, a_n) ≥ E() = 7m / 8$, d'où $S_φ (a_1, …, a_n) ≥ ceil(7m / 8)$ puisque ce nombre est entier.

    Pour calculer $E(a_1, …, a_k)$, on somme par linéarité les contributions de chacune des $m$ clauses : $1$ si la clause est déjà satisfaite, $0$ si tous ses littéraux sont déjà faux, et $1 - 2^(-r)$ s'il reste $r$ littéraux non fixés et que les autres sont faux. Chaque étape examine $m$ clauses de trois littéraux, soit un coût total en $O(n m)$ (et comme $r ≤ 3$, multiplier par $8$ permet d'effectuer tous les calculs en arithmétique entière exacte).

    _Remarque._ Cette méthode (dite des espérances conditionnelles) donne un algorithme déterministe d'approximation de facteur $7 / 8$ pour le problème d'optimisation MAX-3-SAT.
  ]
]
