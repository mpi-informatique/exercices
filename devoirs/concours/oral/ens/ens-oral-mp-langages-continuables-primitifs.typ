#import "/load.typ": est-corrige
#import "/load.typ": exercice, partie, question
#let ex = exercice(
  meta: (
    titre: "Langages continuables et mots primitifs",
    chapitres: ("langages-reguliers", "automates-finis"),
    algorithmes: ("parcours-en-largeur",),
    structures: ("graphe",),
    difficulte: 4,
    niveaux: ("MPI", "MP"),
    duree: (1, 0),
    concours: (nom: "ENS", annee: 2018, filiere: "MP", oral: true),
  ),
  corrections: [
    - Numérotation : commencer à 1 et décaler les renvois d'une unité.
    - Question 2, corrigé : le bloc répété a pour taille $d$, et l'exposant vaut $abs(w)/d$.
    - Question 6, corrigé : la lecture part de l'état initial ; le parcours inverse part de tous les états finaux.
    - Question 7, corrigé : inclure $i=0$ lorsque l'automate a un seul état.
  ],
  jury: [
    - Expliquer les pistes envisagées et les difficultés rencontrées afin de permettre le dialogue avec le jury.
  ],
  contenu: (
    [
      On fixe un alphabet fini $Σ$ avec $abs(Σ)>1$. Tous les automates de ce sujet sont des ADC.
      Un mot non vide $w∈Σ^*$ est primitif s'il n'existe pas de mot $u∈Σ^*$ et d'entier $p>1$ tels que $w=u^p$.
    ],
    question(
      [
        Le mot $a b a a a b a a$ est-il primitif ? Le mot $a b a b b a a b b b a b a b b a b$, de taille 17, est-il primitif ?
      ],
      solution: [
        Le premier est $(a b a a)^2$, donc n'est pas primitif.
        Si le second était $u^p$ avec $p>1$, alors $17=p abs(u)$ imposerait $p=17$ et $abs(u)=1$ ; ses lettres seraient toutes identiques. Il est donc primitif.
      ],
    ),
    question(
      [
        Proposer un algorithme naïf testant si un mot est primitif. Discuter ses complexités en temps et en espace.
      ],
      solution: [
        Rejeter le mot vide. Pour chaque $1≤d≤floor(abs(w)/2)$ qui divise $abs(w)$, tester $w_i=w_(i+d)$ pour $1≤i≤abs(w)-d$.
        Si un test réussit, $w$ est la puissance d'exposant $abs(w)/d$ de son préfixe de taille $d$ : le rejeter. Sinon, l'accepter.
        Toute puissance non triviale possède une telle taille de bloc, ce qui prouve la correction.
        Au plus $abs(w)$ tests de divisibilité et $abs(w)$ comparaisons par candidat donnent $O(abs(w)^2)$ en temps et $O(1)$ en espace auxiliaire, sans copier les facteurs.
      ],
    ),
    question(
      [
        Donner un langage régulier infini ne contenant aucun mot primitif.
      ],
      solution: [
        Le langage décrit par $(a a)^*$ convient : le mot vide n'est pas primitif et chaque mot non vide est $a^(2k)$, avec $k≥1$.
      ],
    ),
    question(
      [
        Donner un langage régulier infini ne contenant que des mots primitifs.
      ],
      solution: [
        Le langage décrit par $a b b^*$ convient. Dans une puissance $u^p$, le nombre de $a$ serait un multiple de $p$, alors qu'il vaut ici 1.
      ],
    ),
    question(
      [
        Un langage régulier $L$ est continuable si, pour tout $u∈Σ^*$, il existe $v∈Σ^*$ tel que $u v∈L$.
        Donner un langage régulier infini non continuable. Existe-t-il un langage régulier continuable dont le complémentaire soit infini ?
      ],
      solution: [
        Le langage $a b^*$ n'est pas continuable : aucun prolongement de $b$ n'y appartient.
        Le langage des mots de taille paire est continuable (ajouter au besoin une lettre) et son complémentaire, celui des mots de taille impaire, est infini.
      ],
    ),
    question(
      [
        Étant donné un automate $A$, décider si $cal(L)(A)$ est continuable. Justifier l'algorithme et ses complexités en temps et en espace.
      ],
      solution: [
        La condition équivaut à ce que tout état accessible soit coaccessible.
        En effet, un mot $u$ atteint un unique état $q$ ; un prolongement $v$ est accepté exactement lorsqu'il mène de $q$ à un état final.
        Marquer les états accessibles depuis l'état initial, puis les coaccessibles depuis les états finaux dans le graphe renversé, et vérifier l'inclusion.
        Avec $N$ états et $m$ transitions, chaque parcours et la construction du graphe renversé prennent $O(N+m)$ en temps et en espace.
        Ici $m=N abs(Σ)$ ; il faut compter les transitions, et pas seulement la taille de l'alphabet.
      ],
    ),
    question(
      [
        #enum(
          numbering: "a)",
          [Montrer que tout langage régulier continuable contient une infinité de mots primitifs.],
          [Donner une borne supérieure sur la taille de son plus petit mot primitif.],
          [La réciproque de a) est-elle vraie ?],
        )
      ],
      solution: [
        a) Soient $a≠b$ dans $Σ$ et $N$ le nombre d'états d'un automate reconnaissant $L$.
        Pour chaque $i≥N-1$, la continuabilité donne un mot $w_i=b a^i x_i∈L$, avec $abs(x_i)≤N-1$ : choisir un plus court chemin vers un état final après $b a^i$.
        Si $w_i=u^p$ avec $p≥2$, alors $abs(u)≤floor((i+N)/2)≤i$.
        La lettre en position $1+abs(u)$ devrait être $b$, comme la première, mais cette position appartient au bloc de $a$. Contradiction.
        Si $i=0=N-1$, $w_i=b$ est directement primitif.
        Les tailles des $w_i$ sont non bornées, donc ces mots primitifs sont en nombre infini.

        b) Prendre $i=N-1$ : $abs(w_i)≤2N-1$.

        c) Non : $b a a^*$ contient une infinité de mots primitifs et aucun prolongement de $a$.
      ],
    ),
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
