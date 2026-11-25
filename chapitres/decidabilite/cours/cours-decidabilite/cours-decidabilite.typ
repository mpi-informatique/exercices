#import "/load.typ": (
  colonnes-cours, cours-et-presentation, est-presentation, liste-cours, pb, slide, slides-only, solution, tableau,
  taille-presentation, theoremes,
)
#import theoremes: definition, exercice, methode, probleme, theoreme

#show: cours-et-presentation.with(titre: "Décidabilité", niveau: "MPI")

= Problèmes de décision

#definition(coeur: true)[Problème de décision][
  Un _problème de décision_ est un couple $(I, I^+)$ où $I$ est l'ensemble des _instances_ et $I^+ ⊂ I$ l'ensemble des _instances positives_, pour lesquelles la réponse est « oui ».
]
On définit souvent $I^+$ par une question binaire sur les instances. Toute instance $x$ (entier, graphe, formule, programme…) est _encodée_ par un mot fini $⟨x⟩$ sur un alphabet fini $Σ$ : on peut donc voir un problème de décision comme le langage ${⟨x⟩ ∣ x ∈ I^+} ⊂ Σ^*$.

Dans toute la suite, $Π = (I, I^+)$ désigne un problème de décision.

#slide()
#colonnes-cours(
  [
    #probleme[SAT][
      - Instance : une formule propositionnelle $φ$.
      - Question : $φ$ est-elle satisfiable ?
    ]
    $I$ = ensemble des formules propositionnelles.\
    $I^+$ = ensemble des formules satisfiables.
  ],
  [
    #probleme[APPARTIENT][
      - Instance : un mot $m$ et un automate $A$.
      - Question : $m ∈ cal(L)(A)$ ?
    ]
    $I = {(m, A) ∣ m ∈ Σ^*, thick A "est un automate"}$.\
    $I^+ = {(m, A) ∈ I ∣ m ∈ cal(L)(A)}$.
  ],
)

= Algorithme

#definition(coeur: true)[Algorithme][
  Un _algorithme_ est une suite finie d'instructions qui s'applique à une entrée finie, avec une mémoire disponible illimitée.\
  Sur une entrée donnée, l'algorithme peut _terminer_ (renvoyer un résultat), s'arrêter sur une erreur ou s'exécuter indéfiniment.
]
#v(-.4em)
#definition[Programme][
  Un _programme_ est l'implémentation d'un algorithme dans un langage de programmation (OCaml, C...), encodée comme un mot fini appelé _code source_.
]

#slide()
#taille-presentation(17pt)[
  On peut formaliser la notion d'algorithme par une machine de Turing munie d'un ruban infini de cases (contenant l'entrée complétée par des blancs $□$) et d'une tête de lecture/écriture guidée par un état interne :
  #v(-.5em)
  #definition(hp: true)[Machine de Turing][
    Une _machine de Turing_ est un $8$-uplet $M = (Q, Σ, Γ, □, q_0, q_"oui", q_"non", δ)$ où :
    - $Q$ est un ensemble fini d'états, contenant un état initial $q_0$ et deux états d'arrêt distincts $q_"oui"$ et $q_"non"$
    - $Σ$ (alphabet d'entrée) et $Γ$ (alphabet du ruban) sont finis avec $Σ ⊂ Γ$ et $□ ∈ Γ ∖ Σ$
    - $δ : Q × Γ ⟶ Q × Γ × {-1, +1}$ (déterministe) ou $δ : Q × Γ ⟶ cal(P)(Q × Γ × {-1, +1})$ (non-déterministe)
    Dans la configuration $(q, i)$ avec $a ∈ Γ$ en case $i$, $M$ applique $(q', b, d) ∈ δ(q, a)$, écrit $b$ en case $i$, se déplace en $i + d$ et passe en $q'$. Le calcul s'arrête dès que $q_"oui"$ (acceptation) ou $q_"non"$ (rejet) est atteint.
  ]
]

La _thèse de Church-Turing_ affirme que tout modèle de calcul raisonnable (OCaml, C, machines de Turing, $λ$-calcul…) définit les mêmes fonctions calculables et les mêmes problèmes décidables.

= Décidabilité

#definition(coeur: true)[Problème décidable][
  $Π = (I, I^+)$ est un _problème décidable_ s'il existe un algorithme qui, pour tout $i ∈ I$, termine et renvoie `true` si $i ∈ I^+$ et `false` sinon. En l'absence d'un tel algorithme, il est _indécidable_.
]

