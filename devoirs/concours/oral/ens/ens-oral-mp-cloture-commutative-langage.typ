#import "/load.typ": exercice, partie, question
#import "/load.typ": sep
#let ex = exercice(
  meta: (
    titre: "Clôture commutative de langages réguliers",
    chapitres: ("langages-reguliers", "automates-finis"),
    algorithmes: ("kosaraju", "parcours-en-profondeur"),
    structures: ("graphe-oriente",),
    difficulte: 5,
    niveaux: ("MPI", "MP"),
    duree: (1, 0),
    concours: (nom: "ENS", annee: 2017, filiere: "MP", oral: true),
  ),
  corrections: [
    - Numérotation : commencer à 1 et décaler les renvois d'une unité.
    - Question 2, corrigé : utiliser $b a a∈L_1$ comme témoin.
    - Question 4, corrigé : fixer le nombre de $a$ et utiliser le langage des mots de même taille.
    - Question 5, corrigé : distinguer composantes fortement connexes et composantes connexes.
    - Question 7, corrigé : expliciter la croissance dans chacune des deux coordonnées avant de stabiliser la diagonale.
  ],
  jury: [
    - Expliquer les pistes envisagées et les difficultés rencontrées afin de permettre le dialogue avec le jury.
  ],
  contenu: (
    [
      On fixe $Σ={a,b}$. Pour $w∈Σ^*$, $abs(w)_a$ et $abs(w)_b$ comptent ses occurrences de $a$ et $b$.
      La clôture commutative de $L⊂Σ^*$ est
      $ "CCl"(L)={w∈Σ^* | ∃w'∈L, abs(w)_a=abs(w')_a " et " abs(w)_b=abs(w')_b}. $
      On admet le théorème de Kleene : les langages décrits par une expression régulière sont exactement ceux reconnus par un automate fini. Ils sont appelés réguliers.
    ],
    question(
      [
        Calculer la clôture commutative du langage $L_0$ décrit par $a^* | b^*$.
      ],
      solution: [
        Chaque mot ne contient qu'une sorte de lettre : le permuter ne le change pas. Ainsi $"CCl"(L_0)=L_0$.
      ],
    ),
    question(
      [
        Soit $L_1$ décrit par $b(a a)^*$. Donner une expression régulière de $"CCl"(L_1)$.
        Existe-t-il un langage régulier $L'_1$ tel que $"CCl"(L'_1)=L_1$ ?
      ],
      solution: [
        Les mots cherchés contiennent un seul $b$ et un nombre pair de $a$. Selon la parité du nombre de $a$ de chaque côté de $b$, une expression est
        $ (a a)^*(a b a | b)(a a)^*. $
        Non pour la seconde question : toute clôture commutative est stable par permutation, tandis que $b a a∈L_1$ et $a a b∉L_1$.
      ],
    ),
    question(
      [
        Trouver un langage régulier $L_2$ tel que $"CCl"(L_2)={w | abs(w)_a=abs(w)_b}$.
        En déduire que la clôture commutative d'un langage régulier n'est pas nécessairement régulière.
      ],
      solution: [
        Prendre $L_2=(a b)^*$.
        Si sa clôture était régulière, pour une taille de pompage $p≥1$, le mot $a^p b^p$ aurait une boucle non vide entièrement dans ses $p$ premiers $a$.
        Pomper cette boucle changerait le nombre de $a$ sans changer celui des $b$, contradiction.
      ],
    ),
    question(
      [
        Un langage est $a$-borné s'il existe $k∈NN$ tel que $abs(w)_a≤k$ pour tout $w∈L$.
        Montrer que, si $L$ est régulier et $a$-borné, $"CCl"(L)$ est régulier.
        Étendre ce résultat aux langages réguliers $a b$-bornés : il existe $k$ tel que chaque $w∈L$ vérifie $abs(w)_a≤k$ ou $abs(w)_b≤k$.
      ],
      solution: [
        Pour tout langage régulier $K$, posons
        $ "Len"(K)={w∈Σ^* | ∃v∈K, abs(w)=abs(v)}. $
        Ce langage est régulier : dans un automate sans transitions $ε$ reconnaissant $K$, remplacer chaque transition par deux transitions de mêmes extrémités, étiquetées respectivement $a$ et $b$.
        L'automate obtenu reconnaît exactement $"Len"(K)$.

        Supposons $L$ régulier et $a$-borné, de borne $k$.
        Pour $0≤i≤k$, le langage $L_i=L∩{w | abs(w)_a=i}$ est régulier, car avoir exactement $i$ occurrences de $a$ est une condition régulière.
        Or
        $ "CCl"(L_i)="Len"(L_i)∩{w∈Σ^* | abs(w)_a=i}. $
        En effet, à nombre de $a$ fixé, deux mots ont la même taille si et seulement s'ils ont le même nombre de $b$.
        Ainsi $"CCl"(L_i)$ est régulier par intersection, puis
        $ "CCl"(L) = union.big_(i = 0)^k "CCl"(L_i) $
        est régulier par union finie.

        Si $L$ est $a b$-borné, le décomposer en l'union de $L∩{w | abs(w)_a≤k}$ et $L∩{w | abs(w)_b≤k}$.
        Appliquer la preuve précédente et sa version symétrique, puis la stabilité par union.
      ],
    ),
    question(
      [
        Proposer des algorithmes décidant si un langage régulier donné est $a$-borné, puis s'il est $a b$-borné.
      ],
      solution: [
        Représenter $L$ par un automate sans transitions $ε$ et l'émonder.
        Il n'est pas $a$-borné si et seulement si une transition sur $a$ appartient à un cycle : on peut alors répéter ce cycle sur un chemin acceptant.
        Sinon, aucune transition sur $a$ ne peut se répéter sur un tel chemin, ce qui borne leur nombre.
        Calculer les composantes fortement connexes par Kosaraju, puis chercher une transition sur $a$ interne à une composante, en $O(N+m)$ en temps et en espace.

        Dans le graphe acyclique des composantes, marquer par $a$ les composantes contenant un cycle avec $a$, et de même pour $b$.
        Le langage n'est pas $a b$-borné exactement lorsqu'un chemin visite une composante marquée $a$ et une composante marquée $b$, éventuellement la même.
        Le sens direct du critère vient de la répétition des deux cycles.
        Réciproquement, sur un chemin de composantes sans ces deux types, l'une des deux lettres n'étiquette aucune transition interne ; elle apparaît donc au plus $N-1$ fois entre composantes. Cette borne est uniforme.
        Deux propagations d'accessibilité, depuis toutes les composantes marquées $a$ puis depuis celles marquées $b$, testent le critère en $O(N+m)$.
        Un automate vide après émondage est borné dans les deux sens.
      ],
    ),
    question(
      [
        Donner un langage régulier qui n'est pas $a b$-borné mais dont la clôture commutative est régulière. Que déduire par rapport à la question 4 ?
      ],
      solution: [
        Le langage $Σ^*$ convient : il est sa propre clôture commutative et contient $a^n b^n$ pour tout $n$. Être $a b$-borné est donc une condition suffisante mais non nécessaire.
      ],
    ),
    question(
      [
        Un langage $L$ est ultimement périodique s'il existe $t∈NN$ et $p∈NN^*$ tels que, pour tous $k,l≥t$, l'existence dans $L$ d'un mot de comptes $(k,l)$ implique l'existence de mots de comptes $(k+p,l)$ et $(k,l+p)$.
        Montrer que, si $L$ est régulier et ultimement périodique, $"CCl"(L)$ est régulier. Comparer à la question 4.
      ],
      solution: [
        Pour $i,j≥0$, poser
        $ S_(i,j)={(r,s)∈{0,…,p-1}^2 | ∃w∈L, (abs(w)_a,abs(w)_b)=(t+i p+r,t+j p+s)}. $
        L'hypothèse donne $S_(i,j)⊂S_(i+1,j)$ et $S_(i,j)⊂S_(i,j+1)$.
        La suite diagonale $S_(i,i)$ est croissante dans un ensemble fini : elle est constante à partir d'un rang $R$.
        Pour $i,j≥R$, en posant $h=max(i, j)$, on a
        $ S_(R,R)⊂S_(i,j)⊂S_(h,h)=S_(R,R). $
        Ainsi tous ces ensembles sont égaux. Posons $T=t+R p$.

        Décomposer $L$ selon qu'un compte est inférieur à $T$, ou que les deux sont au moins $T$.
        La première partie est régulière par intersection avec des compteurs bornés, et $a b$-bornée ; sa clôture est régulière par la question 4 (si $T=0$, elle est vide).
        Pour la seconde, l'égalité précédente dit que les comptes admis sont exactement les couples
        $ (T+i p+r,T+j p+s), #sep i,j≥0, #sep (r,s)∈S_(R,R). $
        Pour chaque couple de résidus, un automate compte les $a$ et les $b$ jusqu'au seuil $T$, puis modulo $p$ ; il reconnaît les mots de ces comptes.
        Une union finie donne la clôture de cette seconde partie, puis celle de $L$.
        Tout langage $a b$-borné est ultimement périodique en choisissant $t$ strictement supérieur à sa borne : l'implication devient vide. Le résultat généralise donc la question 4.
      ],
    ),
    question(
      [
        Montrer réciproquement que, si $L$ est régulier et $"CCl"(L)$ est régulier, alors $L$ est ultimement périodique. Conclure.
        Indication : le quotient à gauche est $w^(-1)K={v | w v∈K}$. On pourra utiliser, puis démontrer, que ${w^(-1)K | w∈Σ^*}$ est fini lorsque $K$ est régulier.
      ],
      solution: [
        Posons $K="CCl"(L)$ et $f(i,j)=(a^i b^j)^(-1)K$. Son image est finie par l'indication.
        Montrons le lemme suivant : pour toute application $g:NN^2→X$ avec $X$ fini non vide, il existe $i,j,d,e$ avec $d,e>0$ et
        $ g(i,j)=g(i+d,j)=g(i,j+e). $
        Raisonnons par récurrence sur $abs(X)$. Pour une seule valeur c'est immédiat.
        Sinon, une valeur $x$ apparaît sur une infinité de positions $(p_r,0)$, avec $p_r$ strictement croissants.
        Si $g(p_r,s)=x$ pour un $s>0$, prendre $i=p_r$, $j=0$, $d=p_(r+1)-p_r$ et $e=s$.
        Sinon, l'application $(r,s)↦g(p_r,s+1)$ évite $x$. La récurrence lui donne trois positions convenables ; leur retour aux indices originaux donne $d=p_(r+d')-p_r>0$ et la même différence verticale $e>0$. Le lemme est démontré.

        Appliquons-le à $f$ et posons $t=max(i, j)$, $p=d e$.
        Pour $k,l≥t$ tels qu'un mot de $L$ ait les comptes $(k,l)$, on a $a^i b^j a^(k-i)b^(l-j)∈K$.
        L'égalité $f(i,j)=f(i+d,j)$ permet d'augmenter le compte de $a$ de $d$ sans quitter $K$ ; par commutativité de $K$, elle reste applicable après chaque augmentation.
        Répéter $e$ fois donne les comptes $(k+p,l)$. L'autre égalité, répétée $d$ fois, donne $(k,l+p)$.
        Par définition de $K$, ces comptes sont réalisés dans $L$, qui est donc ultimement périodique.

        Enfin, si un automate déterministe complet à $N$ états reconnaît un langage $K$, $w^(-1)K$ est le langage lu depuis l'état atteint après $w$ ; il y a donc au plus $N$ quotients. Cela prouve l'indication.
        Pour un langage régulier $L$, sa clôture commutative est régulière si et seulement si $L$ est ultimement périodique au sens du sujet.
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
