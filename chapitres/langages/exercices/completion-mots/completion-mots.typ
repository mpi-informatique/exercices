#import "/load.typ": exercice, partie, question, feuille, est-corrige, code, sep
#import code: code-extrait
#import "@preview/cetz:0.4.2" as cetz
#import "/devoirs/concours/oral/ens/ens-oral-mp-langages-continuables-primitifs.typ": question-primitifs

#let extrait(noms) = code-extrait(read("corrige.ml"), noms)

#let dictionnaires = partie("I", "Compléter dans un dictionnaire", contenu: (
  [
    Soit $Σ$ un alphabet fini non vide, totalement ordonné. Pour tout langage $L ⊂ Σ^*$ et tout mot $u$, le _résiduel_ de $L$ par $u$ est
    $ u^(-1)L = {v ∈ Σ^* ∣ u v ∈ L}. $
    Un mot $v ∈ u^(-1)L$ est une _complétion_ de $u$ dans $L$. La complétion vide est autorisée.
    Un préfixe est _complétable_ si son résiduel est non vide.
    Parmi les complétions de taille minimale, on souhaite choisir la première dans l'ordre lexicographique.
  ],
  question(
    [
      Sur $Σ = {a, b, c}$, prendre $D = {a b, a c, b b, b c}$.
      Déterminer $u^(-1)D$ pour $u = ε, a, b, a b, c$ et donner, lorsqu'elle existe, la complétion choisie.
    ],
    solution: [
      Les résiduels sont respectivement $D$, ${b, c}$, ${b, c}$, ${ε}$ et $∅$.
      Les complétions choisies sont $a b$, $b$, $b$, $ε$, puis aucune.
      Deux préfixes distincts peuvent donc avoir les mêmes continuations possibles.
    ],
    bareme: 0.5,
  ),
  question(
    [
      Établir les identités $ε^(-1)L = L$ et $(u a)^(-1)L = a^(-1)(u^(-1)L)$ pour $a ∈ Σ$.
      Exprimer $u ∈ L$ à l'aide de $u^(-1)L$.
      Montrer enfin qu'un préfixe non complétable ne peut plus le devenir en lui ajoutant des lettres.
    ],
    solution: [
      Par définition, $ε^(-1)L = L$ et
      $ v ∈ (u a)^(-1)L ⟺ u a v ∈ L ⟺ a v ∈ u^(-1)L ⟺ v ∈ a^(-1)(u^(-1)L). $
      De plus, $u ∈ L ⟺ ε ∈ u^(-1)L$.
      Si $u^(-1)L = ∅$, une complétion de $u t$ donnerait, après concaténation à $t$, une complétion de $u$.
      Ainsi $(u t)^(-1)L = ∅$ pour tout $t$.
    ],
    bareme: 1,
    label: <completion-residuels>,
  ),
  [
    Un _trie_ est un arbre enraciné dont les arêtes portent des lettres et dont certains nœuds sont terminaux.
    Les étiquettes des arêtes issues d'un même nœud sont distinctes.
    Le langage représenté est l'ensemble des mots lus de la racine à un nœud terminal.
    La racine peut être terminale. On suppose que chaque nœud possède au moins un descendant terminal, éventuellement lui-même.
  ],
  question(
    [
      Dessiner le trie de $D$ et expliquer comment y lire $u^(-1)D$.
      Que représente le résiduel vide ? Proposer un prétraitement du trie permettant ensuite de compter les complétions d'un préfixe donné et de déterminer la taille d'une plus courte complétion, sans énumérer les mots du dictionnaire.
    ],
    solution: [
      La racine possède deux fils, atteints par $a$ et $b$.
      Chacun possède deux fils terminaux, atteints par $b$ et $c$.
      #align(center, cetz.canvas(length: 8mm, {
        import cetz.draw: circle, line, content
        let positions = ((0, 0), (-2, -1.5), (2, -1.5), (-3, -3), (-1, -3), (1, -3), (3, -3))
        for (pere, fils, lettre) in ((0, 1, $a$), (0, 2, $b$), (1, 3, $b$), (1, 4, $c$), (2, 5, $b$), (2, 6, $c$)) {
          line(positions.at(pere), positions.at(fils))
          let p = positions.at(pere)
          let q = positions.at(fils)
          content(((p.at(0) + q.at(0)) / 2, (p.at(1) + q.at(1)) / 2), box(fill: white, inset: 2pt, lettre))
        }
        for (i, p) in positions.enumerate() {
          circle(p, radius: 0.15, fill: white)
          if i >= 3 { circle(p, radius: 0.09) }
        }
      }))
      Les nœuds terminaux sont marqués par un double cercle.
      Depuis le nœud atteint après $u$, les chemins vers les nœuds terminaux épellent exactement $u^(-1)D$.
      Si la lecture de $u$ échoue, le résiduel est vide.
      L'hypothèse sur les descendants garantit la réciproque : tout nœud présent a une complétion.

      Pour chaque nœud $x$, calculer en ordre postfixe le nombre $c(x)$ de terminaux de son sous-arbre et la distance $d(x)$ à un terminal le plus proche.
      Si les fils sont $y_1, …, y_t$,
      $ c(x) = bb(1)_(x " terminal") + sum_(i=1)^t c(y_i). $
      Si $x$ est terminal, $d(x) = 0$. Sinon, $d(x) = 1 + min_(1 ≤ i ≤ t) d(y_i)$.
      Ce second cas possède au moins un fils, par l'hypothèse sur les descendants.
      Le parcours prend $O(N)$ en temps et l'annotation occupe $O(N)$ cases pour un trie de $N$ nœuds.
      Chercher ensuite le nœud de $u$, puis lire ses annotations, coûte $O(1 + s abs(u))$ avec $s = abs(Σ)$ et des listes de fils.
      Si la lecture échoue, il y a zéro complétion et aucune distance finie.
      Le nœud courant, s'il est terminal, doit être compté : il représente la complétion $ε$.
    ],
    bareme: 1.5,
  ),
  [
    On utilise des listes de caractères en OCaml et le type suivant. Les listes de branches n'ont pas d'ordre imposé.
    #extrait("trie")
  ],
  question(
    [
      Écrire ```ocaml sous_trie : char list -> trie -> trie option``` qui renvoie le sous-trie des complétions, ou ```ocaml None``` si le préfixe est absent.
      Justifier la correction et la complexité. On pourra définir une fonction auxiliaire de recherche d'un fils.
    ],
    solution: [
      #extrait(("fils", "sous_trie"))
      Le préfixe vide conserve le trie. Pour $u = a t$, la première arête est nécessairement celle de lettre $a$, puis il reste à lire $t$.
      Une récurrence sur $abs(u)$ justifie les deux cas, y compris un préfixe absent.
      Chaque recherche inspecte au plus $s$ branches, donc le temps est $O(1 + s abs(u))$.
      Les appels sont terminaux et ne copient aucun sous-arbre. L'espace auxiliaire est $O(1)$ avec l'optimisation des appels terminaux d'OCaml.
    ],
    bareme: 2,
  ),
  question(
    [
      Deux nœuds sont dits équivalents si les langages de leurs sous-tries sont égaux.
      Donner une caractérisation récursive de cette équivalence à l'aide du caractère terminal et des fils.
      En déduire une méthode ascendante de fusion des nœuds équivalents et l'appliquer au trie de $D$.
      Pourquoi le graphe obtenu est-il un automate déterministe partiel reconnaissant $D$ ? Comment le compléter ?
    ],
    solution: [
      Deux nœuds sont équivalents si et seulement s'ils ont le même caractère terminal, les mêmes lettres de branches et, pour chaque lettre, des fils équivalents.
      En effet, la présence de $ε$ donne le caractère terminal et le quotient par chaque lettre donne le langage du fils.
      L'hypothèse d'absence de branche stérile permet de retrouver exactement les lettres présentes.

      Parcourir les nœuds en ordre postfixe. Attribuer à chacun un identifiant canonique pour sa signature : caractère terminal et liste des couples (lettre, identifiant du fils), rangée selon l'ordre de $Σ$.
      Des signatures identiques reçoivent le même identifiant.
      Un dictionnaire de signatures évite les comparaisons de sous-arbres entiers. Pour un alphabet fixé, une table de hachage donne un temps moyen $O(N)$, à condition de vérifier l'égalité des signatures en cas de collision.

      Pour $D$, les quatre feuilles fusionnent, puis les deux fils de la racine fusionnent.
      Il reste trois états : la racine, un état intermédiaire et un état final.
      La transition est bien définie car les fils de même lettre ont été fusionnés simultanément.
      La lecture conserve le langage des continuations, donc le langage reconnu est $D$.
      Ajouter un état puits non final pour les transitions absentes et toutes les boucles de cet état donne un ADC à quatre états.
    ],
    bareme: 2,
  ),
))

