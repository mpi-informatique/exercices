#import "/load.typ": slide
#import "/load.typ": article-only, automate, cours-et-presentation, pause, sep, slides-only, solution, theoremes
#import theoremes: algorithme, definition, exercice, lemme, theoreme
#import automate: dessiner-automate

#show: cours-et-presentation.with(titre: "Théorème de Kleene", niveau: "MPI")

#slide()
On va montrer qu'un langage est régulier si et seulement s'il est reconnaissable.

= Régulier ⟹ reconnaissable

== Expressions régulières linéaires
#definition[
  Une expression régulière est linéaire si chaque lettre y apparaît au plus une fois.
]
#underline[Exemple] : $b a | a$ n'est pas linéaire, mais $a^* b$ est linéaire.

#slide()
#definition[
  Linéariser une expression $e$ consiste à remplacer chacune de ses occurrences de lettres par une lettre distincte d'un nouvel alphabet $Σ'$.
  La projection $π : Σ' → Σ$ associe chaque nouvelle lettre à la lettre d'origine.
]
#underline[Exemple] : $e = ε | b (a | b b)^* b$ se linéarise en $e' = ε | b_0 (a_0 | b_1 b_2)^* b_3$, avec $π(a_0) = a$ et $π(b_i) = b$.

== Premières lettres, dernières lettres, facteurs
#definition[
  Pour $L ⊂ Σ^*$, on définit :
  - $P(L) = {a ∈ Σ ∣ a Σ^* ∩ L ≠ ∅}$ : premières lettres.
  - $S(L) = {a ∈ Σ ∣ Σ^* a ∩ L ≠ ∅}$ : dernières lettres.
  - $F(L) = {m ∈ Σ^2 ∣ Σ^* m Σ^* ∩ L ≠ ∅}$ : facteurs de taille $2$.
]
#slide()
#exercice[Donner $P(L)$, $S(L)$ et $F(L)$ pour $L = a^* b (a b)^* c$.]
#solution[#pause $P(L) = {a, b}$, $S(L) = {c}$ et $F(L) = {a a, a b, b a, b c}$.]

== Langages locaux
#definition[
  Un langage $L$ est local si, pour tout mot non vide $m = m_1 … m_n$ :
  $ m ∈ L ⟺ m_1 ∈ P(L) ∧ m_n ∈ S(L) ∧ (∀ k ∈ {1, …, n - 1}, #sep m_k m_(k + 1) ∈ F(L)). $
]
L'implication de gauche à droite est toujours vraie. Il suffit donc de prouver l'autre sens.
L'appartenance de $ε$ est traitée séparément.

#slide()
Avec $N(L) = Σ^2 ∖ F(L)$, on a :
$ L ∖ {ε} = (P(L) Σ^* ∩ Σ^* S(L)) ∖ Σ^* N(L) Σ^*. $
#exercice[Montrer qu'un langage local est reconnaissable.]

#slide()
#exercice[
  Les langages suivants sont-ils locaux ?
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    [
      + $L_1 = a^*$
      + $L_2 = (a b)^*$
    ],
    enum(start: 3, [$L_3 = a^* | (a b)^*$], [$L_4 = a^* (a b)^*$]),
  )
]
#solution[#pause Les trois premiers donnent deux langages locaux puis un contre-exemple : $a a b$ respecte les conditions locales de $L_3$ sans lui appartenir. $L_4$ est local.]

#slide()
#theoreme[
  Si $L_1$ et $L_2$ sont locaux sur des alphabets disjoints $Σ_1$, $Σ_2$, alors $L_1 ∪ L_2$ et $L_1 L_2$ sont locaux sur $Σ_1 ∪ Σ_2$.
  Si $L_1$ est local, $L_1^*$ est local sur $Σ_1$.
]
#article-only[*Preuve* :]
#solution[
  #pause
  Pour l'union, aucun facteur autorisé ne passe d'un alphabet à l'autre.
  Pour la concaténation, un mot non vide passe au plus une fois de $Σ_1$ à $Σ_2$.
  Pour l'étoile, découper aux nouvelles jonctions $S(L_1) P(L_1)$.
]
L'hypothèse d'alphabets disjoints est essentielle pour les deux premières opérations, comme le montre $a^* ∪ (a b)^*$.

#exercice[L'ensemble des langages locaux est-il stable par complémentaire ?]
#slide()
#theoreme[Si $e$ est une expression régulière linéaire alors $cal(L)(e)$ est local.]
#article-only[*Preuve* :]
#solution[#pause Procéder par induction structurelle. Les deux sous-expressions d'une union ou d'une concaténation utilisent des alphabets disjoints.]

