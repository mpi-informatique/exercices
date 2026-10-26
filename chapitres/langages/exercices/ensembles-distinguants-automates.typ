#import "/load.typ": automate, exercice, partie, question, sep, widetilde
#import automate: style-automates, unite-automates
#import "@preview/finite:0.5.1" as finite
#import "@preview/cetz:0.4.2" as cetz

#let ex = exercice(
  meta: (
    titre: "Théorème de Myhill-Nerode",
    chapitres: ("automates-finis", "langages-reguliers"),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [
      Soit $Σ$ un alphabet et $L$ un langage sur $Σ$.

      Un mot $w ∈ Σ^*$ est un _suffixe distinguant_ pour $u, v ∈ Σ^*$ relativement à $L$ si exactement l'un des mots $u w$ et $v w$ appartient à $L$.
      Un ensemble $D ⊂ Σ^*$ est _distinguant_ pour $L$ si toute paire de mots distincts de $D$ possède un suffixe distinguant.
    ],
    partie("I", "Indice d'un langage", contenu: (
      question(
        [
          Sur $Σ = {a, b}$, on considère $L_1 = cal(L)((a b)^*)$.
          Montrer que ${ε, a, b}$ est un ensemble distinguant pour $L_1$ en donnant un suffixe distinguant pour chaque paire.
        ],
        solution: [
          Chaque case donne un suffixe distinguant pour les mots de sa ligne et de sa colonne.
          #align(center, table(
            columns: 3,
            align: center,
            stroke: none,
            inset: (x: 1em, y: 0.4em),
            [], [$ε$], [$a$],
            [$a$], table.cell(stroke: 0.5pt)[$b$], [],
            [$b$], table.cell(stroke: 0.5pt)[$ε$], table.cell(stroke: 0.5pt)[$b$],
          ))
          En effet, $ε, a b ∈ L_1$ tandis que $b, b b ∉ L_1$.
        ],
        label: <distinguants-exemple-ab>,
      ),
      question(
        [
          Soit $A = (Q, Σ, q_0, F, δ)$ un automate reconnaissant $L$.
          Montrer que deux mots conduisant au même état depuis $q_0$ n'ont aucun suffixe distinguant pour $L$.
          En déduire que si $L$ possède un ensemble distinguant de taille $n$ alors $"ind"(L) ≥ n$.
        ],
        solution: [
          Soient $u, v ∈ Σ^*$ tels que $δ^*(q_0, u) = δ^*(q_0, v)$.
          Pour tout $w ∈ Σ^*$,
          $ δ^*(q_0, u w) = δ^*(δ^*(q_0, u), w) = δ^*(δ^*(q_0, v), w) = δ^*(q_0, v w). $
          Les mots $u w$ et $v w$ sont donc tous les deux acceptés ou tous les deux rejetés.

          Si $D$ est distinguant, l'application $u ⟼ δ^*(q_0, u)$ est ainsi injective sur $D$.
          Tout automate reconnaissant $L$ possède donc au moins $abs(D)$ états.
          Si aucun automate ne reconnaît $L$, l'inégalité reste vraie avec la convention $"ind"(L) = ∞$.
        ],
        label: <distinguants-borne-etats>,
      ),
      question(
        [Déterminer $"ind"(L_1)$ en construisant un automate et en justifiant sa minimalité.],
        solution: [
          D'après la @distinguants-exemple-ab et la @distinguants-borne-etats, $"ind"(L_1) ≥ 3$.
          L'automate suivant reconnaît $L_1$ :
          #align(center, cetz.canvas(length: unite-automates, {
            import finite.draw: state, transition
            cetz.draw.set-style(..style-automates)
            state((0, 0), "0", label: $0$, initial: (label: none), final: true)
            state((3, 0), "1", label: $1$)
            state((0, -3), "2", label: $2$)
            transition("0", "1", label: $a$, curve: 0.5)
            transition("1", "0", label: (text: $b$, dist: -0.33), curve: 0)
            transition("0", "2", label: (text: $b$, dist: -0.33), curve: 0)
            transition("1", "2", label: $a$, curve: 0)
            transition("2", "2", label: $a, b$, anchor: bottom)
          }))
          Les mots de $L_1$ conduisent à l'état $0$, ceux de $cal(L)((a b)^* a)$ à l'état $1$, et tous les autres à l'état puits $2$.
          Ces derniers ne peuvent plus être complétés en un mot de $L_1$.
          Ainsi $"ind"(L_1) = 3$.
        ],
      ),
      question(
        [
          Sur $Σ = {a, b}$, soit $L_2$ le langage des mots contenant un nombre pair de $a$ et un nombre pair de $b$.
          Déterminer $"ind"(L_2)$ en construisant un automate et un ensemble distinguant de même taille.
        ],
        solution: [
          L'ensemble $D = {ε, a, b, a b}$ est distinguant : ses mots représentent les quatre couples de parités possibles.
          Si $u, v ∈ D$ sont distincts, le suffixe $u$ les distingue : dans $u u$, les nombres de $a$ et de $b$ sont pairs, tandis que dans $v u$, au moins l'un de ces nombres est impair.
          La @distinguants-borne-etats donne donc $"ind"(L_2) ≥ 4$.

          L'automate suivant mémorise les deux parités.
          Les états $0, 1, 2, 3$ représentent respectivement $(0, 0), (1, 0), (0, 1), (1, 1)$.
          #align(center, cetz.canvas(length: unite-automates, {
            import finite.draw: state, transition
            cetz.draw.set-style(..style-automates)
            state((0, 0), "0", label: $0$, initial: (label: none), final: true)
            state((3, 0), "1", label: $1$)
            state((0, -3), "2", label: $2$)
            state((3, -3), "3", label: $3$)
            transition("0", "1", label: $a$, curve: 0.5)
            transition("1", "0", label: (text: $a$, dist: -0.33), curve: 0)
            transition("2", "3", label: (text: $a$, dist: -0.33), curve: 0)
            transition("3", "2", label: $a$, curve: 0.5)
            transition("0", "2", label: (text: $b$, dist: -0.33), curve: 0)
            transition("2", "0", label: $b$, curve: 0.5)
            transition("1", "3", label: $b$, curve: 0.5)
            transition("3", "1", label: (text: $b$, dist: -0.33), curve: 0)
          }))
          Seul l'état $0$ est final, donc cet automate reconnaît $L_2$.
          Ainsi $"ind"(L_2) = 4$.
        ],
      ),
    )),
    partie("II", "Le théorème de Myhill-Nerode", contenu: (
      [
        On définit une relation sur $Σ^*$ par
        $ u scripts(≡)_L v ⟺ ∀ w ∈ Σ^*, #sep (u w ∈ L ⟺ v w ∈ L). $
        Ainsi $u scripts(≡)_L v$ signifie que $u$ et $v$ n'ont aucun suffixe distinguant pour $L$.
      ],
      question(
        [
          Montrer que $scripts(≡)_L$ est une relation d'équivalence et que, pour toute lettre $c ∈ Σ$, si $u scripts(≡)_L v$ alors $u c scripts(≡)_L v c$.
          On note $[u]$ la classe de $u$ et $Q_L$ l'ensemble des classes.
        ],
        solution: [
          La réflexivité et la symétrie sont immédiates.
          Si $u scripts(≡)_L v$ et $v scripts(≡)_L t$, alors, pour tout $w ∈ Σ^*$,
          $ u w ∈ L ⟺ v w ∈ L ⟺ t w ∈ L, $
          d'où $u scripts(≡)_L t$.
          La relation est donc une relation d'équivalence.

          Si $u scripts(≡)_L v$ et $c ∈ Σ$, nous pouvons appliquer la définition au suffixe $c w$, pour tout $w ∈ Σ^*$ :
          $ (u c) w ∈ L ⟺ u (c w) ∈ L ⟺ v (c w) ∈ L ⟺ (v c) w ∈ L. $
          Ainsi $u c scripts(≡)_L v c$.
        ],
        label: <distinguants-equivalence>,
      ),
      question(
        [
          On suppose que $Q_L$ est fini.
          Construire un automate reconnaissant $L$ dont l'ensemble des états est $Q_L$, de sorte que la lecture de tout mot $u$ depuis l'état initial conduise à $[u]$.
          Justifier que les transitions et les états finaux ne dépendent pas des représentants choisis.
          En déduire la valeur de $"ind"(L)$ en fonction de $abs(Q_L)$.
        ],
        solution: [
          Prenons l'automate $A_L = (Q_L, Σ, [ε], F_L, δ_L)$ défini par
          $ F_L = {[u] | u ∈ L} quad "et" quad δ_L ([u], c) = [u c]. $
          La @distinguants-equivalence garantit que $δ_L$ est bien définie : si $[u] = [v]$ alors $[u c] = [v c]$.
          En prenant le suffixe $ε$, nous obtenons aussi $u scripts(≡)_L v ==> (u ∈ L ⟺ v ∈ L)$.
          Une classe est donc entièrement contenue dans $L$ ou disjointe de $L$, ce qui justifie la définition de $F_L$.
          Comme $Q_L$ est fini, $A_L$ est bien un automate fini, déterministe et complet.

          Montrons par récurrence sur la taille de $u$ que $δ_L^* ([ε], u) = [u]$.
          C'est vrai pour $u = ε$.
          Si c'est vrai pour $u$ et si $c ∈ Σ$, alors
          $ δ_L^* ([ε], u c) = δ_L (δ_L^* ([ε], u), c) = δ_L ([u], c) = [u c]. $
          Ainsi $u$ est accepté si et seulement si $[u] ∈ F_L$, c'est-à-dire si et seulement si $u ∈ L$.
          L'automate $A_L$ reconnaît donc $L$ et possède $abs(Q_L)$ états.

          Choisissons un représentant dans chaque classe.
          Deux représentants de classes distinctes ont un suffixe distinguant par définition de $scripts(≡)_L$.
          Ces représentants forment donc un ensemble distinguant de taille $abs(Q_L)$.
          La @distinguants-borne-etats donne la borne inverse, d'où $"ind"(L) = abs(Q_L)$.
        ],
        label: <distinguants-automate-classes>,
      ),
      question(
        [
          Déduire des questions précédentes le _théorème de Myhill-Nerode_ : $L$ est régulier si et seulement si $Q_L$ est fini.
          Montrer aussi que $L$ n'est pas régulier si et seulement s'il possède un ensemble distinguant infini.
        ],
        solution: [
          Si $L$ est régulier, le théorème de Kleene assure qu'un automate déterministe complet à $n$ états le reconnaît.
          Si $Q_L$ avait plus de $n$ classes, nous pourrions choisir $n + 1$ représentants de classes distinctes.
          Ils formeraient un ensemble distinguant, en contradiction avec la @distinguants-borne-etats.
          Donc $Q_L$ est fini.

          Réciproquement, si $Q_L$ est fini, la @distinguants-automate-classes construit un automate reconnaissant $L$.
          Par le théorème de Kleene, $L$ est régulier.

          Si $L$ possède un ensemble distinguant infini, celui-ci contient des sous-ensembles distinguants de toute taille finie.
          La @distinguants-borne-etats exclut donc l'existence d'un automate fini reconnaissant $L$.
          Réciproquement, si $L$ n'est pas régulier, $Q_L$ est infini.
          Choisissons un représentant dans chaque classe : ils forment un ensemble distinguant infini.
        ],
        label: <distinguants-myhill-nerode>,
      ),
      question(
        [
          Sur $Σ = {a, b}$, trouver un ensemble distinguant infini pour $K = {a^n b^n | n ∈ NN}$.
          En déduire que $K$ n'est pas régulier.
        ],
        solution: [
          Prenons $D = {a^n | n ∈ NN}$.
          Si $i ≠ j$, le suffixe $b^i$ distingue $a^i$ et $a^j$ : $a^i b^i ∈ K$ tandis que $a^j b^i ∉ K$.
          Cela inclut le cas $i = 0$, pour lequel le suffixe est vide.
          L'ensemble $D$ est donc distinguant et infini.
          La @distinguants-myhill-nerode donne que $K$ n'est pas régulier.
        ],
      ),
    )),
    partie("III", "Distinguer par des préfixes et des contextes", contenu: (
      [
        Dans chacune des deux questions suivantes, $D ⊂ Σ^*$ est un ensemble infini.
        Pour un mot $u$, on note $widetilde(u)$ son miroir et $widetilde(L) = {widetilde(u) | u ∈ L}$.
        On rappelle que le miroir d'un langage régulier est régulier.
      ],
      question(
        [
          Montrer que $L$ n'est pas régulier si, pour tous mots distincts $u, v ∈ D$, il existe un _préfixe distinguant_ $x ∈ Σ^*$ tel qu'exactement l'un des mots $x u$ et $x v$ appartient à $L$.
        ],
        solution: [
          L'ensemble $widetilde(D) = {widetilde(u) | u ∈ D}$ est infini, car l'application miroir est bijective.
          Si $u, v ∈ D$ sont distincts, un préfixe distinguant $x$ pour $u$ et $v$ fournit un suffixe distinguant $widetilde(x)$ pour $widetilde(u)$ et $widetilde(v)$ relativement à $widetilde(L)$ :
          $ widetilde(x u) = widetilde(u) widetilde(x) quad "et" quad widetilde(x v) = widetilde(v) widetilde(x). $
          Donc $widetilde(D)$ est distinguant pour $widetilde(L)$.
          La @distinguants-myhill-nerode montre que $widetilde(L)$ n'est pas régulier.
          Si $L$ était régulier, $widetilde(L)$ le serait aussi, d'où une contradiction.
        ],
      ),
      question(
        [
          On suppose que, pour tous mots distincts $u, v ∈ D$, il existe $x, y ∈ Σ^*$ tels qu'exactement l'un des mots $x u y$ et $x v y$ appartient à $L$.
          Le couple $(x, y)$ est appelé _contexte distinguant_ pour $u$ et $v$.
          Les mots $x$ et $y$ peuvent être vides.
          Montrer que $L$ n'est pas régulier.

          _Indication :_ si $L$ était reconnu par un automate d'ensemble d'états $Q$, considérer, pour chaque mot $u$, la fonction $f_u : Q ⟶ Q$ définie par $f_u (q) = δ^*(q, u)$.
        ],
        solution: [
          Supposons qu'un automate $A = (Q, Σ, q_0, F, δ)$ à $n$ états reconnaisse $L$.
          Chaque mot $u$ induit une fonction $f_u : q ⟼ δ^*(q, u)$ de $Q$ dans $Q$.
          Il existe exactement $n^n$ fonctions de $Q$ dans $Q$, puisque chacun des $n$ états a $n$ images possibles.
          Comme $D$ est infini, le principe des tiroirs fournit deux mots distincts $u, v ∈ D$ tels que $f_u = f_v$.

          Pour tous $x, y ∈ Σ^*$, en posant $q = δ^*(q_0, x)$, nous obtenons
          $ δ^*(q_0, x u y) = δ^*(f_u (q), y) = δ^*(f_v (q), y) = δ^*(q_0, x v y). $
          Les deux mots $x u y$ et $x v y$ sont donc tous les deux acceptés ou tous les deux rejetés.
          Ils ne peuvent être distingués par aucun contexte, contrairement à l'hypothèse.
          Ainsi $L$ n'est pas régulier.

          Plus généralement, dans un langage reconnu par un automate à $n$ états, tout ensemble dont les mots sont deux à deux distinguables par des contextes contient au plus $n^n$ mots.
          Ici, mémoriser seulement l'état atteint depuis $q_0$ ne suffit pas : le préfixe $x$ peut conduire à n'importe quel état accessible avant la lecture de $u$ ou de $v$.
        ],
      ),
    )),
  ),
)
