#import "/load.typ": exercice, question, sep, theoremes
#import theoremes: lemme

// Sources locales : rc/langages/lfcc.pdf, Olivier Carton, § 2.3.2–2.3.3 et 2.4.3.
// Voir aussi ups-mpi/mpi_gluher/Exercices/Lemme_Ogden.tex et son corrigé.
// Référence complémentaire : https://arxiv.org/abs/2209.06809v2.

#let ex = exercice(
  meta: (
    titre: "Intersections et lemme d'Ogden",
    chapitres: ("grammaires-non-contextuelles", "automates-finis"),
    difficulte: 3,
    niveaux: ("MPI",),
    duree: (0, 55),
  ),
  corrections: [
    Corriger l'import du cadre de théorème et utiliser l'API courante de theoremes.
    L'énoncé initial était le lemme de pompage ordinaire. Énoncer le lemme d'Ogden avec positions marquées et expliciter sa spécialisation utilisée pour les trois premières questions.
    Déplacer le prolongement sur l'intersection depuis l'exercice sur la forme normale de Chomsky et le découper en deux questions guidées, suivies d'une application.
    Traiter les productions vides dans la grammaire produit : elles ne relient que deux états identiques.
    Difficulté et durée estimées : 3 sur 5 et 55 minutes.
  ],
  contenu: (
    lemme(title: [d'Ogden (admis)])[
      Si $L$ est non-contextuel, il existe un entier $p ≥ 1$ tel que, pour tout mot $t ∈ L$ et tout choix d'au moins $p$ positions marquées dans $t$, on peut écrire $t = u v w x y$, avec :
      - $v x$ contient au moins une position marquée
      - $v w x$ contient au plus $p$ positions marquées
      - $∀i ∈ ℕ, #sep u v^i w x^i y ∈ L$
    ],
    [
      En marquant toutes les positions, on obtient le #emph[lemme de pompage] : tout mot $t ∈ L$ de taille au moins $p$ admet une telle décomposition avec $abs(v w x) ≤ p$ et $v x ≠ ε$.

      On considère $L_1 = {a^n b^n c^k | n, k ∈ ℕ}$ et $L_2 = {a^n b^n c^n | n ∈ ℕ}$.
    ],
    question([Montrer que $L_1$ est non-contextuel.], solution: [
      Prendre $S → A C$, $A → a A b ∣ ε$ et $C → c C ∣ ε$.
      $A$ engendre exactement les $a^n b^n$ et $C$ les $c^k$ : leur concaténation est $L_1$.
    ]),
    question([Montrer que $L_2$ n'est pas non-contextuel.], solution: [
      Supposons $L_2$ non-contextuel et prenons $p$ fourni par le lemme de pompage.
      Le mot $a^p b^p c^p$ possède alors une décomposition satisfaisant ses conditions.
      Puisque $abs(v w x) ≤ p$, ce facteur ne peut contenir à la fois un $a$ et un $c$ :
      un tel facteur aurait pour taille au moins $p+2$.
      Une des trois lettres est donc absente de $v x$.
      Pour $i=0$, on retire au moins une lettre puisque $v x ≠ ε$, tandis que le nombre d'occurrences de la lettre absente reste $p$.
      Les trois nombres ne sont plus égaux, donc $u w y ∉ L_2$ : contradiction.
    ]),
    question(
      [
        Montrer que les langages non-contextuels sont stables par union.
        En déduire qu'ils ne sont stables ni par intersection ni par passage au complémentaire.
        Les complémentaires sont pris dans ${a,b,c}^*$.
      ],
      solution: [
        Pour l'union, renommer les variables de deux grammaires afin qu'elles soient disjointes, puis ajouter un nouvel axiome $S$ et les règles $S → S_1 ∣ S_2$.
        Les dérivations choisissent l'une des deux grammaires, d'où exactement l'union.

        Le langage $K = {a^k b^n c^n | k,n ∈ ℕ}$ est non-contextuel :
        prendre $S → A B$, $A → a A ∣ ε$, $B → b B c ∣ ε$.
        Or $L_1 ∩ K = L_2$, qui n'est pas non-contextuel.

        Si le passage au complémentaire préservait les langages non-contextuels, la stabilité par union et l'identité de De Morgan
        $ L_1 ∩ K = overline(overline(L_1) ∪ overline(K)) $
        impliqueraient la stabilité par intersection : contradiction.
      ],
    ),
    [
      On cherche maintenant à montrer que l'intersection d'un langage non-contextuel et d'un langage régulier est toujours non-contextuelle.
      On admet que toute grammaire peut être transformée, à langage inchangé, en une grammaire dont les règles ont les formes
      $ X → Y Z, #sep X → a, #sep X → ε, $
      avec $X, Y, Z ∈ V$ et $a ∈ Σ$.

      Soient $G = (Σ, V, R, S)$ une telle grammaire et $B$ un ADC sur $Σ$, d'ensemble d'états $Q$, d'état initial $q_0$, d'états finaux $F$ et de fonction de transition $δ$.
      On note $δ^*(p, m)$ l'état atteint depuis $p$ après lecture du mot $m$.
      On veut construire une grammaire $H$ possédant des variables nouvelles $[p, X, q]$, pour $p, q ∈ Q$ et $X ∈ V$, qui engendrent les mots engendrés par $X$ et conduisant $B$ de $p$ à $q$.
    ],
    question(
      [
        Donner les règles à ajouter à $H$ pour chaque règle $X → Y Z$, $X → a$ et $X → ε$ de $G$.
        Pour la première forme, introduire l'état intermédiaire atteint après lecture du mot engendré par $Y$.
        Pour la dernière, rappeler l'effet de la lecture du mot vide sur l'état de l'automate.
      ],
      label: <q-intersection-regles>,
      solution: [
        On ajoute les règles suivantes :
        - pour chaque règle $X → Y Z$ et tous $p, r, q ∈ Q$,
          $ [p, X, q] → [p, Y, r] [r, Z, q] $
        - pour chaque règle $X → a$ et tout $p ∈ Q$,
          $ [p, X, δ(p, a)] → a $
        - pour chaque règle $X → ε$ et tout $p ∈ Q$,
          $ [p, X, p] → ε $

        Le mot produit par $Y$ conduit de $p$ à $r$, puis celui produit par $Z$ conduit de $r$ à $q$.
        Une lettre suit une transition de $B$, tandis que le mot vide laisse l'état inchangé.
        Il n'y a qu'un nombre fini de règles, car $Q$ et $R$ sont finis.
      ],
    ),
    question(
      [
        Justifier par induction sur les arbres de dérivation que les règles de la @q-intersection-regles donnent, pour tout $m ∈ Σ^*$,
        $ [p, X, q] ⇒_H^* m quad ⟺ quad X ⇒_G^* m " et " δ^*(p, m) = q. $
        Ajouter un nouvel axiome et ses règles pour que $H$ engendre $cal(L)(G) ∩ cal(L)(B)$.
        Vérifier le cas du mot vide.
      ],
      solution: [
        Dans le sens direct, on raisonne par induction sur la hauteur d'un arbre de $H$ enraciné en $[p, X, q]$.
        Une règle terminale ou vide fournit immédiatement la propriété.
        Pour une règle binaire, les deux sous-arbres produisent des mots $u$ et $v$ tels que
        $ Y ⇒_G^* u, #sep Z ⇒_G^* v, #sep δ^*(p, u) = r, #sep δ^*(r, v) = q. $
        Alors $X ⇒_G^* u v$ et $δ^*(p, u v) = q$.

        Réciproquement, on raisonne par induction sur la hauteur d'un arbre de $G$ enraciné en $X$ et produisant $m$.
        Si sa première règle est $X → a$ ou $X → ε$, la règle correspondante de $H$ convient.
        Sinon, elle est de la forme $X → Y Z$ et les deux sous-arbres produisent $u$ et $v$, avec $m = u v$.
        Posons $r = δ^*(p, u)$.
        Les hypothèses d'induction donnent les dérivations depuis $[p, Y, r]$ et $[r, Z, q]$.
        La règle binaire de $H$ permet donc d'engendrer $m$ depuis $[p, X, q]$.

        On choisit un nouvel axiome $S'$ et on ajoute $S' → [q_0, S, f]$ pour tout $f ∈ F$.
        Il engendre exactement les mots de $cal(L)(G)$ conduisant de $q_0$ à un état final, soit $cal(L)(G) ∩ cal(L)(B)$.
        En particulier, $ε$ est engendré si et seulement si $S ⇒_G^* ε$ et $q_0 ∈ F$.
        La construction traite donc aussi le mot vide, sans ajout de règle particulière à l'axiome.
      ],
    ),
    question(
      [
        En déduire que le langage
        $ E = {m ∈ {a, b, c}^* | abs(m)_a = abs(m)_b = abs(m)_c} $
        n'est pas non-contextuel.
        Indication : imposer un ordre aux lettres en intersectant avec un langage régulier.
      ],
      solution: [
        Le langage $K = a^* b^* c^*$ est régulier et $E ∩ K = L_2$.
        En effet, un mot de $K$ ayant autant de $a$, de $b$ et de $c$ s'écrit exactement $a^n b^n c^n$ pour un $n ∈ ℕ$.
        Si $E$ était non-contextuel, le résultat précédent montrerait que $L_2$ l'est aussi, contrairement à la deuxième question.
      ],
    ),
  ),
)