== Automate local
#definition[
  Un automate déterministe est local si toutes les transitions d'une même lettre aboutissent au même état :
  $ (q_1, a, q_2) ∈ E ∧ (q_3, a, q_4) ∈ E ==> q_2 = q_4. $
]
#theoreme[Un langage est local si et seulement s'il est reconnu par un automate local.]

#slide()
Pour reconnaître un langage local $L$, utiliser $Q = Σ ∪ {q_0}$, avec $q_0 ∉ Σ$.
- L'état initial est $q_0$.
- Les états finaux sont $S(L)$, auxquels ajouter $q_0$ si $ε ∈ L$.
- Les transitions sont $(q_0, a, a)$ pour $a ∈ P(L)$ et $(a, b, b)$ pour $a b ∈ F(L)$.

#slide()
#exercice[Construire un automate local reconnaissant $a (a | b)^*$.]
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
#algorithme(coeur: true)[
  #underline[Entrée] : une expression régulière $e$.\
  #underline[Sortie] : un automate de Glushkov reconnaissant $cal(L)(e)$.
  + Linéariser $e$ en $e'$ en remplaçant chaque occurrence de lettre par une lettre distincte d'un alphabet $Σ'$.
  + Calculer $P(cal(L)(e'))$, $S(cal(L)(e'))$ et $F(cal(L)(e'))$, et tester $ε ∈ cal(L)(e')$.
  + Construire l'automate local reconnaissant $cal(L)(e')$.
  + Remplacer chaque étiquette $a'$ par $π(a')$, où $π : Σ' → Σ$ associe à chaque nouvelle lettre sa lettre d'origine.
]
#solution(cours: true)[
  Notons $A'$ l'automate avant réétiquetage et $A$ l'automate renvoyé.
  Comme $e'$ est linéaire, $cal(L)(e')$ est local : la construction précédente donne donc $cal(L)(A') = cal(L)(e')$.
  Le cas de $ε$ est assuré par le choix de l'état initial comme état final exactement lorsque $ε ∈ cal(L)(e')$.

  Prolongeons $π$ aux mots lettre à lettre. Une induction sur $e$ donne $π(cal(L)(e')) = cal(L)(e)$ : la projection redonne chaque lettre d'origine et respecte l'union, la concaténation et l'étoile.

  Le réétiquetage conserve les chemins et leurs extrémités : un chemin acceptant lisant $m$ dans $A'$ lit $π(m)$ dans $A$, et tout chemin acceptant de $A$ provient d'un tel chemin de $A'$. Ainsi :
  $ cal(L)(A) = π(cal(L)(A')) = π(cal(L)(e')) = cal(L)(e). $
]

#slide()
#exercice(title: "Morphismes de mots")[
  Un _morphisme de monoïdes_ $h : Σ^* → Γ^*$ vérifie $h(ε) = ε$ et $h(u v) = h(u) h(v)$ pour tous mots $u, v$.
  Pour $L ⊂ Σ^*$, on note $h(L) = {h(m) | m ∈ L}$.

  + Montrer que toute application $Σ → Γ^*$ se prolonge de manière unique en un morphisme.
  + Pour $L_1, L_2 ⊂ Σ^*$, exprimer $h(L_1 ∪ L_2)$, $h(L_1 L_2)$ et $h(L_1^*)$ en fonction des images de $L_1$ et $L_2$.
  + Pour une expression régulière $r$ sur $Σ$, on note $h(r)$ l'expression obtenue en remplaçant chaque lettre $a$ par le mot $h(a)$, éventuellement $ε$. Montrer que $cal(L)(h(r)) = h(cal(L)(r))$. En déduire que l'image d'un langage régulier par un morphisme est régulière.
] <exo-morphismes-mots>
#solution[
  #pause
  + Nécessairement, $h(a_1 … a_n) = h(a_1) … h(a_n)$, par récurrence sur $n$.
    Réciproquement, cette formule, complétée par $h(ε) = ε$, définit un morphisme pour tout choix des images des lettres. Elle donne donc à la fois l'existence et l'unicité du prolongement.
  + On a :
    $ h(L_1 ∪ L_2) = h(L_1) ∪ h(L_2), #sep h(L_1 L_2) = h(L_1) h(L_2), #sep h(L_1^*) = h(L_1)^*. $
    La première égalité vient de la définition de l'image directe. La deuxième utilise $h(u v) = h(u) h(v)$ dans les deux sens. La troisième s'obtient en appliquant cette propriété aux concaténations d'un nombre quelconque de mots, y compris zéro.
  + Par induction structurelle sur $r$. Les cas $∅$, $ε$ et d'une lettre sont immédiats. Les trois identités précédentes traitent l'union, la concaténation et l'étoile.
    Si $L = cal(L)(r)$, alors $h(L) = cal(L)(h(r))$ est donc régulier.
]

