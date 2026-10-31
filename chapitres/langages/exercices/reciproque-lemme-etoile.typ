#import "/load.typ": automate.Lreg, exercice, lien, question, sep

#let ex = exercice(
  meta: (
    titre: "Réciproque du lemme de l'étoile",
    chapitres: ("automates-finis", "langages-reguliers"),
    difficulte: 3,
    niveaux: ("MPI",),
    duree: (0, 20),
  ),
  contenu: (
    [
      Sur $Σ = {a, b, c}$, soit $L_1 = {a b^n c^n | n ∈ NN}$, $L_2 = {a^n u | n ∈ NN ∖ {1}, u ∈ {b, c}^*}$ et $L = L_1 ∪ L_2$.
    ],
    question(
      [
        Soit $m ∈ L$ tel que $abs(m) ≥ 2$.
        Montrer qu'il existe des mots $x, y, z$ tels que : $ m = x y z, #sep abs(x y) ≤ 2, #sep y ≠ ε, #sep x y^* z ⊂ L. $
      ],
      solution: [
        - Si $m ∈ L_1$ : $m = a b^n c^n$ avec $n ≥ 1$. On choisit $x = ε$, $y = a$ et $z = b^n c^n$. Alors $x y z ∈ L_1$ et $x y^k z ∈ L_2$ pour $k ∈ NN ∖ {1}$.
        - Si $m ∈ L_2$ : $m = a^n u$ avec $n ≠ 1$ et $u ∈ {b, c}^*$.
          - Si $n = 0$ : on écrit $u = u_1 u'$ avec $u_1 ∈ {b, c}$ et on choisit $x = ε$, $y = u_1$, $z = u'$. Alors $x y^* z ⊂ L_2$.
          - Si $n = 2$ : on choisit $x = ε$, $y = a a$, $z = u$. Alors $x y^k z = a^(2 k) u ∈ L_2$ pour tout $k ∈ NN$.
          - Si $n ≥ 3$ : on choisit $x = ε$, $y = a$, $z = a^(n - 1) u$. Alors $x y^* z ⊂ L_2$.

        Dans chaque cas, $m = x y z$ et $1 ≤ abs(y) = abs(x y) ≤ 2$.
      ],
    ),
    question(
      [Montrer que $L$ n'est pas régulier. En déduire que la réciproque du lemme de l'étoile est fausse.],
      solution: [
        Si $L$ était régulier, la stabilité de $Lreg$ par intersection montrerait que $cal(L)(a b^* c^*) ∩ L = L_1$ est régulier.\
        Supposons par l'absurde que $L_1$ soit régulier et soit $n ≥ 1$ donné par le lemme de l'étoile. \
        Le mot $a b^n c^n$ s'écrirait $x y z$ avec $abs(x y) ≤ n$, $y ≠ ε$ et $x y^* z ⊂ L_1$.
        Supprimer $y$ enlève soit l'unique $a$, soit uniquement des $b$, sans toucher aux $c$. Dans les deux cas, $x z ∉ L_1$, contradiction.
        Ainsi $L$ n'est pas régulier, bien qu'il vérifie la conclusion du lemme de l'étoile.

        #underline[Remarque] : On peut aussi utiliser ${b^n c^n | n ∈ NN} = a^(-1) L_1$.
      ],
    ),
  ),
)