Pour montrer qu'un problème est décidable, il suffit d'exhiber un algorithme (ou programme) qui termine sur toutes les instances et répond correctement, quelle que soit sa complexité.

#slide()
#underline[Exemples] :
- #pb("SAT") est décidable : on teste les $2^n$ valuations des $n$ variables de $φ$.
- #pb("APPARTIENT") est décidable : on lit $m$ dans $A$ en maintenant l'ensemble des états atteints.
- Si $I^+$ est fini alors $Π$ est décidable, en testant l'égalité de l'instance avec chaque élément de $I^+$ (stocké en dur).

#slide()
#exercice[Décidabilité non constructive][
  #probleme(pause: false)[SEPT-DANS-PI][
    - Instance : un entier $k ∈ NN$.
    - Question : existe-t-il $k$ chiffres $7$ consécutifs dans le développement décimal de $π$ ?
  ] <pb-sept-pi>
  Montrer que @pb-sept-pi est décidable.
][
  On distingue deux cas, sans avoir besoin de savoir lequel est réalisé :
  - Si pour tout $k ∈ NN$ il existe $k$ chiffres $7$ consécutifs dans le développement décimal de $π$, alors $I^+ = NN$ et l'algorithme qui renvoie toujours `true` décide @pb-sept-pi.
  - Sinon, il existe un plus grand entier $k_max ∈ NN$ tel que $k_max$ chiffres $7$ consécutifs apparaissent dans $π$. Alors $I^+ = {0, …, k_max}$ est fini et l'algorithme qui renvoie `k <= k_max` décide @pb-sept-pi.
  Dans les deux cas, il existe un algorithme qui décide @pb-sept-pi, même si l'on ne sait pas aujourd'hui lequel.
]

#slides-only[== Semi-décidabilité]

#definition(hp: true)[Problème semi-décidable][
  $Π = (I, I^+)$ est un _problème semi-décidable_ s'il existe un algorithme qui, pour tout $i ∈ I$, termine et renvoie `true` si $i ∈ I^+$, et renvoie `false` ou ne termine pas si $i ∉ I^+$.
]
#underline[Remarque] : tout problème décidable est semi-décidable.