#let automates = partie("II", "Préparer toutes les plus courtes complétions", contenu: (
  [
    Soit $A = (Q, Σ, q_0, F, δ)$ un ADC, avec $N ≥ 1$ états, $s = abs(Σ)$ lettres et $m = N s$ transitions.
    On note $δ^*$ la transition étendue aux mots.
    Un état est _coaccessible_ s'il existe un chemin de cet état à un état final.
  ],
  question(
    [
      Soit $q = δ^*(q_0, u)$. Relier $u^(-1)cal(L)(A)$ au langage accepté depuis $q$.
      En déduire un critère de complétabilité et montrer que, si une complétion existe, l'une d'elles a une taille au plus $N - 1$.
    ],
    solution: [
      Pour tout $v$, $u v$ est accepté si et seulement si $δ^*(q, v) ∈ F$.
      Le mot $u$ est donc complétable si et seulement si $q$ est coaccessible.
      Un plus court chemin de $q$ à $F$ ne répète aucun état : retirer un cycle donnerait un chemin plus court.
      Il comporte donc au plus $N - 1$ transitions, y compris zéro si $q ∈ F$.
    ],
    bareme: 1,
    label: <completion-borne>,
  ),
  [
    En OCaml, les états sont numérotés de $0$ à $N - 1$ et les lettres de $0$ à $s - 1$, dans l'ordre de l'alphabet.
    Les tableaux ont les dimensions attendues et les indices de transitions sont valides.
    Les champs d'un enregistrement se lisent par ```ocaml a.delta```, ```ocaml a.initial``` et ```ocaml a.final```.
    #extrait("adc")
  ],
  question(
    [
      Proposer puis programmer ```ocaml distances : adc -> int array```.
      La case $q$ doit contenir la taille minimale $d(q)$ d'un chemin de $q$ à $F$, ou $-1$ si aucun chemin n'existe.
      Effectuer un seul parcours à partir de tous les états finaux et utiliser un tableau de taille $N$ comme file.
      Justifier le résultat et donner les complexités, en comptant la construction du graphe utilisé.
    ],
    solution: [
      Construire les listes de prédécesseurs, puis effectuer un parcours en largeur dans le graphe renversé.
      Tous les états finaux sont placés dans la file avec distance zéro.
      Lors de la première découverte d'un prédécesseur, sa distance est celle du sommet courant augmentée de un.
      #extrait("distances")
      Les sommets sont extraits dans l'ordre croissant de leur distance à l'ensemble des sources du parcours inverse.
      Cette distance est exactement la distance à $F$ dans le graphe initial.
      Un sommet est marqué avant son insertion : il entre au plus une fois dans la file, dont la capacité $N$ suffit.
      Des transitions de lettres différentes peuvent donner plusieurs occurrences d'un prédécesseur dans une liste, sans modifier cette propriété.
      La construction et le parcours coûtent $O(N + m)$ en temps et en espace auxiliaire. Les sommets inaccessibles depuis $q_0$ sont également traités, sans gêner le calcul.
    ],
    bareme: 2,
    label: <completion-distances>,
  ),
  question(
    [
      À partir des distances précalculées, écrire ```ocaml completer_adc : adc -> int array -> int list -> int list option``` qui renvoie la complétion choisie en introduction.
      Justifier en particulier le choix lexicographique. Donner le coût d'une requête en fonction de $abs(u)$, de $s$ et de la taille $ℓ$ de la réponse.
    ],
    solution: [
      Lire $u$, puis choisir à chaque étape la plus petite lettre menant à une distance diminuée de un.
      #extrait("completer_adc")
      Si $d(q) > 0$, la première arête d'un plus court chemin fournit au moins une telle lettre.
      Le parcours de l'alphabet ne sort donc pas du tableau.
      La distance diminue strictement jusqu'à zéro, ce qui donne une complétion de taille minimale.
      Toute complétion minimale doit commencer par une lettre faisant diminuer cette distance. Choisir la plus petite, puis appliquer le même raisonnement au suffixe, prouve la propriété lexicographique.
      Une distance nulle donne $ε$, une distance $-1$ donne l'absence de réponse.

      Hors prétraitement, le temps est $O(1 + abs(u) + s ℓ)$ et l'espace $O(1 + ℓ)$, résultat et pile de reconstruction compris.
      On pourrait préenregistrer la meilleure lettre de chaque état en $O(m)$, pour ramener chaque requête à $O(1 + abs(u) + ℓ)$.
    ],
    bareme: 2,
  ),
  question(
    [
      Un langage $L$ est _continuable_ si tout mot de $Σ^*$ y est complétable.
      Caractériser cette propriété à l'aide des états accessibles et des distances précédentes, puis donner un algorithme en $O(N + m)$.
      Un dictionnaire fini peut-il être continuable ? Donner un langage régulier continuable dont le complémentaire est infini.
    ],
    solution: [
      Les mots conduisent exactement aux états accessibles depuis $q_0$.
      Le langage est continuable si et seulement si tous ces états ont une distance différente de $-1$.
      Calculer les distances, parcourir les états accessibles et vérifier cette condition coûte $O(N + m)$ en temps et en espace auxiliaire.

      Un dictionnaire fini n'est pas continuable : prendre un mot plus grand en taille que tous ses éléments. Pour le dictionnaire vide, aucun mot n'est complétable.
      Le langage des mots de taille paire est continuable et son complémentaire, celui des mots de taille impaire, est infini puisque $Σ$ est non vide.
    ],
    bareme: 1.5,
  ),
))

