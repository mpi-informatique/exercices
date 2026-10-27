#import "/load.typ": automate, exercice, partie, question, sep, widetilde
#import automate: style-automates, unite-automates
#import "@preview/finite:0.5.1" as finite
#import "@preview/cetz:0.4.2" as cetz

#let introduction = [
  Soit $Σ$ un alphabet fini et $L ⊂ Σ^*$.
  Un _ADC_ est un automate déterministe complet, noté $A = (Q, Σ, q_0, F, δ)$.
  On rappelle qu'un langage est régulier si et seulement s'il est reconnu par un ADC.
  Pour les exemples, on fixe $Σ = {a, b}$ et $H = cal(L)((a | b)^* a b (a | b)^*)$.

  Un mot $w$ est un _suffixe distinguant_ pour $u$ et $v$ si exactement l'un des mots $u w$ et $v w$ appartient à $L$.
  Un ensemble $D ⊂ Σ^*$ est _distinguant_ pour $L$ si deux mots distincts de $D$ ont toujours un suffixe distinguant.
]

#let ensembles-distinguants = partie("I", "Ensembles distinguants", contenu: (
  question(
    [Montrer que ${ε, a, a b}$ est distinguant pour $H$ en donnant un suffixe distinguant pour chaque paire.],
    solution: [
      Chaque case donne un suffixe distinguant pour les mots de sa ligne et de sa colonne.
      #align(center, table(
        columns: 3,
        align: center,
        stroke: none,
        inset: (x: 1em, y: 0.4em),
        [], [$ε$], [$a$],
        [$a$], table.cell(stroke: 0.5pt)[$b$], [],
        [$a b$], table.cell(stroke: 0.5pt)[$ε$], table.cell(stroke: 0.5pt)[$ε$],
      ))
      En effet, $a b ∈ H$ tandis que $ε, a, b ∉ H$.
    ],
    label: <distinguants-exemple>,
  ),
  question(
    [
      Montrer que, dans un ADC reconnaissant $L$, deux mots conduisant au même état depuis $q_0$ n'ont aucun suffixe distinguant.
      En déduire une borne sur le nombre d'états à l'aide d'un ensemble distinguant fini, puis montrer que l'existence d'un ensemble distinguant infini entraîne que $L$ n'est pas régulier.
    ],
    solution: [
      Si $δ^*(q_0, u) = δ^*(q_0, v)$ alors, pour tout $w ∈ Σ^*$,
      $ δ^*(q_0, u w) = δ^*(δ^*(q_0, u), w) = δ^*(δ^*(q_0, v), w) = δ^*(q_0, v w). $
      Les mots $u w$ et $v w$ sont donc acceptés ou rejetés simultanément.
      Ainsi $u ⟼ δ^*(q_0, u)$ est injective sur tout ensemble distinguant $D$ et $abs(Q) ≥ abs(D)$.
      Si $D$ est infini, aucun ADC ne peut reconnaître $L$, donc $L$ n'est pas régulier.
    ],
    label: <distinguants-borne-etats>,
  ),
  question(
    [Trouver un ensemble distinguant infini pour $K = {a^n b^n | n ∈ NN}$ et en déduire que $K$ n'est pas régulier.],
    solution: [
      Prenons $D = {a^n | n ∈ NN}$.
      Si $i ≠ j$, le suffixe $b^i$ distingue $a^i$ et $a^j$ : $a^i b^i ∈ K$ tandis que $a^j b^i ∉ K$.
      L'ensemble $D$ est distinguant et infini, donc $K$ n'est pas régulier.
    ],
  ),
  [
    _Distinguer par des préfixes et des contextes._ Dans les deux questions suivantes, $D ⊂ Σ^*$ est infini.
    On note $widetilde(u)$ le miroir de $u$ et $widetilde(L) = {widetilde(u) | u ∈ L}$.
    On rappelle que le miroir d'un langage régulier est régulier.
  ],
  question(
    [
      On suppose que, pour tous mots distincts $u, v ∈ D$, il existe un _préfixe distinguant_ $x$ tel qu'exactement l'un des mots $x u$ et $x v$ appartient à $L$.
      Montrer que $L$ n'est pas régulier.
    ],
    solution: [
      Le miroir est une bijection, donc $widetilde(D)$ est infini.
      Comme $widetilde(x u) = widetilde(u) widetilde(x)$ et $widetilde(x v) = widetilde(v) widetilde(x)$, tout préfixe distinguant $x$ fournit un suffixe distinguant $widetilde(x)$ pour les mots miroirs.
      Ainsi $widetilde(D)$ est distinguant pour $widetilde(L)$, qui n'est donc pas régulier.
      Par stabilité des langages réguliers par miroir, $L$ n'est pas régulier.
    ],
  ),
  question(
    [
      On suppose que, pour tous mots distincts $u, v ∈ D$, il existe un _contexte distinguant_ $(x, y) ∈ (Σ^*)^2$ tel qu'exactement l'un des mots $x u y$ et $x v y$ appartient à $L$.
      Montrer que $L$ n'est pas régulier.

      _Indication :_ dans un ADC à $n$ états, combien de fonctions distinctes $f_u : q ⟼ δ^*(q, u)$ les mots peuvent-ils induire ?
    ],
    solution: [
      Supposons qu'un ADC à $n$ états reconnaisse $L$.
      Il n'existe que $n^n$ fonctions de $Q$ dans $Q$.
      Comme $D$ est infini, deux mots distincts $u, v ∈ D$ induisent la même fonction $f_u = f_v$.
      Pour tous $x, y ∈ Σ^*$, en posant $q = δ^*(q_0, x)$,
      $ δ^*(q_0, x u y) = δ^*(f_u(q), y) = δ^*(f_v(q), y) = δ^*(q_0, x v y). $
      Aucun contexte ne distingue donc $u$ et $v$, d'où une contradiction.
      Plus généralement, tout ensemble dont les mots sont deux à deux distinguables par des contextes possède au plus $n^n$ éléments.
    ],
  ),
))

