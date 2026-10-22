#import "/load.typ": slide
#import "/load.typ": cours-et-presentation, solution, taille-presentation, article-only, item-by-item, only, pause, slides-only
#import "/load.typ": automate, theoremes, completer
#import theoremes: corollaire, definition, exercice, lemme, probleme, propriete, theoreme
#import "/load.typ": sep, widetilde, colonnes-cours, liste-a-completer
#import automate: Lreg, LL

#show: cours-et-presentation.with(titre: "Langages réguliers", niveau: "MPI")

#slides-only[
  = Motivation

  Recherche d'un motif (expression régulière) dans un texte :

  #align(center, image("langages-reguliers/regexp-mail.jpeg", width: 70%))
  #align(center, text(size: 0.7em)[Recherche d'une adresse électronique dans Visual Studio Code])
]

= Alphabet et mot

#definition(item-by-item[
  - Un _alphabet_ est un ensemble $Σ$ fini de lettres.
  - #taille-presentation(0.92em)[Un _mot_ $m$ de $Σ$ est une suite finie $m_1, …, m_n$ de lettres de $Σ$, noté $m = m_1 … m_n$.]
  - La _taille_ $abs(m)$ de $m$ est son nombre de lettres.
  - Le _mot vide_, ne contenant aucune lettre, est noté $ε$.
  - Des mots $u = u_1 … u_n$ et $v = v_1 … v_p$ de $Σ$ sont _égaux_ si $n = p$ et : $forall i ∈ [|1, n|]$, $u_i = v_i$.
  - On note $Σ^*$ l'ensemble des mots sur $Σ$ et $Σ^+ = Σ^* ∖ {ε}$.
])

#underline[Attention] : $ε$ est un mot, pas une lettre.

#slide()

#definition[
  - La _concaténation_ de deux mots $u = u_1 … u_n$ et $v = v_1 … v_p$ est : $ u v = u_1 … u_n v_1 … v_p $
  - Si $u in Σ^*$, on définit ses _puissances_ par récurrence $u^0 = ε$ et $u^k = u u^(k - 1)$ pour $k ≥ 1$.
]

#underline[Remarque] : 
- $(Σ^*, ⋅)$ est un monoïde : la concaténation est associative et $ε$ est élément neutre
- $u ⟼ abs(u)$ est un morphisme de $(Σ^*, ⋅)$ vers $(ℕ, +)$ : $|u v| = |u| + |v|$.

#slide()

#exercice([Théorème de Lévy])[
  Soient $Σ$ un alphabet, $a, b ∈ Σ$ et $u ∈ Σ^*$ tels que $a u = u b$. #slides-only[\ ]
  Montrer que $a = b$ et : $exists k ∈ ℕ, #sep u = a^k$.
]

#slide()

#definition[
  Soient $u$ et $m$ deux mots sur $Σ$.
  - $u$ est un _préfixe_ de $m$ s'il existe un mot $v$ tel que $m = u v$.
  - $u$ est un _suffixe_ de $m$ s'il existe un mot $v$ tel que $m = v u$.
  - $u$ est un _facteur_ (_substring_ en anglais) de $m$ s'il existe des mots $v, w$ tels que $m = v u w$.
  - $u$ est un _sous-mot_ (_subsequence_ en anglais) de $m$ si $u$ est une sous-suite (ou : suite extraite) de $m$.
]

#underline[Exemple] : $a b c$ est un sous-mot de $a a b a c b$, mais pas un facteur.

#slide()
#exercice[
  Soit $m$ un mot de taille $n$ dont toutes les lettres sont différentes.
  + Quel est son nombre de préfixes, de suffixes, de facteurs et de sous-mots ?
  + Et si des lettres peuvent être répétées ?
]

== Chaînes de caractères en C et en OCaml
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  [
    ```c
    #include <string.h> // tableau de char
    char s[4] = "abc"; // le dernier caractère est '\0'
    s[1]; // donne 'b'
    s[1] = 'd'; // ok : s est mutable
    strlen(s); // donne 3
    ```
  ],
  [
    ```ocaml
    "abc" ^ "def" (* concaténation *)
    let s = "abc" (* type string *)
    s.[1] (* donne 'b' *)
    s.[1] <- 'd' (* erreur : string est immuable *)
    String.length s (* donne 3 *)
    ```
  ],
)

#slide()

