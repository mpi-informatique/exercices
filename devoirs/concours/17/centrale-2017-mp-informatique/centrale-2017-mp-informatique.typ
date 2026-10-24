#import "/load.typ": est-corrige
#import "/load.typ": exercice, feuille, partie, question
#import "/load.typ": sep, widetilde
#import "/load.typ": code
#import code: code-extrait
#import "/load.typ": automate
#import automate: dessiner-automate, rayon-etat, rayon-grand-etat

#let code = code-extrait.with(read("corrige.ml"))
#let m0 = dessiner-automate(
  (("0", (0, 2), false, false), ("1", (4, 2), false, false), ("2", (2, -1), false, false)),
  (
    ("0", "1", "0,1", (curve: 0.3)),
    ("1", "0", "0", (curve: 0.3)),
    ("1", "2", "1", (curve: 0)),
    ("2", "0", "0", (curve: 0)),
    ("2", "2", "1", (anchor: right)),
  ),
)
#let m1 = dessiner-automate(
  (("1", (0, 0), false, false), ("2", (3, 0), false, false)),
  (("1", "2", "a", (curve: 0.3)), ("2", "1", "a", (curve: 0.3))),
)
#let m2 = dessiner-automate(
  (
    ("1", (0, 3), false, false),
    ("2", (5, 3), false, false),
    ("3", (5, -2), false, false),
    ("4", (0, -2), false, false),
  ),
  (
    ("1", "1", "b", (anchor: left)),
    ("2", "2", "a,c", (anchor: right)),
    ("3", "3", "a", (anchor: right)),
    ("4", "4", "b,d", (anchor: left)),
    ("1", "2", "a", (curve: 0.25)),
    ("2", "1", "b,d", (curve: 0.25)),
    ("1", "3", "d", (curve: 0.25)),
    ("3", "1", "c", (curve: 0.25)),
    ("1", "4", "c", (curve: 0)),
    ("4", "3", "a,c", (curve: 0.25)),
    ("3", "4", "b", (curve: 0.25)),
    ("3", "2", "d", (curve: 0)),
  ),
)
#let g0 = dessiner-automate(
  (
    ("0", (0, 3), false, false),
    ("1", (4, 3), false, false),
    ("2", (4, 0), false, false),
    ("3", (0, 0), false, false),
    ("4", (7, 0), false, false),
    ("5", (10, 0), false, false),
  ),
  (
    ("0", "0", "b", (anchor: top)),
    ("1", "1", "a", (anchor: top)),
    ("0", "1", "a", (curve: 0)),
    ("0", "2", "b", (curve: 0)),
    ("0", "3", "a", (curve: 0)),
    ("3", "2", "a", (curve: 0.25)),
    ("2", "3", "b", (curve: 0.25)),
    ("1", "2", "a", (curve: 0.25)),
    ("2", "1", "b", (curve: 0.25)),
    ("4", "1", "a", (curve: 0)),
    ("5", "1", "a", (curve: -0.5)),
    ("2", "4", "b", (curve: 0)),
    ("4", "5", "b", (curve: 0)),
  ),
)
#let parties-m0 = dessiner-automate(
  (
    ("{0,1,2}", (0, 0), true, false),
    ("{0,1}", (3, 2), false, false),
    ("{1,2}", (3, -2), false, false),
    ("{0}", (7, 2), false, true),
    ("{1}", (10, 0), false, true),
    ("{2}", (7, -2), false, true),
  ),
  (
    ("{0,1,2}", "{0,1}", "0", (curve: 0)),
    ("{0,1,2}", "{1,2}", "1", (curve: 0)),
    ("{0,1}", "{0,1}", "0", (anchor: top)),
    ("{0,1}", "{1,2}", "1", (curve: 0)),
    ("{1,2}", "{0}", "0", (curve: 0)),
    ("{1,2}", "{2}", "1", (curve: 0)),
    ("{0}", "{1}", "0,1", (curve: 0.25)),
    ("{1}", "{0}", "0", (curve: 0.25)),
    ("{1}", "{2}", "1", (curve: 0)),
    ("{2}", "{0}", "0", (curve: 0.5)),
    ("{2}", "{2}", "1", (anchor: bottom)),
  ),
  rayon: nom => if nom.contains(",") { rayon-grand-etat } else { rayon-etat },
)
#let sat = {
  let etats = ()
  let arcs = ()
  let labels = (("0", "1", "0", "0,1"), ("1", "0,1", "0,1", "1"), ("0,1", "0", "1", "0"))
  for i in range(1, 4) {
    for j in range(1, 6) {
      let nom = "q_(" + str(i) + "," + str(j) + ")"
      etats.push((nom, ((j - 1) * 3, (1 - i) * 2.5), false, false))
      if j < 5 {
        arcs.push((nom, "q_(" + str(i) + "," + str(j + 1) + ")", labels.at(i - 1).at(j - 1), (curve: 0)))
      }
    }
  }
  dessiner-automate(etats, arcs, rayon: nom => rayon-grand-etat)
}

