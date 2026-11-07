#import "/load.typ": exercice, question
#import "/load.typ": sep
#import "@preview/cetz:0.4.2" as cetz

// Deux parenthésages de b a b a b, avec tous les terminaux des arbres d'analyse.
#let arbres = align(center, grid(
  columns: (1fr, 1fr),
  column-gutter: 1cm,
  cetz.canvas({
    import cetz.draw: content, line
    let positions = (
      (0, 0),
      (-1.5, -1),
      (0, -1),
      (1.5, -1),
      (-2.5, -2),
      (-1.5, -2),
      (-0.5, -2),
      (-2.5, -3),
      (-0.5, -3),
      (1.5, -3),
    )
    let labels = ($S$, $S$, $a$, $S$, $S$, $a$, $S$, $b$, $b$, $b$)
    // Relier les bords des étiquettes, en gardant une marge autour du texte.
    for (i, p) in positions.enumerate() {
      content(p, labels.at(i), name: "n" + str(i), padding: 2pt)
    }
    for (p, f) in ((0, 1), (0, 2), (0, 3), (1, 4), (1, 5), (1, 6), (4, 7), (6, 8), (3, 9)) {
      line("n" + str(p) + ".south", "n" + str(f) + ".north")
    }
  }),
  cetz.canvas({
    import cetz.draw: content, line
    let positions = (
      (0, 0),
      (-1.5, -1),
      (0, -1),
      (1.5, -1),
      (0.5, -2),
      (1.5, -2),
      (2.5, -2),
      (-1.5, -3),
      (0.5, -3),
      (2.5, -3),
    )
    let labels = ($S$, $S$, $a$, $S$, $S$, $a$, $S$, $b$, $b$, $b$)
    // Relier les bords des étiquettes, en gardant une marge autour du texte.
    for (i, p) in positions.enumerate() {
      content(p, labels.at(i), name: "n" + str(i), padding: 2pt)
    }
    for (p, f) in ((0, 1), (0, 2), (0, 3), (3, 4), (3, 5), (3, 6), (1, 7), (4, 8), (6, 9)) {
      line("n" + str(p) + ".south", "n" + str(f) + ".north")
    }
  }),
))

#let ex = exercice(
  meta: (
      titre: "Ambiguïté et langages réguliers",
      chapitres: ("grammaires-non-contextuelles", "langages-reguliers", "automates-finis"),
      difficulte: 3,
      niveaux: ("MPI",),
      concours: (nom: "CCINP", annee: 2023),
    ),
  corrections: [
      - Question 4 : justifier l'unicité par les choix de règles, et non par la seule présence d'au plus une variable.
      - Question 5 : utiliser le même nom de variable dans toutes les règles de la construction.
    ],
)[
  On considère la grammaire non-contextuelle $G$ sur $Σ = {a,b}$, donnée par $S → S a S ∣ b$.

  #question[Cette grammaire est-elle ambiguë ? Justifier.][
        Oui : le mot $b a b a b$ possède les deux arbres d'analyse distincts suivants.
        #arbres
        Ils correspondent aux regroupements $(b a b) a b$ et $b a (b a b)$.
      ]

  #question[
          Déterminer, sans preuve pour cette question, le langage $L$ engendré par $G$.
          Quelle est la plus petite classe, parmi les langages réguliers et non-contextuels, à laquelle $L$ appartient ?
        ][Le langage est $L = (b a)^* b$ : il est régulier.]

  #question[Prouver que $L = L(G)$.][
        Pour $n=0$, $S ⇒ b$ engendre $(b a)^0 b$.
        Si $(b a)^n b$ est engendré, alors
        $ S ⇒ S a S ⇒ b a S ⇒^* b a (b a)^n b = (b a)^(n+1) b. $
        Une récurrence donne $L ⊂ L(G)$.

        Réciproquement, raisonner par induction sur les arbres d'analyse.
        La règle $S → b$ produit un mot de $L$.
        Pour $S → S a S$, les deux sous-arbres produisent par hypothèse $(b a)^r b$ et $(b a)^s b$, et leur assemblage produit $(b a)^r b a (b a)^s b = (b a)^(r+s+1) b ∈ L$.
        Ainsi $L(G) ⊂ L$.
      ]

  #question[Donner une grammaire non ambiguë engendrant $L$ et justifier sa non-ambiguïté.][
        Soit $G'$ la grammaire : $S → b a S ∣ b$.
        Pour produire $(b a)^n b$, il faut appliquer $n$ fois la première règle, puis la seconde. Aucun autre choix ne peut produire ce mot : il a un unique arbre d'analyse.
        Cette justification utilise le caractère forcé des choix :
        contenir au plus une variable dans chaque forme ne suffit pas en général à exclure l'ambiguïté.
      ]

  #question[
          Montrer que tout langage régulier peut être engendré par une grammaire non-contextuelle non ambiguë.
        ][
          Soit un automate fini déterministe reconnaissant le langage, d'état initial $q_0$, d'ensemble d'états $Q$, d'états finaux $F$ et de transition $δ$.
          Soit $G$ la grammaire de variables $V_q$, pour $q ∈ Q$, d'axiome $V_(q_0)$ et de règles :
          - $V_q → a V_(δ(q,a))$ pour chaque transition définie
          - $V_f → ε$ pour chaque $f ∈ F$

          Une dérivation terminale correspond exactement à un chemin acceptant dans l'automate, donc la grammaire engendre le langage voulu.
          Pour un mot fixé, le déterminisme impose chaque transition et donc chaque règle qui émet une lettre.
          Après la dernière lettre, il faut utiliser la règle d'effacement.
          Le mot possède donc un unique arbre d'analyse, y compris pour $ε$ si $q_0 ∈ F$.
        ]
]
