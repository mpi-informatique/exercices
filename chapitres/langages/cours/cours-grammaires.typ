#import "/load.typ": cours, espace-reponse, est-corrige, completer, theoremes
#import theoremes: definition, exercice, theoreme
#import "@preview/cetz:0.4.2" as cetz

#show: cours.with(titre: "Grammaires non-contextuelles", niveau: "MPI")

// Source : cours-src/langage/grammaire/resume/poly_grammaire.tex.
#let reponse(n) = if not est-corrige() { espace-reponse(n) }

// Arbres ordonnés : les coordonnées fixent l'ordre des fils et des feuilles.
#let arbre(noeuds, liens) = cetz.canvas(length: 8mm, {
  import cetz.draw: content, line
  for (i, (position, etiquette)) in noeuds.enumerate() {
    content(position, etiquette, name: "n" + str(i), padding: 2pt)
  }
  for (pere, fils) in liens {
    line("n" + str(pere) + ".south", "n" + str(fils) + ".north")
  }
})

TODO : Tree-sitter

#align(center, cetz.canvas(length: 8mm, {
  import cetz.draw: content, rect
  rect((0, 0), (15, 15), radius: 0.2)
  content((7.5, 0), box(fill: white, inset: (x: 3pt))[Langages quelconques])
  content((7.5, 13.5), ${a^n b^n c^n ∣ n ∈ NN}$)
  rect((1, 1), (14, 12), radius: 0.2)
  content((7.5, 1), box(fill: white, inset: (x: 3pt))[Langages non-contextuels])
  rect((2, 2), (13, 9), radius: 0.2)
  content((7.5, 2), box(fill: white, inset: (x: 3pt))[Langages réguliers])
  content((3.75, 10.5), ${a^n b^n ∣ n ∈ NN}$)
  content((7.5, 10.5), ${u ∣ |u|_a = |u|_b}$)
  content((11.25, 10.5), [palindromes])
  rect((3, 3), (12, 6.45), radius: 0.2)
  content((7.5, 3), box(fill: white, inset: (x: 3pt))[Langages locaux])
  content((7.5, 7.725), ${a a}$)
  rect((4, 4), (11, 4.8), radius: 0.2)
  content((7.5, 4), box(fill: white, inset: (x: 3pt), text(size: 8pt)[Langages d'expressions régulières linéaires]))
  content((7.5, 5.55), $a a^*$)
  content((7.5, 4.4), $a b^* | c$)
}))

= Définitions

#definition(titre: [Grammaire non-contextuelle])[
  Une grammaire non-contextuelle est un quadruplet $G = (Σ, V, R, S)$ où :
  - $V$ est un ensemble fini de variables
  - $Σ$ est un alphabet fini de terminaux, disjoint de $V$
  - $R ⊂ V × (V ∪ Σ)^*$ est un ensemble fini de règles de production, chaque règle $(X, α) ∈ R$ étant notée $X → α$
  - $S ∈ V$ est le symbole initial
]
#underline[Remarques] :
- Par convention, on note les variables en majuscules et les terminaux en minuscules.
- On peut noter $X → α ∣ β$ au lieu de $X → α$, $X → β$.
- Il existe des grammaires plus générales (contextuelles) mais nous nous limiterons aux grammaires non-contextuelles, qu'on appellera simplement grammaires.

#definition(titre: [Dérivation])[
  Soient $α, β ∈ (V ∪ Σ)^*$.
  - On note $α ⇒ β$ s'il existe une règle $X → γ$ telle que $α = α_1 X α_2$ et $β = α_1 γ α_2$ avec $α_1, α_2 ∈ (V ∪ Σ)^*$.

    On dit alors qu'on a une dérivation immédiate de $α$ en $β$.
  - On note $α ⇒^n β$ s'il existe des mots $γ_0 = α, γ_1, …, γ_n = β$ tels que $γ_0 ⇒ γ_1 ⇒ … ⇒ γ_n$.

    On dit alors qu'on a une dérivation de longueur $n$ de $α$ en $β$.
  - On note $α ⇒^* β$ si $α ⇒^n β$ pour un certain $n ∈ NN$. On parle alors de dérivation de $α$ en $β$.
]

