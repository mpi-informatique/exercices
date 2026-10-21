#import "/load.typ": article-only, cours-et-presentation, taille-presentation, item-by-item, only, pause, slides-only, solution
#import "/load.typ": automate, theoremes
#import theoremes: corollaire, definition, exercice, lemme, probleme, propriete, theoreme
#import "/load.typ": sep, widetilde, colonnes-cours

#import automate: Lreg

#show: cours-et-presentation.with(titre: "Langages réguliers", niveau: "MPI")

#slides-only[
  == Motivation des langages formels

  Recherche d'un motif dans un texte.

  #align(center, image("langages-reguliers/regexp-mail.jpeg", width: 70%))
  #align(center, text(size: 0.7em)[Recherche d'une adresse électronique dans Visual Studio Code])
]

= Alphabet et mot

#slides-only[== Alphabet, mot]

#definition(item-by-item[
  - Un _alphabet_ est un ensemble $Σ$ fini de lettres.
  - #taille-presentation(0.92em)[Un _mot_ $m$ de $Σ$ est une suite finie $m_1, …, m_n$ de lettres de $Σ$, noté $m = m_1 … m_n$.]
  - La _taille_ $abs(m)$ de $m$ est son nombre de lettres.
  - Le _mot vide_, ne contenant aucune lettre, est noté $ε$.
  - Des mots $u = u_1 … u_n$ et $v = v_1 … v_p$ de $Σ$ sont _égaux_ si $n = p$ et : $forall i ∈ [|1, n|]$, $u_i = v_i$.
  - On note $Σ^*$ l'ensemble des mots sur $Σ$ et $Σ^+ = Σ^* ∖ {ε}$.
])

#underline[Attention] : $ε$ est un mot, pas une lettre.

#slides-only[== Concaténation et puissance]

#definition[
  - La _concaténation_ de deux mots $u = u_1 … u_n$ et $v = v_1 … v_p$ est $u v = u_1 … u_n v_1 … v_p$.
  - Si $u in Σ^*$, on définit ses _puissances_ par récurrence $u^0 = ε$ et $u^k = u u^(k - 1)$ pour $k ≥ 1$.
]

#slides-only[== Une équation sur les mots]

#exercice[
  Soient $Σ$ un alphabet, $a, b ∈ Σ$ et $u ∈ Σ^*$ tels que $a u = u b$.
  Montrer que $a = b$ et : $exists k ∈ ℕ, u = a^k$.
]

#slides-only[== Monoïdes et taille (hors programme)]

#exercice(titre: [Monoïdes et taille])[
  Un _monoïde_ est un ensemble muni d'une loi associative et d'un élément neutre.
  Un _morphisme_ de $(Σ^*, ⋅)$ vers $(ℕ, +)$ est une application $f$ telle que
  $f(ε) = 0$ et $f(u v) = f(u) + f(v)$ pour tous $u, v ∈ Σ^*$.

  + Montrer que $(Σ^*, ⋅)$ et $(ℕ, +)$ sont des monoïdes.
  + Montrer que la taille $u ↦ abs(u)$ est un morphisme.
  + Montrer qu'un morphisme $f$ est entièrement déterminé par les poids $p_a = f(a)$ des lettres $a ∈ Σ$, et que tout choix de poids dans $ℕ$ convient.
  + Quand la valeur $f(u)$ dépend-elle uniquement de $abs(u)$ ?
]

#solution[
  #slides-only[== Monoïdes et taille — correction]

  + La concaténation est associative et admet $ε$ pour élément neutre.
    L'addition est associative et admet $0$ pour élément neutre.
  + On a $abs(ε) = 0$ et $abs(u v) = abs(u) + abs(v)$.
  + Pour $u = a_1 … a_n$, la propriété de morphisme impose
    $ f(u) = sum_(i=1)^n p_(a_i). $
    Cette formule définit réciproquement un morphisme : la somme vide vaut $0$ et la concaténation juxtapose les deux sommes.
  + Si $f(u)$ dépend uniquement de $abs(u)$, toutes les lettres, de taille $1$, ont le même poids $c$.
    Réciproquement, si tous les poids valent $c$, alors $f(u) = c abs(u)$.
    Si $Σ$ est vide, le seul mot est $ε$ et la propriété est immédiate.
]

