#import "/load.typ": slide
#import "/load.typ": (
  article-only, automate, colonnes-cours, cours-et-presentation, hp, liste-cours, pause, sep, slides-only, solution,
  theoremes,
)
#import theoremes: algorithme, corollaire, definition, exercice, lemme, theoreme
#import automate: LA, Le, Ereg, Lrec, Lreg, dessiner-automate

#show: cours-et-presentation.with(titre: "Théorème de Kleene", niveau: "MPI")

#let Lloc = $cal(L)_("loc")$

#slide()

#theoreme(
  coeur: true,
  marge: false,
  title: "Théorème de Kleene",
)[Un langage est régulier si et seulement s'il est reconnaissable par un automate fini : $Lrec(Sigma) = Lreg(Sigma)$.]

= Régulier ⟹ reconnaissable
== Expressions régulières linéaires

#colonnes-cours(
  columns: (1.1fr, 1fr),
  [
    #definition[Expressions régulières linéaires][
      Une expression régulière est _linéaire_ si chaque lettre y apparaît au plus une fois.
    ]
  ],
  [
    #underline[Exemple] : $b a | a$ n'est pas linéaire, mais $a^* b$ est linéaire.
  ],
)


#definition[Linéarisation][
  _Linéariser_ une expression $e$ consiste à remplacer chaque occurrence de lettre $a$ par une nouvelle lettre $φ(a)$ différente.
]
#underline[Exemple] : $e = ε | b (a | b b)^* b$ peut se linéariser en $e' = ε | b_0 (a_0 | b_1 b_2)^* b_3$.

== Langages locaux

#colonnes-cours(
  columns: (1.15fr, 1fr),
  [
    #definition[$P(L)$, $S(L)$, $F(L)$, $N(L)$][
      Pour un langage $L ⊂ Σ^*$ :
      - $P(L) = {a ∈ Σ ∣ a Σ^* ∩ L ≠ ∅}$ : premières lettres.
      - $S(L) = {a ∈ Σ ∣ Σ^* a ∩ L ≠ ∅}$ : dernières lettres.
      - $F(L) = {m ∈ Σ^2 ∣ Σ^* m Σ^* ∩ L ≠ ∅}$ : facteurs de taille $2$.
      - $N(L) = Σ^2 ∖ F(L)$ : facteurs de taille 2 interdits.
    ]
  ],
  [
    #exercice[Donner ces ensembles pour $L = a (a | b)^*$.]
  ],
)

#slide()
#definition[Langage local][
  Soit $"Loc"(L)$ l'ensemble des mots dont la première lettre appartient à $P(L)$, la dernière à $S(L)$ et sans facteur de $N(L)$ :
  $ "Loc"(L) = (P(L) Σ^* ∩ Σ^* S(L)) ∖ Σ^* N(L) Σ^* $
  On dit que $L$ est _local_ si $"Loc"(L) = L\\{ε}$, c'est-à-dire, comme $L\\{ε} ⊂ L$ est toujours vrai :
  $ underbrace(m_1 ∈ P(L) ∧ m_n ∈ S(L) ∧ (∀ k ∈ [|1, n - 1|], #sep m_k m_(k + 1) ∈ F(L)), m ∈ "Loc"(L)) ==> m ∈ L $
  On note $Lloc(Σ)$ l'ensemble des langages locaux sur $Σ$.
]

#slide()
#exercice[Montrer que $Lloc(Σ) ⊂ Lreg(Σ)$.]

#slide()
#liste-cours(
  encadrer: contenu => exercice[
    Les langages suivants sont-ils locaux ?
    #contenu
  ],
  [$L_1 = a^*$],
  [$L_2 = (a b)^*$],
  [$L_3 = a^* | (a b)^*$],
  [$L_4 = a^* (a b)^*$],
)