#slide()
#exercice(title: "Application à Berry-Sethi")[
  Notons $e'$ une linéarisation de $e$ sur un alphabet $Σ'$, $π : Σ' → Σ$ la projection vers les lettres d'origine, $A'$ l'automate construit avant projection et $A$ l'automate renvoyé.

  + Prolonger $π$ en un morphisme $Σ'^* → Σ^*$. Ce morphisme est-il injectif ? Justifier $π(cal(L)(e')) = cal(L)(e)$ à l'aide de @exo-morphismes-mots.
  + Montrer que le remplacement des étiquettes $a'$ de $A'$ par $π(a')$ donne $cal(L)(A) = π(cal(L)(A'))$. Raisonner sur les chemins acceptants dans les deux sens.
  + Justifier $cal(L)(A') = cal(L)(e')$, en traitant aussi le mot vide. En déduire la correction de Berry-Sethi.
] <exo-correction-berry-sethi>
#solution[
  #pause
  + On pose $π(ε) = ε$ et $π(a_1 … a_n) = π(a_1) … π(a_n)$.
    Il s'agit d'un morphisme alphabétique non effaçant. Il n'est pas injectif dès que deux occurrences de $e$ portent la même lettre, par exemple $π(a_0) = π(a_1) = a$.
    La projection de l'expression $e'$ redonne $e$. La dernière question de @exo-morphismes-mots donne donc $π(cal(L)(e')) = cal(L)(e)$.
  + Tout chemin acceptant de $A'$ lisant $m$ devient un chemin acceptant de $A$ lisant $π(m)$.
    Réciproquement, chaque transition d'un chemin acceptant de $A$ provient d'au moins une transition de $A'$ entre les mêmes états. En choisissant ces transitions, on obtient un chemin acceptant de $A'$ lisant un mot $m$ dont l'image est le mot lu dans $A$.
    Les états initiaux et finaux sont inchangés, donc ce raisonnement vaut aussi pour les chemins de taille nulle.
  + Comme $e'$ est linéaire, $cal(L)(e')$ est local.
    Par construction de $A'$, un mot non vide $a_1 … a_n$ est accepté exactement lorsque sa première lettre appartient à $P(cal(L)(e'))$, sa dernière à $S(cal(L)(e'))$ et tous ses facteurs $a_k a_(k + 1)$ à $F(cal(L)(e'))$.
    La localité donne donc l'équivalence avec $a_1 … a_n ∈ cal(L)(e')$.
    L'état initial est final exactement lorsque $ε ∈ cal(L)(e')$. Ainsi, $cal(L)(A') = cal(L)(e')$ et :
    $ cal(L)(A) = π(cal(L)(A')) = π(cal(L)(e')) = cal(L)(e). $
]

#slide()
#exercice[Appliquer l'algorithme à $e = a (a | b)^*$.]
#solution[
  #pause
  Linéarisation : $a_0 (a_1 | b_0)^*$.
  $P = {a_0}$, $S = {a_0, a_1, b_0}$ et
  $F = {a_0 a_1, a_0 b_0, a_1 a_1, a_1 b_0, b_0 a_1, b_0 b_0}$.

  == Automate de Glushkov
  #dessiner-automate(
    (
      ("q_0", (0, 0), true, false),
      ("a_0", (3, 0), false, true),
      ("a_1", (6, 1.5), false, true),
      ("b_0", (6, -1.5), false, true),
    ),
    (
      ("q_0", "a_0", "a", (:)),
      ("a_0", "a_1", "a", (:)),
      ("a_0", "b_0", "b", (:)),
      ("a_1", "a_1", "a", (:)),
      ("b_0", "b_0", "b", (:)),
      ("a_1", "b_0", "b", (curve: 0.5)),
      ("b_0", "a_1", "a", (curve: 0.5)),
    ),
  )
]

== ε-transitions
On peut autoriser des transitions étiquetées par $ε$. Leur parcours ne consomme aucune lettre.
Un automate possédant de telles transitions n'est pas déterministe au sens du cours.

#slide()
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

#epsilon
Cet automate reconnaît ${ε, b, a c, a a, a a b}$.

#slide()
#theoreme[Tout automate avec $ε$-transitions est équivalent à un automate sans $ε$-transition.]<thm-epsilon>
#article-only[*Preuve* :]
#solution[
  #pause
  Noter $C(X)$ l'ensemble des états atteints depuis $X$ par des $ε$-transitions.
  Prendre $I' = C(I)$, garder $F$, et poser :
  $ δ'(q, a) = C(union.big_(p ∈ C({q})) δ(p, a)). $
  Les ensembles $C(X)$ se calculent par parcours de graphe.
]
#slide()
#exercice[Donner un automate sans $ε$-transition équivalent à l'exemple précédent.]
#article-only[#epsilon]
Pour déterminiser directement, partir de $C(I)$ et prendre la $ε$-fermeture après chaque lecture.

