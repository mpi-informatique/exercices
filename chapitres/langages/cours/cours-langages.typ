#import "/load.typ": est-corrige, est-presentation
#import "/load.typ": slide
#import "/load.typ": (
  article-only, cours-et-presentation, item-by-item, only, pause, slides-only, solution, taille-presentation,
)
#import "/load.typ": automate, completer, theoremes
#import theoremes: corollaire, definition, exercice, lemme, probleme, propriete, theoreme
#import "/load.typ": colonnes-cours, equation-slide, liste-a-completer, sep, widetilde
#import automate: LL, Lreg
#import "/load.typ": code
#import code: code-extrait

#let corrige-ocaml = read("langages-reguliers/corrige.ml")
#let corrige-c = read("langages-reguliers/corrige.c")

#show: cours-et-presentation.with(titre: "Langages réguliers", niveau: "MPI")

#slides-only[
  = Motivation

  Recherche d'un motif (expression régulière) dans un texte :

  #align(center, image("langages-reguliers/regexp-mail.jpeg", width: 70%))
  #align(center, text(size: 0.7em)[Recherche d'une adresse électronique dans Visual Studio Code])
]

= Alphabet et mot

#definition(item-by-item[
  - Un _alphabet_ est un ensemble $Σ$ fini, dont les éléments sont des _lettres_.
  - #taille-presentation(
      0.92em,
    )[Un _mot_ $m$ de $Σ$ est une suite finie $m_1, …, m_n$ de lettres de $Σ$, noté $m = m_1 … m_n$.]
  - La _taille_ $abs(m)$ de $m$ est son nombre de lettres.
  - Le _mot vide_, ne contenant aucune lettre, est noté $ε$.
  - Des mots $u = u_1 … u_n$ et $v = v_1 … v_p$ de $Σ$ sont _égaux_ si $n = p$ et : $forall i ∈ [|1, n|]$, $u_i = v_i$.
  - On note $Σ^*$ l'ensemble des mots sur $Σ$ et $Σ^+ = Σ^* ∖ {ε}$.
])

#underline[Attention] : $ε$ est un mot, pas une lettre.

#slide()

#definition[
  - La _concaténation_ de deux mots $u = u_1 … u_n$ et $v = v_1 … v_p$ est : #equation-slide($u v = u_1 … u_n v_1 … v_p$)
  - Si $u in Σ^*$, on définit sa _puissance_ par récurrence : $u^0 = ε$ et $u^k = u u^(k - 1)$ pour $k ≥ 1$.
]

#underline[Remarque] :
- $Σ^*$ muni de la concaténation est un _monoïde_ : la concaténation est associative et $ε$ est élément neutre.
- $u ⟼ abs(u)$ est un morphisme de $(Σ^*, ⋅)$ vers $(ℕ, +)$ : $|u v| = |u| + |v|$.

#slide()

#exercice[
  Soient $a, b ∈ Σ$ et $u ∈ Σ^*$ tels que $a u = u b$. #slides-only[\ ]
  Montrer que $a = b$ et : $exists k ∈ ℕ, #sep u = a^k$.
]
#solution[
  #slides-only[== Théorème de Lévy : preuve]
  Raisonnons par récurrence sur $abs(u)$.
  - Si $u = ε$, l'égalité donne $a = b$ et $u = a^0$.
  #pause
  - Sinon, en comparant les premières lettres de $a u$ et $u b$, on obtient $u = a v$.
    L'égalité $a a v = a v b$ donne $a v = v b$ après simplification par $a$.
    Par hypothèse de récurrence, $a = b$ et $v = a^k$, donc $u = a^(k + 1)$.
]

#slide()