#exercice[Existence de problèmes indécidables][
  Par un argument de dénombrement, montrer qu'il existe des problèmes qui ne sont pas semi-décidables (et donc pas décidables).
][
  Un programme est un mot fini sur un alphabet fini $Σ$. Comme $Σ^* = union.big_(n ∈ NN) Σ^n$ est une union dénombrable d'ensembles finis, l'ensemble des programmes est dénombrable. Or l'ensemble des problèmes de décision $(NN, E)$ pour $E ⊂ NN$ est en bijection avec $cal(P)(NN)$, qui n'est pas dénombrable. Comme un même programme ne peut pas semi-décider deux problèmes $(NN, E)$ et $(NN, E')$ avec $E ≠ E'$ (l'ensemble des entrées sur lesquelles il renvoie `true` détermine $E$), il existe des problèmes qui ne sont pas semi-décidables, et a fortiori indécidables.
]

#slide()
#exercice[Complémentaire d'un problème][
  On note $overline(Π) = (I, I ∖ I^+)$ le _problème complémentaire_ de $Π = (I, I^+)$.
  + Montrer que $Π$ est décidable si et seulement si $overline(Π)$ est décidable.
  + Montrer que $Π$ est décidable si et seulement si $Π$ et $overline(Π)$ sont tous deux semi-décidables.
][
  + Si $A$ décide $Π$, l'algorithme qui exécute $A(i)$ puis renvoie sa négation termine toujours et décide $overline(Π)$. La réciproque s'obtient de même puisque $overline(overline(Π)) = Π$.
  + Si $Π$ est décidable alors $Π$ et $overline(Π)$ sont décidables, donc semi-décidables. Réciproquement, soient $A_1$ un semi-décideur de $Π$ et $A_2$ un semi-décideur de $overline(Π)$. Sur une instance $i ∈ I$, on simule $A_1(i)$ et $A_2(i)$ en parallèle (en alternant une étape de chaque calcul) : on renvoie `true` dès que $A_1(i)$ termine en renvoyant `true`, et `false` dès que $A_2(i)$ termine en renvoyant `true`. Comme $i ∈ I^+$ ou $i ∈ I ∖ I^+$, l'un des deux termine forcément en renvoyant `true`, donc cet algorithme décide $Π$.
] <ex-complementaire>

#slide()
#exercice[Union et intersection][
  Soient $Π_1 = (I, I_1^+)$ et $Π_2 = (I, I_2^+)$ deux problèmes de décision.
  + Montrer que si $Π_1$ et $Π_2$ sont décidables alors $(I, I_1^+ ∩ I_2^+)$ et $(I, I_1^+ ∪ I_2^+)$ sont décidables.
  + Montrer que si $Π_1$ et $Π_2$ sont semi-décidables alors $(I, I_1^+ ∩ I_2^+)$ et $(I, I_1^+ ∪ I_2^+)$ sont semi-décidables.
][
  + Soient $A_1$ et $A_2$ des décideurs respectifs de $Π_1$ et $Π_2$. Sur $i ∈ I$, on exécute $A_1(i)$ puis $A_2(i)$ et on renvoie `A_1(i) && A_2(i)` pour l'intersection, ou `A_1(i) || A_2(i)` pour l'union.
  + Soient $A_1$ et $A_2$ des semi-décideurs respectifs de $Π_1$ et $Π_2$.
    - Pour l'intersection, on exécute $A_1(i)$ puis, s'il termine en renvoyant `true`, on exécute $A_2(i)$ et on renvoie son résultat.
    - Pour l'union, on simule $A_1(i)$ et $A_2(i)$ en parallèle (en alternant une étape de chaque calcul) et on renvoie `true` dès que l'un des deux termine en renvoyant `true`.
]

#slide()
#exercice[Semi-décidabilité et certificat][
  Montrer que $Π = (I, I^+)$ est semi-décidable si et seulement s'il existe un alphabet fini non vide $Σ$ et un algorithme $V$ qui termine toujours sur toute entrée $(i, c) ∈ I × Σ^*$ (_vérifieur_ d'un _certificat_ $c$) tels que :
  $ ∀ i ∈ I, thick i ∈ I^+ <==> ∃ c ∈ Σ^*, thick V(i, c) = #`true` $
][
  - ($==>$) Si $A$ semi-décide $Π$, on définit $V(i, c)$ en simulant $A(i)$ pendant au plus $|c|$ étapes : $V$ renvoie `true` si $A(i)$ termine en renvoyant `true` dans ce délai, et `false` sinon. Alors $V$ termine toujours et vérifie l'équivalence (pour $i ∈ I^+$ accepté en $n$ étapes, tout mot $c$ de longueur $n$ convient).
  - ($<==$) Réciproquement, on énumère les mots $c ∈ Σ^*$ par longueur croissante (et ordre lexicographique à longueur fixée) et on exécute $V(i, c)$ jusqu'à obtenir `true`. Si $i ∈ I^+$ alors un certificat finit par être trouvé, sinon l'algorithme ne termine jamais.
]

= Problème de l'arrêt

== Machine universelle

#definition[Machine universelle][
  Une _machine universelle_ est un programme $U$ qui prend en entrée le code source $f$ d'un programme et une entrée $x$, puis simule l'exécution de $f$ sur $x$ : $U(f, x)$ renvoie le même résultat que $f$ sur $x$, s'arrête sur une erreur si $f$ le fait, et ne termine pas si $f$ ne termine pas sur $x$.
] <def-machine-universelle>

#taille-presentation(17pt)[
  Un interpréteur (comme `utop` en OCaml ou `python`) est une machine universelle : il exécute n'importe quel programme fourni sous forme de texte. Puisque $U$ manipule le code source de $f$ comme une donnée, un programme peut recevoir son propre code en entrée, ou simuler une exécution pas à pas.\
  #underline[Attention] : la fonction OCaml `let applique f x = f x` reçoit une fonction déjà évaluée et n'est pas une machine universelle. Par commodité dans les preuves en OCaml, on s'autorisera toutefois à écrire `f x` au lieu de $U(f, x)$ et à passer directement une fonction au lieu de son code source.
]

