#import "/load.typ": automate, exercice, question
#import automate: dessiner-automate

#let exemple() = dessiner-automate(
  (
    ("q_0", (0, 0), true, false),
    ("q_1", (5, 0), false, false),
    ("q_2", (2.5, -2.5), false, false),
  ),
  (
    ("q_0", "q_0", "a, γ_0, α γ_0", (anchor: top)),
    ("q_0", "q_0", "a, α, α α", (anchor: bottom)),
    ("q_0", "q_1", "b, α, ε", (:)),
    ("q_1", "q_1", "b, α, ε", (anchor: top)),
    ("q_0", "q_2", "ε, γ_0, ε", (label: (dist: 0.8))),
    ("q_1", "q_2", "ε, γ_0, ε", (label: (dist: -0.8))),
  ),
)

#let ex = exercice(
  meta: (
      titre: "Automates à pile",
      chapitres: ("grammaires-non-contextuelles", "automates-finis"),
      structures: ("pile",),
      difficulte: 3,
      niveaux: ("MPI",),
      duree: (1, 0),
    ),
  corrections: [
      Création à partir de l'exercice automate_pile de la banque LaTeX et du DM associé.
      La définition commence par le quadruplet $(Q, q_0, γ_0, δ)$, avec acceptation par pile vide, puis introduit l'acceptation par état final.
      Un automate fourni permet de commencer par des calculs concrets.
      Les symboles auxiliaires de pile sont notés en lettres grecques minuscules.
      Après la construction d'un automate pour les mots bien parenthésés à deux types de parenthèses, une question établit l'équivalence des deux modes d'acceptation. Le déterminisme n'est pas abordé.
      Seul le sens grammaire vers automate est démontré, sans hypothèse de forme normale de Chomsky. La réciproque est admise.
      L'équivalence avec les grammaires est appliquée à la stabilité par intersection avec un langage régulier, en utilisant l'acceptation par état final.
      Difficulté et durée estimées : 3 sur 5 et une heure.
    ],
  (
      block(breakable: false)[
        Soient $Σ$ et $Γ$ deux alphabets finis.
        Un #emph[automate à pile] sur $Σ$, d'alphabet de pile $Γ$, est un quadruplet $A = (Q, q_0, γ_0, δ)$, où :
        - $Q$ est un ensemble fini d'états.
        - $q_0 ∈ Q$ est l'état initial et $γ_0 ∈ Γ$ le symbole de pile initial.
        - $δ : Q × (Σ ∪ {ε}) × Γ ⟶ cal(P)(Q × Γ^*)$ est la fonction de transition, dont chaque valeur est un ensemble fini.

        $A$ dispose d'une pile de taille non bornée.
        Une #emph[configuration] est un couple $(q, z)$, où $q$ est l'état courant et $z ∈ Γ^*$ le contenu de la pile, écrit avec le haut de la pile (le _sommet_) à gauche.
        La configuration initiale est $(q_0, γ_0)$.

        Une transition $p limits(⟶)^(a, γ, β) q$ signifie que $(q, β) ∈ δ(p, a, γ)$.
        Elle lit $a$ et remplace le sommet $γ$ par le mot $β$ : elle fait passer de $(p, γ z)$ à $(q, β z)$.
        Aucune transition n'est possible si la pile est vide.

        Un mot est #emph[accepté par pile vide] s'il existe un chemin qui lit toutes ses lettres dans l'ordre et termine avec une pile vide. C'est le mode d'acceptation utilisé dans les trois premières questions.

        On considère l'automate $A_1$ suivant sur $Σ = {a, b}$, avec $Γ = {γ_0, α}$.
        #exemple()
      ],
      question[
          Donner un calcul acceptant pour $a a b b$ en indiquant les configurations successives.
          Les mots $a b a b$ et $ε$ sont-ils acceptés ?
        ][
          Pour $a a b b$, on obtient
          $
            (q_0, γ_0) limits(⟶)^a (q_0, α γ_0) limits(⟶)^a (q_0, α α γ_0)
            limits(⟶)^b (q_1, α γ_0) limits(⟶)^b (q_1, γ_0) limits(⟶)^ε (q_2, ε).
          $
          Le mot $a b a b$ est refusé : après $a b$, on est en $(q_1, γ_0)$ et aucune transition ne permet de lire le $a$ suivant.
          Vider alors la pile ne suffit pas, car il reste des lettres à lire.
          Le mot $ε$ est accepté par $(q_0, γ_0) limits(⟶)^ε (q_2, ε)$.
        ],
      question[
          Déterminer $L(A_1)$ et donner une grammaire qui engendre ce langage.
        ][
          Le langage reconnu est $L = {a^n b^n | n ∈ ℕ}$.
          Après $n$ lettres $a$, la configuration est $(q_0, α^n γ_0)$.
          Si $n ≥ 1$, le premier $b$ fait passer en $q_1$, où seules des lettres $b$ peuvent être lues.
          Chaque $b$ dépile un $α$. La pile ne peut être vidée qu'après exactement $n$ lettres $b$.
          Tout calcul acceptant lit donc un mot de $L$, y compris $ε$ par le passage direct de $q_0$ à $q_2$.

          Réciproquement, pour tout $n ≥ 1$, on peut lire $n$ lettres $a$, puis $n$ lettres $b$, puis dépiler $γ_0$.
          Le cas $n = 0$ a été traité à la question précédente.

          $L$ est aussi engendré par la grammaire
          $S → a S b ∣ ε$.
        ],
      question[
          On note $D$ le langage des mots bien parenthésés avec deux types de parenthèses : `(`, `)` et `[`, `]`.
          Par exemple, `([])[]` appartient à $D$, mais `([)]` n'y appartient pas.\
          Construire un automate à pile reconnaissant $D$ et donner une grammaire qui engendre $D$.
        ][
          #block(breakable: false)[
            On prend $Γ = {γ_0, α, β}$ et l'automate suivant, où $γ$ désigne un symbole quelconque de $Γ$ :
            #dessiner-automate(
              (
                ("q_0", (0, 0), true, false),
                ("q_1", (4, 0), false, false),
              ),
              (
                ("q_0", "q_0", "\"(\", γ, α γ \\ \"[\", γ, β γ", (anchor: top, label: (dist: 0.85))),
                ("q_0", "q_0", "\")\", α, ε \\ \"]\", β, ε", (anchor: bottom, label: (dist: 0.85))),
                ("q_0", "q_1", "ε, γ_0, ε", (:)),
              ),
            )
          ]

          En $q_0$, la pile contient, au-dessus de $γ_0$, les types des parenthèses ouvertes non encore refermées, dans l'ordre inverse de leur apparition.
          Une parenthèse fermante ne peut être lue que si elle correspond à la dernière parenthèse ouverte.
          Le passage en $q_1$ vide la pile lorsque toutes les parenthèses ont été refermées. Un mot accepté appartient donc à $D$.

          Réciproquement, tout mot de $D$ peut être lu en conservant cet invariant, puis on dépile $γ_0$.
          En particulier, $ε$ est accepté par le passage direct en $q_1$.

          Une grammaire qui engendre $D$ est $S → "(" S ")" S ∣ "[" S "]" S ∣ ε$.
        ],
      [
        On peut aussi munir un automate à pile d'un ensemble d'états finaux $F ⊂ Q$ : il est alors décrit par $(Q, q_0, γ_0, δ, F)$.
        Un mot est #emph[accepté par état final] s'il existe un chemin qui lit toutes ses lettres et termine dans un état de $F$, quel que soit le contenu de la pile.
      ],
      question[
          Montrer que tout langage reconnu par pile vide peut être reconnu par état final, et réciproquement.
        ][
          Dans les deux sens, on ajoute un symbole de pile $ζ ∉ Γ$ et un nouvel état initial $i$.
          La pile initiale contient $ζ$, et la transition $i limits(⟶)^(ε, ζ, γ_0 ζ) q_0$ initialise la simulation de l'automate donné.
          On conserve ses transitions : le symbole $ζ$ reste sous la pile simulée.

          - _De pile vide vers état final._ On ajoute un unique état final $f$, sans transition sortante, et, depuis tout état $q$ de l'automate donné, la transition $q limits(⟶)^(ε, ζ, ζ) f$.
            On peut ainsi atteindre $f$ exactement lorsque la pile simulée est vide. Le langage reconnu est donc inchangé.
          - _D'état final vers pile vide._ On ajoute un état $v$.
            Depuis chaque ancien état final et pour tout $γ ∈ Γ ∪ {ζ}$, on ajoute une transition étiquetée $ε, γ, γ$ vers $v$.
            En $v$, les seules transitions sont les boucles étiquetées $ε, γ, ε$, qui vident la pile sans lire de lettre.
            Un calcul acceptant doit donc avoir lu tout le mot avant d'entrer en $v$, depuis un ancien état final. Réciproquement, tout calcul acceptant de l'ancien automate peut être prolongé par ce vidage.
        ],
      question[
          Soit $G = (Σ, V, R, S)$ une grammaire non-contextuelle.
          Construire un automate à pile à un seul état qui reconnaît $cal(L)(G)$ par pile vide.
        ][
          On prend un seul état $q$, l'alphabet de pile $Γ = Σ ∪ V$, le symbole de pile initial $S$ et les boucles suivantes :
          - pour chaque règle $γ → β$, une transition étiquetée $ε, γ, β$
          - pour chaque terminal $a ∈ Σ$, une transition étiquetée $a, a, ε$

          La première sorte de transition applique une règle au sommet de la pile sans lire de lettre.
          La seconde lit une lettre lorsqu'elle coïncide avec le sommet, puis la dépile.
          L'ordre des symboles de $β$ est conservé, puisque le sommet est à gauche.

          Si le préfixe $u$ a été lu et si la pile contient $z$, on a $S ⇒^* u z$.
          Cette propriété est vraie initialement et conservée par les deux sortes de transitions.
          Si un mot $w$ est accepté, la pile finale est vide, donc $S ⇒^* w$.

          Réciproquement, soit $w ∈ cal(L)(G)$ et choisissons une dérivation gauche de $w$.
          On la simule en appliquant les règles au sommet et en lisant les terminaux dès qu'ils arrivent au sommet.
          Après lecture de tout $w$, la pile est vide. Le mot est donc accepté.
        ],
      [
        On admet réciproquement que tout langage reconnu par un automate à pile est non-contextuel.
        Les automates à pile, avec acceptation par pile vide ou par état final, et les grammaires non-contextuelles définissent donc la même classe de langages.
      ],
      question[
          Soient $L$ un langage non-contextuel et $R$ un langage régulier sur le même alphabet.
          En utilisant l'équivalence précédente, montrer que $L ∩ R$ est non-contextuel.
        ][
          Soient $A$ un automate à pile reconnaissant $L$ par état final et $B$ un automate fini reconnaissant $R$.
          On construit un automate à pile dont les états sont des couples $(q, p)$ d'états de $A$ et de $B$.
          Son état initial est le couple des états initiaux, et sa pile initiale est celle de $A$.
          Chaque transition simule une transition de $A$ et fait avancer $B$ sur la même lettre. Si $A$ ne lit aucune lettre, l'état de $B$ reste inchangé.

          Les états finaux sont les couples dont les deux composantes sont finales.
          Un mot est ainsi accepté exactement lorsqu'il est accepté par $A$ et par $B$.
          Cet automate reconnaît donc $L ∩ R$, qui est non-contextuel par l'équivalence précédente.
        ],
    ),
)
