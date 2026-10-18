#import "/load.typ": article-only, automate, colonnes-cours, cours-et-presentation, pause, pointilles, sep, slides-only, solution, theoremes
#import theoremes: algorithm, definition, exercise, lemma, theorem
#import automate: cetz, dessiner-automate, finite, style-automates, unite-automates
#import "@preview/touying:0.8.0": touying-reducer

#show: cours-et-presentation.with(titre: "Automates", niveau: "MPI")

#let exemple = dessiner-automate(
  (("0", (0, 0), true, false), ("1", (3, 0), false, false), ("2", (6, 0), false, true)),
  (
    ("0", "0", "a", (:)),
    ("0", "1", "b", (curve: 0.4)),
    ("1", "0", "a", (curve: 0.4)),
    ("1", "2", "a", (:)),
    ("2", "2", "b", (:)),
  ),
)
#let impair = dessiner-automate(
  (("0", (0, 0), true, false), ("1", (3, 0), false, true)),
  (("0", "0", "b", (:)), ("1", "1", "b", (:)), ("0", "1", "a", (curve: 0.5)), ("1", "0", "a", (curve: 0.5))),
)
#let deux-initiaux = dessiner-automate(
  (("0", (0, 0.9), true, false), ("1", (0, -0.9), true, false), ("2", (3, 0), false, true)),
  (
    ("0", "0", "a", (:)),
    ("1", "1", "b", (anchor: bottom)),
    ("0", "2", "b", (curve: 0)),
    ("1", "2", "a", (curve: 0)),
  ),
)
#let facteur = dessiner-automate(
  (("0", (0, 0), true, false), ("1", (3, 0), false, false), ("2", (6, 0), false, false), ("3", (9, 0), false, true)),
  (("0", "0", "a, b", (:)), ("0", "1", "a", (:)), ("1", "2", "b", (:)), ("2", "3", "b", (:)), ("3", "3", "a, b", (:))),
)

= Automate non déterministe

#let definition-automate = definition(marge-haute: false)[
  Un automate est un $5$-uplet $A = (Σ, Q, I, F, E)$ où :
  - $Σ$ est un alphabet.
  - $Q$ est un ensemble fini d'états.
  - $I ⊂ Q$ est l'ensemble des états initiaux.
  - $F ⊂ Q$ est l'ensemble des états finaux, ou acceptants.
  - $E ⊂ Q × Σ × Q$ est l'ensemble des transitions.
]

#let exemple-automate = figure(exemple, numbering: none, caption: [
  $Σ = {a, b}, Q = {0, 1, 2}, I = {0}, F = {2}$\
  $E = {(0, a, 0), (0, b, 1), (1, a, 0), (1, a, 2), (2, b, 2)}$
])

#colonnes-cours(
  columns: (1.2fr, 1fr),
  definition-automate,
  exemple-automate,
)

== Fonction de transition
#let definition-transition = [
  #definition(marge-haute: false)[
    On peut remplacer $E$ par  $δ : Q × Σ → cal(P)(Q)$ tel que :
    $ δ(q, a) = {q' ∈ Q ∣ (q, a, q') ∈ E}. $
  ]
  On dit qu'il y a un blocage lorsque $δ(q, a) = ∅$.
]
#let exercice-transition = align(center, figure(
  table(
    columns: (auto, 2.5em, 2.5em, 2.5em),
    rows: 2em,
    align: center + horizon,
    table.header([$q$], [$0$], [$1$], [$2$]),
    [$δ(q, a)$], [], [], [],
    [$δ(q, b)$], [], [], [],
  ),
  numbering: none,
  caption: none,
))

#colonnes-cours(
  columns: (1.2fr, 1fr),
  definition-transition,
  exercice-transition,
)

== Implémentation

#exercise[
  1. Proposer et comparer plusieurs structures de données pour représenter un automate.
  2. En implémenter une.
]