== Problème de l'arrêt

#probleme[ARRET][
  - Instance : le code source $f$ d'un programme et une entrée $x$ pour ce programme.
  - Question : l'exécution de $f$ sur $x$ s'arrête-t-elle en temps fini ?
]

#theoreme(coeur: true)[Le problème #pb("ARRET") est indécidable.]

#solution[
  Supposons qu'un algorithme `arret` décide le problème. On définit alors le programme suivant, où `p` est le code d'un programme prenant un code en entrée.

  #colonnes-cours(
    columns: (1fr, 1.5fr),
    [
      ```ocaml
      let paradoxe p =
        let rec boucle () = boucle () in
        if arret p p then boucle ()
      ```
    ],
    [
      Soit $d$ le code de `paradoxe`. Exécutons `paradoxe` sur $d$.
      - Si `arret d d` renvoie `true`, l'exécution boucle et ne s'arrête pas.
      - Si `arret d d` renvoie `false`, l'exécution s'arrête immédiatement.
    ],
  )

  Dans les deux cas, `arret d d` renvoie une réponse fausse. L'algorithme `arret` ne peut donc pas exister.
]

#slide()
#exercice[Semi-décidabilité de l'arrêt et de son complémentaire][
  Le problème #pb("ARRET") et son complémentaire $overline(pb("ARRET"))$ sont-ils semi-décidables ?
][
  - #pb("ARRET") est semi-décidable : à l'aide d'une machine universelle $U$, on simule l'exécution de $f$ sur $x$ et on renvoie `true` dès que la simulation s'arrête (en OCaml : ```ocaml let semi_arret f x = try ignore (f x); true with _ -> true```, une erreur étant aussi un arrêt).
  - $overline(pb("ARRET"))$ n'est pas semi-décidable : sinon, #pb("ARRET") et $overline(pb("ARRET"))$ seraient tous deux semi-décidables, donc #pb("ARRET") serait décidable d'après @ex-complementaire, ce qui contredit le théorème précédent.
]

= Réductions

#slides-only[== Fonctions calculables et réductions]

#definition[Fonction calculable][
  Une fonction $f : E ⟶ F$ est _calculable_ s'il existe un algorithme qui, pour tout $x ∈ E$, termine et renvoie $f(x)$.
]

#slide()
#definition(coeur: true)[Réductions many-one et Turing][
  Soient $Π_1 = (I_1, I_1^+)$ et $Π_2 = (I_2, I_2^+)$ deux problèmes de décision.
  - $Π_1$ se _réduit many-one_ à $Π_2$, noté $Π_1 ≤_m Π_2$, s'il existe une fonction calculable $f : I_1 ⟶ I_2$ telle que :
  #v(-.5em)
  $ ∀ i ∈ I_1, thick i ∈ I_1^+ <==> f(i) ∈ I_2^+ $
  - $Π_1$ se _réduit au sens de Turing_ à $Π_2$, noté $Π_1 ≤_T Π_2$, si, en disposant d'un algorithme $A_2$ qui décide $Π_2$, on peut construire un algorithme $A_1$ qui décide $Π_1$ en effectuant un nombre fini d'appels à $A_2$.

  Lorsqu'il n'y a pas d'ambiguïté, on note simplement $Π_1 ≤ Π_2$.
] <def-reductions>

#slide()
Intuitivement, $Π_1 ≤ Π_2$ ($Π_1$ se réduit à $Π_2$) signifie que $Π_2$ est au moins aussi difficile que $Π_1$.

