#import "/load.typ": exercice, partie, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
    titre: "Sous-monoïdes de mots et codes",
    chapitres: ("langages-reguliers", "recursivite-et-induction", "algorithmique", "graphes"),
    algorithmes: ("algorithme-glouton", "parcours-en-largeur"),
    structures: ("graphe", "file"),
    langages: (),
    difficulte: 3,
    niveaux: ("MPI",),
    duree: (2, 30),
  ),
  contenu: (
    [On fixe un alphabet fini non vide $Σ$.

      Un *sous-monoïde* de $Σ^*$ est un langage $M$ contenant $ε$ et stable par concaténation :
      $ ∀u, v ∈ M, #sep u v ∈ M. $
      Pour $X ⊂ Σ^+$, on dit que $X$ *engendre* $M$ si $M = X^*$.
      Un *code* est un langage $C ⊂ Σ^+$ tel que chaque mot de $C^*$ possède une unique décomposition en mots de $C$. Autrement dit, pour tous $p, q ∈ ℕ$ et tous $x_1, …, x_p, y_1, …, y_q ∈ C$ :
      $ x_1 ⋯ x_p = y_1 ⋯ y_q ==> p = q " et " ∀i ∈ {1, …, p}, #sep x_i = y_i. $
      Un sous-monoïde est dit *libre* s'il est engendré par un code.

      On cherche à comprendre quand un message obtenu en concaténant des mots d'un dictionnaire peut être décodé sans ambiguïté. ],
    partie("I", "Engendrer et décomposer", contenu: (
      question(
        [
          Montrer qu'un langage $M$ est un sous-monoïde si et seulement si $M = M^*$.
          Donner un langage stable par concaténation qui n'est pas un sous-monoïde.
        ],
        solution: [
          Si $M$ est un sous-monoïde, une récurrence sur le nombre de facteurs montre que toute concaténation de mots de $M$ appartient à $M$. Donc $M^* ⊂ M$.
          L'inclusion $M ⊂ M^*$ est toujours vraie.

          Réciproquement, $M^*$ contient $ε$ et est stable par concaténation. Ainsi $M = M^*$ est un sous-monoïde.

          Pour une lettre $a ∈ Σ$, le langage ${a^n ∣ n ≥ 1}$ est stable par concaténation, mais ne contient pas $ε$.
        ],
      ),
      [Pour un sous-monoïde $M$, on note $M_+ = M ∖ {ε}$ et on appelle *indécomposable* un mot de $M_+$ qui ne s'écrit pas comme concaténation de deux mots de $M_+$. On note $B(M)$ l'ensemble de ces mots.],
      question(
        [
          Exprimer $B(M)$ à l'aide de $M_+$ et des opérations sur les langages. Montrer que $B(M)$ engendre $M$.
        ],
        solution: [
          Par définition :
          $ B(M) = M_+ ∖ M_+ M_+. $
          Comme $B(M) ⊂ M$ et $M$ est un sous-monoïde, $B(M)^* ⊂ M$.

          Montrons l'autre inclusion par récurrence forte sur la taille d'un mot $w ∈ M$.
          Si $w = ε$, il est la concaténation vide de mots de $B(M)$.
          Si $w ∈ B(M)$, une décomposition à un facteur convient.
          Sinon, $w = u v$ avec $u, v ∈ M_+$.
          Les tailles de $u$ et $v$ sont strictement inférieures à celle de $w$. L'hypothèse de récurrence permet de décomposer chacun en mots de $B(M)$, puis de concaténer ces décompositions.
        ],
      ),
      question(
        [
          Soit $X ⊂ Σ^+$ tel que $X^* = M$. Montrer que $B(M) ⊂ X$.
          Montrer ensuite que, si $X$ est un code, $X = B(M)$.
          En déduire une condition nécessaire et suffisante portant sur $B(M)$ pour que $M$ soit libre.
        ],
        solution: [
          Pour $b ∈ B(M)$, écrivons $b = x_1 ⋯ x_k$ avec les $x_i$ dans $X$.
          Comme $b ≠ ε$, on a $k ≥ 1$. Si $k ≥ 2$, les mots $x_1$ et $x_2 ⋯ x_k$ appartiennent à $M_+$, ce qui contredit l'indécomposabilité de $b$. Donc $k = 1$ et $b ∈ X$.

          Supposons que $X$ soit un code. Si $x ∈ X ∖ B(M)$, on peut écrire $x = u v$ avec $u, v ∈ M_+$.
          En décomposant $u$ et $v$ en mots de $X$, on obtient une décomposition de $x$ en au moins deux facteurs de $X$, distincte de la décomposition à un seul facteur $x$. C'est impossible.
          Ainsi $X ⊂ B(M)$, puis $X = B(M)$.

          Si $M$ est libre, le code qui l'engendre est donc nécessairement $B(M)$.
          Réciproquement, si $B(M)$ est un code, l'égalité $M = B(M)^*$ montre que $M$ est libre.

          $B(M)$ est donc l'unique ensemble générateur minimal de $M$ : une base de $M$.
        ],
      ),
      question(
        [
          Sur $Σ = {a}$, on considère $M = {ε} ∪ {a^n ∣ n ≥ 2}$.
          Vérifier que $M$ est un sous-monoïde et déterminer $B(M)$. Est-il libre ?
        ],
        solution: [
          Le langage contient $ε$. La somme de deux entiers supérieurs ou égaux à $2$ est encore supérieure ou égale à $2$, donc $M$ est stable par concaténation.

          Les mots $a^2$ et $a^3$ sont indécomposables, car chaque mot de $M_+$ a une taille au moins égale à $2$.
          Pour $n ≥ 4$, la décomposition $a^n = a^2 a^(n - 2)$ montre que $a^n$ n'est pas indécomposable.
          Ainsi $B(M) = {a^2, a^3}$.

          Or $a^6 = (a^2)(a^2)(a^2) = (a^3)(a^3)$ possède deux décompositions distinctes sur $B(M)$.
          Celui-ci n'est pas un code, donc $M$ n'est pas libre. Un sous-monoïde de mots n'est donc pas nécessairement libre.
        ],
      ),
    )),
    partie("II", "Codes préfixes et décodage", contenu: (
      [Un mot $u$ est un *préfixe propre* de $v$ s'il existe $t ∈ Σ^+$ tel que $v = u t$.
        Un langage $C ⊂ Σ^+$ est dit *préfixe* si aucun de ses mots n'est préfixe propre d'un autre.],
      question(
        [
          Montrer que tout langage préfixe est un code.
          Pour un langage préfixe fini, proposer une méthode de décodage d'un mot de $C^*$ lu de gauche à droite, puis justifier sa correction.
        ],
        solution: [
          Supposons $x_1 ⋯ x_p = y_1 ⋯ y_q$, avec tous les facteurs dans $C$.
          Si l'un des nombres $p, q$ est nul, le mot est vide, donc l'autre nombre est nul puisque les facteurs sont non vides.
          Sinon, $x_1$ et $y_1$ sont deux préfixes du même mot. Le plus court est préfixe de l'autre, donc la propriété de préfixe impose $x_1 = y_1$.
          On simplifie ce préfixe commun et on recommence. Une récurrence sur $p + q$ donne l'égalité des deux suites de facteurs.

          Pour décoder, on accumule les lettres jusqu'à obtenir un mot de $C$, on émet ce facteur, puis on recommence avec un mot courant vide.
          On appelle *coupure* une position du message située à la fin d'un facteur de la décomposition.
          Si le message commence par un facteur $c ∈ C$, aucun préfixe propre de $c$ ne peut être dans $C$. La première coupure a donc lieu exactement à la fin de $c$.
          Le même raisonnement s'applique au reste du message, ce qui prouve la correction par récurrence sur le nombre de facteurs. Le mot vide produit la suite vide.
        ],
      ),
      question(
        [
          Sur $Σ = {a, b}$, montrer que ${a, a b}$ est un code qui n'est pas préfixe.
          La méthode de décodage précédente fonctionne-t-elle encore pour ce code ?
        ],
        solution: [
          Le mot $a$ est préfixe propre de $a b$.
          Cependant, le dernier facteur d'un mot non vide de ${a, a b}^*$ est imposé par sa dernière lettre : il vaut $a$ si le mot finit par $a$, et $a b$ s'il finit par $b$.
          Après suppression de ce facteur, on recommence. Une récurrence sur la taille du mot prouve l'unicité de la décomposition.

          Le décodage glouton de gauche à droite échoue sur $a b$ : il émet $a$, puis reste bloqué sur $b$.
        ],
      ),
      question(
        [
          Montrer que $B(M)$ est préfixe si et seulement si $M$ vérifie la propriété suivante :
          $ ∀u, v ∈ Σ^*, #sep (u ∈ M " et " u v ∈ M) ==> v ∈ M. $
        ],
        solution: [
          Supposons $B(M)$ préfixe, et soient $u, u v ∈ M$.
          Décomposons $u = x_1 ⋯ x_p$ et $u v = y_1 ⋯ y_q$ en mots de $B(M)$.
          Tant qu'il reste des facteurs dans les deux décompositions, leurs premiers facteurs sont préfixes d'un même mot. Ils sont donc égaux et on peut les simplifier.
          La décomposition de $u v$ ne peut être épuisée avant celle de $u$, car cela donnerait un mot non vide suivi de $v$ égal à $ε$.
          Ainsi $p ≤ q$ et $v = y_(p + 1) ⋯ y_q ∈ M$. Cela couvre aussi $u = ε$ et $v = ε$.

          Réciproquement, supposons la propriété vérifiée. Si $b, c ∈ B(M)$ et $c = b v$ avec $v ≠ ε$, elle impose $v ∈ M_+$.
          L'égalité $c = b v$ contredit alors l'indécomposabilité de $c$. Donc $B(M)$ est préfixe.
        ],
      ),
      question(
        [
          Sur $Σ = {a, b}$, soit $M$ le langage des mots contenant un nombre pair d'occurrences de $b$.
          Montrer que $M$ est un sous-monoïde libre et déterminer $B(M)$.
          Ce sous-monoïde peut-il être engendré par un langage fini ?
        ],
        solution: [
          Le mot vide contient zéro occurrence de $b$, et le nombre d'occurrences de $b$ est additif par concaténation. Ainsi $M$ est un sous-monoïde.
          Si $u$ et $u v$ ont chacun un nombre pair d'occurrences de $b$, il en va de même de $v$, par différence.
          La question précédente montre que $B(M)$ est préfixe, donc que $M$ est libre.

          Un mot indécomposable commençant par $a$ est nécessairement le mot $a$ : sinon on peut couper après cette première lettre, et le suffixe non vide appartient encore à $M$.
          Un mot de $M$ commençant par $b$ possède une deuxième occurrence de $b$. Le préfixe s'arrêtant à cette occurrence appartient à $M$.
          L'indécomposabilité impose que ce préfixe soit le mot entier. Il est donc de la forme $b a^k b$ avec $k ≥ 0$.
          Réciproquement, $a$ est indécomposable et tout préfixe propre non vide de $b a^k b$ contient exactement un $b$, donc n'appartient pas à $M$.
          Ainsi :
          $ B(M) = {a} ∪ {b a^k b ∣ k ∈ ℕ}. $
          Cet ensemble est infini et contenu dans tout langage engendrant $M$. Aucun langage fini ne peut donc engendrer $M$.
        ],
      ),
      question(
        [
          Montrer qu'un sous-monoïde $M$ est régulier si et seulement si $B(M)$ est régulier.
          Un sous-monoïde régulier est-il nécessairement engendré par un langage fini ?
        ],
        solution: [
          Si $M$ est régulier, $M_+ = M ∖ {ε}$ est régulier, puis $M_+ M_+$ l'est par stabilité par concaténation.
          Les langages réguliers sont stables par différence, donc $B(M) = M_+ ∖ M_+ M_+$ est régulier.

          Réciproquement, si $B(M)$ est régulier, $M = B(M)^*$ est régulier par stabilité par étoile.

          Dans la question précédente, $B(M)$ est décrit par l'expression régulière $a | b a^* b$.
          Donc $M$ est régulier, mais n'est engendré par aucun langage fini.
        ],
      ),
    )),
    partie("III", "Tester un dictionnaire fini", contenu: (
      [On considère désormais un langage fini non vide $C ⊂ Σ^+$, qui n'est pas supposé préfixe. On pose $N = ∑_(c ∈ C) abs(c)$.

        Dans une décomposition d'un message en mots de $C$, on appelle *coupure* une position située à la fin d'un facteur.
        Par exemple, pour $C = {a b, c d e, a b c, d e}$, le message $a b c d e$ admet les décompositions $a b | c d e$ et $a b c | d e$, où les barres indiquent les coupures entre les facteurs.
        Après le premier facteur, on a lu $U = a b$ dans la première décomposition et $V = a b c$ dans la seconde. Le mot situé entre ces deux coupures est donc $r = c$, avec $U r = V$.

        Plus généralement, on compare deux décompositions en lisant des facteurs entiers de chacune. Les préfixes déjà lus $U$ et $V$ peuvent avoir des tailles différentes.
        En échangeant leurs rôles si nécessaire, on peut supposer que $U$ est préfixe de $V$. On mémorise alors le mot $r$ défini par $U r = V$.
        Ce mot représente ce qui a déjà été lu dans la seconde décomposition mais pas encore dans la première. Il vaut $ε$ lorsque les deux coupures sont à la même position.

        Soit $S$ l'ensemble formé de $ε$ et des suffixes propres non vides des mots de $C$.
        On définit le graphe orienté $G = (S, A)$ par les arcs suivants, pour $r ∈ S ∖ {ε}$ et $s ∈ S$ :
        $ (r, s) ∈ A ⟺ ∃c ∈ C, #sep (r s = c " ou " c s = r). $
        Aucun arc ne part de $ε$. Les sommets de départ forment l'ensemble :
        $ R = {r ∈ Σ^+ ∣ ∃x, y ∈ C, #sep x ≠ y " et " x r = y}. $
        Un chemin peut avoir une longueur nulle.],
      question(
        [
          Justifier que $R ⊂ S$ et que, pour $r ∈ S ∖ {ε}$ et $c ∈ C$, tout mot $s$ vérifiant $r s = c$ ou $c s = r$ appartient à $S$.
          Majorer $abs(S)$ en fonction de $N$, puis $abs(A)$ en fonction de $abs(S)$ et $abs(C)$.
        ],
        solution: [
          Si $x r = y$ avec $x, y ∈ C$ et $r ≠ ε$, alors $r$ est un suffixe propre non vide de $y$, puisque $x ≠ ε$. Donc $R ⊂ S$.

          Si $r s = c$, le mot $s$ est vide ou suffixe propre de $c$, car $r ≠ ε$.
          Si $c s = r$, le mot $s$ est vide ou suffixe de $r$. Comme $r$ est un suffixe propre d'un mot de $C$, le mot $s$ est lui aussi un suffixe propre de ce mot.
          Les opérations définissant les arcs ne font donc pas sortir de $S$.

          Un mot $c$ possède $abs(c) - 1$ suffixes propres non vides. En comptant éventuellement plusieurs fois les suffixes communs :
          $ abs(S) ≤ 1 + ∑_(c ∈ C) (abs(c) - 1) = 1 + N - abs(C) ≤ N. $
          Pour chaque couple $(r, c)$, chacune des deux égalités détermine au plus un mot $s$. Ainsi :
          $ abs(A) ≤ 2 abs(C) (abs(S) - 1). $
        ],
      ),
      question(
        [
          Sur $Σ = {a, b}$, déterminer $R$ et les sommets accessibles depuis $R$ pour $C_1 = {a, a b, b b}$, puis pour $C_2 = {a, a b, b b, b a}$.
          Donner deux décompositions distinctes d'un même mot sur $C_2$.
        ],
        solution: [
          Pour $C_1$, on a $S = {ε, b}$ et $R = {b}$, car $a ⋅ b = a b$.
          Le seul arc est $b → b$, obtenu par $b ⋅ b = b b$. Seul $b$ est accessible depuis $R$.

          Pour $C_2$, on a $S = {ε, a, b}$ et encore $R = {b}$.
          Les arcs sont $b → b$, $b → a$, $a → ε$ et $a → b$.
          Tous les sommets sont accessibles, en particulier par le chemin $b → a → ε$.
          Le mot $a b a$ a les deux décompositions $(a b)(a)$ et $(a)(b a)$.
        ],
      ),
      question(
        [
          Montrer que si $ε$ est accessible depuis $R$, alors $C$ n'est pas un code.
          On pourra associer à chaque sommet $r$ rencontré deux suites de mots de $C$, de premiers facteurs distincts, dont les concaténations $U$ et $V$ vérifient $U r = V$.
        ],
        solution: [
          Pour $r ∈ R$, il existe $x ≠ y$ dans $C$ tels que $x r = y$. Les suites à un facteur $(x)$ et $(y)$ initialisent la propriété.

          Supposons $U r = V$, et considérons un arc $r → s$ associé à un mot $c ∈ C$.
          - Si $c s = r$, alors $(U c) s = V$. On ajoute $c$ à la première suite.
          - Si $r s = c$, alors $V s = U c$. On ajoute $c$ à la première suite, puis on échange les deux suites.

          Dans chaque cas, les premiers facteurs restent distincts. Par récurrence sur la longueur du chemin, la propriété est préservée.
          Si l'on atteint $r = ε$, on obtient $U = V$ avec deux suites de facteurs distinctes, puisque leurs premiers facteurs diffèrent. Ainsi $C$ n'est pas un code.
        ],
      ),
      question(
        [
          Montrer réciproquement que si $C$ n'est pas un code, alors $ε$ est accessible depuis $R$.
          On pourra supprimer les facteurs initiaux communs de deux décompositions distinctes, puis suivre leurs coupures dans le message.
        ],
        solution: [
          Soient deux suites distinctes de mots de $C$ ayant la même concaténation. Supprimons leurs facteurs initiaux communs.
          Aucune des suites restantes ne peut être vide : sa concaténation serait $ε$, tandis que l'autre suite, non vide, aurait une taille strictement positive.
          Leurs premiers facteurs $x$ et $y$ sont distincts et préfixes du même mot.
          En échangeant les suites si nécessaire, on a $x r = y$ pour un mot $r ∈ R$.

          On a ainsi deux préfixes déjà lus $U$ et $V$ du même message, avec $U r = V$.
          Tant que $r ≠ ε$, la coupure après $U$ précède celle après $V$. Il reste donc un facteur $c$ à lire dans la décomposition du côté de $U$.
          Les mots $c$ et $r$ sont préfixes du même suffixe du message, donc comparables pour la relation de préfixe.
          - Si $c$ est préfixe de $r$, on écrit $r = c s$ et on avance la coupure de $U$ à $U c$. Le nouveau reste est $s$.
          - Sinon, $r$ est préfixe propre de $c$. On écrit $c = r s$, on avance la coupure de $U$ à $U c$, puis on échange les rôles des deux côtés. Le nouveau reste est encore $s$.

          Ce sont exactement les arcs de $G$.
          Chaque étape consomme un facteur supplémentaire de l'une des deux décompositions fixées. Le nombre de facteurs restant à lire décroît strictement.
          On atteint donc deux coupures au même endroit, au plus tard à la fin du message, ce qui correspond au sommet $ε$.
        ],
      ),
      question(
        [
          En déduire un algorithme qui décide si un langage fini $C ⊂ Σ^+$ est un code.
          Justifier sa terminaison. Une fois $G$ et $R$ construits, donner sa complexité avec des listes d'adjacence.
          Conclure pour $C_1$. Expliquer comment produire deux décompositions distinctes lorsque $C$ n'est pas un code.
        ],
        solution: [
          Construire $S$, puis $R$ en comparant les mots de $C$ deux à deux, et les arcs en comparant chaque reste non vide de $S$ à chaque mot de $C$.
          Toutes ces opérations portent sur des ensembles finis et des mots finis.

          Initialiser une file avec les sommets de $R$, marqués dès leur insertion. Effectuer un parcours en largeur en marquant chaque nouveau sommet dès sa découverte.
          Si $ε$ est atteint, répondre que $C$ n'est pas un code. Si la file devient vide sans avoir atteint $ε$, répondre que $C$ est un code.
          La correction résulte des deux questions précédentes.
          Chaque sommet est inséré au plus une fois, donc le parcours termine, même en présence de cycles.

          L'initialisation des marques coûte $O(abs(S))$. Le parcours examine chaque sommet et chaque arc au plus une fois, pour un coût total $O(abs(S) + abs(A))$, soit $O(N abs(C))$ avec les majorations précédentes.
          Cette complexité concerne le parcours après construction du graphe. La construction doit aussi tenir compte du coût des comparaisons de mots.

          Pour $C_1$, seul $b$ est accessible et la boucle $b → b$ ne conduit pas à $ε$. Ainsi $C_1$ est un code, bien qu'il ne soit pas préfixe.

          Pour obtenir une ambiguïté, mémoriser pour chaque sommet découvert son prédécesseur, le mot $c$ utilisé et le type d'égalité définissant l'arc. Pour chaque sommet initial, conserver un couple $(x, y)$ tel que $x r = y$.
          Lorsqu'on atteint $ε$, reconstruire le chemin depuis un sommet de $R$, puis appliquer les mises à jour de la question 12. On obtient deux suites distinctes ayant la même concaténation.
        ],
      ),
    )),
  ),
)
