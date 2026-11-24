#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
    titre: "Double inclusion et ambiguïté d'une grammaire",
    chapitres: ("grammaires-non-contextuelles", "langages-reguliers"),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
)[
  On fixe l'alphabet $Σ = {a, b}$ et on considère la grammaire non-contextuelle $G = (Σ, {S}, R, S)$ définie par les règles :
  $ S ⟶ a S b ∣ a S b b ∣ ε. $

  #question[
    Donner tous les mots de $cal(L)(G)$ de taille au plus $4$, puis écrire une dérivation du mot $a^2 b^3$.
  ][
    Chaque application d'une règle récursive augmente la taille d'au moins $2$ (de $2$ pour $S ⟶ a S b$ et de $3$ pour $S ⟶ a S b b$).
    - Avec $0$ règle récursive, on obtient $ε$ (taille $0$).
    - Avec $1$ règle récursive, on obtient $a b$ (taille $2$) et $a b^2$ (taille $3$).
    - Avec $2$ règles récursives, seul $a^2 b^2$ a une taille au plus $4$.
    Les mots de $cal(L)(G)$ de taille au plus $4$ sont donc $ε$, $a b$, $a b^2$ et $a^2 b^2$.

    Une dérivation de $a^2 b^3$ est :
    $ S ⇒ a S b ⇒ a^2 S b^3 ⇒ a^2 b^3. $
  ]

  #question[
    Conjecturer le langage $cal(L)(G)$ en comparant les nombres d'occurrences de $a$ et de $b$.
  ][
    On conjecture que
    $ cal(L)(G) = L = {a^n b^m ∣ n, m ∈ NN, #sep n ≤ m ≤ 2 n}. $
  ]

  #question[
    Démontrer cette conjecture par double inclusion.
  ][
    *Inclusion $cal(L)(G) ⊂ L$.* Montrons par récurrence sur $k ≥ 1$ la propriété $H_k$ : « pour tout $w ∈ Σ^*$, si $S ⇒^k w$ alors $w ∈ L$ ».
    - Pour $k = 1$, la seule dérivation en une étape vers un mot de $Σ^*$ est $S ⇒ ε$, et $ε = a^0 b^0 ∈ L$.
    - Soit $k ≥ 1$ tel que $H_k$ soit vraie, et soit $w ∈ Σ^*$ tel que $S ⇒^(k + 1) w$. La première règle appliquée est soit $S ⟶ a S b$, soit $S ⟶ a S b b$.
      - Si c'est $S ⟶ a S b$, alors $w = a u b$ avec $u ∈ Σ^*$ et $S ⇒^k u$. Par $H_k$, il existe $n, m ∈ NN$ tels que $u = a^n b^m$ et $n ≤ m ≤ 2 n$. Alors $w = a^(n + 1) b^(m + 1)$ vérifie $n + 1 ≤ m + 1 ≤ 2 n + 1 ≤ 2 (n + 1)$, donc $w ∈ L$.
      - Si c'est $S ⟶ a S b b$, alors $w = a u b^2$ avec $u ∈ Σ^*$ et $S ⇒^k u$. Par $H_k$, $u = a^n b^m$ avec $n ≤ m ≤ 2 n$. Alors $w = a^(n + 1) b^(m + 2)$ vérifie $n + 1 ≤ m + 2 ≤ 2 (n + 1)$, donc $w ∈ L$.
    Par récurrence, $cal(L)(G) ⊂ L$.

    *Inclusion $L ⊂ cal(L)(G)$.* Montrons par récurrence sur $n ∈ NN$ la propriété $P_n$ : « pour tout $m ∈ NN$ tel que $n ≤ m ≤ 2 n$, on a $a^n b^m ∈ cal(L)(G)$ ».
    - Pour $n = 0$, on a nécessairement $m = 0$, et $S ⇒ ε = a^0 b^0 ∈ cal(L)(G)$.
    - Soit $n ∈ NN$ tel que $P_n$ soit vraie, et soit $m ∈ NN$ tel que $n + 1 ≤ m ≤ 2 (n + 1)$.
      - Si $m = n + 1$, alors $n ≤ m - 1 ≤ 2 n$. Par $P_n$, on a $S ⇒^* a^n b^(m - 1)$, d'où $S ⇒ a S b ⇒^* a^(n + 1) b^m$.
      - Si $m ≥ n + 2$, alors $n ≤ m - 2 ≤ 2 n$. Par $P_n$, on a $S ⇒^* a^n b^(m - 2)$, d'où $S ⇒ a S b b ⇒^* a^(n + 1) b^m$.
    Dans les deux cas, $a^(n + 1) b^m ∈ cal(L)(G)$. Par récurrence, $L ⊂ cal(L)(G)$, et finalement $cal(L)(G) = L$.
  ]

  #question[
    Montrer que $G$ est ambiguë, puis proposer une grammaire $G'$ faiblement équivalente à $G$ qui soit non ambiguë. Justifier la non-ambiguïté de $G'$.
  ][
    Le mot $a^2 b^3$ possède les deux dérivations gauches distinctes :
    $ S ⇒ a S b ⇒ a^2 S b^3 ⇒ a^2 b^3, quad S ⇒ a S b b ⇒ a^2 S b^3 ⇒ a^2 b^3. $
    Elles diffèrent dès la règle appliquée à la racine, donc $a^2 b^3$ admet deux arbres de dérivation distincts et $G$ est ambiguë.

    On propose la grammaire $G' = (Σ, {S, T}, R', S)$ définie par :
    $ S ⟶ a S b b ∣ T, #sep T ⟶ a T b ∣ ε. $
    Toute dérivation terminale depuis $S$ applique $k$ fois $S ⟶ a S b b$, puis $S ⟶ T$, puis $p$ fois $T ⟶ a T b$, et enfin $T ⟶ ε$, ce qui produit $a^(k + p) b^(2 k + p)$.

    Pour tout mot $a^n b^m ∈ L$, le système $k + p = n$ et $2 k + p = m$ admet l'unique solution $k = m - n$ et $p = 2 n - m$, qui sont deux entiers naturels car $n ≤ m ≤ 2 n$. Ainsi $cal(L)(G') = L$ et chaque mot de $L$ possède une unique dérivation gauche dans $G'$ : la grammaire $G'$ est donc non ambiguë.
  ]

  #question[
    Le langage $cal(L)(G)$ est-il régulier ? Peut-il être engendré par une grammaire régulière à droite ? Justifier.
  ][
    Supposons par l'absurde que $L$ soit régulier. Le lemme de l'étoile fournit un entier $p ≥ 1$. Le mot $w = a^p b^p ∈ L$ est de taille $2 p ≥ p$, donc il se décompose en $w = x y z$ avec $abs(x y) ≤ p$, $abs(y) ≥ 1$ et $x y^k z ∈ L$ pour tout $k ∈ NN$.

    Comme $abs(x y) ≤ p$, le facteur $y$ ne contient que des $a$ : il existe $t ≥ 1$ tel que $y = a^t$. Pour $k = 2$, on obtient $x y^2 z = a^(p + t) b^p$, qui n'appartient pas à $L$ car $p + t > p$. Contradiction.

    Le langage $L$ n'est donc pas régulier. Or un langage est régulier si et seulement s'il est engendré par une grammaire régulière à droite : $L$ ne peut donc pas être engendré par une telle grammaire.
  ]
]