#exercice[Propriétés des réductions][
  + Montrer que les relations $≤_m$ et $≤_T$ sont réflexives et transitives.
  + Montrer que : $Π_1 ≤_m Π_2 ==> Π_1 ≤_T Π_2$.
][
  + La fonction identité $i ⟼ i$ (calculable) montre $Π ≤_m Π$, et un algorithme effectuant un unique appel à un décideur de $Π$ montre $Π ≤_T Π$.
    Pour la transitivité : si $f : I_1 ⟶ I_2$ réalise $Π_1 ≤_m Π_2$ et $g : I_2 ⟶ I_3$ réalise $Π_2 ≤_m Π_3$, alors $g ∘ f$ est calculable et réalise $Π_1 ≤_m Π_3$. De même pour $≤_T$, en remplaçant dans le décideur de $Π_1$ chaque appel au décideur de $Π_2$ par un algorithme appelant un nombre fini de fois un décideur de $Π_3$, on obtient un décideur de $Π_1$ n'effectuant qu'un nombre fini d'appels au décideur de $Π_3$.
  + Si $f : I_1 ⟶ I_2$ est calculable et vérifie $∀ i ∈ I_1, thick i ∈ I_1^+ <==> f(i) ∈ I_2^+$, et si $A_2$ décide $Π_2$, alors l'algorithme $A_1 = A_2 ∘ f$ effectue un unique appel à $A_2$ (sans en modifier le résultat) et décide $Π_1$, d'où $Π_1 ≤_T Π_2$.
]

#slide()

#exercice[][
  Montrer que $pb("ACCESSIBLE") ≤_m pb("CHEMIN")$.
  #colonnes-cours(
    align: top,
    [
      #probleme(pause: false)[ACCESSIBLE][
        - Instance : un graphe fini $G = (S, A)$ et $s, t ∈ S$.
        - Question : existe-t-il un chemin de $s$ à $t$ dans $G$ ?
      ]
    ],
    [
      #probleme(pause: false)[CHEMIN][
        - Instance : $G = (S, A)$, $s, t ∈ S$ et $k ∈ NN$.
        - Question : existe-t-il un chemin de $s$ à $t$ de longueur au plus $k$ ?
      ]
    ],
  )
][
  Si $G$ a $n$ sommets, la fonction calculable $(G, s, t) ⟼ (G, s, t, n - 1)$ convient : un chemin de longueur au plus $n - 1$ est un chemin et, réciproquement, tout chemin de $s$ à $t$ peut être raccourci en un chemin élémentaire d'au plus $n - 1$ arêtes.
]

#slides-only[== Transfert de la décidabilité et de la semi-décidabilité]

#theoreme(coeur: true)[Transfert de la décidabilité][
  Si $Π_1 ≤ Π_2$ (réduction Turing ou many-one), alors :
  #liste-cours(
    columns: 2,
    numerotee: false,
    [Si $Π_2$ est décidable alors $Π_1$ est décidable.],
    [Si $Π_1$ est indécidable alors $Π_2$ est indécidable.],
  )
]
#solution[
  Par définition de $Π_1 ≤_T Π_2$ (qui englobe $Π_1 ≤_m Π_2$), un décideur $A_2$ de $Π_2$ permet de construire un décideur $A_1$ de $Π_1$ (dans le cas many-one, $A_1 = A_2 ∘ f$). Le second énoncé est la contraposée du premier.
]
#methode(
  title: [Pour montrer que $Π$ est indécidable, il suffit de réduire à $Π$ un problème indécidable connu, par exemple $pb("ARRET") ≤ Π$.],
)[]
#underline[Attention] : ne pas se tromper de sens. Montrer $Π ≤ pb("ARRET")$ ne prouve rien sur $Π$.

#slide()
#exercice[Réductions et semi-décidabilité][
  + Montrer que si $Π_1 ≤_m Π_2$ et si $Π_2$ est semi-décidable alors $Π_1$ est semi-décidable (en déduire que si $Π_1$ n'est pas semi-décidable alors $Π_2$ ne l'est pas non plus).
  + Ce résultat reste-t-il vrai si l'on remplace $≤_m$ par $≤_T$ ?
][
  + Soient $f : I_1 ⟶ I_2$ réalisant $Π_1 ≤_m Π_2$ et $A_2$ un semi-décideur de $Π_2$. Sur $i ∈ I_1$, on calcule $f(i)$ (qui termine toujours) puis on exécute $A_2(f(i))$. Si $i ∈ I_1^+$ alors $f(i) ∈ I_2^+$ et $A_2(f(i))$ termine en renvoyant `true`. Sinon $f(i) ∉ I_2^+$ et $A_2(f(i))$ renvoie `false` ou ne termine pas. Le second énoncé est la contraposée.
  + Non. En effet, `let non_arret f x = not (arret f x)` montre $overline(pb("ARRET")) ≤_T pb("ARRET")$, alors que #pb("ARRET") est semi-décidable et $overline(pb("ARRET"))$ ne l'est pas.
]

