#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Un minimum sur un ensemble non compact",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 1,
))[
  Munir $RR^2$ de sa norme euclidienne et poser $A = {(x, y) ∈ RR^2 : x y = 1}$.

  #question[Montrer que $A$ est fermé. Est-il compact ?][L'application $(x, y) ⟼ x y$ est continue et $A$ est l'image réciproque du fermé ${1}$. Il est donc fermé.
    Les points $(n, 1 / n)$ appartiennent à $A$ et ne sont pas bornés. Ainsi $A$ n'est pas compact.]

  #question[Déterminer la distance de $0$ à $A$ et tous les points où elle est atteinte.][Pour $(x, y) ∈ A$, $x^2 + y^2 ≥ 2 abs(x y) = 2$, avec égalité si et seulement si $abs(x) = abs(y)$.
    La contrainte $x y = 1$ donne alors $(x, y) = (1, 1)$ ou $(-1, -1)$. La distance vaut $sqrt(2)$ et est atteinte exactement en ces deux points.]

  #question[Que peut-on en conclure sur le rôle de la compacité dans les théorèmes d'existence d'un minimum ?][La compacité assure l'existence d'un minimum d'une fonction continue, mais n'est pas une condition nécessaire. Ici la distance à $0$ atteint son minimum sur un ensemble non compact.]
]