#slides-only[== Préfixe, suffixe, facteur, sous-mot]

#definition[
  Soient $u$ et $m$ deux mots sur $Σ$.
  - $u$ est un _préfixe_ de $m$ s'il existe un mot $v$ tel que $m = u v$.
  - $u$ est un _suffixe_ de $m$ s'il existe un mot $v$ tel que $m = v u$.
  - $u$ est un _facteur_ (_substring_ en anglais) de $m$ s'il existe des mots $v, w$ tels que $m = v u w$.
  - $u$ est un _sous-mot_ (_subsequence_ en anglais) de $m$ si $u$ est une sous-suite, ou suite extraite, de $m$.
]

#underline[Exemple] : $a b c$ est un sous-mot de $a a b a c b$, mais pas un facteur.

#slides-only[
  == Dénombrement des préfixes et des sous-mots

  #exercice[
    Soit $m$ un mot de taille $n$ dont toutes les lettres sont différentes.
    Quel est son nombre de préfixes, de suffixes, de facteurs et de sous-mots ?

    Et si des lettres peuvent être répétées ?
  ]
]

#slides-only[== Implémentation d'un mot avec une chaîne de caractères]

Rappels d'utilisation d'une chaîne de caractères (```ocaml string```) :

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  [
    *OCaml*
    ```ocaml
    let s = "abc" (* définit une chaîne de caractères *)
    s.[1] (* donne 'b' *)
    String.length s (* donne 3 *)
    "abc" ^ "def" (* concaténation *)
    ```
  ],
  [
    *C*
    ```c
    #include <string.h>
    char s[7] = "abc";
    s[1]; // donne 'b'
    strlen(s); // donne 3
    strcat(s, "def"); // s vaut "abcdef"
    ```
  ],
)

En OCaml, contrairement à ```ocaml array```, le type ```ocaml string``` est immuable/persistant : on ne peut pas modifier un caractère d'une chaîne.

#slides-only[== Reconnaissance d'un sous-mot]

#exercice[
  1. Écrire une fonction ```ocaml sous_mot : string -> string -> bool``` testant si un mot est un sous-mot d'un autre.
  2. Connaissez-vous des algorithmes plus efficaces ?
]

= Langage

#slides-only[== Langage sur un alphabet]

#definition[
  Un _langage_ $L$ sur un alphabet $Σ$ est un ensemble de mots sur $Σ$.
]
De façon équivalente, $L$ est un langage si $L ⊂ Σ^*$, ou encore $L ∈ cal(P)(Σ^*)$.

#slides-only[== Exemples de langages]

#underline[Exemples] :
+ L'ensemble $L_0 = {ε, a, b a b}$ sur $Σ = {a, b}$.
+ L'ensemble $L_1$ des mots d'un dictionnaire ne contenant que des lettres minuscules non accentuées, sur $Σ = {a, b, …, z}$.
+ L'ensemble $L_2$ des formules arithmétiques sur $Σ = {0, …, 9, "+", "-", "/", "*", "(", ")"}$.
+ L'ensemble $L_3$ des programmes OCaml sur $Σ = {a, …, z, "_", "!", "<", ">", …}$.

#slides-only[
  == Problèmes algorithmiques

  #probleme[
    Étant donné un langage $L$ et un mot $m$, est-ce que $m ∈ L$ ?
  ]
  *Applications* : correcteur orthographique, coloration syntaxique.

  #pause
  #probleme[
    Étant donné un texte $s$ et un langage $L$, $s$ contient-il un mot de $L$ ?
    Cas particulier $L = {m}$ : le mot $m$ apparaît-il dans le texte $s$ ?
  ]
  #underline[Application] : recherche d'un motif, par exemple une adresse électronique ou une séquence d'ADN.
]

= Opérations sur les langages

== Concaténation de langages

