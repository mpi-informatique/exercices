#import "/load.typ": automate
#import automate: rayon-etat, rayon-grand-etat, style-automates, unite-automates
#import "/load.typ": exercice, question
#import "@preview/finite:0.5.1" as finite
#import "@preview/cetz:0.4.2" as cetz

#let ex = exercice(
  meta: (
    titre: "Sujet 0 CCINP",
    chapitres: ("langages-reguliers", "automates-finis"),
    algorithmes: ("determinisation",),
    difficulte: 2,
    niveaux: ("MPI",),
    concours: (nom: "CCINP", annee: 2022, filiere: "MPI", oral: true),
  ),
  contenu: (
    question([Rappeler la définition d'un langage régulier.], solution: [
      Sur un alphabet $Σ$, les langages réguliers forment la plus petite famille contenant les langages finis et stable par union, concaténation et étoile de Kleende.
    ]),
    question(
      [
        Les langages suivants sont-ils réguliers ?
        Justifier.
        #grid(
          columns: 2,
          column-gutter: 1em,
          align: top,
          [#enum(numbering: "(a)", [$L_1 = {a^n b a^m | n,m ∈ NN}$], [$L_2 = {a^n b a^m | n,m ∈ NN, n ≤ m}$])],
          [#enum(
            start: 3,
            numbering: "(a)",
            [$L_3 = {a^n b a^m | n,m ∈ NN, n > m}$],
            [$L_4 = {a^n b a^m | n,m ∈ NN, n+m ≡ 0 thin (mod 2)}$],
          )],
        )
      ],
      solution: [
        #enum(
          numbering: "(a)",
          [$L_1$ est régulier : il est dénoté par $a^* b a^*$.],
          [Supposons $L_2$ régulier.
            Par le théorème de Kleene, il est reconnaissable par un automate à $n ≥ 1$ états.
            Soit $m=a^n b a^n ∈ L_2$ ; on a $abs(m)=2n+1 ≥ n$.
            Soit $m=x y z$ la décomposition donnée par le lemme de l'étoile : $abs(x y) ≤ n$, $y ≠ ε$ et $x y^* z ⊂ L_2$.
            Comme les $n$ premières lettres de $m$ sont des $a$, on a $y=a^r$ pour un entier $r ≥ 1$.
            Pour $k=2$, on obtient
            $ x y^2 z=a^(n+r) b a^n ∉ L_2, $
            puisque $n+r>n$.
            C'est absurde : $L_2$ n'est pas reconnaissable, donc n'est pas régulier.],
          [On a $L_2=L_1 ∖ L_3$.
            Si $L_3$ était régulier, la stabilité des langages réguliers par complément et intersection rendrait $L_2$ régulier, puisque $L_1$ l'est.
            Donc $L_3$ n'est pas régulier.],
          [La somme $n+m$ est paire si et seulement si $n$ et $m$ ont la même parité.
            Ainsi $L_4$ est régulier, dénoté par
            $ (a a)^* b (a a)^* | a(a a)^* b a(a a)^*. $],
        )
      ],
    ),
    question(
      [
        On considère l'automate non déterministe suivant :
        #align(center, cetz.canvas(length: unite-automates, {
          import finite.draw: state, transition
          cetz.draw.set-style(..style-automates)
          state((0, -0.8), "s0", label: $0$, initial: (label: none))
          state((0, 3), "s1", label: $1$, final: true)
          state((-4, -3), "s2", label: $2$, initial: (label: none))
          state((4, -3), "s3", label: $3$, final: true)
          transition("s0", "s1", label: $a$, curve: 0)
          transition("s0", "s2", label: (text: $ε$, dist: -0.33), curve: 0)
          transition("s2", "s1", label: (text: $a$, dist: -0.33), curve: 0)
          transition("s2", "s3", label: (text: $b$, dist: -0.33), curve: 0)
          transition("s1", "s3", label: $b$, curve: 0.4)
          transition("s3", "s1", label: (text: $a$, dist: -0.33), curve: 0.4)
          transition("s3", "s0", label: $ε$, curve: 0)
        }))
        #enum(
          numbering: "(a)",
          [Déterminiser cet automate.],
          [Construire une expression régulière dénotant le langage reconnu par cet automate.],
          [Décrire simplement avec des mots le langage reconnu par cet automate.],
        )
      ],
      solution: [
        #enum(
          numbering: "(a)",
          [Avant la première lecture et après chaque lettre lue, on ajoute tous les états accessibles par zéro, une ou plusieurs $ε$-transitions, qui se franchissent sans lire de lettre.
            #align(center, cetz.canvas(length: unite-automates, {
              import finite.draw: state, transition
              cetz.draw.set-style(..style-automates)
              state((0, 0), "0,2", label: ${0,2}$, radius: rayon-grand-etat, initial: (label: none))
              state((4, 0), "1", label: ${1}$, radius: rayon-grand-etat, final: true)
              state((0, -3), "0,2,3", label: ${0,2,3}$, radius: rayon-grand-etat, final: true)
              state((4, -3), "∅", label: $∅$, radius: rayon-grand-etat)
              transition("0,2", "1", label: $a$, curve: 0)
              transition("0,2", "0,2,3", label: $b$, curve: 0)
              transition("1", "∅", label: $a$, curve: 0)
              transition("1", "0,2,3", label: $b$, curve: 0.5)
              transition("0,2,3", "1", label: $a$, curve: 0.5)
              transition("0,2,3", "0,2,3", label: $b$, anchor: bottom)
              transition("∅", "∅", label: $a,b$, anchor: bottom)
            }))],
          [Une expression régulière est
            $ a | (b | a b)(b | a b)^*(ε | a). $
            Depuis ${0,2}$ ou ${0,2,3}$, la lecture de $b$ ou de $a b$ mène à ${0,2,3}$.
            Après au moins un de ces blocs, on peut s'arrêter dans ${0,2,3}$ ou lire un dernier $a$ pour atteindre ${1}$.
            Le mot $a$ est accepté directement depuis ${0,2}$.
            Ce sont tous les chemins acceptants : depuis ${1}$, seule la lettre $b$ permet d'éviter le puits $∅$.],
          [Le langage reconnu est l'ensemble des mots non vides sur ${a,b}$ ne contenant pas deux $a$ consécutifs.
            En effet, après un $a$, on se trouve dans ${1}$ ; un autre $a$ mène au puits.
            Toute lecture sans facteur $a a$ reste dans ${1}$ ou ${0,2,3}$ dès la première lettre, et est donc acceptée.
            Le mot vide est rejeté puisque ${0,2}$ n'est pas final.],
        )
      ],
    ),
  ),
)