#exercice[Lemme de Lévy][
  Soient $u, v, x, y ∈ Σ^*$ tels que $u v = x y$.
  Montrer qu'il existe un unique $m ∈ Σ^*$ vérifiant l'une des conditions suivantes :
  - $u = x m$ et $y = m v$
  - $x = u m$ et $v = m y$
]
#if est-presentation() and est-corrige() { slide() }
#solution[
  #slides-only[== Lemme de Lévy : preuve]
  Les bandes représentent le même mot $u v = x y$, avec deux découpages.
  Le morceau $m$ est celui situé entre les deux coupures.

  #{
    let bande(..cellules) = table(
      columns: (2fr, 1fr, 2fr),
      align: center,
      inset: (x: 6pt, y: 3pt),
      stroke: 0.5pt,
      ..cellules,
    )
    let morceau = table.cell(fill: rgb("#dceaf7"))[$m$]
    grid(
      columns: (1fr, 1fr),
      column-gutter: 1.5em,
      [
        *Si $abs(x) ≤ abs(u)$ :*
        #bande(
          table.cell(colspan: 2)[$u$], [$v$],
          [$x$], morceau, [$v$],
          [$x$], table.cell(colspan: 2)[$y$],
        )
        Les $abs(x)$ premières lettres donnent $u = x m$.
        Puis $x m v = x y$ donne $y = m v$.
      ],
      [
        *Si $abs(u) ≤ abs(x)$ :*
        #bande(
          [$u$], table.cell(colspan: 2)[$v$],
          [$u$], morceau, [$y$],
          table.cell(colspan: 2)[$x$], [$y$],
        )
        De même, $x = u m$.
        Puis $u v = u m y$ donne $v = m y$.
      ],
    )
  }

  Dans chaque cas, $m$ est l'unique suffixe du plus long des mots $u$ et $x$ de taille $abs(abs(u) - abs(x))$.
  Si $abs(u) = abs(x)$, les deux cas donnent $u = x$, $v = y$ et $m = ε$.
]

#slide()

#definition[
  Soient $u, m ∈ Σ^*$.
  - $u$ est un _préfixe_ de $m$ s'il existe un mot $v$ tel que $m = u v$.
  - $u$ est un _suffixe_ de $m$ s'il existe un mot $v$ tel que $m = v u$.
  - $u$ est un _facteur_ (_substring_ en anglais) de $m$ s'il existe des mots $v, w$ tels que $m = v u w$.
  - $u$ est un _sous-mot_ (_subsequence_ en anglais) de $m$ si $u$ est une sous-suite (ou : suite extraite) de $m$.
]

#underline[Exemple] : $a b c$ est un sous-mot de $a a b a c b$, mais pas un facteur.

#slide()
#exercice[
  Soit $m$ un mot de taille $n$ dont toutes les lettres sont différentes.
  + Quel est son nombre de préfixes, de suffixes, de facteurs et de sous-mots distincts, mot vide compris ?
  + Et si des lettres peuvent être répétées ?
]
#solution[
  #slides-only[== Compter les mots extraits]
  + Les préfixes et les suffixes sont déterminés par leur taille : il y en a $n + 1$ de chaque.
    Les facteurs non vides correspondent aux intervalles de positions, donc il y a $1 + n(n + 1) / 2$ facteurs.
    Les sous-mots correspondent aux parties des $n$ positions, donc il y en a $2^n$.
  #pause
  + Avec des répétitions, les préfixes et les suffixes restent distincts par leur taille.
    Plusieurs intervalles ou parties de positions peuvent donner le même mot.
    Il y a donc entre $n + 1$ et $1 + n(n + 1) / 2$ facteurs, et entre $n + 1$ et $2^n$ sous-mots.
    Le mot $a^n$ atteint les deux bornes inférieures.
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
#solution[
  #slides-only[== Recherche d'un facteur : corrigé]
  #taille-presentation(0.78em, code-extrait(corrige-c, "facteur", language: "c"))
  #pause
  Chaque position de départ est testée, y compris celle de fin si le motif est vide.
  Pour des tailles $n$ et $p$, le coût est $O(p + n + (p - n + 1) n)$ si $n ≤ p$, et $O(p + n)$ sinon, calcul des tailles compris.
]
#solution[
  #slides-only[== Recherche d'un sous-mot : corrigé]
  #taille-presentation(0.78em, code-extrait(corrige-ocaml, "sous_mot"))
  #pause
  On associe chaque lettre de $u$ à sa première occurrence disponible dans $v$ : choisir une occurrence plus tardive ne laisserait pas davantage de possibilités.
  Chaque appel avance dans $v$, donc le coût est $O(n + p)$, calcul des tailles compris.
  Pour chercher un facteur : recherche naïve et algorithme de Rabin–Karp.
]