#definition[
  Soient $L_1$ et $L_2$ deux langages sur le même alphabet.
  Leur concaténation est :
  $ L_1 L_2 = {m_1 m_2 ∣ m_1 ∈ L_1, #sep m_2 ∈ L_2}. $
]
$L_1 L_2$ est l'ensemble des mots obtenus par concaténation d'un mot de $L_1$ et d'un mot de $L_2$.

#slides-only[== Calcul d'une concaténation]

#exercice[
  + Soit $L_1 = {a, a b}$ et $L_2 = {ε, b, b b a}$. Déterminer $L_1 L_2$.
  + Quel lien a-t-on entre $abs(L_1 L_2)$ et $abs(L_1) abs(L_2)$ dans le cas général ?
]

#slides-only[== Propriétés de la concaténation]

#exercice[
  + La concaténation de deux langages est-elle commutative ? Associative ?
  + Quel est son élément neutre ? Son élément absorbant ?
]
#pause
La concaténation est distributive par rapport à l'union :
$ L_1 (L_2 ∪ L_3) = L_1 L_2 ∪ L_1 L_3. $

== Puissance d'un langage

#definition[
  On définit la _puissance_ $L^n$ du langage $L$ par récurrence :
  $
    L^0 & = {ε}, \
    L^n & = L^(n - 1) L " pour " n ≥ 1.
  $
]
Pour $n ≥ 1$ :
$ L^n = underbrace(L … L, n " facteurs") = {m_1 … m_n ∣ m_1 ∈ L, …, m_n ∈ L}. $

#underline[Exemple] : $Σ^n$ est l'ensemble des mots de taille $n$ sur l'alphabet $Σ$.

#slides-only[== Puissance et inclusion]

#exercice[
  Soit $L$ un langage.
  + Montrer que $L ⊂ L^2$ si et seulement si $L = ∅$ ou $ε ∈ L$.
  + Comparer $L^2$ et ${u^2 ∣ u ∈ L}$.
]

== Étoile de Kleene

#definition[
  On définit l'_étoile de Kleene_ $L^*$ d'un langage $L$ par :
  $ L^* = display(union.big_(k ∈ ℕ)) L^k. $
]
$L^*$ est donc l'ensemble des mots obtenus par concaténation d'un nombre quelconque de mots de $L$. \
$L^*$ contient toujours $ε$, car $L^0 = {ε}$.

#pause
#exercice[
  Montrer que $(L^*)^* = L^*$.
]

= Langages réguliers

#slides-only[== Définition des langages réguliers]

#definition(coeur: true)[
  L'ensemble des _langages réguliers_ sur $Σ$ est le plus petit ensemble, pour l'inclusion, contenant les langages finis sur $Σ$ et stable par union, concaténation et étoile de Kleene.
]

#slides-only[== Définition inductive équivalente]

#definition(coeur: true)[
  - Tout langage fini est régulier.
  - Si $L_1$ et $L_2$ sont réguliers, alors $L_1 ∪ L_2$ est régulier.
  - Si $L_1$ et $L_2$ sont réguliers, alors $L_1 L_2$ est régulier.
  - Si $L$ est régulier, alors $L^*$ est régulier.
]

#slides-only[== Unions et concaténations finies]

#propriete[
  Par récurrence immédiate, si $L_1, …, L_n$ sont réguliers, alors $L_1 ∪ … ∪ L_n$ et $L_1 L_2 … L_n$ sont réguliers.
]

#underline[Attention] :
- Une union infinie de langages réguliers n'est pas forcément régulière.
- Un langage particulier n'est pas forcément stable par concaténation.

#slides-only[== Exemples de langages réguliers]

+ Soit $m$ un mot. Alors ${m}$ est fini, donc régulier. On le note aussi $m$ par abus de notation.
#pause
+ $Σ$ est fini, donc régulier. Par conséquent, $Σ^*$ est également régulier.
#pause
+ L'ensemble des mots ayant $m$ comme facteur est égal à $Σ^* m Σ^*$, donc régulier.
#pause
+ Si $m = m_1 … m_n$, l'ensemble des mots ayant $m$ comme sous-mot est égal à $Σ^* m_1 Σ^* m_2 … Σ^* m_n Σ^*$, donc régulier.

#slides-only[== Construction de langages réguliers]

