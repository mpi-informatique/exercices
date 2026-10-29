#import "/load.typ": automate, code, exercice, question
#import code: code-extrait

#import automate: dessiner-automate

#let code = code-extrait.with(read("corrige.ml"))

#let ex = exercice(
  meta: (
    titre: "Algorithme de McNaughton-Yamada",
    chapitres: ("langages-reguliers", "automates-finis", "algorithmique"),
    algorithmes: ("programmation-dynamique",),
    langages: ("OCaml",),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [
      On présente une alternative à la méthode d'élimination des états pour convertir un automate en expression régulière, avec un algorithme par programmation dynamique similaire à Floyd-Warshall.

      Soit $A = (Σ, Q, 0, F, δ)$ un automate déterministe tel que $Q = {0, …, n - 1}$. Pour $i, j ∈ Q$ et $k ∈ {0, …, n}$, on note $L(i, j, k)$ le langage des étiquettes des chemins de $i$ à $j$ dont tous les états intermédiaires -- sauf les extrémités -- sont strictement inférieurs à $k$.
    ],
    question([Montrer que $L(i, j, 0)$ est régulier, pour tout $i, j ∈ Q$.], solution: [
      Soient $i, j ∈ Q$ deux états.
      - Si $i ≠ j$, $L(i, j, 0) = {a ∈ Σ | delta(i, a) = j}$.
      - Si $i = j$, $L(i, i, 0) = {a ∈ Σ | delta(i, a) = i} ∪ {ε}$.
      Dans les deux cas, le langage est fini donc régulier.
    ]),
    question([Donner une équation de récurrence sur $L(i, j, k)$.], solution: [
      Soit $m ∈ L(i, j, k + 1)$ l'étiquette d'un chemin $C$ de $i$ à $j$ avec des états intermédiaires inférieurs ou égaux à $k$.
      - Si $C$ n'utilise pas l'état $k$ comme état intermédiaire : $m ∈ L(i, j, k)$
      - Sinon, en coupant à chaque passage intermédiaire par $k$, on décompose $C$ en un chemin de $i$ à $k$, zéro ou plusieurs chemins de $k$ à $k$, puis un chemin de $k$ à $j$. Chacun n'a que des états intermédiaires strictement inférieurs à $k$.

      #dessiner-automate(
        (("i", (0, 0), false, false), ("k", (5, 0), false, false), ("j", (10, 0), false, false)),
        (
          ("i", "k", "L(i, k, k)", (curve: 0)),
          ("k", "k", "L(k, k, k)", (anchor: top)),
          ("k", "j", "L(k, j, k)", (curve: 0)),
        ),
      )

      Réciproquement, une telle concaténation n'a que des états intermédiaires inférieurs ou égaux à $k$. On obtient donc :
      $ L(i, j, k + 1) = L(i, j, k) ∪ L(i, k, k) L(k, k, k)^* L(k, j, k). $
    ]),
    question([En déduire, par récurrence, que tout langage reconnaissable est régulier.], solution: [
      Montrons par récurrence sur $k ∈ {0, …, n}$ la propriété $P(k)$ : « pour tout $i, j ∈ Q$, $L(i, j, k)$ est régulier ».
      - $P(0)$ est vraie d'après la question 1.
      - Supposons $P(k)$ vraie pour un $k$ tel que $0 ≤ k < n$. Les langages $L(i, j, k)$, $L(i, k, k)$, $L(k, k, k)$ et $L(k, j, k)$ sont réguliers par hypothèse de récurrence. La relation de la question précédente montre que $L(i, j, k + 1)$ est régulier par stabilité par union, concaténation et étoile. Donc $P(k + 1)$ est vraie.

      $cal(L)(A) = ⋃_(f ∈ F) L(0, f, n)$ est une union finie de langages réguliers donc est régulier. On conclut en utilisant le fait que tout langage reconnaissable est reconnu par un automate déterministe.
    ]),
    question(
      [
        Implémenter cet algorithme en ```ocaml to_regexp : 'a automate -> 'a regexp```.
        Préciser la complexité, en temps et mémoire.
        #grid(
          columns: (1fr, 1fr),
          column-gutter: 1.5em,
          align: top,
          code("regexp"), code("automate"),
        )
      ],
      solution: [
        #block(breakable: false)[#code("to_regexp")]

        Avant l'itération $k$, ```ocaml l.(i).(j)``` dénote $L(i, j, k)$. Les copies de la ligne et de la colonne $k$ permettent d'appliquer la récurrence en utilisant les valeurs précédentes.

        Pour $m$ transitions, le temps est $O(n^3 + m)$ : chaque constructeur partage ses sous-expressions en $O(1)$.
        La matrice occupe $O(n^2)$ cases, mais les expressions construites peuvent occuper $O(n^3 + m)$ en mémoire. Leur écriture complète peut être de taille exponentielle.
      ],
    ),
  ),
)
