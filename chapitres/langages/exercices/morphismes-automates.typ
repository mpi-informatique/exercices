#import "/load.typ": automate
#import automate: dessiner-automate as dessiner
#import "/load.typ": exercice, question

#let a1 = dessiner(
  (("0", (0, 0), true, false), ("1", (3, 0), false, true)),
  (
    ("0", "0", "a", (anchor: top)),
    ("1", "1", "a", (anchor: top)),
    ("0", "1", "b", (curve: 0.25)),
    ("1", "0", "b", (curve: 0.25)),
  ),
)
#let a2 = dessiner(
  (("0", (0, 0), true, false), ("1", (3, 0), false, false), ("2", (6, 0), false, true)),
  (
    ("0", "1", "a", (:)),
    ("0", "2", "b", (curve: -1.8)),
    ("1", "1", "a", (anchor: top)),
    ("2", "2", "a", (anchor: top)),
    ("1", "2", "b", (curve: 0.25)),
    ("2", "1", "b", (curve: 0.25)),
  ),
)
#let a3 = dessiner(
  (("0", (0, 0), true, false), ("1", (3, 0), false, true), ("2", (6, 0), false, false)),
  (
    ("0", "0", "a", (anchor: top)),
    ("1", "1", "a", (anchor: top)),
    ("0", "1", "b", (curve: 0.25)),
    ("1", "0", "b", (curve: 0.25)),
    ("2", "0", "b", (curve: 1.8)),
    ("2", "1", "a", (curve: 0.25)),
  ),
)

