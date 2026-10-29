#import "/load.typ": est-corrige
#import "/load.typ": exercice, partie, question
#let ex = exercice(
  meta: (
    titre: "Automates et palindromes",
    chapitres: ("langages-reguliers", "automates-finis"),
    algorithmes: ("parcours-en-profondeur", "tri-topologique", "programmation-dynamique"),
    structures: ("graphe",),
    difficulte: 4,
    niveaux: ("MPI", "MP"),
    duree: (1, 0),
    concours: (nom: "ENS", annee: 2018, filiere: "MP", oral: true),
  ),
  corrections: [
    - Question 6, corrigé : justifier l'unicité des chemins acceptants du produit, sans supposer ce produit déterministe ; distinguer opérations arithmétiques et coût binaire.
  ],
  jury: [
    - Expliquer les pistes envisagées et les difficultés rencontrées afin de permettre le dialogue avec le jury.
  ],
  contenu: (
    [
      On fixe un alphabet fini $Σ$ avec $abs(Σ)>1$. Un mot $w=a_1 … a_n$ est un palindrome si $a_i=a_(n-i+1)$ pour tout $1≤i≤n$.
      On note $Π$ le langage des palindromes et $cal(L)(A)$ le langage reconnu par un automate fini $A$ sur $Σ$.
      Les automates sont sans transitions $ε$.
    ],
    question(
      [
        Soit $Π_n=Π∩Σ^n$. Montrer que, pour tout ADC $A$ et tout $n∈NN$, si $cal(L)(A)∩Σ^(2n)=Π_(2n)$, alors $A$ a au moins $abs(Σ)^n$ états.
      ],
      solution: [
        Associons à $u∈Σ^n$ l'état $f(u)$ atteint après sa lecture.
        Si $u≠v$ et $f(u)=f(v)$, l'acceptation de $u overline(u)$ entraîne celle de $v overline(u)$, où $overline(u)$ est le miroir de $u$.
        Ce dernier mot n'est pas un palindrome : ses deux moitiés imposeraient $u=v$.
        Ainsi $f$ est injective, d'où la borne, également valable pour $n=0$.
      ],
    ),
    question(
      [
        En déduire que $Π$ n'est pas régulier.
      ],
      solution: [
        Si un ADC à $N$ états reconnaissait $Π$, la question 1 donnerait $N≥abs(Σ)^N≥2^N>N$, contradiction.
      ],
    ),
    question(
      [
        Étant donné un automate fini $A$, peut-on calculer un automate $A_Π$ reconnaissant $cal(L)(A)∩Π$ ?
      ],
      solution: [
        Non en général : pour $cal(L)(A)=Σ^*$, ce langage serait $Π$, qui n'est pas régulier.
      ],
    ),
    question(
      [
        Pour $m=b_1 … b_n$, on note $overline(m)=b_n … b_1$ son miroir.
        Étant donné $A$, peut-on calculer un automate $A'_Π$ reconnaissant ${m∈Σ^* | m overline(m)∈cal(L)(A)}$ ?
      ],
      solution: [
        Oui. Écrivons $A=(Q,I,F,δ)$ et renversons ses transitions pour obtenir l'automate miroir $overline(A)$.
        Construisons le produit $B$ d'états $Q×Q$, initiaux $I×F$ et finaux $D={(q,q) | q∈Q}$, avec
        $ (p,r) arrow.r.long^(a) (p',r') ⟺ (p,a,p')∈δ " et " (r',a,r)∈δ. $
        Par récurrence sur la taille de $m$, un chemin de $B$ étiqueté $m$ de $(i,f)$ à $(p,r)$ correspond exactement à un chemin $i arrow.r.long^(m) p$ et à un chemin $r arrow.r.long^(overline(m)) f$ dans $A$.
        Il est acceptant si et seulement si $p=r$, ce qui permet de concaténer ces deux chemins en un chemin acceptant de $A$ étiqueté $m overline(m)$.
        Réciproquement, scinder un chemin acceptant de $A$ étiqueté $m overline(m)$ après la lecture de $m$ donne un tel chemin acceptant de $B$.
        Ainsi $cal(L)(B)={m∈Σ^* | m overline(m)∈cal(L)(A)}$ : prendre $A'_Π=B$.
      ],
    ),
    question(
      [
        On note $Π_"pair"=⋃_(n∈NN)Π_(2n)$. Proposer un algorithme déterminant si $cal(L)(A)∩Π_"pair"$ est vide, fini ou infini. Discuter ses complexités en temps et en espace.
      ],
      jury: [Les parcours doivent être décrits avec leur structure de données et leur complexité.],
      solution: [
        La fonction $m↦m overline(m)$ est une bijection de $cal(L)(B)$ vers $cal(L)(A)∩Π_"pair"$.
        Dans $B$, calculer les états accessibles et coaccessibles par deux parcours, puis conserver leur intersection.
        Si elle est vide, le langage est vide. Sinon, il est infini exactement lorsque ce sous-automate contient un cycle : on peut alors répéter ce cycle sur un chemin acceptant ; sans cycle, tout chemin a une longueur bornée.
        Un parcours en profondeur détecte les cycles.

        Posons $N=abs(Q)$ et $m_a$ le nombre de transitions de $A$ étiquetées $a$.
        Le produit a $N^2$ états et $M=∑_(a∈Σ)m_a^2$ transitions, construites en appariant les transitions de même lettre.
        Construction et parcours coûtent $O(N^2+M)$ en temps et en espace, donc $O((N+abs(δ))^2)$.
        Pour un automate déterministe, $m_a≤N$, d'où $O((1+abs(Σ))N^2)$.
      ],
    ),
    question(
      [
        Modifier l'algorithme de la question 5 pour calculer la cardinalité de $cal(L)(A)∩Π_"pair"$ lorsqu'elle est finie, en supposant $A$ déterministe. Comment la complexité est-elle affectée ?
      ],
      solution: [
        Même si $A$ est déterministe, $B$ ne l'est pas nécessairement. En revanche, chaque chemin acceptant de $B$ étiqueté $m$ correspond bijectivement à un chemin acceptant de $A$ étiqueté $m overline(m)$ : il est unique.
        Après émondage, le graphe est acyclique dans le cas fini. Dans l'ordre topologique inverse, calculer
        $ c(s)=bold(1)_(s∈D)+∑_(s arrow.r.long^(a) t)c(t). $
        La somme porte sur les transitions, y compris lorsque plusieurs lettres mènent au même état.
        Le résultat est $∑_(s∈I×F)c(s)$, en ne conservant que les états utiles.
        L'unicité des chemins acceptants justifie que ce compte de chemins soit un compte de mots.
        Il y a $O(N^2+M)$ opérations arithmétiques et autant de mémoire structurelle.
        En coût binaire, si les compteurs ont au plus $b$ bits, les additions coûtent $O(b)$ et les compteurs $O(N^2 b)$ bits ; on peut prendre $b=O(1+N^2 log(1+abs(Σ)))$, puisque les mots acceptés ont une taille inférieure à $N^2$.
      ],
    ),
    question(
      [
        Modifier les algorithmes des questions 5 et 6 pour traiter $cal(L)(A)∩Π$.
      ],
      solution: [
        Pour chaque $a∈Σ$, garder le même produit et remplacer $D$ par $D_a={(p,r) | (p,a,r)∈δ}$.
        Il reconnaît ${m | m a overline(m)∈cal(L)(A)}$, avec la même correspondance entre chemins acceptants.
        Appliquer les tests et le comptage au cas pair et à chaque lettre centrale, puis sommer les cardinalités.
        Les palindromes ainsi obtenus sont disjoints selon leur parité et leur lettre centrale, même si les langages de demi-mots se recoupent.
        Le temps est multiplié au plus par $1+abs(Σ)$ ; les calculs successifs réutilisent le même graphe et le même espace de travail.
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