#slide()
#theoreme[
  - Si $L_1 ∈ Lloc(Σ_1)$, $L_2 ∈ Lloc(Σ_2)$ avec $Σ_1 ∩ Σ_2 = ∅$ alors $L_1 ∪ L_2∈ Lloc(Σ_1 ∪ Σ_2)$ et $L_1 L_2 ∈ Lloc(Σ_1 ∪ Σ_2)$.\
  - Si $L ∈ Lloc(Σ)$ alors $L^* ∈ Lloc(Σ)$.
]

#exercice[
  + La stabilité par union et concaténation reste-t-elle vraie dans le cas général ?
  + $Lloc(Σ)$ est-il stable par complémentaire ?
]
#slide()
#theoreme[Linéaire $==>$ local][Si $e$ est une expression régulière linéaire alors $Le$ est local.]

== Automate local

#definition[Automate local][
  Un AD $A = (Σ, Q, q_0, F, δ)$ est _local_ si toutes les transitions étiquetées par une même lettre aboutissent au même état :
  $ ∀q_1, q_2 ∈ Q, a ∈ Σ, #sep δ(q_1, a) = δ(q_2, a) $
]
#colonnes-cours(
  [
    #theoreme(coeur: true)[$L ∈ Lloc(Σ)$ ⟺ $L$ est reconnu par un automate local.]<thm-local>
  ],
  [
    #exercice[Construire un automate local reconnaissant $a (a | b)^*$.]
  ],
)


#slide()
#solution[
  #pause
  #dessiner-automate(
    (("q_0", (0, 0), true, false), ("a", (3, 0), false, true), ("b", (6, 0), false, true)),
    (
      ("q_0", "a", "a", (:)),
      ("a", "a", "a", (:)),
      ("b", "b", "b", (:)),
      ("a", "b", "b", (curve: 0.5)),
      ("b", "a", "a", (curve: 0.5)),
    ),
  )
]

== Algorithme de Berry-Sethi
#algorithme(coeur: true, title: "Algorithme de Berry-Sethi")[
  - #underline[Entrée] : une expression régulière $e$.\
  - #underline[Sortie] : un automate _de Glushkov_ reconnaissant $Le$.

  + Linéariser $e$ en $e'$.
  + Calculer $P(cal(L)(e'))$, $S(cal(L)(e'))$ et $F(cal(L)(e'))$, et tester $ε ∈ cal(L)(e')$.
  + Construire l'automate local $A'$ reconnaissant $cal(L)(e')$ comme dans la preuve de @thm-local.
  + Renvoyer l'automate $A$ obtenu en remplaçant chaque étiquette $a'$ de $A'$ par sa lettre d'origine $π(a')$.
]<algorithme-berry-sethi>
#solution(cours: true)[
  Prolongeons $π$ aux mots avec $π(m) = π(m_1) … π(m_n)$ pour tout mot $m = m_1 … m_n$. Alors $π(L_1 ∪ L_2) = π(L_1) ∪ π(L_2)$, $π(L_1 L_2) = π(L_1) π(L_2)$ et $π(L_1^*) = π(L_1)^*$. Une induction sur $e$ donne donc $π(cal(L)(e')) = Le$.

  Remplacer $a'$ par $π(a')$ conserve les chemins et leurs extrémités : un chemin acceptant $m$ dans $A'$ accepte $π(m)$ dans $A$, et inversement. Ainsi :
  $ LA = π(cal(L)(A')) = π(cal(L)(e')) = Le. $
]

#exercice[Appliquer @algorithme-berry-sethi à $e = a (a | b)^*$.]

== ε-transitions

#definition[Automate avec $ε$-transitions][
  Un automate _avec $ε$-transitions_ permet des transitions étiquetées par $ε$ : $δ: Q × (Σ ∪ {ε}) → cal(P)(Q).$\
]

#let epsilon = dessiner-automate(
  (
    ("0", (0, 0), true, false),
    ("1", (3, 0), false, false),
    ("2", (6, 2), false, false),
    ("3", (6, -2), false, false),
    ("4", (9, 0), false, true),
  ),
  (
    ("0", "1", "a", (:)),
    ("0", "3", "ε", (curve: -0.5)),
    ("1", "2", "ε", (:)),
    ("1", "3", "a", (:)),
    ("2", "4", "c", (:)),
    ("3", "4", "b", (curve: 0.4)),
    ("3", "4", "ε", (curve: -0.4)),
  ),
)

