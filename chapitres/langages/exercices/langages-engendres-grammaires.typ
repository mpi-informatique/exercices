#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  colonnes: 2,
  meta: (
    titre: "Trouver le langage engendré",
    chapitres: ("grammaires-non-contextuelles", "recursivite-et-induction"),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [Déterminer les langages engendrés par les grammaires suivantes, d'axiome $S$, en prouvant les deux inclusions. On note $abs(w)_a$ le nombre d'occurrences de $a$ dans $w$.],
    question(
      [
        $
          S → X ∣ Y \
          X → a X ∣ a Z \
          Y → Y b ∣ Z b \
          Z → ε ∣ a Z b
        $
      ],
      solution: [
        Depuis $Z$, les dérivations produisent exactement les $a^n b^n$, pour $n ∈ ℕ$.
        Depuis $X$, on ajoute un nombre strictement positif de $a$ devant un tel mot :
        on obtient exactement ${a^n b^p | n > p}$.
        Depuis $Y$, on ajoute un nombre strictement positif de $b$ après un tel mot :
        on obtient exactement ${a^n b^p | n < p}$.
        Ainsi $L(G_1) = {a^n b^p | n,p ∈ ℕ, n ≠ p}$.
      ],
    ),
    question(
      [
        $
          S → 0 A 1 ∣ ε \
          A → 1 S 0 ∣ ε
        $
      ],
      solution: [
        Les deux premières étapes d'une dérivation terminale depuis $S$ donnent soit $ε$, soit $01$, soit $01 S 01$. Une récurrence sur la longueur de la dérivation montre donc que tous les mots engendrés appartiennent à $(01)^*$.

        Réciproquement, $ε$ et $01$ sont engendrés. Pour $n ≥ 2$, on utilise
        $ S ⇒ 0 A 1 ⇒ 01 S 01 ⇒^* 01 (01)^(n-2) 01 = (01)^n, $
        par récurrence sur $n$. Ainsi $L(G_2) = (01)^*$.
      ],
    ),
    question(
      [
        $
          S → X ∣ X a S \
          X → a X b X ∣ b X a X ∣ ε
        $
      ],
      solution: [
        Montrons d'abord que $X$ engendre exactement les mots ayant autant de $a$ que de $b$.
        Chaque règle conserve cette égalité.
        Réciproquement, pour un mot équilibré non vide commençant par $a$, prendre son premier
        préfixe équilibré non vide : le mot s'écrit $a u b v$, avec $u$ et $v$ équilibrés.
        S'il commence par $b$, il s'écrit de même $b u a v$.
        Une récurrence sur la taille fournit alors une dérivation depuis $X$.

        Toute dérivation terminale depuis $S$ produit $u_0 a u_1 a … a u_k$, où les $u_i$ sont équilibrés et $k ≥ 0$.
        Elle a donc un excédent de $k$ lettres $a$.

        Réciproquement, tout mot d'excédent $k ≥ 0$ possède cette décomposition.
        Pour $k > 0$, considérer le dernier préfixe d'excédent nul.
        La lettre suivante est $a$ : si c'était $b$, l'excédent devrait repasser par zéro avant d'atteindre la valeur finale positive. Le suffixe restant a l'excédent $k-1$.
        Une récurrence sur $k$ conclut, avec le cas équilibré pour $k=0$.
        Ainsi
        $ L(G_3) = {w ∈ {a,b}^* | abs(w)_a ≥ abs(w)_b}. $
        En particulier, $S → X$ permet les mots équilibrés et $ε$.
      ],
    ),
    question(
      [
        $
          S → X ∣ Y \
          X → Z 0 X ∣ Z 0 Z \
          Y → Z 1 Y ∣ Z 1 Z \
          Z → ε ∣ 1 Z 0 Z ∣ 0 Z 1 Z
        $
      ],
      solution: [
        La preuve précédente, avec $0$ et $1$ à la place de $a$ et $b$, montre que $Z$ engendre exactement les mots équilibrés.
        Les dérivations depuis $X$ produisent exactement les mots $u_0 0 u_1 … 0 u_k$, où les $u_i$ sont équilibrés et $k ≥ 1$ : ce sont tous les mots ayant plus de $0$ que de $1$, grâce à la décomposition démontrée à la question précédente.
        Symétriquement, $Y$ engendre tous les mots ayant plus de $1$ que de $0$.
        Ainsi
        $ L(G_4) = {w ∈ {0,1}^* | abs(w)_0 ≠ abs(w)_1}. $
      ],
    ),
  ),
)