#exercice[
  Montrer que les langages suivants sont réguliers sur $Σ = {a, b}$ :
  #colonnes-cours(
    [
      + Mots commençant par $a$.
      + Mots commençant par $a$ et finissant par $b$.
    ],
    [
      #enum(start: 3)[Mots de taille paire.][Mots de taille impaire.]
    ],
  )
]

= Expressions régulières

== Définition des expressions régulières

Les expressions régulières sont une notation plus concise pour représenter un langage régulier.

#definition[
  L'ensemble $cal(R)(Σ)$ des _expressions régulières_ sur $Σ$ est le plus petit ensemble vérifiant :
  - $∀ a ∈ Σ, #sep a ∈ cal(R)(Σ)$
  - $∅ ∈ cal(R)(Σ)$ et $ε ∈ cal(R)(Σ)$
  - Si $e_1, e_2 ∈ cal(R)(Σ)$, alors $(e_1 | e_2) ∈ cal(R)(Σ)$ et $(e_1 e_2) ∈ cal(R)(Σ)$.
  - Si $e ∈ cal(R)(Σ)$, alors $e^* ∈ cal(R)(Σ)$.
]

#slides-only[== Notations et exemples]

- On utilise seulement les parenthèses nécessaires : $(((a b) c) | d)$ sera noté $a b c | d$.
- On utilise parfois $+$ à la place de $|$.
- $a^*$, $(a | a b a)^*$ et $a (a | b)^* b$ sont des expressions régulières.

== Représentation en OCaml

On peut représenter informatiquement les expressions régulières par le type :

#let type-regexp = ```ocaml
type 'a regexp = (* 'a est le type des lettres de l'alphabet *)
  | Vide | Epsilon | L of 'a (* L a désigne la lettre a *)
  | Union of 'a regexp * 'a regexp
  | Concat of 'a regexp * 'a regexp
  | Etoile of 'a regexp
