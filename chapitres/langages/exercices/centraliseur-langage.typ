#import "/load.typ": exercice, partie, question

#let ex = exercice(
  meta: (
    titre: "Centraliseur d'un langage",
    chapitres: ("langages-reguliers", "graphes", "algorithmique"),
    algorithmes: ("parcours-en-profondeur",),
    structures: ("graphe-oriente", "liste-adjacence"),
    langages: (),
    difficulte: 4,
    niveaux: ("MPI",),
  ),
  contenu: (
    [On fixe un alphabet fini non vide $Σ$. Tous les langages considérés sont des parties de $Σ^*$.],
    partie("I", "Propriétés du centraliseur", contenu: (
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
          Montrer que $Z(L)$ contient $ε$ et est stable par concaténation, puis comparer $L^*$ à $Z(L)$.
          Déterminer $Z(L)$ lorsque $L = ∅$ ou lorsque $ε ∈ L$.
        ],
        solution: [
          D'après la @langages-commutants-stabilite, l'union de tous les langages commutant avec $L$ commute avec $L$.
          Elle contient chacun de ces langages et constitue donc le plus grand d'entre eux, noté $Z(L)$.

          Le langage ${ε}$ commute avec $L$, donc $ε ∈ Z(L)$.
          Le produit $Z(L) Z(L)$ commute avec $L$, donc $Z(L) Z(L) ⊂ Z(L)$ par maximalité.
          Ainsi $Z(L)$ est un sous-monoïde.
          Comme $L$ commute avec lui-même, $L ⊂ Z(L)$, puis $L^* ⊂ Z(L)$.

          Si $L = ∅$, tout langage commute avec $L$, donc $Z(L) = Σ^*$.
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
      [
        Pour $u ∈ Σ^+$, on note $C(u) = {v ∈ Σ^* | u v = v u}$.
        On admet qu'il existe un unique mot non vide $r$ tel que $C(u) = r^*$.
      ],
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
      [
        Soit $Γ$ un alphabet fini non vide.
        Un _morphisme_ est une application $h : Σ^* → Γ^*$ telle que $h(ε) = ε$ et $h(u v) = h(u) h(v)$ pour tous mots $u, v$.
        Pour un langage $M$, on note $h(M) = {h(w) | w ∈ M}$.
      ],
      question(
        [
          Comparer $h(Z(L))$ et $Z(h(L))$.
          L'égalité est-elle toujours vérifiée, même lorsque $h$ envoie chaque lettre sur une lettre ?
        ],
        solution: [
          Comme $Z(L) L = L Z(L)$ et que $h$ respecte la concaténation,
          $ h(Z(L)) h(L) = h(Z(L) L) = h(L Z(L)) = h(L) h(Z(L)). $
          Ainsi $h(Z(L))$ commute avec $h(L)$, donc $h(Z(L)) ⊂ Z(h(L))$.

          L'inclusion peut être stricte. Prenons $Σ = {a, b}$, $Γ = {c}$, $L = {a b}$ et $h(a) = h(b) = c$.
          Le mot $a b$ n'est pas une puissance propre, donc $Z(L) = (a b)^*$ et $h(Z(L)) = (c c)^*$.
          Or $h(L) = {c c}$ et $Z(h(L)) = c^*$.
          Le mot $c$ appartient donc à $Z(h(L))$ mais pas à $h(Z(L))$.
        ],
      ),
    )),
    partie("II", "Tailles des mots et régularité", contenu: (
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
        label: <centraliseur-alphabet>,
      ),
      question(
        [
          Un langage commutant avec un langage régulier est-il nécessairement régulier ?
          On pourra considérer $K = union.big_(n ∈ NN) Σ^(n^2)$.
        ],
        solution: [
          Le langage $Σ$ est fini, donc régulier. D'après la @centraliseur-alphabet, $K$ commute avec $Σ$.
          Montrons pourtant que $K$ n'est pas régulier.

          Supposons le contraire et soit $p ≥ 1$ une constante du lemme de l'étoile.
          Fixons $a ∈ Σ$ et appliquons ce lemme au mot $a^(p^2) ∈ K$.
          Pour une décomposition $a^(p^2) = x y z$ vérifiant $1 ≤ abs(y) ≤ p$, le mot $x y^2 z$ devrait encore appartenir à $K$.
          Pourtant,
          $ p^2 < abs(x y^2 z) = p^2 + abs(y) ≤ p^2 + p < (p + 1)^2. $
          Sa taille n'est pas un carré, ce qui donne une contradiction.
          Ainsi un langage peut commuter avec un langage régulier sans être régulier.
          Cela concerne un langage commutant avec $Σ$, et non son centraliseur, qui vaut ici $Σ^*$.
        ],
      ),
    )),
    partie("III", "Décider l'appartenance au centraliseur par un graphe", contenu: (
      [
        On suppose désormais que $q = abs(Σ) ≥ 2$ et que $L ⊂ Σ^d$ est non vide, avec $d ≥ 1$.
        On pose $m = abs(L)$ et on fixe $n ∈ NN$.
      ],
      question(
        [
          Montrer que $Z(L) ∩ Σ^n$ commute avec $L$.
          En déduire que c'est le plus grand langage inclus dans $Σ^n$ qui commute avec $L$.
        ],
        solution: [
          Posons $X = Z(L) ∩ Σ^n$.
          Si $w ∈ X$ et $u ∈ L$, l'égalité $Z(L) L = L Z(L)$ donne $w u = v t$ avec $v ∈ L$ et $t ∈ Z(L)$.
          Comme $abs(u) = abs(v) = d$, on a $abs(t) = abs(w) = n$, donc $t ∈ X$.
          Ainsi $X L ⊂ L X$. La même comparaison des tailles dans une factorisation de $u w$ donne $L X ⊂ X L$.
          On en déduit $X L = L X$.

          Tout langage inclus dans $Σ^n$ et commutant avec $L$ est inclus dans $Z(L)$, donc dans $X$.
          Le langage $X$ est bien le plus grand d'entre eux.
        ],
        label: <centraliseur-taille-fixee>,
      ),
      [
        On construit un graphe orienté $G_n = (S_n, A_n)$, où $S_n = Σ^n ∪ {⊥}$ et $⊥$ est un symbole distinct des mots.
        Depuis chaque $w ∈ Σ^n$, pour chaque $u ∈ L$, on ajoute les arcs suivants :
        - On écrit $w u = v t$ avec $abs(v) = d$ et $abs(t) = n$. On ajoute $w → t$ si $v ∈ L$, et $w → ⊥$ sinon.
        - On écrit $u w = t v$ avec $abs(t) = n$ et $abs(v) = d$. On ajoute $w → t$ si $v ∈ L$, et $w → ⊥$ sinon.
        Le sommet $⊥$ n'a aucun arc sortant.
      ],
      question(
        [
          On note $S$ l'ensemble des mots de $Σ^n$ depuis lesquels il n'existe aucun chemin vers $⊥$.
          Montrer que $S$ commute avec $L$, puis comparer $S$ à $Z(L) ∩ Σ^n$.
          Déterminer cet ensemble pour $Σ = {a, b}$ et $L = {a b, b a}$, lorsque $n = 1$ puis lorsque $n = 2$.
        ],
        solution: [
          Si $w ∈ S$ et $u ∈ L$, aucun des arcs construits depuis $w$ ne peut aboutir à $⊥$.
          De plus, chacun de leurs sommets d'arrivée appartient encore à $S$, car un chemin vers $⊥$ depuis ce sommet fournirait un tel chemin depuis $w$.
          Les deux règles de construction donnent donc $w u ∈ L S$ et $u w ∈ S L$.
          Ainsi $S L ⊂ L S$ et $L S ⊂ S L$, d'où $S L = L S$.
          La @centraliseur-taille-fixee donne alors $S ⊂ Z(L) ∩ Σ^n$.

          Réciproquement, posons $X = Z(L) ∩ Σ^n$.
          Comme $X L = L X$, les factorisations des deux règles laissent toujours un mot dans $X$ et retirent un mot de $L$.
          En effet, les tailles imposées rendent chacune de ces factorisations unique.
          Tout arc issu d'un sommet de $X$ aboutit donc encore dans $X$.
          Aucun chemin issu de $X$ ne peut atteindre $⊥$, d'où $X ⊂ S$.
          Finalement, $S = Z(L) ∩ Σ^n$.

          Pour $L = {a b, b a}$ et $n = 1$, les concaténations $a (a b)$ et $b (b a)$ ont des préfixes de taille $2$ extérieurs à $L$.
          Les deux sommets $a$ et $b$ possèdent donc un arc vers $⊥$, d'où $S = ∅$.
          Pour $n = 2$, les mots $a a$ et $b b$ possèdent encore un arc vers $⊥$.
          En revanche, tous les arcs issus de $a b$ ou $b a$ aboutissent à l'un de ces deux mots.
          On obtient donc $S = {a b, b a}$.
        ],
        label: <centraliseur-accessibilite>,
      ),
      question(
        [
          Proposer un algorithme qui détermine $Z(L) ∩ Σ^n$ à partir de $G_n$ représenté par listes d'adjacence.
          Justifier sa complexité en fonction de $q, m, n$.
          En déduire un algorithme décidant, pour un mot $w$ donné, si $w ∈ Z(L)$.
          Donner aussi une borne du coût de construction de $G_n$ lorsque l'appartenance à $L$ est testée par comparaison avec chacun de ses mots.
        ],
        solution: [
          On construit le graphe transposé de $G_n$, puis on effectue un parcours en profondeur depuis $⊥$.
          Les sommets visités sont exactement ceux qui peuvent atteindre $⊥$ dans $G_n$.
          D'après la @centraliseur-accessibilite, les mots non visités forment $Z(L) ∩ Σ^n$.

          Le graphe possède $q^n + 1$ sommets et au plus $2 m q^n$ arcs.
          La transposition et le parcours coûtent donc $O(m q^n)$ en temps et en espace, une fois le graphe construit.
          Pour décider si $w ∈ Z(L)$, on prend $n = abs(w)$ et on teste si le sommet $w$ est visité.

          Pour construire le graphe, on énumère les $q^n$ mots de taille $n$.
          Après avoir numéroté les lettres de $0$ à $q - 1$, on identifie un mot de taille $n$ à l'entier décrit par ses lettres en base $q$.
          Pour chaque couple $(w, u)$, les concaténations, découpages et calculs des numéros des sommets coûtent $O(n + d)$.
          Chaque test d'appartenance à $L$ coûte $O(m d)$ par comparaisons directes.
          La construction coûte donc $O(m q^n (n + m d))$, qui borne aussi le coût total de cette méthode.
          Cet algorithme termine, mais sa borne est exponentielle en la taille du mot testé lorsque $q$ est fixé.
        ],
      ),
    )),
  ),
)
