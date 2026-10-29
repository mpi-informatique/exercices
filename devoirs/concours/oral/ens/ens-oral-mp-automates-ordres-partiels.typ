#import "/load.typ": est-corrige
#import "/load.typ": automate
#import automate: dessiner-automate, rayon-etat, rayon-grand-etat
#import "/load.typ": exercice, partie, question
#let dessiner = dessiner-automate.with(
  echelle: (1.5, 1.3),
  rayon: nom => if nom.len() > 5 { 1.1 } else if nom.len() > 2 { rayon-grand-etat } else { rayon-etat },
)
#let fini = dessiner(
  (
    ("ε", (0, 0), true, false),
    ("a", (2, 1), false, false),
    ("b", (2, -1), false, false),
    ("a b", (4, 1), false, false),
    ("b a", (4, -1), false, false),
    ("a b a", (6, 2), false, false),
    ("a b b", (6, 0), false, true),
    ("b a a", (6, -2), false, false),
    ("a b a a", (8, 2), false, true),
    ("b a a a", (8, -2), false, true),
  ),
  (
    ("ε", "a", "a", (:)),
    ("ε", "b", "b", (:)),
    ("a", "a b", "b", (:)),
    ("b", "b a", "a", (:)),
    ("a b", "a b a", "a", (:)),
    ("a b", "a b b", "b", (:)),
    ("b a", "b a a", "a", (:)),
    ("a b a", "a b a a", "a", (:)),
    ("b a a", "b a a a", "a", (:)),
  ),
)
#let infini = dessiner((("0", (0, 0), true, true),), (("0", "0", "a", (anchor: top)),))
#let exemple-k = dessiner(
  (("0", (0, 0), true, false), ("1", (3, 0), false, false), ("2", (6, 0), false, true)),
  (
    ("0", "0", "a,b,c", (anchor: top)),
    ("0", "1", "a", (:)),
    ("1", "1", "c", (anchor: top)),
    ("1", "2", "a", (:)),
    ("2", "2", "a,b,c", (anchor: top)),
  ),
)