#figure(
  epsilon,
  caption: [Automate à $ε$-transitions reconnaissant ${ε, b, a c, a a, a a b}$.],
  numbering: "1",
)<fig-epsilon>

#definition([$ε$-fermeture])[
  Pour un ensemble d'états $X ⊂ Q$, on note $ε(X)$ l'_$ε$-fermeture_ de $X$, c'est-à-dire l'ensemble des états atteignables depuis $X$ en utilisant uniquement des $ε$-transitions.
]
#underline[Exemple] : Sur @fig-epsilon, $ε(0) = {0, 3, 4}$ et $ε(1) = {1, 2}$.

#exercice[
  Proposer deux algorithmes pour calculer tous les $ε(q)$ pour $q ∈ Q$. Comparer.
]

#slide()
#theoreme[Suppression des $ε$-transitions][Tout automate avec $ε$-transitions est équivalent à un automate sans $ε$-transition.]<thm-epsilon>
#solution[
  Soit $A = (Σ, Q, I, F, δ)$ un automate avec $ε$-transitions.\
  On note $ε(X)$ l'$ε$-fermeture de $X$, c'est-à-dire l'ensemble des états atteignables depuis $X ⊂ Q$ avec des $ε$-transitions. \
  Alors $A$ est équivalent à $A' = (Σ, Q, ε(I), F, δ')$ avec :
  $ δ'(q, a) = ε(δ(q, a)) $

  Les ensembles $ε(X)$ se calculent par parcours de graphe.
]
#slide()
#exercice[Donner un automate sans $ε$-transition équivalent à @fig-epsilon.]
#slides-only[#epsilon]
Pour déterminiser directement, partir de $C(I)$ et prendre la $ε$-fermeture après chaque lecture.

#underline[Remarque] : un automate avec $ε$-transitions n'est pas déterministe, mais il peut être déterminisé en adaptant l'algorithme de déterminisation ou en utilisant préalablement @thm-epsilon.

#hp[== Automate de Thompson]

La construction de Thompson est une alternative récursive à l'algorithme de Berry-Sethi pour obtenir un automate à partir d'une expression régulière.

#exercice[Algorithme de Thompson][
  1. Définir récursivement un automate $T(e)$ reconnaissant une expression régulière $e$.
  2. Dessiner $T(a (a b | b)^*)$.
  3. Comparer les tailles des automates de Thompson et de Glushkov.
]

= Reconnaissable ⟹ régulier

#lemme[Normalisation][
  Tout automate est équivalent à un automate avec $ε$-transitions possédant deux états distincts :
  - Un unique état initial $q_i$ sans transition entrante.
  - Un unique état final $q_f$ sans transition sortante.
]

#slide()
#definition([Automate généralisé])[
  Un _automate généralisé_ $A = (Ereg(Σ), Q, I, F, δ)$ sur un alphabet $Σ$ permet des transitions étiquetées par des expressions régulières : $δ: Q × Ereg(Σ) → cal(P)(Q)$.\
  Une transition de $p$ à $q$ étiquetée par $e$ peut être franchie en lisant un mot quelconque de $Le$.
  On note $R_(p, r)$ l'union des expressions étiquetant les transitions de $p$ à $r$, et $∅$ en l'absence de transition.
]

#slide()
#definition([Langage reconnu])[
  Un mot $m$ est _accepté_ par $A$ s'il existe un _chemin acceptant_ de $I$ à $F$
  $ q_0 limits(⟶)^(e_1) q_1 limits(⟶)^(e_2) … limits(⟶)^(e_n) q_n $
  tel que $m ∈ cal(L)(e_1) … cal(L)(e_n)$. Pour un chemin sans transition, ce produit vaut ${ε}$.\
  Le _langage_ $LA$ _reconnu_ par $A$ est l'ensemble des mots acceptés par $A$.
]

