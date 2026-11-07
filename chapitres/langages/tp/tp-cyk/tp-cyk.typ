#import "/load.typ": code, est-corrige, exercice, feuille, question, theoremes
#import code: code-extrait
#import theoremes: algorithme
#import "../../exercices/forme-normale-chomsky.typ": chomsky
#let corrige = read("corrige.ml")
#let squelette = read("tp4.ml")

#let sujet = exercice(
  meta: (
      titre: "TP 4 : Algorithme CYK",
      chapitres: ("grammaires-non-contextuelles",),
      algorithmes: ("programmation-dynamique",),
      structures: ("tableau", "arbre-binaire"),
      langages: ("OCaml",),
      niveaux: ("MPI",),
      difficulte: 2,
    ),
)[
  L'algorithme CYK (Cocke-Younger-Kasami) permet de déterminer, par programmation dynamique, si un mot est généré par une grammaire non-contextuelle.
  Il permet aussi de trouver un arbre de dérivation pour ce mot, par analyse syntaxique ascendante (_bottom-up_ : des feuilles à la racine).

  #chomsky

  L'algorithme prend en entrée une grammaire $G = (Σ, V, R, S)$ en forme normale de Chomsky.
  On note $V = {X_0, X_1, …, X_(k - 1)}$ les variables, où $S = X_0$.

  = Équation de récurrence
  Cette partie est à faire sur papier.

  Soit $u = u_0 … u_(n - 1) ∈ Σ^+$. On veut savoir si $u ∈ cal(L)(G)$.
  Pour cela, on va calculer, pour $1 ≤ l ≤ n$, $0 ≤ d ≤ n - l$ et $0 ≤ i < k$ :
  $ t[l][d][i] = cases("vrai" & "si" X_i ⟹^* u_d … u_(d + l - 1), "faux" & "sinon".) $

  #question[À quelle condition a-t-on $u ∈ cal(L)(G)$ ?][On a $u ∈ cal(L)(G) ⟺ t[n][0][0]$.]

  #question[Comment traiter séparément le cas du mot vide ?][On a $ε ∈ cal(L)(G)$ si et seulement si $S ⟶ ε$ appartient à $R$. Ce cas ne nécessite pas de tableau.]

  #question[Que vaut $t[1][d][i]$ ?][La valeur est vraie si et seulement si $X_i ⟶ u_d$ appartient à $R$.]

  Pour $l ≥ 2$, avoir $X_i ⟹^* u_d … u_(d + l - 1)$ équivaut à l'existence d'une règle $X_i ⟶ X_j X_k$ et d'un entier $1 ≤ p < l$ tels que $X_j ⟹^* u_d … u_(d + p - 1)$ et $X_k ⟹^* u_(d + p) … u_(d + l - 1)$.

  #question[En déduire une équation de récurrence pour $t[l][d][i]$.][Pour $l ≥ 2$ et $0 ≤ d ≤ n - l$ :
        $ t[l][d][i] = or.big_(X_i ⟶ X_j X_k ∈ R) or.big_(p = 1)^(l - 1) (t[p][d][j] ∧ t[l - p][d + p][k]). $
        Les bornes assurent $d + p < n$.]

  #question[En déduire un algorithme en pseudo-code pour remplir le tableau $t$. Quelle est sa complexité ?][
          #algorithme[
            + *Si* $n = 0$, renvoyer vrai si $S ⟶ ε ∈ R$, et faux sinon.
            + Initialiser le tableau à faux, puis remplir le cas $l = 1$.
            + *Pour* $l$ de $2$ à $n$ :
              + *Pour* $d$ de $0$ à $n - l$ :
                + *Pour chaque* règle $X_i ⟶ X_j X_k$ :
                  + *Pour* $p$ de $1$ à $l - 1$ :
                    + *Si* $t[p][d][j] ∧ t[l - p][d + p][k]$ alors $t[l][d][i] ← "vrai"$.
            + *Renvoyer* $t[n][0][0]$.
          ]
          Notons $r_1$ et $r_2$ les nombres de règles terminales et binaires.
          L'initialisation coûte $O(n^2 k + n r_1)$ pour $n ≥ 1$.
          Les boucles de récurrence effectuent $r_2 sum_(l = 2)^n (n - l + 1)(l - 1) = O(r_2 n^3)$ opérations.
          La complexité totale est donc $O(n^2 k + n r_1 + r_2 n^3)$ en temps et $O(n^2 k)$ en espace.
        ]

  = Implémentation
  On définit le type suivant :
  #code-extrait(squelette, "grammaire")
  Les variables sont numérotées de `0` à `n_variables - 1` (`int`) et les lettres sont des caractères (`char`).
  `regles1` contient un couple $(i, a)$ pour chaque règle $X_i ⟶ a$ et `regles2` contient un triplet $(i, j, k)$ pour chaque règle $X_i ⟶ X_j X_k$.
  `epsilon` est vrai si $ε ∈ cal(L)(G)$.

  #question[Définir une variable `g0` représentant la grammaire suivante :
          $
              S & ⟶ b ∣ X_1 X_2 ∣ X_2 X_1 ∣ X_3 X_1 \
            X_1 & ⟶ a ∣ X_1 X_4 \
            X_2 & ⟶ b \
            X_3 & ⟶ X_1 X_2 \
            X_4 & ⟶ a
          $
        ][#code-extrait(corrige, "g0")]

  #question[Écrire une fonction `init : grammaire -> string -> bool array array array` qui prend en argument une grammaire et un mot non vide de taille $n$ et renvoie un tableau `t` de dimensions $(n + 1) × n × k$, initialisé pour le cas de base $l = 1$, les autres cases étant à faux.
          Les cases d'indice $l = 0$ ou telles que $d + l > n$ ne sont pas utilisées.
          Veiller à créer des sous-tableaux indépendants : `Array.make` ne copie pas le tableau fourni comme valeur initiale.
          #block(breakable: false)[
            ```ocaml
            (init g0 "aba").(1);;
            - : bool array array =
            [|[|false; true; false; false; true|];
              [|true; false; true; false; false|];
              [|false; true; false; false; true|]|]
            ```
          ]
        ][#code-extrait(corrige, "init")]

  #question[Écrire une fonction `cyk : grammaire -> string -> bool` qui prend en argument une grammaire et un mot et renvoie vrai si le mot est dans le langage de la grammaire, en utilisant l'algorithme CYK décrit en première partie. Traiter le mot vide avant de construire le tableau.
        ][#code-extrait(corrige, "cyk")]

  #question[Justifier que `g0` engendre le langage $a^* b a^*$ et tester la fonction `cyk` sur quelques exemples.
          ```ocaml
          cyk g0 "aab";;
          - : bool = true
          cyk g0 "aabb";;
          - : bool = false
          cyk g0 "abaa";;
          - : bool = true
          cyk g0 "aababa";;
          - : bool = false
          ```
          Tester aussi les mots `""`, `"a"` et `"b"`, puis le mot vide avec `{ g0 with epsilon = true }`.
        ][Les variables $X_1$, $X_2$, $X_3$ et $X_4$ engendrent respectivement $a^+$, ${b}$, $a^+ b$ et ${a}$.
          Les quatre règles de $S$ engendrent respectivement ${b}$, $a^+ b$, $b a^+$ et $a^+ b a^+$.
          Leur union est $a^* b a^*$.
          #code-extrait(corrige, "exemples")
        ]

  = Arbre de dérivation
  On définit le type suivant pour modéliser un arbre de dérivation :
  #code-extrait(squelette, "arbre")
  où :
  - `Vide` correspond à une dérivation $S ⟶ ε$
  - `Un (i, a)` correspond à une dérivation $X_i ⟶ a$
  - `Deux (i, gauche, droite)` correspond à une règle $X_i ⟶ X_j X_k$, où `gauche` et `droite` sont des arbres de dérivation de racines respectives $X_j$ et $X_k$

  On rappelle que le type `option` est défini nativement en OCaml par :
  ```ocaml
  type 'a option = None | Some of 'a
  ```
  On adapte alors l'algorithme CYK avec `t : arbre option array array array` où `t[l][d][i]` contient un arbre de dérivation pour $X_i ⟹^* u_d … u_(d + l - 1)$ s'il en existe un, `None` sinon.

  #question[Écrire une fonction `arbre_derivation : grammaire -> string -> arbre option` qui prend en argument une grammaire et un mot et renvoie `Some a`, où `a` est un arbre de dérivation de ce mot, ou `None` si le mot n'est pas engendré. Un seul arbre quelconque suffit. Traiter le mot vide séparément.
        ][#code-extrait(corrige, "arbre_derivation")]
]

#show: feuille.with(
  type: "tp",
  titre: sujet.meta.titre,
  niveau: "MPI",
  exercices: (sujet,),
  tp: (
    ouvrir: "tp4.ml",
    squelette: ((source: "tp4.ml"),),
    corrige: ((source: "corrige.ml"),),
  ),
  corrige: est-corrige(),
)
