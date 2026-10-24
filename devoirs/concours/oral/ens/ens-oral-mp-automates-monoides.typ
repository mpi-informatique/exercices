#import "/load.typ": est-corrige
#import "/load.typ": exercice, partie, question
#let ex = exercice(
  meta: (
    titre: "Automates et monoïdes",
    chapitres: ("langages-reguliers", "automates-finis"),
    algorithmes: (),
    structures: ("tableau",),
    difficulte: 4,
    niveaux: ("MPI", "MP"),
    duree: (1, 0),
    concours: (nom: "ENS", annee: 2022, filiere: "MP", oral: true),
  ),
  corrections: [
    - Numérotation : commencer à 1 et décaler les renvois d'une unité.
    - Questions 2 et 3 : définir les morphismes et fixer le sens du produit des transformations pour que $u↦f_u$ soit un morphisme.
    - Question 3 : expliciter la dépendance en la taille de l'alphabet dans les complexités et détailler le parcours des transformations en b), avec un contre-exemple au choix d'un seul mot depuis l'état initial.
    - Question 3.e) : démontrer directement les deux inclusions, sans utiliser la notion de fibre.
    - Question 6 : corriger les types de $I$, $δ$ et la définition de $R_u$.
    - Question 7 : réparer la phrase incomplète et préciser la base du logarithme ; la borne est $sqrt(log_2 n)$.
  ],
  jury: [
    - Expliquer les pistes envisagées et les difficultés rencontrées afin de permettre le dialogue avec le jury.
  ],
  contenu: (
    [
      Un semigroupe est un ensemble muni d'une multiplication interne associative : $x · (y · z)=(x · y) · z$.
      Un élément neutre $e$ vérifie $x · e=e · x=x$ pour tout $x$.
      Un monoïde est un semigroupe possédant un neutre. Il est fini si son ensemble sous-jacent est fini.
      Un morphisme de monoïdes conserve la multiplication et l'élément neutre.
      Pour des transformations, on utilisera le produit $f · g=g∘f$, qui correspond à leur application de gauche à droite.
    ],
    question(
      [
        #enum(
          numbering: "a)",
          [Montrer qu'un monoïde possède un unique élément neutre.],
          [Pour un alphabet fini $A$, montrer que $(A^*, · )$, muni de la concaténation, est un monoïde.],
        )
      ],
      solution: [
        a) Si $e$ et $e'$ sont neutres, $e=e · e'=e'$.

        b) Le mot vide est neutre. Les deux concaténations $(u v)w$ et $u(v w)$ ont même taille et les mêmes lettres à chaque position : d'abord celles de $u$, puis celles de $v$, puis celles de $w$. La concaténation est associative.
      ],
    ),
    question(
      [
        Soit $Q$ un ensemble fini. Montrer que les fonctions $Q→Q$ forment un monoïde, appelé monoïde des transformations.
        Un monoïde $N$ est un sous-monoïde de $M$ s'il existe un morphisme injectif de $N$ vers $M$.
        Montrer que tout monoïde fini est un sous-monoïde d'un monoïde des transformations.
      ],
      solution: [
        La composition est associative et l'identité est neutre, y compris pour le produit choisi $f · g=g∘f$.
        Pour un monoïde $M$, associer à $m$ la transformation $r_m:x↦x · m$ de $M$.
        On a $r_(m n)=r_n∘r_m=r_m · r_n$ et $r_e="id"$. Enfin $r_m (e)=m$, donc cette application est injective.
        Avec la composition dans l'autre sens, on utiliserait les translations à gauche $x↦m · x$.
      ],
    ),
    [
      Soit $cal(A)=(Q,A,δ,i,F)$ un automate fini déterministe complet.
      On note $q · a=δ(q,a)$ et $q · u$ l'état obtenu après lecture de $u$ depuis $q$.
      Une fonction de transition est une fonction $f_u:q↦q · u$, pour un mot $u∈A^*$.
      Dans les complexités, $n=abs(Q)≥1$, $k=abs(A)≥1$ et $N$ est le nombre de fonctions de transition distinctes.
    ],
    question(
      [
        #enum(
          numbering: "a)",
          [Montrer que les fonctions de transition forment un monoïde fini.],
          [Donner un algorithme testant si une fonction $f:Q→Q$ appartient à ce monoïde et sa complexité.],
          [En déduire un algorithme énumérant les fonctions de transition et donner sa complexité en fonction de $abs(Q)$.],
          [Proposer une énumération polynomiale en $abs(Q)$ et $N$, à alphabet fixé.],
          [Un langage $L⊂A^*$ est reconnu par un monoïde $M$ s'il existe un morphisme $φ:A^*→M$ tel que $L=φ^(-1)(φ(L))$. Montrer que le monoïde des transitions reconnaît $cal(L)(cal(A))$.],
        )
      ],
      solution: [
        a) $f_ε="id"$ et $f_(u v)=f_v∘f_u=f_u · f_v$. Il y a au plus $n^n$ fonctions de $Q$ dans $Q$.

        b) Il faut trouver un même mot $u$ tel que $f(q)=q · u$ pour tous les états $q$.
        Trouver seulement un mot vérifiant $f(i)=i · u$, puis le tester sur les autres états, ne suffit pas : un échec peut venir du choix de $u$, alors qu'un autre mot convient.

        Explorer plutôt un graphe dont les sommets sont les fonctions $Q→Q$, représentées par les tableaux de leurs $n$ images.
        Depuis un sommet $g$, la lettre $a$ mène à $h=f_(a)∘g$, dont le tableau se calcule par $h(q)=δ(g(q),a)$.
        Si $g=f_(u)$, alors $h=f_(u a)$ : cette étape ajoute la même lettre à droite du mot, pour tous les états à la fois.

        Partir de l'identité, correspondant au mot vide, et effectuer un parcours en largeur :
        - conserver une liste des fonctions découvertes et une file des fonctions à traiter, initialement réduites à l'identité.
        - retirer une fonction $g$ de la file et calculer $f_(a)∘g$ pour chaque lettre $a∈A$.
        - ajouter chaque fonction nouvelle à la liste et à la file.
        - répondre oui dès que $f$ est découverte, et non si la file devient vide.

        Chaque fonction est traitée une seule fois : le parcours termine après au plus $N≤n^n$ itérations.

        Chaque composition coûte $O(n)$ et la recherche de son tableau dans la liste coûte $O(n N)$.
        Au plus $k N$ compositions sont examinées, soit $O(k n N^2)$ en temps et $O(n N+k n)$ en espace, donc au pire $O(k n^(2n+1))$ en temps.

        c) Énumérer les $n^n$ tableaux et appliquer ce test à chacun donne la borne $O(k n^(3n+1))$ en temps, avec réutilisation de l'espace de travail. C'est une méthode volontairement naïve ; l'alphabet est fixé pour exprimer la borne en fonction de $n$ seul.

        d) Une exploration complète de b), poursuivie jusqu'à ce que la file soit vide, énumère directement les $N$ fonctions : $O(k n N^2)$ en temps et $O(n N+k n)$ en espace, polynomiaux dans les paramètres demandés.
        On peut accélérer la détection des doublons par une table de hachage de tableaux, à condition d'avoir aucun coût de hachage constant pour une fonction entière.

        e) Noter $M$ le monoïde des transitions et $L=cal(L)(cal(A))$.
        Définir $φ:A^*→M$ par $φ(u)=f_(u)$.
        D'après a), $φ(ε)="id"$ et $φ(u v)=φ(u) · φ(v)$ : $φ$ est donc un morphisme de monoïdes.

        L'idée est que la transformation $f_(u)$ suffit à savoir si $u$ est accepté : il suffit de regarder si $f_(u) (i)∈F$.
        Montrer maintenant $L=φ^(-1)(φ(L))$ par deux inclusions.

        - Si $u∈L$, alors $φ(u)∈φ(L)$, donc $u∈φ^(-1)(φ(L))$.

        - Réciproquement, si $u∈φ^(-1)(φ(L))$, alors $φ(u)∈φ(L)$.
          Cela signifie qu'il existe un mot accepté $v∈L$ tel que $φ(u)=φ(v)$, donc $f_(u)=f_(v)$.
          Les deux mots arrivent alors au même état depuis l'état initial :
          $ i · u=f_(u) (i)=f_(v) (i)=i · v. $
          Puisque $v$ est accepté, cet état appartient à $F$, donc $u$ est accepté aussi : $u∈L$.

        Ainsi $L=φ^(-1)(φ(L))$ : le monoïde des transitions reconnaît bien le langage de l'automate.
      ],
    ),
    question(
      [
        Un langage est reconnaissable par monoïde s'il est reconnu par un monoïde fini. Montrer que cela équivaut à être reconnu par un automate fini.
      ],
      solution: [
        Un automate fini peut être déterminisé et complété ; la question 3 donne alors un monoïde fini reconnaissant son langage.
        Réciproquement, si $φ:A^*→M$ reconnaît $L$, prendre les états $M$, l'état initial $e$, les finaux $φ(L)$ et $δ(m,a)=m · φ(a)$.
        Après lecture de $u$, l'état est $φ(u)$, par récurrence. Il est final exactement lorsque $u∈φ^(-1)(φ(L))=L$.
      ],
    ),
    [
      Une relation sur $Q$ est une partie de $Q×Q$. On définit
      $ R_1∘R_2={(x,y) | ∃z∈Q, (x,z)∈R_1 " et " (z,y)∈R_2}. $
    ],
    question(
      [
        #enum(
          numbering: "a)",
          [Montrer que les relations sur $Q$, munies de cette composition, forment un monoïde.],
          [Donner sa taille en fonction de $abs(Q)$.],
        )
      ],
      solution: [
        a) Les deux parenthésages décrivent les couples reliés par trois étapes successives : ils sont égaux. La diagonale ${(q,q) | q∈Q}$ est neutre.

        b) Une relation choisit indépendamment la présence de chacun des $abs(Q)^2$ couples, d'où $2^(abs(Q)^2)$ relations.
      ],
    ),
    [
      Soit maintenant $cal(A)=(Q,A,δ,I,F)$ un automate fini non déterministe, avec $I,F⊂Q$ et $δ⊂Q×A×Q$.
      Pour $u∈A^*$, $q · u$ désigne l'ensemble des états atteignables en lisant $u$ depuis $q$.
      La relation de transition de $u$ est $R_u={(q,r)∈Q×Q | r∈q · u}$.
    ],
    question(
      [
        #enum(
          numbering: "a)",
          [Montrer que les relations de transition forment un monoïde fini.],
          [Montrer que ce monoïde reconnaît le langage de l'automate.],
          [Proposer un algorithme calculant ce monoïde et sa complexité.],
        )
      ],
      solution: [
        a) $R_ε$ est la diagonale et $R_(u v)=R_u∘R_v$. C'est donc un sous-monoïde des relations sur $Q$.

        b) Le mot $u$ est accepté si et seulement si $R_u∩(I×F)≠∅$. Cette condition ne dépend que de $R_u$, donc le morphisme $u↦R_u$ reconnaît le langage.

        c) Représenter une relation par sa matrice booléenne $n×n$. La composition se calcule par trois boucles en $O(n^3)$.
        Saturer depuis la diagonale par composition à droite avec chaque $R_a$.
        S'il y a $N_R≤2^(n^2)$ relations atteignables, une recherche des doublons dans une liste coûte $O(N_R n^2)$ par candidate.
        Le temps est donc $O(k N_R(n^3+N_R n^2))$ et l'espace $O((N_R+k)n^2)$.
        La terminaison et l'exhaustivité se prouvent comme pour les transformations.
      ],
    ),
    question(
      [
        On appelle ici taille du monoïde syntaxique de $L$ la plus petite cardinalité d'un monoïde fini reconnaissant $L$.
        Si cette taille vaut $n$, montrer que tout automate fini non déterministe reconnaissant $L$ a au moins $sqrt(log_2 n)$ états.
      ],
      solution: [
        Si un tel automate a $s$ états, son monoïde des relations reconnaît $L$ et possède au plus $2^(s^2)$ éléments.
        Par minimalité, $n≤2^(s^2)$, donc $s≥sqrt(log_2 n)$.
        Cette preuve utilise seulement la propriété de minimalité donnée, sans supposer connue la construction du monoïde syntaxique.
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
