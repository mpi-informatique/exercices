#import "/load.typ": est-corrige
#import "/load.typ": exercice, partie, question
#import "/load.typ": sep
#let ex = exercice(
  meta: (
    titre: "Évaluation accélérée d'automates",
    chapitres: ("langages-reguliers", "automates-finis"),
    algorithmes: ("diviser-pour-regner",),
    structures: ("arbre-binaire", "tableau", "arbre-bicolore"),
    difficulte: 4,
    niveaux: ("MPI", "MP"),
    duree: (1, 0),
    concours: (nom: "ENS", annee: 2018, filiere: "MP", oral: true),
  ),
  corrections: [
    - Numérotation : commencer à 1 et décaler les renvois d'une unité.
    - Question 6, corrigé : remplacer la décomposition dyadique fautive par un parcours de l'arbre d'intervalles ; conserver l'ordre des compositions.
    - Question 8, corrigé : conserver le facteur $abs(Q)$ pour les mises à jour et préciser les informations à maintenir.
  ],
  jury: [
    - Expliquer les pistes envisagées et les difficultés rencontrées afin de permettre le dialogue avec le jury.
  ],
  contenu: (
    [
      On donne un alphabet $Σ$, un ADC $A$ et un mot $w=a_0 … a_(n-1)$.
      Pour $0≤i<j≤n$, on note $w[i,j]=a_i … a_(j-1)$.
      L'objectif est de répondre efficacement aux requêtes : « $w[i,j]$ est-il accepté par $A$ ? ».
      Les transitions, le mot et l'appartenance aux états finaux sont accessibles par tableaux en temps constant.
    ],
    question(
      [
        Donner le pseudocode d'un algorithme répondant à une requête. Préciser ses complexités en temps et en espace.
      ],
      solution: [
        ```text
        q ← état initial
        pour k de i à j − 1 :
            q ← δ(q, w[k])
        renvoyer (q appartient à F)
        ```
        Après chaque itération, $q$ est l'état atteint après le préfixe déjà lu du facteur. Le résultat est donc correct.
        Il faut $O(j-i)$ en temps et $O(1)$ en espace auxiliaire.
      ],
    ),
    [
      On cherche maintenant une structure de données, appelée index, construite à partir de $A$ et $w$, qui accélère les requêtes.
    ],
    question(
      [
        Proposer un index de taille $O(n^2)$ permettant de répondre en temps $O(1)$.
      ],
      solution: [
        Stocker dans un tableau à deux entrées le booléen $T[i,j]=(w[i,j]∈cal(L)(A))$. Les $n(n+1)/2$ cases utiles donnent la taille annoncée et chaque requête est un accès direct.
      ],
    ),
    question(
      [
        Quelle est la complexité en temps du calcul de cet index ?
      ],
      solution: [
        Des simulations indépendantes coûteraient $O(n^3)$.
        Pour chaque $i$, partir de l'état initial et lire successivement $a_i,…,a_(n-1)$, en stockant après chaque lettre la réponse correspondante.
        Il y a $∑_(i=0)^(n-1)(n-i)=n(n+1)/2$ transitions : le temps est $Θ(n^2)$, optimal pour remplir cet index.
      ],
    ),
    [
      Notons $Q$ l'ensemble des états et $δ:Q×Σ→Q$ la transition. On définit
      $ δ^*(q,ε)=q, #sep δ^*(q,a m)=δ^*(δ(q,a),m). $
      L'effet de transition de $m$ est la fonction $f_m:Q→Q$ donnée par $f_m(q)=δ^*(q,m)$.
    ],
    question(
      [
        Décrire $f_ε$ et exprimer $f_(u v)$ en fonction de $f_u$ et $f_v$.
      ],
      solution: [
        On a $f_ε="id"_Q$ et $f_(u v)=f_v∘f_u$, car on lit $u$ avant $v$. Chaque fonction se représente par un tableau de $abs(Q)$ images.
      ],
    ),
    question(
      [
        Supposons $n$ puissance de 2. Deux indices $i<j$ sont des multiples consécutifs d'une même puissance de 2 si $j-i$ est une puissance de 2 divisant $i$ et $j$.
        Proposer un algorithme « diviser pour régner » calculant $f_(w[i,j])$ pour tous ces intervalles. Analyser son temps de calcul.
      ],
      solution: [
        Construire un arbre binaire dont les feuilles sont les lettres et dont chaque nœud représente un intervalle $[i,j[$.
        Une feuille stocke $q↦δ(q,a_i)$. Un nœud interne, de milieu $m=(i+j)/2$, stocke
        $ f_(w[i,j])=f_(w[m,j])∘f_(w[i,m]). $
        Les enfants étant calculés avant leur parent, chaque composition de tableaux coûte $O(abs(Q))$.
        L'arbre a $2n-1$ nœuds : temps et espace $O(n abs(Q))$.
      ],
    ),
    question(
      [
        Répondre à une requête avec l'index précédent ; préciser la complexité et conclure.
      ],
      solution: [
        Parcourir l'arbre de gauche à droite : ignorer les intervalles disjoints de $[i,j[$, utiliser directement ceux entièrement inclus et descendre dans les autres.
        À chaque profondeur, seuls les deux intervalles contenant les bornes peuvent être partiellement inclus : on visite $O(1+log n)$ nœuds utiles.
        Partir de l'état initial et lui appliquer, dans l'ordre, les effets des intervalles retenus, puis tester si l'état obtenu est final.
        Chaque effet s'applique en $O(1)$ : temps $O(1+log n)$ et pile récursive $O(1+log n)$.
        Calculer toute la fonction du facteur coûterait $O(abs(Q)(1+log n))$, mais une seule image suffit ici.
        L'index échange donc un prétraitement $O(n abs(Q))$ contre des requêtes logarithmiques, au lieu des requêtes linéaires sans index ou du stockage quadratique de toutes les réponses.
      ],
    ),
    question(
      [
        On autorise maintenant la substitution de la $i$-ème lettre, $1≤i≤n$, par $a∈Σ$.
        Adapter l'index et donner la complexité de mise à jour.
      ],
      solution: [
        Modifier la feuille d'indice $i-1$, puis recalculer les tableaux de ses seuls ancêtres, du bas vers le haut.
        Il y a $1+log_2 n$ tableaux, chacun recalculé en $O(abs(Q))$, soit $O(abs(Q)(1+log n))$ en temps. Les requêtes restent inchangées.
      ],
    ),
    question(
      [
        Pourrait-on autoriser insertions et suppressions de lettres ? Quelles seraient les difficultés ?
      ],
      solution: [
        Le décalage des indices invalide les intervalles alignés sur les puissances de deux. On représente plutôt les lettres par les feuilles, dans l'ordre, d'un arbre binaire équilibré.
        Chaque nœud stocke la taille de son sous-arbre et l'effet de son mot ; les tailles permettent de retrouver une position.
        Après insertion ou suppression, recalculer les informations des ancêtres et des nœuds concernés par les rotations de rééquilibrage.
        Pour une hauteur $h$, une requête coûte $O(h)$ et une mise à jour $O(abs(Q)h)$ si l'équilibrage modifie $O(h)$ nœuds.
        Maintenir $h=O(1+log n)$ est donc la difficulté essentielle ; un arbre bicolore augmenté donne ces garanties. Sa mise en œuvre détaillée n'est pas demandée.
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
