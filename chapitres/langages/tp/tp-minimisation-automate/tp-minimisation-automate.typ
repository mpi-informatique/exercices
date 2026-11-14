#import "/load.typ": automate, code, est-corrige, exercice, feuille, lien, partie, question, telecharger
#import code: code-extrait
#import automate: dessiner-automate

#let corrige = read("corrige.ml")

#let sujet = exercice(
  meta: (
    titre: "Minimisation d'un automate",
    chapitres: ("automates-finis", "langages-reguliers"),
    structures: ("tableau", "table-de-hachage"),
    langages: ("OCaml",),
    niveaux: ("MPI",),
    difficulte: 2,
    duree: (1, 30),
    mots-cles: (
      "automate minimal",
      "algorithme de Moore",
      "raffinement de partitions",
    ),
  ),
)[
  L'objectif de ce TP est d'implémenter l'_algorithme de Moore_ qui construit un automate minimal, c'est-à-dire un automate ayant le moins d'états possible parmi les automates déterministes complets reconnaissant un même langage.

  Télécharger #telecharger("https://mpi-informatique.github.io/exercices/banque/chapitres/langages/tp/tp-minimisation-automate/main.ml")[`main.ml`], le compléter et tester les fonctions dans `utop`. Les fonctions `nb_etats`, `nb_lettres`, `delta_etoile`, `accepte` et `equivalent_jusqua` sont fournies. Un mot est représenté par une liste de lettres.

  La fonction fournie `dessiner` utilise la #link("https://mpi-informatique.github.io/lib/")[bibliothèque MPI] et Graphviz. Si nécessaire, suivre les #link("https://github.com/mpi-informatique/lib#utilisation")[instructions d'installation] de la bibliothèque et installer Graphviz pour disposer de la commande `dot`. Depuis le dossier du TP, lancer `utop`, puis saisir :
  ```ocaml
  #require "mpi-informatique";;
  #use "main.ml";;
  dessiner "exemple" exemple;;
  ```
  Ouvrir le fichier `exemple.svg` créé dans ce dossier, par exemple dans un navigateur. Après avoir modifié `main.ml`, le recharger avec `#use "main.ml";;`.

  Toutes les notions utiles sont rappelées ci-dessous. L'exercice #lien("residuels-minimisation")[Ensembles distinguants, résiduels et minimisation] propose un approfondissement théorique.


  On considère des automates déterministes complets (_ADC_) à $n ≥ 1$ états et $p ≥ 1$ lettres, numérotés respectivement de $0$ à $n - 1$ et de $0$ à $p - 1$. On les suppose _accessibles_ : chaque état peut être atteint depuis l'état initial. On utilise le type suivant.
  #code-extrait(corrige, "adc")
  Le champ `initial` contient l'état initial, `finaux` la liste sans doublons des états finaux et `delta` un tableau de $n$ lignes et $p$ colonnes. Ainsi, `a.delta.(q).(x)` est l'état atteint depuis `q` en lisant la lettre `x`.

  #partie("Quels états peut-on fusionner ?")[]

  Soit $A = (Q, Σ, q_0, F, δ)$ un ADC, où $Q$ est l'ensemble des états, $Σ$ l'alphabet, $q_0$ l'état initial, $F$ l'ensemble des états finaux et $δ$ la fonction de transition. On note $δ^*(q, u)$ l'état atteint en lisant le mot $u$ depuis l'état $q$. En particulier, $δ^*(q, ε) = q$.

  Un mot $u$ est _accepté depuis_ $q$ si $δ^*(q, u) ∈ F$ : on commence la lecture en $q$, qui n'est pas nécessairement l'état initial. Deux états $q$ et $r$ sont _équivalents_, ce que l'on note $q ∼ r$, s'ils acceptent exactement les mêmes mots :
  $ q ∼ r ⟺ ∀ u ∈ Σ^*, (δ^*(q, u) ∈ F ⟺ δ^*(r, u) ∈ F). $
  Pour montrer que deux états ne sont pas équivalents, il suffit donc de trouver un _mot distinguant_, accepté depuis l'un et rejeté depuis l'autre. Le mot vide distingue notamment un état final d'un état non final.

  L'automate `exemple` ci-dessous servira tout au long du TP. Dans le code, les lettres $a$ et $b$ sont représentées respectivement par `0` et `1`. Sa définition est fournie dans `main.ml`.

  #dessiner-automate(
    (
      ("0", (0, 0), true, false),
      ("1", (3, 2), false, false),
      ("2", (3, -2), false, false),
      ("3", (6, 2), false, false),
      ("4", (6, -2), false, false),
      ("5", (9, 0), false, true),
    ),
    (
      ("0", "1", "a", (:)),
      ("0", "2", "b", (:)),
      ("1", "3", "a", (:)),
      ("1", "4", "b", (:)),
      ("2", "4", "a", (:)),
      ("2", "5", "b", (curve: -3.4)),
      ("3", "4", "a", (:)),
      ("3", "5", "b", (:)),
      ("4", "5", "a", (:)),
      ("4", "4", "b", (anchor: bottom)),
      ("5", "5", "a, b", (anchor: right)),
    ),
  )

  #question[
    Vérifier que les six états sont accessibles. Trouver un mot distinguant les états `2` et `4`, puis un mot distinguant les états `0` et `1`. Pourquoi aucune lettre ne suffit-elle à distinguer ces deux derniers états ? Montrer enfin que les états `2` et `3` sont équivalents.
  ][
    Les mots $ε$, $a$, $b$, $a a$, $a b$ et $b b$ conduisent respectivement aux états `0`, `1`, `2`, `3`, `4` et `5`.

    Le mot $b$ est accepté depuis `2` et rejeté depuis `4`. Le mot $a b$ est rejeté depuis `0` et accepté depuis `1`. Depuis `0` ou `1`, le mot vide et chacune des deux lettres conduisent à un état non final : aucun mot de taille inférieure à $2$ ne les distingue.

    Les états `2` et `3` sont tous deux non finaux et ont les mêmes successeurs pour chaque lettre. Ils rejettent donc tous deux le mot vide et, après la première lettre d'un mot non vide, la lecture se poursuit dans le même état. Ils sont équivalents.
  ]

  Une _relation_ sur $Q$ indique, pour chaque couple d'états, s'ils sont liés ou non. C'est une _relation d'équivalence_ si elle est :
  - _réflexive_ : chaque état est lié à lui-même
  - _symétrique_ : si $q$ est lié à $r$ alors $r$ est lié à $q$
  - _transitive_ : si $q$ est lié à $r$ et $r$ à $s$ alors $q$ est lié à $s$

  La relation $∼$ vérifie ces trois propriétés, car elle exprime l'égalité des ensembles de mots acceptés depuis les états. La _classe d'équivalence_ de $q$ est l'ensemble $[q] = {r ∈ Q | r ∼ q}$ des états équivalents à $q$. Deux classes sont identiques ou disjointes et chaque état appartient à une classe.

  Ces classes forment une _partition_ de $Q$ : une famille d'ensembles non vides, deux à deux disjoints, dont l'union est $Q$. L'objectif est de calculer cette partition, puis de remplacer chaque classe par un seul état.

  #partie("Raffiner les classes d'états")[]

  On ne peut pas tester tous les mots un par un. On commence par ne considérer que le mot vide, puis les mots de taille au plus $1$, au plus $2$, etc. À chaque étape, on regroupe les états que les mots déjà considérés ne permettent pas de distinguer.

  On appelle ces groupes des _classes provisoires_. Elles forment une partition, mais peuvent encore contenir des états non équivalents. _Raffiner_ cette partition consiste à découper certaines classes en classes plus petites, sans jamais regrouper des états auparavant séparés. Une partition est _stable_ si un nouveau raffinement ne la modifie plus.

  On représente une partition par un tableau `classes` : `classes.(q)` est le numéro de la classe contenant $q$. Deux états sont dans la même classe exactement lorsque leurs cases contiennent le même numéro. Ainsi, `[|0; 0; 1; 1; 2; 3|]` représente les classes ${0, 1}$, ${2, 3}$, ${4}$ et ${5}$. Les numéros servent seulement à identifier les classes.

  Au départ, on sépare les états finaux des états non finaux, en omettant un groupe s'il est vide. Ce sont exactement les distinctions que permet le mot vide.

  #question[
    Compléter `classes_initiales : adc -> int array`. Numéroter `0` la classe contenant l'état `0` (qui n'est pas nécessairement initial) et `1` l'autre classe, si elle existe. Traiter aussi le cas où tous les états sont finaux et celui où aucun ne l'est.
  ][
    #block(breakable: false)[#code-extrait(corrige, "classes_initiales")]

    Pour `exemple`, on obtient `[|0; 0; 0; 0; 0; 1|]`, qui représente les classes ${0, 1, 2, 3, 4}$ et ${5}$.
  ]

  À partir d'une partition, on associe à chaque état sa _signature_ : sa classe actuelle, suivie des classes atteintes en lisant chaque lettre, dans l'ordre de $0$ à $p - 1$. On sépare les états de signatures différentes. La première composante conserve les distinctions déjà connues, les autres permettent d'en découvrir de nouvelles en suivant une transition.

  #question[
    Compléter `signature : adc -> int array -> int -> int list` telle que `signature a classes q` renvoie la signature de l'état `q`.

    Calculer à la main les signatures des six états de `exemple` pour la partition initiale, puis vérifier les résultats avec votre fonction. Quels états seront séparés dès le premier raffinement ?
  ][
    #block(breakable: false)[#code-extrait(corrige, "signature")]

    Les états `0` et `1` ont pour signature `[0; 0; 0]`, les états `2` et `3` ont pour signature `[0; 0; 1]`, l'état `4` a pour signature `[0; 1; 0]` et l'état `5` a pour signature `[1; 1; 1]`. Le premier raffinement donne donc les classes ${0, 1}$, ${2, 3}$, ${4}$ et ${5}$.
  ]

  *Utiliser une table de hachage en OCaml.* Le module `Hashtbl`, dont l'utilisation n'est pas exigible au programme de MPI, permet de mémoriser des associations entre des _clés_ et des _valeurs_. Ici, une clé sera une signature (une liste d'entiers) et sa valeur sera un numéro de classe. Les trois opérations suivantes suffisent :
  - `Hashtbl.create n` crée une table vide. `n` est une estimation du nombre d'associations, pas une limite.
  - `Hashtbl.find_opt table cle` renvoie `None` si la clé est absente, ou `Some valeur` si elle est présente. Les listes sont comparées par leur contenu.
  - `Hashtbl.add table cle valeur` ajoute une association. Dans ce TP, on l'utilisera seulement lorsque la clé est absente, afin de ne pas ajouter plusieurs associations pour une même clé.

  Exemple d'utilisation dans `utop` :
  ```ocaml
  let numeros = Hashtbl.create 6;;
  Hashtbl.add numeros [0; 0; 1] 2;;
  Hashtbl.find_opt numeros [0; 0; 1];;  (* Some 2 *)
  Hashtbl.find_opt numeros [0; 1; 0];;  (* None *)
  ```
  Pour exploiter le résultat d'une recherche, utiliser `match ... with None -> ... | Some numero -> ...`. Les opérations `add` modifient la table sur place, sans créer une nouvelle table.

  #question[
    Compléter `raffine : adc -> int array -> int array`, qui place dans une même nouvelle classe exactement les états ayant la même signature. Parcourir les états dans l'ordre croissant et numéroter les nouvelles classes à partir de `0`, dans l'ordre de première apparition des signatures. Ne pas modifier le tableau reçu en argument.

    On pourra parcourir les états dans l'ordre et utiliser une table de hachage associant chaque signature déjà rencontrée à son numéro de classe. Si la signature est déjà présente, reprendre son numéro. Sinon, lui attribuer le prochain numéro disponible et mémoriser l'association.
  ][
    #block(breakable: false)[#code-extrait(corrige, "raffine")]
  ]

  Vérifier que la partition initiale de `exemple`, puis les résultats de deux appels successifs à `raffine`, sont :
  ```ocaml
  [|0; 0; 0; 0; 0; 1|]
  [|0; 0; 1; 1; 2; 3|]
  [|0; 1; 2; 2; 3; 4|]
  ```

  #question[
    Compléter `classes_equivalence : adc -> int array`, qui part de `classes_initiales` et applique `raffine` jusqu'à stabilisation. Expliquer pourquoi l'algorithme termine.

    La convention de numérotation permet de comparer les tableaux avec `=` pour détecter la stabilisation. Ne pas utiliser `==`, qui teste l'identité physique des tableaux.
  ][
    #block(breakable: false)[#code-extrait(corrige, "classes_equivalence")]

    Chaque raffinement conserve la partition ou augmente strictement le nombre de classes. Avec $n$ états, une partition possède au plus $n$ classes.

    Chaque classe est numérotée dans l'ordre de son plus petit état, dès la partition initiale. Une partition inchangée donne donc un tableau inchangé. Il faut au plus $n - 1$ raffinements stricts, puis un dernier appel pour constater la stabilisation.
  ]

  #question[
    Montrer par récurrence sur $k$ qu'après $k$ raffinements, deux états sont dans une même classe si et seulement s'ils acceptent les mêmes mots de taille au plus $k$. En déduire qu'à la stabilisation, les classes obtenues sont exactement les classes d'états équivalents.
  ][
    Pour $k = 0$, seul le mot vide intervient : deux états l'acceptent simultanément si et seulement s'ils sont tous deux finaux ou tous deux non finaux. C'est la partition initiale.

    Supposons la propriété vraie au rang $k$. Deux états ont la même signature si et seulement s'ils sont dans la même classe et si, pour chaque lettre, leurs successeurs sont dans la même classe. Par hypothèse de récurrence, cela signifie qu'ils acceptent les mêmes mots de taille au plus $k$ et les mêmes mots $x u$, où $x$ est une lettre et $u$ un mot de taille au plus $k$. Cela équivaut à accepter les mêmes mots de taille au plus $k + 1$.

    Une fois la partition stable, tous les raffinements suivants la laissent inchangée. La propriété précédente s'applique donc à toute taille de mot : deux états d'une même classe sont équivalents. Réciproquement, deux états équivalents ne sont séparés à aucun rang.
  ]

  #partie("Construire l'automate minimal")[]

  Lorsque la partition est stable, chaque classe d'équivalence devient un état du nouvel automate, appelé _automate quotient_. Un _représentant_ d'une classe est simplement un état appartenant à cette classe. Par exemple, on peut choisir `2` ou `3` pour représenter la classe ${2, 3}$.

  Pour lire une lettre depuis une classe, on choisit un représentant, on suit sa transition dans l'automate de départ, puis on prend la classe de l'état atteint. La stabilité doit garantir que le résultat ne dépend pas du représentant choisi.

  #question[
    Compléter `quotient : adc -> int array -> adc`, qui construit l'automate quotient associé à la partition renvoyée par `classes_equivalence`. Ses états sont les numéros de classes, de `0` à $c - 1$, où $c$ est le nombre de classes.

    Préciser son état initial et ses états finaux. Pour construire ses transitions, on pourra mémoriser un représentant de chaque classe dans un tableau. Justifier que le choix de ces représentants ne change pas l'automate obtenu.
  ][
    L'état initial est la classe de `a.initial`. Une classe est finale si ses états le sont : une classe ne mélange jamais états finaux et non finaux. Enfin, deux représentants d'une même classe ont la même signature, donc leurs transitions pour une lettre donnée aboutissent dans la même classe.

    #block(breakable: false)[#code-extrait(corrige, "quotient")]
  ]

  #question[
    En déduire `minimiser : adc -> adc`. Dessiner le résultat avec `dessiner "minimal" (minimiser exemple)`, puis ouvrir `minimal.svg`. Vérifier qu’il possède cinq états et utiliser `equivalent_jusqua` pour comparer les langages reconnus jusqu'à la taille $12$. Ce test est une vérification expérimentale, pas une preuve d'équivalence.

    Justifier que le quotient reconnaît le même langage que l'automate de départ.

    Justifier enfin la minimalité : choisir, pour chaque classe, un mot qui y conduit depuis l'état initial, puis montrer que ces mots doivent atteindre des états deux à deux distincts dans tout ADC reconnaissant le même langage.
  ][
    #block(breakable: false)[#code-extrait(corrige, "minimiser")]

    Pour le mot vide, l'état initial du quotient est bien la classe de l'état initial de départ. Supposons que la lecture d'un mot $u$ conduise à $q$ dans l'automate de départ et à sa classe dans le quotient. Par définition des transitions du quotient, la lecture d'une lettre supplémentaire $x$ conduit alors à $δ(q, x)$ et à sa classe. Par récurrence, la propriété vaut pour tout mot. Ces deux états sont finaux simultanément, donc les deux automates reconnaissent le même langage.

    À la stabilisation, deux classes distinctes sont distinguées par un suffixe : depuis l'une, ce suffixe conduit à un état final, et depuis l'autre à un état non final. Comme l'automate est accessible, choisissons des mots menant de l'état initial à ces deux classes. Dans tout ADC reconnaissant le même langage, ces deux mots doivent conduire à des états distincts, sinon le suffixe ne pourrait plus les distinguer. L'automate quotient est donc minimal.
  ]

  #question[
    *Pour aller plus loin.* Estimer le coût d'un raffinement puis celui de l'algorithme complet, en supposant que chaque accès à la table de hachage coûte $O(p)$, comparaisons de signatures comprises.

  ][
    Sous cette hypothèse, un raffinement coûte $O(n p)$ et il y a au plus $n$ raffinements, d'où un coût total en $O(p n^2)$. Il ne s'agit pas d'une garantie dans le pire cas pour `Hashtbl`, dont les performances dépendent des collisions. L'initialisation et la construction du quotient sont également couvertes par cette borne.
  ]

  Pour traiter un automate qui n'est pas accessible, supprimer d'abord ses états inaccessibles. Conserver en revanche les états accessibles depuis lesquels aucun état final n'est atteignable : les supprimer pourrait rendre l'automate incomplet.
]

#show: feuille.with(
  type: "tp",
  titre: sujet.meta.titre,
  niveau: "MPI",
  exercices: (sujet,),
  tp: (
    ouvrir: "main.ml",
    squelette: ((source: "main.ml"),),
    corrige: ((source: "corrige.ml"),),
  ),
  corrige: est-corrige(),
  espacement: 0.7em,
)
