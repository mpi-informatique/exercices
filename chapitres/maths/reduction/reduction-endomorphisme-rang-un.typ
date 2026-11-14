#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
      titre: "Réduction en rang un",
      chapitres: ("reduction",),
      difficulte: 3,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soient $E$ un espace vectoriel réel de dimension $n ≥ 2$, $a ∈ E ∖ {0}$ et $φ$ une forme linéaire non nulle sur $E$.
  On définit $u ∈ cal(L)(E)$ par $u(x) = φ(x)a$ et on pose $t = φ(a)$.

  #question[Déterminer le noyau et l'image de $u$, puis calculer $u^2$.][Comme $a ≠ 0$, $ker u = ker φ$, de dimension $n - 1$.
          Puisque $φ$ est non nulle, son image est $RR$, donc $"Im" u = RR a$.
          Enfin $u^2 (x) = φ(x)φ(a)a = t u(x)$ pour tout $x$, soit $u^2 = t u$.]

  #question[Si $t ≠ 0$, déterminer les valeurs propres et les sous-espaces propres de $u$. En déduire sa diagonalisabilité et son polynôme caractéristique.][On a $u(a) = t a$, donc $RR a ⊂ E_t (u)$.
          Si $u(x) = t x$, alors $x = φ(x)a/t ∈ RR a$, d'où $E_t (u) = RR a$.
          D'autre part $E_0 (u) = ker φ$. Ces deux sous-espaces propres sont en somme directe et leurs dimensions ont pour somme $n$.
          Ils donnent une base propre, donc $u$ est diagonalisable et $χ_u (X) = X^(n - 1) (X - t)$. Il n'y a pas d'autre valeur propre.]

  #question[Si $t = 0$, déterminer l'indice de nilpotence et le polynôme caractéristique de $u$. L'endomorphisme $u$ est-il diagonalisable ?][On a $u^2 = 0$ mais $u ≠ 0$, donc l'indice de nilpotence est $2$.
          La caractérisation des endomorphismes nilpotents donne $χ_u (X) = X^n$.
          Une matrice diagonale semblable à $u$ aurait uniquement des zéros sur sa diagonale, ce qui imposerait $u = 0$. Ainsi $u$ n'est pas diagonalisable.]
]
