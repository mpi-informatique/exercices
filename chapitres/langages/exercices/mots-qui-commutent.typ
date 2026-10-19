#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Mots et langages qui commutent",
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
        Montrer qu'il existe un unique mot non vide $r$ tel que $ C(u) = {r^k | k ∈ NN}. $
        En déduire que $C(u)$ est un langage régulier.
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

        Comme $C(u) = {r^k | k ∈ NN}$, il est dénoté par l'expression régulière $r^*$.
      ],
    ),
    [
      Deux langages $K, L ⊂ Σ^*$ _commutent_ si $K L = L K$.
    ],
    question(
      [
        La commutation de $K$ et $L$ impose-t-elle que tout mot de $K$ commute avec tout mot de $L$ ?
      ],
      solution: [
        Non. Sur $Σ = {a, b}$, les langages $K = L = {a, b}$ commutent, puisque $K = L$.
        Pourtant, $a ∈ K$ et $b ∈ L$ ne commutent pas : $a b ≠ b a$.
      ],
    ),
    question(
      [
        Soit $L ⊂ Σ^*$ et soit $(K_i)_(i ∈ I)$ une famille de langages commutant avec $L$.
        Leur union commute-t-elle avec $L$ ? Et le produit de deux langages commutant avec $L$ ?
      ],
      solution: [
        Par distributivité de la concaténation sur l'union,
        $ (union.big_(i ∈ I) K_i) L = union.big_(i ∈ I) (K_i L) = union.big_(i ∈ I) (L K_i) = L (union.big_(i ∈ I) K_i). $
        L'union commute donc avec $L$, y compris lorsque $I$ est vide.

        Si $K$ et $H$ commutent avec $L$, alors
        $ (K H) L = K (H L) = K (L H) = (K L) H = (L K) H = L (K H). $
        Leur produit commute donc aussi avec $L$.
      ],
      label: <langages-commutants-stabilite>,
    ),
    question(
      [
        Montrer qu'il existe un plus grand langage, pour l'inclusion, commutant avec un langage donné $L ⊂ Σ^*$.
        On l'appelle _centraliseur_ de $L$ et on le note $Z(L)$.
        Montrer que $Z(L)$ est un sous-monoïde de $Σ^*$ et comparer $L^*$ à $Z(L)$.
        Déterminer $Z(L)$ lorsque $ε ∈ L$.
      ],
      solution: [
        D'après la @langages-commutants-stabilite, l'union de tous les langages commutant avec $L$ commute avec $L$.
        Elle contient chacun de ces langages et constitue donc le plus grand d'entre eux, noté $Z(L)$.

        Le langage ${ε}$ commute avec $L$, donc $ε ∈ Z(L)$.
        Le produit $Z(L) Z(L)$ commute avec $L$, donc $Z(L) Z(L) ⊂ Z(L)$ par maximalité.
        Ainsi $Z(L)$ est un sous-monoïde.
        Comme $L$ commute avec lui-même, $L ⊂ Z(L)$, puis $L^* ⊂ Z(L)$.

        Si $ε ∈ L$, alors $Σ^* L = Σ^* = L Σ^*$, donc $Z(L) = Σ^*$.
      ],
    ),
    [
      Pour un langage $M$, on note $"Pref"(M)$ et $"Suf"(M)$ les ensembles de ses préfixes et de ses suffixes.
    ],
    question(
      [
        Soit $L ⊂ Σ^+$ un langage non vide.
        Comparer $Z(L)$ à $"Pref"(L^*)$ et à $"Suf"(L^*)$.
      ],
      solution: [
        Comme $Z(L)$ commute avec $L$, il commute avec $L^n$ pour tout $n ∈ NN$.
        Fixons $w ∈ Z(L)$, $u ∈ L$ et un entier $n > abs(w)$.
        L'appartenance $w u^n ∈ Z(L) L^n = L^n Z(L)$ fournit $v ∈ L^n$ et $t ∈ Z(L)$ tels que $w u^n = v t$.
        Les mots de $L$ étant non vides, $abs(v) ≥ n > abs(w)$.
        Ainsi $w$ est un préfixe de $v ∈ L^*$.

        De même, $u^n w ∈ L^n Z(L) = Z(L) L^n$ fournit $t' ∈ Z(L)$ et $v' ∈ L^n$ tels que $u^n w = t' v'$.
        Comme $abs(v') ≥ n > abs(w)$, le mot $w$ est un suffixe de $v' ∈ L^*$.
        Finalement,
        $ Z(L) ⊂ "Pref"(L^*) ∩ "Suf"(L^*). $
      ],
      label: <centraliseur-prefixes>,
    ),
    question(
      [
        Soit $u ∈ Σ^+$. Comparer $Z({u})$ et $C(u)$.
        En déduire une expression régulière du centraliseur d'un singleton.
      ],
      solution: [
        Tout mot de $C(u)$ commute avec $u$, donc $C(u) {u} = {u} C(u)$ et $C(u) ⊂ Z({u})$.

        Réciproquement, soit $w ∈ Z({u})$.
        Puisque $u ∈ Z({u})$ et que le centraliseur est un sous-monoïde, $w u$ et $u w$ appartiennent à $Z({u})$.
        D'après la @centraliseur-prefixes, ce sont donc des préfixes de puissances de $u$.
        Deux puissances de $u$ étant toujours préfixes d'une même puissance de $u$, les mots $w u$ et $u w$ sont deux préfixes de même taille d'un même mot.
        Ils sont donc égaux, d'où $w ∈ C(u)$.

        Ainsi $Z({u}) = C(u) = r^*$, où $r$ est l'unique mot non vide qui engendre $C(u)$.
      ],
    ),
    question(
      [
        On identifie $Σ$ au langage des mots de taille $1$.
        Caractériser les langages $K ⊂ Σ^*$ tels que $K Σ = Σ K$, à l'aide des tailles des mots qu'ils contiennent.
        En déduire $Z(Σ)$.
      ],
      solution: [
        Supposons $K Σ = Σ K$ et soit $w = a_1 ⋯ a_n ∈ K$, avec $n ≥ 1$.
        Pour toute lettre $b$, le mot $w b$ appartient à $K Σ = Σ K$.
        Son suffixe de taille $n$ appartient donc à $K$ : $a_2 ⋯ a_n b ∈ K$.
        En répétant cette opération avec les lettres d'un mot arbitraire $b_1 ⋯ b_n ∈ Σ^n$, on obtient $b_1 ⋯ b_n ∈ K$.
        Dès que $K$ contient un mot de taille $n$, il contient donc $Σ^n$.
        Cela vaut aussi pour $n = 0$, car $Σ^0 = {ε}$.

        Ainsi, en posant $E = {abs(w) | w ∈ K}$, on obtient
        $ K = union.big_(n ∈ E) Σ^n. $
        Réciproquement, pour tout $E ⊂ NN$, ce langage vérifie
        $ K Σ = union.big_(n ∈ E) Σ^(n + 1) = Σ K. $
        Les langages commutant avec $Σ$ sont donc exactement les unions de langages $Σ^n$.
        Le plus grand correspond à $E = NN$, d'où $Z(Σ) = Σ^*$.
      ],
    ),
  ),
)