#underline[Remarque] : un automate avec $ε$-transitions n'est pas déterministe, mais il peut être déterminisé en adaptant l'algorithme de déterminisation ou en utilisant préalablement @thm-epsilon.

== Construction de Thompson (exemples non exigibles)
La construction récursive d'un automate avec $ε$-transitions fournit une autre preuve de régulier ⟹ reconnaissable.
Utiliser des copies à ensembles d'états disjoints.

#slide()
- $T(∅)$ ne possède aucun chemin acceptant.
- $T(ε)$ possède une transition $ε$ de l'état initial vers l'état final.
- $T(a)$ possède une transition $a$ de l'état initial vers l'état final.
#dessiner-automate(
  (("i", (0, 0), true, false), ("f", (3, 0), false, true)),
  (("i", "f", "a", (:)),),
)

#slide()
Pour $T(e_1 e_2)$, ajouter des transitions $ε$ des états finaux de $T(e_1)$ vers les états initiaux de $T(e_2)$.
Garder seulement les états initiaux du premier et les états finaux du second.

#slide()
- Pour $T(e_1 | e_2)$, réunir les deux ensembles d'états initiaux et finaux.
- Pour $T(e^*)$, ajouter un nouvel état $s$ initial et final, des transitions $ε$ de $s$ vers les anciens états initiaux et des anciens états finaux vers $s$. Retirer aux anciens états leurs rôles initial et final.

#slide()
#exercice[
  + Construire un automate de Thompson pour $a (a b | b)^*$.
  + Borner les nombres d'états des automates de Thompson et de Glushkov en fonction de la taille de l'expression.
]
#solution[#pause Les deux constructions donnent un nombre d'états linéaire. Glushkov utilise un état par occurrence de lettre, plus l'état initial.]

= Reconnaissable ⟹ régulier

== Normalisation
#lemme[
  Tout automate est équivalent à un automate avec $ε$-transitions possédant deux états distincts :
  - Un unique état initial $q_i$ sans transition entrante.
  - Un unique état final $q_f$ sans transition sortante.
]
#article-only[*Preuve* :]
#solution[#pause Ajouter $q_i$ et $q_f$, relier $q_i$ aux anciens états initiaux et les anciens états finaux à $q_f$ par des $ε$-transitions.]

== Élimination d'un état
Autoriser des expressions régulières comme étiquettes.
Noter $R_(p, r)$ l'union des étiquettes des transitions de $p$ à $r$, et $∅$ en l'absence de transition.

#algorithme(coeur: true)[
  Pour supprimer un état $q$ distinct de $q_i$, $q_f$, remplacer simultanément, pour tous les états restants $p, r$ :
  $ R_(p, r) ← R_(p, r) | R_(p, q) (R_(q, q))^* R_(q, r). $
  Supprimer ensuite $q$ et ses transitions.
]
#slide()
Tout passage par $q$ consiste à entrer dans $q$, parcourir sa boucle un nombre quelconque de fois, puis sortir de $q$.
Les chemins qui évitent $q$ sont conservés par le premier terme de l'union.

#slide()
#algorithme[
  + Normaliser l'automate.
  + Tant qu'il reste au moins trois états, éliminer un état différent de $q_i$, $q_f$.
  + Renvoyer l'étiquette de $q_i$ vers $q_f$, ou $∅$ s'il n'y a pas de transition.
]
Chaque élimination conserve le langage. À la fin, l'étiquette restante décrit donc le langage initial.

#slide()
#exercice[Donner une expression régulière pour l'automate suivant par élimination des états.]
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
  ("4", "4", "b", (:)),
)

#dessiner-automate(elimination-etats, elimination-arcs)

#solution[
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

= Théorème de Kleene et conséquences

#theoreme(coeur: true)[Un langage est régulier si et seulement s'il est reconnaissable par un automate fini.]
Choisir les automates ou les expressions régulières selon le problème.
La conversion d'une expression vers un automate permet une reconnaissance efficace.

#slide()
#theoreme[
  Les langages réguliers sont stables par union finie, concaténation, étoile, intersection finie, complémentaire et différence.
]
Les trois premières stabilités viennent de la définition. Les autres se déduisent du théorème de Kleene et des constructions sur les automates.

#slides-only[
  #slide()
  #exercice[Montrer que les mots sur $Σ = {a, b}$ ne contenant pas le facteur $a b a b b$ forment un langage régulier.]
]