#let parentheses = partie("III", "Compléter une structure syntaxique", contenu: (
  [
    On considère maintenant l'alphabet des quatre caractères `(`, `)`, `[` et `]`.
    Le langage $B$ des mots bien parenthésés avec ces deux sortes de parenthèses est décrit par
    $ S → ε ∣ "(" S ")" S ∣ "[" S "]" S. $
  ],
  question(
    [
      Justifier que cette grammaire engendre exactement $B$ et qu'elle est non ambiguë.
      Montrer que $B$ n'est pas régulier en utilisant les préfixes constitués de $k$ parenthèses ouvrantes `(`.
    ],
    solution: [
      Chaque règle juxtapose un bloc bien parenthésé et un mot bien parenthésé, donc une induction sur les arbres d'analyse donne seulement des mots de $B$.
      Réciproquement, un mot non vide de $B$ commence par une ouvrante.
      Sa fermante correspondante, au premier retour à hauteur zéro, impose une unique décomposition en un bloc entouré de parenthèses du même type, puis un suffixe de $B$.
      Une récurrence forte sur la taille donne une dérivation et son unicité. Le mot vide utilise nécessairement la règle d'effacement.

      Pour $i ≠ j$, le suffixe constitué de $i$ caractères `)` complète le préfixe de $i$ caractères `(`, mais pas celui de $j$ caractères `(`.
      Un automate déterministe devrait donc atteindre des états distincts après chacun de ces préfixes, car deux lectures arrivant au même état ont les mêmes continuations acceptées.
      Aucun automate fini ne reconnaît $B$.
    ],
    bareme: 1.5,
  ),
  question(
    [
      Décrire un parcours de $u$ avec une pile permettant de décider si $u$ est complétable dans $B$.
      Lorsque ce parcours réussit, noter $c_1, …, c_k$ les fermantes attendues, du sommet au fond de la pile.
      Établir la formule
      $ u^(-1)B = B c_1 B c_2 … B c_k B, $
      avec la convention $u^(-1)B = B$ si $k = 0$.
      Que vaut le résiduel si le parcours échoue ?
    ],
    solution: [
      Empiler la fermante attendue à chaque ouvrante.
      Pour une fermante, exiger qu'elle égale le sommet, puis dépiler. Une pile vide ou un type différent fait échouer le parcours.
      Une telle erreur appartient déjà au préfixe lu et aucun suffixe ne peut la réparer : le résiduel est vide.

      En l'absence d'erreur, la pile représente exactement les ouvrantes encore non refermées, dans l'ordre où elles doivent être fermées.
      Dans toute complétion, avant de fermer l'ouvrante au sommet, on peut seulement ouvrir et refermer des blocs complets : cette partie est dans $B$.
      La fermante suivante qui dépile une ouverture du préfixe est nécessairement $c_1$.
      Le même raisonnement donne ensuite $c_2, …, c_k$, puis un dernier mot de $B$ une fois la pile initiale épuisée.
      Cela prouve une inclusion.
      Réciproquement, les blocs de $B$ ne modifient pas la pile initiale et les lettres $c_i$ la dépilent correctement. Tout mot de la forme indiquée complète donc $u$.
    ],
    bareme: 2,
    label: <completion-pile>,
  ),
  question(
    [
      En déduire la plus courte complétion et préciser si elle est unique.
      Écrire ```ocaml completer_dyck : char list -> char list option``` et donner ses complexités.
      Traiter notamment les préfixes `([()`, `([)]` et le mot vide.
    ],
    solution: [
      Chaque bloc de $B$ peut être vide. La complétion $c_1 … c_k$ convient et toute complétion a au moins $k$ lettres.
      Pour avoir exactement $k$ lettres, tous les blocs doivent être vides : cette complétion minimale est unique.
      #extrait("completer_dyck")
      Le résultat est respectivement `])`, l'absence de complétion, puis $ε$.
      Le parcours effectue un travail constant par lettre. Il utilise $O(1 + abs(u))$ en temps et en espace, en comptant la pile qui devient directement la réponse.
    ],
    bareme: 2,
  ),
  question(
    [
      Pour un préfixe complétable et sa pile $c_1, …, c_k$, construire explicitement une grammaire non-contextuelle engendrant $u^(-1)B$.
      Peut-on remplacer la pile par le seul nombre d'ouvertures encore en attente ?
    ],
    solution: [
      Conserver les règles de $S$ et ajouter les variables $T_0, …, T_k$, d'axiome $T_0$, avec
      $ T_(i-1) → S c_i T_i quad (1 ≤ i ≤ k), quad T_k → S. $
      Elles engendrent exactement $B c_1 B … c_k B$, donc le résiduel d'après la @completion-pile.
      Pour $k = 0$, la seule règle ajoutée est $T_0 → S$.
      Pour un préfixe impossible, un axiome sans règle engendre le langage vide.

      Le seul nombre d'ouvertures ne suffit pas : `(` et `[` donnent la même hauteur mais des complétions minimales différentes, et `([)]` ne provoque aucune hauteur négative sans être complétable.
    ],
    bareme: 1,
  ),
))

