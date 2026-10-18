#import "/load.typ": automate
#import automate: rayon-etat, rayon-grand-etat, style-automates, unite-automates
#import "/load.typ": exercice, question
#import "@preview/finite:0.5.1" as finite
#import "@preview/cetz:0.4.2" as cetz

// Le produit suit simultanément deux compteurs modulo 2 et modulo 3.
#let produit-modulo(finaux) = align(center, cetz.canvas(length: unite-automates, {
  import finite.draw: state, transition
  cetz.draw.set-style(..style-automates, state: (radius: rayon-grand-etat))
  for i in range(2) {
    for j in range(3) {
      state(
        (3 * j, -3 * i),
        str(i) + str(j),
        label: $(#i,#j)$,
        initial: if (i, j) == (0, 0) { (label: none) } else { false },
        final: (i, j) in finaux,
      )
    }
  }
  for j in range(3) {
    transition("0" + str(j), "1" + str(j), label: (text: $a$, dist: if j == 0 { -0.33 } else { 0.33 }), curve: if j
      == 0 { 0 } else { 0.5 })
    transition("1" + str(j), "0" + str(j), label: (text: $a$, dist: if j == 2 { -0.33 } else { 0.33 }), curve: if j
      == 2 { 0 } else { 0.5 })
  }
  for i in range(2) {
    transition(str(i) + "0", str(i) + "1", label: (text: $b$, dist: if i == 0 { 0.33 } else { -0.33 }), curve: 0)
    transition(str(i) + "1", str(i) + "2", label: (text: $b$, dist: if i == 0 { 0.33 } else { -0.33 }), curve: 0)
    transition(str(i) + "2", str(i) + "0", label: (text: $b$, dist: if i == 0 { -0.33 } else { 0.33 }), curve: if i
      == 0 { -2.0 } else { 2.0 })
  }
}))

