#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Calcul à l'aide d'une fonction affine",
      chapitres: ("determinants",),
      difficulte: 3,
      niveaux: ("MP",),
      matiere: "mathématiques",
    ),
)[
  Soit $A = (a_(i, j)) in cal(M)_(n)(RR)$. Pour $x in RR$, on note $A(x)$ la matrice dont le coefficient d'indices $(i, j)$ est $a_(i, j) + x$.

  #question[Montrer que la fonction $x ↦ det(A(x))$ est polynomiale de degré inférieur ou égal à $1$.][Retrancher la première colonne à chacune des autres colonnes.
          La première colonne de la matrice obtenue est formée des coefficients $a_(i, 1) + x$, tandis que les autres colonnes sont indépendantes de $x$.
          En développant suivant la première colonne, obtenir
          $ det(A(x)) = sum_(i = 1)^n (-1)^(i + 1) (a_(i, 1) + x) det(A_(i)) $,
          où les matrices $A_(i)$ sont indépendantes de $x$.
          Cette expression est polynomiale de degré inférieur ou égal à $1$.]

  #question[Soient $a$ et $b$ deux réels distincts et $alpha_(1), dots, alpha_(n) in RR$. En déduire la valeur du déterminant
          $ lr(
            mat(
              delim: "|",
              alpha_(1), a, dots.h, a;
              b, alpha_(2), dots.down, dots.v;
              dots.v, dots.down, dots.down, a;
              b, dots.h, b, alpha_(n)
            )
          ) $.][Noter $D(x)$ le déterminant de la matrice obtenue en ajoutant $x$
          à chacun des coefficients. D'après la question précédente, $D(x) = lambda x + mu$.

          Pour $x = -a$, la matrice est triangulaire inférieure, donc $D(-a) = product_(i = 1)^n (alpha_(i) - a)$.
          Pour $x = -b$, elle est triangulaire supérieure, donc $D(-b) = product_(i = 1)^n (alpha_(i) - b)$.
          L'interpolation affine entre ces deux valeurs donne
          $ D(0) = frac(
            a product_(i = 1)^n (alpha_(i) - b)
            - b product_(i = 1)^n (alpha_(i) - a),
            a - b
          ) $.]
]
