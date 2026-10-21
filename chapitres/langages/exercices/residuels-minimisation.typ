#import "/load.typ": automate
#import automate: rayon-etat, rayon-grand-etat, style-automates, unite-automates
#import "/load.typ": exercice, question
#import "@preview/finite:0.5.1" as finite
#import "@preview/cetz:0.4.2" as cetz

#let ex = exercice(
  meta: (
    titre: "Résiduels et minimisation d'automate",
    chapitres: ("langages-reguliers", "automates-finis"),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [
      Si $u ∈ Σ^*$ et $L$ est un langage sur $Σ$, on appelle résiduel de $L$ par rapport à $u$ le langage $u^(-1)L$ tel que :
      $ u^(-1)L = {m ∈ Σ^* | u m ∈ L}. $
      Intuitivement, le résiduel de $L$ par rapport à $u$ est l'ensemble des mots
      avec lesquels on peut compléter $u$ pour obtenir un mot de $L$.
      L'ensemble des résiduels de $L$ est noté $cal(R)_L = {u^(-1)L | u ∈ Σ^*}$.
    ],
    question(
      [
        Si $L$ est un langage, quel est le résiduel de $L$ par rapport à $ε$ ?
      ],
      solution: [
        $ε^(-1)L = L$. En effet, si $m ∈ Σ^*$, $m ∈ ε^(-1)L ⟺ ε m = m ∈ L$.
      ],
    ),
    question(
      [
        Montrer que pour tout langage $L$ sur $Σ$ et tous mots $u,v ∈ Σ^*$, $u^(-1)(v^(-1)L) = (v u)^(-1)L$.
      ],
      solution: [
        Soient $L$ un langage et $u,v ∈ Σ^*$. Si $m ∈ Σ^*$, alors :
        $ m ∈ u^(-1)(v^(-1)L) ⟺ u m ∈ v^(-1)L ⟺ v u m ∈ L ⟺ m ∈ (v u)^(-1)L. $
      ],
    ),
    question(
      [
        #enum(
          numbering: "a)",
          [Soit $L_1 = (a|b)^* a b (a|b)^*$. Déterminer $(b a b)^(-1)L_1$ et $(a a a b a)^(-1)L_1$. Que constate-t-on ?],
          [Expliciter $cal(R)_(L_1)$.],
        )
      ],
      solution: [
        #enum(
          numbering: "a)",
          [Le langage $L_1$ est l'ensemble des mots contenant $a b$.
            Les deux mots proposés contiennent déjà le motif $a b$ : on peut donc les compléter par n'importe quel mot sur ${a,b}$ et rester dans $L_1$.
            On en déduit $(b a b)^(-1)L_1 = (a a a b a)^(-1)L_1 = (a|b)^*$.],
          [On a
            $
              u^(-1)L_1 = cases(
                (a|b)^* & "si " u ∈ L_1,
                L_1 ∪ b(a|b)^* & "si " u ∉ L_1 " et finit par un " a,
                L_1 & "si " u = ε " ou si " u ∉ L_1 " et finit par un " b.
              )
            $
            D'où $cal(R)_(L_1) = {(a|b)^*, L_1 ∪ b(a|b)^*, L_1}$.],
        )
      ],
    ),
    [On veut montrer qu'un langage $L$ est reconnaissable si et seulement s'il admet un nombre fini de résiduels.],
    question(
      [
        Soit $L$ un langage reconnaissable par un automate $A = (Σ,Q,q_0,F,δ)$ qu'on peut supposer déterministe, complet et dont tous les états sont accessibles sans perte de généralité.
        #enum(
          numbering: "a)",
          [Montrer que la fonction
            $
              φ: Q & → cal(R)_L \
                 q & ↦ u^(-1)L quad "où " δ^*(q_0,u) = q
            $
            est correctement définie : $u$ est l'un des mots qui permettent d'atteindre $q$ depuis $q_0$.],
          [Montrer que $L$ admet un nombre fini de résiduels.],
        )
      ],
      solution: [
        #enum(
          numbering: "a)",
          [Soit $q ∈ Q$. Comme $A$ est accessible, il existe un mot $u$ permettant d'atteindre $q$ depuis $q_0$. Le déterminisme de $A$ assure que $δ^*(q_0,u)$ est un seul état : $q$. Il existe donc bien un mot $u$ tel que $δ^*(q_0,u) = q$, ce qui permet de construire l'image de $q$ par $φ$.

            Il reste à montrer que cette image ne dépend pas du choix de $u$.
            Considérons deux mots $u,v$ tels que $δ^*(q_0,u) = δ^*(q_0,v)$.
            Pour tout $m ∈ Σ^*$,
            $
              m ∈ u^(-1)L & ⟺ u m ∈ L \
                          & ⟺ δ^*(q_0,u m) ∈ F \
                          & ⟺ δ^*(δ^*(q_0,u),m) ∈ F \
                          & ⟺ δ^*(δ^*(q_0,v),m) ∈ F \
                          & ⟺ δ^*(q_0,v m) ∈ F \
                          & ⟺ v m ∈ L ⟺ m ∈ v^(-1)L.
            $
            Ainsi $u^(-1)L = v^(-1)L$ : le résiduel associé à $q$ par $φ$ est indépendant du choix de $u$.],
          [Montrons que $φ$ est surjective. Soit $u^(-1)L$ un résiduel de $L$.
            Comme $A$ est complet, le mot $u$ peut être lu à partir de $q_0$ :
            il existe $q ∈ Q$ tel que $δ^*(q_0,u) = q$.
            En particulier, $u^(-1)L = φ(q)$.

            Ceci garantit que $abs(Q) ≥ abs(cal(R)_L)$.
            L'automate $A$ étant fini, le langage $L$ a un nombre fini de résiduels.],
        )
      ],
    ),
    question(
      [
        Soit à présent $L$ un langage ayant un nombre fini de résiduels.
        On définit alors un automate $M(L) = (Σ,Q,I,F,δ)$, appelé automate des résiduels associé à $L$, où :
        - $Q = cal(R)_L$
        - $I = {ε^(-1)L}$
        - $F = {u^(-1)L | u ∈ L}$
        - pour toute lettre $a ∈ Σ$ et tout résiduel $u^(-1)L ∈ Q$,
          $δ(u^(-1)L,a) = (u a)^(-1)L$

        #enum(
          numbering: "a)",
          [Montrer que la fonction $δ$ est correctement définie, c'est-à-dire que l'image donnée par $δ$ d'un résiduel $u^(-1)L$ ne dépend que du résiduel et pas de $u$.],
          [Montrer que $M(L)$ est un automate déterministe et complet.],
          [Montrer que $M(L)$ reconnaît le langage $L$.],
        )
      ],
      solution: [
        #enum(
          numbering: "a)",
          [Soient $u,v ∈ Σ^*$ tels que $u^(-1)L = v^(-1)L$, et $a ∈ Σ$.
            Pour tout $m ∈ Σ^*$, d'après la définition et la question 2,
            $
              m ∈ δ(u^(-1)L,a) & ⟺ m ∈ (u a)^(-1)L \
                               & ⟺ u a m ∈ L \
                               & ⟺ a m ∈ u^(-1)L \
                               & ⟺ a m ∈ v^(-1)L \
                               & ⟺ m ∈ a^(-1)(v^(-1)L) = δ(v^(-1)L,a).
            $
            Ces deux langages sont donc égaux. L'état atteint en lisant $a$ depuis le résiduel $u^(-1)L$ ne dépend que de ce résiduel, et non du choix de $u$.],
          [Par hypothèse, l'ensemble des résiduels de $L$, qui est aussi l'ensemble des états de $M(L)$, est fini. Donc $M(L)$ est un automate
            fini. Il est déterministe et complet par construction de sa fonction
            de transition et parce qu'il a un seul état initial.],
          [Procédons par double inclusion.

            Si $m ∈ L$, $δ^*(ε^(-1)L,m) = m^(-1)L$ en lisant le mot $m$ lettre à lettre et en utilisant la question 2.
            Or $m^(-1)L ∈ F$ puisque $m ∈ L$. Lire $m$ depuis l'état initial conduit donc à un état final : $m$ est reconnu par $M(L)$.

            Réciproquement, si $m$ est reconnu par $M(L)$, alors il existe $u ∈ L$
            tel que $m^(-1)L = δ^*(ε^(-1)L,m) = u^(-1)L$.
            Comme $u ∈ L$, $ε ∈ u^(-1)L$ ; on a donc aussi $ε ∈ m^(-1)L$, ce qui garantit que $m ∈ L$.],
        )
      ],
    ),
    question(
      [
        À l'aide des questions précédentes, déterminer l'automate des résiduels associé au langage $L_1$.
      ],
      solution: [
        Les états sont étiquetés par les représentants $ε$, $a$, $a b$ de leurs résiduels, respectivement $L_1$, $L_1 ∪ b(a|b)^*$ et $(a|b)^*$.
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
          transition("ab", "ab", label: $a,b$, anchor: top)
        }))
      ],
    ),
    [
      Un automate reconnaissant un langage $L$ est dit minimal s'il est
      déterministe, complet et possède le plus petit nombre d'états possible
      parmi les automates déterministes et complets reconnaissant $L$.
    ],
    question([Montrer que l'automate des résiduels est un automate minimal.], solution: [
      D'après la question 5, $M(L)$ est déterministe, complet et reconnaît $L$.
      Il possède exactement $abs(cal(R)_L)$ états.

      Soit $A$ un autre automate déterministe complet reconnaissant $L$.
      On peut supprimer ses états inaccessibles : les transitions issues d'un état accessible aboutissent à des états accessibles, donc l'automate obtenu reste complet et reconnaît $L$.
      La surjection construite à la question 4, de ses états accessibles vers $cal(R)_L$, montre qu'il possède au moins $abs(cal(R)_L)$ états.
      A fortiori, $A$ possède au moins autant d'états que $M(L)$.
      Ainsi $M(L)$ atteint le plus petit nombre d'états possible : il est minimal.
    ]),
    [
      On peut montrer que cet automate minimal est en fait unique (à renommage des états près), ce qui fournit une façon de déterminer si deux automates reconnaissent le même langage : il suffit de les minimiser et de comparer les deux automates obtenus (une autre méthode consistant à tester si $L_1 Δ L_2 = ∅$).
    ],
  ),
)