#let ex = exercice(
  meta: (
    titre: "Reconnaissable ou non ?",
    chapitres: ("automates-finis", "langages-reguliers"),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
  corrections: [
    - Question 5 : préciser, à la demande de l'utilisateur, les écritures usuelles sans zéros initiaux et adapter l'automate pour exclure le mot vide.
  ],
  contenu: (
    [Pour chacun des langages suivants, dire s'il est reconnaissable ou non. Justifier.
      Pour un mot $m$, $abs(m)_a$ désigne le nombre d'occurrences de $a$.],
    question([$L_1$ est l'ensemble des mots sur ${a,b}$ sans lettres consécutives égales.], solution: [
      Il est reconnaissable par l'automate ci-dessous. L'état $1$ (respectivement $2$) signifie que la dernière lettre lue est $a$ (respectivement $b$).
      L'état $0$ accepte le mot vide ; une répétition de lettre bloque la lecture.
      #align(center, cetz.canvas(length: unite-automates, {
        import finite.draw: state, transition
        cetz.draw.set-style(..style-automates)
        state((0, 0), "0", label: $0$, initial: (label: none), final: true)
        state((3, 0), "1", label: $1$, final: true)
        state((0, -3), "2", label: $2$, final: true)
        transition("0", "1", label: $a$, curve: 0)
        transition("0", "2", label: (text: $b$, dist: -0.33), curve: 0)
        transition("1", "2", label: $b$, curve: 0.5)
        transition("2", "1", label: (text: $a$, dist: -0.33), curve: 0)
      }))
    ]),
    question(
      [$L_2$ est l'ensemble des mots sur ${a,b}$ ayant un nombre pair de $a$ et un nombre de $b$ multiple de $3$.],
      solution: [
        Un automate à deux états suit la parité du nombre de $a$ et un automate à trois états le reste modulo $3$ du nombre de $b$.
        Leur produit reconnaît $L_2$. Son état $(i,j)$ signifie que le nombre de $a$ est congru à $i$ modulo $2$ et celui de $b$ à $j$ modulo $3$. Il commence et accepte en $(0,0)$.
        #produit-modulo(((0, 0),))
        Sur $a$, il passe de $(i,j)$ à $(1-i,j)$ ; sur $b$, à $(i,(j+1) mod 3)$.
        Cet invariant prouve que l'automate reconnaît exactement $L_2$.
      ],
    ),
    question([$L_3={u∈{a,b}^* | abs(u)_a mod 2=abs(u)_b mod 3}$.], solution: [
      Le même automate, avec $(0,0)$ et $(1,1)$ comme états finaux, reconnaît $L_3$ :
      #produit-modulo(((0, 0), (1, 1)))
    ]),
    question([$L_4={m∈{a,b}^* | abs(m)_a=abs(m)_b}$.], solution: [
      Supposons $L_4$ reconnaissable et soit $n≥1$ une taille de pompage.
      Le mot $u=a^n b^n$ appartient à $L_4$ et a une taille au moins $n$.
      Le lemme de l'étoile donne $u=x y z$ avec $abs(x y)≤n$, $y≠ε$ et $x y^k z∈L_4$ pour tout $k∈NN$.
      Le mot $y$ ne contient que des $a$ ; pour $k=0$, $x z$ contient strictement moins de $a$ que de $b$.
      Contradiction : $L_4$ n'est pas reconnaissable.
    ]),
    question(
      [$L_5$ est l'ensemble des écritures usuelles en base $2$ des multiples de $5$.
        Le mot $0$ représente zéro ; toute autre écriture commence par $1$, et le mot vide est exclu.],
      solution: [
        Il est reconnaissable. Pour suivre la valeur modulo $5$, utiliser les états $q_0,…,q_4$ et $δ(q_r,c)=q_((2r+c) mod 5)$ : ajouter le chiffre $c$ à droite remplace la valeur $v$ par $2v+c$.
        L'état $q_0$ est le seul état final parmi ces cinq états.
        Ajouter un état initial $s$, non final : sa transition $1$ mène à $q_1$, et sa transition $0$ mène à un état final $z$ sans transition sortante.
        On accepte ainsi $0$ et les écritures commençant par $1$ de valeur divisible par $5$.
        #align(center, cetz.canvas(length: unite-automates, {
          import finite.draw: state, transition
          cetz.draw.set-style(..style-automates)
          state((-3, -1.5), "s", label: $s$, initial: (label: none))
          state((-3, 1.5), "z", label: $z$, final: true)
          state((0, 0), "0", label: $q_0$, final: true)
          state((0, -3), "1", label: $q_1$)
          state((4, 0), "2", label: $q_2$)
          state((7, -1.5), "4", label: $q_4$)
          state((4, -3), "3", label: $q_3$)
          transition("s", "z", label: $0$, curve: 0)
          transition("s", "1", label: $1$, curve: 0)
          transition("0", "0", label: $0$)
          transition("0", "1", label: $1$, curve: 0)
          transition("1", "2", label: $0$, curve: 0)
          transition("1", "3", label: (text: $1$, dist: -0.33), curve: 0)
          transition("2", "4", label: $0$, curve: 0)
          transition("2", "0", label: $1$, curve: 0)
          transition("3", "1", label: $0$, curve: 1.1)
          transition("3", "2", label: (text: $1$, dist: -0.33), curve: 0)
          transition("4", "3", label: $0$, curve: 0)
          transition("4", "4", label: $1$, anchor: right)
        }))
      ],
    ),
    question([$L_6={a^p | p " est un nombre premier"}$.], solution: [
      Supposons $L_6$ reconnaissable et soit $n$ une taille de pompage.
      Choisissons un nombre premier $p≥n+2$. Le lemme de l'étoile appliqué à $a^p$ donne $a^p=a^(i_1)(a^(i_2))a^(i_3)$ avec $i_1+i_2≤n$, $i_2>0$ et $a^(i_1+k i_2+i_3)∈L_6$ pour tout $k∈NN$.
      Prenons $k=i_1+i_3$. La taille obtenue est $q=(i_1+i_3)(1+i_2)$.
      Les deux facteurs sont strictement supérieurs à $1$, car $i_3=p-i_1-i_2≥2$.
      Donc $q$ n'est pas premier : contradiction.
    ]),
  ),
)
