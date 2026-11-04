#import "/load.typ": exercice, lien, question, sep, theoremes
#import theoremes: lemme-sans-numero

// Sources locales : rc/langages/lfcc.pdf, Olivier Carton, § 2.3.2–2.3.3 et 2.4.3.
// Voir aussi ups-mpi/mpi_gluher/Exercices/Lemme_Ogden.tex et son corrigé.
// Référence complémentaire : https://arxiv.org/abs/2209.06809v2.

#let lemme-etoile = lemme-sans-numero(outlined: false, full-title: [Lemme de l'étoile pour les langages non-contextuels (admis)])[
  Si $L$ est non-contextuel, il existe $N ≥ 1$ tel que tout mot $z ∈ L$ de taille au moins $N$ se décompose en $z = u v w x y$, avec
  $ abs(v w x) ≤ N, #sep v x ≠ ε, #sep ∀k ∈ NN, #sep u v^k w x^k y ∈ L. $
]

#let ex = exercice(
  meta: (
    titre: "Intersection et lemme d'Ogden",
    chapitres: ("grammaires-non-contextuelles", "automates-finis"),
    difficulte: 3,
    niveaux: ("MPI",),
    duree: (0, 55),
  ),
  corrections: [
    Corriger l'import du cadre de théorème et utiliser l'API courante de theoremes.
    Conserver la formulation du lemme admis choisie par le professeur, sans introduire les positions marquées.
    Déplacer le prolongement sur l'intersection depuis l'exercice sur la forme normale de Chomsky et le découper en deux questions guidées, suivies d'une application.
    Traiter les productions vides dans la grammaire produit : elles ne relient que deux états identiques.
    Difficulté et durée estimées : 3 sur 5 et 55 minutes.
  ],
  contenu: (
    lemme-etoile,
    [
      On considère $L_1 = {a^n b^n c^k | n, k ∈ ℕ}$ et $L_2 = {a^n b^n c^n | n ∈ ℕ}$.
    ],
    question([Montrer que $L_1$ est non-contextuel.], solution: [
      Soit $G$ la grammaire : $S → A C, #sep A → a A b ∣ ε, #sep C → c C ∣ ε$.
      $A$ engendre exactement les $a^n b^n$ et $C$ les $c^k$.
    ]),
    question([Montrer que $L_2$ n'est pas non-contextuel.], solution: [
      Supposons $L_2$ non-contextuel et prenons $p$ fourni par le lemme de l'étoile.
      Le mot $a^p b^p c^p$ possède alors une décomposition satisfaisant ses conditions.
      Puisque $abs(v w x) ≤ p$, ce facteur ne peut contenir à la fois un $a$ et un $c$.
      Une des trois lettres est donc absente de $v x$.
      Pour $i=0$, on retire au moins une lettre puisque $v x ≠ ε$, tandis que le nombre d'occurrences de la lettre absente reste $p$.
      Les trois nombres ne sont plus égaux, donc $u w y ∉ L_2$ : contradiction.
    ]),
    question(
      [
        Montrer que l'ensemble des langages non-contextuels est pas stable par union mais pas par intersection ni passage au complémentaire.
      ],
      solution: [

        Pour l'union, renommer les variables de deux grammaires afin qu'elles soient disjointes, puis ajouter une nouvelle variable $S$ avec $S → S_1 ∣ S_2$.
        Les dérivations choisissent l'une des deux grammaires, d'où exactement l'union.

        Soit $G$ la grammaire : $S → A B, #sep A → a A ∣ ε, #sep B → b B c ∣ ε$.
        Elle engendre le langage $K = {a^k b^n c^n | k,n ∈ ℕ}$, qui est donc non-contextuel.
        Or $L_1 ∩ K = L_2$, qui n'est pas non-contextuel.

        Si le passage au complémentaire préservait les langages non-contextuels, la stabilité par union et l'identité de De Morgan
        $ L_1 ∩ K = overline(overline(L_1) ∪ overline(K)) $
        impliqueraient la stabilité par intersection : contradiction.
      ],
    ),
    [
      On veut montrer que l'intersection d'un langage non-contextuel et d'un langage régulier est toujours non-contextuelle.

      Soit $G = (Σ, V, R, S)$ une grammaire sous #lien("forme-normale-chomsky")[Forme normale de Chomsky] et $A = (Σ, Q, q_0, F, δ)$ un ADC sur $Σ$.
    ],
    question(
      [Construire un automate $A_(p, q)$ reconnaissant les étiquettes des chemins de $p ∈ Q$ à $q ∈ Q$ dans $A$.],
      solution: [$A_(p, q) = (Σ, Q, p, {q}, δ)$.],
    ),
    [
      Soit $H = (Σ, V', R', S')$ une grammaire avec $V' = {X_(p, q) | X ∈ V$ et $p, q ∈ Q}$.
    ],
    question(
      [
        Construire $R'$ pour que :
        $ cal(L)_H (X_(p, q)) = cal(L)_G (X) ∩ cal(L)(A_(p, q)) $
      ],
      label: <q-intersection-regles>,
      solution: [
        - pour $X → Y Z ∈ R$ et $p, r, q ∈ Q$ : $X_(p, q) → Y_(p, r) Z_(r, q)$
        - pour $X → a ∈ R$ et $p ∈ Q$ : $X_(p, δ(p, a)) → a$
        - si $S → ε$ et pour $p ∈ Q$ : $S_(p, p) → ε$
      ],
    ),
    question(
      [
        Montrer qu'on a alors :
        $ X_(p, q) ⇒_H^* m quad ⟺ quad X ⇒_G^* m " et " δ^*(p, m) = q. $
        Finir la construction de $H$ pour avoir $cal(L)(H) = cal(L)(G) ∩ cal(L)(A)$.
      ],
      solution: [
        On montre l'équivalence par induction.\
        On choisit ensuite une nouvelle variable $S'$ et on ajoute $S' → S_(q_0, f)$ pour tout $f ∈ F$.
        Il engendre exactement les mots de $cal(L)(G)$ conduisant de $q_0$ à un état final, soit $cal(L)(G) ∩ cal(L)(A)$.
        En particulier, $ε$ est engendré si et seulement si $S ⇒_G^* ε$ et $q_0 ∈ F$.
      ],
    ),
    question(
      [
        En déduire que le langage suivant n'est pas non-contextuel :
        $ E = {m ∈ {a, b, c}^* | abs(m)_a = abs(m)_b = abs(m)_c} $

      ],
      solution: [
        Le langage $K = a^* b^* c^*$ est régulier et $E ∩ K = L_2$.
        En effet, un mot de $K$ ayant autant de $a$, de $b$ et de $c$ s'écrit exactement $a^n b^n c^n$ pour un $n ∈ ℕ$.
        Si $E$ était non-contextuel, le résultat précédent montrerait que $L_2$ l'est aussi, contrairement à la deuxième question.
      ],
    ),
  ),
)
