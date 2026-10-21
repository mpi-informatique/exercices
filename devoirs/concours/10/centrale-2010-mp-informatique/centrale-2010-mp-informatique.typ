#import "/load.typ": exercice, feuille, partie, question, sep, code, automate
#import code: code-extrait
#import automate: dessiner-automate

#let extrait(..noms) = block(breakable: false, code-extrait(read("corrige.ml"), ..noms))
#let exemple = dessiner-automate(
  (("-1", (0, 1), false, false), ("0", (2, -1), false, false), ("1", (4, 1), false, false), ("2", (6, -1), false, false), ("3", (8, 1), false, false), ("4", (11, 1), false, false), ("5", (14, 1), false, false)),
  (
    ("-1", "0", "a", (curve: 0)), ("0", "1", "b", (curve: 0)),
    ("-1", "1", "a b", (curve: 0)), ("1", "2", "a", (curve: 0)),
    ("2", "3", "a", (curve: 0)), ("1", "3", "a a", (curve: 0)),
    ("1", "4", "a a b", (curve: 1.7)), ("2", "4", "a b", (curve: -0.4)),
    ("3", "4", "b", (curve: 0)), ("4", "5", "a", (curve: 0)),
  ),
)
#let graphe-l0 = dessiner-automate(
  (("-1", (0, 0), false, false), ("0", (2, 0), false, false), ("1", (4, 0), false, false), ("2", (6, 0), false, false), ("3", (8, 0), false, false), ("4", (10, 0), false, false), ("5", (12, 0), false, false), ("6", (14, 0), false, false)),
  (("-1", "3", "a a b b", (curve: 1.5)), ("0", "2", "a b", (curve: -1.3)), ("3", "5", "a b", (curve: 0.5))),
)

