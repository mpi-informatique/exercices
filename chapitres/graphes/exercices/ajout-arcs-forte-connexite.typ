#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Nombre minimal d'arcs à ajouter pour rendre un graphe fortement connexe",
    chapitres: ("graphes",),
    algorithmes: ("kosaraju", "parcours-en-profondeur"),
    structures: ("graphe", "tableau", "liste"),
    langages: ("OCaml",),
    difficulte: 4,
    niveaux: ("MPI",),
    duree: (1, 0),
  ),
  contenu: (
    [Soit $G = (S, A)$ un graphe orienté fini non vide, représenté par des listes d'adjacence.
      On note $n = abs(S)$ et $m = abs(A)$.
      On peut ajouter des arcs entre des sommets existants, sans supprimer d'arc ni ajouter de sommet.
      On cherche le nombre minimal $a(G)$ d'arcs à ajouter pour rendre $G$ fortement connexe.
      Les chemins de longueur nulle sont autorisés : un graphe réduit à un sommet est donc fortement connexe.],

    question(
      [
        On appelle graphe condensé de $G$ le graphe $D$ dont les sommets sont les composantes fortement connexes de $G$, avec un arc $C -> C'$ lorsque $C != C'$ et qu'un arc de $G$ va de $C$ vers $C'$.
        Montrer que $D$ est acyclique et que $a(G) = a(D)$.
        Traiter le cas où $D$ a un seul sommet.
      ],
      solution: [
        Un cycle de composantes distinctes les rendrait mutuellement accessibles : leur réunion serait fortement connexe, ce qui contredit leur maximalité.
        Ainsi $D$ est acyclique.

        Tout ajout rendant $G$ fortement connexe induit un ajout rendant $D$ fortement connexe, avec au plus autant d'arcs : les arcs internes à une composante et les doublons sont inutiles dans $D$.
        Donc $a(D) <= a(G)$.
        Réciproquement, chaque arc ajouté entre deux composantes peut être réalisé entre des représentants quelconques de celles-ci dans $G$.
        La forte connexité interne des composantes permet de suivre les chemins du graphe condensé augmenté.
        Donc $a(G) <= a(D)$.

        Si $D$ a un seul sommet, $G$ est déjà fortement connexe et $a(G) = 0$.
      ],
    ),

    [Pour les deux questions suivantes, on suppose que $D$ possède au moins deux sommets.
      On appelle source un sommet de degré entrant nul et puits un sommet de degré sortant nul.
      On note $s$ le nombre de sources et $t$ le nombre de puits.
      Un sommet isolé est à la fois une source et un puits.],

    question(
      [
        Montrer que chaque sommet de $D$ est accessible depuis une source et peut atteindre un puits.
        En déduire que $s >= 1$, $t >= 1$, puis établir $a(G) >= max(s, t)$.
      ],
      solution: [
        En remontant des arcs depuis un sommet, on finit par rencontrer une source : sinon, la finitude imposerait une répétition et donc un cycle.
        De même, suivre des arcs conduit à un puits.
        Cela comprend les chemins de longueur nulle pour les sommets isolés.

        Pour obtenir un graphe fortement connexe à au moins deux sommets, chaque source doit recevoir un nouvel arc depuis un autre sommet et chaque puits doit émettre un nouvel arc vers un autre sommet.
        Un arc ne satisfait qu'une contrainte de chaque sorte.
        Il faut donc au moins $s$ arcs et au moins $t$ arcs, d'où la borne $max(s, t)$.
      ],
    ),

    question(
      [
        Montrer que cette borne est atteinte.
        On pourra choisir une famille de couples $(S_1, T_1), dots, (S_r, T_r)$, où les $S_i$ sont des sources distinctes, les $T_i$ des puits distincts et $S_i$ peut atteindre $T_i$, telle qu'on ne puisse plus ajouter un couple de source et de puits encore inutilisés.
        Relier d'abord ces couples en cycle, puis intégrer les sources et les puits restants.
      ],
      solution: [
        Une telle famille s'obtient en ajoutant des couples tant que cela est possible ; $r >= 1$.
        Par maximalité, aucune source inutilisée ne peut atteindre un puits inutilisé.
        Toute source inutilisée atteint donc un des $T_i$, et tout puits inutilisé est accessible depuis un des $S_i$.

        Ajoutons les $r$ arcs $T_i -> S_(i+1)$ pour $1 <= i < r$, puis $T_r -> S_1$.
        Les chemins $S_i -> dots -> T_i$ forment alors, avec ces arcs, un ensemble fortement connexe $K$ contenant tous les $S_i$ et $T_i$.

        Il reste $p = s-r$ sources et $q = t-r$ puits.
        Associons arbitrairement $min(p, q)$ couples formés chacun d'une source restante $S$ et d'un puits restant $T$, et ajoutons l'arc $T -> S$.
        Puisque $K$ atteint $T$ et que $S$ atteint $K$, cet arc intègre $S$ et $T$ dans la composante de $K$.
        S'il reste des sources, ajoutons un arc de $T_1$ vers chacune ; s'il reste des puits, ajoutons un arc de chacun vers $S_1$.
        Toutes les sources et tous les puits appartiennent désormais à une même composante fortement connexe.

        Tout sommet $v$ est sur un chemin allant d'une source à un puits : cette composante atteint donc $v$ et est accessible depuis $v$.
        Le graphe obtenu est fortement connexe.
        Le nombre d'arcs ajoutés vaut
        $ r + min(p, q) + abs(p-q) = r + max(p, q) = max(s, t). $

        Les arcs sont nouveaux puisque leurs origines sont des puits de $D$.
        Aucun n'est une boucle : un sommet à la fois source et puits est isolé et doit être sélectionné comme couple avec lui-même.
        Si $r = 1$ et $S_1 = T_1$, les autres sommets de $D$ permettraient d'ajouter un couple, contredisant la maximalité.
        On a donc bien $a(G) = max(s, t)$.
      ],
    ),

    question(
      [
        Rappeler les deux parcours de l'algorithme de Kosaraju.
        En déduire un algorithme calculant $a(G)$ en temps $O(n+m)$, sans construire explicitement les arcs à ajouter.
      ],
      solution: [
        On effectue un parcours en profondeur complet de $G$, en mémorisant les sommets dans l'ordre de fin de visite.
        On construit le graphe transposé
        (tous les arcs sont renversés), puis on le parcourt en profondeur en
        choisissant les racines dans l'ordre décroissant des dates de fin du premier parcours.
        Chaque nouvel arbre de ce second parcours fournit une composante fortement connexe.

        Notons $k$ leur nombre et $c(v)$ le numéro de la composante de $v$.
        Si $k = 1$, on renvoie $0$.
        Sinon, on initialise deux tableaux booléens de taille $k$, indiquant la présence d'un arc entrant ou sortant pour chaque composante.
        Pour chaque arc $(u, v)$ de $G$ tel que $c(u) != c(v)$, on marque une sortie de $c(u)$ et une entrée de $c(v)$.
        Les composantes sans entrée sont les sources de $D$ ; celles sans sortie sont ses puits.
        On renvoie le maximum de ces deux nombres.

        Kosaraju coûte $O(n+m)$, et le balayage des arcs suivi des tableaux coûte $O(m+k)$.
        Le temps total est donc $O(n+m)$.
        L'espace auxiliaire est $O(n+m)$, hors stockage de $G$ mais en comptant son transposé et les piles de récursion.
        Il suffit de tester la présence d'arcs : les arcs internes aux composantes et les arcs multiples entre deux composantes ne faussent pas le comptage.
        La construction de la question précédente justifie la formule ; il n'est pas nécessaire de l'exécuter pour calculer le minimum.
      ],
    ),

    question(
      [
        On dispose d'une fonction OCaml `kosaraju : int list array -> int * int array` renvoyant le nombre $k$ de composantes et le tableau de leurs numéros, compris entre $0$ et $k-1$.
        Écrire `nombre_arcs : int list array -> int`.
        Donner le résultat pour un graphe fortement connexe, pour $n >= 2$ sommets sans arcs, pour une chaîne orientée à au moins deux sommets, puis pour les arcs $0 -> 1$, $0 -> 2$ avec un quatrième sommet isolé.
      ],
      solution: [
        ```ocaml
        let nombre_arcs g =
          let k, composante = kosaraju g in
          if k = 1 then 0
          else begin
            let entree = Array.make k false in
            let sortie = Array.make k false in
            Array.iteri (fun u voisins ->
              List.iter (fun v ->
                let a = composante.(u) and b = composante.(v) in
                if a <> b then begin
                  sortie.(a) <- true;
                  entree.(b) <- true
                end) voisins) g;
            let compter_faux tab =
              Array.fold_left (fun acc b ->
                if b then acc else acc + 1) 0 tab
            in
            max (compter_faux entree) (compter_faux sortie)
          end
        ```

        Les résultats sont respectivement $0$, $n$, $1$ et $3$.
        Dans le dernier exemple, les sources sont $0$ et le sommet isolé $3$, tandis que les puits sont $1$, $2$ et $3$.
        Par exemple, ajouter $1 -> 3$, $3 -> 2$ et $2 -> 0$ rend le graphe fortement connexe.
      ],
    ),
  ),
)