#slide()
#underline[Exemple] :
#dessiner-automate(
  (("q_0", (0, 0), true, false), ("q_1", (3, 0), false, false), ("q_2", (6, 0), false, true)),
  (("q_0", "q_1", "a^*", (:)), ("q_1", "q_2", "b | ε", (:))),
)
Cet automate reconnaît $cal(L)(a^* (b | ε))$.
Le chemin de $q_0$ à $q_2$ accepte par exemple $a a b$ en lisant $a a$ puis $b$, mais aussi $ε$ en lisant $ε$ sur chacune des deux transitions.

#slide()
#exercice[Montrer que tout automate généralisé ayant un nombre fini de transitions est équivalent à un automate fini classique.]
#solution[
  Pour chaque transition $p limits(⟶)^e q$, construire par Berry-Sethi un automate reconnaissant $Le$, avec des états nouveaux.
  Remplacer la transition par cet automate, relier $p$ à ses états initiaux et ses états finaux à $q$ par des $ε$-transitions.
  Conserver comme états initiaux et finaux ceux de l'automate d'origine.

  Traverser ce nouvel automate revient à lire un mot de $Le$. Les chemins acceptants lisent donc les mêmes mots.
  Il reste à supprimer les $ε$-transitions.
]

#exercice[Substitution régulière][
  Soit $L ⊂ Σ^*$ un langage reconnaissable. Pour chaque $a ∈ Σ$, soit $e_a$ une expression régulière sur $Γ$.
  On note $s: Σ^* → cal(P)(Γ^*)$ le morphisme pour la concaténation défini par $s(a) = cal(L)(e_a)$ et $s(ε) = {ε}$.
  Montrer que $s(L) = union.big_(m ∈ L) s(m)$ est reconnaissable.
]
#solution[
  Prendre un automate $A$ reconnaissant $L$ et remplacer chaque étiquette $a$ par $e_a$.
  Dans l'automate généralisé $B$ obtenu, un chemin d'étiquette $m$ de $A$ peut lire exactement les mots de $s(m)$.
  Ainsi $cal(L)(B) = s(L)$.
  D'après le résultat précédent, $B$ est équivalent à un automate fini classique, donc $s(L)$ est reconnaissable.
]

== Élimination d'un état

#lemme[
  Soit $A = (Ereg(Σ), Q, I, F, T)$ un automate généralisé et $q ∈ Q ∖ (I ∪ F)$.
  Noter $R_(p, r)$ l'union des étiquettes des transitions de $p$ à $r$, avec $R_(p, r) = ∅$ s'il n'y en a pas.

  Construire $A'$ en supprimant $q$ et en mettant, pour chaque $p, r ∈ Q ∖ {q}$, une transition de $p$ à $r$ d'étiquette
  $ R'_(p, r) = R_(p, r) | R_(p, q) (R_(q, q))^* R_(q, r). $
  Avec les mêmes états initiaux et finaux, $cal(L)(A') = LA$.
]
#slide()
#grid(
  columns: (1fr, auto, 1fr),
  column-gutter: 0.5em,
  row-gutter: 0.65em,
  align: (col, row) => if row == 0 { horizon } else { top },
  dessiner-automate(
    (("p", (0, 0), false, false), ("q", (2.5, 0), false, false), ("r", (5, 0), false, false)),
    (
      ("p", "q", "e", (:)),
      ("q", "q", "f", (curve: 1)),
      ("q", "r", "g", (:)),
      ("p", "r", "h", (curve: -1.7)),
    ),
  ),
  $==>$,
  dessiner-automate(
    (("p", (0, 0), false, false), ("r", (5, 0), false, false)),
    (("p", "r", "h | e f^* g", (:)),),
  ),
  align(center)[Automate $A$],
  [],
  align(center)[Automate $A'$ après élimination de $q$],
)
Dans un chemin acceptant de $A$, contracter chaque portion de $p$ à $r$ dont les états intermédiaires sont une ou plusieurs occurrences de $q$.
Elle lit un mot de $cal(L)(R_(p, q) (R_(q, q))^* R_(q, r))$. Les transitions qui évitent $q$ sont conservées par $R_(p, r)$.
On obtient donc un chemin acceptant de $A'$ lisant le même mot.
Réciproquement, chaque transition d'un chemin de $A'$ se développe en un chemin de $A$ lisant le même mot. D'où $cal(L)(A') = LA$.

