#import "/load.typ": est-corrige
#import "/load.typ": code
#import code: code-extrait
#import "/load.typ": automate
#import automate: rayon-etat, rayon-grand-etat, style-automates, unite-automates
#import "/load.typ": exercice, partie, question
#import "/load.typ": sep, widetilde
#import "@preview/cetz:0.4.2" as cetz
#import "@preview/finite:0.5.1" as finite

// Le code affiché est exactement celui compilé et testé.
#let code = code-extrait.with(read("corrige.ml"))

#let automate-a1(miroir: false) = align(center, cetz.canvas(length: unite-automates, {
  import finite.draw: state, transition
  cetz.draw.set-style(..style-automates)
  state((0, 0), "s0", label: $0$, initial: if miroir { false } else { (label: none) }, final: miroir)
  state((2.5, 0), "s1", label: $1$)
  state((5, 0), "s2", label: $2$, initial: if miroir { (anchor: right, label: none) } else { false }, final: not miroir)
  if miroir {
    transition("s1", "s0", label: $a$, curve: 0)
    transition("s2", "s1", label: $b$, curve: 0)
  } else {
    transition("s0", "s1", label: $a$, curve: 0)
    transition("s1", "s2", label: $b$, curve: 0)
  }
  transition("s0", "s0", label: $a,b$, anchor: top)
  transition("s2", "s2", label: $a$, anchor: top)
}))

#let arbre-e4() = align(center, cetz.canvas({
  cetz.draw.set-style(content: (padding: 0.08))
  cetz.tree.tree(
    ($|$, $a$, ($dot$, $b$, ($dot$, $b$, ($dot$, $b$, ($dot$, $b$, $∅$))))),
    grow: 0.7,
    spread: 0.5,
  )
}))

#let graphe-matrice() = align(center, cetz.canvas(length: unite-automates, {
  import finite.draw: state, transition
  cetz.draw.set-style(..style-automates)
  state((0, 0), "s0", label: $0$)
  state((3, 0), "s1", label: $1$)
  transition("s0", "s0", label: $a$, anchor: top)
  transition("s1", "s1", label: $d$, anchor: top)
  transition("s0", "s1", label: $b$, curve: 0.4)
  transition("s1", "s0", label: $c$, curve: 0.4)
}))

#let antimirov() = align(center, cetz.canvas(length: unite-automates, {
  import finite.draw: state, transition
  cetz.draw.set-style(..style-automates)
  state((0, 0), "E", label: $E$, initial: (label: none))
  state((3, 0), "bE", label: $b E$)
  state((0, -2.5), "a", label: $a$)
  state((3, -2.5), "epsilon", label: $ε$, final: true)
  transition("E", "E", label: $b$, anchor: top)
  transition("E", "bE", label: $a$, curve: 0.25)
  transition("bE", "E", label: $b$, curve: 0.25)
  transition("E", "a", label: (text: $b$, dist: -0.33), curve: 0)
  transition("a", "epsilon", label: (text: $a$, dist: -0.33), curve: 0)
}))

// Les données de transitions restent explicites pour vérifier les déterminisations.
#let dessiner-determinise(etats, transitions) = align(center, cetz.canvas(length: unite-automates, {
  import finite.draw: state, transition
  cetz.draw.set-style(..style-automates)
  for (position, nom, etiquette, initial, final) in etats {
    state(position, nom, label: etiquette, initial: if initial { (label: none) } else { false }, final: final)
  }
  for (depart, arrivee, etiquette, style) in transitions {
    transition(
      depart,
      arrivee,
      label: (text: etiquette, dist: if style.at("curve", default: 1) < 0 { -0.33 } else { 0.33 }),
      ..style,
    )
  }
}))

#let automate-a3() = dessiner-determinise(
  (
    ((0, 0), "e0", $e_0$, true, false),
    ((2.8, 0), "e1", $e_1$, false, false),
    ((4.2, -2.8), "e2", $e_2$, false, false),
    ((5.6, 0), "e3", $e_3$, false, true),
    ((8.4, 0), "e4", $e_4$, false, true),
  ),
  (
    ("e0", "e1", $a$, (curve: 0)),
    ("e0", "e2", $b$, (curve: 0)),
    ("e1", "e2", $a$, (curve: 0)),
    ("e1", "e3", $b$, (curve: 0)),
    ("e2", "e2", $a,b$, (anchor: bottom)),
    ("e3", "e2", $a$, (curve: 0)),
    ("e3", "e4", $b$, (curve: 0.25)),
    ("e4", "e3", $a$, (curve: 0.25)),
    ("e4", "e4", $b$, (anchor: top)),
  ),
)

#let automate-a4() = dessiner-determinise(
  (
    ((0, 0), "q0", $q_0$, true, false),
    ((0, 2.8), "q1", $q_1$, false, false),
    ((3, 0), "q2", $q_2$, false, false),
    ((6, 2.8), "q3", $q_3$, false, false),
    ((6, 0), "q4", $q_4$, false, true),
  ),
  (
    ("q0", "q1", $a$, (curve: 0.25)),
    ("q0", "q2", $b$, (curve: 0)),
    ("q1", "q3", $a$, (curve: 0)),
    ("q1", "q0", $b$, (curve: 0.25)),
    ("q2", "q4", $a$, (curve: 0)),
    ("q2", "q2", $b$, (anchor: bottom)),
    ("q3", "q3", $a,b$, (anchor: right)),
    ("q4", "q3", $a$, (curve: 0)),
    ("q4", "q0", $b$, (curve: 2.2)),
  ),
)

#let concours = (nom: "Centrale", annee: 2022, filiere: "MP")

