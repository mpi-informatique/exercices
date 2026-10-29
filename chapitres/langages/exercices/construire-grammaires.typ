#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  colonnes: 2,
  meta: (
    titre: "Trouver une grammaire",
    chapitres: ("grammaires-non-contextuelles", "automates-finis"),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
  contenu: (
    [Montrer que chacun des langages suivants est non-contextuel en donnant une grammaire et en justifiant que son langage est exactement celui demandé.
      Tous les exposants sont des entiers naturels.],
    question([$L_1 = (a b)^*$.], solution: [
      Prendre $S → a b S ∣ ε$.
      Toute dérivation terminale applique $k$ fois la première règle, puis la seconde, et produit $(a b)^k$. Réciproquement, tout $k ∈ ℕ$ est possible.
    ]),
    question([$L_2 = {a^n b^p | n ≥ p}$.], solution: [
      Prendre $S → a S b ∣ a S ∣ ε$.
      Les règles non terminales ajoutent soit un $a$ et un $b$, soit seulement un $a$, en conservant tous les $a$ avant les $b$ : elles produisent donc uniquement des mots de $L_2$.
      Pour engendrer $a^n b^p$, appliquer $p$ fois la première règle, $n-p$ fois la deuxième, puis terminer par $ε$.
    ]),
    question(
      [
        $L_3$ = représentations en base $2$ des multiples de $3$.
      ],
      solution: [
        Le reste modulo $3$ devient $2r$ après lecture de $0$, et $2r+1$ après lecture de $1$.
        Prendre les règles
        $
          S → 1 X_1 ∣ 0 quad
          X_0 → 0 X_0 ∣ 1 X_1 ∣ ε quad
          X_1 → 0 X_2 ∣ 1 X_0 quad
          X_2 → 0 X_1 ∣ 1 X_2
        $
        Une forme $m X_r$ obtenue après le premier $1$ indique que la valeur de $m$ a pour reste $r$ modulo $3$. Seul $X_0$ peut terminer.
        Chaque représentation non nulle est donc engendrée exactement lorsqu'elle est divisible par $3$.
        La règle $S → 0$ ajoute zéro et aucune règle ne produit de zéro initial superflu ni le mot vide.
      ],
    ),
    question([$L_4 = {a^i b^j c^k | i = j+k}$.], solution: [
      Prendre $S → a S c ∣ X$ et $X → a X b ∣ ε$.
      Toute dérivation terminale applique $k$ fois $S → a S c$, puis $S → X$, puis $j$ fois $X → a X b$ et enfin $X → ε$.
      Elle produit exactement $a^(j+k) b^j c^k$, et tous les couples $(j,k) ∈ ℕ^2$ sont possibles.
    ]),
  ),
)