#let grammaires = partie("IV", "Une méthode pour toute grammaire", contenu: (
  [
    Dans cette partie, une complétion de taille minimale suffit, sans choix lexicographique.
    Soit $G = (Σ, V, R, S)$ une grammaire non-contextuelle dont les règles ont l'une des formes
    $ X → ε, quad X → a, quad X → Y, quad X → Y Z, $
    avec $X, Y, Z ∈ V$ et $a ∈ Σ$.
    On admet que toute grammaire non-contextuelle peut être mise sous ces formes par introduction de variables et transformation des règles.
    Les cycles et les variables n'engendrant aucun mot terminal sont autorisés.
    On fixe un préfixe $u = u_1 … u_n$.
  ],
  question(
    [
      Construire un ADC $P_u$ à $n + 2$ états, numérotés $0, …, n$ et $⊥$, reconnaissant $u Σ^*$.
      Préciser toutes ses transitions, son état initial et ses états finaux, y compris lorsque $u = ε$.
    ],
    solution: [
      L'état initial est $0$ et le seul état final est $n$.
      Pour $0 ≤ i < n$, la lettre $u_(i+1)$ mène de $i$ à $i + 1$ et toute autre lettre mène à $⊥$.
      L'état $n$ boucle sur toutes les lettres, de même que le puits $⊥$.
      Tant que le préfixe n'est pas lu, l'état compte ses lettres correctement reconnues.
      Une erreur est définitive. Après les $n$ lettres attendues, tout suffixe convient.
      Pour $n = 0$, l'état initial est final et boucle sur tout $Σ$, donc le langage est $Σ^*$.
    ],
    bareme: 1.5,
    label: <completion-automate-prefixe>,
  ),
  question(
    [
      Écrire $P_u = (Q, Σ, 0, {n}, δ)$ et introduire une variable $[p, X, q]$ pour chaque $p, q ∈ Q$ et $X ∈ V$.
      On veut que cette variable engendre exactement
      $ {w ∈ Σ^* ∣ X ⇒_G^* w " et " δ^*(p, w) = q}. $
      Donner les règles correspondant aux quatre formes de règles de $G$.
      Choisir l'axiome et justifier, à l'aide des arbres de dérivation, que la grammaire obtenue engendre $cal(L)(G) ∩ u Σ^*$.
    ],
    solution: [
      Pour chaque règle de $G$, ajouter les règles suivantes pour tous les états indiqués :
      - si $X → ε$, ajouter $[p, X, p] → ε$ pour tout $p$
      - si $X → a$, ajouter $[p, X, δ(p, a)] → a$ pour tout $p$
      - si $X → Y$, ajouter $[p, X, q] → [p, Y, q]$ pour tous $p, q$
      - si $X → Y Z$, ajouter $[p, X, q] → [p, Y, r] [r, Z, q]$ pour tous $p, r, q$

      Prendre $[0, S, n]$ pour axiome.
      Une induction sur un arbre de cette grammaire montre que son mot est engendré par $X$ et conduit de $p$ à $q$.
      Dans le cas binaire, le mot se factorise en deux mots, avec l'état intermédiaire $r$.
      Réciproquement, pour un arbre de $G$ et un parcours du mot de $p$ à $q$, annoter chaque nœud par les états avant et après la lecture du facteur qu'il engendre.
      Une règle binaire reçoit l'état intermédiaire atteint après son premier fils.
      On obtient un arbre de la nouvelle grammaire, ce qui prouve l'inclusion réciproque.

      Avec $k = n + 2$, on crée $abs(V) k^2$ variables et au plus $O(abs(R) k^3)$ règles.
      La construction est finie et n'utilise pas d'automate à pile.
    ],
    bareme: 2,
    label: <completion-produit>,
  ),
  question(
    [
      Dans la grammaire précédente, remplacer par $ε$ le membre droit de chaque règle terminale
      $ [i, X, δ(i, a)] → a quad "avec" quad 0 ≤ i < n, $
      et conserver les autres règles.
      Montrer que la nouvelle grammaire engendre exactement $u^(-1)cal(L)(G)$.
      Expliquer pourquoi le remplacement doit dépendre de l'état de départ et ne peut pas consister à effacer globalement certaines lettres de $Σ$.
    ],
    solution: [
      Dans tout arbre issu de $[0, S, n]$ avant modification, les feuilles terminales décrivent un parcours de $P_u$ de $0$ à $n$.
      Ce parcours lit nécessairement un mot $u v$.
      Il ne visite jamais $⊥$ et part d'un état strictement inférieur à $n$ exactement lors des $n$ premières lettres.
      Les règles modifiées effacent donc exactement $u$, puis conservent $v$.
      Tout $u v ∈ cal(L)(G)$ fournit ainsi une dérivation de $v$ dans la grammaire modifiée.

      Réciproquement, chaque arbre de la grammaire modifiée provient d'un arbre de la grammaire du produit : à chaque feuille effacée, rétablir une règle terminale d'origine qui a produit cette règle.
      Les étiquettes d'états imposent encore le parcours de $0$ à $n$.
      Le mot rétabli est donc $u v$, appartient à $cal(L)(G)$, et son effacement donne le mot $v$ initialement dérivé.
      Cela prouve l'égalité, même si plusieurs règles devenues identiques ont été regroupées.

      Une même lettre peut figurer dans le préfixe imposé et dans la continuation : l'effacer partout détruirait des lettres de la réponse.
      Le marquage par les états distingue les positions lues avant et après la fin du préfixe.
      On a construit une grammaire du quotient par un mot, sans supposer de théorème de fermeture.
    ],
    bareme: 3,
    label: <completion-quotient-grammaire>,
  ),
  [
    On applique maintenant un algorithme à la grammaire du quotient ainsi obtenue.
    Plus généralement, soit $H$ une grammaire sous les quatre formes précédentes, avec $M ≥ 1$ variables et $T$ règles.
    La hauteur d'un arbre de dérivation compte les nœuds étiquetés par une variable sur sa plus longue branche.
    Pour une variable $X$, noter $d_h(X)$ la taille minimale d'un mot ayant un arbre issu de $X$ de hauteur au plus $h$, et $+∞$ si aucun n'existe.
  ],
  question(
    [
      Donner $d_0$ et une récurrence permettant de calculer simultanément tous les $d_(h+1)(X)$ à partir de $d_h$.
      Montrer que $M$ étapes suffisent à obtenir les tailles minimales sans restriction de hauteur.
      On pourra choisir, parmi les arbres donnant un mot de taille minimale, un arbre ayant le moins de nœuds et examiner une répétition de variable sur une branche.
    ],
    solution: [
      Initialement, $d_0(X) = +∞$ pour toute variable.
      Pour chaque $X$, $d_(h+1)(X)$ est le minimum de $d_h(X)$ et des coûts suivants pour ses règles :
      $ ε : 0, quad a : 1, quad Y : d_h(Y), quad Y Z : d_h(Y) + d_h(Z). $
      Un minimum sans candidat fini vaut $+∞$, et $+∞ + t = +∞$.
      La décomposition à la racine et l'indépendance des sous-arbres prouvent cette récurrence.

      Si $X$ engendre un mot, choisir un arbre de mot de taille minimale, puis de nombre de nœuds minimal parmi ces arbres.
      Si une variable $Y$ se répète sur une branche, remplacer le sous-arbre de sa première occurrence par celui de sa seconde occurrence.
      On obtient encore un arbre valide issu de $X$.
      Sa taille terminale ne peut augmenter, puisqu'on retire seulement des sous-arbres à tailles terminales non négatives.
      Si elle diminue, cela contredit la minimalité du mot. Sinon, l'arbre a strictement moins de nœuds, ce qui contredit le second choix.
      Aucune variable ne se répète donc sur une branche, et la hauteur est au plus $M$.
      Ainsi $d_M$ donne toutes les tailles minimales, avec $+∞$ exactement pour les variables stériles.
    ],
    bareme: 2,
    label: <completion-hauteur>,
  ),
  [
    Les variables sont numérotées de $0$ à $M - 1$. Dans le tableau représentant une grammaire, la case $x$ contient les règles de membre gauche $x$.
    #extrait(("regle", "grammaire"))
    On représente $+∞$ par ```ocaml None``` et un coût fini $k$ par ```ocaml Some k```.
    On suppose que les additions de coûts finis tiennent dans les entiers de la machine.
  ],
  question(
    [
      Programmer ```ocaml longueurs : grammaire -> int option array``` selon la récurrence précédente et analyser ses complexités.
      Expliquer pourquoi une reconstruction qui suit seulement des règles réalisant les distances finales risque de boucler.
      Proposer une reconstruction terminante d'une complétion minimale en conservant les étapes du calcul.
    ],
    solution: [
      Les tableaux successifs doivent être distincts pour respecter exactement la récurrence en hauteur.
      #extrait(("minimum", "somme", "cout", "longueurs"))
      Chacune des $M$ étapes copie et parcourt $M$ cases et examine $T$ règles en temps constant par règle.
      Le temps est $O(M(M + T))$, avec $O(M)$ d'espace auxiliaire, hors grammaire. Le parcours récursif des règles est terminal.

      Pour $X → X ∣ a$, la distance finale est $1$, et choisir la première règle de même coût bouclerait.
      Conserver plutôt, pour chaque étape et chaque variable, un choix réalisant son coût : soit le coût conservé depuis l'étape précédente, soit une règle évaluée avec les coûts de cette étape précédente.
      Reconstruire depuis l'axiome à l'étape $M$ en diminuant l'étape à chaque appel, y compris lorsqu'on conserve un ancien choix.
      Un coût fini ne peut atteindre l'étape zéro, où tous les coûts sont infinis.
      La reconstruction termine et donne la taille calculée par la récurrence.
      Les choix occupent $O(M^2)$ cases. Émettre les lettres dans un parcours des feuilles évite de recopier des facteurs à chaque concaténation.
      Si l'axiome a un coût infini, le préfixe n'est pas complétable.
    ],
    bareme: 2,
  ),
  question(
    [
      Pour $r ≥ 0$, considérer les règles $X_0 → a$ et $X_i → X_(i-1) X_(i-1)$ pour $1 ≤ i ≤ r$, avec axiome $X_r$ et préfixe vide.
      Déterminer la plus courte complétion.
      Comparer sa taille à celle de la grammaire et expliquer la différence avec la borne obtenue pour les automates.
      Que peut-on promettre pour le temps nécessaire à afficher toute la réponse ?
    ],
    solution: [
      Chaque variable $X_i$ engendre le seul mot $a^(2^i)$, par récurrence sur $i$.
      La réponse contient donc $2^r$ lettres, pour une grammaire ayant $r + 1$ variables et autant de règles.
      Sa taille est exponentielle en ces nombres, alors que la borne de la @completion-borne est linéaire en le nombre d'états d'un ADC.
      Calculer la taille minimale en un nombre polynomial d'opérations arithmétiques ne signifie pas pouvoir afficher le mot en temps polynomial dans la taille de la grammaire.
      Toute sortie explicite exige au moins $2^r$ opérations.
      On peut en revanche conserver une description partagée : chaque $X_i$ renvoie deux fois vers le même sous-résultat $X_(i-1)$, dans un graphe acyclique de taille $O(r)$.
      Les coûts eux-mêmes ont $O(r)$ bits dans cet exemple, ce qui précise la convention de calcul sur les entiers.
    ],
    bareme: 1.5,
  ),
))