#definition(titre: [Langage engendré])[
  Soit $G = (Σ, V, R, S)$ une grammaire.
  - On dit que $G$ génère un mot $w ∈ Σ^*$ si $S ⇒^* w$.
  - L'ensemble $cal(L)(G) = {w ∈ Σ^* ∣ S ⇒^* w}$ est le langage engendré par $G$.
  - Un langage $L$ est dit non-contextuel s'il existe une grammaire non-contextuelle $G$ telle que $L = cal(L)(G)$.
]

#underline[Exemples] :
- Soit $G = (Σ = {a, b}, V = {S}, R = {S → a a S ∣ b}, S)$.

  $cal(L)(G) =$ #completer()
- Soit $G = ({a, b}, {S}, {S → a S b ∣ ε}, S)$.

  $cal(L)(G) =$ #completer()
- Soit $G = ({x, y, ⊤, ⊥, ∨, ∧, ¬}, {S}, R, S)$ avec $R$ contenant les règles suivantes :
  $S → ⊤ ∣ ⊥ ∣ x ∣ y ∣ ¬ S ∣ S ∨ S ∣ S ∧ S$.

  $cal(L)(G)$ est #completer()

#exercice[
  Donner des grammaires engendrant les langages suivants sur ${a, b}$ (sauf $L_4$, sur l'alphabet des expressions arithmétiques) :
  + $L_1 = a b^* a$.
  + $L_2 =$ ensemble des mots dont la taille est un multiple de 3.
  + $L_3 =$ ensemble des mots ayant $b b b$ comme facteur.
  + $L_4 =$ ensemble des expressions arithmétiques bien formées, comme $4 + 3 × 2$.
  + $L_5 =$ ensemble des palindromes, c'est-à-dire des mots qui se lisent de la même façon de gauche à droite et de droite à gauche.
  + $L_6 =$ ensemble des mots qui ne sont pas des palindromes.
  #reponse(8)
]

#underline[Méthode] : Si $G$ est une grammaire et $L$ un langage, on peut montrer $cal(L)(G) = L$ par double inclusion.
- $L ⊂ cal(L)(G)$ : montrer que si $u ∈ L$ alors $u ∈ cal(L)(G)$, par récurrence sur $|u|$.
- $cal(L)(G) ⊂ L$ : montrer $H_n$ : « Si $S ⇒^n u$ avec $u ∈ Σ^*$ alors $u ∈ L$ », par récurrence sur $n$, en renforçant au besoin la propriété aux autres variables. Pour montrer $H_(n + 1)$, on considère la première règle dans $S ⇒^(n + 1) u$ et on utilise le théorème « évident » suivant :

#theoreme[
  Soit $G = (Σ, V, R, S)$ une grammaire, $α_1, α_2, β ∈ (V ∪ Σ)^*$ et $n ∈ NN$.

  Si $α_1 α_2 ⇒^n β$ alors il existe $β_1, β_2 ∈ (V ∪ Σ)^*$, $k, p ∈ NN$ tels que :
  - $β = β_1 β_2$
  - $α_1 ⇒^k β_1$
  - $α_2 ⇒^p β_2$
  - $n = k + p$
]

#exercice[
  Soit $G$ la grammaire définie par les règles $S → a S b S ∣ b S a S ∣ ε$.

  Déterminer $cal(L)(G)$, en le démontrant.
  #reponse(8)
]

= Langages non-contextuels et langages réguliers

#theoreme[
  L'ensemble des langages non-contextuels est stable par union, concaténation et étoile.

  C'est-à-dire : si $L_1$ et $L_2$ sont des langages non-contextuels alors $L_1 ∪ L_2$, $L_1 L_2$ et $L_1^*$ sont des langages non-contextuels.
]
#underline[Preuve] :
#reponse(3)

#underline[Remarque] : les langages non-contextuels ne sont pas stables par intersection, différence, complémentaire.

#theoreme[
  Tout langage régulier est non-contextuel.
]
#underline[Preuve] :
#reponse(1)

#underline[Remarque] : la réciproque est fausse, car ${a^n b^n ∣ n ∈ NN}$ est non-contextuel mais pas régulier.

#definition(titre: [Grammaire régulière (HP)])[
  Une grammaire est dite régulière (à droite) si chaque règle est de la forme $X → a Y$, $X → a$ ou $X → ε$, avec $X, Y ∈ V$ et $a ∈ Σ$.
]

#theoreme[
  Un langage est régulier si et seulement s'il est engendré par une grammaire régulière.
]
#underline[Preuve] :
#reponse(7)