#slides-only[== Exemples de problèmes indécidables]

#exercice[Arrêt sur l'entrée vide et équivalence][
  + Montrer que #pb("ARRET-VIDE") est indécidable ($pb("ARRET") ≤_m pb("ARRET-VIDE")$).
  + Montrer que #pb("EQUIVALENCE") est indécidable ($pb("ARRET") ≤_T pb("EQUIVALENCE")$).

  #colonnes-cours(
    align: top,
    [
      #probleme(pause: false)[ARRET-VIDE][
        - Instance : le code de ```ocaml g : unit -> 'a```.
        - Question : `g ()` s'arrête-t-il en temps fini ?
      ]
    ],
    [
      #probleme(pause: false)[EQUIVALENCE][
        - Instance : les codes de deux programmes $f_1$ et $f_2$.
        - Question : $f_1$ et $f_2$ ont-ils le même comportement sur toute entrée ?
      ]
    ],
  )

][
  + Supposons disposer d'une fonction `arret_vide` décidant #pb("ARRET-VIDE"). On définit :
    ```ocaml
    let arret f x =
      let g () = f x in
      arret_vide g
    ```
    La fonction `g` n'est pas exécutée lors de sa définition : on construit son code (via @def-machine-universelle) et on le passe à `arret_vide`. Comme `g ()` s'arrête si et seulement si `f x` s'arrête, on obtient $pb("ARRET") ≤_m pb("ARRET-VIDE")$, donc #pb("ARRET-VIDE") est indécidable.
  + Supposons disposer d'une fonction `equiv` décidant #pb("EQUIVALENCE"). On définit :
    ```ocaml
    let arret f x =
      let f1 () = ignore (f x) in
      let f2 () = while true do () done in
      not (equiv f1 f2)
    ```
    Comme `f2 ()` ne termine jamais, `f1` et `f2` sont équivalentes si et seulement si `f x` ne termine pas. Ainsi `arret` décide #pb("ARRET"), contradiction. Cette réduction est de Turing (et non many-one) à cause de la négation finale.
] <ex-equivalence>

#slide()
#exercice[#pb("EQUIVALENCE") n'est même pas semi-décidable][
  + Montrer que $overline(pb("ARRET")) ≤_m pb("EQUIVALENCE")$ et $pb("ARRET") ≤_m pb("EQUIVALENCE")$.
  + En déduire que ni #pb("EQUIVALENCE") ni $overline(pb("EQUIVALENCE"))$ ne sont semi-décidables.
][
  + La fonction $(f, x) ⟼ (f_1, f_2)$ de l'@ex-equivalence[!] (sans la négation finale) est calculable et vérifie : `f x` ne termine pas si et seulement si $(f_1, f_2) ∈ pb("EQUIVALENCE")$. Elle réalise donc $overline(pb("ARRET")) ≤_m pb("EQUIVALENCE")$.\
    En remplaçant `f2` par ```ocaml let f2 () = ()```, `f1` et `f2` sont équivalentes si et seulement si `f x` termine, d'où $pb("ARRET") ≤_m pb("EQUIVALENCE")$.
  + Comme $overline(pb("ARRET"))$ n'est pas semi-décidable, la première réduction montre que #pb("EQUIVALENCE") ne l'est pas. Une même fonction réalisant $Π_1 ≤_m Π_2$ réalise aussi $overline(Π_1) ≤_m overline(Π_2)$, donc la seconde réduction donne $overline(pb("ARRET")) ≤_m overline(pb("EQUIVALENCE"))$ et $overline(pb("EQUIVALENCE"))$ n'est pas semi-décidable.
]

