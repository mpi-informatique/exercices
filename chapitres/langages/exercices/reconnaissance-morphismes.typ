#import "/load.typ": exercice, partie, question, sep

#let ex = exercice(
  meta: (
    titre: "Reconnaître un langage par un morphisme",
    chapitres: ("langages-reguliers", "automates-finis", "recursivite-et-induction"),
    difficulte: 3,
    niveaux: ("MPI",),
    duree: (2, 0),
  ),
  contenu: (
    [
      On fixe des alphabets finis non vides $Σ$ et $Γ$.
      Un _monoïde_ est un ensemble $M$ muni d'une opération associative, notée $·$, et d'un élément neutre $1_M$.
      Un _morphisme de monoïdes_ $h : M → N$ vérifie $h(1_M) = 1_N$ et $h(x · y) = h(x) · h(y)$.
      L'ensemble $Σ^*$, muni de la concaténation et du mot vide $ε$, est un monoïde.

      Un morphisme $h : Σ^* → M$ _reconnaît_ un langage $L ⊂ Σ^*$ s'il existe une partie $P ⊂ M$ telle que
      $ L = h^(-1)(P) = {u ∈ Σ^* | h(u) ∈ P}. $
      On dit alors que $M$ reconnaît $L$. Le monoïde $M$ n'est supposé fini que lorsque cela est précisé.

      L'objectif est de comprendre comment l'élément $h(u)$ peut résumer un mot, puis de montrer qu'un langage est reconnu par un monoïde fini si et seulement s'il est reconnu par un automate fini.
      Les notions algébriques utilisées sont rappelées ici. On pourra utiliser le théorème de Kleene.
    ],
    partie("I", "Un résumé compatible avec la concaténation", contenu: (
      question(
        [
          Montrer que toute application $Σ → M$ se prolonge de manière unique en un morphisme $Σ^* → M$.
          Expliquer comment calculer le résumé d'une concaténation de deux mots sans relire leurs lettres.
        ],
        solution: [
          Pour une application $f : Σ → M$, on pose $h(ε) = 1_M$ et
          $ h(a_1 … a_n) = f(a_1) · … · f(a_n). $
          L'associativité permet de regrouper les facteurs correspondant à deux mots $u$ et $v$, donc $h(u v) = h(u) · h(v)$.
          Réciproquement, tout prolongement morphique doit vérifier cette formule, d'où son unicité.
          Connaître $h(u)$ et $h(v)$ suffit à obtenir $h(u v)$ par un seul produit dans $M$.
        ],
        label: <morphismes-prolongement>,
      ),
      question(
        [
          Pour un morphisme $h : Σ^* → M$ et un langage $L$, montrer l'équivalence des propriétés suivantes :
          #enum(
            numbering: "a)",
            [$h$ reconnaît $L$],
            [pour tous mots $u, v$, si $h(u) = h(v)$ alors $u ∈ L ⟺ v ∈ L$],
            [$L = h^(-1)(h(L))$],
          )
          Interpréter b) en termes d'information conservée sur le mot.
          Si $h$ n'est pas surjectif, la partie $P$ de la définition est-elle nécessairement unique ?
        ],
        solution: [
          a) implique b) car l'appartenance de $u$ à $h^(-1)(P)$ dépend seulement de $h(u)$.
          Supposons b). L'inclusion $L ⊂ h^(-1)(h(L))$ est toujours vraie.
          Si $u ∈ h^(-1)(h(L))$, il existe $v ∈ L$ tel que $h(u) = h(v)$. Par b), $u ∈ L$, ce qui prouve c).
          Enfin c) implique a) en prenant $P = h(L)$.

          Le résumé $h(u)$ conserve toute l'information nécessaire pour décider si $u$ appartient à $L$. Il n'a pas à permettre de retrouver $u$.
          Les valeurs de $P$ hors de $h(Σ^*)$ ne jouent aucun rôle : on peut les ajouter ou les enlever.
          La partie $P$ n'est donc pas unique si $h$ n'est pas surjectif, mais sa trace sur $h(Σ^*)$ est nécessairement $h(L)$.
        ],
        label: <morphismes-resume>,
      ),
      question(
        [
          On prend $Σ = {a, b}$ et on note $abs(u)_a$ le nombre d'occurrences de $a$ dans $u$.
          Reconnaître chacun des langages suivants par un morphisme vers un monoïde fini. Préciser le produit, le neutre, les images de $a$ et $b$ et la partie $P$ :
          #enum(
            numbering: "a)",
            [${u | abs(u)_a ≡ 0 mod 3}$],
            [${u | u " contient au moins un " a}$],
          )
          Dans chaque cas, indiquer si $ε$ est accepté et expliquer pourquoi le morphisme n'a pas besoin d'être injectif.
        ],
        solution: [
          a) Prendre $M = ZZ / 3 ZZ$ avec l'addition, de neutre $0$, et $h(a) = 1$, $h(b) = 0$.
          Le prolongement vérifie $h(u) = abs(u)_a mod 3$. La partie acceptante est $P = {0}$ et $ε$ est accepté.

          b) Prendre $M = {0, 1}$ avec l'opération $max$, de neutre $0$, et $h(a) = 1$, $h(b) = 0$.
          Alors $h(u) = 1$ si et seulement si $u$ contient un $a$. On prend $P = {1}$ et $ε$ est refusé.

          Dans les deux exemples, $h(ε) = h(b)$ alors que $ε ≠ b$. Ces mots ont simplement le même statut d'acceptation.
        ],
      ),
      question(
        [
          Peut-on inverser le sens du morphisme et décrire des langages comme images de parties d'un monoïde fini ?
          Montrer que tout morphisme $g : M → Σ^*$, avec $M$ fini, vérifie $g(M) = {ε}$.
          Quelles images $g(P)$ peut-on alors obtenir ?
        ],
        solution: [
          Pour $m ∈ M$, la suite $1_M, m, m^2, …$ prend ses valeurs dans un ensemble fini.
          Il existe donc $0 ≤ i < j$ tels que $m^i = m^j$, d'où $g(m)^i = g(m)^j$.
          En comparant les tailles, $i abs(g(m)) = j abs(g(m))$, donc $g(m) = ε$.
          Le monoïde contient $1_M$, donc son image est exactement ${ε}$.
          Selon que $P$ est vide ou non, $g(P)$ vaut $∅$ ou ${ε}$.
          Ce sens du morphisme ne peut donc pas représenter les langages recherchés.
        ],
      ),
    )),
    partie("II", "Morphismes et automates finis", contenu: (
      question(
        [
          Soient $M$ un monoïde fini, $h : Σ^* → M$ un morphisme et $P ⊂ M$.
          Construire un ADC d'ensemble d'états $M$ qui reconnaît $h^(-1)(P)$.
          Justifier la construction en décrivant l'état atteint après lecture d'un mot $u$.
        ],
        solution: [
          Prendre l'état initial $1_M$, l'ensemble d'états finaux $P$ et $δ(m, a) = m · h(a)$.
          Cette transition est définie pour tout $(m, a) ∈ M × Σ$, donc l'automate est déterministe complet et fini.
          Par récurrence sur la taille de $u$, l'état atteint depuis $1_M$ est $h(u)$ : c'est vrai pour $ε$, puis
          $ δ(h(u), a) = h(u) · h(a) = h(u a). $
          Le mot $u$ est donc accepté si et seulement si $h(u) ∈ P$.
        ],
        label: <morphismes-vers-automates>,
      ),
      [
        Réciproquement, on considère un ADC $A = (Q, Σ, q_0, F, δ)$.
        On note $δ^*$ sa transition étendue aux mots, et $t_u : Q → Q$ la transformation $q ⟼ δ^*(q, u)$.
      ],
      question(
        [
          Exprimer $t_ε$ et $t_(u v)$ en fonction de $t_u$ et $t_v$.
          Définir un produit $·$ sur les transformations de $Q$ tel que $u ⟼ t_u$ soit un morphisme.
          Montrer que $T = {t_u | u ∈ Σ^*}$ est un monoïde fini pour ce produit et majorer sa taille en fonction de $n = abs(Q)$.
        ],
        solution: [
          On a $t_ε = "id"_Q$ et, pour tout $q ∈ Q$,
          $ t_(u v)(q) = δ^*(δ^*(q, u), v) = t_v(t_u(q)). $
          Ainsi $t_(u v) = t_v ∘ t_u$. On définit donc $f · g = g ∘ f$ : on applique d'abord $f$, puis $g$.
          Ce produit est associatif et son neutre est $"id"_Q$.
          L'ensemble $T$ contient le neutre et est stable par produit, puisque $t_u · t_v = t_(u v)$.
          Il est donc un monoïde et l'application $u ⟼ t_u$ est un morphisme.
          Il existe $n^n$ applications de $Q$ dans $Q$, donc $abs(T) ≤ n^n$.
        ],
        label: <morphismes-transitions>,
      ),
      question(
        [
          Déterminer une partie $P ⊂ T$ telle que le morphisme $u ⟼ t_u$ reconnaisse $cal(L)(A)$.
          Conclure qu'un langage est reconnu par un monoïde fini si et seulement s'il est reconnaissable, puis si et seulement s'il est régulier.
        ],
        solution: [
          Prendre $P = {t ∈ T | t(q_0) ∈ F}$.
          En effet, $u ∈ cal(L)(A) ⟺ δ^*(q_0, u) ∈ F ⟺ t_u ∈ P$.
          Tout langage reconnaissable possède un ADC, dont le monoïde $T$ reconnaît le langage.
          La construction de #ref(<morphismes-vers-automates>, supplement: [la question]) donne la réciproque.
          Le théorème de Kleene fournit enfin l'équivalence avec la régularité.
        ],
      ),
    )),
    partie("III", "Résumer un préfixe ou un facteur", contenu: (
      [
        On fixe $Σ = {a, b}$ et $H = Σ^* a$, le langage des mots se terminant par $a$.
        On considère l'ADC à deux états $Q = {0, 1}$, d'état initial $0$, de seul état final $1$ et de transition $δ(q, a) = 1$, $δ(q, b) = 0$ pour tout $q ∈ Q$.
      ],
      question(
        [
          Les mots $ε$ et $b$ conduisent au même état depuis l'état initial. Existe-t-il un préfixe $x$ tel que $x ε$ et $x b$ aient des statuts d'acceptation différents ?
          En déduire qu'il n'existe pas de produit de monoïde sur $Q$ rendant $u ⟼ δ^*(0, u)$ morphique.
          Expliquer pourquoi on a conservé toute la transformation $t_u$ dans la partie II.
        ],
        solution: [
          Prendre $x = a$ : $a ε = a ∈ H$, mais $a b ∉ H$.
          Si $s(u) = δ^*(0, u)$ était un morphisme pour un produit sur $Q$, l'égalité $s(ε) = s(b)$ donnerait
          $ s(a ε) = s(a) · s(ε) = s(a) · s(b) = s(a b), $
          alors que ces états sont respectivement $1$ et $0$. C'est impossible.
          L'état atteint depuis $0$ résume un préfixe déjà lu. La transformation $t_u$ décrit l'effet de $u$ depuis chaque état possible, donc aussi lorsque $u$ est placé après un préfixe quelconque.
        ],
      ),
      question(
        [
          Calculer le monoïde de transitions de cet ADC et dresser sa table de multiplication, avec la convention de #ref(<morphismes-transitions>, supplement: [la question]).
          Préciser la partie acceptante.
          Montrer qu'aucun monoïde à moins de trois éléments ne reconnaît $H$, bien qu'un ADC à deux états suffise.
        ],
        solution: [
          Posons $I = "id"_Q$, $C_0(q) = 0$ et $C_1(q) = 1$.
          Le mot vide induit $I$, tout mot non vide se terminant par $b$ induit $C_0$, et tout mot se terminant par $a$ induit $C_1$.
          Ces trois transformations sont distinctes. Avec $f · g = g ∘ f$, on obtient :
          #align(center, table(
            columns: 4,
            align: center,
            inset: (x: 1em, y: 0.3em),
            table.header([$·$], [$I$], [$C_0$], [$C_1$]),
            [$I$], [$I$], [$C_0$], [$C_1$],
            [$C_0$], [$C_0$], [$C_0$], [$C_1$],
            [$C_1$], [$C_1$], [$C_0$], [$C_1$],
          ))
          La partie acceptante est ${C_1}$.

          Soit $h$ un morphisme reconnaissant $H$. Le mot $a$ est accepté tandis que $ε$ et $b$ sont refusés, donc $h(a)$ diffère de $h(ε)$ et de $h(b)$ d'après #ref(<morphismes-resume>, supplement: [la question]).
          Enfin, $h(ε) = h(b)$ entraînerait $h(a) = h(a b)$, alors que $a ∈ H$ et $a b ∉ H$.
          Les trois images de $ε$, $a$ et $b$ sont donc distinctes, ce qui impose au moins trois éléments.
        ],
      ),
      question(
        [
          Un monoïde est _commutatif_ si $m · n = n · m$ pour tous $m, n$.
          Montrer que $H$ n'est reconnu par aucun monoïde commutatif.
          Quelle information un morphisme vers un monoïde commutatif perd-il nécessairement sur les lettres d'un mot ?
        ],
        solution: [
          Si $h$ prend ses valeurs dans un monoïde commutatif, alors $h(a b) = h(a) · h(b) = h(b) · h(a) = h(b a)$.
          Or $b a ∈ H$ et $a b ∉ H$, ce qui contredit #ref(<morphismes-resume>, supplement: [la question]).
          Plus généralement, le produit des images des lettres ne dépend plus de leur ordre : deux mots ayant les mêmes nombres d'occurrences de chaque lettre ont la même image.
          Cela convenait pour les deux exemples de la partie I, mais pas pour tester la dernière lettre.
        ],
      ),
    )),
    partie("IV", "Conséquences et limites", contenu: (
      question(
        [
          Soit $h : Σ^* → M$ un morphisme reconnaissant $L$.
          Montrer que si $h(u) = h(v)$ alors, pour tous mots $x, y$, on a $x u y ∈ L ⟺ x v y ∈ L$.
          Utiliser ce résultat pour montrer que $K = {a^n b^n | n ∈ NN}$ n'est reconnu par aucun monoïde fini.
          Est-il reconnu par un monoïde infini ?
        ],
        solution: [
          L'égalité $h(u) = h(v)$ entraîne $h(x u y) = h(x) · h(u) · h(y) = h(x) · h(v) · h(y) = h(x v y)$.
          #ref(<morphismes-resume>, supplement: [La question]) donne l'équivalence d'appartenance.

          Si un monoïde fini reconnaissait $K$, deux mots $a^i$ et $a^j$, avec $i < j$, auraient la même image.
          On pourrait alors leur ajouter le même suffixe $b^i$, mais $a^i b^i ∈ K$ et $a^j b^i ∉ K$ : contradiction.
          En revanche, l'identité $Σ^* → Σ^*$ reconnaît $K$ en prenant $P = K$.
          Elle reconnaît de cette manière tout langage. La finitude du monoïde d'arrivée est donc essentielle dans la caractérisation de la partie II.
        ],
      ),
      question(
        [
          Retrouver par les morphismes la stabilité des langages reconnaissables par complémentaire, intersection et union.
          Pour combiner deux morphismes $h_1 : Σ^* → M_1$ et $h_2 : Σ^* → M_2$, on pourra munir $M_1 × M_2$ d'un produit composante par composante.
        ],
        solution: [
          Si $L = h^(-1)(P)$ avec $M$ fini, son complémentaire est $h^(-1)(M ∖ P)$.
          Pour $L_i = h_i^(-1)(P_i)$, le produit $(m_1, m_2) · (n_1, n_2) = (m_1 · n_1, m_2 · n_2)$ fait de $M_1 × M_2$ un monoïde fini de neutre $(1_(M_1), 1_(M_2))$.
          L'application $h(u) = (h_1(u), h_2(u))$ est un morphisme.
          Elle reconnaît $L_1 ∩ L_2$ avec $P_1 × P_2$, et $L_1 ∪ L_2$ avec $(P_1 × M_2) ∪ (M_1 × P_2)$.
          La caractérisation de la partie II permet de conclure à la reconnaissabilité.
        ],
      ),
      question(
        [
          Soit $g : Γ^* → Σ^*$ un morphisme de mots, qui peut envoyer une lettre sur un mot quelconque, éventuellement $ε$.
          #enum(
            numbering: "a)",
            [Montrer que si $L ⊂ Σ^*$ est reconnu par un monoïde fini alors $g^(-1)(L)$ l'est aussi.],
            [Montrer que si $R ⊂ Γ^*$ est régulier alors $g(R)$ est régulier. On pourra transformer une expression régulière décrivant $R$.],
          )
          Préciser le rôle de l'image réciproque dans a) et de l'image directe dans b).
        ],
        solution: [
          a) Écrivons $L = h^(-1)(P)$, où $h : Σ^* → M$ est un morphisme vers un monoïde fini.
          La composée $h ∘ g : Γ^* → M$ est un morphisme et
          $ g^(-1)(L) = (h ∘ g)^(-1)(P). $
          On reconnaît donc les mots dont l'image par $g$ appartient à $L$, sans changer de monoïde fini.

          b) Si $R = cal(L)(r)$, remplacer chaque lettre $c$ de $r$ par une expression décrivant le mot $g(c)$, avec $ε$ lorsque ce mot est vide.
          Une induction structurelle justifie que l'expression obtenue décrit $g(R)$ : les cas $∅$, $ε$ et d'une lettre sont immédiats, puis on utilise
          $ g(U ∪ V) = g(U) ∪ g(V), #sep g(U V) = g(U) g(V), #sep g(U^*) = g(U)^*. $
          Ici, on produit des mots de $Σ^*$ à partir des mots de $R$. Il s'agit d'une image directe par un morphisme entre monoïdes de mots, dont la source est infinie : cela ne contredit pas la dernière question de la partie I.
        ],
      ),
    )),
  ),
)