= Arbre de dérivation

#definition(titre: [Arbre de dérivation])[
  Soient $G = (Σ, V, R, S)$ une grammaire et $u ∈ cal(L)(G)$.

  Un arbre de dérivation (ou : arbre syntaxique) pour $u$ est un arbre ordonné tel que :
  - la racine est étiquetée $S$
  - chaque nœud interne est étiqueté par un élément de $V$
  - chaque feuille est étiquetée par un élément de $Σ ∪ {ε}$
  - si un nœud interne est étiqueté $X$ et possède $n$ fils étiquetés $α_1, …, α_n$, alors $X → α_1 … α_n ∈ R$
  - les étiquettes des feuilles, lues de gauche à droite en ignorant $ε$, forment le mot $u$
]

#underline[Exemple] : Soit $G$ la grammaire définie par $S → S + S ∣ S × S ∣ 2$ avec $Σ = {+, ×, 2}$.

Il y a plusieurs façons d'engendrer $2 + 2 × 2$, donnant des arbres de dérivation différents :
+ $S ⇒ S + S ⇒ 2 + S ⇒ 2 + S × S ⇒ 2 + 2 × S ⇒ 2 + 2 × 2$
+ $S ⇒ S × S ⇒ S + S × S ⇒ 2 + S × S ⇒ 2 + 2 × S ⇒ 2 + 2 × 2$

#grid(
  columns: (1fr, 1fr), align: center, column-gutter: 1em,
  [
    #arbre(
      (((0, 0), $S$), ((-1.5, -1), $S$), ((0, -1), $+$), ((1.5, -1), $S$), ((-1.5, -2), $2$), ((0.5, -2), $S$), ((1.5, -2), $×$), ((2.5, -2), $S$), ((0.5, -3), $2$), ((2.5, -3), $2$)),
      ((0, 1), (0, 2), (0, 3), (1, 4), (3, 5), (3, 6), (3, 7), (5, 8), (7, 9)),
    )

    #align(center)[1.]
  ],
  [
    #arbre(
      (((0, 0), $S$), ((-1.5, -1), $S$), ((0, -1), $×$), ((1.5, -1), $S$), ((-2.5, -2), $S$), ((-1.5, -2), $+$), ((-0.5, -2), $S$), ((1.5, -2), $2$), ((-2.5, -3), $2$), ((-0.5, -3), $2$)),
      ((0, 1), (0, 2), (0, 3), (1, 4), (1, 5), (1, 6), (3, 7), (4, 8), (6, 9)),
    )

    #align(center)[2.]
  ],
)

= Grammaire ambiguë

#definition(titre: [Grammaire ambiguë])[
  Soit $G = (Σ, V, R, S)$ une grammaire.
  - On dit que $u$ est ambigu pour $G$ s'il existe plusieurs arbres de dérivation distincts pour $u$.
  - On dit que la grammaire $G$ est ambiguë s'il existe au moins un mot $u$ ambigu pour $G$.
]

#exercice[
  Montrer que les grammaires suivantes sont ambiguës :
  + $S → S ∣ ε$
  + $S → a X b$, $X → a ∣ b ∣ ε ∣ X X$.
  #reponse(6)
]

#underline[Attention] : Si $S → S a S ∣ b$, $b a b$ peut être engendré de deux façons ($S ⇒ S a S ⇒ b a S ⇒ b a b$ et $S ⇒ S a S ⇒ S a b ⇒ b a b$) mais n'est pas ambigu (les deux arbres de dérivation sont les mêmes).

#definition(titre: [Dérivation gauche])[
  Soit $G = (Σ, V, R, S)$ une grammaire.

  Une dérivation gauche pour $u$ est une dérivation où, à chaque étape, on remplace la variable la plus à gauche.
]
#underline[Exemple] : $S ⇒ S + S ⇒ 2 + S ⇒ 2 + S × S ⇒ 2 + 2 × S ⇒ 2 + 2 × 2$ est une dérivation gauche pour $2 + 2 × 2$.

#theoreme[
  Soient $G$ une grammaire et $u ∈ cal(L)(G)$. Il y a une bijection entre les dérivations gauches de $u$ et les arbres de dérivation de $u$.
]
#underline[Preuve] :
#reponse(5)