= Langage


#definition[
  Un _langage_ $L$ sur un alphabet $Σ$ est un ensemble de mots sur $Σ$, c'est-à-dire $L ⊂ Σ^*$ ou encore $L ∈ cal(P)(Σ^*)$
]
Le nombre de langages sur $Σ$ est : #completer()
#solution[
  #pause
  Il y en a $2^(abs(Σ^*))$, puisque les langages sont les parties de $Σ^*$.
  Si $Σ = ∅$, alors $Σ^* = {ε}$ : il y a exactement deux langages.
  Sinon, $Σ^*$ est infini dénombrable et son ensemble de parties est indénombrable, comme on le verra dans le complément.
]
#slide()

#taille-presentation(0.85em)[
  #set par(justify: false)
  #figure(
    table(
      columns: (1fr, 1fr, 1fr, 1.2fr, 1.2fr),
      align: (left, center, center, center, center),
      inset: 0.4em,
      [*Description*], [$L_0 = {ε, a, b a b}$], [$L_1$ : mots du dictionnaire français], [$L_2$ : formules arithmétiques], [$L_3$ : programmes OCaml],
      [*Alphabet*], [${a, b}$], [${a, b, …, z}$], [${0, …, 9}$ \ $∪ {"+", "-", "/", "*"}$ \ $∪ {"(", ")"}$], [Lettres, chiffres, espaces, ponctuation…],
      [*Exemple de mot*], [$b a b$], [`chat`], [`(2+3)*4`], [`let x = 1`],
    ),
    caption: [Exemples de langages],
    numbering: none,
  )
]

== Concaténation

#definition[
  La _concaténation_ de deux langages $L_1$ et $L_2$ est : $L_1 L_2 = {m_1 m_2 ∣ m_1 ∈ L_1, #sep m_2 ∈ L_2}$.
]
#underline[Remarque] : La concaténation de langages est associative, d'élément neutre ${ε}$ et d'élément absorbant $∅$.

#slide()

#exercice[
  + Soit $L_1 = {a, a b}$ et $L_2 = {ε, b, b b a}$. Déterminer $L_1 L_2$ et $L_2 L_1$. Comparer.
  + Quel lien a-t-on entre $abs(L_1 L_2)$ et $abs(L_1) abs(L_2)$ dans le cas général ?
]
#solution[
  #slides-only[== Concaténation : corrigé]
  + $L_1 L_2 = {a, a b, a b b, a b b a, a b b b a}$, tandis que
    $L_2 L_1 = {a, a b, b a, b a b, b b a a, b b a a b}$.
    La concaténation n'est donc pas commutative.
  #pause
  + L'application $(u, v) ⟼ u v$ de $L_1 × L_2$ vers $L_1 L_2$ est surjective.
    Ainsi $abs(L_1 L_2) ≤ abs(L_1) abs(L_2)$.
    L'inégalité peut être stricte : ici $a ⋅ b = a b ⋅ ε$ et $abs(L_1 L_2) = 5 < 6$.
]

#slide()

#exercice[
  Les propositions suivantes sont-elles vraies ?
  + $∀ u, v, w ∈ Σ^*, #sep u v = u w ==> v = w$.
  + $∀ L_1, L_2, L_3 ⊂ Σ^*, #sep L_1 L_2 = L_1 L_3 ==> L_2 = L_3$.
]
#solution[
  #slides-only[== Simplification : corrigé]
  + Vrai : après les $abs(u)$ premières lettres communes, les suites de lettres restantes sont égales.
  #pause
  + Faux : si $L_1 = ∅$, les deux produits sont vides quels que soient $L_2$ et $L_3$.
    Même avec des langages non vides, sur $Σ = {a}$, on peut prendre
    $L_1 = Σ^*$, $L_2 = {ε}$ et $L_3 = {ε, a}$ : les deux produits valent $Σ^*$.
]

== Puissance