= Langage reconnaissable

#slides-only[== Chemin acceptant]
#definition[
  Un chemin $C$ dans un automate $A$ est une suite de transitions consécutives :
  $q_0 limits(arrow.long)^(a_1) q_1 limits(arrow.long)^(a_2) … limits(arrow.long)^(a_n) q_n.$\
  L'étiquette de $C$ est le mot $a_1 … a_n$.
  On dit que $C$ est acceptant si $q_0 ∈ I$ et $q_n ∈ F$.
]
#slides-only[== Langage reconnu]
#definition[
  Un mot est accepté par $A$ s'il est l'étiquette d'un chemin acceptant.
  Le langage $cal(L)(A)$ reconnu par $A$ est l'ensemble des mots acceptés.
  Un langage est reconnaissable s'il est reconnu par un automate.
]
Le chemin de longueur nulle permet d'accepter $ε$ exactement lorsque $I ∩ F ≠ ∅$.

#slides-only[== Lecture d'un automate]
#exercise[Déterminer le langage reconnu par chacun des deux automates suivants.]
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  align: horizon,
  figure(impair, numbering: none, gap: 0.4em, caption: [$A_1$]),
  figure(deux-initiaux, numbering: none, gap: 0.4em, caption: [$A_2$]),
)

#slides-only[
  == Lecture d'un automate : réponses
  À gauche : les mots contenant un nombre impair de $a$, par exemple $b b a b$.

  À droite : $a^* b | b^* a$.
  Chaque état initial correspond à l'une des deux branches de l'union.
]

#slides-only[== Construction d'automates]

#colonnes-cours(
  encadrer: contenu => exercise[
    Montrer que les langages suivants sont reconnaissables :
    #contenu
  ],
  [
    + $a b | a b c | c$
    + Mots de taille paire sur $Σ = {a, b}$.
  ],
  [
    #set enum(start: 3)
    + $(b | a b | a b a)^*$
    + Mots sur $Σ = {a, b}$ dont l'avant-dernière lettre est $a$.
  ],
)

= Test d'appartenance

#slides-only[== Ensemble des états atteints]
Pour lire $m = m_1 … m_n$, calculer :
$ Q_0 = I, quad Q_k = union.big_(q ∈ Q_(k - 1)) δ(q, m_k). $
Alors $m ∈ cal(L)(A)$ si et seulement si $Q_n ∩ F ≠ ∅$.
Cette méthode traite aussi le mot vide.

#slides-only[== Programmation de la reconnaissance]
#exercise[
  + Écrire ```ocaml etape a etats lettre``` renvoyant les états atteints après une lettre.
  + Écrire ```ocaml accepte (a : automate) (m : string)```.
  + Déterminer la complexité.
]
#solution[
  == Une étape de lecture
  ```ocaml
  let rec etape a etats lettre = match etats with
    | [] -> []
    | e :: q ->
      let suivants = match Hashtbl.find_opt a.delta (e, lettre) with
        | None -> []
        | Some l -> l
      in
      suivants @ etape a q lettre
  ```
  Cette version peut produire des doublons. Utiliser un ensemble pour les supprimer.

  == Lecture du mot
  ```ocaml
  let accepte a mot =
    let etats = ref a.initiaux in
    for i = 0 to String.length mot - 1 do
      etats := etape a !etats mot.[i]
    done;
    List.exists (fun e -> List.mem e a.finaux) !etats
  ```
  Avec des ensembles représentés par tableaux booléens et des listes d'adjacence, chaque étape coûte $O(abs(Q) + abs(E))$. Le coût total est $O((abs(m) + 1)(abs(Q) + abs(E)))$.
]
On peut aussi essayer les chemins par retour sur trace, mais leur nombre peut être exponentiel en la taille du mot.

= Automate complet