#let ex = exercice(
  meta: (
    titre: "Étoile d'un langage polynomial",
    chapitres: ("langages-reguliers", "automates-finis", "algorithmique", "graphes", "structures"),
    algorithmes: ("programmation-dynamique", "parcours-en-largeur"),
    structures: ("tableau", "file", "graphe"),
    langages: ("OCaml",),
    difficulte: 4, // Estimation de la difficulte globale.
    niveaux: ("MPI",),
    concours: (nom: "Centrale", annee: 2010, filiere: "MP", oral: false),
  ),
  corrections: [
    - I.A.2–3, corrigé : ajouter un nouvel état initial final, sans arc entrant, pour accepter $ε$ sans autoriser des retours parasites à l'ancien état initial. Compter aussi la copie de l'automate.
    - I.C.2 et I.D.2, corrigé : corriger le test de puissance de deux et donner une preuve de non-régularité par pompage d'un mot choisi.
    - I.E.1–3 : traiter $L = ∅$ et $ε$. Remplacer le contre-exemple de pompage invalide du corrigé par $(a b^p)^2$.
    - II.A.3, corrigé : « centralesupelec » a 14 lettres, donc $p = 12$, et non 15.
    - II.B.1 : réserver l'équivalence aux mots non vides. II.C : remplacer « un mot de $L$ » par « un mot de $A^*$ ».
    - II.A.4, II.B.2, II.C.4 et III.B.2, corrigé : accepter explicitement $ε$ et garder le type de l'oracle demandé dans l'énoncé. Corriger les dimensions et indices de la table dynamique.
    - II.B.3, corrigé : donner un cas atteignant $2^n - 1$ appels. Un mot rejeté quelconque ne suffit pas.
    - III.A.2, corrigé : conserver des compteurs croissants et appliquer le modulo seulement à l'accès au tableau, afin de préserver le test de vacuité.
    - III.B.1 : ajouter l'arc $(2, 4)$ étiqueté $a b$ dans l'exemple. Dessiner le graphe de $L_0$, et non celui de $a^* b^*$ montré dans le corrigé.
    - III.B.2–4, corrigé : suivre le parcours en largeur implicite demandé, dimensionner la file pour $n + 1$ sommets, et distinguer le coût des extractions de facteurs du nombre d'appels à l'oracle.
    - Adaptations : OCaml remplace Caml Light et Pascal. Les termes « régulier », « taille », et la notation $(S, A)$ des graphes suivent les conventions de la banque. Difficulté globale estimée à 4 sur 5.
  ],
  contenu: (
    [On considère dans tout le problème un alphabet $A$. Un langage $L$ est un ensemble de mots sur $A$. On désigne par $L^*$ l'ensemble des mots obtenus par concaténation de suites finies de mots de $L$, y compris le mot vide $ε$. Chaque mot entrant dans la concaténation est appelé _facteur_. En particulier, si $m$ est un mot, $m^k$ est la concaténation de $k$ copies de $m$.

      Ainsi $L^* = union.big_(n ∈ ℕ) L^n$, avec $L^0 = {ε}$ et $L^(n + 1) = {w_1 w_2 | (w_1, w_2) ∈ L^n × L}$ pour tout $n ∈ ℕ$.

      Les trois parties tournent autour d'une même question, tout en restant largement indépendantes. Le résultat abordé est :
      #align(center)[_Si un langage $L$ est polynomial, alors $L^*$ l'est aussi._]

      Un _langage polynomial_ est un langage $L$ pour lequel il existe un programme prenant en entrée un mot $m ∈ A^*$ et retournant un booléen indiquant son appartenance à $L$, en un temps majoré par $P(abs(m))$, où $P$ est un polynôme dépendant du programme, mais pas du mot. L'entier $abs(m)$ désigne la taille de $m$.
      On pourra admettre que si un polynôme réel $P$ tend vers $+∞$ en $+∞$, il existe un polynôme réel $Q$, croissant sur $ℝ_+$, tel que $P(t) ≤ Q(t)$ pour tout $t ≥ 0$ et $P(t) ∼ Q(t)$ lorsque $t → +∞$.

      Un langage est _régulier_ lorsqu'il est accepté par un automate fini.
      Pour les programmes testant l'appartenance à un langage, on pourra supposer que les lettres du mot donné appartiennent au bon alphabet. Les programmes demandés seront écrits en OCaml, sauf lorsqu'un pseudocode est explicitement autorisé.],
    partie("I", "Quelques exemples", contenu: (
      partie("I.A", "Cas des langages réguliers", contenu: (
        question([Soit $L$ un langage régulier. Montrer qu'il est polynomial en écrivant un programme prenant un mot en entrée et évaluant son appartenance à $L$. Le pseudocode est accepté.
          On dispose d'un automate fini déterministe complet, d'état initial $q_i$, d'ensemble d'états finaux $F$, dont chaque transition $δ(q, α)$ se calcule en $O(1)$. Justifier le temps d'exécution.], label: <cs10-regulier>, solution: [
          ```text
          q <- qi
          pour chaque lettre alpha de m :
            q <- delta(q, alpha)
          retourner (q appartient a F)
          ```
          Après lecture d'un préfixe, $q$ est l'état atteint depuis $q_i$ par ce préfixe. Le test final décide donc l'appartenance à $L$. Les $abs(m)$ transitions et le test final coûtent $O(abs(m) + 1)$, l'automate étant fixé.
        ]),
        question([Soit $L$ un langage régulier. Montrer que $L^*$ est régulier en construisant explicitement un automate sans $ε$-transition reconnaissant $L^*$.], label: <cs10-etoile>, solution: [
          Partons de l'automate déterministe complet $(Q, A, δ, q_i, F)$. Ajoutons un état $s ∉ Q$, seul état initial, et rendons finaux les états de $F ∪ {s}$.
          Conservons les transitions de l'automate initial. Pour chaque $α ∈ A$, ajoutons $s → δ(q_i, α)$, et pour chaque $f ∈ F$, ajoutons $f → δ(q_i, α)$, avec l'étiquette $α$.
          Aucun arc n'entre dans $s$.

          Le chemin vide accepte $ε$. Un chemin réussi non vide se découpe aux transitions de redémarrage en chemins réussis de l'ancien automate, donc son étiquette est une concaténation de mots de $L$.
          Réciproquement, toute concaténation de mots non vides de $L$ se lit en utilisant ces redémarrages. Les facteurs vides peuvent être supprimés. L'automate reconnaît donc exactement $L^*$, sans $ε$-transition.
        ]),
        [Les deux questions précédentes prouvent le théorème dans le cas particulier d'un langage régulier.],
        question([Évaluer le coût en temps et en espace de la construction choisie d'un automate reconnaissant $L^*$ à partir d'un automate reconnaissant $L$.], solution: [
          Si $N = abs(Q)$ et $r = abs(A)$, l'automate initial complet a $N r$ transitions. On ajoute un état et au plus $(abs(F) + 1)r$ transitions.
          La copie complète coûte $O(N + N r + (abs(F) + 1)r)$ en temps et en espace. Si la représentation initiale est conservée et étendue, le surcoût est $O(1 + (abs(F) + 1)r)$.
          Une éventuelle déterminisation peut être exponentielle en $N$, mais elle ne dépend pas du mot testé.
        ]),
      )),
      partie("I.B", "Le cas de L₀ = {aⁿbⁿ | n ∈ ℕ}", contenu: (
        [On note $L_0 = {a^n b^n | n ∈ ℕ}$.],
        question([Montrer que ni $L_0$ ni $L_0^*$ n'est régulier.], solution: [
          Pour chacun des deux langages, supposons qu'un entier de pompage $p ≥ 1$ existe et prenons $u = a^p b^p$. Dans toute décomposition $u = x y z$ avec $abs(x y) ≤ p$ et $abs(y) ≥ 1$, on a $y = a^r$, où $1 ≤ r ≤ p$.
          Le mot $x z = a^(p - r) b^p$ n'appartient à aucun des deux langages : chaque facteur $a^k b^k$ est équilibré, donc tout mot de $L_0^*$ contient autant de $a$ que de $b$. Cela contredit le lemme de l'étoile.
        ]),
        question([Montrer que $L_0$ et $L_0^*$ sont polynomiaux. Écrire explicitement un programme reconnaissant chacun de ces langages.], solution: [
          #extrait("reconnait_l0")
          #extrait("reconnait_l0_etoile")
          Le premier programme compte les $a$ initiaux puis les $b$, et vérifie que les deux nombres sont égaux et que le mot est épuisé.
          Le second applique ce test à chaque bloc maximal de $a$ suivi de $b$. Dans une concaténation de facteurs non vides $a^k b^k$, les retours de $b$ à $a$ imposent les coupures.
          Chaque lettre est parcourue au plus une fois, donc le coût est $O(abs(m) + 1)$. Le mot vide est accepté dans les deux cas.
        ]),
      )),
      partie("I.C", "Un autre exemple", contenu: (
        [Dans cette section, $A = {a}$ et $L_1 = {a^(2^n) | n ∈ ℕ}$.],
        question([Le langage $L_1$ est-il régulier ? Donner un automate ou une preuve de non-régularité.], solution: [
          Supposons qu'il possède un entier de pompage $p$. Choisissons $r$ tel que $2^r > p$, puis le mot $u = a^(2^r)$. Le facteur pompé a une taille $d$ vérifiant $1 ≤ d ≤ p$.
          En le répétant deux fois, on obtient un mot de taille $2^r + d$, strictement comprise entre $2^r$ et $2^(r + 1)$. Cette taille n'est pas une puissance de deux, d'où une contradiction.
        ]),
        question([Prouver que $L_1$ est polynomial.], solution: [
          Calculons $ℓ = abs(m)$. Si $ℓ = 0$, on rejette. Tant que $ℓ > 1$ est pair, remplaçons $ℓ$ par $ℓ / 2$. On accepte si et seulement si la valeur finale est $1$.
          Il y a au plus $1 + floor(log_2(abs(m)))$ divisions. Avec des entiers binaires, même en comptant $O(log(abs(m) + 1))$ par opération, le coût reste polynomial, y compris le calcul initial de la taille.
        ]),
        question([Donner, en la justifiant, la valeur de $L_1^*$.], solution: [Comme $a = a^(2^0) ∈ L_1$, toute puissance de $a$ est dans $L_1^*$. Ainsi $L_1^* = {a}^*$.]),
        question([Le langage $L_1^*$ est-il régulier ? Polynomial ?], solution: [Un automate à un seul état initial et final, muni d'une boucle étiquetée $a$, reconnaît ${a}^*$. Ce langage est donc régulier et polynomial.]),
      )),
      partie("I.D", "Un dernier exemple", contenu: (
        [On prend $A = {0, 1, \#}$. La fonction $φ$ code un entier en base deux sans zéro initial, sauf $φ(0) = 0$. Par exemple, $φ(10) = 1010$. On note
          $ L_2 = {φ(n_1) \# φ(n_2) \# φ(n_1 n_2) \# | n_1, n_2 ∈ ℕ}. $
          Ainsi $11 \# 100 \# 1100 \# ∈ L_2$, car $3 × 4 = 12$.],
        question([Montrer que $L_2$ est polynomial.], solution: [
          Vérifions que le mot comporte exactement trois blocs binaires non vides, séparés et terminés par $\#$, sans zéro initial sauf dans le bloc $0$. Cette vérification est linéaire.
          Décodons les trois entiers $n_1$, $n_2$, $n_3$, puis vérifions $n_1 n_2 = n_3$. Ils ont au plus $abs(m)$ bits. Le décodage, la multiplication scolaire et la comparaison se font en $O(abs(m)^2)$ opérations sur les bits. Le test est donc polynomial.
        ]),
        question([Le langage $L_2$ est-il régulier ?], solution: [
          Non. S'il avait un entier de pompage $p ≥ 1$, considérons $u = 1 0^(2p) \# 1 \# 1 0^(2p) \#$, qui code $2^(2p) × 1 = 2^(2p)$.
          Un facteur pompé contenu dans les $p$ premières lettres se trouve dans le premier bloc. S'il contient le premier $1$, sa suppression laisse un bloc commençant par $0$ et de taille au moins deux, donc un codage interdit. Sinon, sa suppression diminue le premier entier sans changer le produit annoncé ni le second entier, égal à $1$. Dans les deux cas le mot obtenu n'est plus dans $L_2$, d'où la contradiction.
        ]),
      )),
      partie("I.E", "Une petite variation", contenu: (
        [Pour un langage $L$, on définit $ψ(L) = {w^n | w ∈ L, n ∈ ℕ}$.],
        question([Montrer que $ψ(L) ⊂ L^*$. Donner un exemple où l'inclusion est stricte.], solution: [
          Toute puissance d'un mot de $L$ est une concaténation de mots de $L$.
          Pour $L = {a b, b a}$, le mot $a b b a ∈ L^*$ n'est une puissance d'aucun mot de $L$. L'inclusion est donc stricte.
          Pour $L = ∅$, on a également $ψ(L) = ∅$, tandis que $L^* = {ε}$.
        ]),
        [Dans les trois questions suivantes, donner une preuve ou un contre-exemple rapidement justifié.],
        question([« $L$ est régulier » implique-t-il « $ψ(L)$ est régulier » ?], solution: [
          Non. Prenons $L = a b^*$. Si $ψ(L)$ avait un entier de pompage $p ≥ 1$, appliquons le lemme au mot $u = (a b^p)^2$.
          Le facteur pompé est dans le premier bloc $a b^p$. S'il contient $a$, sa suppression produit un mot commençant par $b$. Sinon, il est de la forme $b^r$, avec $r ≥ 1$, et sa suppression donne $a b^(p - r) a b^p$.
          Ce dernier mot contient deux $a$, donc devrait être le carré d'un même mot $a b^k$, ce qui imposerait $p - r = p$. Les deux cas contredisent le lemme.
        ]),
        question([« $L$ est polynomial » implique-t-il « $ψ(L)$ est polynomial » ?], label: <cs10-psi>, solution: [
          Oui. Si $L = ∅$, le résultat est immédiat. Sinon, $ε ∈ ψ(L)$ et on accepte le mot vide.
          Pour un mot $m$ de taille $n ≥ 1$, testons chaque diviseur $d$ de $n$. Soit $v$ le préfixe de taille $d$. On accepte si $v ∈ L$ et $m = v^(n / d)$.
          Ce test est nécessaire et suffisant, car tout mot non vide de $ψ(L)$ est une puissance d'un mot non vide de $L$.
          Pour un majorant croissant $P$ du coût du test de $L$, le coût est $O(n(P(n) + n))$ dans le modèle arithmétique usuel, donc polynomial. Le test du mot vide est une constante propre au langage fixé : il ne nécessite pas de résoudre uniformément la vacuité d'un langage donné par un programme.
        ]),
        question([« $L$ est régulier » implique-t-il « $ψ(L)$ est polynomial » ?], solution: [Oui, par la @cs10-regulier puis la @cs10-psi.]),
      )),
    )),
    partie("II", "Trois algorithmes", contenu: (
      partie("II.A", "Une énumération des parties de ⟦0, n − 1⟧", contenu: (
        question([Écrire une fonction prenant deux entiers $k$ et $n$, avec $0 ≤ k ≤ 2^n - 1$, et calculant un tableau contenant la décomposition de $k$ en base deux. L'ordre de placement des bits est libre.], solution: [
          #extrait("decompose")
          Le bit d'indice $i$ est le coefficient de $2^i$. Le tableau a $n$ cases, y compris les zéros de poids fort. Le coût est $O(n)$ dans le modèle où division et reste ont un coût constant.
        ]),
        question([Expliquer comment utiliser cette fonction pour décrire toutes les parties de $⟦0, n - 1⟧$.], solution: [Pour chaque $k ∈ ⟦0, 2^n - 1⟧$, prenons les indices dont le bit vaut `true`. L'unicité de l'écriture binaire donne une bijection avec les $2^n$ parties de $⟦0, n - 1⟧$.]),
        question([Expliquer comment associer à une partie non vide de $⟦0, p⟧$, avec $p$ à préciser, une décomposition d'un mot en mots non vides. Illustrer avec `centralesupelec = cent.rale.supelec`.], solution: [
          Pour un mot de taille $n ≥ 2$, prenons $p = n - 2$. Un indice choisi indique une coupure après cette lettre. Les indices croissants définissent une décomposition en au moins deux facteurs non vides. La partie vide correspond au facteur unique.
          Le mot `centralesupelec` a 14 lettres. Les coupures après `cent` et `rale` sont représentées par ${3, 7} ⊂ ⟦0, 12⟧$.
        ]),
        question([Écrire une fonction `dans_l_etoile` prenant un mot `mot` et testant son appartenance à $L^*$. Elle prendra aussi en argument une fonction `dans_l` testant l'appartenance d'un mot à $L$. Donner son type.], label: <cs10-oracle>, solution: [
          On représente les mots par des chaînes. Le type demandé est `(string -> bool) -> string -> bool`.
          #extrait("teste_decomposition")
          #extrait("dans_l_etoile")
          Le mot vide est accepté sans appel à `dans_l`. Sinon, toutes les coupures possibles sont énumérées jusqu'à trouver une décomposition valide. Le dernier facteur se termine toujours à la dernière lettre.
        ]),
        question([Quelle est la complexité temporelle de `dans_l_etoile` ? Distinguer les appels à `dans_l` des opérations arithmétiques standards, dont les divisions euclidiennes supposées de coût constant.], solution: [
          Pour $n ≥ 1$, il y a $2^(n - 1)$ décompositions et au plus $n$ facteurs à tester par décomposition. On effectue donc $O(n 2^n)$ appels à `dans_l` et $O(n 2^n)$ opérations élémentaires.
          Les extractions de chaînes coûtent au total $O(n)$ par décomposition, donc restent dans cette même borne hors coût interne de `dans_l`. Avec un majorant croissant $P$, une borne globale est $O(n 2^n (P(n) + 1))$.
          L'espace auxiliaire est $O(n)$, hors mémoire de l'oracle : on ne conserve qu'une décomposition à la fois.
        ]),
        question([Pour des mots de plus de quelques dizaines de lettres, la méthode fait intervenir de trop grands entiers. Comment énumérer toutes les parties de $⟦0, n - 1⟧$ sans manipuler d'entiers de l'ordre de $2^n$ ? La complexité globale est-elle détériorée ?], solution: [
          On conserve directement les bits dans un tableau. Pour passer à la partie suivante, on propage une retenue jusqu'au premier bit nul.
          #extrait("suivant")
          #extrait("dans_l_etoile_sans_entiers")
          Un passage coûte au plus $O(n)$ et il y a toujours $2^(n - 1)$ décompositions. La borne globale reste $O(n 2^n)$ hors oracle.
        ]),
      )),
      partie("II.B", "Un algorithme récursif", contenu: (
        question([Prouver que pour $n ≥ 1$ et des lettres $w_0, …, w_(n - 1)$ de $A$, le mot $w = w_0 ⋯ w_(n - 1)$ appartient à $L^*$ si et seulement si $w ∈ L$ ou il existe $k ∈ ⟦0, n - 2⟧$ tel que $w_0 ⋯ w_k ∈ L$ et $w_(k + 1) ⋯ w_(n - 1) ∈ L^*$.], label: <cs10-rec>, solution: [
          Si $w ∈ L^*$ est non vide, supprimons les facteurs vides de sa décomposition. S'il ne reste qu'un facteur, $w ∈ L$. Sinon, le premier facteur appartient à $L$ et le suffixe non vide restant appartient à $L^*$, ce qui donne $k$.
          Réciproquement, $L ⊂ L^*$ et $L L^* ⊂ L^*$, donc les deux possibilités impliquent $w ∈ L^*$.
        ]),
        question([En utilisant cette propriété, écrire une fonction `dans_l_etoile_2` testant l'appartenance à $L^*$, avec les conventions de la @cs10-oracle.], solution: [
          #extrait("dans_l_etoile_2")
          `aux debut` teste le suffixe commençant à `debut`. Chaque appel récursif porte sur un suffixe strictement plus court. La @cs10-rec justifie les deux branches, et le suffixe vide est accepté.
        ]),
        question([Évaluer le nombre d'appels à `dans_l` dans le pire cas. Donner un majorant atteint dans un cas explicite.], solution: [
          Pour un suffixe de taille $n ≥ 1$, on fait un test sur le suffixe entier, puis au plus un test et un appel récursif pour chaque préfixe propre non vide.
          Ainsi $c(1) = 1$ et
          $ c(n) ≤ n + sum_(k = 1)^(n - 1) c(k) = 2^n - 1. $
          Cette borne est atteinte pour $L = {a}^*$ et le mot $a^(n - 1) b$ : chaque préfixe propre testé est dans $L$, mais tous les suffixes se terminent par $b$ et sont rejetés. Toutes les branches sont donc explorées.
        ]),
      )),
      partie("II.C", "Une programmation dynamique", contenu: (
        [Soit $L$ un langage sur $A$ et $m = m_0 ⋯ m_(n - 1) ∈ A^*$. Pour $0 ≤ i ≤ j ≤ n - 1$, on définit $T_(i, j)$ comme le booléen valant `true` si $m_i ⋯ m_j ∈ L^*$, et `false` sinon. Pour $n ≥ 1$, on a $m ∈ L^*$ si et seulement si $T_(0, n - 1)$ vaut `true`. Le cas $n = 0$ sera traité séparément.],
        question([Soit $i ∈ ⟦0, n - 1⟧$. Que vaut $T_(i, i)$ ?], solution: [Une lettre ne peut se décomposer en plusieurs facteurs non vides. Ainsi $T_(i, i)$ vaut `true` si et seulement si le mot d'une lettre $m_i$ appartient à $L$.]),
        question([Montrer que pour $0 ≤ i < j ≤ n - 1$ :
          $ T_(i, j) = (m_i ⋯ m_j ∈ L) ∨ (or.big_(k = i)^(j - 1) (T_(i, k) ∧ T_(k + 1, j))). $
          Les symboles $∨$ et $∧$ désignent le ou et le et logiques.], solution: [
          Un facteur dans $L$ est dans $L^*$. La concaténation de deux facteurs dans $L^*$ y appartient aussi.
          Réciproquement, une décomposition de $m_i ⋯ m_j ∈ L^*$ en facteurs non vides comporte soit un seul facteur, dans $L$, soit au moins deux facteurs. Une coupure après le premier donne l'un des termes de la disjonction.
        ]),
        question([En déduire un algorithme pour calculer tous les $T_(i, j)$.], solution: [On remplit les cases par taille croissante $j - i + 1$. Les deux sous-facteurs utilisés dans la récurrence sont strictement plus courts, donc leurs valeurs sont déjà calculées. On commence par les facteurs d'une lettre.]),
        question([Programmer cet algorithme pour déterminer si $m ∈ L^*$ en calculant tous les $T_(i, j)$.], solution: [
          #extrait("dans_l_etoile_3")
          La case `t.(i).(j)` représente directement $T_(i, j)$. Chaque ligne du tableau est distincte. Le cas vide est traité avant tout accès à la table.
        ]),
        question([Évaluer la complexité temporelle en distinguant le nombre d'appels au test d'appartenance à $L$ du nombre d'opérations élémentaires, telles qu'un ou ou un et logique.], solution: [
          Il y a exactement $n(n + 1) / 2$ appels à `dans_l`, un par facteur non vide. Le nombre de coupures examinées est au plus
          $ sum_(ℓ = 1)^n (n - ℓ + 1)(ℓ - 1) = n(n - 1)(n + 1) / 6. $
          Le nombre d'opérations élémentaires est donc $O(n^3)$. Les copies par `String.sub` coûtent aussi $O(n^3)$ au total.
          Si le coût du test de $L$ est majoré par un polynôme croissant $P$, le temps global est $O(n^3 + n^2 P(n))$. Cela prouve déjà le résultat annoncé.
        ]),
        question([Évaluer la complexité spatiale. Comparer aux deux autres solutions de cette partie.], solution: [
          La table contient $n^2$ booléens, donc l'espace auxiliaire est $O(n^2)$, hors oracle. Les facteurs extraits demandent au plus $O(n)$ supplémentaires à un instant donné.
          L'énumération et la récursion utilisent $O(n)$ d'espace auxiliaire, mais leur temps peut être exponentiel. La programmation dynamique évite de recalculer les mêmes sous-problèmes.
        ]),
      )),
    )),
    partie("III", "Utilisation d'un graphe", contenu: (
      partie("III.A", "Structure de file", contenu: (
        [Une _file_ est une structure FIFO (« first in, first out ») : les éléments en sortent dans leur ordre d'entrée. On choisit le type suivant :
          #extrait("fifo")
          Les éléments présents sont les cases d'indices compris entre `debut` et `fin`, bornes incluses. La taille maximale du tableau est fixée à la création.
          Pour entrer un élément, on incrémente `fin` puis on écrit dans la case correspondante. Pour sortir un élément, on lit la case `debut` puis on incrémente `debut`.
          Les signatures sont `put : int -> fifo -> unit` et `get : fifo -> int`.
          On dispose de `creer_file : int -> fifo`, initialisant `debut` à 0 et `fin` à −1, et de `est_vide : fifo -> bool`, qui teste `debut > fin`.
          Dans un premier temps, on suppose que le nombre total d'entrées reste inférieur à la capacité du tableau. On n'appelle `get` que sur une file non vide.],
        question([Écrire les fonctions `put` et `get` répondant à ces spécifications.], solution: [
          #extrait(("put", "get"))
          Chaque opération utilise un nombre constant d'accès et d'opérations arithmétiques.
        ]),
        question([Comment modifier ces fonctions si le nombre total d'éléments entrés peut dépasser la taille du tableau, mais que le nombre d'éléments présents à chaque instant reste strictement inférieur à cette taille ?], solution: [
          On réutilise les cases circulairement, en gardant les compteurs croissants. Seuls les accès au tableau sont effectués modulo sa capacité.
          #extrait(("put_circulaire", "get_circulaire"))
          Le test `debut > fin` reste valide. Réduire également les compteurs modulo la capacité imposerait de changer ce test et de distinguer les états plein et vide. On suppose ici, comme pour les autres indices, que les compteurs restent représentables.
        ]),
      )),
      partie("III.B", "Introduction d'un graphe orienté", contenu: (
        [Un _graphe orienté_ est un couple $(S, A_G)$, où $S$ est un ensemble fini de _sommets_ et $A_G ⊂ S × S$ l'ensemble des _arcs_. Un chemin de $d$ à $f$ est une suite finie $s_0, …, s_r$ avec $s_0 = d$, $s_r = f$ et $(s_k, s_(k + 1)) ∈ A_G$ pour $0 ≤ k < r$.
          Pour $w = w_0 ⋯ w_(n - 1) ∈ A^*$, on définit $G_L(w) = (S, A_G)$ par
          $ S = ⟦-1, n - 1⟧, #sep A_G = {(i, j) ∈ S × S | i < j " et " w_(i + 1) ⋯ w_j ∈ L}. $
          Les arcs localisent les facteurs de $w$ appartenant à $L$. L'appartenance de $w$ à $L^*$ équivaut à l'existence d'un chemin de $-1$ à $n - 1$ dans ce graphe. On ne demande pas de justifier ce fait.],
        question([Pour $A = {a, b}$ et $L = {a}^* {b}^* = {a^i b^j | (i, j) ∈ ℕ^2}$, le graphe $G_L(a b a a b a)$ est le suivant :
          #exemple
          Chaque arc $(i, j)$ est étiqueté par le facteur $w_(i + 1) ⋯ w_j ∈ L$ qui le justifie. Représenter $G_(L_0)(a a b b a b a)$, où $L_0 = {a^k b^k | k ∈ ℕ}$.], solution: [
          Les seuls facteurs non vides dans $L_0$ sont $w_0 ⋯ w_3 = a a b b$, $w_1 w_2 = a b$ et $w_4 w_5 = a b$.
          #graphe-l0
          Les arcs sont donc exactement $(-1, 3)$, $(0, 2)$ et $(3, 5)$. Le sommet $6$ est isolé, et le mot n'appartient pas à $L_0^*$.
        ]),
        [On revient au cas général. Pour déterminer l'accessibilité de $n - 1$ depuis $-1$, on effectue un parcours en largeur. La file contient les sommets détectés accessibles mais non encore traités. Le tableau `vus` mémorise les sommets accessibles. Pour $n ≥ 1$, le pseudocode est :
          ```text
          initialiser tous les vus[i] a false
          entrer -1 dans la file
          tant que la file n'est pas vide et que n - 1 n'a pas ete vu :
            enlever un sommet s de la file
            pour i allant de s + 1 a n - 1 :
              si (i n'a pas deja ete vu) et (w[s + 1..i] appartient a L) :
                vus[i] <- true
                entrer i dans la file
          ```
          On admet qu'à la fin, `vus[n - 1]` vaut `true` si et seulement si $n - 1$ est accessible depuis $-1$.],
        question([Écrire une nouvelle fonction testant l'appartenance d'un mot à l'étoile d'un langage en appliquant cet algorithme.], solution: [
          #extrait("dans_l_etoile_4")
          Le graphe reste implicite : on teste un arc seulement lorsqu'il est utile. Chaque sommet est enfilé au plus une fois. Avec le sommet initial $-1$, il y a au plus $n + 1$ insertions, d'où la capacité choisie. Le cas vide correspond au chemin vide et est accepté immédiatement.
        ]),
        question([Évaluer la complexité dans le pire cas, en distinguant les accès au test d'appartenance des opérations élémentaires.], solution: [
          Il y a au plus $n + 1$ sommets traités et au plus $n$ candidats inspectés par sommet, donc $O(n^2)$ appels à `dans_l` et $O(n^2)$ opérations de gestion du parcours.
          Le graphe n'est pas mémorisé : le tableau et la file occupent $O(n)$ d'espace auxiliaire, hors oracle.
          Dans ce code, `String.sub` copie le facteur en temps proportionnel à sa taille. Le total des copies est majoré par $O(n^3)$ et le temps total par $O(n^3 + n^2 P(n))$ pour un majorant croissant $P$ du test de $L$.
          Si l'oracle travaille directement sur un mot et deux indices, sans copie, on retrouve $O(n^2 + n^2 P(n))$.
        ]),
        question([Faire le bilan comparé des quatre algorithmes. Aller si possible au-delà de « celui-ci est plus rapide que celui-là ».], solution: [
          Pour $n ≥ 1$, les majorants suivants séparent la gestion de l'algorithme du coût du test d'un facteur et de son extraction :
          #align(center, table(
            columns: (auto, auto, auto, auto),
            table.header([Algorithme], [Espace auxiliaire], [Appels à `dans_l`], [Gestion]),
            [Énumération], [$O(n)$], [$O(n 2^n)$], [$O(n 2^n)$],
            [Récursion], [$O(n)$], [$2^n - 1$], [$O(2^n)$],
            [Table dynamique], [$O(n^2)$], [$O(n^2)$], [$O(n^3)$],
            [Parcours en largeur], [$O(n)$], [$O(n^2)$], [$O(n^2)$],
          ))
          Les deux premières méthodes réexplorent des décompositions et peuvent demander un temps exponentiel. Les deux dernières prouvent que l'étoile d'un langage polynomial est polynomiale.
          Le parcours en largeur implicite réduit ici la mémoire et les opérations de gestion. Avec des chaînes copiées, les deux méthodes polynomiales ont toutefois la même borne $O(n^3 + n^2 P(n))$. Avec des facteurs représentés sans copie, le parcours évite le terme cubique de la récurrence à deux sous-facteurs.
          Si le coût de l'oracle domine les autres opérations, cette différence peut ne pas changer l'ordre du temps total. Enfin, pour un langage régulier fixé, un automate de son étoile permet un test linéaire en la taille du mot.
        ]),
      )),
    )),
  ),
)

#show: feuille.with(
  type: "devoir",
  titre: ex.meta.titre,
  niveau: ex.meta.niveaux.join(" / "),
  concours: ex.meta.concours,
  exercices: (ex,),
  corrige: sys.inputs.at("corrige", default: "false") == "true",
)