#let elimination-etats = (
  ("1", (0, 1.5), true, false),
  ("2", (3, 1.5), false, true),
  ("3", (0, -1.5), false, false),
  ("4", (3, -1.5), false, false),
)
#let elimination-arcs = (
  ("1", "2", "a", (:)),
  ("1", "3", "a", (:)),
  ("2", "4", "a", (:)),
  ("3", "4", "b", (:)),
  ("4", "1", "b", (:)),
  ("4", "4", "b", (anchor: right)),
)

#slide()
#colonnes-cours(
  columns: (1.25fr, 1fr),
  align: left + top,
  saut-slide: true,
  [
    #algorithme[
      + Normaliser l'automate.
      + Tant qu'il reste au moins trois états, éliminer un état différent de $q_i$, $q_f$.
      + Renvoyer l'étiquette de $q_i$ vers $q_f$, ou $∅$ s'il n'y a pas de transition.
    ]
    Chaque élimination conserve le langage. À la fin, l'étiquette restante décrit donc le langage initial.
  ],
  [
    #exercice[
      Donner une expression régulière pour l'automate suivant par élimination des états.
      #dessiner-automate(elimination-etats, elimination-arcs)
    ]
  ],
)

#solution(presentation: true)[
  == Normaliser l'exemple
  #dessiner-automate(
    (
      ("q_i", (-3, 1.5), true, false),
      ("1", (0, 1.5), false, false),
      ("2", (3, 1.5), false, false),
      ("q_f", (6, 1.5), false, true),
      ("3", (0, -1.5), false, false),
      ("4", (3, -1.5), false, false),
    ),
    (..elimination-arcs, ("q_i", "1", "ε", (:)), ("2", "q_f", "ε", (:))),
  )

  == Supprimer l'état 1
  #dessiner-automate(
    (
      ("q_i", (-3, 1.5), true, false),
      ("2", (3, 1.5), false, false),
      ("q_f", (6, 1.5), false, true),
      ("3", (0, -1.5), false, false),
      ("4", (3, -1.5), false, false),
    ),
    (
      ("q_i", "2", "a", (:)),
      ("q_i", "3", "a", (:)),
      ("2", "4", "a", (curve: 0.4)),
      ("4", "2", "b a", (curve: 0.4)),
      ("3", "4", "b", (curve: 0.4)),
      ("4", "3", "b a", (curve: 0.4)),
      ("4", "4", "b", (:)),
      ("2", "q_f", "ε", (:)),
    ),
  )

  == Supprimer l'état 4
  Poser $u = b^* b a$.
  #dessiner-automate(
    (
      ("q_i", (-3, 1), true, false),
      ("2", (3, 1), false, false),
      ("q_f", (6, 1), false, true),
      ("3", (0, -2), false, false),
    ),
    (
      ("q_i", "2", "a", (:)),
      ("q_i", "3", "a", (:)),
      ("2", "3", "a u", (curve: 0.4)),
      ("3", "2", "b u", (curve: 0.4)),
      ("2", "2", "a u", (:)),
      ("3", "3", "b u", (:)),
      ("2", "q_f", "ε", (:)),
    ),
  )

  == Supprimer l'état 3
  #dessiner-automate(
    (("q_i", (0, 0), true, false), ("2", (6, 0), false, false), ("q_f", (10, 0), false, true)),
    (("q_i", "2", "a | a (b u)^* b u", (:)), ("2", "2", "a u | a u (b u)^* b u", (:)), ("2", "q_f", "ε", (:))),
  )

  == Supprimer l'état 2
  On obtient, avec $u = b^* b a$ :
  $ (a | a (b u)^* b u) (a u | a u (b u)^* b u)^*. $
  Une expression équivalente plus courte est :
  $ a (b u)^* (a u (b u)^*)^*. $
]

