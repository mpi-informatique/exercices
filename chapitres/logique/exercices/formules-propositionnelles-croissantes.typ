#import "/load.typ": exercice, question, sep

#let ex = exercice(
  meta: (
    titre: "Formules propositionnelles croissantes",
    chapitres: ("logique",),
    difficulte: 2,
    niveaux: ("MP2I", "MPI"),
    concours: (nom: "CCINP", annee: 2023, filiere: "MPI", oral: true),
  ),
  corrections: [
    - Question 3 : le sens direct traite aussi le cas où $C$ est réduite à un unique littéral négatif $¬ x$ (sans partie $C'$).
    - Question 4b : on explicite pourquoi la disjonction $P'$ est finie et non vide (en utilisant que $P$ n'est pas une antilogie) et pourquoi chaque clause $C_a$ est non vide (en utilisant que $P$ n'est pas une tautologie).
  ],
)[
  On fixe un entier $n ≥ 1$ et un ensemble $E = {x_1, …, x_n}$ de variables propositionnelles.
  Étant données deux valuations $a : E ⟶ {V, F}$ et $b : E ⟶ {V, F}$, on dit que $a$ est _plus petite_ que $b$ (ce que l'on note $a ≤ b$) si :
  $ ∀ x ∈ E, #sep a(x) = V ==> b(x) = V. $
  Dans un but de simplification des calculs, on pourra faire les abus de notation suivants : assimiler $V$ à $1$ et $F$ à $0$ et vice versa.
  Avec cet abus, la propriété $a ≤ b$ se traduit par :
  $ ∀ x ∈ E, #sep a(x) ≤ b(x). $

  #question(
    jury: [Le jury profite de cette question pour vérifier que le candidat sait faire la différence entre syntaxe et sémantique.],
  )[
    Étant donnée une valuation sur $E$, rappeler comment on l'étend naturellement en une valuation sur les formules propositionnelles.
  ][
    Soit $a : E ⟶ {V, F}$ une valuation sur $E$. On l'étend par induction structurelle sur l'ensemble des formules propositionnelles construites sur $E$ :
    - pour toute variable $x ∈ E$, la valeur $a(x)$ est donnée par la valuation de départ
    - pour toutes formules propositionnelles $P$ et $Q$ :
      - $a(¬ P) = V$ si et seulement si $a(P) = F$
      - $a(P ∧ Q) = V$ si et seulement si $a(P) = V$ et $a(Q) = V$
      - $a(P ∨ Q) = V$ si et seulement si $a(P) = V$ ou $a(Q) = V$
    Les autres connecteurs ($→$, $↔$) s'étendent de manière analogue selon leurs tables de vérité.
  ]

  On dit qu'une formule propositionnelle $P$ est _croissante_ si, pour toutes valuations $a, b$ vérifiant $a ≤ b$, on a :
  $ a(P) = V ==> b(P) = V. $

  #question(
    jury: [Le candidat est autorisé à utiliser l'abus introduit par l'énoncé (assimiler $V$ à $1$ et $F$ à $0$), mais le jury se réserve le droit de vérifier qu'il a bien compris en quoi c'est un abus. Prouver rigoureusement la propriété pour un connecteur et indiquer ce qu'il suffit de changer pour l'autre obtient tous les points.],
    label: <q-croissantes-stabilite>,
  )[
    Montrer que si $P$ et $Q$ sont des formules croissantes alors $P ∧ Q$ et $P ∨ Q$ sont des formules croissantes.
  ][
    Soient $P$ et $Q$ deux formules croissantes et $a, b$ deux valuations vérifiant $a ≤ b$.
    En assimilant $V$ à $1$ et $F$ à $0$, on a :
    $ a(P ∧ Q) = min(a(P), a(Q)), #sep b(P ∧ Q) = min(b(P), b(Q)), $
    $ a(P ∨ Q) = max(a(P), a(Q)), #sep b(P ∨ Q) = max(b(P), b(Q)). $
    Comme $P$ et $Q$ sont croissantes et $a ≤ b$, on a $a(P) ≤ b(P)$ et $a(Q) ≤ b(Q)$.
    On en déduit :
    $ min(a(P), a(Q)) ≤ min(b(P), b(Q)) quad "et" quad max(a(P), a(Q)) ≤ max(b(P), b(Q)), $
    c'est-à-dire $a(P ∧ Q) ≤ b(P ∧ Q)$ et $a(P ∨ Q) ≤ b(P ∨ Q)$.
    Ainsi $P ∧ Q$ et $P ∨ Q$ sont croissantes.
  ]

  #question(
    jury: [Il ne faut pas oublier de traiter le caractère nécessaire et suffisant.],
    label: <q-croissantes-clause>,
  )[
    Soit $C$ une clause conjonctive satisfiable contenant au moins un littéral.
    Montrer qu'elle est croissante si et seulement si elle ne contient aucun littéral de la forme $¬ x$ avec $x ∈ E$.
  ][
    On procède par double implication.

    *Sens réciproque.* Supposons que $C$ ne contienne que des littéraux positifs.
    Une formule réduite à une unique variable $x ∈ E$ est croissante par définition de l'ordre $a ≤ b$.
    Par récurrence sur le nombre de littéraux de $C$ et par stabilité par conjonction (@q-croissantes-stabilite), la clause conjonctive $C$ est croissante.

    *Sens direct (par contraposée).* Supposons que $C$ contienne au moins un littéral négatif $¬ x$ avec $x ∈ E$.
    Comme $C$ est satisfiable, il existe une valuation $a$ telle que $a(C) = V$.
    En particulier, $a(¬ x) = V$, donc $a(x) = F$.
    Considérons la valuation $b$ qui coïncide avec $a$ sur $E ∖ {x}$ et vérifie $b(x) = V$.
    Par construction, $a ≤ b$.
    Or $b(¬ x) = F$, et comme $¬ x$ est un littéral de la clause conjonctive $C$, on a $b(C) = F$.
    Ainsi $a(C) = V$ et $b(C) = F$ avec $a ≤ b$, donc $C$ n'est pas croissante.
  ]

  #question(
    jury: [Le jury peut donner une indication pour aider le candidat à trouver une formule permettant de répondre à cette question.],
  )[
    On considère une formule propositionnelle $P$ qui n'est ni une tautologie, ni une antilogie.
    + Montrer que si $P$ est logiquement équivalente à une disjonction de clauses conjonctives dont aucune ne contient un littéral de la forme $¬ x$ avec $x ∈ E$ alors $P$ est une formule propositionnelle croissante.
    + Réciproquement, montrer que si $P$ est une formule propositionnelle croissante alors elle est logiquement équivalente à une disjonction de clauses conjonctives dont aucune ne contient un littéral de la forme $¬ x$ avec $x ∈ E$.
  ][
    + Chaque clause conjonctive sans littéral négatif est satisfiable (en affectant $V$ à toutes les variables) et croissante d'après la @q-croissantes-clause.
      Par récurrence et par stabilité par disjonction (@q-croissantes-stabilite), toute disjonction finie de telles clauses est croissante.
      Comme $P$ est logiquement équivalente à cette disjonction, elles prennent la même valeur pour toute valuation, donc $P$ est croissante.
    + Supposons $P$ croissante.
      Notons $cal(C)$ l'ensemble des clauses conjonctives non vides composées uniquement de littéraux positifs (sans répétition) telles que $C ⊨ P$, c'est-à-dire $a(C) = V ==> a(P) = V$ pour toute valuation $a$.
      Comme $E$ est fini, $cal(C)$ est fini (il contient au plus $2^n - 1$ clauses à équivalence près).

      Montrons d'abord que $cal(C)$ est non vide et associons une clause à chaque modèle de $P$.
      Soit $a$ une valuation vérifiant $a(P) = V$ (il en existe au moins une puisque $P$ n'est pas une antilogie).
      Posons :
      $ E_a = {x ∈ E mid(|) a(x) = V} quad "et" quad C_a = and.big_(x ∈ E_a) x. $
      L'ensemble $E_a$ est non vide : sinon $a$ enverrait toutes les variables sur $F$, donc on aurait $a ≤ b$ pour toute valuation $b$, et la croissance de $P$ donnerait $b(P) = V$ pour toute valuation $b$, ce qui contredirait le fait que $P$ n'est pas une tautologie.
      Ainsi $C_a$ est une clause conjonctive non vide de littéraux positifs.
      De plus, pour toute valuation $b$ telle que $b(C_a) = V$, on a $b(x) = V$ pour tout $x ∈ E_a$, donc $a ≤ b$, d'où $b(P) = V$ par croissance de $P$.
      Cela montre que $C_a ⊨ P$, donc $C_a ∈ cal(C)$.

      En particulier $cal(C)$ est non vide, ce qui permet de poser :
      $ P' = or.big_(C ∈ cal(C)) C. $
      Vérifions que $P$ et $P'$ sont logiquement équivalentes :
      - Si $a(P') = V$, alors il existe $C ∈ cal(C)$ tel que $a(C) = V$, donc $a(P) = V$ puisque $C ⊨ P$.
      - Réciproquement, si $a(P) = V$, alors $C_a ∈ cal(C)$ et $a(C_a) = V$ par définition de $E_a$, donc $a(P') = V$.

      Ainsi $P$ est logiquement équivalente à $P'$, qui est une disjonction de clauses conjonctives sans littéral négatif.
  ]
]