#let ex = exercice(
  meta: (
    titre: "Mots synchronisants",
    chapitres: ("automates-finis", "langages-reguliers", "graphes", "structures", "logique"),
    algorithmes: ("parcours-en-largeur", "determinisation"),
    structures: ("file", "tableau", "graphe"),
    langages: ("OCaml",),
    difficulte: 4,
    niveaux: ("MPI",),
    duree: (4, 0),
    concours: (nom: "Centrale", annee: 2017, filiere: "MP", oral: false),
  ),
  jury: [
    - Lire les hypothèses et les représentations avant de répondre.
    - Respecter la syntaxe OCaml, les filtrages et le déréférencement. Éviter les références inutiles.
    - Réutiliser les fonctions précédentes, limiter les auxiliaires, commenter et indenter le code. Numéroter les réponses et conserver les notations.
    - Justifier les réponses, sauf dispense explicite, et les complexités. Pour une récurrence, préciser la propriété et le paramètre.
    - Pratiquer sur machine pour maîtriser le langage.
  ],
  // corrections: [
  //   - Partie II : ajouter le mot-clé `let` à la définition de `v0`, noter $A_0$ l'ensemble des arcs et $D[s_r]-D[s_1]$ dans l'invariant de la question 17.
  //   - Partie IV : préciser les deux arguments de $widetilde(δ)(E,x)$.
  // ],
  contenu: (
    [== Notations
      - On appelle *machine* tout triplet $(Q,Σ,δ)$ où $Q$ est un ensemble fini non vide dont les éléments sont appelés *états*, $Σ$ un ensemble fini non vide appelé *alphabet* dont les éléments sont appelés *lettres*, et $δ$ une application de $Q × Σ$ dans $Q$ appelée *fonction de transition*. Une machine correspond donc à un automate déterministe complet sans notion d'état initial ou d'états finaux.
      - Pour un état $q$ et une lettre $x$, on note $q.x=δ(q,x)$.
      - L'ensemble des mots (c'est-à-dire des concaténations de lettres) sur l'alphabet $Σ$ est noté $Σ^*$.
      - Le mot vide est noté $ε$.
      - On note $u x$ le mot obtenu par la concaténation du mot $u$ et de la lettre $x$.
      - On note $δ^*$ l'extension à $Q × Σ^*$ de la fonction de transition $δ$ définie par
        $
          cases(
            ∀q ∈ Q\, #sep δ^*(q,ε)=q,
            ∀(q,x,u) ∈ Q × Σ × Σ^*\, #sep δ^*(q,x u)=δ^*(δ(q,x),u)
          ).
        $
      - Pour un état $q$ de $Q$ et un mot $m$ de $Σ^*$, on note encore $q.m$ pour désigner $δ^*(q,m)$.
      - Pour deux états $q$ et $q'$, on dit que $q'$ est *accessible* depuis $q$ s'il existe un mot $u$ tel que $q'=q.u$.
      - On dit qu'un mot $m$ de $Σ^*$ est *synchronisant* pour une machine $(Q,Σ,δ)$ s'il existe un état $q_0$ de $Q$ tel que pour tout état $q$ de $Q$, $q.m=q_0$.

      L'existence de tels mots dans certaines machines est utile car elle permet de ramener une machine dans un état particulier connu en lisant un mot donné (donc en pratique de la « réinitialiser » par une succession précise d'ordres passés à la machine réelle).

      La partie I étudie quelques considérations générales sur les mots synchronisants, la partie II est consacrée à des problèmes algorithmiques classiques, la partie III relie le problème de la satisfiabilité d'une formule logique à celui de la recherche d'un mot synchronisant de taille donnée dans une certaine machine, et la partie IV étudie l'existence d'un mot synchronisant pour une machine donnée. Les parties I, II et III peuvent être traitées indépendamment. La partie IV, plus technique, utilise la partie II.

      Dans les exemples concrets de machines donnés plus loin, l'ensemble d'états peut être quelconque, de même que l'alphabet $(Σ={0,1},{a,b,c},…)$. Pour la modélisation en OCaml, l'alphabet $Σ$ sera toujours considéré comme étant un intervalle d'entiers $⟦0,p-1⟧$ où $p=abs(Σ)$. Une lettre correspondra donc à un entier entre $0$ et $p-1$. Un mot de $Σ^*$ sera représenté par une liste de lettres (donc d'entiers).
      ```ocaml
      type lettre = int
      type mot = lettre list
      ```
      De même, en OCaml, l'ensemble d'états $Q$ d'une machine sera toujours considéré comme étant l'intervalle d'entiers $⟦0,n-1⟧$ où $n=abs(Q)$.
      ```ocaml
      type etat = int
      ```
      Ainsi, la fonction de transition $δ$ d'une machine sera modélisée par une fonction OCaml de signature ```ocaml etat -> lettre -> etat```. On introduit alors le type :
      ```ocaml
      type machine = {
        n_etats : int;
        n_lettres : int;
        delta : etat -> lettre -> etat
      }
      ```
      ```ocaml n_etats``` correspond au cardinal de $Q$, ```ocaml n_lettres``` à celui de $Σ$ et ```ocaml delta``` à la fonction de transition. Dans tout le problème, on supposera que ```ocaml m.delta``` s'exécute en temps constant.

      Par exemple, on peut créer une machine ```ocaml m0``` à trois états sur un alphabet à deux lettres ayant comme fonction de transition la fonction ```ocaml f0``` donnée ci-après :
      ```ocaml
      let f0 etat lettre =
        let matrice = [|
          [|1; 1|];
          [|0; 2|];
          [|0; 2|]
        |] in
        matrice.(etat).(lettre)

      let m0 = { n_etats = 3; n_lettres = 2; delta = f0 }
      ```
      La figure 1 fournit une représentation de la machine $M_0$.
      #m0
      #align(center)[Figure 1 : la machine $M_0$.]
      On pourra observer que les mots $11$ et $10$ sont tous les deux synchronisants pour la machine $M_0$.

      Dans tout le sujet, si une question demande la complexité d'un programme ou d'un algorithme, on attend une complexité temporelle exprimée en $O(…)$.],
    partie(
      "I",
      "Considérations générales",
      jury: [Respecter les types : un mot est une liste, et ```ocaml n_etats``` un entier non mutable. Vérifier les bornes des tableaux.],
      contenu: (
        question(
          [Que dire des mots synchronisants pour une machine ayant un seul état ?],
          solution: [Tout mot, y compris $ε$, est synchronisant : sa lecture depuis l'unique état mène à cet état.],
        ),
        [Dans toute la suite du problème, on supposera que les machines ont au moins deux états.],
        question(
          [On considère la machine $M_1$ représentée figure 2. Donner un mot synchronisant pour $M_1$ s'il en existe un. Justifier la réponse.
            #m1
            #align(center)[Figure 2 : la machine $M_1$.]],
          solution: [Il n'en existe pas. Un mot $a^(2k)$ laisse chaque état inchangé, tandis qu'un mot $a^(2k+1)$ échange les deux états. Les images des deux états restent donc distinctes.],
        ),
        question(
          [On considère la machine $M_2$ représentée figure 3. Donner un mot synchronisant de trois lettres pour $M_2$. On ne demande pas de justifier la réponse.
            #m2
            #align(center)[Figure 3 : la machine $M_2$.]],
          solution: [Le mot $a c a$ convient : $Q.a={2,3}$, $Q.(a c)={1,2}$ et $Q.(a c a)={2}$.],
        ),
        question(
          [Écrire une fonction ```ocaml delta_etoile``` qui, prenant en entrée une machine $M$, un état $q$ et un mot $u$, renvoie l'état atteint par la machine $M$ en partant de l'état $q$ et en lisant le mot $u$.
            ```ocaml
            val delta_etoile : machine -> etat -> mot -> etat
            ```],
          solution: [#code("delta_etoile")],
        ),
        question(
          [Écrire une fonction ```ocaml est_synchronisant``` qui, prenant en entrée une machine $M$ et un mot $u$, dit si le mot est synchronisant pour $M$.
            ```ocaml
            val est_synchronisant : machine -> mot -> bool
            ```],
          jury: [Lors du test, s'arrêter dès qu'un état aboutit à une image différente de celle du premier état, et éviter de recalculer cette première image.],
          solution: [#code("est_synchronisant")],
        ),
        question(
          [Montrer que pour qu'une machine ait un mot synchronisant, il faut qu'il existe une lettre $x$ et deux états distincts de $Q$, $q$ et $q'$, tels que $q.x=q'.x$.],
          solution: [Soient $r ≠ r'$ et $u=x_1…x_k$ un mot synchronisant. Il existe un premier indice $j ≥ 1$ auquel les images de $r$ et $r'$ par le préfixe de taille $j$ coïncident. Juste avant cette lettre, les états $q=r.(x_1…x_(j-1))$ et $q'=r'.(x_1…x_(j-1))$ sont distincts, et $q.x_j=q'.x_j$.],
        ),
        [Soit $L S(M)$ le langage des mots synchronisants d'une machine $M=(Q,Σ,δ)$. On introduit la machine des parties $hat(M)=(hat(Q),Σ,hat(δ))$ où $hat(Q)$ est l'ensemble des parties de $Q$ et où $hat(δ)$ est définie par
          $ ∀P ⊂ Q, #sep ∀x ∈ Σ, #sep hat(δ)(P,x)={δ(p,x) | p ∈ P}. $],
        question(
          [Justifier que l'existence d'un mot synchronisant pour $M$ se ramène à un problème d'accessibilité de certain(s) état(s) depuis certain(s) état(s) dans la machine des parties.],
          solution: [Une récurrence sur la taille de $u$ donne $hat(δ)^*(P,u)={δ^*(q,u) | q ∈ P}$. Ainsi $u$ est synchronisant si et seulement si $hat(δ)^*(Q,u)$ est un singleton. Il suffit donc de chercher si un singleton est accessible depuis l'état $Q$.],
        ),
        question(
          [En déduire que le langage $L S(M)$ des mots synchronisants de la machine $M$ est reconnaissable.],
          solution: [Prendre la machine des parties comme automate déterministe, avec $Q$ pour état initial et les singletons pour états finaux. Il est fini et reconnaît exactement $L S(M)$.],
        ),
        question(
          [Déterminer la machine des parties associée à la machine $M_0$, puis donner une expression régulière du langage $L S(M_0)$.],
          jury: [Donner un automate déterministe et une expression régulière concise.],
          solution: [Voici les états accessibles depuis $Q={0,1,2}$, avec les singletons marqués comme états finaux :
            #parties-m0
            Pour compléter la machine des parties, ajouter les états inaccessibles $∅$ et ${0,2}$ : $∅$ boucle sur $0$ et $1$, tandis que ${0,2}$ mène à ${0,1}$ par $0$ et à ${1,2}$ par $1$.
            On atteint ${1,2}$ après $0^*1$, puis un singleton après une lettre supplémentaire. Les singletons restent des singletons pour toute continuation. Ainsi
            $ L S(M_0)=0^*1(0 | 1)^+. $],
        ),
        question(
          [Montrer que si l'on sait résoudre le problème de l'existence d'un mot synchronisant, on sait dire, pour une machine $M$ et un état $q_0$ de $M$ choisi, s'il existe un mot $u$ tel que pour tout état $q$ de $Q$, le chemin menant de $q$ à $q.u$ passe forcément par $q_0$.],
          solution: [Construire $M'=(Q,Σ,η)$ en rendant $q_0$ absorbant : $η(q_0,x)=q_0$ et $η(q,x)=δ(q,x)$ pour $q ≠ q_0$.
            La lecture de $u$ depuis $q$ dans $M'$ aboutit à $q_0$ si et seulement si le chemin correspondant dans $M$ passe par $q_0$, éventuellement dès le départ.

            Si $M'$ possède un mot synchronisant, il synchronise nécessairement sur $q_0$, puisque $q_0$ est absorbant : ce mot convient dans $M$.
            Réciproquement, un mot faisant passer tous les chemins par $q_0$ dans $M$ synchronise $M'$ sur $q_0$.
            Il suffit donc de tester l'existence d'un mot synchronisant pour $M'$.],
        ),
      ),
    ),
    partie(
      "II",
      "Algorithmes classiques",
      jury: [Respecter les enregistrements et distinguer listes et tableaux. Les opérations doivent être cohérentes : implémenter une file FIFO, pas une pile.],
      contenu: (
        [On appellera *graphe d'automate* tout couple $(S,A)$ où $S$ est un ensemble dont les éléments sont appelés *sommets* et $A$ une partie de $S × Σ × S$ dont les éléments sont appelés *arcs*. Pour un arc $(q,x,q')$, $x$ est l'*étiquette* de l'arc, $q$ son *origine* et $q'$ son *extrémité*. Un graphe d'automate correspond donc à un automate non déterministe sans notion d'état initial ou final.

          Soient $s$ et $s'$ deux sommets d'un graphe $(S,A)$. On appelle chemin de $s$ vers $s'$ de taille $ℓ$ toute suite d'arcs $(s_1,x_1,s_1'),…,(s_ℓ,x_ℓ,s_ℓ')$ de $A$ telle que $s_1=s$, $s_ℓ'=s'$ et, pour tout $i ∈ ⟦1,ℓ-1⟧$, $s_i'=s_(i+1)$. L'étiquette de ce chemin est alors le mot $x_1…x_ℓ$ et on dit que $s'$ est accessible depuis $s$. En particulier, pour tout $s ∈ S$, $s$ est accessible depuis $s$ par le chemin vide d'étiquette $ε$.

          Par exemple, avec
          $ Σ={a,b}, #sep S_0={0,1,2,3,4,5}, $
          $
            A_0= { (0,b,0),(0,a,3),(0,b,2),(0,a,1),(1,a,1),(1,a,2),(2,b,1), \
              (2,b,3),(2,b,4),(3,a,2),(4,a,1),(4,b,5),(5,a,1) }.
          $
          le graphe d'automate $G_0=(S_0,A_0)$ est représenté en figure 4.
          #g0
          #align(center)[Figure 4 : le graphe d'automate $G_0$.]
          Dans les programmes à écrire, un graphe aura toujours pour ensemble de sommets un intervalle d'entiers $⟦0,n-1⟧$ et l'ensemble des arcs étiquetés par $Σ$ (supposé être un intervalle $⟦0,p-1⟧$) sera codé par un tableau de listes d'adjacence ```ocaml v``` : pour tout ```ocaml s``` $∈ S$, ```ocaml v.(s)``` est la liste (dans n'importe quel ordre) de tous les couples $(s',x)$ tels que $(s,x,s')$ soit un arc du graphe. Pour des raisons de compatibilité ultérieure, les sommets seront codés par le type ```ocaml etat```.

          Avec l'alphabet $Σ={a,b}$, la lettre $a$ est codée $0$ et la lettre $b$ est codée $1$. L'ensemble des arcs de $G_0$, dont chaque sommet est codé par son numéro, admet pour représentation OCaml :
          ```ocaml
          let v0 : (etat * lettre) list array = [|
            [(0,1);(3,0);(2,1);(1,0)];
            [(1,0);(2,0)];
            [(1,1);(3,1);(4,1)];
            [(2,0)];
            [(1,0);(5,1)];
            [(1,0)]
          |]
          ```
          On veut implémenter une file d'attente à l'aide d'un tableau circulaire, dans lequel les indices sont considérés modulo la longueur du tableau. On définit pour cela un type :
          ```ocaml
          type 'a file = {
            tab : 'a array;
            mutable deb : int;
            mutable fin : int;
            mutable vide : bool
          }
          ```
          - ```ocaml deb``` indique l'indice du premier (plus ancien) élément de la file.
          - ```ocaml fin``` indique l'indice *suivant* (modulo la longueur du tableau) celui du dernier (plus récent) élément de la file.
          - Il est tout à fait possible d'avoir ```ocaml deb > fin```.
        ],
        question(
          [Expliquer pourquoi le champ ```ocaml vide``` est nécessaire.],
          solution: [Lorsque ```ocaml deb = fin```, la file peut être vide ou pleine : ces indices seuls ne permettent pas de distinguer les deux situations. Le champ ```ocaml vide``` lève cette ambiguïté.],
        ),
        question(
          [Écrire une fonction ```ocaml ajoute``` telle que ```ocaml ajoute f x``` ajoute ```ocaml x``` à la fin de la file d'attente ```ocaml f```. Si c'est impossible, la fonction lèvera une exception.
            ```ocaml
            val ajoute : 'a file -> 'a -> unit
            ```],
          solution: [#code("ajoute")],
        ),
        question(
          [Écrire une fonction ```ocaml retire``` telle que ```ocaml retire f``` retire l'élément en tête de la file d'attente et le renvoie. Si c'est impossible, la fonction lèvera une exception.
            ```ocaml
            val retire : 'a file -> 'a
            ```],
          solution: [#code("retire")],
        ),
        question(
          [Quelle est la complexité de ces fonctions ?],
          jury: [```ocaml Array.length``` coûte $O(1)$, contrairement à la longueur d'une liste.],
          solution: [Les deux fonctions effectuent un nombre constant d'accès au tableau, de tests et d'opérations arithmétiques : leur complexité est $O(1)$.],
        ),
        [On considère l'algorithme 1 suivant s'appliquant à un graphe d'automate $G=(S,A)$ et à un ensemble de sommets $X$ (on note $n=abs(S)$ et $∞$, « vide » et « rien » des valeurs particulières).
          #block(inset: 8pt, stroke: 0.4pt)[
            Algorithme 1
            ```text
            F ← file vide
            D ← (∞, …, ∞) (tableau de longueur n)
            P ← (vide, …, vide) (tableau de longueur n)
            c ← n
            Pour s ∈ X :
              Ajouter s à F
              D[s] ← 0
              P[s] ← rien
              c ← c - 1
            Tant que F n'est pas vide :
              s ← Retirer de F
              Pour (s, y, s') un arc de A tel que D[s'] = ∞ :
                D[s'] ← D[s] + 1
                P[s'] ← (s, y)
                Ajouter s' à F
                c ← c - 1
            Renvoyer (c, D, P)
            ```
          ]],
        question(
          [Justifier que l'algorithme 1 termine toujours.],
          jury: [Identifier un parcours en largeur ne remplace pas sa justification.],
          solution: [Un sommet est ajouté à la file seulement quand sa distance vaut $∞$, puis sa distance devient finie et ne change plus. Chaque sommet est donc ajouté au plus une fois. Chaque tour retire un sommet de la file : il y a au plus $abs(S)$ tours.],
        ),
        question(
          [Donner la complexité de cet algorithme en fonction de $abs(S)$ et $abs(A)$. Justifier la réponse.],
          solution: [L'initialisation coûte $O(abs(S))$ et la première boucle $O(abs(X))$, avec $abs(X) ≤ abs(S)$. Chaque sommet est retiré au plus une fois, et sa liste d'arcs sortants est parcourue une fois. Chaque arc traité demande un temps constant. La complexité totale est $O(abs(S)+abs(A))$.],
        ),
        question(
          [Justifier qu'au début de chaque passage dans la boucle « tant que $F$ n'est pas vide », si $F$ contient dans l'ordre les sommets $s_1,s_2,…,s_r$, alors $D[s_1] ≤ D[s_2] ≤ … ≤ D[s_r]$ et $D[s_r]-D[s_1] ≤ 1$.],
          solution: [Au départ, tous les sommets en file ont distance $0$.
            Supposons la propriété vraie et posons $d=D[s_1]$. Après avoir retiré $s_1$, les sommets restants ont des distances croissantes, comprises entre $d$ et $d+1$. Les nouveaux sommets sont ajoutés en fin de file avec distance $d+1$ : l'ordre et l'écart maximal sont conservés.
            Si aucun sommet ne restait, les nouveaux sommets ont tous la même distance. Si la file devient vide, aucune propriété n'est à vérifier à l'itération suivante.],
        ),
        [Pour $s$ sommet de $G$, on note $d_s$ la distance de $X$ à $s$, c'est-à-dire la longueur d'un plus court chemin d'un sommet de $X$ à $s$ (avec la convention $d_s=∞$ s'il n'existe pas de tel chemin).],
        question(
          [Justifier brièvement qu'à la fin de l'algorithme, pour tout sommet $s$, $D[s] ≠ ∞$ si et seulement si $s$ est accessible depuis un sommet de $X$ et que $d_s ≤ D[s]$. Que désigne alors $c$ ?],
          solution: [À chaque attribution d'une distance finie, on connaît un chemin depuis $X$ de longueur $D[s]$ : c'est vrai pour les sources, puis chaque découverte prolonge un tel chemin d'un arc. Ainsi $s$ est accessible et $d_s ≤ D[s]$.

            Réciproquement, suivre un chemin $s_0,…,s_k$ avec $s_0 ∈ X$. Le sommet $s_0$ est découvert. Chaque sommet découvert est ensuite retiré de la file et tous ses successeurs sont découverts au plus tard à ce moment. Par récurrence, $s_k$ est découvert.
            Le compteur $c$, décrémenté une fois par sommet découvert, donne le nombre de sommets inaccessibles depuis $X$.],
        ),
        question(
          [Montrer qu'en fait, à la fin, on a pour tout sommet $s$, $D[s]=d_s$. Que vaut alors $P[s]$ ?],
          solution: [Les sommets sont retirés par distances $D$ croissantes, d'après la question 17. Montrons par récurrence sur $k$ que tous les sommets de distance réelle $k$ sont découverts avec $D=k$.
            Pour $k=0$, ce sont les sommets de $X$. Pour $k+1$, un plus court chemin vers $s$ possède un prédécesseur $t$ à distance $k$. Lorsque $t$ est retiré, soit $s$ est encore inconnu et reçoit $D[s]=k+1$, soit il a déjà été découvert depuis un sommet retiré plus tôt, dont la distance $D$ est au plus $k$. Alors $D[s] ≤ k+1$, tandis que la question 18 donne $D[s] ≥ d_s=k+1$.
            Les sommets inaccessibles gardent $D=∞$.

            Pour $s ∈ X$, $P[s]$ vaut « rien ». Pour $s$ inaccessible, il vaut « vide ». Sinon, $P[s]=(t,y)$ est le dernier arc d'un plus court chemin depuis $X$, avec $D[t]=D[s]-1$.],
        ),
        question(
          [Écrire une fonction ```ocaml accessibles``` prenant en entrée un graphe d'automate (sous forme de son tableau de listes d'adjacence ```ocaml v```) et un ensemble ```ocaml x``` de sommets (sous forme d'une liste d'états) et renvoyant le triplet $(c,D,P)$ calculé selon l'algorithme précédent. La constante $∞$ sera représentée par l'entier $-1$, et pour les couples (état, lettre) on utilisera le type suivant :
            ```ocaml
            type arc = Rien | Vide | Arc of etat * lettre

            val accessibles : ((etat * lettre) list) array -> etat list
                              -> int * int array * arc array
            ```],
          solution: [La liste représentant un ensemble ne contient pas de doublons. La file de capacité $n$ suffit, puisqu'un sommet est ajouté au plus une fois.
            #code("accessibles")],
        ),
        question(
          [Écrire une fonction ```ocaml chemin``` qui, prenant en entrée un sommet ```ocaml s``` et le tableau ```ocaml p``` calculé à l'aide de la fonction ```ocaml accessibles``` sur un graphe $G$ et un ensemble $X$, renvoie un mot de taille minimale qui est l'étiquette d'un chemin d'un sommet de $X$ à $s$ (ou lèvera une exception s'il n'en existe pas).
            ```ocaml
            val chemin : etat -> arc array -> mot
            ```],
          solution: [Remonter les prédécesseurs en ajoutant chaque lettre en tête de l'accumulateur remet les lettres dans l'ordre du chemin.
            #code("chemin")],
        ),
      ),
    ),
    partie(
      "III",
      "Réduction SAT",
      jury: [Rédiger des preuves précises, avec toutes les implications nécessaires.],
      contenu: (
        [On s'intéresse à la satisfiabilité d'une formule logique portant sur des variables propositionnelles $x_1,…,x_m$. On note $∧$ le connecteur logique « et », $∨$ le connecteur « ou » et $overline(f)$ la négation d'une formule $f$.
          On appelle *littéral* une formule constituée d'une variable $x_i$ ou de sa négation $overline(x_i)$, et *clause* une disjonction de littéraux.
          Une formule sous forme normale conjonctive est une conjonction de clauses. Par exemple,
          $ F_1=(x_1 ∨ overline(x_2) ∨ x_3) ∧ (overline(x_1) ∨ overline(x_4)) ∧ (x_2 ∨ overline(x_3) ∨ x_4) $
          est une formule formée de trois clauses et portant sur quatre variables propositionnelles $x_1,x_2,x_3,x_4$.

          Soit $F$ une formule sous forme normale conjonctive composée de $n$ clauses et faisant intervenir $m$ variables. On suppose les clauses numérotées $c_1,…,c_n$. On veut ramener le problème de sa satisfiabilité au problème de la recherche d'un mot synchronisant de taille inférieure ou égale à $m$ sur une certaine machine. On introduit la machine suivante associée à $F$ :
          - $Q$ est formé de $m n+n+1$ états : un état particulier $f$ et $n(m+1)$ autres états notés $q_(i,j)$, avec $(i,j) ∈ ⟦1,n⟧ × ⟦1,m+1⟧$.
          - $Σ={0,1}$
          - $δ$ est définie par :
            - $f$ est un état puits : $δ(f,0)=δ(f,1)=f$.
            - Pour tout $i ∈ ⟦1,n⟧$, $δ(q_(i,m+1),0)=δ(q_(i,m+1),1)=f$.
            - Pour tous $i ∈ ⟦1,n⟧$ et $j ∈ ⟦1,m⟧$,
              $
                δ(q_(i,j),1)=cases(
                  f & "si le littéral" x_j "apparaît dans" c_i,
                  q_(i,j+1) & "sinon"
                ),
              $
              $
                δ(q_(i,j),0)=cases(
                  f & "si le littéral" overline(x_j) "apparaît dans" c_i,
                  q_(i,j+1) & "sinon"
                ).
              $
        ],
        question(
          [Représenter la machine associée à la formule $F_1$.],
          solution: [Le dessin montre les transitions qui ne mènent pas à $f$.
            #sat
            Toute transition manquante mène à $f$ : depuis $q_(1,1)$ par $1$, $q_(1,2)$ par $0$, $q_(1,3)$ par $1$, $q_(2,1)$ par $0$, $q_(2,4)$ par $0$, $q_(3,2)$ par $1$, $q_(3,3)$ par $0$ et $q_(3,4)$ par $1$.
            Depuis chaque $q_(i,5)$, les deux lettres mènent à $f$ ; depuis $f$, elles bouclent sur $f$.],
        ),
        question(
          [Donner une distribution de vérité $(v_1,v_2,v_3,v_4) ∈ ⟦0,1⟧^4$ (la valeur $v_i$ étant associée à la variable $x_i$) satisfaisant $F_1$. Le mot $v_1 v_2 v_3 v_4$ est-il synchronisant ?],
          solution: [La distribution $(1,1,1,0)$ satisfait $F_1$ : les trois clauses sont satisfaites respectivement par $x_1$, $overline(x_4)$ et $x_2$. Le mot $1110$ est synchronisant : depuis $q_(1,1)$, $q_(2,1)$ et $q_(3,1)$ on atteint $f$ respectivement après une, quatre et deux lettres. Depuis tout $q_(i,j)$ avec $j ≥ 2$, quatre lettres suffisent également à atteindre $f$.],
        ),
        question(
          [Montrer que tout mot $u$ de taille $m+1$ est synchronisant. À quelle condition sur les $q_(i,1).u$ un mot de taille $m$ est-il synchronisant ?],
          solution: [Chaque transition qui n'atteint pas $f$ augmente le second indice de $1$. Depuis $q_(i,j)$, on atteint donc $f$ en au plus $m+2-j$ lettres, puis on y reste. Tout mot de taille $m+1$ synchronise sur $f$.
            Un mot de taille $m$ envoie déjà tous les états $q_(i,j)$ avec $j ≥ 2$ sur $f$, et laisse $f$ inchangé. Il est synchronisant si et seulement si $q_(i,1).u=f$ pour tout $i$.],
        ),
        question(
          [Montrer que si la formule $F$ est satisfiable, toute distribution de vérité la satisfaisant donne un mot synchronisant de taille $m$ pour l'automate.],
          solution: [Soit $u=u_1…u_m$ une valuation satisfaisante. Dans chaque clause $c_i$, prendre le plus petit indice $j$ d'un littéral satisfait par $u$. Depuis $q_(i,1)$, les $j-1$ premières lettres mènent à $q_(i,j)$, puis la lettre $u_j$ mène à $f$. Les lettres restantes laissent la machine en $f$. Ainsi tous les $q_(i,1).u$ valent $f$ : la question 24 permet de conclure.],
        ),
        question(
          [Inversement, prouver que si l'automate dispose d'un mot synchronisant de taille au plus $m$, $F$ est satisfiable. Donner alors une distribution de vérité convenable.],
          solution: [Soit $v=v_1…v_k$ synchronisant, avec $k ≤ m$. Puisque $f$ est absorbant, il synchronise nécessairement sur $f$.
            Depuis $q_(i,1)$, les $k$ lettres ne permettent pas d'atteindre $f$ par la transition finale de $q_(i,m+1)$, qui demanderait $m+1$ lettres. On atteint donc $f$ par un littéral de $c_i$ satisfait par l'une des valeurs $v_j$, avec $j ≤ k$.
            Compléter la distribution en posant $u_j=v_j$ pour $j ≤ k$ et $u_j=0$ pour $k < j ≤ m$. Chaque clause contient un littéral déjà satisfait par ce préfixe : $u$ satisfait $F$.],
        ),
      ),
    ),
    partie(
      "IV",
      "Existence",
      jury: [Respecter notamment la représentation par tableau de listes d'adjacence.],
      contenu: (
        [On reprend le problème de l'existence d'un mot synchronisant pour une machine $M=(Q,Σ,δ)$. Pour toute partie $E$ de $Q$ et tout mot $u$ de $Σ^*$, on note $E.u={q.u | q ∈ E}$.],
        question(
          [Soit $u$ un mot synchronisant de $M$ et $u_0,u_1,…,u_r$ une suite de préfixes de $u$ rangés dans l'ordre croissant de leur taille et telle que $u_r=u$. Que peut-on dire de la suite des cardinaux $abs(Q.u_i)$ ?],
          solution: [Pour tout ensemble $E$ et tout mot $v$, l'image $E.v$ a au plus $abs(E)$ éléments. Puisque $u_(i+1)=u_i v$ pour un certain suffixe $v$, la suite est décroissante au sens large. Ses valeurs sont au moins $1$ et sa dernière valeur est $1$.],
        ),
        question(
          [Montrer qu'il existe un mot synchronisant si et seulement s'il existe pour tout couple d'états $(q,q')$ de $Q^2$ un mot $u_(q,q')$ tel que $q.u_(q,q')=q'.u_(q,q')$.],
          solution: [Si $u$ est synchronisant, prendre $u_(q,q')=u$ pour tous les couples.

            Réciproquement, partir de $v=ε$. Tant que $Q.v$ contient deux états distincts $q,q'$, remplacer $v$ par $v u_(q,q')$. Deux éléments de $Q.v$ ont alors la même image : son cardinal diminue strictement. En au plus $abs(Q)-1$ étapes, il vaut $1$, donc le mot construit est synchronisant.],
        ),
        [On veut se servir du critère établi ci-dessus pour déterminer s'il existe un mot synchronisant. On associe à $M$ la machine $widetilde(M)=(widetilde(Q),Σ,widetilde(δ))$ définie par :
          - $widetilde(Q)$ est formé des parties à un ou deux éléments de $Q$.
          - $∀(E,x) ∈ widetilde(Q) × Σ$, $widetilde(δ)(E,x)={δ(q,x) | q ∈ E}$.
        ],
        question(
          [Si $n=abs(Q)$, que vaut $widetilde(n)=abs(widetilde(Q))$ ?],
          solution: [Il y a $n$ singletons et $binom(n, 2)$ paires : $widetilde(n)=n+binom(n, 2)=n(n+1)/2$.],
        ),
        [Pour la modélisation informatique, $widetilde(Q)$ doit être modélisé par l'intervalle $⟦0,widetilde(n)-1⟧$. Soit $φ_n$ une bijection de $widetilde(Q)$ sur cet intervalle. On définit un type pour représenter les parties à un ou deux éléments :
          ```ocaml
          type un_ou_deux = Un of int | Deux of int * int
          ```
          On suppose qu'on dispose d'une fonction ```ocaml set_to_nb``` de signature ```ocaml int -> un_ou_deux -> etat``` telle que ```ocaml set_to_nb n l``` renvoie :
          $
            cases(
              φ_n({i}) & "si" #raw("l = Un i", lang: "ocaml")", " 0 ≤ i ≤ n-1,
              φ_n({i,j}) & "si" #raw("l = Deux (i, j)", lang: "ocaml")", " 0 ≤ i < j ≤ n-1
            ).
          $
          On dispose aussi d'une fonction réciproque ```ocaml nb_to_set``` de type ```ocaml int -> etat -> un_ou_deux``` telle que ```ocaml nb_to_set n q```, pour $n ∈ ℕ^*$ et $q ∈ ⟦0,widetilde(n)-1⟧$, renvoie une valeur ```ocaml Un i``` ou ```ocaml Deux (i, j)``` (avec $i < j$) correspondant à $φ_n^(-1)(q)$. Ces deux fonctions sont supposées agir en temps constant.
          Pour ne pas confondre un état de $widetilde(Q)$ avec sa représentation informatique par un entier, on notera $overline(q)$ l'entier associé à l'état $q$.],
        question(
          [Écrire une fonction ```ocaml delta2``` de signature ```ocaml machine -> etat -> lettre -> etat``` qui, prenant en entrée une machine $M$, un état $overline(q)$ de $widetilde(Q)$ et une lettre $x$, renvoie l'état de $widetilde(Q)$ atteint en lisant la lettre $x$ depuis l'état $q$ dans $widetilde(M)$.],
          solution: [Un singleton reste un singleton. Les images d'une paire peuvent coïncider : sinon, les ranger par ordre croissant pour respecter le contrat de ```ocaml set_to_nb```.
            #code("delta2")],
        ),
        question(
          [À la machine $widetilde(M)$, on associe un graphe d'automate $widetilde(G)$ dont l'ensemble des sommets est $widetilde(Q)$ et dont l'ensemble des arcs est ${ (q,x,widetilde(δ)(q,x)) | (q,x) ∈ widetilde(Q) × Σ }$. On associe à $widetilde(G)$ le graphe retourné $widetilde(G)_R$ qui a les mêmes sommets mais dont les arcs sont retournés : $(q,x,q')$ est un arc de $widetilde(G)_R$ si et seulement si $(q',x,q)$ est un arc de $widetilde(G)$.
            Écrire une fonction ```ocaml retourne_machine``` de signature ```ocaml machine -> (etat * lettre) list array``` qui, à partir d'une machine $M$, calcule le tableau ```ocaml v``` des listes d'adjacence du graphe $widetilde(G)_R$.],
          solution: [Pour chaque arc $q → q'$ étiqueté par $x$, ajouter $(q,x)$ à la liste d'adjacence de $q'$.
            #code("retourne_machine")],
        ),
        question(
          [Justifier qu'il suffit d'appliquer la fonction ```ocaml accessibles``` de la partie II au graphe $widetilde(G)_R$ et à l'ensemble des sommets correspondant à des singletons pour déterminer si la machine $M$ possède un mot synchronisant.],
          solution: [D'après la question 28, il suffit que toute paire ${q,q'}$ puisse atteindre un singleton dans $widetilde(G)$. En retournant les arcs, cela équivaut à ce que toute paire soit accessible depuis au moins un singleton dans $widetilde(G)_R$.
            Les singletons sont eux-mêmes dans l'ensemble de départ. Ainsi la condition est satisfaite si et seulement si le parcours atteint tous les sommets, c'est-à-dire si le compteur $c$ renvoyé vaut $0$.],
        ),
        question(
          [Écrire une fonction ```ocaml existe_synchronisant``` de signature ```ocaml machine -> bool``` qui dit si une machine possède un mot synchronisant.],
          solution: [#code(("singletons", "existe_synchronisant"))],
        ),
      ),
    ),
  ),
)

#let sujet = (titre: ex.meta.titre, exercices: (ex,), bareme: none)
#show: feuille.with(
  type: "concours",
  titre: sujet.titre,
  niveau: ex.meta.niveaux.join(" / "),
  concours: ex.meta.concours,
  exercices: sujet.exercices,
  bareme: sujet.bareme,
  corrige: est-corrige(),
  espacement: if est-corrige() { 12pt } else { 10.6pt },
)