#slide()
#exercice[Implémentation de l'élimination des états][
  Soit $A$ un automate normalisé à $n$ états, dont les étiquettes initiales sont de taille constante.
  1. Décrire, sans code, une implémentation de l'élimination des états utilisant une matrice de transitions et un type persistant pour les expressions régulières. Justifier les mises à jour en place de la matrice.
  2. Donner les complexités temporelle et spatiale en tenant compte du partage des sous-expressions.
  3. Montrer, sur une famille d'automates, que la longueur de l'expression obtenue sans partage ni simplification peut être exponentielle.
]
#solution[
  1. La matrice $R$ contient l'expression de chaque transition, ou $∅$ en son absence. Une union, une concaténation ou une étoile crée un nœud référençant ses opérandes, sans les recopier.
    Pour éliminer $q$, calculer $(R_(q, q))^*$ puis mettre à jour $R_(p, r)$ pour les états restants $p, r ≠ q$. La ligne et la colonne de $q$ ne sont pas modifiées pendant cette étape, ce qui justifie les mises à jour en place. Marquer ensuite $q$ comme supprimé.
  2. Il y a $O(n)$ éliminations, chacune mettant à jour $O(n^2)$ transitions. Chaque mise à jour prend un temps constant et crée un nombre constant de nœuds.
    Le temps et le nombre total de nœuds créés sont donc $O(n^3)$. La matrice occupe $O(n^2)$ cases, d'où un espace total $O(n^3)$.
  3. Prendre les états $s, t, q_1, …, q_k$, avec $s$ initial et $t$ final, et une transition étiquetée $a$ de chaque état de ${s, q_1, …, q_k}$ vers chaque état de ${q_1, …, q_k, t}$.
    Pour $k = 2$ :
    #dessiner-automate(
      (("s", (0, 0), true, false), ("q_1", (3, 1.5), false, false), ("q_2", (3, -1.5), false, false), ("t", (6, 0), false, true)),
      (
        ("s", "q_1", "a", (:)),
        ("s", "q_2", "a", (:)),
        ("s", "t", "a", (curve: 4.2)),
        ("q_1", "q_1", "a", (anchor: top)),
        ("q_1", "q_2", "a", (curve: 0.4)),
        ("q_2", "q_1", "a", (curve: 0.4)),
        ("q_2", "q_2", "a", (anchor: bottom)),
        ("q_1", "t", "a", (:)),
        ("q_2", "t", "a", (:)),
      ),
    )
    Après $j$ éliminations, les transitions entre états restants, hors celles entrant en $s$ ou sortant de $t$, portent la même expression $E_j$, où
    $ E_0 = a, quad E_(j + 1) = E_j | E_j (E_j)^* E_j. $
    Le nombre d'occurrences de $a$ est multiplié par $4$ à chaque étape. L'expression finale en contient donc $4^k$, pour un automate à $k + 2$ états.
    Cette borne concerne l'expression produite sans simplification. Le langage reconnu est simplement $a a^*$.
]
#slide()
#underline[Remarque] : l'intérêt du _type persistant_ est de conserver et partager les anciennes sous-expressions sans les recopier. La matrice est mutable, mais les expressions sont immuables et leur représentation partagée forme un graphe acyclique. Développer ce graphe en une expression écrite sans partage peut demander un temps et un espace exponentiels.

#slide()
#corollaire[
  Les langages réguliers sont stables par union finie, concaténation, étoile, intersection finie, complémentaire et différence.
]
Les trois premières stabilités viennent de la définition. Les autres se déduisent du théorème de Kleene et des constructions sur les automates.

#slides-only[
  #slide()
  #exercice[Montrer que les mots sur $Σ = {a, b}$ ne contenant pas le facteur $a b a b b$ forment un langage régulier.]
]