#let ex = exercice(
  meta: (
    titre: "Automates et ordres partiels",
    chapitres: ("langages-reguliers", "automates-finis"),
    difficulte: 4,
    niveaux: ("MPI", "MP"),
    duree: (1, 0),
    concours: (nom: "ENS", annee: 2022, filiere: "MP", oral: true),
  ),
  corrections: [
    - Numérotation : commencer à 1 et décaler les renvois d'une unité.
    - Question 3 : permettre les automates incomplets ; un automate complet sur un alphabet non vide ne peut être sans cycle.
    - Question 4 : préciser $i<j$ et le sens du sous-mot dans le lemme de Higman ; sans cette condition, l'énoncé serait trivial.
    - Question 5 : préciser l'indexation des lettres des monômes et compléter la preuve sur le complémentaire.
  ],
  jury: [
    - Expliquer les pistes envisagées et les difficultés rencontrées afin de permettre le dialogue avec le jury.
  ],
  contenu: (
    [
      Soit $cal(A)=(Q,A,δ,I,F)$ un automate fini sans transitions $ε$, non nécessairement déterministe.
      On note $q · m$ l'ensemble des états atteints depuis $q$ en lisant $m$ ; dans le cas déterministe, on désigne aussi ainsi l'unique état atteint lorsqu'il existe.
      L'automate est partiellement ordonné si tous ses cycles ne visitent qu'un état : si $q'∈q · u$ et $q∈q' · v$, alors $q=q'$.
      Les automates peuvent être incomplets.
    ],
    question(
      [
        #enum(
          numbering: "a)",
          [Justifier le nom « partiellement ordonné ».],
          [Reconnaître ${a b a a,b a a a,a b b}$ par un automate déterministe partiellement ordonné.],
          [Donner un langage infini reconnu par un tel automate.],
          [Sur $A={a,b,c}$, reconnaître $K=A^* a c^* a A^*$ par un automate non déterministe partiellement ordonné.],
        )
      ],
      solution: [
        a) La relation $q≤q'⇔∃m∈A^*,q'∈q · m$ est réflexive et transitive. L'hypothèse est exactement son antisymétrie.

        b) L'automate des préfixes suivant convient ; toute transition non dessinée est absente.
        #fini
        Les transitions augmentent la taille du préfixe, donc aucun cycle n'est possible.

        c) Le langage $a^*$ est infini et est reconnu par :
        #infini

        d) L'automate suivant reconnaît $K$. Les seules transitions entre états distincts vont de gauche à droite.
        #exemple-k
      ],
    ),
    question(
      [
        Montrer la stabilité par union et intersection des langages reconnus par des automates partiellement ordonnés.
        Ces stabilités restent-elles vraies pour les automates déterministes partiellement ordonnés ?
      ],
      jury: [Le jury attend la maîtrise de la construction du produit pour l'intersection.],
      solution: [
        Pour l'union non déterministe, prendre la réunion disjointe des automates, de leurs initiaux et de leurs finaux.
        Pour l'intersection, prendre le produit synchrone, avec initiaux $I_1×I_2$ et finaux $F_1×F_2$.
        Un cycle dans le produit projette des chemins fermés dans les deux automates ; chaque composante reste donc au même état.
        Dans le cas déterministe, compléter d'abord par un puits non final muni de boucles : cela préserve l'ordre partiel.
        Le produit reste déterministe ; choisir les finaux $F_1×F_2$ pour l'intersection, et $(F_1×Q_2)∪(Q_1×F_2)$ pour l'union.
      ],
    ),
    question(
      [
        Un automate est strictement partiellement ordonné s'il est partiellement ordonné et n'a aucune boucle : $q∉δ(q,a)$ pour tous $q,a$.
        #enum(
          numbering: "a)",
          [Montrer qu'un langage est reconnu par un tel automate si et seulement s'il est fini.],
          [Montrer par un exemple que la taille de l'automate peut être bien inférieure au cardinal du langage.],
        )
      ],
      solution: [
        a) Un chemin dans un automate à $N$ états sans cycle a longueur au plus $N-1$, donc le langage reconnu est fini.
        Réciproquement, l'arbre des préfixes des mots d'un langage fini, sans puits ajouté, est un automate sans cycle reconnaissant ce langage. Pour le langage vide, prendre un état initial non final sans transition.

        b) Une chaîne de $n+1$ états, chaque étape portant deux transitions étiquetées $a$ et $b$, reconnaît ${a,b}^n$, qui contient $2^n$ mots.
      ],
    ),
    [
      Pour $m=a_1 … a_n∈A^*$, on note $↑m=A^* a_1 A^* … a_n A^*$ (et $↑ε=A^*$).
      Un langage est clos par sur-mots si $m∈L$ implique $↑m⊂L$.
      On veut prouver qu'un tel langage est régulier et reconnu par un automate déterministe partiellement ordonné.
      On admet le lemme de Higman : pour toute suite infinie $(w_i)_(i∈NN)$ sur un alphabet fini, il existe $i<j$ tels que $w_j∈↑w_i$.
    ],
    question(
      [
        #enum(
          numbering: "a)",
          [Montrer que l'intersection de deux langages clos par sur-mots est close par sur-mots.],
          [Pour $F⊂A^*$ fini, reconnaître $⋃_(m∈F)↑m$ par un automate déterministe partiellement ordonné.],
          [Montrer qu'un langage $L$ est clos par sur-mots si et seulement s'il existe un ensemble fini $F$ tel que $L=⋃_(m∈F)↑m$. Conclure.],
        )
      ],
      solution: [
        a) Un sur-mot d'un mot de l'intersection appartient à chacun des deux langages.

        b) Pour $m=a_1…a_n$, prendre les états $0,…,n$, initial $0$, seul final $n$.
        Depuis $k<n$, avancer à $k+1$ sur $a_(k+1)$ et boucler sur toute autre lettre ; depuis $n$, boucler sur toutes les lettres.
        Après chaque préfixe lu, l'état est la taille du plus long préfixe de $m$ déjà rencontré comme sous-mot, par récurrence.
        Cet automate reconnaît $↑m$ et ses états ne peuvent que croître. Appliquer la stabilité par union finie de la question 2, y compris pour $F=∅$.

        c) Si aucune famille finie ne suffit, choisir $w_0∈L$, puis $w_j∈L$ hors de $⋃_(i<j)↑w_i$.
        Cette suite contredit Higman. Il existe donc une famille finie $F⊂L$ couvrant $L$ par ses sur-mots ; l'inclusion inverse vient de la clôture.
        Réciproquement, toute union de langages $↑m$ est close par sur-mots, par transitivité de la relation de sous-mot.
        La construction de b) conclut.
      ],
    ),
    [
      Un monôme est un langage de la forme $B_0^* a_0 B_1^* a_1 … a_(n-1) B_n^*$, avec $B_i⊂A$ et $a_i∈A$. On autorise $n=0$ et on pose $∅^*={ε}$.
    ],
    question(
      [
        #enum(
          numbering: "a)",
          [Montrer qu'un langage est reconnu par un automate non déterministe partiellement ordonné si et seulement s'il est une union finie de monômes.],
          [Montrer que l'intersection de deux monômes est une union finie de monômes.],
          [Montrer que $T=(a b)^*$ n'est pas reconnu par un automate non déterministe partiellement ordonné.],
          [En déduire un langage reconnu par un tel automate dont le complémentaire ne l'est pas.],
        )
      ],
      solution: [
        a) Un monôme est reconnu par une chaîne d'états : les transitions successives portent $a_0,…,a_(n-1)$ et l'état $i$ boucle sur les lettres de $B_i$.
        La réunion disjointe traite une union finie.
        Réciproquement, supprimer les boucles d'un chemin acceptant laisse un chemin sans répétition d'état. Il n'existe qu'un nombre fini de tels chemins étiquetés.
        Chacun décrit un monôme, avec pour $B_i$ les lettres des boucles de son état $i$. Leur union est le langage reconnu.

        b) Utiliser le produit de la question 2, puis a).

        c) Supposons $T$ union de monômes. Un monôme contenu dans $T$ ne peut avoir de $B_i$ non vide : si $a∈B_i$ ou $b∈B_i$, choisir dans ce facteur étoilé respectivement $a a$ ou $b b$ et les autres facteurs étoilés vides produirait un mot hors de $T$.
        Tous ces monômes seraient donc des singletons, rendant $T$ fini, contradiction.

        d) Sur $A={a,b}$,
        $ A^*∖T=b A^* ∪ A^* a ∪ A^* a a A^* ∪ A^* b b A^*. $
        En effet, un mot non vide qui commence par $a$, termine par $b$ et n'a pas deux lettres consécutives égales appartient à $(a b)^*$ ; $ε$ appartient aussi à $T$.
        Ce complémentaire est une union finie de monômes, mais son complémentaire $T$ ne l'est pas.
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