#exercice[
  + Écrire une fonction ```c int facteur(char *, char *)``` testant si le premier mot est un facteur du deuxième.
  + Écrire une fonction ```ocaml sous_mot : string -> string -> bool``` testant si le premier mot est un sous-mot du deuxième.
  + Donner deux algorithmes de MP2I pour chercher un facteur dans un mot. 
]

= Langage


#definition[
  Un _langage_ $L$ sur un alphabet $Σ$ est un ensemble de mots sur $Σ$, c'est-à-dire $L ⊂ Σ^*$ ou encore $L ∈ cal(P)(Σ^*)$
]
Le nombre de langages sur $Σ$ est : #completer()
#slide()

#underline[Exemples] :
+ L'ensemble $L_0 = {ε, a, b a b}$ sur $Σ = {a, b}$.
+ L'ensemble $L_1$ des mots d'un dictionnaire ne contenant que des lettres minuscules non accentuées, sur $Σ = {a, b, …, z}$.
+ L'ensemble $L_2$ des formules arithmétiques sur $Σ = {0, …, 9, "+", "-", "/", "*", "(", ")"}$.
+ L'ensemble $L_3$ des programmes OCaml sur $Σ = {a, …, z, "_", "!", "<", ">", …}$.

== Concaténation

#definition[
  La _concaténation_ de deux langages $L_1$ et $L_2$ est : $L_1 L_2 = {m_1 m_2 ∣ m_1 ∈ L_1, #sep m_2 ∈ L_2}$.
]

#slide()

#exercice[
  + Soit $L_1 = {a, a b}$ et $L_2 = {ε, b, b b a}$. Déterminer $L_1 L_2$.
  + Quel lien a-t-on entre $abs(L_1 L_2)$ et $abs(L_1) abs(L_2)$ dans le cas général ?
]

#slide()

#exercice[
  + La concaténation de deux langages est-elle commutative ? Associative ?
  + Quel est son élément neutre ? Son élément absorbant ?
  + La concaténation est-elle distributive par rapport à l'union ? Et inversement ?
]

== Puissance

#definition[
  Si $L ⊂ Σ^*$, on définit sa _puissance_ par récurrence $L^0 = {ε}$ et $L^k = L L^(k - 1)$ pour $k ≥ 1$.
]
Pour $n ≥ 1$ :
$ L^n = underbrace(L … L, n " facteurs") = {m_1 … m_n ∣ m_1 ∈ L, …, m_n ∈ L}. $

#underline[Exemple] : $Σ^n$ est l'ensemble des mots de taille $n$ sur l'alphabet $Σ$.

#slide()

#exercice[
  + Montrer que $L ⊂ L^2$ si et seulement si $L = ∅$ ou $ε ∈ L$.
  + Comparer $L^2$ et ${u^2 ∣ u ∈ L}$.
]

== Étoile de Kleene

#definition[
  L'_étoile de Kleene_ d'un langage $L$ est $L^* = display(union.big_(k ∈ ℕ)) L^k$.
]
$L^*$ est donc l'ensemble des mots obtenus par concaténation d'un nombre quelconque de mots de $L$. \
#underline[Remarque] : $L^*$ contient toujours $ε$, car $L^0 = {ε}$.

#pause
#exercice[
  + Montrer que $(L^*)^* = L^*$.
  + Montrer que $L^* = L$ si et seulement si $L$ est un sous-monoïde de $Σ^*$, c'est-à-dire $L$ stable par concaténation et $ε ∈ L$.
]

= Langages réguliers


#definition(coeur: true)[
  L'ensemble $Lreg(Σ)$, ou simplement $Lreg$, des _langages réguliers_ sur $Σ$ est le plus petit ensemble, pour l'inclusion, contenant les langages finis sur $Σ$ et stable par union, concaténation et étoile de Kleene.
]

#slide()

En particulier :
- Si $L$ est un langage fini alors $L ∈ Lreg$.
- Si $L_1$ et $L_2$ sont réguliers alors $L_1 ∪ L_2 ∈ Lreg$.
- Si $L_1$ et $L_2$ sont réguliers alors $L_1 L_2 ∈ Lreg$.
- Si $L$ est régulier alors $L^* ∈ Lreg$.

#exercice[
  Montrer qu'on peut remplacer « contenant les langages finis sur $Σ$ » par « $∅ ∈ Lreg, {ε} ∈ Lreg$ et ${a} ∈ Lreg, #sep ∀a ∈ Σ$ ».
]

#slide()

#propriete[
  Si $L_1, …, L_n$ sont réguliers alors $L_1 ∪ … ∪ L_n$ et $L_1 … L_n$ sont réguliers.
]