#definition[
  Si $L ⊂ Σ^*$, on définit sa _puissance_ par récurrence : $L^0 = {ε}$ et $L^k = L L^(k - 1)$ pour $k ≥ 1$.
]
Autrement dit : $L^n = underbrace(L … L, n " facteurs") = {m_1 … m_n ∣ m_1 ∈ L, …, m_n ∈ L}.$

#underline[Exemple] : $Σ^n$ est l'ensemble des mots de taille $n$ sur l'alphabet $Σ$. On note aussi $Σ^(< n) = union.big_(k < n) Σ^k$.

#slide()

#exercice[
  + Montrer que $L ⊂ L^2$ si et seulement si $L = ∅$ ou $ε ∈ L$.
  + Comparer $L^2$ et ${u^2 ∣ u ∈ L}$.
]
#solution[
  #slides-only[== Puissances : corrigé]
  + Si $L = ∅$, l'inclusion est vraie. Si $ε ∈ L$, tout $u ∈ L$ s'écrit $u ε ∈ L^2$.
    Réciproquement, supposons $L ≠ ∅$ et $L ⊂ L^2$.
    Un mot de taille minimale $d$ dans $L$ est le produit de deux mots de $L$, donc $d ≥ 2 d$.
    Ainsi $d = 0$ et $ε ∈ L$.
  #pause
  + On a toujours ${u^2 ∣ u ∈ L} ⊂ L^2$.
    L'inclusion peut être stricte : pour $L = {a, b}$, $a b ∈ L^2$ mais $a b ∉ {a a, b b}$.
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
#solution[
  #slides-only[== Étoile de Kleene : corrigé]
  + Comme $L ⊂ L^*$, on a $L^* ⊂ (L^*)^*$.
    Réciproquement, un produit de produits finis de mots de $L$ est encore un produit fini de mots de $L$.
    Donc $(L^*)^* ⊂ L^*$.
  #pause
  + Si $L = L^*$, alors $ε ∈ L$ et la concaténation de deux mots de $L$ reste dans $L$.
    Réciproquement, si $L$ est un sous-monoïde, une récurrence donne $L^k ⊂ L$ pour tout $k ∈ ℕ$.
    Ainsi $L^* ⊂ L$, et l'autre inclusion est toujours vraie.
]

= Langages réguliers


#definition(coeur: true)[
  L'ensemble $Lreg$ des _langages réguliers_ sur $Σ$ est le plus petit ensemble de langages, pour l'inclusion, contenant les langages finis sur $Σ$ et stable par union, concaténation et étoile de Kleene.
]

#underline[Remarque] : Cette définition est similaire à celle de tribu borélienne en maths (plus petite tribu contenant tous les ouverts).

#slide()

En particulier :
- Si $L$ est un langage fini alors $L ∈ Lreg$.
- Si $L_1 ∈ Lreg$ et $L_2 ∈ Lreg$ alors $L_1 ∪ L_2 ∈ Lreg$.
- Si $L_1 ∈ Lreg$ et $L_2 ∈ Lreg$ alors $L_1 L_2 ∈ Lreg$.
- Si $L ∈ Lreg$ alors $L^* ∈ Lreg$.

#exercice[
  Montrer qu'on peut remplacer « contenant les langages finis sur $Σ$ » par « $∅ ∈ Lreg, {ε} ∈ Lreg$ et ${a} ∈ Lreg, #sep ∀a ∈ Σ$ ».
]
#solution[
  #slides-only[== Cas de base : corrigé]
  Les langages $∅$, ${ε}$ et ${a}$ sont finis.
  Réciproquement, tout singleton ${a_1 … a_n}$ s'obtient par concaténation des ${a_i}$, avec ${ε}$ pour $n = 0$.
  Tout langage fini est une union finie de singletons, le cas vide étant fourni par $∅$.
  Les deux conditions imposent donc les mêmes familles stables.
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
  #set par(justify: false)
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

#solution[
  #slides-only[== Exemples de langages réguliers : corrigé]
  + $a Σ^*$
  #pause
  + $a Σ^* b$
  #pause
  + $(Σ Σ)^*$
  #pause
  + $Σ (Σ Σ)^*$

  Ces langages sont construits à partir de langages finis par concaténation et étoile.
]