D'où :
#theoreme[
  Soit $G$ une grammaire et $u ∈ cal(L)(G)$.

  $u$ est ambigu pour $G$ si et seulement si $u$ possède plusieurs dérivations gauches.
]

#exercice[
  Montrer qu'un langage régulier est engendré par une grammaire non ambiguë.
  #reponse(2)
]

#definition(titre: [Faible équivalence])[
  Deux grammaires $G_1$ et $G_2$ sont dites faiblement équivalentes si $cal(L)(G_1) = cal(L)(G_2)$.
]
#underline[Remarque] : le terme « faiblement » vient du fait qu'on ne demande que l'égalité sur les langages et pas sur les arbres de dérivation. Ainsi, une grammaire ambiguë peut être faiblement équivalente à une grammaire non ambiguë.

#block(breakable: false)[
#underline[Exemple] : la grammaire définie par $S → S + S ∣ S × S ∣ (S) ∣ 2$ est ambiguë mais est faiblement équivalente à la grammaire non ambiguë suivante (admis) :
$ S &→ S + T ∣ T \
  T &→ T × F ∣ F \
  F &→ (S) ∣ 2 $
On force ici la priorité des opérations.
]

#underline[Remarques] :
- Il est indécidable de savoir si une grammaire est ambiguë, c'est-à-dire qu'il n'existe pas d'algorithme qui, étant donnée une grammaire, détermine si elle est ambiguë.
- Un langage non-contextuel qui ne peut être engendré que par une grammaire ambiguë est dit intrinsèquement ambigu.

#underline[Exemple (_dangling else_)] : la grammaire $S → "if" S "else" S ∣ "if" S ∣ "…"$ est ambiguë car `if ... if ... else ...` peut être dérivé de deux façons.

= Analyse syntaxique

L'analyse d'un code source lors de la compilation comporte deux grandes étapes :
+ Analyse lexicale : découpe le code source en une liste de lexèmes (mots-clés, identifiants, opérateurs…) en vérifiant que le code est bien formé lexicalement.

  Utilise un automate fini déterministe.
+ Analyse syntaxique (_parsing_) : construit l'arbre de dérivation du code source.

  Utilise un algorithme _top-down_ ou _bottom-up_.

#underline[Exemple] : Une expression arithmétique postfixe (ou : polonaise inverse) consiste à écrire les opérateurs après les opérandes : $3 quad 4 quad + quad 5 quad ×$ au lieu de $(3 + 4) × 5$. Grammaire (non ambiguë) :
#reponse(2)

On simplifiera l'écriture d'un arbre syntaxique
#align(center, grid(
  columns: (auto, auto, auto), align: center + horizon, column-gutter: 2em,
  arbre(
    (((0, 0), $S$), ((-1.5, -1), $S$), ((0, -1), $S$), ((1.5, -1), $B$), ((-1.5, -2), $…$), ((0, -2), $…$), ((1.5, -2), $+$)),
    ((0, 1), (0, 2), (0, 3), (1, 4), (2, 5), (3, 6)),
  ),
  [par],
  arbre(
    (((0, 0), $+$), ((-1, -1), $…$), ((1, -1), $…$)),
    ((0, 1), (0, 2)),
  ),
))

On utilise le type suivant :
```ocaml
type token = I of int | B of char
type arbre = F of int | N of token * arbre * arbre
```
Ainsi, $3 quad 4 quad + quad 5 quad ×$ est représenté par :
- la liste de tokens `[I 3; I 4; B '+'; I 5; B '*']`
- l'arbre `N (B '*', N (B '+', F 3, F 4), F 5)`.

On parcourt la liste de tokens en utilisant une pile pour stocker les arbres en cours de construction.
- Si on rencontre un entier `k`, on ajoute un arbre feuille `F k` à la pile.
- Si on rencontre un opérateur `op`, on extrait d'abord le sous-arbre droit `a2`, puis le sous-arbre gauche `a1`, et on ajoute l'arbre `N (B op, a1, a2)` à la pile.
- Quand on a fini de parcourir la liste, le seul arbre restant dans la pile est l'arbre de dérivation (une pile insuffisante lors d'un opérateur, ou ne contenant pas exactement un arbre à la fin, signale une expression mal formée).

#exercice[
  Écrire une fonction `parse : token list -> arbre` qui prend une liste de tokens et renvoie l'arbre de dérivation correspondant.
  #reponse(6)
]
