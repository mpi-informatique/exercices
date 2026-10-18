#import "/load.typ": code
#import code: code-extrait
#import "/load.typ": exercice, question
#import "/load.typ": sep

#let code = code-extrait.with(read("corrige.ml"))

#let ex = exercice(
  meta: (
    titre: "Grammaires linéaires",
    chapitres: ("grammaires-non-contextuelles", "langages-reguliers", "automates-finis", "algorithmique"),
    algorithmes: ("programmation-dynamique",),
    structures: ("tableau", "liste"),
    langages: ("OCaml",),
    difficulte: 3,
    niveaux: ("MPI",),
    duree: (1, 15),
  ),
  contenu: (
    [
      Une grammaire non-contextuelle $G = (Σ, V, R, S)$ est dite linéaire si le membre droit de chaque règle contient au plus une occurrence de variable.
      Ses règles sont donc de la forme $X → u Y v$ ou $X → w$, avec $X, Y ∈ V$ et $u, v, w ∈ Σ^*$.
      Le mot vide est noté $ε$ et $L(G) = {w ∈ Σ^* | S ⇒^* w}$.

      On cherche à comprendre ce que cette restriction apporte à la reconnaissance des mots.
      Toutes les réponses doivent être justifiées.
    ],
    question(
      [
        Montrer que les langages engendrés par les grammaires dont les règles sont uniquement de la forme $X → a Y$ ou $X → ε$, avec $a ∈ Σ$, sont exactement les langages réguliers.
      ],
      solution: [
        À une telle grammaire, on associe l'automate non déterministe d'états $V$, d'état initial $S$ et d'états finaux les $X$ tels que $X → ε ∈ R$.
        Chaque règle $X → a Y$ donne une transition de $X$ vers $Y$ étiquetée $a$.
        Une dérivation terminale correspond exactement à un chemin partant de $S$, suivi d'une règle d'effacement dans son dernier état.
        Les deux langages sont donc égaux, et le théorème de Kleene conclut.

        Réciproquement, soit un automate déterministe reconnaissant un langage régulier.
        On prend une variable par état, l'état initial pour axiome, une règle $p → a q$ pour chaque transition de $p$ vers $q$ étiquetée $a$, et $f → ε$ pour chaque état final $f$.
        La même correspondance prouve que cette grammaire engendre le langage voulu.
      ],
    ),
    question(
      [
        Sur $Σ = {a, b}$, on considère la grammaire d'axiome $S$ donnée par
        $ S → a T ∣ ε, #sep T → S b $
        Déterminer son langage et montrer qu'il n'est pas régulier.
        Que se passe-t-il donc si l'on autorise simultanément les règles $X → a Y$ et $X → Y a$ ?
      ],
      solution: [
        Tant qu'on ne termine pas, les règles sont appliquées par paires :
        $S ⇒ a T ⇒ a S b$.
        Après $k$ paires, on obtient $a^k S b^k$ ; la règle $S → ε$ termine.
        Toute dérivation terminale est de cette forme et chaque $k ∈ ℕ$ est possible.
        Ainsi $L(G) = {a^k b^k | k ∈ ℕ}$.

        Si ce langage était régulier, le lemme de l'étoile fournirait un entier $p ≥ 1$.
        Le mot $a^p b^p$ se décomposerait en $x y z$, avec $abs(x y) ≤ p$, $abs(y) ≥ 1$ et $x y^k z ∈ L(G)$ pour tout $k ∈ ℕ$.
        Nécessairement $y = a^t$ pour un $t ≥ 1$, donc $x z = a^(p-t) b^p ∉ L(G)$ : contradiction.

        Autoriser les deux orientations dans une même grammaire permet donc d'engendrer des langages non réguliers, même si chaque règle n'ajoute qu'une lettre.
      ],
    ),
    question(
      [
        Montrer que toute forme obtenue par dérivation depuis l'axiome d'une grammaire linéaire contient au plus une variable.
        Un élève en déduit qu'une grammaire linéaire est nécessairement non ambiguë.
        A-t-il raison ?
      ],
      solution: [
        L'axiome contient une variable.
        Une étape remplace l'unique variable présente par un mot qui en contient au plus une, d'où le résultat par récurrence sur le nombre d'étapes.

        Cela ne garantit pas l'unicité du choix de la règle.
        La grammaire $S → a S ∣ S a ∣ ε$ est linéaire, mais le mot $a$ admet les deux dérivations $S ⇒ a S ⇒ a$ et $S ⇒ S a ⇒ a$.
        Les arbres sont distincts : à la racine, la lettre $a$ se trouve respectivement avant et après le fils étiqueté $S$.
        Les deux dérivations sont gauches, puisqu'il n'y a jamais deux variables entre lesquelles choisir.
        Cette grammaire est donc ambiguë.
      ],
    ),
    [
      On considère désormais une grammaire dont les règles ont les trois formes
      $ X → ε, #sep X → a Y, #sep X → Y a, $
      où $a$ est une lettre. En particulier, les règles $X → Y$ sont exclues.
      On note $m = abs(V) ≥ 1$ et $r = abs(R)$.

      Soit $w = w_0 … w_(n-1)$ le mot à reconnaître.
      Pour $0 ≤ i ≤ j ≤ n$, on note $w[i:j]$ son facteur allant de l'indice $i$ inclus à l'indice $j$ exclu ; $w[i:i] = ε$.
      On définit le booléen $D(X,i,j)$ par
      $ D(X,i,j) = "vrai" quad ⇔ quad X ⇒^* w[i:j]. $
    ],
    question(
      [
        Exprimer $D(X,i,i)$, puis donner une relation de récurrence pour $D(X,i,j)$ lorsque $i < j$.
        En déduire un ordre de calcul permettant de décider si $w ∈ L(G)$.
        Justifier la correction de cette méthode.
      ],
      solution: [
        Aucune règle contenant une lettre ne peut produire le mot vide, donc $D(X,i,i)$ est vrai exactement lorsque $X → ε ∈ R$.
        Pour $i < j$, on a
        $
          D(X,i,j) ⇔
          (⋁_(X → a Y ∈ R) (w_i = a ∧ D(Y,i+1,j)))
          ∨ (⋁_(X → Y a ∈ R) (w_(j-1) = a ∧ D(Y,i,j-1))).
        $
        Une disjonction vide vaut faux.

        En effet, la première règle d'une dérivation non vide ajoute soit la première, soit la dernière lettre du mot. La variable restante doit engendrer exactement le facteur obtenu en supprimant cette lettre.
        Réciproquement, chaque terme vrai de la disjonction fournit une première règle
        et une dérivation du facteur restant, donc une dérivation du mot voulu.

        Les facteurs utilisés à droite ont pour taille $j-i-1$.
        On remplit donc la table par tailles croissantes, de $0$ à $n$.
        Une récurrence sur la taille, avec le cas vide ci-dessus, prouve la correction de toutes les cases. La réponse est $D(S,0,n)$.
      ],
    ),
    [
      En OCaml, les variables sont numérotées de $0$ à $m-1$ et la grammaire est un tableau de listes : la case d'indice $x$ contient les règles de membre gauche $x$.
      On utilise les types suivants :
      #code(("regle", "grammaire"))
      Dans la liste de $x$, ```ocaml Vide``` représente $X → ε$,
      ```ocaml Prefixe (a, y)``` représente $X → a Y$ et
      ```ocaml Suffixe (y, a)``` représente $X → Y a$.
      On suppose tous les indices de variables valides.

      On pourra utiliser ```ocaml Array.init k f```, qui construit un tableau
      dont la case d'indice $i$ contient le résultat de l'appel ```ocaml f i```,
      pour $0 ≤ i < k$.
      Des appels distincts à ```ocaml Array.make``` créent des tableaux indépendants.
    ],
    question(
      [
        Écrire une fonction ```ocaml reconnait : grammaire -> int -> string -> bool```
        qui reçoit la grammaire, l'indice de son axiome et un mot, et applique la méthode précédente.
        Utiliser une table booléenne à trois indices, sans créer de sous-chaînes.
        Le mot vide doit être traité.
      ],
      solution: [
        #code("reconnait")
        Les tableaux internes sont créés séparément pour éviter tout partage de cases modifiables.
        Les gardes ```ocaml i < j``` protègent les accès aux lettres et aux facteurs plus courts.
        La fonction locale parcourt les règles jusqu'à en trouver une convenable, ou renvoie faux.
        Le remplissage suit exactement l'ordre démontré à la question précédente, y compris pour $n = 0$.
      ],
    ),
    question(
      [
        Justifier les complexités temporelle et spatiale en fonction de $m$, $r$ et $n$.
        Si l'on veut seulement une réponse booléenne, expliquer comment ramener l'espace de stockage de la table à $O(m(n+1))$, sans changer l'ordre de grandeur du temps.
      ],
      solution: [
        La table allouée contient $m(n+1)^2$ booléens ; son initialisation coûte $O(m(n+1)^2)$ en temps et en espace.
        Il y a $(n+1)(n+2)/2$ intervalles $[i,j[$.
        Pour chacun, le parcours des $m$ variables examine au plus $r$ règles au total, chacune en temps constant. Le temps total est donc $O((m+r)(n+1)^2)$, quadratique en la taille du mot lorsque la grammaire est fixée.
        La mémoire auxiliaire est $O(m(n+1)^2)$, hors grammaire et mot d'entrée.
        Les appels récursifs parcourant les règles sont terminaux.

        Pour une taille $ℓ$, on ne lit que des valeurs correspondant à $ℓ-1$.
        Il suffit de deux tableaux indépendants de taille $m × (n+1)$, indexés par la variable et le début du facteur.
        On initialise le premier pour les facteurs vides.
        Pour calculer le facteur $w[i:i+ℓ]$, une règle $X → a Y$ consulte la case $(Y,i+1)$ du tableau précédent, et une règle $X → Y a$ sa case $(Y,i)$.
        On écrit toutes les cases utiles du second tableau avant d'échanger les deux tableaux.
        On ne doit pas écraser une case de la taille précédente pendant son utilisation.

        On conserve le même nombre de calculs et on utilise $O(m(n+1))$ cases.
        Après la taille $n$, la réponse se lit à l'axiome, à l'indice $0$.
      ],
    ),
    question(
      [
        Pour conclure, montrer que toute grammaire linéaire peut être transformée en une grammaire engendrant le même langage et n'utilisant que les trois formes précédentes.
        On pourra commencer par supprimer les règles $X → Y$, appelées règles unitaires, en tenant compte des chaînes et des cycles de telles règles.
        En déduire une borne de reconnaissance pour toute grammaire linéaire fixée.
      ],
      solution: [
        Pour chaque variable $X$, on calcule l'ensemble $U(X)$ des variables accessibles depuis $X$ par zéro ou plusieurs règles unitaires ; il contient donc $X$.
        Un parcours avec un ensemble de variables déjà visitées termine même en présence de cycles.
        Pour chaque $Y ∈ U(X)$ et chaque règle non unitaire $Y → α$, on ajoute $X → α$, puis on supprime toutes les règles unitaires.

        Toute dérivation terminale de la grammaire initiale se décompose en suites de règles unitaires suivies d'une règle non unitaire : on contracte chaque suite en une règle ajoutée.
        Réciproquement, chaque règle ajoutée se développe en une telle suite.
        Les langages sont donc égaux, même si certains cycles unitaires n'aboutissent à aucun mot.

        Il reste à décomposer les règles longues, avec des variables intermédiaires
        nouvelles, propres à chaque règle.
        Pour $X → u Y v$, on émet d'abord les lettres de $u$ de gauche à droite avec des règles de préfixe, puis les lettres de $v$ de droite à gauche avec des règles de suffixe, la dernière règle laissant la variable $Y$.
        Par exemple, $X → a b Y c d$ est remplacée par
        $ X → a A, #sep A → b B, #sep B → C d, #sep C → Y c $
        Comme la règle initiale n'était pas unitaire, $abs(u)+abs(v) ≥ 1$ :
        aucune règle unitaire n'est nécessaire.
        Les cas $u = ε$ ou $v = ε$ utilisent seulement l'une des deux orientations.

        Pour $X → a_1 … a_k$ avec $k ≥ 1$, on introduit $Z_1,…,Z_k$ et les règles
        $
          X → a_1 Z_1, #sep Z_1 → a_2 Z_2, #sep …, #sep
          Z_(k-1) → a_k Z_k, #sep Z_k → ε,
        $
        en ne gardant que $X → a_1 Z_1$ et $Z_1 → ε$ si $k=1$.
        Les règles $X → ε$ sont conservées.
        Chaque chaîne nouvelle simule exactement la règle remplacée ; aucune autre règle ne part de ses variables intermédiaires.

        La transformation est finie et ne dépend pas du mot à reconnaître.
        Pour une grammaire initiale fixée, les nombres de variables et de règles après transformation sont donc des constantes.
        On obtient un temps $O((n+1)^2)$ et, avec les deux tableaux, un espace auxiliaire $O(n+1)$.
      ],
    ),
  ),
)
