#import "/load.typ": automate, code, exercice, feuille, partie, question, sep, theoremes
#import automate: Lloc, dessiner-automate
#import automate: cetz, finite, style-automates, unite-automates
#import code: code-extrait
#import theoremes: definition

#import "/chapitres/langages/exercices/intersection-grammaire-ogden.typ": lemme-etoile

#let source = read("corrige.ml")
#let code = code-extrait.with(source)

#let automate-glushkov = dessiner-automate(
  (
    ("0", (0, 0), true, true),
    ("a_(1)", (3, 0), false, false),
    ("a_(2)", (6, 0), false, true),
  ),
  (
    ("0", "a_(1)", "a", (curve: 0)),
    ("a_(1)", "a_(2)", "a", (curve: 0.8)),
    ("a_(2)", "a_(1)", "a", (curve: 0.8)),
  ),
)

#let automate-k = dessiner-automate(
  (
    ("q_(0)", (0, 0), true, false),
    ("q_(1)", (2.5, 0), false, false),
    ("q_(2)", (5, 0), false, true),
    ("q_(3)", (7.5, 0), false, true),
    ("q_(4)", (10, 0), false, false),
    ("q_(5)", (10, -2.5), false, true),
    ("q_(6)", (7.5, -2.5), false, false),
    ("q_(7)", (5, -2.5), false, true),
  ),
  (
    ("q_(0)", "q_(1)", "a", (curve: 0)),
    ("q_(1)", "q_(2)", "a", (curve: 0)),
    ("q_(2)", "q_(3)", "a", (curve: 0)),
    ("q_(3)", "q_(4)", "a", (curve: 0)),
    ("q_(4)", "q_(5)", "a", (curve: 0)),
    ("q_(5)", "q_(6)", "a", (curve: 0)),
    ("q_(6)", "q_(7)", "a", (curve: 0)),
    ("q_(7)", "q_(2)", "a", (curve: 0)),
  ),
)

