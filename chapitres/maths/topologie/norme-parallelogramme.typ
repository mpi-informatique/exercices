#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une boule en parallélogramme",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 1,
))[
  Pour $v = (x, y) ∈ RR^2$, poser $N(v) = max(abs(x), abs(x + y))$ et $norm(v)_∞ = max(abs(x), abs(y))$.

  #question[Montrer que $N$ est une norme. Dessiner sa boule unité fermée et en donner les sommets.][La positivité et l'homogénéité sont immédiates. Si $N(v) = 0$ alors $x = 0$ et $x + y = 0$, donc $v = 0$.
    Les inégalités triangulaires sur les deux formes linéaires donnent $N(v + w) ≤ N(v) + N(w)$.
    La boule est définie par $-1 ≤ x ≤ 1$ et $-1 ≤ x + y ≤ 1$. Ses sommets sont $(1, 0)$, $(1, -2)$, $(-1, 0)$ et $(-1, 2)$.]

  #question[Trouver les meilleures constantes $a, b > 0$ telles que $a norm(v)_∞ ≤ N(v) ≤ b norm(v)_∞$ pour tout $v ∈ RR^2$.][On a $abs(x) ≤ N(v)$ et $abs(y) ≤ abs(x + y) + abs(x) ≤ 2N(v)$, donc $norm(v)_∞ ≤ 2N(v)$.
    Réciproquement, $N(v) ≤ 2 norm(v)_∞$.
    Les constantes optimales sont $a = 1 / 2$ et $b = 2$, avec égalité respectivement en $(1, -2)$ et $(1, 1)$.]
]