#slides-only[== Équivalence et complétude]
#definition[
  Deux automates sont équivalents s'ils reconnaissent le même langage.
  Un automate est complet si :
  $ ∀ q ∈ Q, #sep ∀ a ∈ Σ, #sep ∃ q' ∈ Q, #sep (q, a, q') ∈ E. $
]
Un automate complet n'a pas de blocage.
#slides-only[== Compléter un automate]
#theorem[Tout automate est équivalent à un automate complet.]
#article-only[*Preuve* :]
#slides-only[
  #pause
  Ajouter un état puits $q_∞$ non final, bouclant sur chaque lettre.
  Pour chaque transition manquante, ajouter une transition vers $q_∞$.
  Aucun nouveau chemin acceptant n'est créé.
]

= Automate déterministe

#grid(
  columns: (1.6fr, 1fr),
  column-gutter: 1.5em,
  align: horizon,
  definition(coeur: true, marge-haute: false)[
    Un automate $A$ est déterministe si :
    + Il possède un unique état initial
    + $(q, a, q_1) ∈ E ∧ (q, a, q_2) ∈ E ==> q_1 = q_2$
  ],
  dessiner-automate(
    (("q", (0, 0), true, false), ("q_1", (2.5, 1), false, true), ("q_2", (2.5, -1), false, false)),
    (("q", "q_1", "a", (curve: 0)), ("q", "q_2", "b", (curve: 0))),
  ),
)

Un ADC (automate déterministe complet) a $|Q| × |Σ|$ transitions et une fonction de transition de la forme $δ : Q × Σ → Q$.

#slides-only[== Chemins dans un automate déterministe complet]
#exercise[
  Soient $A = (Q, Σ, q_0, F, E)$ un ADC, $q ∈ Q$, $m ∈ Σ^*$. Quelles sont les propositions vraies ?
  + Il existe un unique chemin d'étiquette $m$ partant de $q$.
  + Il existe un unique chemin de $q_0$ à $q$.
  + $(q_1, a, q) ∈ E ∧ (q_2, a, q) ∈ E ==> q_1 = q_2.$
]
== Fonction de transition étendue
#definition[
  Pour un automate déterministe complet, la fonction $δ^* : Q × Σ^* → Q$ est définie par :
  - $δ^*(q, ε) = q$
  - $δ^*(q, a v) = δ^*(δ(q, a), v)$
]
On a $u ∈ cal(L)(A) ⇔ δ^*(q_i, u) ∈ F$.
#slides-only[== Lecture d'une concaténation]
#theorem[$δ^*(q, u v) = δ^*(δ^*(q, u), v)$.] <thm-transition-concatenation>
#article-only[*Preuve* :]
#slides-only[#pause Démontrer le résultat par récurrence sur $abs(u)$.]

#slides-only[== Un test fini d'universalité]
#exercise[
  Soit $A$ un automate déterministe complet à $n$ états sur un alphabet $Σ$.
  Montrer que si $A$ accepte tous les mots de taille strictement inférieure à $n$, alors $cal(L)(A) = Σ^*$.
  La borne est-elle optimale ?
]
#solution[
  #slides-only[== Correction : supprimer une boucle]
  Supposons $cal(L)(A) ≠ Σ^*$ et soit $m$ un mot refusé de taille minimale.
  Par hypothèse, $abs(m) ≥ n$.
  Parmi les états atteints après lecture de ses $n + 1$ premiers préfixes, deux sont égaux.
  On peut donc écrire $m = x y z$, avec $y ≠ ε$, et
  $ δ^*(q_0, x) = δ^*(q_0, x y). $
  Le @thm-transition-concatenation sur la lecture d'une concaténation donne
  $ δ^*(q_0, x z) = δ^*(δ^*(q_0, x), z) = δ^*(δ^*(q_0, x y), z) = δ^*(q_0, m). $
  Le mot $x z$ est donc refusé et strictement plus court que $m$, ce qui contredit sa minimalité.

  #slides-only[== Correction : optimalité de la borne]
  La borne est optimale sur $Σ = {a}$.
  Prenons $Q = {0, …, n - 1}$, l'état initial $0$, les états finaux $Q ∖ {n - 1}$ et
  $ δ(i, a) = min(i + 1, n - 1). $
  Cet automate accepte tous les mots de taille strictement inférieure à $n - 1$, mais refuse $a^(n - 1)$.
]