#let residuels = partie("II", "Résiduels et théorème de Myhill-Nerode", contenu: (
  [
    Le _résiduel_ de $L$ par un mot $u$ est le langage $u^(-1)L = {w ∈ Σ^* | u w ∈ L}$ des continuations acceptées après $u$.
    On note $cal(R)_L = {u^(-1)L | u ∈ Σ^*}$ l'ensemble des résiduels de $L$.
  ],
  question(
    [
      Calculer $ε^(-1)L$ et exprimer $v^(-1)(u^(-1)L)$ comme un résiduel de $L$.
      Déterminer tous les résiduels de $H$, en distinguant les mots contenant déjà $a b$, ceux qui se terminent par $a$, et les autres.
    ],
    solution: [
      Par définition, $ε^(-1)L = L$ et
      $ w ∈ v^(-1)(u^(-1)L) ⟺ v w ∈ u^(-1)L ⟺ u v w ∈ L, $
      donc $v^(-1)(u^(-1)L) = (u v)^(-1)L$.

      Si $u$ contient $a b$, toute continuation convient, donc $u^(-1)H = Σ^*$.
      Sinon, si $u$ se termine par $a$, il suffit que la continuation contienne $a b$ ou commence par $b$, donc $u^(-1)H = H ∪ b Σ^*$.
      Dans les autres cas, $u^(-1)H = H$.
      Ces trois résiduels sont distincts et atteints respectivement pour $u = a b, a, ε$.
    ],
    label: <residuels-calcul>,
  ),
  question(
    [
      On définit $u scripts(≡)_L v$ par $u^(-1)L = v^(-1)L$.
      Montrer que $scripts(≡)_L$ est une relation d'équivalence, appelée _congruence de Nerode_, stable par concaténation à droite :
      $ u scripts(≡)_L v ==> ∀ t ∈ Σ^*, #sep u t scripts(≡)_L v t. $
      Relier cette relation aux suffixes distinguants.
      En déduire une bijection entre ses classes et les résiduels, puis caractériser les ensembles distinguants à l'aide de ces classes.
    ],
    solution: [
      L'égalité des résiduels est réflexive, symétrique et transitive.
      Si $u^(-1)L = v^(-1)L$ alors $(u t)^(-1)L = t^(-1)(u^(-1)L) = t^(-1)(v^(-1)L) = (v t)^(-1)L$.
      C'est donc une congruence à droite.
      De plus,
      $ u scripts(≡)_L v ⟺ ∀ w ∈ Σ^*, #sep (u w ∈ L ⟺ v w ∈ L), $
      c'est-à-dire que $u$ et $v$ n'ont aucun suffixe distinguant.
      L'application $[u] ⟼ u^(-1)L$ est une bijection des classes vers $cal(R)_L$.
      Un ensemble est distinguant si et seulement s'il contient au plus un mot de chaque classe.
    ],
    label: <residuels-nerode>,
  ),
  question(
    [
      On suppose $cal(R)_L$ fini.
      Construire un ADC $M_L$ d'ensemble d'états $cal(R)_L$ tel que la lecture de tout mot $u$ depuis l'état initial conduise à $u^(-1)L$.
      Préciser l'état initial, les états finaux et les transitions, puis montrer que $M_L$ est accessible et reconnaît $L$.
    ],
    solution: [
      On prend $L$ pour état initial, $F_L = {R ∈ cal(R)_L | ε ∈ R}$ et $δ_L(R, c) = c^(-1)R$ pour $c ∈ Σ$.
      La @residuels-calcul donne $δ_L(u^(-1)L, c) = (u c)^(-1)L$.
      La transition ne dépend donc que du résiduel et son image appartient à $cal(R)_L$.
      L'ensemble des états est fini et $δ_L$ est une application de $cal(R)_L × Σ$ dans $cal(R)_L$ : $M_L$ est un ADC.

      Par récurrence sur la taille de $u$, $δ_L^*(L, u) = u^(-1)L$.
      Tout résiduel est donc accessible.
      Enfin, $u$ est accepté si et seulement si $ε ∈ u^(-1)L$, c'est-à-dire si et seulement si $u ∈ L$.
    ],
    label: <residuels-automate>,
  ),
  question(
    [Dessiner $M_H$ et donner un ensemble distinguant certifiant qu'aucun ADC reconnaissant $H$ n'a moins d'états.],
    solution: [
      Les états $ε, a, a b$ représentent les résiduels $H$, $H ∪ b Σ^*$ et $Σ^*$.
      #align(center, cetz.canvas(length: unite-automates, {
        import finite.draw: state, transition
        cetz.draw.set-style(..style-automates)
        state((0, 0), "vide", label: $ε$, initial: (label: none))
        state((3, 0), "a", label: $a$)
        state((6, 0), "ab", label: $a b$, final: true)
        transition("vide", "vide", label: $b$, anchor: top)
        transition("vide", "a", label: $a$, curve: 0)
        transition("a", "a", label: $a$, anchor: top)
        transition("a", "ab", label: $b$, curve: 0)
        transition("ab", "ab", label: $a, b$, anchor: top)
      }))
      L'ensemble ${ε, a, a b}$ est distinguant : $b$ distingue $ε$ de $a$, et $ε$ distingue $a b$ des deux autres mots.
      Ces mots conduisent nécessairement à trois états distincts dans tout ADC reconnaissant $H$.
      Ainsi $M_H$ possède le nombre minimal d'états, soit trois.
    ],
  ),
  question(
    [
      Soit $A = (Q, Σ, q_0, F, δ)$ un ADC accessible reconnaissant $L$.
      Montrer que $φ : δ^*(q_0, u) ⟼ u^(-1)L$ est bien définie et surjective.
      Vérifier qu'elle préserve l'état initial, les transitions et l'appartenance aux états finaux.

      Un ADC reconnaissant $L$ est _minimal_ s'il a le moins d'états possible parmi les ADC reconnaissant $L$.
      En déduire la minimalité de $M_L$, puis l'unicité de l'ADC minimal à renommage des états près.
    ],
    solution: [
      Le résiduel $u^(-1)L$ est exactement le langage accepté depuis $δ^*(q_0, u)$, donc ne dépend que de cet état.
      L'accessibilité définit $φ$ sur tout $Q$, et chaque résiduel a un antécédent.
      Pour $q = δ^*(q_0, u)$ et $c ∈ Σ$,
      $ φ(q_0) = L, quad φ(δ(q, c)) = (u c)^(-1)L = δ_L(φ(q), c), $
      et $q ∈ F ⟺ u ∈ L ⟺ ε ∈ φ(q) ⟺ φ(q) ∈ F_L$.

      La surjectivité donne $abs(Q) ≥ abs(cal(R)_L)$.
      Supprimer les états inaccessibles d'un ADC conserve son langage et sa complétude, car les transitions issues d'états accessibles restent dans cet ensemble.
      Cette borne vaut donc pour tout ADC reconnaissant $L$, et $M_L$ l'atteint : il est minimal.

      Tout ADC minimal est accessible, sinon on pourrait supprimer un état.
      Il a exactement $abs(cal(R)_L)$ états, donc $φ$ est bijective.
      Comme elle préserve l'état initial, les transitions et les états finaux, elle donne un renommage transformant cet ADC en $M_L$.
      Deux ADC minimaux reconnaissant $L$ sont ainsi isomorphes.
    ],
    label: <residuels-minimalite>,
  ),
  question(
    [
      Établir le _théorème de Myhill-Nerode_ : les propriétés suivantes sont équivalentes.
      - $L$ est régulier
      - $L$ possède un nombre fini de résiduels
      - la congruence de Nerode a un nombre fini de classes

      Pour $L$ régulier, relier le nombre d'états de l'ADC minimal à la taille maximale d'un ensemble distinguant.
      Montrer enfin que tout langage non régulier possède un ensemble distinguant infini.
    ],
    solution: [
      Si $L$ est régulier, un ADC le reconnaît et la surjection précédente montre que $cal(R)_L$ est fini.
      Réciproquement, si $cal(R)_L$ est fini, $M_L$ est un ADC reconnaissant $L$, donc $L$ est régulier.
      L'équivalence avec la finitude du nombre de classes résulte de la bijection de la @residuels-nerode.

      Un ensemble distinguant contient au plus un mot par classe.
      En choisissant un représentant dans chaque classe, on obtient un ensemble distinguant de taille $abs(cal(R)_L)$, qui est aussi le nombre d'états de l'ADC minimal.
      Si $L$ n'est pas régulier, il y a une infinité de classes.
      Le choix d'un représentant par classe fournit donc un ensemble distinguant infini.
    ],
    label: <residuels-myhill-nerode>,
  ),
))

#let ex = exercice(
  meta: (
    titre: "Ensembles distinguants, résiduels et minimisation",
    chapitres: ("automates-finis", "langages-reguliers"),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (introduction, ensembles-distinguants, residuels),
)