= Expressions régulières

Les expressions régulières sont une notation plus concise pour représenter un langage régulier.

#colonnes-cours(
  columns: (1fr, 2fr),
  encadrer: regles => definition[
    L'ensemble $cal(R)(Σ)$ des _expressions régulières_ sur $Σ$ est le plus petit ensemble vérifiant :
    #regles
  ],
  [
    - $∀ a ∈ Σ, #sep a ∈ cal(R)(Σ)$
    - $∅ ∈ cal(R)(Σ)$ et $ε ∈ cal(R)(Σ)$
  ],
  [
    - Si $e_1, e_2 ∈ cal(R)(Σ)$, alors $(e_1 | e_2) ∈ cal(R)(Σ)$ et $(e_1 e_2) ∈ cal(R)(Σ)$.
    - Si $e ∈ cal(R)(Σ)$, alors $e^* ∈ cal(R)(Σ)$.
  ],
)

#slide()

#underline[Exemple] : $a^*$, $(a | a b a)^*$ et $a (a | b)^* b$ sont des expressions régulières.

#underline[Remarque] :
- On utilise seulement les parenthèses nécessaires : $(((a b) c) | d)$ sera noté $a b c | d$.
- On utilise parfois $+$ à la place de $|$.

#slide()

#colonnes-cours(
  encadrer: regles => definition[
    Le _langage_ $LL(e)$ dénoté par une expression régulière $e$ est défini récursivement :
    #regles
  ],
  [
    - $LL(a) = {a}$ si $a ∈ Σ$.
    - $LL(∅) = ∅$ et $LL(ε) = {ε}$
  ],
  [
    - $LL(e | e') = LL(e) ∪ LL(e')$
    - $LL(e e') = LL(e) LL(e')$
    - $LL(e^*) = LL(e)^*$
  ],
)

#slide()

Par abus de langage, on confond $e$ et $LL(e)$.
Ainsi, suivant le contexte, $a$ peut désigner une lettre, un mot de taille $1$ ou un langage singleton.\

#pause
#theoreme[
  Un langage $L$ est régulier si et seulement s'il existe une expression régulière $e$ telle que $L = LL(e)$.
]
#solution[
  #slides-only[== Expressions et langages réguliers : preuve]
  Tout langage dénoté par une expression régulière est régulier : c'est vrai des lettres, de $∅$ et de $ε$, et les trois constructeurs conservent la régularité.
  Le raisonnement suit la construction de l'expression.
  #pause
  Réciproquement, la famille des langages dénotés contient tous les langages finis : un singleton s'écrit par concaténation de lettres, puis on prend une union finie.
  Elle est stable par union, concaténation et étoile, grâce aux constructeurs correspondants.
  Elle contient donc $Lreg$, par minimalité.
]

#slide()

#exercice[
  #set par(justify: false)
  Donner une expression régulière pour les langages suivants sur $Σ = {a, b}$ :
  #colonnes-cours(
    [
      + Mots contenant au plus un $a$.
      + Mots dont la taille est congrue à $1$ modulo $3$.
      + Mots contenant un nombre pair de $a$.
    ],
    [
      #enum(
        start: 4,
      )[Mots contenant un nombre impair de $a$.][Sur $Σ = {0, 1}$ : écritures en base $2$ des entiers divisibles par $4$.]
    ],
  )
]

#solution[
  #slides-only[== Expressions régulières : corrigé]
  + $b^* (ε | a) b^*$
  #pause
  + $(a | b) ((a | b) (a | b) (a | b))^*$
  #pause
  + $b^* (a b^* a b^*)^*$
  #pause
  + $b^* a b^* (a b^* a b^*)^*$
  #pause
  + Pour les écritures canoniques, sans zéro initial, avec $0$ écrit $0$ : $0 | 1 (0 | 1)^* 0 0$.
    Si les zéros initiaux sont autorisés : $0 | (0 | 1)^* 0 0$.

  Les $a$ se regroupent par paires dans les réponses 3 et 4.
  Un entier binaire non nul est divisible par $4$ si et seulement si ses deux derniers chiffres sont $0$.
]

#slide()