#underline[Attention] :
- Une union infinie de langages réguliers n'est pas forcément régulière.
- Un langage particulier n'est pas forcément stable par concaténation.

#slide()

#underline[Exemple] : 
+ Soit $m$ un mot. Alors ${m}$ est fini, donc régulier. On le note aussi $m$ par abus de notation.
#pause
+ $Σ$ est fini donc régulier. Donc $Σ^*$ est régulier.
#pause
+ L'ensemble des mots ayant $m$ comme facteur est égal à $Σ^* m Σ^*$, donc régulier.
#pause
+ Si $m = m_1 … m_n$, l'ensemble des mots ayant $m$ comme sous-mot est égal à $Σ^* m_1 Σ^* m_2 … Σ^* m_n Σ^*$, donc régulier.

#slide()

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

Les expressions régulières sont une notation plus concise pour représenter un langage régulier.

#definition[
  L'ensemble $cal(R)(Σ)$ des _expressions régulières_ sur $Σ$ est le plus petit ensemble vérifiant :
  - $∀ a ∈ Σ, #sep a ∈ cal(R)(Σ)$
  - $∅ ∈ cal(R)(Σ)$ et $ε ∈ cal(R)(Σ)$
  - Si $e_1, e_2 ∈ cal(R)(Σ)$, alors $(e_1 | e_2) ∈ cal(R)(Σ)$ et $(e_1 e_2) ∈ cal(R)(Σ)$.
  - Si $e ∈ cal(R)(Σ)$, alors $e^* ∈ cal(R)(Σ)$.
]

#slide()

#underline[Exemple] : $a^*$, $(a | a b a)^*$ et $a (a | b)^* b$ sont des expressions régulières.

#underline[Remarque] : 
- On utilise seulement les parenthèses nécessaires : $(((a b) c) | d)$ sera noté $a b c | d$.
- On utilise parfois $+$ à la place de $|$.

== Représentation en OCaml

On peut représenter informatiquement les expressions régulières par le type :

```ocaml
type 'a regexp = (* 'a est le type des lettres de l'alphabet *)
  | Vide | Epsilon | L of 'a (* L a désigne la lettre a *)
  | Union of 'a regexp * 'a regexp
  | Concat of 'a regexp * 'a regexp
  | Etoile of 'a regexp
```

#slide()

#definition[
  Le _langage_ $LL(e)$ dénoté par une expression régulière $e$ est défini récursivement :
  - $LL(a) = {a}$ si $a ∈ Σ$.
  - $LL(∅) = ∅$ et $LL(ε) = {ε}$
  - $LL(e | e') = LL(e) ∪ LL(e')$
  - $LL(e e') = LL(e) LL(e')$
  - $LL(e^*) = LL(e)^*$
]

#slide()

Par abus de langage, on confond $e$ et $LL(e)$.
Ainsi, suivant le contexte, $a$ peut désigner une lettre, un mot de taille $1$ ou un langage singleton.\
Une expression régulière décrit de façon plus simple et compacte un langage régulier à l'aide de l'union, de la concaténation et de l'étoile de Kleene.
Cette notation est utilisés dans les éditeurs de texte.

#pause
#theoreme[
  Un langage $L$ est régulier si et seulement s'il existe une expression régulière $e$ telle que $L = LL(e)$.
]

#slide()

#exercice[
  Donner une expression régulière pour les langages suivants sur $Σ = {a, b}$ :
  #colonnes-cours(
    [
      + Mots contenant au plus un $a$.
      + Mots dont la taille est congrue à $1$ modulo $3$.
      + Mots contenant un nombre pair de $a$.
    ],
    [
      #enum(start: 4)[Mots contenant un nombre impair de $a$.][Sur $Σ = {0, 1}$ : écritures en base $2$ des entiers divisibles par $4$.]
    ],
  )
]

== Résumé des définitions

