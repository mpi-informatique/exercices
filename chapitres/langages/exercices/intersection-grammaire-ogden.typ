#import "/load.typ": exercice, formules-reparties, lien, question, sep, theoremes
#import theoremes: lemme-sans-numero

// Sources locales : rc/langages/lfcc.pdf, Olivier Carton, § 2.3.2–2.3.3 et 2.4.3.
// Voir aussi ups-mpi/mpi_gluher/Exercices/Lemme_Ogden.tex et son corrigé.
// Référence complémentaire : https://arxiv.org/abs/2209.06809v2.

#let lemme-etoile = lemme-sans-numero(
  outlined: false,
  full-title: [Lemme de l'étoile pour les langages non-contextuels],
)[
  Si $L$ est non-contextuel, il existe un entier $p ≥ 1$ tel que tout mot $t ∈ L$ de taille au moins $p$ s'écrit $t = u v w x y$, avec :
  #formules-reparties($abs(v w x) ≤ p$, $v x ≠ ε$, $∀i ∈ ℕ, #sep u v^i w x^i y ∈ L$)
]

#let ex = exercice(
  meta: (
    titre: "Intersection et lemme d'Ogden",
    chapitres: ("grammaires-non-contextuelles", "automates-finis"),
    difficulte: 3,
    niveaux: ("MPI",),
    duree: (1, 15),
  ),
  contenu: (
    [#lemme-etoile <lem-etoile>],
    question(
      [
        Soit $a$ un arbre de dérivation d'un mot non vide dans une grammaire en #lien("forme-normale-chomsky")[forme normale de Chomsky].
        Majorer son nombre de feuilles $f(a)$ en fonction de sa hauteur $h(a)$.
      ],
      solution: [
        L'arbre a au plus $2^(h-1)$ feuilles.
        On le montre par récurrence sur $h ≥ 1$.
        Si $h = 1$, la racine produit une unique feuille terminale.
        Sinon, la racine possède deux fils et chacun des deux sous-arbres est de hauteur au plus $h - 1$.
        Par hypothèse de récurrence, chacun a au plus $2^(h-2)$ feuilles, d'où le résultat.
      ],
    ),
    question(
      [
        Démontrer #link(<lem-etoile>)[le lemme de l'étoile].
      ],
      solution: [
        Soit $G$ une grammaire en forme normale de Chomsky engendrant $L$, avec $n$ variables.
        Posons $p = 2^n$ et considérons un arbre de dérivation d'un mot $t ∈ L$ de taille au moins $p$.
        Comme $t ≠ ε$, les règles utilisées sont binaires ou terminales.
        D'après la question précédente, une branche de longueur maximale contient au moins $n + 1$ variables : sinon l'arbre aurait au plus $2^(n-1)$ feuilles terminales.

        Parmi les $n + 1$ dernières variables de cette branche, deux sont égales à une même variable $X$.
        Le sous-arbre issu de la première occurrence de $X$ a une hauteur au plus $n + 1$, car aucune branche de l'arbre initial n'est plus longue que la branche choisie.
        D'après la question précédente, il a donc au plus $2^n$ feuilles.
        En distinguant les parties situées avant, entre et après ces deux occurrences, on obtient :
        $ S ⇒^* u X y ⇒^* u v X x y ⇒^* u v w x y = t. $
        Le sous-arbre de la première occurrence de $X$ engendre $v w x$, donc $abs(v w x) ≤ p$.
        Entre les deux occurrences de $X$, au moins une règle binaire est utilisée et chaque branche latérale engendre un mot non vide : $v x ≠ ε$.
        Enfin, on peut répéter ou supprimer la dérivation $X ⇒^* v X x$, puis utiliser $X ⇒^* w$.
        Pour tout $i ∈ ℕ$, on obtient ainsi $u v^i w x^i y ∈ L$.
      ],
    ),
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
        Si $E$ était non-contextuel, le résultat précédent montrerait que $L_2$ l'est aussi, contrairement au résultat sur $L_2$.
      ],
    ),
  ),
)
