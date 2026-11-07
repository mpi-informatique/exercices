#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Exemples de langages réguliers",
      chapitres: ("langages-reguliers",),
      difficulte: 2,
      niveaux: ("MPI",),
    ),
)[
  #question[
          Donner une expression régulière dont le langage est l'ensemble des mots sur ${a,b,c}$ contenant exactement un $a$ et un $b$ (et un nombre quelconque de $c$).
        ][
          En distinguant l'ordre d'apparition de $a$ et $b$, on obtient
          $ c^* a c^* b c^* | c^* b c^* a c^*. $
        ]

  #question[
          Donner une expression régulière dont le langage est l'ensemble des mots sur ${a,b,c}$ ne contenant pas de $a$ consécutifs ($a a$ ne doit pas apparaître).
        ][
          L'expression $(a(b|c)|b|c)^*(a|epsilon)$ convient : un $a$ qui n'est pas en dernière position doit être suivi d'un $b$ ou d'un $c$.
        ]

  #question[
          Donner une expression régulière dont le langage est l'ensemble des mots sur ${a,b,c}$ contenant exactement deux $a$ et tels que tout $c$ est immédiatement précédé d'un $b$.
        ][
          Posons $e=(b|b c)^*$, qui décrit les mots sur ${b,c}$ dont chaque $c$ est immédiatement précédé d'un $b$.
          L'expression $e a e a e$ convient.
        ]

  Si $x in RR$, on note $L(x)$ l'ensemble des préfixes de la suite des chiffres de $x$ après la virgule.
  On utilise le développement décimal qui ne se termine pas par une infinité de $9$.
  Par exemple,
  $ L(pi)={epsilon,1,14,141,1415,dots}. $

  #question[
          En sachant que $1/6=0.1666 dots$ et $1/7=0.142857142857 dots$, montrer que $L(1/6)$ et $L(1/7)$ sont réguliers.
        ][
          Une expression pour $L(1/6)$ est $epsilon | 1 6^*$.
          Une expression pour $L(1/7)$ est
          $ (142857)^*(epsilon | 1 | 14 | 142 | 1428 | 14285 | 142857). $
        ]

  #question[
          Montrer plus généralement que $L(x)$ est régulier si $x in QQ$
          (on montrera plus tard que c'est en fait une équivalence).
        ][
          Le développement décimal d'un rationnel est ultimement périodique : la partie après la virgule s'écrit $t p p p dots$, avec $t$ un mot fini et $p$ un mot fini non vide (on peut prendre $p=0$ pour un décimal).
          Notons $"Pref"(m)$ l'ensemble fini des préfixes de $m$.
          On a
          $ L(x)="Pref"(t) union {t} {p}^* "Pref"(p). $
          Un préfixe s'arrête soit dans $t$, soit après $t$, un certain nombre de copies de $p$ et un préfixe de $p$.
          Ce langage est régulier par stabilité par union, concaténation et étoile.
        ]

  #question[
          Donner une expression régulière dont le langage est ${a^n b^p | n,p in NN, n equiv p (mod 2)}$.
        ][
          Les deux exposants sont pairs ou tous deux impairs.
          L'expression
          $ (a a)^*(b b)^* | a(a a)^* b(b b)^* $
          convient.
        ]
]