== Implémentation déterministe
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  align: top,
  [
```ocaml
type afdc = {
  initial : int;
  finaux : int list;
  delta : (int * char, int) Hashtbl.t
}
```
  ],
  [
```ocaml
let accepte a m =
  let etat = ref a.initial in
  for i = 0 to String.length m - 1 do
    etat := Hashtbl.find a.delta (!etat, m.[i])
  done;
  List.mem !etat a.finaux
```
  ],
)
Complexité : #pointilles()

== Déterminisation
#theorem(coeur: true)[Tout automate est équivalent à un automate déterministe complet.]
L'automate des parties est $A' = (Σ, cal(P)(Q), {I}, F', δ')$, où :
$ F' = {X ⊂ Q ∣ X ∩ F ≠ ∅}, quad δ'(X, a) = union.big_(q ∈ X) δ(q, a). $

#slides-only[== Correction de la déterminisation]
*Invariant* : après lecture d'un mot $u$, l'état atteint dans $A'$ est exactement l'ensemble des états atteignables dans $A$ depuis $I$ en lisant $u$.

#article-only[*Preuve* :]
#solution[
  #pause
  - Pour $ε$, cet ensemble est $I$.
  - Pour $u a$, prendre l'union des $δ(q, a)$ pour tous les états atteints après $u$.
  - Le mot est accepté si cet ensemble rencontre $F$.
]

#slides-only[== Construire seulement les états accessibles]
#algorithm(coeur: true)[
  + Initialiser les états découverts et la liste d'attente à ${I}$.
  + Tant que la liste n'est pas vide, extraire un ensemble $X$.
  + Pour chaque $a ∈ Σ$, calculer $X' = union.big_(q ∈ X) δ(q, a)$, enregistrer la transition et ajouter $X'$ s'il est nouveau.
  + Marquer finaux les ensembles rencontrant $F$.
]
L'automate des parties possède $2^(abs(Q))$ états. En pratique, ne construire que les états accessibles. L'ensemble vide joue le rôle d'un puits.

#slides-only[== Exemple de déterminisation]
#exercise(coeur: true)[Déterminiser l'automate suivant.]
#facteur
#solution[
  == Automate déterminisé
  // Les éléments masqués gardent leurs dimensions et leurs ancres entre les étapes.
  #text(size: 0.6em)[
    #facteur
    #v(0.5em)
    #align(center, touying-reducer(
      reduce: cetz.canvas,
      cover: cetz.draw.hide.with(bounds: true),
      length: unite-automates,
      {
        import finite.draw: state, transition
        cetz.draw.set-style(..style-automates, state: (radius: 0.9))
        state((0, 2), "0", label: ${0}$, initial: (label: none))
        (pause,)
        state((3, 2), "1", label: ${0, 1}$)
        transition("0", "1", label: (text: $a$))
        (pause,)
        transition("0", "0", label: (text: $b$))
        (pause,)
        transition("1", "1", label: (text: $a$))
        (pause,)
        state((6, 2), "2", label: ${0, 2}$)
        transition("1", "2", label: (text: $b$), curve: 0.4)
        (pause,)
        transition("2", "1", label: (text: $a$), curve: 0.4)
        (pause,)
        state((6, -2), "3", label: ${0, 3}$, final: true)
        transition("2", "3", label: (text: $b$))
        (pause,)
        state((3, -2), "4", label: ${0, 1, 3}$, final: true)
        transition("3", "4", label: (text: $a$))
        (pause,)
        transition("3", "3", label: (text: $b$), anchor: bottom)
        (pause,)
        transition("4", "4", label: (text: $a$), anchor: bottom)
        (pause,)
        state((0, -2), "5", label: ${0, 2, 3}$, final: true)
        transition("4", "5", label: (text: $b$), curve: 0.4)
        (pause,)
        transition("5", "4", label: (text: $a$), curve: 0.4)
        (pause,)
        transition("5", "3", label: (text: $b$, dist: -style-automates.transition.label.dist), curve: -3)
      },
    ))
  ]
]