// Partie partagée avec l'exercice autonome sur les palindromes.
#let palindromes = partie(
  "I.B",
  "Palindromes et régularité",
  contexte: (
    [Sur un alphabet fini $Σ$, on note $widetilde(w)$ le miroir du mot $w$, obtenu en inversant l'ordre de ses lettres ; $widetilde(ε)=ε$.],
  ),
  meta: (
    concours: concours,
    chapitres: ("langages-reguliers", "automates-finis"),
    langages: ("OCaml",),
    difficulte: 3,
  ),
  contenu: (
    [Soit $w ∈ Σ^*$.
      Le mot $w$ est un palindrome si $widetilde(w)=w$.],
    question(
      [Écrire une fonction ```ocaml palindrome``` de signature ```ocaml string -> bool``` qui teste, en temps linéaire, si un mot est un palindrome.],
      solution: [
        #code("palindrome")
        On compare les lettres symétriques jusqu'au milieu du mot.
        L'appel d'indice $i$ vérifie les paires restantes ; $floor(n/2)-i$ décroît tant qu'un appel récursif est effectué.
        Le mot vide est accepté.
        Au plus $floor(n/2)$ comparaisons donnent un coût $O(n+1)$, linéaire dans le pire cas.
        L'appel récursif est terminal, donc l'espace auxiliaire est constant.
      ],
    ),
    [On rappelle que pour $0 ≤ i <$```ocaml String.length s```, le $i$-ième caractère de la chaîne ```ocaml s``` est obtenu par ```ocaml s.[i]```.
      Pour un alphabet $Σ$, on note $"Pal"(Σ)$ l'ensemble des palindromes de $Σ^*$.],
    question([Montrer que si $Σ$ est un alphabet à une lettre, alors $"Pal"(Σ)$ est régulier.], solution: [
      Si $Σ={a}$, tout mot est de la forme $a^n$ et est un palindrome.
      Ainsi $"Pal"(Σ)=a^*$.
    ]),
    question(
      [Montrer que si $Σ$ contient au moins deux lettres, alors $"Pal"(Σ)$ n'est pas régulier.
        On pourra utiliser un automate et un mot de $"Pal"(Σ) ∩ a^* b a^*$.],
      solution: [
        Choisissons deux lettres distinctes $a,b ∈ Σ$.
        Si $"Pal"(Σ)$ était régulier, son intersection $K$ avec $a^* b a^*$ le serait aussi.
        Or $K={a^n b a^n | n ∈ NN}$.
        Supposons qu'un automate déterministe à $p$ états reconnaisse $K$.
        Sur le chemin étiqueté $a^p b a^p$, deux des $p+1$ états atteints après $ε,a,…,a^p$ sont égaux.
        Il existe donc $0 ≤ i < j ≤ p$ tels que l'on puisse répéter le segment de $j-i$ lettres $a$.
        L'automate accepte alors $a^(p+j-i) b a^p$, qui n'appartient pas à $K$ : contradiction.
      ],
    ),
    [Soit $L ⊂ Σ^*$ un langage reconnu par $A=(Q,I,F,T)$.
      Pour $(q,q') ∈ Q^2$, on note $L_(q,q')$ le langage des mots étiquetant un chemin de $q$ à $q'$ dans $A$.],
    question(
      [Montrer que $L_(q,q')$ est reconnaissable et exprimer $cal(L)(A)$ en fonction des langages $L_(q,q')$.],
      jury: [Distinguer une famille de langages de leur union.],
      solution: [
        L'automate $(Q,{q},{q'},T)$ reconnaît $L_(q,q')$.
        Un chemin est acceptant s'il part d'un état initial et arrive à un état final, d'où
        $ cal(L)(A)=union_(i ∈ I) union_(f ∈ F) L_(i,f). $
      ],
    ),
    question([Montrer que $"Pal"(Σ) ∩ (Σ^2)^*={m widetilde(m) | m ∈ Σ^*}$.], solution: [
      Le langage $(Σ^2)^*$ contient exactement les mots de taille paire.
      Tout $m widetilde(m)$ est un palindrome de taille $2 abs(m)$.
      Réciproquement, si un palindrome a pour taille $2n$, sa seconde moitié est le miroir de sa première moitié $m$.
      Il vaut donc $m widetilde(m)$.
      L'égalité reste vraie pour $m=ε$.
    ]),
    [Soit $L$ un langage régulier reconnu par $A=(Q,I,F,T)$.
      On définit $D(L)={w widetilde(w) | w ∈ L}$ et $R(L)={w ∈ Σ^* | w widetilde(w) ∈ L}$.],
    question([Décrire simplement $D(a^* b)$ et $R(a^* b^* a^*)$.], solution: [
      On a
      $ D(a^* b)={a^n b b a^n | n ∈ NN}, #sep R(a^* b^* a^*)=a^* b^*. $
      Pour la seconde égalité, si $w widetilde(w) ∈ a^* b^* a^*$, son préfixe $w$ appartient à ce même langage et n'utilise que $a,b$.
      Un tel mot $w$ comportant un $b$ puis un $a$ fait apparaître un facteur $b a^+ b$ dans $w widetilde(w)$, impossible dans $a^* b^* a^*$.
      Ainsi $w ∈ a^* b^*$ ; réciproquement $w=a^i b^j$ donne $w widetilde(w)=a^i b^(2j) a^i$.
    ]),
    question(
      [Les langages $D(L)$ et $R(L)$ sont-ils reconnaissables ?
        On pourra faire intervenir les langages $L_(q,q')$ définis ci-dessus.],
      solution: [
        $D(L)$ ne l'est pas toujours : pour $L=a^* b$, le langage ${a^n b b a^n | n ∈ NN}$ ne peut être reconnu par un automate fini.
        Le même argument de répétition d'une boucle dans le premier bloc de $a$ que pour les palindromes donne une contradiction.

        En revanche, $R(L)$ est toujours reconnaissable.
        Un chemin acceptant étiqueté $w widetilde(w)$ passe, après $w$, par un état $q ∈ Q$.
        On a donc
        $
          R(L)=union_(i ∈ I) union_(q ∈ Q) union_(f ∈ F)
          (L_(i,q) ∩ widetilde(L_(q,f))).
        $
        Chaque langage de chemins est reconnaissable.
        Le miroir est reconnaissable en inversant les transitions et en échangeant états initiaux et finaux.
        Les stabilités par intersection et union finies concluent.
      ],
    ),
  ),
)

#let ex = exercice(
  meta: (
    titre: "Option informatique",
    chapitres: ("langages-reguliers", "automates-finis", "recursivite-et-induction", "algorithmique"),
    algorithmes: ("determinisation", "diviser-pour-regner"),
    structures: ("liste", "tableau", "arbre"),
    langages: ("OCaml",),
    difficulte: 4,
    niveaux: ("MP", "MPI"),
    duree: (4, 0),
    concours: concours,
  ),
  corrections: [
    - Partie I.D : préciser que la minimalité concerne les ADC.
    - Questions 26–27 : remplacer $δ^*({I},u)$ par $δ^*(I,u)$, car l'état initial du déterminisé est $I$.
    - Partie II.B.3, avant la question 38 : $a$ est une expression régulière quelconque, pas nécessairement une lettre.
  ],
  jury: [
    - Justifier les réponses théoriques et les calculs de complexité.
    - Lire chaque partie avant de programmer ; les trois parties sont indépendantes.
    - « L'indentation, certes utile pour comprendre le code, n'est pas un délimiteur comme en Python. »
  ],
  contenu: (
    [
      Ce sujet aborde différents problèmes autour des automates et des expressions régulières.
      On explore dans une première partie des propriétés sur le miroir d'un langage, sur les palindromes et sur les automates correspondants.
      On implémente ensuite l'algorithme de déterminisation d'un automate, afin de construire de manière effective l'automate de Brzozowski qui a la propriété d'être minimal.
      Dans une deuxième partie, on travaille sur la syntaxe des expressions régulières, puis sur une construction de l'expression régulière associée à un automate donné, par un algorithme diviser pour régner, dû à Conway, en exploitant une représentation matricielle d'un automate et la construction de l'étoile d'une matrice d'expressions régulières.
      Enfin, dans une troisième partie, on introduit les dérivées d'Antimirov, qui permettent d'obtenir un automate fini non déterministe avec peu d'états qui reconnaît le langage spécifié par une expression régulière.
      Les trois parties sont indépendantes, de difficulté progressive.

      == Langages et mots
      On appelle alphabet tout ensemble fini de lettres.
      On note généralement l'alphabet $Σ$.
      On note $Σ^*$ l'ensemble de tous les mots formés sur $Σ$.
      La taille d'un mot $w ∈ Σ^*$ est son nombre de lettres et se note $abs(w)$.
      Le mot vide, noté $ε$, est le seul mot de taille nulle.
      Si $abs(w)=n$, on note $w=a_0 a_1 … a_(n-1)$, où les $a_i$ sont des lettres de $Σ$.
      Un langage sur l'alphabet $Σ$ est un ensemble $L ⊂ Σ^*$.
      L'étoile de Kleene d'un langage $L$, notée $L^*$, est le plus petit langage qui inclut $L$, qui contient $ε$ et qui est stable par concaténation.
      La concaténation de deux langages $L$ et $L'$ est notée $L dot L'$, souvent abrégée en $L L'$ lorsqu'il n'y a pas d'ambiguïté.

      == Automates finis
      Un automate fini non déterministe sur $Σ$ est un quadruplet $A=(Q,I,F,T)$, où $Q$ est un ensemble fini d'états, $I ⊂ Q$ l'ensemble des états initiaux, $F ⊂ Q$ l'ensemble des états finaux et $T ⊂ Q × Σ × Q$ l'ensemble des transitions.
      Si $(q,a,q') ∈ T$, on note cette transition $q limits(→)^a q'$.
      Dans la figure 1, une flèche entrante désigne un état initial et un double cercle un état final.

      Un mot $w=a_0 … a_(n-1)$ est reconnu par $A$ s'il existe une succession de transitions
      $
        q_0 limits(→)^(a_0) q_1 limits(→)^(a_1) … q_(n-1) limits(→)^(a_(n-1)) q_n,
        #sep q_0 ∈ I, #sep q_n ∈ F.
      $
      On dit que $w$ étiquette un chemin de $q_0$ à $q_n$.
      Le langage de l'automate, noté $cal(L)(A)$, est l'ensemble des mots reconnus par $A$.
      Un langage est reconnaissable s'il est le langage d'un automate fini.

      Un automate déterministe est un quadruplet $A=(Q,{q_0},F,δ)$ avec un unique état initial et une fonction de transition $δ$ définie sur une partie de $Q × Σ$, à valeurs dans $Q$.
      Pour chaque $(q,a)$, il existe au plus une transition $(q,a,q')$ ; si elle existe, $q'=δ(q,a)$.
      L'automate est complet si $δ$ est définie sur $Q × Σ$.
      On définit alors sa fonction de transition étendue par
      $
        δ^*(q,ε)=q, #sep δ^*(q,w a)=δ(δ^*(q,w),a)
        quad (q ∈ Q, w ∈ Σ^*, a ∈ Σ).
      $

      Les automates sont représentés par le type OCaml suivant ; l'ensemble d'états est toujours l'intervalle d'entiers $⟦0,n-1⟧$ :
      #code("automate")
      #automate-a1()
      #align(center)[Figure 1 — L'automate $cal(A)_1$.]
      Par exemple, l'automate de la figure 1 est codé par :
      #code("a1")
      On accède au nombre d'états par ```ocaml a1.nb```, aux états initiaux par ```ocaml a1.init```, aux états finaux par ```ocaml a1.final``` et aux transitions par ```ocaml a1.trans```.

      == Expressions régulières
      Sur un alphabet $Σ$, $∅$, $ε$ et toute lettre $a ∈ Σ$ sont des expressions régulières.
      Si $E,F$ sont des expressions régulières, alors $(E | F)$, $(E dot F)$ et $E^*$ en sont aussi.
      L'application $cal(L)$ associe à une expression le langage qu'elle représente :
      $ cal(L)(∅)=∅, #sep cal(L)(ε)={ε}, #sep cal(L)(a)={a}, $
      $
        cal(L)(E | F)=cal(L)(E) ∪ cal(L)(F), #sep
        cal(L)(E dot F)=cal(L)(E) cal(L)(F), #sep
        cal(L)(E^*)=cal(L)(E)^*.
      $

      == Programmation
      Le seul langage de programmation autorisé est OCaml.
      Toutes les fonctions des modules ```ocaml Array``` et ```ocaml List```, ainsi que les fonctions de la bibliothèque standard (comme ```ocaml max``` et ```ocaml incr```) et les opérateurs comme ```ocaml /``` ou ```ocaml mod``` peuvent être utilisés.
      Les objets mathématiques notés $A,m,i,n,ℓ$ sont représentés en OCaml par ```ocaml a```, ```ocaml m```, ```ocaml i```, ```ocaml n```, ```ocaml l```.
      Les complexités demandées sont temporelles dans le pire des cas et sont exprimées sous la forme $O(f(n,m))$, où $f$ est une fonction usuelle simple des tailles des objets en entrée.
    ],
    partie("I", "Mots et automates", contenu: (
      partie("I.A", "Miroir d'un mot et automate transposé", contenu: (
        [Pour tout mot $w=a_0 a_1 … a_(n-1)$ de taille $n ∈ NN^*$, son miroir est $widetilde(w)=a_(n-1) … a_1 a_0$.
          Le mot vide $ε$ est son propre miroir.
          Pour tout langage $L ⊂ Σ^*$, on pose $widetilde(L)={widetilde(w) | w ∈ L}$.],
        question(
          [Décrire le langage $L_1$ de l'automate $cal(A)_1$ de la figure 1 et décrire son langage miroir $widetilde(L)_1$.],
          jury: [Distinguer un langage d'un ensemble de langages.],
          solution: [
            Les chemins acceptants bouclent d'abord sur $0$, lisent $a b$ pour atteindre $2$, puis lisent uniquement des $a$.
            Ainsi
            $ L_1=(a | b)^* a b a^*, #sep widetilde(L)_1=a^* b a (a | b)^*. $
          ],
        ),
        question(
          [Dessiner un automate $widetilde(cal(A))_1$ reconnaissant $widetilde(L)_1$.],
          solution: [On inverse toutes les transitions et on échange états initiaux et finaux.
            #automate-a1(miroir: true)
          ],
        ),
        [Soit $A=(Q,I,F,T)$ un automate non déterministe et $L=cal(L)(A)$ son langage.],
        question(
          [Donner, en justifiant, la construction de l'automate miroir $widetilde(A)=(Q,I',F',T')$ reconnaissant $widetilde(L)$.],
          solution: [
            On prend $I'=F$, $F'=I$ et $T'={(q',c,q) | (q,c,q') ∈ T}$.
            Un chemin de $i ∈ I$ à $f ∈ F$ étiqueté $w$ devient un chemin de $f$ à $i$ étiqueté $widetilde(w)$, et réciproquement.
            Cela inclut $ε$ : il est accepté dans les deux automates exactement lorsque $I ∩ F ≠ ∅$.
          ],
        ),
        question(
          [Écrire une fonction ```ocaml transpose``` de signature ```ocaml automate -> automate``` qui renvoie un automate reconnaissant le miroir du langage de l'automate d'entrée.],
          solution: [#code("transpose")],
        ),
        question([Quelle est la complexité de cette fonction ?], solution: [
          Chaque transition est parcourue une fois.
          Le coût est $O(1+abs(T))$ en temps et en espace supplémentaire ; les listes d'états sont partagées.
        ]),
      )),
      palindromes,
      partie(
        "I.C",
        "Déterminisation",
        jury: [Pour la représentation binaire, travailler directement sur les entiers : les conversions intermédiaires en listes annulent le gain recherché.],
        contenu: (
          [Pour tout automate non déterministe $A=(Q,I,F,T)$, on définit le déterminisé accessible $A_"det"=(Y,{I},F',δ)$, où $Y ⊂ cal(P)(Q)$ est l'ensemble des états accessibles depuis l'état initial $I$ dans l'automate des parties.
            Il reconnaît le même langage que $A$.],
          question(
            [Écrire un automate $cal(A)_2$ non déterministe à quatre états reconnaissant $L_2=(b | a b)^* b a$, avec un unique état initial et un unique état final.],
            solution: [
              #code("a2")
              Depuis $0$, on peut lire les blocs $b$ ou $a b$ pour revenir à $0$.
              On termine par le chemin $0$ vers $2$ vers $3$, étiqueté $b a$.
            ],
          ),
          question(
            [Déterminiser l'automate miroir $widetilde(cal(A))_2$ pour obtenir $cal(A)_3=(widetilde(cal(A))_2)_"det"$.
              Renommer ses états $e_0,e_1,…$.],
            jury: [Vérifier le déterminisme et les états finaux.],
            solution: [
              Les états accessibles sont
              $ e_0={3}, #sep e_1={2}, #sep e_2=∅, #sep e_3={0}, #sep e_4={0,1}. $
              $e_0$ est initial ; $e_3,e_4$ sont finaux.
              #automate-a3()
            ],
          ),
          question(
            [Déterminiser l'automate miroir $widetilde(cal(A))_3$ pour obtenir $cal(A)_4=(widetilde(cal(A))_3)_"det"$.
              Renommer ses états $q_0,q_1,…$.],
            jury: [Vérifier le déterminisme et les états finaux.],
            solution: [
              Les états accessibles sont
              $ q_0={e_3,e_4}, #sep q_1={e_4}, #sep q_2={e_1,e_3,e_4}, $
              $ q_3=∅, #sep q_4={e_0,e_4}. $
              L'état initial est $q_0$ ; le seul état final est $q_4$.
              #automate-a4()
            ],
          ),
          question([Quel doit être le langage reconnu par $cal(A)_4$ ?], solution: [
            Chaque déterminisation préserve le langage, et les deux transpositions prennent deux fois le miroir.
            Le langage est donc $L_2=(b | a b)^* b a$.
          ]),
          [On souhaite implémenter cette construction.
            Une représentation naïve des parties de $Q$ utilise des listes d'états.
            Lors des réunions, la concaténation de listes crée des doublons qu'il faut supprimer.],
          question(
            [Écrire ```ocaml supprimer : 'a list -> 'a list``` qui supprime toutes les occurrences multiples des éléments d'une liste.],
            solution: [
              #code("supprimer")
              On conserve la dernière occurrence de chaque élément.
              L'induction sur la liste montre que le résultat a les mêmes éléments et aucun doublon.
              Comme avec ```ocaml List.mem```, l'égalité doit être définie pour les éléments considérés ; ici ce sont des entiers.
            ],
          ),
          question([Donner la complexité en fonction de la taille de la liste.], solution: [
            Pour une liste de longueur $m$, les recherches parcourent au plus $(m-1)+…+1=m(m-1)/2$ éléments.
            Le coût est $O(m^2)$ et cette borne est atteinte quand les éléments sont distincts, en comptant une comparaison en temps constant.
          ]),
          [On code désormais les ensembles d'états par des entiers.
            Pour $Q=⟦0,n-1⟧$, avec $n ≤ 20$, toute partie est représentée par un entier entre $0$ et $2^n-1$.
            On pose $"numero"(X)=sum_(i ∈ X) 2^i$.
            Le tableau ```ocaml pow``` contient $2^k$ pour $0 ≤ k ≤ 20$.
            #code("pow")
            Soient $q ∈ ⟦0,n-1⟧$ et $k="numero"(X) ∈ ⟦0,2^n-1⟧$.],
          question(
            [Écrire ```ocaml est_dans : int -> int -> bool``` qui teste, à l'aide d'opérations arithmétiques, si $q ∈ X$ en $O(1)$ opérations.],
            jury: [Le codage binaire permet un test en temps constant.],
            solution: [#code("est_dans") Le quotient par $2^q$, modulo $2$, est le bit d'indice $q$.],
          ),
          [Soit $ℓ$ une liste d'états pouvant contenir des doublons, représentant $X$.],
          question(
            [Écrire ```ocaml numero : int list -> int``` qui calcule le numéro de $X$.
              Par exemple, ```ocaml [1; 5; 2; 5; 2; 5; 2; 2; 1; 2; 1]``` représente ${1,2,5}$, de numéro $38=2^1+2^2+2^5$.],
            solution: [
              #code("numero")
              On ajoute $2^q$ seulement si le bit correspondant n'est pas déjà présent.
              Le coût est linéaire dans la longueur de la liste.
            ],
          ),
          [Soit $ℓ$ une liste d'états et $X$ un ensemble représenté par $k$.],
          question(
            [Écrire ```ocaml intersecte : int list -> int -> bool``` qui vérifie si un élément de $ℓ$ appartient à $X$.],
            solution: [#code("intersecte")],
          ),
          [On suppose désormais $Σ={a,b}$.
            Pour $X ⊂ Q$ et $c ∈ Σ$, la transition du déterminisé est
            $ δ(X,c)=union_(q ∈ X) {q' ∈ Q | (q,c,q') ∈ T}. $
            En parcourant $T$, on calcule simultanément $δ(X,a)$ et $δ(X,b)$.],
          question(
            [Écrire ```ocaml etat_suivant : int -> (int * char * int) list -> int * int``` qui, à partir de $k="numero"(X)$ et de $T$, renvoie $(k_a,k_b)=("numero"(δ(X,a)),"numero"(δ(X,b)))$.],
            jury: [Éviter les parcours répétés de toutes les transitions et les conversions en listes.],
            solution: [
              #code("etat_suivant")
              Chaque transition issue de $X$ ajoute son arrivée à l'accumulateur de sa lettre.
              Les doublons ne changent pas le résultat.
              Coût : $O(1+abs(T))$.
            ],
          ),
          [Pour obtenir un ensemble d'états $Y=⟦0,N-1⟧$, on renumérote les parties accessibles avec une liste de couples $(k,v)$ : $k$ code une partie, $v$ est son nouveau numéro.
            Par exemple, $(6,2)$ renumérote la partie ${1,2}$, de code $6$, en l'état $2$.],
          question(
            [Écrire ```ocaml cherche : int -> (int * int) list -> int``` qui renvoie le nouveau numéro associé à $k$, ou $-1$ si $k$ est absent.],
            solution: [#code("cherche")],
          ),
          question(
            [Écrire ```ocaml determinise : automate -> automate``` qui calcule le déterminisé accessible.
              Expliquer brièvement la démarche.],
            solution: [
              #code("determinise")
              La liste ```ocaml attente``` est une pile des parties découvertes et non encore traitées.
              Chaque partie reçoit son nom lors de sa découverte et n'est empilée qu'une fois.
              Le traitement ajoute ses deux transitions et marque l'état final exactement si la partie rencontre les états finaux.
              La partie vide est conservée lorsqu'elle est accessible : elle fournit le puits du déterminisé complet.
              À la fin, tous les états accessibles ont été traités, puisqu'il n'existe que $2^n$ parties possibles.
            ],
          ),
          question(
            [Quelle est la complexité de ```ocaml determinise``` en fonction du nombre $n$ d'états de $A$ et du nombre $N$ d'états de $A_"det"$ ?],
            solution: [
              Chaque partie traitée parcourt $T$, la liste des états finaux et effectue trois recherches dans une liste de longueur au plus $N$.
              Le coût est $O(n+N(abs(T)+n+N))$.
              Sur deux lettres, sans transitions répétées, $abs(T) ≤ 2n^2$, donc $O(N n^2+N^2+n)$.
              L'espace supplémentaire est $O(N)$, en dehors de l'automate d'entrée.
              Comme $N ≤ 2^n$, le temps peut être exponentiel en $n$.
            ],
          ),
        ),
      ),
      partie(
        "I.D",
        "Algorithme de Brzozowski",
        jury: [Raisonner sur les chemins ; distinguer accessibilité et coaccessibilité.],
        contenu: (
          [L'algorithme de Brzozowski donne un ADC ayant un nombre minimal d'états parmi les ADC reconnaissant le même langage.
            On se donne $A=(Q,I,{f},T)$ reconnaissant $L$, dont le miroir $widetilde(A)$ est déterministe et accessible.
            On note $A_"det"=(Y,{I},F',δ)$ son déterminisé accessible.
            Pour $u ∈ Σ^*$, on pose $u^(-1)L={w ∈ Σ^* | u w ∈ L}$.],
          question(
            [Soient $q ∈ Q$ et $u ∈ Σ^*$.
              Montrer que si $q ∈ δ^*(I,u)$, alors il existe $w ∈ Σ^*$ tel que $u w ∈ L$.],
            solution: [
              L'accessibilité de $widetilde(A)$ fournit un chemin de $f$ à $q$.
              En le renversant, on obtient dans $A$ un chemin de $q$ à $f$, étiqueté par un mot $w$.
              Comme $q ∈ δ^*(I,u)$, un chemin étiqueté $u$ joint un état initial à $q$ ; leur concaténation accepte $u w$.
            ],
          ),
          question([Montrer la propriété $(*)$ : si $u^(-1)L=v^(-1)L$, alors $δ^*(I,u)=δ^*(I,v)$.], solution: [
            Prenons $q ∈ δ^*(I,u)$ et un chemin de $q$ à $f$ étiqueté $w$.
            Alors $u w ∈ L$, donc $v w ∈ L$.
            Un chemin acceptant pour $v w$ passe, après $v$, par un état $q' ∈ δ^*(I,v)$, puis lit $w$ jusqu'à $f$.
            Dans $widetilde(A)$, les deux chemins de $f$ étiquetés $widetilde(w)$ aboutissent à $q$ et $q'$.
            Le déterminisme impose $q=q'$.
            Cela prouve une inclusion ; l'autre s'obtient en échangeant $u,v$.
          ]),
          question(
            [Pour un automate quelconque $A$ reconnaissant $L$, on pose $B=(widetilde(A))_"det"$.
              En déduire que $(widetilde(B))_"det"$ reconnaît $L$ et vérifie $(*)$.],
            solution: [
              $B$ est un ADC accessible et reconnaît $widetilde(L)$.
              L'automate $widetilde(B)$ a un unique état final et son miroir $B$ est déterministe accessible : le résultat précédent s'applique.
              Son déterminisé $C$ reconnaît $L$ et vérifie $(*)$.

              Il est minimal parmi les ADC : si deux mots conduisent au même état d'un autre ADC reconnaissant $L$, ils ont les mêmes continuations acceptantes, donc le même quotient $u^(-1)L$.
              Par $(*)$, ils conduisent aussi au même état de $C$.
              Choisir un mot d'accès à chaque état de $C$ donne ainsi des états distincts dans l'autre automate.
              Celui-ci a au moins autant d'états.
            ],
          ),
          question(
            [Écrire ```ocaml minimal : automate -> automate``` appliquant cette construction.
              On fera abstraction de la taille des automates générés, possiblement problématique.],
            solution: [
              #code("minimal")
              Cette composition suppose, comme demandé, que les représentations intermédiaires sont disponibles.
              Le code avec ```ocaml pow``` ne fonctionne effectivement que si chaque appel à ```ocaml determinise``` reçoit au plus $20$ états.
              Cette limite peut être dépassée dès la première déterminisation ; il faudrait alors changer la représentation des ensembles pour appliquer la construction sans cette restriction.
            ],
          ),
        ),
      ),
    )),
    partie("II", "Expression régulière associée à un automate", contenu: (
      [On introduit un algorithme dû à Conway, calculant une expression régulière associée au langage d'un automate à l'aide de matrices d'expressions régulières.],
      partie("II.A", "Simplification d'expressions régulières équivalentes", contenu: (
        [On se donne le type OCaml des expressions régulières : #code("exprat")],
        partie("II.A.1", "Parcours d'une expression", contenu: (
          question(
            [Écrire ```ocaml lettre : exprat -> int``` qui renvoie le nombre de lettres présentes dans une expression régulière.
              Par exemple, pour $E=(a^* b) | a b b a(a | ε)^* | ∅$, la fonction doit renvoyer $7$.],
            solution: [#code("lettre")
              La preuve suit l'induction structurelle : seuls les nœuds ```ocaml Lettre``` contribuent, chacun pour une unité.
            ],
          ),
          question(
            [Écrire ```ocaml est_vide : exprat -> bool``` qui teste si le langage représenté est vide.],
            solution: [#code("est_vide") Une union est vide si ses deux termes le sont ; une concaténation est vide si au moins un terme l'est.
              Une étoile contient toujours $ε$.
              Ces règles donnent la correction par induction structurelle.
            ],
          ),
        )),
        partie("II.A.2", "Règles de simplification", contenu: (
          [On travaille sur la syntaxe des expressions et on utilise les équivalences
            $ ∅ | E ≡ E | ∅ ≡ E, #sep E dot ε ≡ ε dot E ≡ E, $
            $
              E dot ∅ ≡ ∅ dot E ≡ ∅, #sep ∅^* ≡ ε, #sep ε^* ≡ ε,
              #sep (E^*)^* ≡ E^*.
            $
            La notation $E ≡ E'$ signifie $cal(L)(E)=cal(L)(E')$.
            La fonction suivante simplifie à la racine une union : #code("su") On suppose aussi codée ```ocaml sc : exprat -> exprat```, qui simplifie à la racine une concaténation en utilisant les règles données.],
          question(
            [Écrire ```ocaml se : exprat -> exprat``` qui simplifie à la racine une expression de type ```ocaml Etoile``` selon ces règles.],
            solution: [#code("se")],
          ),
          [Considérons $E_n=a | (b dot (b dot (… (b dot ∅)…)))$, où $n$ lettres $b$ concaténées se succèdent.
            #arbre-e4()
            #align(center)[Figure 2 — Arbre syntaxique de $E_4$.]
          ],
          question(
            [Combien d'applications des règles sont nécessaires pour obtenir l'expression $a$ à partir de $E_n$ ?],
            solution: [
              Il faut $n+1$ applications : les $n$ concaténations avec $∅$ sont supprimées de l'intérieur vers l'extérieur, puis $a | ∅$ devient $a$.
              Aucune concaténation extérieure n'est simplifiable avant que sa sous-expression droite ne soit devenue $∅$.
            ],
          ),
          question(
            [Écrire ```ocaml simplifie : exprat -> exprat``` qui simplifie une expression selon ces règles.],
            jury: [Simplifier toute l'expression en profondeur.],
            solution: [
              #code(("sc", "simplifie"))
              On simplifie les fils avant la racine.
              Par induction, les fils sont irréductibles ; la règle appliquée à la racine renvoie alors soit un fils déjà simplifié, soit un constructeur auquel plus aucune règle ne s'applique.
              Un parcours suffit.
              Il est linéaire dans le nombre de nœuds de l'arbre syntaxique fourni.
            ],
          ),
        )),
      )),
      partie("II.B", "Matrices d'expressions régulières", contenu: (
        [On considère des matrices d'expressions régulières : #code("mat") La matrice nulle de taille $n$ a tous ses coefficients égaux à $∅$.
          La matrice identité a $ε$ sur sa diagonale et $∅$ ailleurs.
          Pour $A,B$ de taille $n × m$, on définit $[A | B]_(i,j)=A_(i,j) | B_(i,j)$, où le signe $|$ désigne l'union, pour $0 ≤ i<n$ et $0 ≤ j<m$.
          Pour $A$ de taille $n × p$ et $B$ de taille $p × q$, le produit de taille $n × q$ est défini comme le produit usuel, en remplaçant la somme par l'union et le produit par la concaténation.

          Les dimensions de cette sous-partie sont strictement positives.
          Pour les complexités, on compte la construction d'un nœud d'expression en temps constant, avec partage des sous-expressions immuables.
          On ne développe ni n'imprime les expressions pendant les calculs.
        ],
        partie("II.B.1", "Somme et produit", contenu: (
          question(
            [Écrire ```ocaml somme : mat -> mat -> mat``` qui effectue la somme de matrices de même taille $n × p$.
              Quelle est sa complexité ?],
            solution: [#code("somme")
              Chaque coefficient crée une union en temps constant : coût $Θ(n p)$.
            ],
          ),
          question(
            [Écrire ```ocaml produit : mat -> mat -> mat``` qui effectue le produit de deux matrices de tailles compatibles $n × p$ et $p × q$.
              On ne vérifiera pas cette compatibilité.
              Quelle est sa complexité ?],
            solution: [#code("produit")
              Après $k$ itérations de la boucle intérieure, le coefficient calculé représente l'union des $k$ premiers produits.
              Il y a $n p q$ itérations, chacune en temps constant, donc un coût $Θ(n p q)$, initialisation comprise.
            ],
          ),
        )),
        [On cherche à définir l'étoile de Kleene d'une matrice carrée.],
        partie("II.B.2", "Étoile d'une matrice de taille deux", contenu: (
          [Soit $M=mat(a, b; c, d)$, où $a,b,c,d$ sont quatre lettres.
            On associe à $M$ le graphe étiqueté $G=(S,A)$ de la figure 3, avec $S={0,1}$.
            #graphe-matrice()
            #align(center)[Figure 3 — Graphe associé à $M$.]
            On note $L_(i,j)$ le langage de l'automate $cal(A)_(i,j)=({0,1},{i},{j},T)$, où $T={(i,M_(i,j),j) | (i,j) ∈ {0,1}^2}$.
          ],
          question([Donner une expression régulière sur ${a,b,c,d}$ pour chacun des langages $L_(i,j)$.], solution: [
            $ L_(0,0)=(a | b d^* c)^*, #sep L_(1,1)=(d | c a^* b)^*, $
            $
              L_(0,1)=a^* b(d | c a^* b)^*, #sep
              L_(1,0)=d^* c(a | b d^* c)^*.
            $
            Un chemin de $0$ à $0$ est une succession de boucles $a$ ou d'excursions $b d^* c$ ; l'argument est symétrique pour $1$.
            Pour aller de $0$ à $1$, on lit $a^* b$ jusqu'à la première arrivée en $1$, puis un chemin de $1$ à $1$.
            Même raisonnement pour $1$ vers $0$.
          ]),
        )),
        partie(
          "II.B.3",
          "Étoile d'une matrice de taille quelconque",
          jury: [Calculer chaque résultat récursif une seule fois avant de compter les appels et de résoudre la récurrence.],
          contenu: (
            [On définit récursivement l'étoile de $M$ : si $M=(e)$ est de taille $1$, alors $M^*=(e^*)$.
              Sinon, on découpe en blocs
              $ M=mat(A, B; C, D), #sep M^*=mat(A', B'; C', D'), $
              où $A,D$ sont carrées de tailles au moins $1$, et
              $ A'=(A | B D^* C)^*, #sep B'=A^* B(D | C A^* B)^*, $
              $ C'=D^* C(A | B D^* C)^*, #sep D'=(D | C A^* B)^*. $
              Les fonctions suivantes sont supposées codées :
              - ```ocaml decouper : mat -> int -> int -> mat * mat * mat * mat``` :
                ```ocaml decouper m n1 n2``` renvoie les blocs $A,B,C,D$ d'une matrice carrée $M$ de taille $n_1+n_2$, avec $A$ carrée de taille $n_1$ et $D$ carrée de taille $n_2$ ;
              - ```ocaml recoller : mat -> mat -> mat -> mat -> mat``` : reconstruit
                $M=mat(A, B; C, D)$ à partir de quatre blocs de tailles compatibles.

              Pour une matrice de taille $n ≥ 2$, considérons d'abord
              $ M=mat(a, B; C, D), $
              où $a$ est une expression régulière (un bloc de taille $1$) et $D$ est carrée de taille $n-1$.
              On a alors
              $ A'=(a | B D^* C)^*, #sep B'=a^* B(D | C a^* B)^*, $
              $ C'=D^* C(a | B D^* C)^*, #sep D'=(D | C a^* B)^*. $
            ],
            question(
              [Évaluer les complexités des sommes et produits.
                En déduire que le coût $C(n)$ du calcul de l'étoile vérifie $C(n)=2C(n-1)+O(n^2)$.
                En déduire la complexité de cet algorithme.],
              solution: [
                Posons $m=n-1$.
                On calcule et conserve $D^*$ et $a^*$. $D^* C$ coûte $Θ(m^2)$, puis $B(D^* C)$ coûte $Θ(m)$. $a^* B$ coûte $Θ(m)$ et $C(a^* B)$ coûte $Θ(m^2)$ ; l'addition à $D$ coûte $Θ(m^2)$.
                On calcule ensuite $(D | C a^* B)^*$ une seule fois.
                Le produit donnant $B'$ coûte $Θ(m^2)$ ; celui donnant $C'$ coûte $Θ(m)$.
                Les opérations scalaires coûtent $O(1)$ ; découpage et recollement coûtent $O(n^2)$.
                Les deux appels sur des matrices de taille $n-1$ donnent la récurrence.
                En la déroulant,
                $ C(n)/2^n ≤ C(1)/2 + K sum_(j=2)^n j^2/2^j. $
                La somme est bornée : le rapport des termes successifs est inférieur à une constante strictement inférieure à $1$ à partir d'un certain rang.
                Ainsi $C(n)=O(2^n)$, et même $Θ(2^n)$ puisque l'arbre d'appels contient $2^(n-1)$ feuilles.
              ],
            ),
            [Supposons maintenant que $n ≥ 2$ est une puissance de $2$.
              On découpe $M=mat(A, B; C, D)$ avec $A,D$ de taille $n/2$.],
            question(
              [Évaluer les complexités des sommes et produits.
                En déduire $C(n)=4C(n/2)+O(n^3)$, puis la complexité de l'algorithme.],
              solution: [
                On conserve les quatre étoiles $A^*$, $D^*$, $A'$ et $D'$ pour les réutiliser.
                Il y a un nombre constant de produits de matrices de taille $n/2$, coûtant chacun $Θ(n^3)$, et de sommes coûtant $Θ(n^2)$.
                Le découpage et le recollement coûtent $Θ(n^2)$.
                Au niveau $k$ de l'arbre de récursion, le coût hors appels est $O(4^k(n/2^k)^3)=O(n^3/2^k)$.
                La somme géométrique sur tous les niveaux est $O(n^3)$ ; les $4^(log_2 n)=n^2$ feuilles ne changent pas cette borne.
                Le coût du premier niveau fournit aussi une minoration : $C(n)=Θ(n^3)$.
              ],
            ),
            question(
              [Comment gérer une taille $n$ quelconque ?
                Quelle complexité peut-on obtenir pour $M^*$ ?],
              solution: [
                On peut compléter $M$ par des lignes et colonnes d'expressions vides jusqu'à la puissance de deux $p$ suivante, avec $n ≤ p<2n$.
                Aucun chemin ne passe par les nouveaux sommets, sauf les chemins vides sur eux-mêmes.
                Le bloc supérieur gauche de l'étoile est donc $M^*$, calculé en $O(p^3)=O(n^3)$.

                On peut aussi découper directement en tailles $floor(n/2)$ et $ceil(n/2)$, comme dans le code suivant.
                Au niveau $k$, il y a au plus $4^k$ appels sur des tailles au plus $ceil(n/2^k)$, d'où le même majorant géométrique $O(n^3/2^k)$ avant le dernier niveau.
                Les $O(n^2)$ feuilles donnent encore un coût $O(n^3)$.
              ],
            ),
            question(
              [Écrire ```ocaml etoile : mat -> mat``` qui renvoie l'étoile d'une matrice avec l'algorithme récursif le plus adéquat.],
              solution: [
                #code("etoile")
                Chaque sous-matrice carrée passée récursivement est strictement plus petite.
                Les formules de l'énoncé donnent la correction par récurrence sur $n$.
                Les quatre résultats récursifs sont calculés une seule fois chacun, comme requis pour le coût cubique.
              ],
            ),
          ),
        ),
      )),
      partie("II.C", "Algorithme de Conway", contenu: (
        [Soit $A=(Q,I,F,T)$ avec $Q=⟦0,n-1⟧$.
          Sa matrice de transition est la matrice d'expressions régulières $M_A$ dont le coefficient $[M_A]_(i,j)$ est l'union, notée $|$, des lettres $c ∈ Σ$ telles que $(i,c,j) ∈ T$.
          L'union vide vaut $∅$.
          On admet que $cal(L)([M_A^*]_(i,j))=L_(i,j)$, langage des chemins défini à la question 9.],
        question(
          [Montrer que $cal(L)(A)=cal(L)([X M_A^* Y]_(0,0))$, où $X$ est une matrice ligne $(x_0,…,x_(n-1))$ et $Y$ une matrice colonne de coefficients $y_0,…,y_(n-1)$, avec $x_i,y_j ∈ {∅,ε}$.
            Préciser les coefficients en fonction de l'automate.],
          solution: [
            On choisit $x_i=ε$ si $i ∈ I$, et $∅$ sinon ; $y_j=ε$ si $j ∈ F$, et $∅$ sinon.
            Le produit représente exactement
            $
              union_(i ∈ I) union_(j ∈ F) cal(L)([M_A^*]_(i,j))
              =union_(i ∈ I) union_(j ∈ F) L_(i,j)=cal(L)(A).
            $
          ],
        ),
        question(
          [Écrire ```ocaml langage : automate -> exprat``` renvoyant une expression régulière du langage de l'automate.
            Quelle est sa complexité ?],
          solution: [
            #code("langage")
            Le calcul final sélectionne directement les coefficients d'indices initial-final, ce qui donne le même langage que $X M_A^* Y$.
            La construction de $M_A$ coûte $O(n^2+abs(T))$, l'étoile $O(n^3)$ et l'union finale $O(abs(I) abs(F))$.
            Le coût total est donc $O(1+n^3+abs(T))$, soit $O(n^3)$ pour $n ≥ 1$ sur un alphabet fixé.

            Les sous-expressions sont partagées : un constructeur OCaml conserve des références à ses arguments, sans recopier leurs arbres.
            Cette borne concerne la représentation partagée produite.
            Le développement, l'affichage ou la simplification naïve de l'arbre entièrement déplié peut coûter beaucoup plus, et n'est pas effectué ici.
          ],
        ),
      )),
    )),
    partie("III", "Automate des dérivées d'Antimirov", contenu: (
      [On propose une méthode construisant, à partir d'une expression régulière, un automate non déterministe ayant peu d'états.
        Pour deux ensembles d'expressions $S,S'$, on pose
        $ S dot S'={E dot E' | (E,E') ∈ S × S'}. $
        En particulier, $∅ dot S=∅$ et ${ε} dot S=S$.
        On utilise les conventions syntaxiques d'associativité de la concaténation et de neutralité de $ε$.
        Soient $E$ une expression régulière sur $Σ$ et $a ∈ Σ$.
        La dérivée partielle $∂_a(E)$ est l'ensemble d'expressions défini inductivement par
        $
          ∂_a(∅)=∅, #sep ∂_a(ε)=∅, #sep
          ∂_a(b)=cases({ε} & "si" a=b, ∅ & "sinon"),
        $
        $ ∂_a(E | F)=∂_a(E) ∪ ∂_a(F), #sep ∂_a(E^*)=∂_a(E) dot {E^*}, $
        $
          ∂_a(E F)=cases(
            ∂_a(E) dot {F} & "si" ε ∉ cal(L)(E),
            ∂_a(E) dot {F} ∪ ∂_a(F) & "sinon".
          )
        $
        La dérivée partielle prend donc une expression en argument et renvoie un ensemble d'expressions.

        Par exemple, pour $E=a^*(a | b)$, puisque $ε ∈ cal(L)(a^*)$,
        $
          ∂_a(E)=∂_a(a^*) dot {a | b} ∪ ∂_a(a | b)
          ={a^*(a | b),ε},
        $
        $ ∂_b(E)=∂_b(a^*) dot {a | b} ∪ ∂_b(a | b)={ε}. $
      ],
      question([Pour $E=(a b | b)^* b a$, calculer $∂_a(E)$ et $∂_b(E)$.], solution: [
        Posons $H=(a b | b)^*$, donc $E=H b a$.
        On a $∂_a(a b | b)={b}$ et $∂_b(a b | b)={ε}$.
        Par conséquent $∂_a(H)={b H}$ et $∂_b(H)={H}$.
        Comme $ε ∈ cal(L)(H)$, on obtient
        $
          ∂_a(E)={b H b a}={b E}, #sep
          ∂_b(E)={H b a,a}={E,a}.
        $
      ]),
      [On étend les dérivées aux mots et aux ensembles d'expressions : pour $a ∈ Σ$, $w ∈ Σ^*$ et un ensemble d'expressions $S$,
        $
          ∂_ε(E)={E}, #sep ∂_(w a)(E)=∂_a(∂_w(E)), #sep
          ∂_w(S)=union_(E ∈ S) ∂_w(E).
        $
        L'automate d'Antimirov de $E$ est $A=(Q,I,F,T)$, défini par
        $ Q={E_1 | ∃w ∈ Σ^*, E_1 ∈ ∂_w(E)}, #sep I={E}, $
        $ F={E_1 ∈ Q | ε ∈ cal(L)(E_1)}, $
        $ T={(E_1,c,E_2) ∈ Q × Σ × Q | E_2 ∈ ∂_c(E_1)}. $
        Pour tout mot $w$ et tout langage $L ⊂ Σ^*$, on rappelle $w^(-1)L={u ∈ Σ^* | w u ∈ L}$.
      ],
      question(
        [Dessiner l'automate obtenu à partir de $E=(a b | b)^* b a$.
          Indiquer précisément son ensemble d'états $Q$.],
        solution: [
          On a $Q={E,b E,a,ε}$, $I={E}$ et $F={ε}$.
          En plus des dérivées de $E$, on a $∂_a(b E)=∅$, $∂_b(b E)={E}$, $∂_a(a)={ε}$, $∂_b(a)=∅$ et les deux dérivées de $ε$ sont vides.
          Les quatre états sont accessibles et cet ensemble est stable par dérivation.
          #antimirov()
          L'état final est représenté par un double cercle.
        ],
      ),
      question([Montrer que pour tous mots $u,v$ et tout langage $L$, $v^(-1)(u^(-1)L)=(u v)^(-1)L$.], solution: [
        Pour tout $z$, on a successivement
        $
          z ∈ v^(-1)(u^(-1)L) ⟺ v z ∈ u^(-1)L ⟺ u v z ∈ L
          ⟺ z ∈ (u v)^(-1)L.
        $
      ]),
      [Pour un ensemble d'expressions $S$, on note $cal(L)(S)$ la réunion de leurs langages.
        On admet que pour toute expression $E$ et toute lettre $x$,
        $ cal(L)(∂_x(E))=x^(-1)cal(L)(E). $
      ],
      question(
        [Pour tout ensemble $S$ d'expressions sur $Σ$ et tout $w ∈ Σ^*$, montrer $cal(L)(∂_w(S))=w^(-1)cal(L)(S)$.],
        solution: [
          Pour une lettre $x$, l'union des identités admises donne
          $
            cal(L)(∂_x(S))=union_(E ∈ S) x^(-1)cal(L)(E)
            =x^(-1)cal(L)(S).
          $
          La dernière égalité vient de ce que $x z$ appartient à une union si et seulement s'il appartient à l'un de ses termes.
          Raisonnons maintenant par récurrence sur la taille de $w$, pour tout $S$.
          Le cas $ε$ est immédiat car $∂_ε(S)=S$.
          Pour $w=u x$, l'identité pour une lettre, l'hypothèse de récurrence et la question 46 donnent
          $
            cal(L)(∂_(u x)(S))=cal(L)(∂_x(∂_u(S)))
            =x^(-1)(u^(-1)cal(L)(S))=(u x)^(-1)cal(L)(S).
          $
        ],
      ),
      question(
        [Montrer que pour tout $w ∈ Σ^*$, $∂_w(E)$ est l'ensemble des états accessibles depuis $E$ en lisant $w$.],
        solution: [
          Pour $ε$, le seul état atteint est $E$ et $∂_ε(E)={E}$.
          Si la propriété est vraie pour $u$, les états atteints après $u a$ sont les successeurs par $a$ des états de $∂_u(E)$, soit
          $ union_(H ∈ ∂_u(E)) ∂_a(H)=∂_a(∂_u(E))=∂_(u a)(E). $
          La récurrence conclut.
        ],
      ),
      question([En déduire que l'automate d'Antimirov reconnaît le langage de $E$.], solution: [
        Un mot $w$ est accepté si et seulement si un état $H ∈ ∂_w(E)$ est final, c'est-à-dire si $ε ∈ cal(L)(∂_w(E))$.
        Par la question 47, cela équivaut à $ε ∈ w^(-1)cal(L)(E)$, donc à $w ∈ cal(L)(E)$.
        La finitude de l'automate sera établie à la question suivante.
      ]),
      [Pour $w ∈ Σ^* ∖ {ε}$ et toutes expressions $E,F$, on vérifie les relations
        $ ∂_w(E | F)=∂_w(E) ∪ ∂_w(F) quad "(III.1)", $
        $
          ∂_w(E F) ⊂ ∂_w(E) dot {F} ∪ union_(v ∈ S^+(w)) ∂_v(F)
          quad "(III.2)",
        $
        $
          ∂_w(E^*) ⊂ union_(v ∈ S^+(w)) ∂_v(E) dot {E^*}
          quad "(III.3)",
        $
        où $S^+(w)$ est l'ensemble des suffixes non vides de $w$.
        On pose
        $ Q(E)=union_(w ∈ Σ^* ∖ {ε}) ∂_w(E). $
      ],
      question(
        [Montrer que $abs(Q(E))$ est majoré par le nombre de lettres présentes dans l'écriture syntaxique de $E$, noté $norm(E)$.
          Qu'en déduit-on sur l'automate d'Antimirov ?],
        solution: [
          Raisonnons par induction structurelle.
          - Pour $E=∅$ ou $E=ε$, $Q(E)=∅$ et $norm(E)=0$.
          - Pour une lettre $a$, $Q(a)={ε}$ et $norm(a)=1$.
          - D'après (III.1), $Q(E | F)=Q(E) ∪ Q(F)$, donc
            $abs(Q(E | F)) ≤ abs(Q(E))+abs(Q(F)) ≤ norm(E)+norm(F)=norm(E | F)$.
          - D'après (III.2), $Q(E F) ⊂ Q(E) dot {F} ∪ Q(F)$.
            L'image de $Q(E)$ par $H ↦ H F$ contient au plus $abs(Q(E))$ éléments.
            Ainsi $abs(Q(E F)) ≤ norm(E)+norm(F)=norm(E F)$.
          - D'après (III.3), $Q(E^*) ⊂ Q(E) dot {E^*}$, donc
            $abs(Q(E^*)) ≤ abs(Q(E)) ≤ norm(E)=norm(E^*)$.

          L'ensemble des états de l'automate est ${E} ∪ Q(E)$, car il faut également compter la dérivée par le mot vide.
          Il contient donc au plus $norm(E)+1$ états.
          L'automate est fini, accessible et reconnaît $cal(L)(E)$ ; il n'est pas nécessairement déterministe.
        ],
      ),
    )),
  ),
)

#import "/load.typ": feuille
#show: feuille.with(
  type: "concours",
  titre: ex.meta.titre,
  niveau: ex.meta.niveaux.join(" / "),
  concours: ex.meta.concours,
  exercices: (ex,),
  corrige: est-corrige(),
)
