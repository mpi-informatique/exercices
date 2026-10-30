#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Réciproque du lemme de l'étoile",
    chapitres: ("automates-finis", "langages-reguliers"),
    difficulte: 3,
    niveaux: ("MPI",),
    duree: (0, 20),
    source: "https://marcdefalco.github.io/Langages%20et%20Automates/langages_reguliers_automates/",
  ),
  contenu: (
    [
      Sur $Σ = {a, b, c}$, on considère
      $ L = {a b^n c^n | n ∈ NN} ∪ {a^k u | k ∈ NN ∖ {1}, u ∈ {b, c}^*}. $
    ],
    question(
      [
        Montrer que tout mot $m ∈ L$ de taille au moins $2$ s'écrit $m = x y z$, avec
        $ abs(x y) ≤ 2, quad y ≠ ε, quad x y^* z ⊂ L. $
      ],
      solution: [
        Écrire $m = a^k u$, avec $u ∈ {b, c}^*$. Si $k = 0$, écrire $u = ℓ v$ avec $ℓ ∈ {b, c}$.
        Prendre $x = ε$ et choisir :
        #table(
          columns: 4,
          align: center,
          [Cas], [$y$], [$z$], [Nombre de $a$ dans $y^i z$],
          [$k = 0$], [$ℓ$], [$v$], [$0$],
          [$k = 1$], [$a$], [$u$], [$i$],
          [$k = 2$], [$a a$], [$u$], [$2 i$],
          [$k ≥ 3$], [$a$], [$a^(k - 1) u$], [$k - 1 + i$],
        )
        Dans chaque cas, $1 ≤ abs(y) ≤ 2$.
        Seul le cas $k = 1$, $i = 1$ donne un unique $a$, et alors $u = b^n c^n$.
        Les mots $y^i z$ restent donc dans $L$ pour tout $i ∈ NN$.
      ],
    ),
    question(
      [Montrer que $L$ n'est pas régulier. En déduire que la réciproque du lemme de l'étoile est fausse.],
      solution: [
        Si $L$ était régulier, son intersection avec $cal(L)(a b^* c^*)$ le serait aussi :
        $ K = L ∩ cal(L)(a b^* c^*) = {a b^n c^n | n ∈ NN}. $
        Dans un ADC à $N$ états reconnaissant $K$, deux préfixes $a b^i$ et $a b^j$, avec $0 ≤ i < j ≤ N$, atteignent le même état.
        Le suffixe $c^i$ devrait donc être accepté après les deux, alors que $a b^i c^i ∈ K$ et $a b^j c^i ∉ K$.
        Ainsi $L$ n'est pas régulier malgré la propriété de la première question.
      ],
    ),
  ),
)
