#import "/load.typ": exercice, question

#let ex = exercice(meta: (titre: "Formes normales et variables auxiliaires", chapitres: ("logique",), difficulte: 3, niveaux: ("MPI",)))[
  #question[
        Pour $k ≥ 1$, donner une FND de $φ_k = and.big_(i=1)^k (x_i ∨ y_i)$, où les $2k$ variables sont distinctes. Comparer sa taille à celle de $φ_k$.
      ][
        La distributivité donne $2^k$ termes de $k$ littéraux, un pour chaque choix de $x_i$ ou $y_i$ dans chaque paire. Cette FND a pour taille $Θ(k 2^k)$, tandis que $abs(φ_k) = 4k - 1$.
      ]

  #question[
        Montrer que toute FND équivalente à $φ_k$ possède au moins $2^k$ termes. Considérer les valuations où exactement une variable de chaque paire est vraie. En déduire qu'une mise en FNC peut elle aussi produire une formule de taille exponentielle.
      ][
        Il existe $2^k$ de ces valuations. Un terme satisfiable d'une FND de $φ_k$ doit contenir $x_i$ ou $y_i$ positivement pour chaque $i$. Sinon, mettre ces deux variables à $0$ dans un modèle du terme conserverait le terme vrai mais rendrait $φ_k$ fausse.
        Le terme couvre donc au plus une des valuations choisies, puisque chaque littéral positif fixe la variable vraie de sa paire. Il faut au moins $2^k$ termes.
        Une FNC de $¬ φ_k$ donne, par négation et lois de De Morgan, une FND de $φ_k$ avec autant de termes que de clauses. Toute FNC de $¬ φ_k$ possède donc au moins $2^k$ clauses.
      ]

  On cherche maintenant à éviter un tel développement pour obtenir une FNC. Soit $φ$ construite avec des variables et les connecteurs $¬$, $∧$, $∨$, sans constante. À chaque nœud interne $t$ de son arbre, associer une variable nouvelle $z_t$, différente des variables initiales et des autres variables nouvelles. Pour une feuille $t$ étiquetée par $x$, poser $a_t = x$, et pour un nœud interne poser $a_t = z_t$.

  #question[
        Donner des FNC de $z ↔ ¬ a$, de $z ↔ (a ∧ b)$ et de $z ↔ (a ∨ b)$, avec des clauses de taille au plus $3$.
      ][
        On obtient respectivement :
        $
          &(¬ z ∨ ¬ a) ∧ (z ∨ a), \
          &(¬ z ∨ a) ∧ (¬ z ∨ b) ∧ (z ∨ ¬ a ∨ ¬ b), \
          &(z ∨ ¬ a) ∧ (z ∨ ¬ b) ∧ (¬ z ∨ a ∨ b).
        $
        Les deux sens de chaque équivalence donnent ces clauses par distributivité.
      ]

  #question[
        À chaque nœud interne, imposer la relation de la question précédente entre sa variable et celles de ses fils. Ajouter la clause unitaire imposant que la racine soit vraie. On note $C_φ$ la FNC obtenue.
        Montrer que chaque modèle de $φ$ se prolonge en un unique modèle de $C_φ$, et que la restriction de tout modèle de $C_φ$ aux variables initiales satisfait $φ$. En déduire l'équisatisfiabilité.
      ][
        Pour une valuation initiale $v$, les relations imposent par induction $z_t = v(φ_t)$, où $φ_t$ est la sous-formule enracinée en $t$. Le prolongement qui satisfait les relations locales existe et est unique.
        La clause de la racine est vraie exactement lorsque $v ⊨ φ$. Ainsi, un modèle de $φ$ a un unique prolongement satisfaisant $C_φ$, et tout modèle de $C_φ$ se restreint à un modèle de $φ$. En particulier, les deux formules sont satisfiables simultanément.
      ]

  #question[
        Si l'arbre de $φ$ a $r$ nœuds internes, majorer le nombre de variables nouvelles et le nombre de clauses. Cette construction, appelée transformation de Tseitin, donne-t-elle une formule équivalente à $φ$ sur l'ensemble des variables élargi ?
      ][
        On ajoute $r$ variables et au plus $3r + 1$ clauses de taille au plus $3$. La taille de sortie et le temps de construction par parcours de l'arbre sont en $O(abs(φ))$.
        Les formules ne sont pas équivalentes sur les variables élargies. Pour $φ = x ∧ y$, la valuation $x = y = 1$, $z = 0$ satisfait $φ$ mais pas $C_φ$. La construction préserve l'existence d'un modèle, en autorisant un choix des variables auxiliaires.
      ]
]