#let ex = exercice(
  meta: (
      titre: "Langages unaires",
      chapitres: (
        "langages-reguliers",
        "automates-finis",
        "grammaires-non-contextuelles",
        "graphes",
        "recursivite-et-induction",
        "algorithmique",
      ),
      algorithmes: ("berry-sethi",),
      structures: ("tableau", "graphe"),
      langages: ("OCaml",),
      difficulte: 4,
      niveaux: ("MPI",),
      duree: (5, 0),
    ),
)[
  Dans tout le sujet, $Σ$ désigne l'alphabet ${a}$. Un langage sur $Σ$ est dit _unaire_.

  #partie(
    "Langages locaux unaires",
    numero: "I",
    (
          definition[Langage local][
            Pour un langage $L$, on note $P(L)$ l'ensemble des premières lettres de ses mots non vides, $S(L)$ l'ensemble de leurs dernières lettres et $F(L)$ l'ensemble des facteurs de taille deux de ses mots.
            Le langage $L$ est _local_ si, pour tout mot $u = u_1…u_n != epsilon$ :
            $
              u ∈ L <==> u_1 ∈ P(L) ∧ u_n ∈ S(L)
              ∧ (∀i ∈ {1, …, n - 1}, #sep u_(i) u_(i + 1) ∈ F(L)).
            $
          ],
          question(bareme: 1)[Est-ce que $L = (a a)^*$ est un langage local ?][
              $P(L) = S(L) = {a}$ et $F(L) = {a a}$.
              Soit $u = a$. Alors $u$ a sa première lettre dans $P(L)$, sa dernière dans $S(L)$ et ses facteurs dans $F(L)$ mais $u in.not L$ : $L$ n'est pas local.
            ],
          question(bareme: 2, notation: [50 % au plus pour un automate reconnaissant le bon langage sans respecter la construction de Glushkov. Exiger la linéarisation ou une construction équivalente explicite par positions ; accepter tout renommage des états.])[Construire, par l'algorithme de Berry-Sethi, l'automate de Glushkov de $(a a)^*$.][
              $P(L) = {a_(1)}$, $S(L) = {a_(2)}$ et $F(L) = {a_(1) a_(2), a_(2) a_(1)}$. Après construction de l'automate et retour à l'alphabet de départ :
              #automate-glushkov
            ],
          question(bareme: 3, label: <q-unaires-locaux>)[Déterminer l'ensemble $Lloc$ des langages unaires locaux.][
              Soit $L$ un langage local.

              - Si $P(L) = ∅$ ou $S(L) = ∅$, $L$ ne contient aucun mot non vide : $L = ∅$ ou $L = {ε}$.
              Sinon, $P(L) = S(L) = {a}$.
              - Si $F(L) = ∅$, seul le mot $a$ appartient à $L$ parmi les mots non vides : $L = {a}$ ou $L = {ε, a}$.
              - Si $F(L) = {a a}$, tous les mots non vides appartiennent à $L$ : $L = a^+$ ou $L = a^*$.

              Comme ces langages sont bien locaux, l'ensemble des langages locaux unaires est :
              $ Lloc = {∅, #sep {ε}, #sep {a}, #sep {ε, a}, #sep a^+, #sep a^*} $
            ],
          question(bareme: 2.5)[$Lloc$ est-il stable par : $a)$ union, $b)$ concaténation, $c)$ étoile, $d)$ intersection, $e)$ complémentaire dans $Σ^*$ ?][
              $a)$ et $d)$ : oui, en vérifiant toutes les possibilités avec les $6$ langages de $Lloc$.\
              $b)$ : non car ${a} {a} = {a a} in.not Lloc$.\
              $c)$ : oui, car $∅^* = {ε}^* = {ε}$ et ${a}^* = {ε, a}^* = (a^+)^* = (a^*)^* = a^*$.\
              $e)$ : non, car ${ε, a}$ est local mais son complémentaire $a^2 a^*$ ne figure pas dans la liste de la @q-unaires-locaux.
            ],
        ),
  )

  #partie("Structure des automates unaires", numero: "II")[
    Pour $α, β ∈ NN$, on pose :
    $ L(α, β) = {a^(α k + β) | k ∈ NN}. $

    #question(bareme: 1, label: <q-unaires-progressions>)[Déterminer pour quelles valeurs de $α$ et $β$ le langage $L(α, β)$ est fini et donner une expression régulière qui le dénote.][
              $L(α, β)$ est fini si et seulement si $α = 0$ : il vaut alors ${a^β}$. Si $α ≥ 1$, il est infini et est dénoté par $a^β (a^α)^*$. Cette expression convient aussi pour $α = 0$, avec la convention $a^0 = ε$, puisque $ε^*$ dénote ${ε}$.
            ]

    Soit $cal(A) = ({a}, Q, q_(0), F, δ)$ un automate fini déterministe complet.
    On note $q_(n) = δ^*(q_(0), a^n)$.

    #question(bareme: 2, label: <q-unaires-structure>, notation: [Exiger une définition des paramètres par la première répétition, la distinction des états avant cette répétition et la propagation par déterminisme. Une description précise du chemin puis du cycle suffit, sans imposer une récurrence formellement rédigée. Une simple invocation de la finitude ne justifie pas tous les résultats demandés.])[
              Montrer qu'il existe $μ ∈ NN$ et $λ ∈ NN^*$ tels que les états $q_(0), …, q_(μ + λ - 1)$ soient deux à deux distincts et $q_(n + λ) = q_(n)$ pour tout $n ≥ μ$. Justifier que $μ + λ ≤ abs(Q)$.
            ][
              $Q$ est fini donc $(q_n)_(n ∈ NN)$ passe plusieurs fois par le même état.
              Soit $j ≥ 1$ le plus petit indice tel que $q_(j)$ soit déjà apparu, et $μ < j$ tel que $q_(j) = q_(μ)$ et $λ = j - μ$.
              Par minimalité de $j$, $q_(0), …, q_(j - 1)$ sont deux à deux
              distincts, donc $j = μ + λ ≤ abs(Q)$.

              Comme $cal(A)$ est déterministe, $q_(μ + λ) = q_(μ)$ entraîne par récurrence $q_(n + λ) = q_(n)$ pour tout $n ≥ μ$.
              Les $μ$ premières transitions forment un chemin suivi d'un cycle de $λ$ transitions, pour un total de $μ + λ$ états accessibles depuis $q_(0)$ :

              #align(center, cetz.canvas(length: unite-automates, {
                import finite.draw: state, transition
                cetz.draw.set-style(..style-automates)
                state((0, 0), "initial", label: $q_0$, initial: (label: none))
                state((2, 0), "queue", label: $…$, radius: 0.25, stroke: 0pt)
                state((4, 0), "entree", label: $q_μ$)
                state((6, 0), "cycle", label: $…$, radius: 0.25, stroke: 0pt)
                state((8.5, 0), "dernier", label: none)
                cetz.draw.content("dernier.east", $q_(μ + λ - 1)$, anchor: "west", padding: 0.1)
                for (depart, arrivee) in (
                  ("initial", "queue"),
                  ("queue", "entree"),
                  ("entree", "cycle"),
                  ("cycle", "dernier"),
                ) {
                  transition(depart, arrivee, label: (text: $a$, dist: -0.33))
                }
                transition("dernier", "entree", curve: 1, label: (text: $a$, dist: 0.25))
              }))
            ]

    Une partie $E ⊂ NN$ est dite _ultimement périodique_ s'il existe $n_0 ∈ NN$ et $p ∈ NN^*$ tels que, pour tout $n ≥ n_0$ :
    $ n ∈ E ⟺ n + p ∈ E $
    On dit alors que $E$ est $p$-périodique à partir de $n_0$.

    #question(bareme: 1, label: <q-unaires-periodicite>, notation: [Le seuil et la période doivent être précisés, et l'acceptation reliée au caractère final des états. Accepter une rédaction concise lorsque l'égalité des états établit immédiatement l'équivalence d'appartenance. Une répétition pour un décalage arbitraire ne convient pas.])[Montrer que si $L$ est régulier alors $N(L) = {n ∈ NN | a^n ∈ L}$ est ultimement périodique.][
              On considère un automate déterministe complet reconnaissant $L$ et les entiers $μ, λ$ de la question précédente. Pour $n ≥ μ$ :
              $ a^n ∈ L <==> q_(n) ∈ F <==> q_(n + λ) ∈ F <==> a^(n + λ) ∈ L $
              Ainsi $N(L)$ est $λ$-périodique à partir de $μ$.
            ]

    #question(bareme: 1, label: <q-unaires-periodicite-automate>, notation: [La chaîne et le cycle ne suffisent pas : vérifier le choix des états finaux selon les tailles acceptées. Une construction correcte sans justification de l'acceptation ni caractérisation reste partielle.])[
              Réciproquement, construire un automate déterministe complet qui
              reconnaît $L$ lorsque $N(L)$ est ultimement périodique. En déduire une caractérisation des langages réguliers unaires.
            ][
              Soient $n_0 ∈ NN$ et $p ∈ NN^*$ tels que $N(L)$ soit $p$-périodique à partir de $n_0$.
              On construit les $n_0 + p$ états $q_(0), …, q_(n_0 + p - 1)$, avec $q_(0)$ initial, les transitions $q_(i) arrow.r.long^(a) q_(i + 1)$ pour $0 ≤ i < n_0 + p - 1$, puis $q_(n_0 + p - 1) arrow.r.long^(a) q_(n_0)$.
              $q_(i)$ final si et seulement si $i ∈ N(L)$.

              Après la lecture de $a^n$, si $n < n_0$ l'état atteint est $q_(n)$.
              Sinon, c'est $q_(n_0 + ((n - n_0) mod p))$. La définition de la périodicité
              montre que cet état est final si et seulement si $n ∈ N(L)$.

              Ainsi, un langage unaire est régulier si et seulement si son ensemble
              de tailles est ultimement périodique.
            ]

    #question(bareme: 2)[
              Généraliser le résultat de la @q-unaires-periodicite à l'ensemble ${abs(w) | w ∈ L}$ des tailles des mots d'un langage régulier $L ⊂ Γ^*$ sur un alphabet quelconque $Γ$.
              Montrer que la réciproque est fausse lorsque $abs(Γ) ≥ 2$.
            ][
              Partir d'un automate fini reconnaissant $L$ et remplacer l'étiquette de chaque transition par $a$. L'automate non déterministe obtenu reconnaît exactement ${a^n | ∃w ∈ L, #sep abs(w) = n}$. Ce langage unaire est régulier, donc son ensemble de tailles est ultimement
              périodique.

              Pour la réciproque, choisir deux lettres distinctes $b, c ∈ Γ$.
              Le langage ${b^n c^n | n ∈ NN}$ n'est pas régulier, tandis que son ensemble de tailles est l'ensemble des entiers pairs, qui est $2$-périodique à partir de $0$.
            ]

    #question(bareme: 2, notation: [50 % pour un seuil et une période corrects et justifiés, 50 % pour un automate déterministe complet reconnaissant exactement le langage. Accepter d'autres seuils, périodes et automates corrects, sans exiger la minimalité.])[
              Soit $K = L(3, 2) ∪ L(2, 3)$. Déterminer $n_0 ∈ NN$ et $p ∈ NN^*$ tels que $N(K)$ soit $p$-périodique à partir de $n_0$ et construire un automate déterministe complet reconnaissant $K$.
            ][
              Par définition, $N(K) = {3 k + 2 | k ∈ NN} ∪ {2 k + 3 | k ∈ NN}$. Pour $n ≥ 2$, on a donc $n ∈ N(K)$ si et seulement si $n ≡ 2 mod 3$ ou $n$ est impair.
              Modulo $6$, la première condition correspond aux restes $2$ et $5$, et la seconde aux restes $1$, $3$ et $5$. Ainsi, pour tout $n ≥ 2$ :
              $ n ∈ N(K) <==> n mod 6 ∈ {1, 2, 3, 5} <==> n + 6 ∈ N(K). $
              Ainsi $N(K)$ est $6$-périodique à partir de $2$. La construction de la @q-unaires-periodicite-automate donne l'automate suivant :
              #automate-k
            ]

    #question(bareme: 2, label: <q-unaires-union-progressions>, notation: [Évaluer séparément les deux implications. Pour le sens direct, exiger une union finie explicite couvrant aussi les tailles avant le seuil et la justification des deux inclusions. Un produit ou une décomposition en facteurs premiers de la période ne suffit pas à construire cette union. Pour la réciproque, la régularité des progressions et la stabilité par union finie suffisent.])[
              Montrer qu'un langage unaire est régulier si et seulement s'il est une union finie (éventuellement vide) de langages de la forme $L(α, β)$, avec $α, β ∈ NN$.
            ][
              - Supposons $L$ régulier. Soient $n_0 ∈ NN$ et $p ∈ NN^*$ tels que $N(L)$ soit $p$-périodique à partir de $n_0$. \
                Posons $B = {n ∈ N(L) | n < n_0}$ et $R = {r ∈ {0, …, p - 1} | n_0 + r ∈ N(L)}$ et montrons :
                $ L = union.big_(n ∈ B) L(0, n) ∪ union.big_(r ∈ R) L(p, n_0 + r). $
                - Chaque singleton $L(0, n)$ avec $n ∈ B$ est inclus dans $L$. Pour $r ∈ R$, la périodicité donne $n_0 + r + k p ∈ N(L)$ pour tout $k ∈ NN$, donc $L(p, n_0 + r) ⊂ L$.
                - Réciproquement, soit $a^n ∈ L$. Si $n < n_0$, alors $n ∈ B$. Sinon, la division euclidienne de $n - n_0$ par $p$ donne $n = n_0 + r + k p$, avec $0 ≤ r < p$ et $k ∈ NN$. La périodicité entraîne $n_0 + r ∈ N(L)$, donc $r ∈ R$ et $a^n ∈ L(p, n_0 + r)$.

              - Dans l'autre sens, chaque $L(α, β)$ est régulier d'après la @q-unaires-progressions. La stabilité par union finie donne le résultat, y compris pour l'union vide.
            ]

    #question(bareme: 1, notation: [Accepter toute décomposition finie exacte, même redondante. Vérifier les tailles absentes et les concaténations mêlant les deux blocs. Ne pas pénaliser une omission locale dans un ensemble intermédiaire si la description des tailles et la décomposition finale sont sans ambiguïté et correctes.])[Écrire ${a^2, a^3}^*$ comme une union finie de langages de la forme $L(α, β)$.][
              Le mot $ε$ appartient à ce langage, mais pas $a$. Tout entier pair $n ≥ 2$ est un multiple de $2$, et tout entier impair $n ≥ 3$ s'écrit $3 + 2k$ avec $k ∈ NN$.
              Ainsi ${a^2, a^3}^* = {ε} ∪ {a^n | n ≥ 2} = L(0, 0) ∪ L(1, 2)$.
            ]

    #question(bareme: 3)[
              Soit $L$ un langage unaire. Montrer que $L^*$ est régulier.
            ][
              Si $L ⊂ {ε}$, alors $L^* = {ε}$ est régulier. Sinon, soit $p ≥ 1$ tel que $a^p ∈ L$.
              Pour tout $a^n ∈ L^*$ et tout $k ∈ NN$, on a $a^(n + k p) ∈ L^*$.

              Soit $R$ l'ensemble des restes modulo $p$ des tailles des mots de $L^*$.
              Pour chaque $r ∈ R$, notons $m_r$ la plus petite taille d'un mot de $L^*$ congrue à $r$ modulo $p$.
              On a $L(p, m_r) ⊂ L^*$ par la propriété précédente.
              Réciproquement, si $a^n ∈ L^*$ et $r$ est le reste de $n$ modulo $p$, alors $n ≥ m_r$ et $n - m_r$ est un multiple de $p$. Ainsi $a^n ∈ L(p, m_r)$ et
              $ L^* = union.big_(r ∈ R) L(p, m_r). $
              La @q-unaires-union-progressions permet de conclure que $L^*$ est régulier.
            ]

    #question(bareme: 2, notation: [Exiger un argument portant sur la non-régularité de l'étoile, pas seulement sur celle du langage de départ. Un langage non régulier simplement cité ne suffit pas. Accepter tout contre-exemple dont la propriété demandée est effectivement démontrée.])[Soit $L$ un langage sur ${a, b}$. Le langage $L^*$ est-il nécessairement régulier ?][
              Non. Prenons $K = {a^n b^n | n ∈ NN}$. On a $K^* ∩ a^* b^* = K$.
              On montre avec le lemme de l'étoile que $K$ n'est pas régulier. Si $K^*$ était régulier, $K$ le serait aussi par intersection avec le langage régulier $a^* b^*$. Donc $K^*$ n'est pas régulier.
            ]
  ]

  #partie("Algorithme de Floyd", numero: "III")[
    On représente un automate unaire déterministe complet à $n$ états (numérotés de $0$ à $n - 1$) par son tableau de transitions
    ```ocaml delta``` où ```ocaml delta.(q)``` contient $δ(q, a)$. L'état initial est $0$.

    On cherche à calculer les entiers $(μ, λ)$ de la @q-unaires-structure avec l'_algorithme de Floyd_, dit du lièvre et de la tortue.

    Une tortue et un lièvre partent de $q_(0)$. À chaque étape, la tortue avance d'une transition et le lièvre de deux transitions. Après $k$ étapes, la tortue est donc sur l'état $q_(k)$ et le lièvre est sur l'état $q_(2k)$.

    #question(bareme: 1, notation: [50 % pour les deux paramètres, 50 % pour la simulation jusqu'à la première rencontre après au moins un déplacement. Créditer les étapes correctes d'une simulation partielle.])[
              Pour ```ocaml delta = [|1; 2; 3; 4; 2|]```, déterminer $μ$ et $λ$, puis donner les positions successives du lièvre et de la tortue jusqu'à leur première rencontre après au moins un déplacement.
            ][
              Les états parcourus sont $0, 1, 2, 3, 4, 2, 3, 4, …$, donc $μ = 2$ et $λ = 3$.
              Les positions (tortue, lièvre) aux étapes $0, 1, 2, 3$ sont respectivement $(0, 0)$, $(1, 2)$, $(2, 4)$ et $(3, 3)$. La première rencontre après au moins un déplacement a donc lieu à l'étape $3$, dans l'état $3$.
            ]

    #question(bareme: 1.5)[
              Montrer qu'ils finissent par se rencontrer. Plus précisément, montrer que la première rencontre a lieu pour un entier $k ≥ μ$ qui est un multiple de $λ$, avec $k ≤ μ + λ$.
            ][
              Tant que $k < μ$, la tortue est dans le chemin. Elle ne peut pas rencontrer le lièvre : si celui-ci est aussi dans le chemin, les états $q_(k)$ et $q_(2k)$ sont distincts. S'il est déjà dans le cycle, aucun état du cycle ne peut revenir dans le chemin.

              Pour $k ≥ μ$, les deux états sont dans le cycle et $q_(k) = q_(2k)$ si et seulement si leurs indices sont congrus modulo $λ$, c'est-à-dire si $k ≡ 0 mod λ$. Le plus petit multiple strictement positif de $λ$ supérieur ou égal à $μ$ convient et est au plus égal à $μ + λ$.
            ]

    #question(bareme: 1.5)[
              À partir de l'état de la première rencontre $q_(k) = q_(2k)$, proposer une méthode pour déterminer $μ$ et l'état d'entrée du cycle $q_(μ)$ en complexité mémoire $O(1)$, sans modifier le tableau de transitions.
            ][
              Replacer la tortue en $q_(0)$ et laisser le lièvre en $q_(k)$. Les faire avancer chacun d'une transition par étape jusqu'à leur rencontre, en comptant les étapes effectuées. Le compteur est initialisé à $0$ et la rencontre est testée avant chaque déplacement.

              Après $i$ nouvelles étapes, la tortue est en $q_(i)$ et le lièvre en $q_(k + i)$. D'après la question précédente, $k$ est un multiple de $λ$. Pour $i = μ$, les indices $μ$ et $k + μ$ désignent donc le même état du cycle.

              Pour $i < μ$, la tortue est encore dans le chemin, tandis que le lièvre est dans le cycle puisque $k ≥ μ$. Ils ne peuvent pas être égaux.
              La première rencontre a donc lieu exactement après $μ$ étapes, en $q_(μ)$.
              Le compteur donne $μ$ et la position commune donne $q_(μ)$, y compris si $μ = 0$. Seuls deux états et un compteur sont conservés : l'espace auxiliaire est $O(1)$.
            ]

    #question(bareme: 1)[
              Une fois $q_(μ)$ déterminé, proposer une méthode pour calculer $λ$ en complexité mémoire $O(1)$, sans modifier le tableau de transitions. Démontrer la correction de la méthode proposée.
            ][
              Immobiliser la tortue en $q_(μ)$ et y placer le lièvre. Faire avancer le lièvre d'au moins une transition, puis poursuivre jusqu'à son premier retour à la tortue, en comptant tous ses déplacements.

              Après $j ≥ 1$ déplacements, le lièvre se trouve en $q_(μ + j)$. Il retrouve $q_(μ)$ si et seulement si $j$ est un multiple de $λ$.
              Le plus petit tel entier strictement positif est $λ$.
              Le compteur donne donc $λ$. Seuls deux états et un compteur sont conservés : l'espace auxiliaire est $O(1)$.
            ]

    #question(bareme: 2, notation: [Évaluer les trois phases de Floyd et le couple renvoyé, puis les justifications de terminaison et de complexité. Distinguer une erreur propre au programme d'une méthode erronée déjà pénalisée aux questions précédentes. Une boucle sautée dès l'initialisation ou une comparaison des numéros d'états à la place du test de rencontre est une erreur algorithmique, pas une petite erreur de syntaxe.])[
              En déduire une fonction
              ```ocaml forme : int array -> int * int``` telle que
              ```ocaml forme delta``` renvoie $(μ, λ)$ avec l'algorithme de Floyd.
              Justifier la terminaison et déterminer les complexités en temps et en espace auxiliaire.
            ][
              #code("forme")
              Les trois boucles terminent d'après les questions précédentes. La première effectue $k - 1$ itérations, où $k ≤ μ + λ$ est l'indice de la première rencontre. La deuxième en effectue exactement $μ$ et la troisième $λ - 1$, le premier déplacement ayant lieu avant la boucle.
              Le temps total est donc $O(μ + λ)$, donc $O(n)$ puisque $μ + λ ≤ n$.

              L'algorithme ne conserve qu'un nombre constant d'états et de
              compteurs : son espace auxiliaire est $O(1)$.
            ]

    #question(bareme: 1, notation: [Le rang réduit est un nombre de transitions, pas nécessairement un numéro d'état. Exiger le traitement des longueurs avant l'entrée du cycle et la consultation du tableau des états finaux à l'état effectivement atteint. Les complexités doivent être justifiées.])[
              Les entiers $(μ, λ)$ ayant été calculés, expliquer comment tester en temps $O(n)$ si $a^p$ est reconnu par l'automate, pour $p ∈ NN$.
              Les états finaux sont indiqués par un tableau de booléens ```ocaml final```, indexé par les états.
              Justifier cette complexité et déterminer la complexité en mémoire, en supposant les opérations arithmétiques de coût constant.
            ][
              Si $p < μ$, poser $j = p$. Sinon, poser $j = μ + ((p - μ) mod λ)$. La périodicité des états donne dans les deux cas $q_(p) = q_(j)$.
              Partir de l'état $0$, suivre $j$ transitions à l'aide de ```ocaml delta```, puis consulter ```ocaml final``` à l'indice obtenu.

              On a $0 ≤ j < μ + λ$, donc au plus $μ + λ - 1$ transitions sont effectuées. Le temps est $O(μ + λ)$, donc $O(n)$, et l'espace auxiliaire est $O(1)$.
              Ces coûts ne comprennent pas le calcul préalable de $(μ, λ)$, qui a les mêmes bornes.
            ]
  ]

  #partie("Tailles et preuve de non-régularité", numero: "IV")[
    #question(bareme: 0.5, notation: [Accepter l'utilisation correcte du résultat de la question sur l'union finie de progressions même si sa démonstration précédente est incomplète. Exiger le lien entre infinitude de l'union et infinitude d'au moins une progression.])[Justifier que tout langage régulier unaire infini contient un langage $L(p, r)$ avec $p ≥ 1$.][
              C'est une conséquence de la @q-unaires-union-progressions : $L$ est une union finie de langages $L(α, β)$. Comme $L$ est infini, au moins l'un d'eux est infini, donc son paramètre $α$ est strictement positif.
            ]

    #question(bareme: 1.5, label: <q-unaires-ecarts>)[Soit $(u_(n))_(n ∈ NN)$ une suite strictement croissante d'entiers naturels. Montrer que, si le langage ${a^(u_(n)) | n ∈ NN}$ est régulier, la suite des écarts $u_(n + 1) - u_(n)$ est bornée.][
              La question précédente fournit une progression $r + k p$ entièrement contenue dans l'ensemble des tailles.
              Pour $u_(n) ≥ r$, le premier terme de cette progression strictement supérieur à $u_(n)$ est au plus égal à $u_(n) + p$. Comme $u_(n + 1)$ est la taille acceptée suivante, $u_(n + 1) - u_(n) ≤ p$.
              Il reste seulement un nombre fini d'écarts avant la taille $r$ : la suite des écarts est bornée.
            ]

    #question(bareme: 1, label: <q-unaires-carres>, notation: [50 % pour chaque langage : calcul de l'écart, caractère non borné et conclusion par contraposée. Ne pas exiger de redémontrer le résultat précédent. Une erreur locale de recopie dans une factorisation intermédiaire reste sans pénalité si l'écart final et son utilisation sont corrects et sans ambiguïté.])[En déduire que les langages ${a^(n^2) | n ∈ NN}$ et ${a^(3^n + 1) | n ∈ NN}$ ne sont pas réguliers.][
              Par contraposée, des écarts non bornés entre les tailles successives entraînent la non-régularité du langage.
              Pour $u_(n) = n^2$, l'écart vaut $2n + 1$, tandis que pour $u_(n) = 3^n + 1$, il vaut $2 · 3^n$. Ces deux suites d'écarts ne sont pas bornées : les deux langages ne sont pas réguliers.
            ]

    #question(bareme: 2)[
              Soit $(u_(n))_(n ∈ NN)$ une suite strictement croissante d'entiers naturels telle que la suite $u_(n + 1) - u_(n)$ est bornée.
              Le langage ${a^(u_(n)) | n ∈ NN}$ est-il nécessairement régulier ?
            ][
              Non. Soit $C = Σ^* ∖ {a^(n^2) | n ∈ NN}$ et énumérons ses
              tailles dans l'ordre strictement croissant : $u_(0) = 2$, $u_(1) = 3$, $u_(2) = 5$, ...
              Deux entiers consécutifs supérieurs ou égaux à $2$ ne peuvent pas être tous deux des carrés : pour $m ≥ 1$, l'écart entre $m^2$ et $(m + 1)^2$ vaut $2m + 1 ≥ 3$.
              Entre deux tailles successives de $C$, il manque donc au plus un entier. Ainsi, pour tout $n ∈ NN$,
              $ 1 ≤ u_(n + 1) - u_(n) ≤ 2. $

              Pourtant, $C$ n'est pas régulier. S'il l'était, la stabilité des
              langages réguliers par complémentaire rendrait le langage des carrés régulier, contrairement à la question précédente.
            ]

    #question(bareme: 2.5, label: <q-unaires-ecarts-periodiques>)[
              Soit $(u_(n))_(n ∈ NN)$ une suite strictement croissante d'entiers naturels et $d_n = u_(n + 1) - u_(n)$.
              Montrer que ${a^(u_(n)) | n ∈ NN}$ est régulier si et seulement si la suite $(d_n)$ est _ultimement périodique_, c'est-à-dire s'il existe $n_0 ∈ NN$ et $s ≥ 1$ tels que $d_(n + s) = d_n$ pour tout $n ≥ n_0$.
            ][
              Supposer le langage régulier. Soient $n_0 ∈ NN$ et $p ∈ NN^*$ tels que son ensemble de tailles soit $p$-périodique à partir de $n_0$, et $s$ le nombre de tailles acceptées dans ${n_0, …, n_0 + p - 1}$. Le langage étant infini, $s ≥ 1$.
              Choisir $m_0$ tel que $u_(m_0) ≥ n_0$. Pour tout $n ≥ m_0$, $u_(n) + p$ est accepté et l'intervalle $]u_(n), u_(n) + p]$ contient exactement $s$ tailles acceptées, une pour chaque reste accepté modulo $p$.
              Ainsi $u_(n + s) = u_(n) + p$, d'où
              $ d_(n + s) = u_(n + s + 1) - u_(n + s) = u_(n + 1) - u_(n) = d_n. $

              Réciproquement, supposer $d_(n + s) = d_n$ pour tout $n ≥ n_0$ et poser $P = sum_(i = 0)^(s - 1) d_(n_0 + i) ≥ 1$.
              Toute somme de $s$ écarts consécutifs à partir du rang $n_0$ vaut $P$, donc $u_(n + s) = u_(n) + P$ pour tout $n ≥ n_0$. Par récurrence,
              $ u_(n_0 + i + k s) = u_(n_0 + i) + k P quad (0 ≤ i < s, #sep k ∈ NN). $
              Le langage est donc l'union du langage fini ${a^(u_(n)) | n < n_0}$ et des $s$ langages réguliers $L(P, u_(n_0 + i))$, pour $0 ≤ i < s$ : il est régulier.
            ]
  ]

  #partie("Grammaires unaire", numero: "V")[
    Dans cette partie, une grammaire non-contextuelle sur $Σ$ est dite _régulière à droite_ si toutes ses règles sont de la forme $X → a Y$ ou $X → ε$, où $X$ et $Y$ sont des variables.

    #question(bareme: 0.5, notation: [Vérifier à la fois la forme imposée des règles et le langage engendré. Une grammaire équivalente à plusieurs lettres terminales par règle ne satisfait pas entièrement la définition donnée ; une grammaire engendrant un autre langage ne reçoit pas de crédit pour la seule présence des blocs de tailles deux et trois.])[Construire une grammaire régulière à droite engendrant $L(3, 2)$.][
              Prenons $G = (Σ, {S, A, B}, R, S)$, où
              $ R = {S → a A, #sep A → a B, #sep B → ε, #sep B → a S}. $
              Toute dérivation terminale effectue un certain nombre $k ∈ NN$ de tours du cycle $S ⇒ a A ⇒ a^2 B ⇒ a^3 S$, puis se termine par $S ⇒ a A ⇒ a^2 B ⇒ a^2$.
              Les mots engendrés sont donc exactement les $a^(3k + 2)$, pour $k ∈ NN$.
            ]

    #question(bareme: 1, label: <q-unaires-grammaires-automates>)[Transformer un automate fini déterministe sur $Σ$ en une grammaire régulière à droite qui engendre le même langage.][
              Soit $A = (Σ, Q, q_0, F, δ)$ un automate. Construisons la grammaire $G = (Σ, V, R, X_(q_0))$, où $V = {X_q | q ∈ Q}$ contient une variable par état et
              $ R = {X_q → a X_r | q, r ∈ Q, #sep δ(q, a) = r} ∪ {X_f → ε | f ∈ F}. $
              Une dérivation dans $G$ produit exactement les étiquettes d'un chemin de $A$ issu de $q_0$ et ne peut terminer que dans un état final. Ainsi $L(G) = L(A)$.
            ]

    #question(bareme: 1)[Transformer réciproquement une telle grammaire en un automate fini non déterministe.][
              Soit $G = (Σ, V, R, S)$ la grammaire donnée. Construisons l'automate $A = (Σ, V, {S}, F, T)$, où
              $ F = {X ∈ V | (X → ε) ∈ R}, quad T = {(X, a, Y) | X, Y ∈ V, #sep (X → a Y) ∈ R}. $
              Les dérivations terminales de $G$ correspondent exactement aux chemins acceptants de $A$. Ainsi $A$ reconnaît le langage engendré par $G$.
            ]

    On admet :

    #lemme-etoile

    Soit $L$ un langage unaire non-contextuel. On note $n$ un entier donné par le lemme de l'étoile et on pose $P = n!$.

    #question(bareme: 1.5)[Montrer que, pour tout $m ≥ n$, $a^m ∈ L ==> a^(m + P) ∈ L$.][
              Soit $m ≥ n$ tel que $a^m ∈ L$. Le lemme donne une décomposition $a^m = x u y v z$ avec $j = abs(u) + abs(v)$ vérifiant $1 ≤ j ≤ n$.
              Pour tout $k ∈ NN$, le mot $x u^k y v^k z$ appartient à $L$ et a pour taille $m + (k - 1)j$.
              Comme $j$ divise $P = n!$, choisir $k = 1 + P / j$ donne $a^(m + P) ∈ L$.
            ]

    #question(bareme: 1.5, label: <q-unaires-non-contextuels>)[En regroupant les tailles au moins égales à $n$ selon leur reste modulo $P$, écrire $L$ comme une union finie de langages de la forme $L(α, β)$. En déduire que tout langage non-contextuel unaire est régulier.][
              Soit $R$ l'ensemble des restes modulo $P$ des tailles au moins égales à $n$ de mots de $L$. Pour chaque $r ∈ R$, noter $m_r$ la plus petite de ces tailles ayant pour reste $r$.
              La question précédente donne, par récurrence, $L(P, m_r) ⊂ L$.
              Réciproquement, toute taille $m ≥ n$ de $L$ a un reste $r ∈ R$ et s'écrit $m = m_r + k P$ avec $k ∈ NN$.
              Ainsi
              $ L = union.big_(m < n, a^m ∈ L) L(0, m) ∪ union.big_(r ∈ R) L(P, m_r). $
              Les deux unions sont finies, y compris lorsque $R = ∅$. La @q-unaires-union-progressions montre que $L$ est régulier.
            ]

    #question(bareme: 1)[
              En déduire que toute grammaire non-contextuelle unaire admet une grammaire régulière à droite équivalente.
              Le langage ${a^(n^2) | n ∈ NN}$ peut-il être engendré par une grammaire
              non-contextuelle ?
            ][
              Le langage d'une grammaire non-contextuelle unaire est régulier d'après la question précédente. Il est donc reconnu par un automate fini déterministe, que la @q-unaires-grammaires-automates transforme en grammaire régulière à droite.
              La preuve par lemme de l'étoile établit l'existence mais ne donne pas directement d'algorithme de transformation de la grammaire initiale.

              Le langage des tailles carrées n'est pas régulier d'après la @q-unaires-carres. Il n'est donc pas non-contextuel : aucune grammaire
              non-contextuelle ne l'engendre.
            ]

    #question(bareme: 1.5, label: <q-unaires-ambiguite>)[
              Tout langage non-contextuel unaire peut-il être engendré par une grammaire non ambiguë ? Justifier.
              Toute grammaire qui l'engendre est-elle alors nécessairement non ambiguë ?
            ][
              Oui pour la première question. Le langage est régulier, donc reconnu par un automate fini déterministe. La construction de la @q-unaires-grammaires-automates fournit une grammaire régulière à droite équivalente.
              Pour un mot accepté $a^n$, le déterminisme impose les $n$ transitions et donc les $n$ règles qui émettent une lettre. Il faut ensuite appliquer la règle $X_(q_(n)) → ε$. Le mot possède un unique arbre d'analyse, y compris pour $ε$ lorsque l'état initial est final.

              En revanche, une autre grammaire du même langage peut être ambiguë. Par exemple, les règles $S → S S$ et $S → a$ engendrent $a^+$, mais $a^3$ admet deux arbres d'analyse : les deux sous-arbres de la racine produisent respectivement $(a, a a)$ ou $(a a, a)$.
            ]
  ]

  #partie("Langage sans étoile unaire", numero: "VI")[
    Un langage _sans étoile_ sur $Σ$ est obtenu à partir de $∅$, de ${ε}$ et de ${a}$ en utilisant seulement l'union, la concaténation et le passage au complémentaire dans $Σ^*$.

    #question(bareme: 3)[Montrer qu'un langage unaire est sans étoile si et seulement s'il est fini ou cofini (c'est-à-dire de complémentaire fini).
            ][
              Pour une expression sans étoile $e$, notons $cal(L)(e)$ le langage qu'elle dénote. Montrons par induction structurelle sur $e$ la propriété $cal(P)(e)$ : « $cal(L)(e)$ est fini ou cofini ».

              *Cas de base.* Les trois expressions de base dénotent respectivement $∅$, ${ε}$ et ${a}$, qui sont finis : elles vérifient $cal(P)$.

              *Hérédité.* Soient $e_1$ et $e_2$ deux expressions sans étoile vérifiant $cal(P)$. Posons $K = cal(L)(e_1)$ et $L = cal(L)(e_2)$. Par hypothèse d'induction, $K$ et $L$ sont chacun finis ou cofinis. Vérifions la propriété pour chaque construction autorisée.

              - Le complémentaire de $e_1$ dénote $Σ^* ∖ K$. Le complémentaire échange les langages finis et cofinis, donc cette expression vérifie $cal(P)$.
              - L'union de $e_1$ et $e_2$ dénote $K ∪ L$. Si $K$ et $L$ sont finis, leur union est finie. Sinon, elle contient un langage cofini et est donc cofinie. La propriété $cal(P)$ est vérifiée.
              - La concaténation de $e_1$ et $e_2$ dénote $K L$. Si $K$ et $L$ sont finis, $K L$ est fini. Si l'un est vide, $K L = ∅$. Dans les autres cas, l'un des deux est cofini et l'autre est non vide. Supposons $K$ cofini et choisissons $a^r ∈ L$. Il existe $n_0 ∈ NN$ tel que $a^n ∈ K$ pour tout $n ≥ n_0$. Pour $n ≥ n_0 + r$, $a^n = a^(n - r)a^r ∈ K L$, donc $K L$ est cofini. Le cas où $L$ est cofini se traite de même. La propriété $cal(P)$ est vérifiée.

              Par induction structurelle, toute expression sans étoile dénote donc un langage fini ou cofini.

              Réciproquement, chaque singleton ${a^n}$ est sans étoile : il vaut
              ${ε}$ si $n = 0$ et est une concaténation de $n$ copies de ${a}$
              sinon. Tout langage fini est une union finie de tels singletons.
              Tout langage cofini est le complémentaire d'un langage fini. On a bien obtenu exactement les langages finis ou cofinis.
            ]

    #question(bareme: 1)[
              Montrer qu'un langage unaire est sans étoile si et seulement s'il est reconnu par un automate déterministe complet dont l'unique cycle accessible depuis l'état initial est une boucle (c'est-à-dire une transition de l'état vers lui-même).
            ][
              Si l'unique cycle accessible est une boucle, la suite des états atteints devient constante (ils sont tous acceptés ou tous refusés). L'acceptation est donc constante à partir d'une certaine taille : le langage est fini ou cofini, donc sans étoile.

              Réciproquement, si $L$ est fini ou cofini, choisir $n_0$ tel que
              l'appartenance de $a^n$ à $L$ soit constante pour $n ≥ n_0$. On construit le chemin $q_(0) arrow.r.long^(a) … arrow.r.long^(a) q_(n_0)$ avec une boucle étiquetée par $a$ sur $q_(n_0)$. Déclarer $q_(i)$ final si $a^i ∈ L$. Cet automate reconnaît $L$ et son seul cycle accessible est la boucle sur $q_(n_0)$.
            ]

    #question(bareme: 1.5)[
              Comparer, par des inclusions strictes et des exemples, les classes
              des langages unaires locaux, sans étoile, réguliers et
              non-contextuels.
            ][
              Les résultats précédents donnent
              $
                Lloc subset.neq cal(L)_("sans étoile")
                subset.neq cal(L)_("reg") = cal(L)_("non-contextuel").
              $
              Tout langage local unaire est fini ou cofini d'après la liste de la @q-unaires-locaux. L'inclusion est stricte car ${a^2}$ est fini, donc sans
              étoile, mais n'est pas local. Tout langage unaire sans étoile est
              fini ou cofini, donc régulier. L'inclusion est stricte car $(a a)^*$ est régulier mais n'est ni fini ni cofini. Enfin, la @q-unaires-non-contextuels et la @q-unaires-grammaires-automates donnent l'égalité des classes régulière et non-contextuelle sur un alphabet unaire.
            ]
  ]
]

#let sujet = (
  titre: ex.meta.titre,
  exercices: (ex,),
  bareme: none,
)

#show: feuille.with(
  type: "devoir",
  titre: sujet.titre,
  niveau: "MPI",
  duree: (3, 0),
  exercices: sujet.exercices,
  bareme: sujet.bareme,
  corrige: sys.inputs.at("corrige", default: "false") == "true",
  espacement: 11pt,
)