```
#type-regexp

#slides-only[
  #pause
  Par exemple, $a (a | b)^* b$ est représenté par :
  ```ocaml
  Concat(L 'a', Concat(Etoile(Union(L 'a', L 'b')), L 'b'))
  ```

  == Lettres d'une expression régulière

  #type-regexp

  #exercice[
    Écrire une fonction ```ocaml lettres : 'a regexp -> 'a list``` qui renvoie la liste des lettres utilisées dans une expression régulière.
  ]
]

== Langage d'une expression régulière

#definition[
  Le _langage_ $cal(L)(e)$ d'une expression régulière $e$ est défini récursivement :
  - $cal(L)(a) = {a}$ si $a ∈ Σ$.
  - $cal(L)(∅) = ∅$ et $cal(L)(ε) = {ε}$
  - $cal(L)(e | e') = cal(L)(e) ∪ cal(L)(e')$
  - $cal(L)(e e') = cal(L)(e) cal(L)(e')$
  - $cal(L)(e^*) = cal(L)(e)^*$
]

#slides-only[== Langages réguliers et expressions régulières]

Par abus de langage, on confond souvent $e$ et $cal(L)(e)$.
Ainsi, suivant le contexte, $a$ peut désigner une lettre, un mot de taille $1$ ou un langage singleton.\
Une expression régulière décrit de façon compacte la construction d'un langage régulier à l'aide de l'union, de la concaténation et de l'étoile de Kleene.
Cette notation est à la base des moteurs d'expressions régulières utilisés dans les éditeurs de texte.

#pause
#theoreme[
  Un langage $L$ est régulier si et seulement s'il existe une expression régulière $e$ telle que $L = cal(L)(e)$.
]

#slides-only[== Exemples de langages associés]

Sur $Σ = {a, b}$ :
- $(a | b)^*$ représente l'ensemble de tous les mots, $Σ^*$.
#pause
- $(a | b)^* b b$ représente les mots finissant par $b b$.

== Résumé des définitions

*Exercice* : compléter la colonne « Ensemble » (ensemble auquel appartient l'objet donné en exemple).

#taille-presentation(0.75em)[
  #table(
    columns: (1.5fr, 0.65fr, 1.2fr, 1fr),
    align: left + horizon,
    inset: (x: 0.5em, y: 0.35em),
    table.header([*Description*], [*Notation*], [*Exemple*], [*Ensemble*]),
    [Lettre], [$a$], [$a$], [#completer()],
    [Alphabet], [$Σ$], [${a, b}$], [#completer()],
    [Mot vide], [$ε$], [$ε$], [#completer()],
    [Mot], [$m$], [$a b a$], [#completer()],
    [Langage], [$L$], [${ε, a, a b}$], [#completer()],
    [Expression régulière], [$e$], [$a b^*$], [#completer()],
    [Langage décrit par une expression régulière], [$cal(L)(e)$], [${a b^n | n ∈ ℕ}$], [#completer()],
    [Langages réguliers], [$Lreg$], [$Lreg$], [#completer()],
  )
]


#slides-only[== Recherche d'expressions régulières]

#exercice[
  Donner une expression régulière pour les langages suivants sur $Σ = {a, b}$ :
  #colonnes-cours(
    [
      + Mots contenant au plus un $a$.
      + Mots dont la taille est congrue à $1$ modulo $3$.
    ],
    [
      #enum(start: 3)[Mots contenant un nombre pair de $a$.][Mots contenant un nombre impair de $a$.]
    ],
  )

  Sur $Σ = {0, 1}$ :
  #enum(start: 5)[Écritures en base $2$ des entiers divisibles par $4$.]
]

= Équivalence d'expressions régulières

#slides-only[== Définition de l'équivalence]

#definition[
  Deux expressions régulières $e_1$ et $e_2$ sont dites _équivalentes_, ce que l'on note $e_1 ≡ e_2$, si elles définissent le même langage, c'est-à-dire si $cal(L)(e_1) = cal(L)(e_2)$.
]

#underline[Exemple] : $(a b)^* a ≡ a (b a)^*$.

#slides-only[== Propriétés à compléter]

#propriete[
  #let liste-a-completer(start: 1, ..items) = enum(start: start, ..items.pos().map(item => [#item #completer()]))
  Pour des expressions régulières $e$, $e_1$, $e_2$ et $e_3$, compléter :
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    align: top,
    liste-a-completer($e ∅ ≡$, $e ε ≡$, $e | ∅ ≡$, $∅^* ≡$),
    liste-a-completer(start: 5, $ε^* ≡$, $(e_1 | e_2) e_3 ≡$, $e_1 (e_2 e_3) ≡$),
  )
]

= Induction structurelle

== Induction sur les langages réguliers

#theoreme(coeur: true)[
  Soit $cal(P)(L)$ une propriété sur les langages réguliers telle que :
  - $cal(P)(L)$ est vraie pour les langages $L$ finis : cas de base.
  - $cal(P)(L_1) ∧ cal(P)(L_2) ==> cal(P)(L_1 L_2)$
  - $cal(P)(L_1) ∧ cal(P)(L_2) ==> cal(P)(L_1 ∪ L_2)$
  - $cal(P)(L) ==> cal(P)(L^*)$

  Alors $cal(P)(L)$ est vraie pour tout langage régulier $L$.
]
#solution[
  #pause
  L'ensemble ${L ∣ cal(P)(L)}$ contient les langages finis et est stable par union, concaténation et étoile de Kleene.
  Il contient donc tous les langages réguliers, par définition.
]

== Induction sur les expressions régulières

#theoreme(coeur: true)[
  Soit $cal(P)(e)$ une propriété sur les expressions régulières telle que :
  - $cal(P)(∅)$ et $cal(P)(ε)$ sont vraies : cas de base.
  - $cal(P)(a)$ est vraie pour $a ∈ Σ$ : cas de base.
  - $cal(P)(e_1) ∧ cal(P)(e_2) ==> cal(P)(e_1 e_2)$
  - $cal(P)(e_1) ∧ cal(P)(e_2) ==> cal(P)(e_1 | e_2)$
  - $cal(P)(e) ==> cal(P)(e^*)$

  Alors $cal(P)(e)$ est vraie pour toute expression régulière $e$.
]

#slides-only[== Miroir d'un langage]

#exercice[
  On note $widetilde(m) = m_n … m_1$ le _miroir_ d'un mot $m = m_1 … m_n$ et $widetilde(L) = {widetilde(m) ∣ m ∈ L}$ celui d'un langage $L$.

  + Donner une expression régulière du miroir de $a (a | b)^* b$.
  + Soit $L$ un langage régulier. Montrer que $widetilde(L)$ est régulier.
  + Écrire une fonction OCaml ```ocaml miroir : 'a regexp -> 'a regexp``` renvoyant le miroir d'une expression régulière.
]

#slides-only[
  == Méthodes de démonstration

  - Pour montrer une égalité de deux mots, on peut faire une récurrence sur la taille du mot.
  - Pour montrer une égalité de deux langages, on peut montrer une double inclusion.

  #exercice[
    Soient $e_1$ et $e_2$ deux expressions régulières.
    Montrer que $(e_1^* e_2)^* e_1^* ≡ (e_1 | e_2)^*$.
  ]

  = Expressions régulières en pratique (non exigible)

  == Recherche avec grep

  ```sh grep -E``` est une commande qui permet de chercher des motifs dans un texte en utilisant des expressions régulières étendues :

  #table(
    columns: (auto, 1fr),
    inset: 0.5em,
    table.header([*Expression*], [*Signification*]),
    [`.`], [N'importe quel caractère.],
    [`[aei]`], [Un caractère parmi `a`, `e`, `i`.],
    [`[a-z]`], [Un caractère entre `a` et `z`.],
    [`[^aei]`], [Un caractère différent de `a`, `e`, `i`.],
  )

  = Complément : dénombrabilité et langages non réguliers

  == Dénombrabilité des mots

  Soit $Σ$ un alphabet non vide.

  #theoreme[
    $Σ^+$, et donc aussi $Σ^*$, est infini dénombrable.
  ]
  #pause
  *Preuve* : identifier les $p$ lettres de $Σ$ avec les entiers de $1$ à $p$.
  L'écriture en base $p + 1$ donne une injection de $Σ^+$ vers $ℕ$.
  L'ensemble est infini puisqu'il contient les mots $a^n$ pour $n ≥ 1$, avec $a ∈ Σ$.

  #pause
  #corollaire[
    Un langage $L ⊂ Σ^*$ est au plus dénombrable.
  ]
  Par exemple, le langage des programmes OCaml est dénombrable.

  == Théorème de Cantor

  #theoreme[
    Un ensemble $E$ ne peut pas être en bijection avec $cal(P)(E)$.
  ]
  #pause
  *Preuve* : si $f : E → cal(P)(E)$, alors $Y = {x ∈ E ∣ x ∉ f(x)}$ n'a pas d'antécédent par $f$.

  #pause
  #corollaire[
    Pour $Σ$ non vide, l'ensemble $cal(P)(Σ^*)$ des langages sur $Σ$ n'est pas dénombrable.
  ]

  == Limites des algorithmes de reconnaissance

  L'ensemble des langages est indénombrable alors que l'ensemble des programmes OCaml est dénombrable.
  Il existe donc des langages $L$ pour lesquels aucun algorithme ne résout le problème suivant :

  #probleme[
    Étant donné un mot $m$, est-ce que $m ∈ L$ ?
  ]
  On se restreint donc à un ensemble plus simple de langages.

  == Dénombrabilité des langages réguliers

  Soit $Σ$ un alphabet non vide.

  #theoreme[
    L'ensemble des langages réguliers sur $Σ$ est infini dénombrable.
  ]
  #pause
  *Preuve* : l'ensemble des expressions régulières sur $Σ$ est dénombrable, car c'est un langage sur un alphabet fini.
  L'ensemble des langages réguliers est donc au plus dénombrable.
  Si $a ∈ Σ$, les langages ${a^n}$, pour $n ∈ ℕ$, sont réguliers et deux à deux distincts.

  == Existence de langages non réguliers

  Comme l'ensemble des langages sur $Σ$ est indénombrable :

  #corollaire[
    Il existe des langages non réguliers sur $Σ$.
  ]
  On verra plus tard comment montrer qu'un langage n'est pas régulier.
]