#colonnes-cours(
  encadrer: exercice,
  [
    + Écrire ```ocaml epsilon : 'a regexp -> bool``` qui teste $ε ∈ LL(e)$.
    + Écrire ```ocaml vide : 'a regexp -> bool``` qui teste $LL(e) = ∅$.
  ],
  code-extrait(corrige-ocaml, "regexp"),
)
#solution[
  #slides-only[== Test du mot vide : corrigé]
  #code-extrait(corrige-ocaml, "epsilon")
  #pause
  Le mot vide appartient à une union si et seulement s'il appartient à l'un des deux langages.
  Il appartient à une concaténation si et seulement s'il appartient aux deux langages, car $u v = ε$ impose $u = v = ε$.
]
#solution[
  #slides-only[== Test du langage vide : corrigé]
  #code-extrait(corrige-ocaml, "vide")
  #pause
  Une concaténation est vide si et seulement si l'un des facteurs l'est.
  Une étoile contient toujours $ε$.
  Ces règles prouvent les deux fonctions par induction structurelle.
  Pour un arbre de taille $n$, leur coût est $O(n)$, car chaque nœud est visité au plus une fois.
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
    ([Ensemble des langages réguliers], [$Lreg$], [$Lreg$], [$cal(P)(cal(P)(Σ^*))$]),
  )
  let reponse(contenu) = if est-presentation() {
    [#pause #contenu]
  } else if est-corrige() {
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

#slide()

#definition[Équivalence d'expressions régulières][
  Deux expressions régulières $e_1$ et $e_2$ sont dites _équivalentes_, noté $e_1 ≡ e_2$, si $LL(e_1) = LL(e_2)$.
]

#underline[Exemple] : $(a b)^* a ≡ a (b a)^*$.

#slide()

#exercice[
  Pour des expressions régulières $e$, $e_1$, $e_2$ et $e_3$ :
  #context block(above: par.leading, grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    align: top,
    liste-a-completer($e ∅ ≡$, $e ε ≡$, $e | ∅ ≡$, $∅^* ≡$),
    liste-a-completer(start: 5, $ε^* ≡$, $(e_1 | e_2) e_3 ≡$, $e_1 (e_2 e_3) ≡$),
  ))
]
#solution[
  #slides-only[== Identités : corrigé]
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    align: top,
    [
      + $e ∅ ≡ ∅$
      + $e ε ≡ e$
      + $e | ∅ ≡ e$
      + $∅^* ≡ ε$
    ],
    enum(start: 5, [$ε^* ≡ ε$], [$(e_1 | e_2) e_3 ≡ e_1 e_3 | e_2 e_3$], [$e_1 (e_2 e_3) ≡ (e_1 e_2) e_3$]),
  )
]

= Induction structurelle

#colonnes-cours(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  align: top,
  [
    #theoreme(coeur: true)[
      Soit $cal(P)(L)$ une propriété sur les langages telle que :
      - $cal(P)(L)$ est vraie pour les langages $L$ finis
      - $cal(P)(L_1) ∧ cal(P)(L_2) ==> cal(P)(L_1 L_2)$
      - $cal(P)(L_1) ∧ cal(P)(L_2) ==> cal(P)(L_1 ∪ L_2)$
      - $cal(P)(L) ==> cal(P)(L^*)$
      Alors $cal(P)(L)$ est vraie pour tout langage régulier $L$.
    ]
  ],
  [
    #if est-presentation() { slide() }
    #theoreme[
      Soit $cal(P)(e)$ une propriété sur $e ∈ cal(R)(Σ)$ telle que :
      - $cal(P)(∅)$, $cal(P)(ε)$ et $cal(P)(a)$ sont vraies pour $a ∈ Σ$
      - $cal(P)(e_1) ∧ cal(P)(e_2) ==> cal(P)(e_1 e_2)$
      - $cal(P)(e_1) ∧ cal(P)(e_2) ==> cal(P)(e_1 | e_2)$
      - $cal(P)(e) ==> cal(P)(e^*)$

      Alors $cal(P)(e)$ est vraie pour toute expression régulière $e$.
    ]
  ],
)

