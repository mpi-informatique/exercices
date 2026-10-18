#import "/load.typ": exercice, partie, question
#import "/load.typ": sep
#let ex = exercice(
  meta: (
    titre: "Réparation de mots pour un langage régulier",
    chapitres: ("langages-reguliers", "automates-finis"),
    algorithmes: ("programmation-dynamique", "parcours-en-largeur"),
    structures: ("tableau", "graphe-oriente", "liste-adjacence"),
    difficulte: 4,
    niveaux: ("MPI", "MP"),
    duree: (1, 0),
    concours: (nom: "ENS", annee: 2018, filiere: "MP", oral: true),
  ),
  corrections: [
    - Numérotation : commencer à 1 et décaler les renvois d'une unité.
    - Question 6 : une suppression doit donner $u v∈L$, et non seulement $u v∈Σ^*$.
    - Question 8, corrigé : corriger l'initialisation d'une suppression vide et le sens des transitions dans les minima.
    - Questions 9 et 10, corrigé : corriger les indices des distances, expliciter leur prétraitement et la reconstruction.
  ],
  jury: [
    - Expliquer les pistes envisagées et les difficultés rencontrées afin de permettre le dialogue avec le jury.
  ],
  contenu: (
    [
      On fixe un langage régulier $L$ sur $Σ$.
      Une réparation par insertion de $w$ est une décomposition $w=u v$ et un mot $z$ tels que $u z v∈L$.
      Pour les algorithmes, $L$ est représenté par un automate fini non déterministe sans transitions $ε$, $A=(Q,I,F,δ)$.
      On pose $n=abs(w)$, $N=abs(Q)$ et $m=abs(δ)$ ; les états sont numérotés, les transitions stockées par listes d'adjacence.
      On peut conserver des listes inverses, de taille $O(N+m)$, et représenter les ensembles d'états par des tableaux booléens.
      Le mot est stocké dans un tableau ; $w[i,j]$ désigne son facteur d'indices $i$ inclus à $j$ exclu.
    ],
    question(
      [
        Soit $L_0$ décrit par $(a b)^*$. Proposer une réparation par insertion de $w_0=a a b$, puis de $w'_0=a b a b$.
        Le mot $w''_0=a a$ en admet-il une ?
      ],
      solution: [
        Pour $a a b$, prendre $u=a$, $v=a b$, $z=b$ : on obtient $a b a b$.
        Pour $a b a b$, prendre $z=ε$.
        Pour $a a$, toute insertion ailleurs qu'à la fin laisse un $a$ final ; une insertion à la fin laisse le préfixe $a a$. Aucun de ces mots n'appartient à $(a b)^*$.
      ],
    ),
    question(
      [
        Une réparation par insertion finale de $w$ est un mot $z$ tel que $w z∈L$. Proposer un algorithme décidant son existence et donner ses complexités en temps et en espace.
      ],
      solution: [
        Notons $P_i$ les états atteints après le préfixe de taille $i$.
        Le pseudocode suivant utilise $δ(P,a)=⋃_(q∈P)δ(q,a)$.
        ```text
        P ← I
        pour chaque lettre a de w : P ← δ(P, a)
        C ← états atteignables depuis F dans le graphe inversé
        renvoyer (P ∩ C est non vide)
        ```
        Un état de $P_n∩C$ permet exactement de lire un prolongement acceptant.
        Chaque lecture parcourt au plus $m$ transitions et initialise $N$ cases ; le parcours inverse coûte $O(N+m)$.
        Temps $O((n+1)(N+m))$, espace auxiliaire $O(N+m)$, dont $O(N)$ pour les marques et la file.
      ],
    ),
    question(
      [
        Modifier l'algorithme de la question 2 pour produire une insertion finale de taille minimale ; préciser les complexités.
      ],
      solution: [
        Faire un parcours en largeur depuis tous les finaux dans le graphe inversé.
        Il donne pour chaque état $q$ une distance $d(q,F)$ et une transition témoin allant vers un état de distance inférieure d'une unité.
        Choisir $q∈P_n$ de distance minimale finie et suivre ces transitions pour construire $z$.
        Un plus court chemin n'a pas de répétition, donc $abs(z)≤N-1$.
        Les complexités de la question 2 restent valables, production du témoin comprise.
      ],
    ),
    question(
      [
        Décider l'existence d'une réparation par insertion quelconque ; donner les complexités en temps et en espace.
      ],
      solution: [
        Calculer $P_i$ comme précédemment et, à rebours, $T_i$, l'ensemble des états depuis lesquels $w[i,n]$ mène à un final :
        $ T_n=F, #sep T_i={q | ∃r∈T_(i+1), (q,w_i,r)∈δ}. $
        À la coupure $i$, une insertion existe si un chemin relie un état de $P_i$ à un état de $T_i$.
        Tester ce fait par un parcours depuis $P_i$, pour chaque $i$.
        Les $n+1$ parcours et les calculs des ensembles prennent $O((n+1)(N+m))$ en temps ; stocker les ensembles de suffixes prend $O((n+1)N)$, et les listes inverses $O(N+m)$.
      ],
    ),
    question(
      [
        Modifier l'algorithme de la question 4 pour produire une décomposition et une insertion $z$ de taille minimale.
      ],
      solution: [
        À chaque coupure, utiliser un parcours en largeur multi-source depuis $P_i$ et prendre la plus petite distance atteinte dans $T_i$.
        Conserver la meilleure coupure et relancer son parcours en mémorisant les prédécesseurs et les lettres des transitions ; leur remontée fournit $z$.
        La distance mesure exactement le nombre de lettres insérées.
        Temps $O((n+1)(N+m))$ et espace $O((n+1)N+m)$, comme précédemment.
      ],
    ),
    question(
      [
        Une réparation par suppression de $w$ est une décomposition $w=u z v$ telle que $u v∈L$.
        Proposer un algorithme naïf décidant son existence et produisant une suppression de taille minimale. Préciser ses complexités.
      ],
      solution: [
        Énumérer les coupures $0≤i≤j≤n$, simuler $A$ sur $w[0,i]w[j,n]$, et conserver une paire acceptante minimisant $j-i$.
        Il y a $O((n+1)^2)$ paires et chaque simulation coûte $O((n+1)(N+m))$.
        D'où $O((n+1)^3(N+m))$ en temps et $O(N)$ en espace auxiliaire hors automate ; on lit les deux facteurs sans les copier et on renvoie leurs indices.
      ],
    ),
    question(
      [
        Décider l'existence d'une réparation par suppression avec une complexité linéaire en $w$.
      ],
      solution: [
        Pour chaque préfixe $u$, maintenir trois ensembles : $P_u$ après lecture sans suppression, $D_u$ pendant une suppression suffixe, et $R_u$ après une suppression éventuellement vide.
        Initialiser les trois à $I$, puis, à la lettre $a$, calculer simultanément
        $
          P_(u a)=δ(P_u,a), #sep D_(u a)=D_u∪P_(u a), #sep
          R_(u a)=D_(u a)∪δ(R_u,a).
        $
        Une suppression est soit encore en cours à la fin du préfixe, soit déjà terminée avant sa dernière lettre : cela justifie la dernière égalité. Les deux autres expriment directement les définitions.
        Tester finalement $R_w∩F≠∅$.
        Un nombre constant de tableaux et de parcours de transitions par lettre donne $O((n+1)(N+m))$ en temps et $O(N)$ en espace auxiliaire hors automate.
      ],
    ),
    question(
      [
        Modifier l'algorithme de la question 7 pour produire une suppression minimale, toujours en temps linéaire en $w$.
      ],
      jury: [Préciser les valeurs calculées, leur ordre de calcul et leur occupation mémoire.],
      solution: [
        Remplacer $D_u$ et $R_u$ par des tableaux de coûts $d_u(q)$ et $r_u(q)$, égaux à $0$ sur $I$ et à $∞$ ailleurs au départ.
        Garder $P_u$ pour les lectures sans suppression. Les récurrences sont
        $ d_(u a)(q)=min(1+d_u(q), cases(0 &"si " q∈P_(u a), ∞ &"sinon")), $
        $ r_(u a)(q)=min(d_(u a)(q), min_((p,a,q)∈δ)r_u(p)). $
        Un minimum vide vaut $∞$. La première formule prolonge une suppression ou démarre une suppression vide ; la seconde termine la suppression ou lit la lettre après celle-ci.
        Le minimum sur les finaux donne le coût optimal.
        Pour reconstruire une décomposition, conserver pour chaque case et chaque position un prédécesseur réalisant son minimum, puis remonter depuis le meilleur final.
        On retrouve les indices de début et de fin du bloc supprimé.
        Le temps reste $O((n+1)(N+m))$ ; la reconstruction utilise $O((n+1)N+m)$ en espace, contre $O(N)$ auxiliaire pour le seul coût.
      ],
    ),
    question(
      [
        Une réparation par insertions de $w$ est un mot $w'∈L$ dont $w$ est un sous-mot : il existe une application strictement croissante $φ:{1,…,abs(w)}→{1,…,abs(w')}$ telle que $w_i=w'_(φ(i))$.
        Décider s'il en existe une et produire un $w'$ de taille minimale ; préciser les complexités.
      ],
      solution: [
        Précalculer par $N$ parcours en largeur les distances $d(p,q)$ entre états, ainsi que des chemins témoins.
        Pour chaque préfixe $u$, $c_u(q)$ est le coût minimal pour atteindre $q$ après avoir lu $u$ en autorisant des insertions partout.
        Initialiser $c_ε(q)=min_(i∈I)d(i,q)$. Puis calculer
        $ c_(u a)(q)=min_((p,a,r)∈δ)(c_u(p)+d(r,q)). $
        Toute réparation lit la dernière lettre conservée sur une transition $(p,a,r)$, puis insère un chemin de $r$ à $q$ ; réciproquement chaque terme construit une telle réparation.
        Le minimum de $c_w$ sur $F$ est donc le nombre minimal d'insertions, ou $∞$ si aucune réparation n'existe.
        Conserver pour chaque minimum la transition choisie ; remonter les préfixes et insérer les chemins témoins donne $w'$.
        Le prétraitement coûte $O(N(N+m))$. Pour chaque lettre, examiner chaque transition de cette lettre et chaque état d'arrivée donne $O(N(N+m))$ comme borne simple.
        Temps total $O((n+1)N(N+m))$, espace $O(N^2+(n+1)N+m)$ avec reconstruction.
        Les chemins insérés ont longueur au plus $N-1$, donc la sortie est de taille $O((n+1)N)$.
      ],
    ),
    question(
      [
        On autorise la suppression de $k_1$ caractères, puis l'insertion de $k_2$ caractères pour obtenir un mot de $L$, au coût $k_1+k_2$.
        Calculer le coût minimal et une réparation qui l'atteint.
      ],
      solution: [
        Conserver la signification de $c_u$ en autorisant aussi les suppressions. La base est inchangée et
        $ c_(u a)(q)=min(1+c_u(q), min_((p,a,r)∈δ)(c_u(p)+d(r,q))). $
        Soit on supprime $a$, soit on le conserve et on insère ensuite un chemin. Dans le premier cas, les insertions postérieures à la suppression peuvent être déplacées avant celle-ci et sont déjà prises en compte dans $c_u(q)$.
        Les prédécesseurs indiquent si la lettre est supprimée ou conservée ; les chemins témoins donnent les insertions.
        Le coût et le témoin se déduisent du meilleur final. Si tous les coûts finaux sont infinis, $L$ est vide et aucune réparation n'existe.
        L'ajout d'une possibilité par case ne change pas les bornes de la question 9.
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
  corrige: sys.inputs.at("corrige", default: "false") == "true",
)