#{
  let lignes = (
    ([Lettre], [$a$], [$a$], [$Σ$]),
    ([Alphabet], [$Σ$], [${a, b}$], [$cal(P)(Σ)$]),
    ([Mot vide], [$ε$], [$ε$], [$Σ^*$]),
    ([Mot], [$m$], [$a b a$], [$Σ^*$]),
    ([Langage], [$L$], [${ε, a, a b}$], [$cal(P)(Σ^*)$]),
    ([Expression régulière], [$e$], [$a b^*$], [$cal(R)(Σ)$]),
    ([Langage d'une expression régulière], [$LL(e)$], [${a b^n | n ∈ ℕ}$], [$Lreg(Σ)$]),
    ([Langages réguliers], [$Lreg$], [$Lreg$], [$cal(P)(cal(P)(Σ^*))$]),
  )
  let reponse(contenu) = if sys.inputs.at("format", default: "cours") == "presentation" {
    [#pause #contenu]
  } else if sys.inputs.at("corrige", default: "false") == "true" {
    contenu
  } else {
    completer()
  }
  table(
    columns: (1.5fr, 0.65fr, 1.2fr, 1fr),
    align: center + horizon,
    inset: (x: 0.5em, y: 0.35em),
    table.header([*Description*], [*Notation*], [*Exemple*], text(size: 0.89em)[*Ensemble d'appartenance*]),
    ..lignes.map(ligne => ligne.slice(0, 3) + (reponse(ligne.last()),)).flatten(),
  )
}

= Équivalence d'expressions régulières


#definition[
  Deux expressions régulières $e_1$ et $e_2$ sont dites _équivalentes_, noté $e_1 ≡ e_2$, si $LL(e_1) = LL(e_2)$.
]

#underline[Exemple] : $(a b)^* a ≡ a (b a)^*$.

#slide()

#propriete[
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
  - $cal(P)(L)$ est vraie pour les langages $L$ finis
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
  - $cal(P)(∅)$ et $cal(P)(ε)$ sont vraies
  - $cal(P)(a)$ est vraie pour $a ∈ Σ$
  - $cal(P)(e_1) ∧ cal(P)(e_2) ==> cal(P)(e_1 e_2)$
  - $cal(P)(e_1) ∧ cal(P)(e_2) ==> cal(P)(e_1 | e_2)$
  - $cal(P)(e) ==> cal(P)(e^*)$

  Alors $cal(P)(e)$ est vraie pour toute expression régulière $e$.
]

#slide()

#exercice[
  On note $widetilde(m) = m_n … m_1$ le _miroir_ d'un mot $m = m_1 … m_n$ et $widetilde(L) = {widetilde(m) ∣ m ∈ L}$ celui d'un langage $L$.

  + Donner une expression régulière du miroir de $a (a | b)^* b$.
  + Soit $L$ un langage régulier. Montrer que $widetilde(L)$ est régulier.
  + Écrire une fonction OCaml ```ocaml miroir : 'a regexp -> 'a regexp``` renvoyant le miroir d'une expression régulière.
]

#slides-only[
  #slide()

  - Pour montrer une égalité de deux mots, on peut faire une récurrence sur la taille du mot.
  - Pour montrer une égalité de deux langages, on peut montrer une double inclusion.

  #exercice[
    Soient $e_1$ et $e_2$ deux expressions régulières.
    Montrer que $(e_1^* e_2)^* e_1^* ≡ (e_1 | e_2)^*$.
  ]

  = Expressions régulières en pratique (non exigible)


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

  #slide()

  #theoreme[
    Un ensemble $E$ ne peut pas être en bijection avec $cal(P)(E)$.
  ]
  #pause
  *Preuve* : si $f : E → cal(P)(E)$, alors $Y = {x ∈ E ∣ x ∉ f(x)}$ n'a pas d'antécédent par $f$.

  #pause
  #corollaire[
    Pour $Σ$ non vide, l'ensemble $cal(P)(Σ^*)$ des langages sur $Σ$ n'est pas dénombrable.
  ]

  #slide()

  L'ensemble des langages est indénombrable alors que l'ensemble des programmes OCaml est dénombrable.
  Il existe donc des langages $L$ pour lesquels aucun algorithme ne résout le problème suivant :

  #probleme[
    Étant donné un mot $m$, est-ce que $m ∈ L$ ?
  ]
  On se restreint donc à un ensemble plus simple de langages.

  #slide()

  Soit $Σ$ un alphabet non vide.

  #theoreme[
    L'ensemble des langages réguliers sur $Σ$ est infini dénombrable.
  ]
  #pause
  *Preuve* : l'ensemble des expressions régulières sur $Σ$ est dénombrable, car c'est un langage sur un alphabet fini.
  L'ensemble des langages réguliers est donc au plus dénombrable.
  Si $a ∈ Σ$, les langages ${a^n}$, pour $n ∈ ℕ$, sont réguliers et deux à deux distincts.

  #slide()

  Comme l'ensemble des langages sur $Σ$ est indénombrable :

  #corollaire[
    Il existe des langages non réguliers sur $Σ$.
  ]
  On verra plus tard comment montrer qu'un langage n'est pas régulier.
]
