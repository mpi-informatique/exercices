#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
    titre: "Ensembles inévitables de mots",
    chapitres: ("langages-reguliers", "automates-finis", "graphes"),
    algorithmes: ("parcours-en-profondeur", "determinisation"),
    structures: ("graphe",),
    difficulte: 4,
    niveaux: ("MPI", "MP"),
    duree: none,
    concours: (nom: "ENS", annee: 2019, filiere: "MP"),
  ),
  contenu: (
    [
      On fixe l'alphabet $Sigma = {a, b}$.
      Pour $w in Sigma^*$, on note $w = w_1 dots w_n$, où $n = abs(w)$ est sa taille.
      Le mot vide est noté $epsilon$.
      Un mot $s in Sigma^*$ est un *facteur* de $w$ s'il existe deux mots $u, v in Sigma^*$ tels que $w = u s v$.
      Autrement dit, $s$ apparaît dans $w$ en un bloc de lettres consécutives.
      En particulier, $epsilon$ et $w$ sont des facteurs de $w$.

      Un mot $w$ *évite* un mot $s$ si $s$ n'est pas un facteur de $w$.
      Il évite un ensemble $S subset.eq Sigma^*$ s'il évite chacun de ses éléments.
    ],
    question(
      [
        Donner un mot de taille au moins $12$ qui évite
        $ S_0 = {a a a a, a a a b, a b a, b a a a, b a b, b b b b}. $
      ],
      solution: [
        Le mot $(a a b b)^3 = a a b b a a b b a a b b$ convient.
        Ses facteurs de taille $3$ sont $a a b$, $a b b$, $b b a$ et $b a a$ ; ceux de taille $4$ sont $a a b b$, $a b b a$, $b b a a$ et $b a a b$.
        Aucun ne figure dans $S_0$.
      ],
    ),
    question(
      [
        Donner le pseudocode d'un algorithme simple qui détermine si un mot $w$ évite un ensemble fini $S$.
        Analyser son coût en temps et en espace lorsque les $m$ mots de $S$ ont tous la même taille $ell$.
      ],
      solution: [
        On compare chaque motif à chaque position possible, sans extraire de sous-chaîne.
        Le pseudocode utilise des indices commençant à $0$.

        ```text
        évite(w, S):
            n ← taille(w)
            pour chaque s dans S:
                ℓ ← taille(s)
                si ℓ = 0: renvoyer faux
                si ℓ ≤ n:
                    pour i de 0 à n − ℓ inclus:
                        j ← 0
                        tant que j < ℓ et w[i + j] = s[j]:
                            j ← j + 1
                        si j = ℓ: renvoyer faux
            renvoyer vrai
        ```

        Les tests du « tant que » sont évalués de gauche à droite, avec court-circuit.
        Pour $1 <= ell <= n$, le temps au pire est $O(1 + m + m (n - ell + 1) ell)$, donc $O(n m ell)$ si $m >= 1$.
        L'espace auxiliaire est $O(1)$ : seuls des indices sont conservés, sans compter les entrées.
        Si $ell > n$, le temps est $O(1 + m)$.
        L'ensemble vide est toujours évité ; si $epsilon in S$, aucun mot ne l'évite.
      ],
    ),
    [
      On pose
      $ "Av"(S) = {w in Sigma^* | w " évite " S}. $
      L'ensemble $S$ est *inévitable* si $"Av"(S)$ est fini, et *évitable* sinon.
      Sur un alphabet fini, être évitable équivaut à admettre des mots évitants de tailles arbitrairement grandes.
    ],
    question(
      [
        L'ensemble $S_0$ de la question 1 est-il inévitable ?
        Même question pour $S_1 = {a a a, a b b, b a a, a b a b}$.
      ],
      solution: [
        Ils sont tous deux évitables.
        Pour tout $t in NN$, $(a a b b)^t$ évite $S_0$, comme le montre la liste de facteurs de la question 1.
        De même, $b^t$ évite $S_1$, dont chaque élément contient au moins un $a$.
      ],
    ),
    question(
      [
        Montrer que $S_2 = {a a a, b a b, b a a b, b b b}$ est inévitable.
        On pourra donner une borne sur la taille des mots qui l'évitent.
      ],
      solution: [
        Supposons qu'un mot de taille $7$ évite $S_2$.
        Ses cinq premières lettres contiennent $b a$ : sinon ce préfixe serait de la forme $a^i b^j$, avec $i <= 2$ et $j <= 2$ pour éviter $a a a$ et $b b b$, donc de taille au plus $4$.

        Cette occurrence de $b a$ commence à une position $p <= 4$ ; elle est donc suivie d'au moins deux lettres.
        La première doit être $a$, pour éviter $b a b$.
        La suivante ne peut être ni $a$ (facteur $a a a$), ni $b$
        (facteur $b a a b$).
        C'est impossible.
        Tout mot de taille au moins $7$ contient donc un facteur dans $S_2$.
        La borne est optimale : $a a b b a a$, de taille $6$, évite $S_2$.
      ],
    ),
    question(
      [
        Soient maintenant un alphabet fini non vide $Sigma$, de cardinal $r$, et un entier $k >= 1$.
        Montrer que tout mot de taille au moins $r^k + k$ possède deux occurrences distinctes d'un même facteur de taille $k$.
        Autrement dit, il existe $1 <= p < q <= abs(w) - k + 1$ tels que $w_(p+j) = w_(q+j)$ pour tout $0 <= j < k$.
      ],
      solution: [
        Un mot de taille $n$ possède $n-k+1$ positions où commence un facteur de taille $k$, alors qu'il n'existe que $r^k$ mots de cette taille.
        Si $n >= r^k+k$, le principe des tiroirs donne deux positions distinctes portant le même facteur.
        Les deux occurrences peuvent se chevaucher.
      ],
    ),
    question(
      [
        En déduire un algorithme qui détermine si un ensemble fini $S$ est inévitable.
        Justifier sa terminaison et sa correction, puis donner sa complexité en temps et en espace.
        On ne demande pas un algorithme efficace.
      ],
      solution: [
        Si $S$ est vide, il est évitable puisque l'alphabet est non vide.
        Si $epsilon in S$, il est inévitable.
        On suppose désormais $S$ non vide et formé de mots non vides.
        Posons
        $ k = max_(s in S) abs(s), #sep L = sum_(s in S) abs(s), #sep N = r^k + k. $

        *Répétition et cycle.* Considérons le graphe dont les sommets sont les mots
        de taille $k$ qui évitent $S$.
        Il existe une arête de $u$ vers $v$ si $v$ s'obtient en supprimant la première lettre de $u$ et en ajoutant une lettre à sa fin.
        Les facteurs successifs de taille $k$ d'un mot évitant $S$ décrivent un chemin dans ce graphe.

        Réciproquement, un chemin donne un mot évitant $S$ : tout facteur interdit, de taille au plus $k$, serait contenu dans l'une de ses fenêtres de taille $k$.
        Un chemin qui répète un sommet contient un cycle ; en parcourant ce cycle autant de fois que voulu, on obtient des mots évitants arbitrairement longs.
        Cet argument vaut aussi lorsque les deux occurrences se chevauchent.

        Par la question 5, un mot évitant de taille $N$ fournit un tel cycle.
        Ainsi,
        $ S " est inévitable " <==> " aucun mot de taille " N " n'évite " S. $
        Il suffit donc d'énumérer les $r^N$ mots de taille *exactement* $N$ et de les tester avec l'algorithme de la question 2.
        Un seul témoin évitant suffit pour répondre « évitable ».

        Le coût au pire est $O(r^N N L)$ en temps et $O(N)$ en espace auxiliaire, en générant un seul mot à la fois.
        Pour $r >= 2$ fixé, cette borne en temps est doublement exponentielle en $k$.
        Le stockage des entrées est exclu.

        *Amélioration.* On peut construire directement le graphe précédent et y
        chercher un cycle par parcours en profondeur.
        Il possède au plus $r^k$ sommets et $r^(k+1)$ arêtes ; une fois le graphe construit, ce parcours coûte $O(r^k + r^(k+1))$.
        Il faut aussi compter la construction, notamment les tests d'évitement des sommets, qui coûtent $O(r^k k L)$ avec la méthode naïve.
      ],
    ),
    question(
      [
        Une expression régulière $e$ est dite *inévitable* si son langage $cal(L)(e)$ est un ensemble inévitable.
        Donner un exemple dont le langage ne contient pas le mot vide.
      ],
      solution: [
        L'expression $e = a a a | b a b | b a a b | b b b$ convient, d'après la question 4.
        Il n'est pas nécessaire d'ajouter une étoile : celle-ci ferait appartenir $epsilon$ au langage et rendrait l'inévitabilité immédiate.
      ],
    ),
    question(
      [
        Une expression régulière $e$ est *bornée* s'il existe $n in NN$ tel que tout mot de $cal(L)(e)$ soit de taille au plus $n$.
        Si $e$ est bornée, comment déterminer si elle est inévitable ?
      ],
      solution: [
        Sur un alphabet fini, un langage borné est fini.
        On peut donc énumérer $cal(L)(e)$ puis appliquer la question 6.

        Pour rendre cette énumération effective sans connaître de borne à l'avance, on construit un automate déterministe pour $cal(L)(e)$ et on ne conserve que les états *utiles*, accessibles depuis l'état initial et depuis lesquels un état final est accessible.
        Le graphe utile est acyclique puisque le langage est fini.
        On énumère ses chemins acceptants et les mots qu'ils portent.
        Si aucun état final n'est accessible, le langage est vide.
      ],
    ),
    question(
      [
        Expliquer comment déterminer si une expression régulière quelconque $e$ est inévitable.
      ],
      solution: [
        Les mots qui contiennent un facteur de $cal(L)(e)$ forment le langage régulier
        $ B = Sigma^* cal(L)(e) Sigma^*. $
        On construit un automate pour $B$, on le déterminise, puis on le complète sur $Sigma$ avant d'échanger états finaux et non finaux.
        On obtient un automate déterministe complet $A$ reconnaissant
        $ "Av"(cal(L)(e)) = Sigma^* without B. $

        On conserve les états utiles de $A$.
        Son langage est infini si et seulement si ce graphe utile contient un cycle : un cycle utile peut être répété sur un chemin acceptant ; réciproquement, un chemin acceptant assez long répète un état.
        Chaque arête consomme ici une lettre.

        L'expression $e$ est donc inévitable si et seulement si le graphe utile est acyclique.
        Les recherches d'accessibilité et de cycle sont linéaires dans la taille de l'automate obtenu ; la déterminisation peut produire un nombre d'états exponentiel dans la taille de l'automate initial.
      ],
    ),
    question(
      [
        On dit que $S$ est *inévitable relativement à* $e$ si seuls un nombre fini de mots de $cal(L)(e)$ évitent $S$, c'est-à-dire si
        $ cal(L)(e) ∩ "Av"(S) $
        est fini.
        Étant donnés $e$ et un ensemble fini $S$, expliquer comment décider cette propriété, ainsi que la propriété opposée.
      ],
      solution: [
        On construit un automate déterministe pour $cal(L)(e)$ et un automate déterministe complet pour $"Av"(S)$, comme à la question 9 en remplaçant $cal(L)(e)$ par l'union finie des mots de $S$.

        Leur automate produit reconnaît $cal(L)(e) ∩ "Av"(S)$ : une paire d'états est finale lorsque ses deux composantes le sont.
        Après suppression des états inutiles, un cycle existe si et seulement si cette intersection est infinie.
        Son absence caractérise donc l'inévitabilité relative.

        La propriété opposée signifie qu'une infinité de mots de $cal(L)(e)$ évitent $S$.
        Si $cal(L)(e)$ est fini, tout ensemble $S$ est inévitable relativement à $e$ selon la définition retenue ici.
      ],
    ),
    question(
      [
        Montrer que tout ensemble inévitable $S subset.eq Sigma^*$, même infini, contient un sous-ensemble fini inévitable.
      ],
      solution: [
        Si $epsilon in S$, on prend $S' = {epsilon}$.
        Sinon, $epsilon$ évite $S$ ; l'ensemble fini $"Av"(S)$ est donc non vide.
        Notons $n$ la taille maximale de ses éléments.

        Chaque mot $u$ de taille $n+1$ possède un facteur $s_u in S$.
        On choisit un tel facteur pour chacun de ces mots et on pose
        $ S' = {s_u | u in Sigma^(n+1)}. $
        Cet ensemble est fini, inclus dans $S$ et inévitable : tout mot de taille au moins $n+1$ possède un préfixe de taille $n+1$, qui contient l'un des facteurs choisis.
        Il ne reste qu'un nombre fini de mots plus courts.
      ],
    ),
    question(
      [
        Étant donnée une expression régulière inévitable $e$, expliquer comment calculer un sous-ensemble fini inévitable de $cal(L)(e)$.
      ],
      solution: [
        On commence par tester si $epsilon in cal(L)(e)$ ; dans ce cas, ${epsilon}$ est une réponse.
        Sinon, l'automate de la question 9 reconnaît un langage fini non vide, celui des mots évitant $cal(L)(e)$.

        Son graphe utile est un graphe orienté acyclique.
        Un calcul de plus long chemin dans un ordre topologique donne la taille maximale $n$ d'un mot accepté.
        On énumère alors les mots $u$ de taille $n+1$ ; pour chacun, on énumère ses facteurs et on en retient un accepté par un automate de $cal(L)(e)$.
        Un tel facteur existe par définition de $n$.

        L'ensemble des facteurs retenus, après suppression des doublons, est une réponse par la question 11.
        Toutes les énumérations sont finies ; l'algorithme termine, même si son coût peut être très élevé.
        Le sous-ensemble obtenu n'est pas nécessairement de cardinal minimal.
      ],
    ),
  ),
)
