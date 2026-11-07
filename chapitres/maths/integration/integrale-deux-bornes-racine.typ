#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Deux bornes à examiner",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 1,
  ),
)[
  #question[Justifier la convergence de $I = ∫_0^1 1 / sqrt(t(1 - t)) dif t$ en étudiant séparément les deux bornes.][La fonction est continue et positive sur $]0, 1[$.
    En $0$, elle est équivalente à $t^(-1 / 2)$ et, en $1$, à $(1 - t)^(-1 / 2)$.
    Les deux intégrales de référence convergent.
    Les intégrales sur $]0, 1 / 2]$ et $[1 / 2, 1[$ convergent donc, ce qui définit $I$.]

  #question[Calculer $I$ avec le changement de variable $t = (sin u)^2$.][Pour $0 < a < b < 1$, poser $t = (sin u)^2$ sur $]0, π / 2[$.
    Comme $sin u$ et $cos u$ y sont positifs,
    $ ∫_a^b 1 / sqrt(t(1 - t)) dif t = 2( arcsin sqrt(b) - arcsin sqrt(a) ). $
    En faisant tendre séparément $a$ vers $0$ et $b$ vers $1$, on obtient $I = π$.]
]