#slides-only[== Coût exponentiel]
#exercise[
  Soit $L_n = Σ^* a Σ^n$ sur $Σ = {a, b}$, avec $n ∈ ℕ$.
  + Construire un automate non déterministe à $n + 2$ états reconnaissant $L_n$.
  + En déduire un automate déterministe à $2^(n + 2)$ états.
  + Montrer que tout automate déterministe reconnaissant $L_n$ possède au moins $2^n$ états.
]

= Stabilité des langages reconnaissables

== Complémentaire
#theorem(coeur: true)[Si $L ⊂ Σ^*$ est reconnaissable, $Σ^* ∖ L$ est reconnaissable.]
#article-only[*Preuve* :]
#solution[
  #pause
  Prendre un automate déterministe complet reconnaissant $L$ et remplacer $F$ par $Q ∖ F$.
  Chaque mot possède un unique chemin, qui aboutit dans un état final exactement lorsque le mot n'appartient pas à $L$.
]
#slides-only[== Hypothèses et application]
#exercise[
  + Montrer pourquoi la preuve nécessite un automate déterministe complet.
  + Dessiner un automate reconnaissant les mots contenant le facteur $a a a$, puis un automate reconnaissant les mots ne le contenant pas.
]

== Automate produit
#theorem(
  coeur: true,
)[Les langages reconnaissables sur un même alphabet sont stables par intersection, union et différence.]
Pour deux automates déterministes complets $A_1$, $A_2$, utiliser les états $Q_1 × Q_2$, l'état initial $(i_1, i_2)$ et :
$ δ((q_1, q_2), a) = (δ_1(q_1, a), δ_2(q_2, a)). $

#slides-only[== Choix des états finaux du produit]
Le produit simule les deux lectures en parallèle. Compléter l'ensemble des états finaux :
#solution[
  - Pour $L_1 ∩ L_2$ : $F_1 × F_2$.
  - Pour $L_1 ∪ L_2$ : $(F_1 × Q_2) ∪ (Q_1 × F_2)$.
  - Pour $L_1 ∖ L_2$ : $F_1 × (Q_2 ∖ F_2)$.
]
#article-only[
  - Pour $L_1 ∩ L_2$ : $F =$ #line(length: 5cm)
  - Pour $L_1 ∪ L_2$ : $F =$ #line(length: 5cm)
  - Pour $L_1 ∖ L_2$ : $F =$ #line(length: 5cm)
]

#article-only[
  Si les alphabets diffèrent, compléter les deux automates sur leur union.
  Ces résultats se généralisent aux unions et intersections finies.
  Pour une union, on peut aussi prendre l'union disjointe de deux automates non déterministes.
]
#slides-only[== Applications du produit]
#exercise[
  + La construction fonctionne-t-elle sans les hypothèses de déterminisme et de complétude ? Examiner chaque opération.
  + Construire un automate reconnaissant les mots sur ${a, b}$ contenant un nombre pair de $a$ et un nombre de $b$ congru à $2$ modulo $3$.
]

= Accessibilité et émondage