#let primitifs = partie("V", "Approfondissement : recherche de motifs et mots primitifs", contenu: (
  [
    Cette partie est facultative et ne compte pas dans la durée indicative.
    On suppose $abs(Σ) ≥ 2$.
    Un mot non vide $w$ est _primitif_ s'il n'est pas de la forme $t^p$ avec $p ≥ 2$.
    La dernière question est reprise de l'oral ENS MP 2018 « Langages continuables et mots primitifs ».
  ],
  question(
    [
      Soit $w$ non vide, de taille $n$.
      Montrer que $w$ est non primitif si et seulement s'il apparaît dans $w w$ à une position $d$ telle que $0 < d < n$, les positions étant numérotées à partir de zéro.
      Pour la réciproque, on pourra étudier la permutation $i ⟼ (i + d) mod n$ des positions de $w$.
    ],
    solution: [
      Si $w = t^p$, prendre $d = abs(t)$ : le décalage d'un bloc laisse le mot inchangé, et une occurrence de $w$ commence à cette position de $w w$.
      Réciproquement, une occurrence interne donne $w_i = w_((i+d) mod n)$ pour toute position $i$.
      Posons $g = gcd(n, d)$.
      Les orbites de cette permutation sont les classes modulo $g$ : en écrivant $n = g n'$ et $d = g d'$, les multiples de $d'$ modulo $n'$ visitent tous les résidus car $n'$ et $d'$ sont premiers entre eux.
      Les lettres de $w$ sont donc constantes sur chaque classe modulo $g$.
      Ainsi $w$ est la puissance de son préfixe de taille $g$, d'exposant $n/g ≥ 2$ puisque $0 < d < n$.
    ],
  ),
  question(
    [
      En déduire un test de primitivité fondé sur une recherche de motif, en précisant le texte à parcourir pour exclure les deux occurrences triviales.
      Expliquer comment réutiliser Boyer–Moore ou Rabin–Karp, étudiés en MP2I.
      Dans le second cas, comment garantir la correction malgré les collisions ? Peut-on annoncer un temps linéaire dans le pire cas pour cette seule raison ?
    ],
    solution: [
      Chercher $w$ dans le facteur de $w w$ obtenu en supprimant sa première et sa dernière lettre.
      Ce texte a taille $2n - 2$ et ses positions de départ possibles correspondent exactement aux positions $1, …, n - 1$ de $w w$.
      Pour $n = 1$, le texte est vide et le mot est primitif. Le mot vide est à rejeter avant d'appliquer le critère.

      Un algorithme de recherche de motif peut être réutilisé directement.
      Avec Rabin–Karp, faire glisser l'empreinte sur les fenêtres de taille $n$ et comparer les lettres dès qu'une empreinte égale celle de $w$.
      Cette vérification rend le test exact malgré les collisions.
      Avec une empreinte et une mise à jour de coût constant, les fenêtres coûtent $O(n)$ hors vérifications, mais des collisions répétées peuvent imposer $O(n^2)$ comparaisons dans le pire cas.
      Aucune complexité linéaire ne découle donc du seul nom de l'algorithme. La version choisie de Boyer–Moore doit également être analysée selon ses règles de décalage.
    ],
  ),
  question-primitifs,
))

