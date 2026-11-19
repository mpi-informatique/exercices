#import "/load.typ": exercice, question

#let ex = exercice(meta: (titre: "Satisfaire beaucoup de clauses", chapitres: ("logique", "algorithmique"), difficulte: 2, niveaux: ("MPI",)))[
  Soit $f$ une FNC de $m ≥ 1$ clauses sur $n ≥ 3$ variables. Dans cet exercice, chaque clause contient _exactement trois littéraux portant sur trois variables distinctes_. Pour une valuation $v$, on note $S_f(v)$ le nombre de clauses satisfaites et $M(f) = max_v S_f(v)$.

  #question[
        Construire sur trois variables une formule non satisfiable de huit clauses. Calculer $M(f)$ pour cette formule.
      ][
        Prendre la conjonction des huit clauses obtenues en choisissant indépendamment le signe de chaque variable. Chaque valuation rend exactement une clause fausse, celle dont les trois littéraux sont faux. La formule est insatisfiable et $M(f) = 7$.
      ]

  #question[
        Pour une clause fixée, combien des $2^n$ valuations la satisfont ? En considérant une valuation uniforme, en déduire l'espérance de $S_f$.
      ][
        Une clause est fausse pour une seule affectation des trois variables concernées, les $n - 3$ autres étant libres. Elle est donc satisfaite par $2^n - 2^(n - 3) = (7 / 8) 2^n$ valuations.
        Chaque indicatrice de satisfaction a pour espérance $7 / 8$. Par linéarité, $bold(E)(S_f) = 7m / 8$, sans hypothèse d'indépendance entre les clauses.
      ]

  #question[
        Minorer $M(f)$ en fonction de $m$. En déduire le nombre minimum de clauses d'une formule insatisfiable sous les hypothèses de cet exercice. Pourquoi la condition sur les variables distinctes est-elle nécessaire ?
      ][
        Le maximum est au moins la moyenne : $M(f) ≥ ceil(7m / 8)$. Si $m ≤ 7$, ce plafond vaut $m$ et la formule est satisfiable. Il faut donc au moins huit clauses, borne atteinte à la première question.
        Sans variables distinctes, $(x ∨ x ∨ x) ∧ (¬ x ∨ ¬ x ∨ ¬ x)$ est déjà insatisfiable avec deux clauses.
      ]

  #question[
        Proposer un algorithme déterministe qui construit une valuation satisfaisant au moins $ceil(7m / 8)$ clauses. À chaque étape, comparer les deux moyennes obtenues en fixant la prochaine variable à $0$ ou à $1$, puis en complétant uniformément les autres.
      ][
        La moyenne avant un choix est la demi-somme des deux moyennes après ce choix. Garder une valeur dont la moyenne est au moins la moyenne actuelle. Après les $n$ choix, cette moyenne est le nombre de clauses effectivement satisfaites, donc il est au moins $7m / 8$.
        Pour calculer une moyenne, sommer les contributions des clauses : $1$ si la clause est déjà vraie, $0$ si elle est déjà fausse, et $1 - 2^(-r)$ s'il reste $r$ littéraux non fixés et que les autres sont faux.
        Chaque étape examine $m$ clauses de trois littéraux. Le coût est $O(n m)$. Ici $r ≤ 3$, donc multiplier toutes les moyennes par $8$ permet des calculs entiers exacts.
      ]
]