#slides-only[== États accessibles et co-accessibles]
#definition[
  - Un état est accessible s'il existe un chemin depuis un état initial vers cet état.
  - Il est co-accessible s'il existe un chemin depuis cet état vers un état final.
  - Un automate est émondé si tous ses états sont accessibles et co-accessibles.
]
#slides-only[== Calcul de l'accessibilité]
#exercise[Décrire un algorithme de coût $O(abs(Q) + abs(E))$ déterminant ces deux ensembles.]
#solution[#pause Parcourir le graphe depuis $I$, puis le graphe transposé depuis $F$.]
#slides-only[== Émondage]
#theorem[Tout automate est équivalent à un automate émondé.]
Supprimer les états inaccessibles et les états non co-accessibles : aucun chemin acceptant ne les utilise.
#exercise[Tout automate est-il équivalent à un automate émondé déterministe complet ?]

= Lemme de l'étoile

#slides-only[== Énoncé]
#lemma(coeur: true)[
  Soit $L$ reconnu par un automate à $n$ états. Pour tout $u ∈ L$ de taille au moins $n$, il existe $x, y, z$ tels que :
  $ u = x y z, quad abs(x y) ≤ n, quad y ≠ ε, quad ∀ k ∈ ℕ, #sep x y^k z ∈ L. $
]
#slides-only[== Preuve : trouver un cycle]
*Preuve* : prendre un chemin acceptant d'étiquette $u$.
Parmi ses $n + 1$ premiers états, deux sont égaux : $q_i = q_j$, avec $0 ≤ i < j ≤ n$.
Décomposer le mot en $x$, avant $q_i$, $y$, entre $q_i$ et $q_j$, et $z$, après $q_j$.

#dessiner-automate(
  (("q_0", (0, 0), true, false), ("q_i=q_j", (4, 0), false, false), ("q_p", (8, 0), false, true)),
  (("q_0", "q_i=q_j", "x", (:)), ("q_i=q_j", "q_i=q_j", "y", (:)), ("q_i=q_j", "q_p", "z", (:))),
  rayon: nom => if nom == "q_i=q_j" { 1 } else { 0.6 },
)
#slides-only[== Preuve : répéter le cycle]
On a $abs(x y) = j ≤ n$ et $abs(y) = j - i > 0$.
Répéter le cycle $k$ fois donne un chemin acceptant d'étiquette $x y^k z$, y compris pour $k = 0$.

#slides-only[== Utiliser le lemme]
*Attention* : la réciproque est fausse. On ne choisit pas la décomposition $x y z$.

Pour montrer que $L$ n'est pas reconnaissable :
+ Supposer qu'un automate à $n$ états reconnaît $L$.
+ Choisir $u ∈ L$ avec $abs(u) ≥ n$.
+ Pour toute décomposition respectant le lemme, trouver un $k$ tel que $x y^k z ∉ L$.

#slides-only[== Langages non reconnaissables]
#exercise[
  Montrer que les langages suivants ne sont pas reconnaissables :
  + $L_1 = {a^n b^n ∣ n ∈ ℕ}$
  + $L_2 = {a^n b^p ∣ n, p ∈ ℕ, #sep n ≠ p}$
]
#solution[
  == Correction : autant de a que de b
  Supposer que $L_1$ est reconnu par un automate à $n ≥ 1$ états.
  Prendre $u = a^n b^n$. Comme $abs(x y) ≤ n$, on a $y = a^j$ avec $j > 0$.
  Alors $x z = a^(n - j) b^n ∉ L_1$, contradiction pour $k = 0$.

  == Correction : des nombres différents
  Si $L_2$ était reconnaissable, $a^* b^* ∖ L_2 = L_1$ le serait aussi par stabilité par différence.
]

#underline[Remarque] :
- Les automates sont sans mémoire : le choix d'une transition dépend uniquement de l'état actuel et de la lettre lue, pas du chemin déjà parcouru. Ils ne peuvent donc pas compter.
- ${a^n b^p | n ≡ p mod 2}$ est reconnaissable car il suffit de mémoriser la parité du nombre de $a$ et de $b$ lus (2 états suffisent) et pas une infinité de valeurs possibles.