#let ex = exercice(
  meta: (
    titre: "Complétion de mots : dictionnaires, automates et grammaires",
    chapitres: ("langages-reguliers", "automates-finis", "grammaires-non-contextuelles", "structures", "graphes", "algorithmique", "recursivite-et-induction"),
    algorithmes: ("parcours-en-profondeur", "parcours-postfixe", "parcours-en-largeur", "programmation-dynamique", "boyer-moore", "rabin-karp"),
    structures: ("arbre", "graphe", "pile", "file", "tableau", "tableau-associatif"),
    langages: ("OCaml",),
    difficulte: 4,
    niveaux: ("MPI",),
    duree: (4, 30),
  ),
  contenu: (
    [
      L'objectif est de compléter un mot déjà saisi pour obtenir un mot accepté par un dictionnaire, un automate ou une grammaire.
      Les parties I à IV constituent le devoir. La partie V est un approfondissement facultatif.
      Les résultats des questions précédentes peuvent être utilisés sans avoir été démontrés.
      Les complexités demandées sont dans le pire cas, sauf mention contraire. L'espace auxiliaire exclut les données d'entrée.

      Les fonctions OCaml auxiliaires peuvent être réutilisées d'une question à l'autre.
      Les syntaxes ```ocaml function```, ```ocaml Array.copy t``` et ```ocaml Array.length t``` désignent respectivement un filtrage direct de l'argument, une copie de tableau et sa taille.
      Le barème indicatif des quatre premières parties est sur 32 points.

      Le travail sur les tries prolonge le thème de la fouille de dictionnaires du sujet Mines-Ponts MP option informatique 2022. Le lien avec l'oral ENS est précisé en partie V.
    ],
    dictionnaires,
    automates,
    parentheses,
    grammaires,
    primitifs,
  ),
)

#show: feuille.with(
  type: "devoir",
  titre: ex.meta.titre,
  niveau: "MPI",
  duree: ex.meta.duree,
  exercices: (ex,),
  corrige: est-corrige(),
  nouvelle-page: false,
)
