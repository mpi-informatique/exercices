#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Mots qui commutent",
    chapitres: ("langages-reguliers",),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [On fixe un alphabet $Σ$. Tous les mots considérés sont des éléments de $Σ^*$.],
    question(
      [
        Soient $u$ et $v$ deux mots *non vides*.
        Montrer que les trois conditions suivantes sont équivalentes :
        #enum(numbering: "a)",
        [$u v = v u$],
        [Il existe un mot $w$ et des entiers $k, p in NN$ tels que $u = w^k$ et $v = w^p$.],
        [Il existe $m, n in NN^*$ tels que $u^m = v^n$.])
      ],
      solution: [
        *a) $==>$ b).* On raisonne par récurrence forte sur $abs(u) + abs(v)$.
        Si $abs(u) = abs(v)$, les premières lettres de $u v = v u$ donnent $u = v$. On prend $w = u$ et $k = p = 1$.
        Cela traite notamment le cas initial $abs(u) + abs(v) = 2$.

        Sinon, supposons $abs(u) < abs(v)$, l'autre cas étant symétrique.
        Comme $u v = v u$, le mot $u$ est préfixe de $v$ : il existe un mot non vide $v'$ tel que $v = u v'$.
        Ainsi $u^2 v' = u v' u$, puis $u v' = v' u$ par simplification du préfixe $u$.
        Comme $abs(u) + abs(v') < abs(u) + abs(v)$, l'hypothèse de récurrence donne $u = w^k$ et $v' = w^p$, avec $k, p >= 1$.
        Alors $v = w^(k + p)$.

        *b) $==>$ c).* Puisque $u$ et $v$ ne sont pas vides, $k, p >= 1$.
        Avec $m = p$ et $n = k$, on obtient $u^m = w^(k p) = v^n$.

        *c) $==>$ a).* Supposons $u^m = v^n$, avec $m, n >= 1$.
        Le mot $v$ est préfixe de $u^m$, donc $u v$ est préfixe de $u^(m + 1)$, puis de $u^(2 m)$ puisque $m + 1 <= 2 m$.
        De même, $v u$ est préfixe de $v^(2 n)$.
        Comme $u^(2 m) = v^(2 n)$, les mots $u v$ et $v u$ sont deux préfixes de même taille d'un même mot. Ils sont donc égaux.
      ],
    ),
    [
      Soit $u ∈ Σ^+$. On appelle _commutant_ de $u$ le langage $C(u) = {v ∈ Σ^* | u v = v u}.$
    ],
    question(
      [
        Montrer que $C(u)$ est un _sous-monoïde_ de $(Σ^*, ·)$, c'est-à-dire qu'il contient $ε$ et est stable par concaténation.
      ],
      solution: [
        Il est clair que $ε ∈ C(u)$. Si $v, w ∈ C(u)$, alors $u v w = v u w = v w u$, donc $v w ∈ C(u)$.
        Ainsi $C(u)$ est un sous-monoïde de $Σ^*$.
      ],
    ),
    question(
      [
        Montrer qu'il existe un unique mot non vide $r$ tel que $C(u) = r^*$.
      ],
      solution: [
        Comme $u ∈ C(u)$ et $u ≠ ε$, choisissons un mot non vide $r ∈ C(u)$ de taille minimale.
        Toutes ses puissances appartiennent à $C(u)$.
        Montrons réciproquement, par récurrence forte sur $abs(v)$, que tout $v ∈ C(u)$ est une puissance de $r$.
        C'est immédiat si $v = ε$.

        Soit $v ∈ C(u)$ non vide. Par minimalité, $abs(r) ≤ abs(v)$.
        Pour tout entier $N$, on a $u^N r = r u^N$ et $u^N v = v u^N$.
        En choisissant $N$ tel que $abs(u^N) ≥ abs(v)$, on voit que $r$ et $v$ sont des préfixes de $u^N$.
        Donc $r$ est préfixe de $v$ : écrivons $v = r t$.
        L'égalité $u v = v u$ donne $u r t = r t u$, puis $r u t = r t u$ puisque $u r = r u$.
        Par simplification, $u t = t u$, donc $t ∈ C(u)$.
        Comme $abs(t) < abs(v)$, l'hypothèse de récurrence donne $t = r^k$, puis $v = r^(k + 1)$.

        Enfin, si un mot non vide $s$ engendre aussi $C(u)$, il existe $a, b ≥ 1$ tels que $r = s^a$ et $s = r^b$.
        Les tailles donnent $abs(r) = a b abs(r)$, donc $a = b = 1$ et $r = s$.
      ],
    ),
  ),
)