#solution[
  #slides-only[== Induction structurelle : preuves]
  Pour les langages, l'ensemble ${L ⊂ Σ^* ∣ cal(P)(L)}$ contient les langages finis et est stable par union, concaténation et étoile de Kleene.
  Il contient donc tous les langages réguliers, par minimalité.
  #pause
  Pour les expressions, l'ensemble ${e ∈ cal(R)(Σ) ∣ cal(P)(e)}$ contient les cas de base et est stable par les trois constructeurs.
  Il contient donc tout $cal(R)(Σ)$, par minimalité.
]

#slide()

#exercice([Miroir])[
  On note $widetilde(m) = m_n … m_1$ le _miroir_ d'un mot $m = m_1 … m_n$ et $widetilde(L) = {widetilde(m) ∣ m ∈ L}$ celui d'un langage $L$.

  + Donner une expression régulière du miroir de $a (a | b)^* b$.
  + Soit $L$ un langage régulier. Montrer que $widetilde(L)$ est régulier.
  + Écrire une fonction OCaml ```ocaml miroir : 'a regexp -> 'a regexp``` renvoyant le miroir d'une expression régulière.
]
#solution[
  #slides-only[== Miroir : corrigé]
  + $b (a | b)^* a$
  #pause
  + Le miroir conserve l'union, renverse l'ordre de la concaténation et commute avec l'étoile :
    $widetilde(L_1 ∪ L_2) = widetilde(L_1) ∪ widetilde(L_2)$,
    $widetilde(L_1 L_2) = widetilde(L_2) widetilde(L_1)$ et
    $widetilde(L^*) = widetilde(L)^*$.
    Le miroir d'un langage fini étant fini, une induction structurelle sur les langages donne la régularité du miroir.
]
#solution[
  #slides-only[== Miroir d'une expression : corrigé]
  #code-extrait(corrige-ocaml, "miroir")
  #pause
  Les identités précédentes prouvent par induction structurelle que
  $LL("miroir"(e)) = widetilde(LL(e))$.
  Le coût est linéaire en la taille de l'arbre de l'expression.
]

#slides-only[
  #slide()
  - Pour montrer une égalité de deux mots, on peut faire une récurrence sur la taille du mot.
  - Pour montrer une égalité de deux langages, on peut montrer une double inclusion.

  #exercice[
    Soient $e_1$ et $e_2$ deux expressions régulières.
    Montrer que $(e_1^* e_2)^* e_1^* ≡ (e_1 | e_2)^*$.
  ]
  #solution[
    == Équivalence : corrigé
    Posons $A = LL(e_1)$ et $B = LL(e_2)$.
    - Tout mot de $(A^* B)^* A^*$ est un produit de mots de $A$ ou de $B$, donc appartient à $(A ∪ B)^*$.
    #pause
    - Réciproquement, choisissons une décomposition en facteurs de $A ∪ B$, puis affectons chaque facteur à $A$ ou à $B$.
      Regroupons chaque facteur de $B$ avec les facteurs de $A$ qui le précèdent depuis le dernier facteur de $B$.
      Ces groupes appartiennent à $A^* B$, et les facteurs de $A$ restants forment un mot de $A^*$.
  ]

  = Complément : Expressions régulières en pratique

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
  #underline[Preuve] : identifier les $p$ lettres de $Σ$ avec les entiers de $1$ à $p$.
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
  #underline[Preuve] : si $f : E --> cal(P)(E)$, alors $Y = {x ∈ E ∣ x ∉ f(x)}$ n'a pas d'antécédent par $f$.

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
  #underline[Preuve] : l'ensemble des expressions régulières sur $Σ$ est dénombrable, car c'est un langage sur un alphabet fini.
  L'ensemble des langages réguliers est donc au plus dénombrable.
  Si $a ∈ Σ$, les langages ${a^n}$, pour $n ∈ ℕ$, sont réguliers et deux à deux distincts.

  #slide()

  Comme l'ensemble des langages sur $Σ$ est indénombrable :

  #corollaire[
    Il existe des langages non réguliers sur $Σ$.
  ]
  On verra plus tard comment montrer qu'un langage n'est pas régulier.
]
