#import "/load.typ": automate, exercice, question
#import automate: dessiner-automate

#let ex = exercice(meta: (
  titre: "Automates de valuations et ordre des variables",
  chapitres: ("logique", "automates-finis"),
  difficulte: 3,
  niveaux: ("MPI",),
))[
  Soit $φ$ une formule propositionnelle sur des variables $x_1, …, x_n$, munies de cet ordre. À toute valuation $v : {x_1, …, x_n} ⟶ {0, 1}$, on associe le mot $v(x_1) … v(x_n)$ de taille $n$ sur l'alphabet ${0, 1}$. Un _automate de valuations_ pour $φ$ (relativement à l'ordre $x_1, …, x_n$) est un automate fini sur ${0, 1}$ reconnaissant exactement le langage
  $ {v(x_1) … v(x_n) mid(|) v ⊨ φ}. $

  #question[
    Construire un automate déterministe de valuations pour $φ = (x_1 ∧ x_3) ∨ x_2$ dans l'ordre $x_1, x_2, x_3$. L'automate n'a pas besoin d'être complet.
  ][
    Les modèles de $φ$ correspondent aux mots $010$, $011$, $101$, $110$ et $111$. On peut construire l'automate déterministe suivant :
    #dessiner-automate(
      (
        ("q_0", (0, 0), true, false),
        ("a", (2.5, 1), false, false),
        ("b", (2.5, -1), false, false),
        ("c", (5, 1), false, false),
        ("d", (5, -1), false, false),
        ("f", (7.5, 0), false, true),
      ),
      (
        ("q_0", "a", "0", (:)),
        ("q_0", "b", "1", (:)),
        ("a", "c", "1", (:)),
        ("b", "c", "1", (:)),
        ("b", "d", "0", (:)),
        ("c", "f", "0, 1", (:)),
        ("d", "f", "1", (:)),
      ),
    )
    Les états $a$ et $b$ mémorisent respectivement $x_1 = 0$ et $x_1 = 1$. Depuis $a$, la lecture de $x_2 = 0$ rend $φ$ fausse quelle que soit la valeur de $x_3$, donc il n'y a pas de transition par $0$. L'état $c$ indique que $φ$ est déjà satisfaite ($x_2 = 1$) et qu'il reste une variable à lire. L'état $d$ correspond à $x_1 = 1$ et $x_2 = 0$, ce qui impose $x_3 = 1$. Enfin, aucune transition ne sort de l'état final $f$, donc aucun mot de taille différente de $3$ n'est accepté.
  ]

  #question(label: <q-automates-lk>)[
    Pour $k ≥ 1$, on pose $L_k = {u u mid(|) u ∈ {0, 1}^k}$. Montrer que tout automate reconnaissant $L_k$, même non déterministe, possède au moins $2^k$ états.

    _Indication._ Pour chaque mot $u ∈ {0, 1}^k$, considérer un calcul acceptant sur $u u$ et l'état atteint après la lecture du premier facteur $u$.
  ][
    Soit $A = ({0, 1}, Q, I, F, δ)$ un automate (non nécessairement déterministe) tel que $cal(L)(A) = L_k$.
    Pour chaque mot $u ∈ {0, 1}^k$, le mot $u u$ appartient à $L_k$, donc il existe un calcul acceptant de $u u$ dans $A$ :
    $ i_u limits(⟶)^(u) q_u limits(⟶)^(u) f_u, quad "avec" i_u ∈ I "et" f_u ∈ F. $
    Montrons que l'application $u ⟼ q_u$ est injective. Si $u, v ∈ {0, 1}^k$ vérifient $q_u = q_v$ alors la concaténation du préfixe du calcul sur $u u$ et du suffixe du calcul sur $v v$ donne un calcul acceptant
    $ i_u limits(⟶)^(u) q_u = q_v limits(⟶)^(v) f_v $
    pour le mot $u v$. Comme $cal(L)(A) = L_k$, on en déduit $u v ∈ L_k$, donc $u = v$.
    Les $2^k$ mots de ${0, 1}^k$ donnent ainsi $2^k$ états deux à deux distincts dans $Q$, d'où $abs(Q) ≥ 2^k$.
  ]

  #question[
    Pour $k ≥ 1$, construire une formule $Φ_k$ de taille $O(k)$ sur les $2k$ variables $x_1, …, x_k, y_1, …, y_k$ telle que tout automate de valuations pour $Φ_k$, dans l'ordre $x_1, …, x_k, y_1, …, y_k$, possède au moins $2^k$ états.
    Peut-on toujours construire un automate de valuations de taille polynomiale en la taille de la formule ?
  ][
    On pose
    $ Φ_k = and.big_(i = 1)^k (x_i ↔ y_i). $
    Même en développant chaque équivalence $x_i ↔ y_i$ sous la forme $(x_i ∧ y_i) ∨ (¬ x_i ∧ ¬ y_i)$, chaque facteur est de taille constante, donc $Φ_k$ est de taille $Θ(k)$.

    Une valuation $v$ satisfait $Φ_k$ si et seulement si $v(x_i) = v(y_i)$ pour tout $i ∈ {1, …, k}$. Dans l'ordre $x_1, …, x_k, y_1, …, y_k$, le mot associé est $v(x_1) … v(x_k) v(y_1) … v(y_k)$, donc le langage des modèles de $Φ_k$ est exactement $L_k$.
    D'après la @q-automates-lk, tout automate de valuations pour $Φ_k$ dans cet ordre possède au moins $2^k$ états, ce qui est exponentiel en la taille de $Φ_k$.
    Il n'est donc pas toujours possible de construire un automate de valuations de taille polynomiale en la taille de la formule, même si le langage des modèles est toujours fini (et donc régulier).
  ]

  #question[
    On reprend la formule $Φ_k$ avec l'ordre $x_1, y_1, x_2, y_2, …, x_k, y_k$. Donner une expression régulière du langage des modèles, puis construire un automate déterministe (non nécessairement complet) à $O(k)$ états reconnaissant ce langage. Que peut-on en conclure sur le choix de l'ordre des variables ?
  ][
    Dans l'ordre $x_1, y_1, …, x_k, y_k$, une valuation satisfait $Φ_k$ si et seulement si chaque paire consécutive de bits est $00$ ou $11$. Le langage des modèles est donc décrit par l'expression régulière $(00 | 11)^k$ (concaténation de $k$ copies de $00 | 11$).

    Pour le reconnaître, on chaîne $k$ fois le motif suivant (pour $i = 1, …, k$), avec $q_0$ comme unique état initial et $q_k$ comme unique état final :
    #dessiner-automate(
      (
        ("q_(i - 1)", (0, 0), false, false),
        ("r_i^0", (2.5, 1), false, false),
        ("r_i^1", (2.5, -1), false, false),
        ("q_i", (5, 0), false, false),
      ),
      (
        ("q_(i - 1)", "r_i^0", "0", (:)),
        ("q_(i - 1)", "r_i^1", "1", (:)),
        ("r_i^0", "q_i", "0", (:)),
        ("r_i^1", "q_i", "1", (:)),
      ),
    )
    L'automate obtenu est déterministe, comporte $3k + 1$ états et $4k$ transitions (et le compléter ne coûte qu'un unique état puits supplémentaire, soit $3k + 2$ états).
    Le choix de l'ordre des variables est donc déterminant : pour une même formule, la taille minimale d'un automate de valuations peut passer d'exponentielle à linéaire. On observe le même phénomène pour les arbres de décision ordonnés (exercice II).
  ]
]
