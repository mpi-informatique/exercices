#import "/load.typ": code, est-corrige, exercice, feuille, question, theoremes
#import code: code-extrait
#import theoremes: algorithme
#let corrige = read("corrige.ml")
#let squelette = read("tp4.ml")

#let sujet = exercice(
  meta: (
    titre: "TP 4 : Algorithme CYK (Cocke-Younger-Kasami)",
    chapitres: ("grammaires-non-contextuelles",),
    algorithmes: ("programmation-dynamique",),
    structures: ("tableau", "arbre-binaire"),
    langages: ("OCaml",),
    niveaux: ("MPI",),
    difficulte: 2,
  ),
  contenu: (
    [L'algorithme CYK permet de déterminer, par programmation dynamique, si un mot est généré par une grammaire non-contextuelle.
      Il permet aussi de trouver un arbre de dérivation pour ce mot, par analyse syntaxique ascendante (_bottom-up_ : des feuilles à la racine).

      L'algorithme prend en entrée une grammaire $G = (Σ, V, R, S)$ en forme normale de Chomsky, c'est-à-dire que toutes les règles sont de la forme $X ⟶ Y Z$, $X ⟶ a$ ou $S ⟶ ε$, où $X, Y, Z ∈ V$, $Y ≠ S$, $Z ≠ S$ et $a ∈ Σ$.
      On note $V = {X_0, X_1, …, X_(k - 1)}$ les variables, où $S = X_0$.
    ],
    [= Équation de récurrence
      Cette partie est à faire sur papier.

      Soit $u = u_0 … u_(n - 1) ∈ Σ^*$. On veut savoir si $u ∈ cal(L)(G)$.
      Pour cela, on va calculer, pour $l ∈ {0, …, n}$, $d ∈ {0, …, n - 1}$ et $i ∈ {0, …, k - 1}$ :
      $ t[l][d][i] = cases("vrai" & "si" X_i ⟹^* u_d … u_(d + l - 1), "faux" & "sinon".) $],
    question([À quelle condition a-t-on $u ∈ cal(L)(G)$ ?], solution: [Pour $n > 0$, on a $u ∈ cal(L)(G) ⟺ t[n][0][0]$.
      Pour le mot vide, on teste si la règle $S ⟶ ε$ appartient à $R$.]),
    question(
      [Que vaut $t[0][d][i]$ ?],
      solution: [La valeur est vraie si et seulement si $i = 0$ et $S ⟶ ε$ appartient à $R$, car aucune autre variable ne peut engendrer le mot vide.],
    ),
    question(
      [Que vaut $t[1][d][i]$ ?],
      solution: [La valeur est vraie si et seulement si $X_i ⟶ u_d$ appartient à $R$.],
    ),
    [Pour avoir $X_i ⟹^* u_d … u_(d + l - 1)$, il faut que $X_i ⟶ X_j X_k$ avec $X_j ⟹^* u_d … u_(d + p - 1)$ et $X_k ⟹^* u_(d + p) … u_(d + l - 1)$.],
    question([En déduire une équation de récurrence pour $t[l][d][i]$.], solution: [Pour $l ≥ 2$ et $0 ≤ d ≤ n - l$ :
      $ t[l][d][i] = or.big_(X_i ⟶ X_j X_k ∈ R) or.big_(p = 1)^(l - 1) (t[p][d][j] ∧ t[l - p][d + p][k]). $
      Les bornes assurent $d + p < n$.]),
    question(
      [En déduire un algorithme en pseudo-code pour remplir le tableau $t$. Quelle est sa complexité ?],
      solution: [
        #algorithme[
          + Initialiser le tableau à faux, puis remplir les cas $l = 0$ et $l = 1$.
          + *Pour* $l$ de $2$ à $n$ :
            + *Pour* $d$ de $0$ à $n - l$ :
              + *Pour chaque* règle $X_i ⟶ X_j X_k$ :
                + *Pour* $p$ de $1$ à $l - 1$ :
                  + *Si* $t[p][d][j] ∧ t[l - p][d + p][k]$ alors $t[l][d][i] ← "vrai"$.
          + *Renvoyer* $t[n][0][0]$ pour $n > 0$, et tester $S ⟶ ε ∈ R$ pour $n = 0$.
        ]
        Notons $r_1$ et $r_2$ les nombres de règles terminales et binaires.
        L'initialisation coûte $O(n^2 k + n r_1)$ pour $n ≥ 1$.
        Les boucles de récurrence effectuent $r_2 sum_(l = 2)^n (n - l + 1)(l - 1) = O(r_2 n^3)$ opérations.
        La complexité totale est donc $O(n^2 k + n r_1 + r_2 n^3)$ en temps et $O(n^2 k)$ en espace.
      ],
    ),
    [= Implémentation
      On définit le type suivant :
      #code-extrait(squelette, "grammaire")
      Les variables sont numérotées de `0` à `n_variables - 1` (`int`) et les lettres sont des caractères (`char`).
      `regles1` contient un couple $(i, a)$ pour chaque règle $X_i ⟶ a$ et `regles2` contient un triplet $(i, j, k)$ pour chaque règle $X_i ⟶ X_j X_k$.
      `epsilon` est vrai si $ε ∈ cal(L)(G)$.],
    question(
      [Définir une variable `g0` représentant la grammaire suivante :
        $
            S & ⟶ b ∣ X_1 X_2 ∣ X_2 X_1 ∣ X_3 X_1 \
          X_1 & ⟶ a ∣ X_1 X_4 \
          X_2 & ⟶ b \
          X_3 & ⟶ X_1 X_2 \
          X_4 & ⟶ a
        $
      ],
      solution: [#code-extrait(corrige, "g0")],
    ),
    question(
      [Écrire une fonction `init : grammaire -> string -> bool array array array` qui prend en argument une grammaire et un mot et renvoie un tableau `t` initialisé pour les cas de base $l = 0$ et $l = 1$.
        #block(breakable: false)[
          ```ocaml
          init g0 "aba";;
          - : bool array array array =
          [|[|[|false; false; false; false; false|];
              [|false; false; false; false; false|];
              [|false; false; false; false; false|]|];
            [|[|false; true; false; false; true|];
              [|true; false; true; false; false|];
              [|false; true; false; false; true|]|];
            [|[|false; false; false; false; false|];
              [|false; false; false; false; false|];
              [|false; false; false; false; false|]|];
            [|[|false; false; false; false; false|];
              [|false; false; false; false; false|];
              [|false; false; false; false; false|]|]|]
          ```
        ]
      ],
      solution: [#code-extrait(corrige, "init")],
    ),
    question(
      [Écrire une fonction `cyk : grammaire -> string -> bool` qui prend en argument une grammaire et un mot et renvoie vrai si le mot est dans le langage de la grammaire, en utilisant l'algorithme CYK décrit en première partie.
      ],
      solution: [#code-extrait(corrige, "cyk")],
    ),
    question(
      [Justifier que `g0` engendre le langage $a^* b a^*$ et tester la fonction `cyk` sur quelques exemples.
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
      ],
      solution: [Les variables $X_1$, $X_2$, $X_3$ et $X_4$ engendrent respectivement $a^+$, ${b}$, $a^+ b$ et ${a}$.
        Les quatre règles de $S$ engendrent respectivement ${b}$, $a^+ b$, $b a^+$ et $a^+ b a^+$.
        Leur union est $a^* b a^*$.
        #code-extrait(corrige, "exemples")
      ],
    ),
    [= Arbre de dérivation
      On définit le type suivant pour modéliser un arbre de dérivation :
      #code-extrait(squelette, "arbre")
      où :
      - `Vide` correspond à une dérivation $S ⟶ ε$
      - `Un (i, a)` correspond à une dérivation $X_i ⟶ a$
      - `Deux (i, j, k)` correspond à une dérivation $X_i ⟶ X_j X_k$

      On rappelle que le type `option` est défini nativement en OCaml par :
      ```ocaml
      type 'a option = None | Some of 'a
      ```
      On adapte alors l'algorithme CYK avec `t : arbre option array array array` où `t[l][d][i]` contient un arbre de dérivation pour $X_i ⟹^* u_d … u_(d + l - 1)$ s'il en existe un, `None` sinon.],
    question(
      [Écrire une fonction `arbre_derivation : grammaire -> string -> arbre option` qui prend en argument une grammaire et un mot et renvoie un arbre de dérivation pour ce mot si celui-ci est dans le langage de la grammaire ou `None` sinon.
      ],
      solution: [#code-extrait(corrige, "arbre_derivation")],
    ),
  ),
)

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