#slide()
#theoreme(hp: true)[Théorème de Rice][
  On dit qu'une propriété sur les programmes est _sémantique_ si elle ne dépend que de la fonction calculée et _non triviale_ s'il existe un programme qui la vérifie et un autre qui ne la vérifie pas.\
  Toute propriété sémantique non triviale des programmes est indécidable.
]
#solution[
  Soit $P$ une telle propriété, supposée décidée par `decide_p`. Notons `loop` un programme qui ne termine jamais (`let rec loop y = loop y`). Comme $P$ est non triviale, il existe un programme `autre` tel que `decide_p autre <> decide_p loop`. On définit alors :
  ```ocaml
  let arret f x =
    let g y = ignore (f x); autre y in
    decide_p g <> decide_p loop
  ```
  Si `f x` termine alors `g` a la même sémantique que `autre`, sinon `g` a la même sémantique que `loop`. Ainsi `arret` décide #pb("ARRET"), absurde.
]

#underline[Exemples] :
- « $f$ renvoie-t-il $0$ sur $0$ ? » est une propriété sémantique non triviale (`fun _ -> 0` la vérifie, `fun _ -> 1` non), donc indécidable par le théorème de Rice.
- « $f$ termine-t-il en au plus $100$ étapes sur $0$ ? » n'est pas sémantique (deux programmes calculant la même fonction peuvent prendre un nombre différent d'étapes) : ce problème est décidable en simulant $f(0)$ pendant au plus $100$ étapes.

#slide()
Certains problèmes indécidables ne parlent pas de programmes, comme le _problème de correspondance de Post_ :
#probleme[PCP][
  - Instance : couples de mots $(u_1, v_1), …, (u_n, v_n)$ sur un alphabet $Σ$.
  - Question : existe-t-il $i_1, …, i_m$ ($m ≥ 1$) tels que $u_(i_1) … u_(i_m) = v_(i_1) … v_(i_m)$ ?
]
#theoreme(hp: true)[Post, 1946][Le problème #pb("PCP") est indécidable (admis).]

#slide()
#exercice[#pb("PCP") et #pb("AMBIGUÏTÉ")][
  + Montrer que $((a, b a a), (a b, a a), (b b a, b b))$ est une instance positive de #pb("PCP").
  + Montrer que #pb("AMBIGUÏTÉ") est indécidable.
  #probleme(pause: false)[AMBIGUÏTÉ][
    - Instance : une grammaire non contextuelle $G$.
    - Question : existe-t-il un mot ayant deux arbres de dérivation distincts dans $G$ ?
  ]
  #v(.5em)
][
  + La suite d'indices $(3, 2, 3, 1)$ convient :
    $ u_3 u_2 u_3 u_1 = b b a · a b · b b a · a = b b a a b b b a a = b b · a a · b b · b a a = v_3 v_2 v_3 v_1 $
  + Sur $Σ ∪ {a_1, …, a_n}$ (où les $a_i$ sont des lettres fraîches), on pose $S ⟶ U ∣ V$ et, pour chaque $i$, $U ⟶ u_i U a_i ∣ u_i a_i$ et $V ⟶ v_i V a_i ∣ v_i a_i$.
    Une dérivation issue de $U$ engendre $u_(i_1) … u_(i_m) a_(i_m) … a_(i_1)$ et une dérivation issue de $V$ engendre la forme analogue avec les $v_i$. Le suffixe de lettres fraîches fixe la suite d'indices, donc chaque branche admet au plus un arbre par mot. Deux arbres distincts existent exactement lorsqu'un même mot est dérivé par $U$ et par $V$, c'est-à-dire pour une solution de #pb("PCP"). Ainsi $pb("PCP") ≤_m pb("AMBIGUÏTÉ")$, donc #pb("AMBIGUÏTÉ") est indécidable.
]

#slide()
#underline[Autres problèmes indécidables] :
- 10#super[e] problème de Hilbert (Matiyasevich, 1970) : déterminer si une équation polynomiale à coefficients entiers (équation diophantienne) admet une solution entière.
- Grammaires non contextuelles : déterminer si $cal(L)(G_1) ∩ cal(L)(G_2) = ∅$, si $cal(L)(G) = Σ^*$ (universalité) ou si $cal(L)(G_1) = cal(L)(G_2)$ (équivalence).
- Matrices mortelles : déterminer s'il existe un produit fini (avec répétitions) de matrices carrées d'un ensemble fini donné égal à la matrice nulle.