#let ex = exercice(
  meta: (
    titre: "Morphismes d'automates et unicité de l'automate minimal",
    chapitres: ("automates-finis",),
    algorithmes: ("parcours-en-largeur",),
    structures: ("tableau", "unir-et-trouver"),
    difficulte: 4,
    niveaux: ("MPI", "MP"),
    duree: none,
  ),
  corrections: [
    - Questions 4 à 11 : ajouter l'accessibilité de $A$ ; elle manque pour le parcours de la question 5 et la surjectivité de $f$ en question 11.
    - Question 3 : compléter la réciproque manquante par les automates $A_3$ et $A_1$.
    - Questions 7 à 12 : compléter les preuves et les analyses de complexité absentes ou partielles.
  ],
  contenu: (
    [
      Dans toute la suite, les automates sont des ADC, sur $Σ={a,b}$.
      Soient $A=(Q_A,i_A,δ_A,F_A)$ et $A'=(Q_(A'),i_(A'),δ_(A'),F_(A'))$.
      Une fonction $f:Q_A→Q_(A')$ est un morphisme d'automates si :
      #enum(
        numbering: "(i)",
        [$f(i_A)=i_(A')$ ;],
        [$∀q∈Q_A,∀x∈Σ, f(δ_A(q,x))=δ_(A')(f(q),x)$ ;],
        [$∀q∈Q_A, f(q)∈F_(A')⇔q∈F_A$.],
      )
      Les trois automates suivants serviront d'exemples.
      #grid(
        columns: (1fr, 1fr),
        gutter: 12pt,
        [#align(center)[$A_1$] #a1], [#align(center)[$A_2$] #a2],
      )
      #align(center)[$A_3$]
      #a3
    ],
    question(
      [
        Expliciter un morphisme de $A_2$ vers $A_1$.
      ],
      solution: [
        L'application $f(0)=f(1)=0$, $f(2)=1$ conserve l'état initial et les états finaux. Les transitions sur $a$ ont des images inchangées et celles sur $b$ échangent les deux images : les six transitions vérifient (ii).
      ],
    ),
    question(
      [
        Montrer qu'il n'existe pas de morphisme de $A_3$ vers $A_1$.
      ],
      solution: [
        Les seuls états non finaux de $A_3$ sont 0 et 2, et le seul de $A_1$ est 0. Donc $f(0)=f(2)=0$. Mais $f(δ_(A_3)(2,b))=f(0)=0$, tandis que $δ_(A_1)(f(2),b)=δ_(A_1)(0,b)=1$, contradiction.
      ],
    ),
    question(
      [
        Montrer que l'existence d'un morphisme $A→A'$ implique $cal(L)(A)=cal(L)(A')$. La réciproque est-elle vraie ?
      ],
      solution: [
        Par récurrence sur $abs(u)$, les propriétés (i) et (ii) donnent
        $ f(δ_A^*(i_A,u))=δ_(A')^*(i_(A'),u). $
        Par (iii), le membre de gauche est final exactement lorsque l'état atteint dans $A$ l'est, donc les deux automates acceptent les mêmes mots.
        La réciproque est fausse : $A_3$ et $A_1$ reconnaissent tous deux les mots comportant un nombre impair de $b$, car l'état 2 de $A_3$ est inaccessible ; la question 2 exclut pourtant un morphisme $A_3→A_1$.
      ],
    ),
    [
      À partir de maintenant, on suppose $A$ et $A'$ accessibles : tout état est atteint depuis l'état initial par un mot.
      On conserve ces hypothèses dans la suite.
    ],
    question(
      [
        Si $f:A→A'$ est un morphisme, montrer qu'il est surjectif.
      ],
      solution: [
        Pour $q'∈Q_(A')$, l'accessibilité fournit $u$ avec $δ_(A')^*(i_(A'),u)=q'$. L'identité précédente donne $q'=f(δ_A^*(i_A,u))$. Ici l'accessibilité de $A'$ seule suffit.
      ],
    ),
    question(
      [
        Décrire un algorithme décidant l'existence d'un morphisme $A→A'$ et le calculant s'il existe. Préciser structures et complexité.
      ],
      solution: [
        Numéroter les états et stocker les transitions et les finaux dans des tableaux.
        Initialiser un tableau $f$ à « non défini », poser $f(i_A)=i_(A')$ et explorer $A$ depuis $i_A$ avec une file ou une pile.
        Pour chaque état $q$ extrait, vérifier $q∈F_A⇔f(q)∈F_(A')$.
        Pour chaque lettre $x$, poser $r=δ_A(q,x)$ et $r'=δ_(A')(f(q),x)$.
        Si $f(r)$ n'est pas défini, lui affecter $r'$ et ajouter $r$ à la file ; sinon vérifier $f(r)=r'$.
        Toute contradiction exclut un morphisme, puisque la valeur sur un état accessible est imposée par un mot qui l'atteint. Sans contradiction, toutes les conditions ont été vérifiées sur tous les états : le tableau est un morphisme.
        Avec $N=abs(Q_A)$, $N'=abs(Q_(A'))$ et $k=abs(Σ)=2$, le parcours coûte $O(k N)$, et la lecture des deux automates $O(k(N+N'))$ ; espace auxiliaire $O(N)$.
        Sans accessibilité de $A$, ce parcours ne vérifierait pas ses états inaccessibles, comme le montre $A_3$.
      ],
    ),
    [
      On définit le produit $A×A'$ d'états $Q_A×Q_(A')$, initial $(i_A,i_(A'))$, finaux $F_A×F_(A')$, avec
      $ δ_(A×A')((q,q'),x)=(δ_A(q,x),δ_(A')(q',x)). $
    ],
    question(
      [
        Si $A×A'$ est accessible et $cal(L)(A)=cal(L)(A')$, montrer qu'il existe un morphisme $A×A'→A$, et de même vers $A'$.
      ],
      solution: [
        Prendre la première projection $(q,q')↦q$. Elle conserve l'état initial et les transitions.
        Comme $(q,q')$ est accessible, il existe un mot $u$ atteignant ce couple. L'égalité des langages donne $q∈F_A⇔q'∈F_(A')$.
        Ainsi $(q,q')∈F_A×F_(A')⇔q∈F_A$, ce qui prouve la propriété finale.
        La seconde projection se traite de même. L'argument s'applique également à la partie accessible du produit si le produit entier n'est pas accessible.
      ],
    ),
    [
      Soit $B=(Q_B,i_B,δ_B,F_B)$ accessible, muni de morphismes $f:B→A$ et $g:B→A'$.
      On cherche $C$ et des morphismes $f':A→C$, $g':A'→C$.
      Définissons sur $Q_B$ la relation d'équivalence
      $ p≡q ⟺ ∃q_0,…,q_k, q_0=p, q_k=q, $
      où, pour chaque $0≤i<k$, $f(q_i)=f(q_(i+1))$ ou $g(q_i)=g(q_(i+1))$.
      Les suites de longueur nulle, leur renversement et leur concaténation montrent respectivement réflexivité, symétrie et transitivité.
    ],
    question(
      [
        Montrer que $p≡q$ implique $δ_B(p,x)≡δ_B(q,x)$ pour toute lettre $x$.
      ],
      solution: [
        Pour deux états consécutifs reliés par $f$, on a
        $ f(δ_B(q_i,x))=δ_A(f(q_i),x)=δ_A(f(q_(i+1)),x)=f(δ_B(q_(i+1),x)). $
        Si la liaison utilise $g$, le même calcul s'applique dans $A'$.
        L'image de la chaîne par $δ_B( · ,x)$ est donc une chaîne admissible, ce qui prouve le résultat.
      ],
    ),
    question(
      [
        Montrer que $p≡q$ implique $p∈F_B⇔q∈F_B$.
      ],
      solution: [
        Chaque liaison par égalité des images de $f$ conserve le caractère final par la propriété (iii) de $f$ ; il en va de même pour $g$. La propriété se transmet le long de toute la chaîne.
      ],
    ),
    [
      On note $[q]$ la classe de $q$ modulo $≡$ et $Q_C$ l'ensemble de ces classes.
    ],
    question(
      [
        Décrire un algorithme calculant $Q_C$, avec ses structures de données et sa complexité.
      ],
      solution: [
        Utiliser une structure unir et trouver sur $Q_B$.
        Deux tableaux, indexés par $Q_A$ et $Q_(A')$, mémorisent un premier représentant rencontré de chaque fibre de $f$ et de $g$.
        Pour chaque $q∈Q_B$, unir $q$ au représentant de sa fibre pour $f$, puis à celui de sa fibre pour $g$, lorsqu'ils existent ; sinon initialiser ces représentants.
        Les unions engendrent exactement les chaînes définissant $≡$ : les ensembles obtenus sont donc les classes cherchées.
        Posons $N=abs(Q_B)$. Les surjectivités de la question 4 donnent $abs(Q_A),abs(Q_(A'))≤N$.
        Il y a $O(N)$ opérations. Avec des arbres unis par taille sans compression, chaque profondeur est au plus $log_2 N$ : chaque augmentation de profondeur double la taille de la composante.
        D'où $O(N log(N+1))$ en temps et $O(N)$ en espace, collecte des classes comprise.
      ],
    ),
    question(
      [
        Définir un automate $C$ d'états $Q_C$ tel que $h:q↦[q]$ soit un morphisme $B→C$.
      ],
      solution: [
        Prendre l'initial $[i_B]$, la transition $δ_C([q],x)=[δ_B(q,x)]$ et les finaux $F_C={[q] | q∈F_B}$.
        La question 7 rend la transition indépendante du représentant ; la question 8 garantit $[q]∈F_C⇔q∈F_B$.
        Les trois propriétés de morphisme sont alors immédiates. Tout état $[q]$ est accessible en lisant un mot atteignant $q$ dans $B$.
      ],
    ),
    question(
      [
        Définir $f':A→C$ et $g':A'→C$ tels que $f'∘f=h=g'∘g$.
      ],
      solution: [
        Les morphismes $f$ et $g$ sont surjectifs puisque leurs buts sont accessibles.
        Pour $a∈Q_A$, choisir $q$ avec $f(q)=a$ et poser $f'(a)=[q]$.
        Deux tels choix ont la même image par $f$, donc sont équivalents : $f'$ est bien définie. Définir $g'$ de même.
        On a $f'(i_A)=[i_B]$ et, si $a=f(q)$,
        $ f'(δ_A(a,x))=f'(f(δ_B(q,x)))=[δ_B(q,x)]=δ_C(f'(a),x). $
        Enfin $a∈F_A⇔q∈F_B⇔[q]∈F_C$. C'est donc un morphisme ; la preuve pour $g'$ est identique.
        Leurs définitions donnent les deux compositions demandées.
      ],
    ),
    [
      Soit $L$ un langage régulier et $n$ le plus petit nombre d'états d'un ADC reconnaissant $L$.
    ],
    question(
      [
        Montrer que deux automates à $n$ états reconnaissant $L$ sont isomorphes, c'est-à-dire reliés par un morphisme bijectif.
      ],
      solution: [
        Soient $A,A'$ ces automates. Ils sont accessibles, car supprimer les états inaccessibles conserve déterminisme, complétude et langage et contredirait sinon la minimalité de $n$.
        Prendre pour $B$ la partie accessible de leur produit. Par le raisonnement de la question 6, ses projections sur $A$ et $A'$ sont des morphismes.
        Les questions 7 à 11 donnent un automate $C$ et des morphismes surjectifs $f':A→C$, $g':A'→C$.
        Il reconnaît encore $L$ par la question 3. Par minimalité, $abs(Q_C)≥n$, tandis que la surjectivité donne $abs(Q_C)≤n$.
        Ainsi $f'$ et $g'$ sont bijectifs. L'inverse d'un morphisme bijectif conserve l'initial, les transitions et les finaux, en appliquant l'inverse aux identités définissant un morphisme.
        Donc $(g')^(-1)∘f'$ est l'isomorphisme recherché.
      ],
    ),
  ),
)
