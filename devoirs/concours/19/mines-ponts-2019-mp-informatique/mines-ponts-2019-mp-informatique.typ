#import "/load.typ": code
#import code: code-extrait
#import "/load.typ": automate
#import automate: dessiner-automate, dist-lettre, rayon-etat, rayon-grand-etat
#import "/load.typ": exercice, partie, question
#import "/load.typ": sep
#import "@preview/cetz:0.4.2" as cetz

#let code = code-extrait.with(read("corrige.ml"))

#let dessiner = dessiner-automate.with(
  rayon: nom => if nom.contains(",") { rayon-grand-etat } else { rayon-etat },
)
#let a1 = dessiner(
  (("A", (0, 0), true, false), ("B", (3, 0), false, true)),
  (("A", "B", "a,b", (curve: 0.3)), ("B", "A", "a,b", (curve: 0.3))),
)
#let a2 = dessiner(
  (("C", (0, 0), true, false), ("D", (3, 0), false, true)),
  (
    ("C", "C", "a", (anchor: top)),
    ("D", "D", "a", (anchor: top)),
    ("C", "D", "b", (curve: 0.3)),
    ("D", "C", "b", (curve: 0.3)),
  ),
)
#let a3 = dessiner(
  (("E", (0, 0), true, false), ("F", (3, 0), false, false), ("G", (6, 0), false, true)),
  (
    ("E", "F", "a", (curve: 0)),
    ("E", "G", "b", (curve: -1.8)),
    ("F", "F", "a", (anchor: top)),
    ("G", "G", "a", (anchor: top)),
    ("F", "G", "b", (curve: 0.3)),
    ("G", "F", "b", (curve: 0.3)),
  ),
)
#let a4 = dessiner(
  (("H", (0, 0), true, false), ("I", (3, 2), false, false), ("J", (3, -2), false, true), ("K", (6, 0), false, true)),
  (
    ("H", "I", "a", (curve: 0.25)),
    ("I", "H", "a", (curve: 0.25)),
    ("H", "J", "b", (curve: 0.25)),
    ("J", "H", "b", (curve: 0.25)),
    ("I", "K", "b", (curve: 0.25)),
    ("K", "I", "b", (curve: 0.25)),
    ("J", "K", "a", (curve: 0.25)),
    ("K", "J", "a", (curve: 0.25)),
  ),
)
#let a5 = dessiner(
  (("L", (0, 0), true, false), ("M", (3, 0), false, true), ("N", (6, 0), false, false)),
  (
    ("L", "L", "a", (anchor: top)),
    ("L", "M", "b", (curve: 0.3)),
    ("M", "L", "b", (curve: 0.3)),
    ("M", "N", "a", (curve: 0.3)),
    ("N", "M", "a", (curve: 0.3)),
    ("N", "L", "b", (curve: 1.8)),
  ),
)
#let a6 = dessiner(
  (
    ("P", (0, 0), true, true),
    ("O", (4, 0), false, true),
    ("Q", (2, 3), false, false),
    ("R", (7, 2), false, false),
    ("S", (7, -2), false, false),
    ("T", (2, -3), false, false),
  ),
  (
    ("P", "P", "a", (anchor: top)),
    ("P", "Q", "b", (curve: 0, label: (dist: -dist-lettre))),
    ("O", "P", "a", (curve: 0)),
    ("O", "T", "b", (curve: 0)),
    ("Q", "R", "a", (curve: 0.25)),
    ("R", "Q", "a", (curve: 0.25)),
    ("Q", "O", "b", (curve: 0)),
    ("R", "S", "b", (curve: 0, label: (dist: -dist-lettre))),
    ("S", "S", "b", (anchor: right)),
    ("S", "T", "a", (curve: 0, label: (dist: -dist-lettre))),
    ("T", "P", "b", (curve: 0, label: (dist: -dist-lettre))),
    ("T", "R", "a", (curve: -1)),
  ),
)
#let produit-accessible = dessiner(
  (
    ("E,H", (0, 0), true, false),
    ("F,I", (3, 2), false, false),
    ("F,H", (3, -2), false, false),
    ("G,K", (7, 2), false, true),
    ("G,J", (7, -2), false, true),
  ),
  (
    ("E,H", "F,I", "a", (curve: 0)),
    ("E,H", "G,J", "b", (curve: -0.5)),
    ("F,I", "F,H", "a", (curve: 0.25)),
    ("F,H", "F,I", "a", (curve: 0.25)),
    ("F,I", "G,K", "b", (curve: 0.25)),
    ("G,K", "F,I", "b", (curve: 0.25)),
    ("F,H", "G,J", "b", (curve: 0.25)),
    ("G,J", "F,H", "b", (curve: 0.25)),
    ("G,K", "G,J", "a", (curve: 0.25)),
    ("G,J", "G,K", "a", (curve: 0.25)),
  ),
)
#let quotient = dessiner(
  (("S_0", (0, 0), true, false), ("S_1", (3, 0), false, true)),
  (
    ("S_0", "S_0", "a", (anchor: top)),
    ("S_1", "S_1", "a", (anchor: top)),
    ("S_0", "S_1", "b", (curve: 0.3)),
    ("S_1", "S_0", "b", (curve: 0.3)),
  ),
)
#let fusion = dessiner(
  (
    ("O,P", (0, 0), true, true),
    ("Q,T", (3, 0), false, false),
    ("R", (6, 1.5), false, false),
    ("S", (6, -1.5), false, false),
  ),
  (
    ("O,P", "O,P", "a", (anchor: top)),
    ("O,P", "Q,T", "b", (curve: 0.3)),
    ("Q,T", "O,P", "b", (curve: 0.3)),
    ("Q,T", "R", "a", (curve: 0.25)),
    ("R", "Q,T", "a", (curve: 0.25)),
    ("R", "S", "b", (curve: 0)),
    ("S", "Q,T", "a", (curve: 0)),
    ("S", "S", "b", (anchor: bottom)),
  ),
)
#let minimal = dessiner(
  (("O,P", (0, 0), true, true), ("Q,T", (3, 0), false, false), ("R,S", (6, 0), false, false)),
  (
    ("O,P", "O,P", "a", (anchor: top)),
    ("R,S", "R,S", "b", (anchor: top)),
    ("O,P", "Q,T", "b", (curve: 0.3)),
    ("Q,T", "O,P", "b", (curve: 0.3)),
    ("Q,T", "R,S", "a", (curve: 0.3)),
    ("R,S", "Q,T", "a", (curve: 0.3)),
  ),
)
#let diagramme = align(center, cetz.canvas({
  import cetz.draw: content, line
  content((0, 2), $cal(B)$, name: "B")
  content((-2, 0), $cal(A)$, name: "A")
  content((2, 0), $cal(A)'$, name: "Ap")
  content((0, -2), $cal(C)$, name: "C")
  for (p, q, label, pos) in (
    ("B", "A", $φ$, (-1.3, 1)),
    ("B", "Ap", $ψ$, (1.3, 1)),
    ("A", "C", $φ'$, (-1.3, -1)),
    ("Ap", "C", $ψ'$, (1.3, -1)),
    ("B", "C", $η$, (0.3, 0)),
  ) {
    line(p + ".south", q + ".north", mark: (end: ">"))
    content(pos, label)
  }
}))

#let ex = exercice(
  meta: (
    titre: "Morphismes d'automates",
    chapitres: ("automates-finis", "langages-reguliers", "graphes"),
    algorithmes: ("parcours-en-profondeur",),
    structures: ("tableau", "liste", "graphe"),
    langages: ("OCaml",),
    difficulte: 4,
    niveaux: ("MPI", "MP"),
    duree: (3, 0),
    concours: (nom: "Mines-Ponts", annee: 2019, filiere: "MP"),
  ),
  corrections: [
    - Question 36 : inverser le sens du chemin recherché, de $(p,q)$ vers une paire de caractères finaux différents, pour calculer les paires distinguables.
  ],
  jury: [
    Le jury demande des preuves argumentées, en citant les propriétés et résultats antérieurs utilisés.
  ],
  contenu: (
    [
      == Définition mathématique d'un automate
      Dans tout le sujet, le terme _automate_ désigne un automate fini déterministe complet sur ${a,b}$, c'est-à-dire un quadruplet $cal(A)=⟨ Q,i,δ,F ⟩$ avec $i ∈ Q$, $δ: Q × {a,b} → Q$ et $F ⊂ Q$.\
      On note $cal(L)(cal(A))$ le langage reconnu par $cal(A)$ et $δ^*: Q × {a,b}^* → Q$ l'extension de $δ$ définie par
      $ δ^*(q,ε)=q, #sep δ^*(q,σ w)=δ^*(δ(q,σ),w). $

      == Représentation en OCaml
      Les états sont numérotés de $0$ à $abs(Q)-1$, l'état initial ayant le numéro $0$.
      Un automate est un triplet ```ocaml (n, delta, f)``` :
      - ```ocaml n : int``` est le nombre d'états.
      - ```ocaml delta : (int * int) array``` contient les couples $(δ(q,a),δ(q,b))$.
      - ```ocaml f : bool array``` indique les états finaux.
      Les deux tableaux sont de longueur $n$.
      #code("automate")
      Ainsi, ```ocaml let (n, delta, f) = aut in ...``` extrait les composantes de l'automate ```ocaml aut```,
      ```ocaml let (succ_a, succ_b) = delta.(q) in ...``` les successeurs de $q$,
      et ```ocaml if f.(q) then ...``` teste si $q$ est final.\
      On rappelle que ```ocaml List.length``` donne la longueur d'une liste,
      ```ocaml Array.make n x``` crée un tableau de taille $n$ initialisé à ```ocaml x``` et ```ocaml Array.length``` donne sa longueur.
      ```ocaml Array.make_matrix n m x``` crée une matrice $n × m$ initialisée à ```ocaml x```.
      On pourra aussi utiliser ```ocaml List.iter f l``` qui applique ```ocaml f``` à chaque élément de ```ocaml l```, dans l'ordre.
    ],
    partie("I", "Premiers exemples", contenu: (
      question(
        [Donner, sans preuve, une description courte en langue française de $cal(L)(cal(A)_1)$.],
        solution: [Les mots de taille impaire sur ${a,b}$.],
        bareme: 0.5,
        notation: [100 % pour les tailles impaires ; 0 % sinon.],
      ),
      question(
        [Donner, sans preuve, une description courte en langue française de $cal(L)(cal(A)_2)$.],
        solution: [Les mots contenant un nombre impair de $b$.],
        bareme: 0.5,
        notation: [100 % pour un nombre impair de $b$, sans restriction sur les $a$ ; 0 % sinon.],
      ),
      question(
        [Donner, sans preuve, une expression régulière qui dénote $cal(L)(cal(A)_1)$.],
        solution: [$ (a|b)((a|b)(a|b))^*. $],
        bareme: 0.5,
        notation: [100 % si correcte ; 50 % pour une seule petite erreur avec taille impaire, ou pour exactement les tailles paires ; 0 % si deux erreurs cumulées ou parité non maîtrisée.],
      ),
      question(
        [Donner, sans preuve, une expression régulière qui dénote $cal(L)(cal(A)_2)$.],
        solution: [$ a^* b a^* (b a^* b a^*)^*. $],
        bareme: 0.5,
        notation: [100 % si correcte ; 50 % pour une seule petite erreur avec un nombre impair de $b$ ($a^*$ manquant, $b b$ consécutifs imposés…), ou pour exactement les nombres pairs de $b$ ; 0 % si deux erreurs cumulées ou parité non maîtrisée.],
      ),
      question(
        [Écrire en OCaml, sans justification, une instance du type ```ocaml automate``` correspondant à $cal(A)_2$.],
        solution: [On identifie $C$ à $0$ et $D$ à $1$. #code("a2")],
        bareme: 0.5,
        notation: [25 % pour le nombre d'états, 50 % pour les deux transitions de chaque état, 25 % pour les états finaux. Au plus 50 % pour un enregistrement ou des listes à la place du triplet et des tableaux demandés.],
      ),
      [
        #grid(
          columns: (1fr, 1fr),
          column-gutter: 1.5em,
          row-gutter: (0.5em, 1em, 0.5em),
          align: center + horizon,
          a1, a2,
          [Automate $cal(A)_1$], [Automate $cal(A)_2$],
          a3, a4,
          [Automate $cal(A)_3$], [Automate $cal(A)_4$],
        )
      ],
    )),
    partie("II", "États accessibles d'un automate", contenu: (
      question(
        [Écrire une fonction ```ocaml numero : int -> int list -> int array``` qui, à partir d'un entier $n$ et d'une liste $A$ d'entiers entre $0$ et $n-1$, renvoie un tableau $T$ de taille $n$ :
          $T[i]=-1$ si $i$ est absent de $A$, et $T[i]$ est l'indice de l'une de ses occurrences sinon.
          Par exemple, ```ocaml numero 5 [3;2;0]``` peut renvoyer ```ocaml [|2;-1;1;0;-1|]```.],
        jury: [Un compteur et un parcours de la liste suffisent. Certaines solutions correctes étaient inutilement quadratiques.],
        solution: [On mémorise la position courante. En cas de répétition, on conserve la dernière occurrence.
          #code("numero") Le coût est $O(n+abs(A))$.],
        bareme: 1,
        notation: [Un tiers pour le tableau de taille $n$ initialisé à $-1$, un tiers pour le parcours de la liste avec suivi des indices, un tiers pour leur écriture aux bonnes cases. Ne pas pénaliser une recherche quadratique correcte ni le choix d'une occurrence autre que la première.],
      ),
      [Un état $q$ de $cal(A)=⟨ Q_cal(A),i_cal(A),δ_cal(A),F_cal(A) ⟩$ est accessible s'il existe $w ∈ {a,b}^*$ tel que $δ_cal(A)^*(i_cal(A),w)=q$.
        Si $Q'$ est l'ensemble des états accessibles, la partie accessible de $cal(A)$ est $cal(A)'=⟨ Q',i_cal(A),δ',F_cal(A) ∩ Q' ⟩$, où $δ'$ est la restriction de $δ_cal(A)$ à $Q' × {a,b}$.
        Un automate est accessible si tous ses états le sont.],
      question(
        [Écrire ```ocaml etats_accessibles : automate -> int list``` renvoyant les états accessibles dans l'ordre de leur première rencontre lors d'un parcours en profondeur depuis l'état initial, sans doublon. Donner sa complexité.],
        jury: [« Une attention toute particulière devait être consacrée à l'ordre exigé du résultat. » Le jury relève aussi des confusions avec le parcours en largeur et des oublis de marquage.],
        solution: [
          On marque chaque état avant d'explorer ses successeurs, d'abord par $a$.
          #code("etats_accessibles")
          Chaque état accessible est traité une seule fois, avec deux transitions à examiner.
          L'initialisation coûte $O(n)$, comme le temps total et l'espace utilisé.
        ],
        bareme: 2,
        notation: [Retirer 25% pour chaque petite erreur différente, 25% pour complexité quadratique.],
      ),
      question(
        [Écrire ```ocaml partie_accessible : automate -> automate``` construisant la partie accessible
          de l'automate donné. ],
        jury: [« Beaucoup de candidats ont mal renuméroté les sommets du graphe ou les transitions. »],
        solution: [
          On renumérote dans l'ordre obtenu précédemment : la liste commence par $0$, qui reste l'état initial.
          Les successeurs d'un état accessible sont accessibles.
          #code("partie_accessible") La complexité est $O(n)$.
        ],
        bareme: 1.5,
        notation: [Un cinquième pour la détermination des états accessibles, un cinquième pour leur renumérotation avec l'état initial en $0$, un cinquième pour les transitions associées aux bons états sources, un cinquième pour la renumérotation des destinations, un cinquième pour les états finaux.],
      ),
    )),
    partie("III", "Morphismes d'automates", contenu: (
      [Soient $cal(A)=⟨ Q_cal(A),i_cal(A),δ_cal(A),F_cal(A) ⟩$ et $cal(B)=⟨ Q_cal(B),i_cal(B),δ_cal(B),F_cal(B) ⟩$ deux automates.

        Un morphisme $φ$ de $cal(A)$ vers $cal(B)$, noté $φ: cal(A) → cal(B)$, est une application $φ: Q_cal(A) → Q_cal(B)$ satisfaisant :
        #enum(
          numbering: "(1)",
          [$φ$ est surjective],
          [$φ(i_cal(A)) = i_cal(B)$],
          [$∀ q ∈ Q_cal(A), ∀ σ ∈ {a,b}, #sep φ(δ_cal(A)(q, σ))= δ_cal(B)(φ(q),σ)$],
          [$∀ q ∈ Q_cal(A), #sep q ∈ F_cal(A) <==> φ(q) ∈ F_cal(B)$],
        )

        En OCaml, $φ$ est représenté par le tableau $[φ(q)]_(q ∈ Q_cal(A))$,
        de type ```ocaml morphisme```, de longueur $abs(Q_cal(A))$ et à valeurs entre $0$ et $abs(Q_cal(B))-1$.
        #code("morphisme")],
      partie("III.A", "Exemples de morphismes d'automates", contenu: (
        question(
          [Compléter, sans justification, le tableau suivant par des états de $cal(A)_2$ pour qu'il représente un morphisme $φ: cal(A)_3 → cal(A)_2$.
            #align(center, table(
              columns: 4,
              [$q$], [$E$], [$F$], [$G$],
              [$φ(q)$], [], [], [],
            ))],
          solution: [$φ(E)=φ(F)=C$ et $φ(G)=D$.],
          bareme: 0.5,
          notation: [Un tiers pour chacune des trois images correctes.],
        ),
        question(
          [Donner, sans justification, un morphisme de $cal(A)_4$ vers $cal(A)_2$.],
          solution: [$φ(H)=φ(I)=C$ et $φ(J)=φ(K)=D$.],
          bareme: 0.5,
          notation: [25 % pour chacune des quatre images correctes.],
        ),
        question(
          [Montrer qu'il n'existe pas de morphisme de $cal(A)_1$ vers $cal(A)_2$.],
          solution: [
            La conservation de l'état initial et du caractère final impose $φ(A)=C$ et $φ(B)=D$.
            Mais $φ(δ_(cal(A)_1)(A,a))=D ≠ C=δ_(cal(A)_2)(φ(A),a)$, en contradiction avec (3).
          ],
          bareme: 0.5,
          notation: [50 % pour les images imposées par l'état initial et les finaux, 50 % pour une contradiction explicite avec une transition. Accepter tout autre argument correct.],
        ),
        question(
          [Montrer qu'il n'existe pas de morphisme de $cal(A)_5$ vers $cal(A)_2$.],
          solution: [
            La condition (4) impose $φ(L)=φ(N)=C$ et $φ(M)=D$.
            Or $φ(δ_(cal(A)_5)(N,a))=D ≠ C=δ_(cal(A)_2)(φ(N),a)$, ce qui contredit (3).
          ],
          bareme: 0.5,
          notation: [50 % pour les images imposées par les finaux, 50 % pour une contradiction explicite avec une transition. Accepter tout autre argument correct.],
        ),
      )),
      partie("III.B", "Propriétés des morphismes d'automates", contenu: (
        question(
          [Montrer que s'il existe un morphisme de $cal(A)$ vers $cal(B)$ alors $cal(L)(cal(A)) = cal(L)(cal(B))$.],
          jury: [« On doit citer les propriétés d'un morphisme utilisées, à chaque étape du raisonnement. »],
          solution: [
            Pour un morphisme $φ: cal(A) → cal(B)$, montrons par récurrence sur $abs(w)$ que
            $ ∀ q ∈ Q_cal(A), #sep φ(δ_cal(A)^*(q,w))=δ_cal(B)^*(φ(q),w). quad "(∗)" $
            Pour $w=ε$, les deux membres valent $φ(q)$.
            Pour $w=σ w'$, la définition de $δ^*$, l'hypothèse de récurrence et (3) donnent
            $
              φ(δ_cal(A)^*(q,σ w')) & = φ(δ_cal(A)^*(δ_cal(A)(q,σ),w')) \
                                    & = δ_cal(B)^*(φ(δ_cal(A)(q,σ)),w') \
                                    & = δ_cal(B)^*(δ_cal(B)(φ(q),σ),w') \
                                    & = δ_cal(B)^*(φ(q),σ w').
            $
            Par (2) et (4), $δ_cal(A)^*(i_cal(A),w) ∈ F_cal(A) ⟺ δ_cal(B)^*(i_cal(B),w) ∈ F_cal(B)$.
            Donc $cal(L)(cal(A)) = cal(L)(cal(B))$.
          ],
          bareme: 2,
          notation: [50 % pour la compatibilité avec la lecture d'un mot, dont 25 % pour une récurrence détaillée, 25 % pour la première inclusion, 25 % pour la réciproque. Accepter une preuve directe par équivalence. Repères : 50 % pour la seule première inclusion avec récurrence non détaillée, 75 % pour le chemin image établi sans réciproque justifiée.],
        ),
        question(
          [Montrer qu'un morphisme $φ : cal(A) → cal(B)$ avec $|Q_cal(A)| = |Q_cal(B)|$ est bijectif
            et que $φ^(-1)$ est encore un morphisme.\
            On dit alors que $φ$ est un isomorphisme.],
          jury: [Le jury relève des preuves confuses du caractère bijectif.],
          solution: [
            Une surjection entre ensembles finis de même cardinal est bijective.
            Vérifions les quatre conditions pour $φ^(-1)$ :
            - Elle est bijective, donc surjective.
            - Par (2), $φ^(-1)(i_cal(B))=i_cal(A)$.
            - En appliquant (3) à $φ^(-1)(q)$ puis $φ^(-1)$ à l'égalité obtenue,
              $φ^(-1)(δ_cal(B)(q,σ))=δ_cal(A)(φ^(-1)(q),σ)$.
            - Par (4), $q ∈ F_cal(B) ⟺ φ^(-1)(q) ∈ F_cal(A)$.
          ],
          bareme: 1.5,
          notation: [Un cinquième pour la bijectivité par égalité des cardinaux, puis un cinquième pour chacune des quatre propriétés de l'inverse : surjectivité, état initial, compatibilité avec les transitions, équivalence sur les finaux. Ne pas pénaliser les seuls lapsus d'indices sans ambiguïté.],
        ),
        question(
          [Montrer que la composition de deux morphismes est encore un morphisme.],
          solution: [
            Soient $φ: cal(A) → cal(B)$ et $ψ: cal(B) → cal(C)$.
            - $ψ ∘ φ$ est surjective comme composée de surjections.
            - $(ψ ∘ φ)(i_cal(A))=ψ(i_cal(B))=i_cal(C)$
            - $(ψ ∘ φ)(δ_cal(A)(q,σ))=ψ(δ_cal(B)(φ(q),σ))=δ_cal(C)((ψ ∘ φ)(q),σ)$
            - $q ∈ F_cal(A) ⟺ φ(q) ∈ F_cal(B) ⟺ (ψ ∘ φ)(q) ∈ F_cal(C)$
          ],
          bareme: 1,
          notation: [25 % pour la surjectivité, 25 % pour l'état initial, 25 % pour les transitions, 25 % pour l'équivalence sur les finaux. Attribuer 90 % si seule la réciproque sur les finaux manque.],
        ),
        [#grid(
          columns: (1fr, 1fr),
          column-gutter: 1.5em,
          align: horizon,
          [#a5 #align(center)[Automate $cal(A)_5$]], [#a6 #align(center)[Automate $cal(A)_6$]],
        )],
      )),
      partie("III.C", "Existence de morphismes entre automates accessibles", contenu: (
        question(
          [Montrer que la propriété (1) de la définition d'un morphisme découle de (2), (3) et (4) lorsque les deux automates sont accessibles.],
          jury: [Pour établir la surjectivité, le jury attend un antécédent explicite pour chaque état.],
          solution: [
            La preuve de (∗) n'utilise que (3). Pour tout $q' ∈ Q_cal(B)$, l'accessibilité donne un mot $w$ avec $q'=δ_cal(B)^*(i_cal(B),w)=φ(δ_cal(A)^*(i_cal(A),w))$, par (2) et (∗).
            Ainsi $φ$ est surjective. L'accessibilité de $cal(A)$ et (4) ne sont pas nécessaires ici.
          ],
          bareme: 1,
          notation: [Un tiers pour un mot atteignant un état arbitraire du but, un tiers pour la construction de son antécédent, un tiers pour la vérification de son image. Une simple évocation des chemins sans construction d'antécédent reçoit au plus un tiers.],
        ),
        question(
          [Écrire ```ocaml existe_morphisme : automate -> automate -> bool * morphisme```
            qui, pour deux automates accessibles, indique s'il existe un morphisme du premier vers le second
            et en renvoie un lorsqu'il existe. Sinon, le tableau renvoyé est quelconque.
            On pourra expliquer le principe de l'algorithme avant le code.],
          jury: [Le jury conseille de décrire l'algorithme et de commenter les différentes étapes du code.],
          solution: [
            On impose l'image de l'état initial, puis celles des états rencontrés en profondeur.
            L'appel ```ocaml visiter q q'``` impose $φ(q)=q'$. Si l'image est déjà fixée, on vérifie sa compatibilité.
            Sinon, on vérifie le caractère final et on propage aux deux successeurs.
            #code("existe_morphisme")
            Chaque image est imposée par (2) et (3). En l'absence de contradiction, l'accessibilité donne une image à chaque état et (2), (3), (4) sont vérifiées.
            La question 16 assure (1). Le caractère final de l'état initial est également testé.
            La complexité est $O(n)$.
          ],
          bareme: 3,
          notation: [Un cinquième pour la propagation depuis les états initiaux, un cinquième pour la mémorisation des images déjà imposées, un cinquième pour la détection des contradictions sur les images, un cinquième pour la vérification des caractères finaux, un cinquième pour le résultat booléen et le tableau renvoyés. Accepter toute méthode correcte, y compris moins efficace.],
        ),
      )),
    )),
    partie("IV", "Constructions de morphismes d'automates", contenu: (
      partie("IV.A", "Automate produit", contenu: (
        [Pour deux automates $cal(A)$ et $cal(A)'$, on définit l'automate produit
          $
            cal(A) × cal(A)' = ⟨ Q_cal(A) × Q_(cal(A)'), (i_cal(A),i_(cal(A)')),
              δ_(cal(A) × cal(A)'), F_cal(A) × F_(cal(A)') ⟩
          $
          avec, pour chaque couple $(q,q')$ et lettre $σ ∈ {a,b}$,
          $ δ_(cal(A) × cal(A)')((q,q'),σ)=(δ_cal(A)(q,σ),δ_(cal(A)')(q',σ)). $
        ],
        question(
          [Dessiner, sans justification, la partie accessible de $cal(A)_3 × cal(A)_4$.],
          jury: [Le jury relève des incompréhensions de la définition du produit d'automates.],
          solution: [#produit-accessible],
          bareme: 1.5,
          notation: [Enlever 25% pour chaque petite erreur.],
        ),
        question(
          [Écrire ```ocaml produit : automate -> automate -> automate``` renvoyant le produit des deux automates donnés.],
          jury: [Le jury insiste sur la renumérotation des couples d'états et des transitions associées.],
          solution: [
            On représente $(q,q')$ par $q+n q'$, où $n$ est le nombre d'états du premier automate.
            L'état initial $(0,0)$ est codé par $0$.
            #code("produit") La complexité est $O(n n')$.
          ],
          bareme: 1.5,
          notation: [Un tiers pour le codage bijectif des couples et les tableaux de tailles adaptées, un tiers pour les transitions vers les couples correctement codés, un tiers pour la conjonction des caractères finaux.],
        ),
        [On suppose dans les deux questions suivantes que $cal(A)$ et $cal(A)'$ sont accessibles et que $cal(L)(cal(A)) = cal(L)(cal(A)')$. On note $cal(B)$ la partie accessible de $cal(A) × cal(A)'$.],
        question(
          [Soit $(q, q') ∈ Q_cal(B)$.
            Montrer que $q in F_cal(A)$ si et seulement si $q' in F_(cal(A)')$.],
          jury: [Le jury a trouvé peu de preuves convaincantes pour cette question.],
          solution: [
            Par récurrence sur $abs(w)$,
            $ δ_(cal(A) × cal(A)')^*((q,q'),w)=(δ_cal(A)^*(q,w),δ_(cal(A)')^*(q',w)). $
            L'accessibilité fournit donc un même mot $w$ tel que $q=δ_cal(A)^*(i_cal(A),w)$ et $q'=δ_(cal(A)')^*(i_(cal(A)'),w)$.
            Alors $q ∈ F_cal(A) ⟺ w ∈ cal(L)(cal(A)) ⟺ w ∈ cal(L)(cal(A)') ⟺ q' ∈ F_(cal(A)')$.
          ],
          bareme: 1.5,
          notation: [50 % pour un même mot menant aux deux composantes, 50 % pour l'équivalence de leurs caractères finaux par égalité des langages. L'accessibilité du couple doit être utilisée.],
        ),
        question(
          [Montrer qu'il existe un morphisme de $cal(B)$ vers $cal(A)$ et un morphisme de $cal(B)$ vers $cal(A)'$.],
          jury: [Le jury a trouvé peu de preuves convaincantes pour cette question.],
          solution: [
            Soit $φ(q,q')=q$ la première projection.
            - Pour chaque $q$, l'accessibilité de $cal(A)$ fournit $w$ menant à $q$.
              Avec $q'=δ_(cal(A)')^*(i_(cal(A)'),w)$, le couple $(q,q')$ est accessible et d'image $q$ : $φ$ est surjective.
            - $φ(i_cal(B))=φ(i_cal(A),i_(cal(A)'))=i_cal(A)$
            - Par définition du produit, $φ(δ_cal(B)((q,q'),σ))=δ_cal(A)(q,σ)=δ_cal(A)(φ(q,q'),σ)$.
            - Par la question 20,
              $(q,q') ∈ F_cal(B) ⟺ q ∈ F_cal(A) " et " q' ∈ F_(cal(A)') ⟺ q ∈ F_cal(A)$.
            La seconde projection $ψ(q,q')=q'$ est de même un morphisme vers $cal(A)'$.
          ],
          bareme: 2,
          notation: [Un cinquième pour les projections, puis un cinquième pour chacune des quatre propriétés : surjectivité, état initial, compatibilité avec les transitions, équivalence sur les finaux. Accepter une seule vérification suivie d'un argument de symétrie.],
        ),
      )),
      partie(
        "IV.B",
        "Diagramme d'automates",
        jury: [À chaque pas de la chaîne, l'égalité peut porter sur les images par $φ$ ou sur celles par $ψ$. Ce choix n'est pas nécessairement le même à tous les pas.],
        contenu: (
          [Dans toute cette sous-partie, $cal(A)$, $cal(A)'$ et $cal(B)$ sont accessibles, et $φ: cal(B) → cal(A)$ et $ψ: cal(B) → cal(A)'$ sont des morphismes.
            On veut construire un automate accessible $cal(C)$ et trois morphismes $φ'$, $ψ'$, $η$ :
            #diagramme
            Pour $(p,q) ∈ Q_cal(B)^2$, on pose $p ≡ q$ s'il existe une suite finie $p=q_0,q_1,…,q_k=q$, avec $k ∈ NN$, telle que
            $ ∀ 0 ≤ j < k, #sep φ(q_j)=φ(q_(j+1)) " ou " ψ(q_j)=ψ(q_(j+1)). $
          ],
          question(
            [Montrer que $≡$ est une relation d'équivalence sur $Q_cal(B)$.],
            solution: [
              - Réflexivité : la suite réduite à $p$ convient ($k=0$).
              - Symétrie : on renverse une suite reliant $p$ à $q$.
              - Transitivité : on concatène les suites de $p$ à $q$ et de $q$ à $r$, en gardant une seule fois le terme commun $q$.
            ],
            bareme: 1,
            notation: [Un tiers pour la réflexivité, un tiers pour la symétrie, un tiers pour la concaténation des suites établissant la transitivité.],
          ),
          question(
            [Montrer que $p ≡ q$ entraîne $δ_cal(B)(p,σ) ≡ δ_cal(B)(q,σ)$ pour toute lettre $σ ∈ {a,b}$.],
            solution: [
              Soit $p=q_0,…,q_k=q$ une suite témoin. Si $φ(q_j)=φ(q_(j+1))$, la condition (3) donne
              $ φ(δ_cal(B)(q_j,σ))=δ_cal(A)(φ(q_j),σ)=δ_cal(A)(φ(q_(j+1)),σ)=φ(δ_cal(B)(q_(j+1),σ)). $
              On raisonne de même avec $ψ$ lorsque les images par $ψ$ sont égales.
              La suite $δ_cal(B)(q_0,σ),…,δ_cal(B)(q_k,σ)$ témoigne de l'équivalence recherchée.
            ],
            bareme: 1.5,
            notation: [Un tiers pour la conservation de l'égalité des images par $φ$, un tiers pour le cas de $ψ$, un tiers pour la suite témoin obtenue. Accepter un argument de symétrie explicite pour le second cas.],
          ),
          question(
            [Montrer que, si $p ≡ q$, alors $p$ est final dans $cal(B)$ si et seulement si $q$ l'est.],
            solution: [
              Lorsque $φ(q_j)=φ(q_(j+1))$, la condition (4) donne
              $ q_j ∈ F_cal(B) ⟺ φ(q_j) ∈ F_cal(A) ⟺ φ(q_(j+1)) ∈ F_cal(A) ⟺ q_(j+1) ∈ F_cal(B). $
              On obtient la même équivalence si les images par $ψ$ sont égales.
              Le caractère final est donc constant le long d'une suite témoin.
            ],
            bareme: 1,
            notation: [Un tiers pour l'équivalence des caractères finaux lorsque les images par $φ$ sont égales, un tiers pour le cas de $ψ$, un tiers pour la propagation le long de la suite témoin. Accepter un argument de symétrie explicite pour le second cas.],
          ),
          [La classe d'un état $q$ est $[q]={p ∈ Q_cal(B) | q ≡ p}$.
            On note $ℓ$ le nombre de classes et $S_0,…,S_(ℓ-1)$ ces classes, avec $i_cal(B) ∈ S_0$.
            On définit $η: Q_cal(B) → {S_0,…,S_(ℓ-1)}$ par $η(q)=[q]$.
            En OCaml, la classe $S_j$ est représentée par l'indice $j$.],
          question(
            [Construire un automate accessible $cal(C)$ d'ensemble d'états ${S_0,…,S_(ℓ-1)}$
              tel que $η: cal(B) → cal(C)$ soit un morphisme. Justifier.],
            solution: [
              On pose
              $ Q_cal(C)={S_0,…,S_(ℓ-1)}, #sep i_cal(C)=[i_cal(B)]=S_0, $
              $ δ_cal(C)([q],σ)=[δ_cal(B)(q,σ)], #sep F_cal(C)={[q] | q ∈ F_cal(B)}. $
              Les questions 23 et 24 assurent que transitions et caractère final sont indépendants du représentant choisi.
              On obtient donc un automate déterministe complet.
              L'application $η$ est surjective, préserve l'état initial et commute aux transitions par définition.
              La question 24 donne $q ∈ F_cal(B) ⟺ [q] ∈ F_cal(C)$ : $η$ est un morphisme.
              Enfin, l'accessibilité de $cal(B)$ fournit pour chaque $q$ un mot $w$ menant à $q$.
              Par (∗), $δ_cal(C)^*(S_0,w)=η(q)=[q]$, donc $cal(C)$ est accessible.
            ],
            bareme: 2.5,
            notation: [25 % pour la définition de l'automate quotient, 25 % pour l'indépendance du représentant, 25 % pour les propriétés du morphisme, 25 % pour l'accessibilité.],
          ),
          question(
            [Construire deux morphismes $φ': cal(A) → cal(C)$ et $ψ': cal(A)' → cal(C)$,
              où $cal(C)$ est l'automate de la question 25.],
            solution: [
              Pour $q ∈ Q_cal(A)$, choisir $p$ tel que $φ(p)=q$ et poser $φ'(q)=[p]$.
              Cet antécédent existe par surjectivité. Si $φ(p)=φ(p')$, alors $p ≡ p'$, donc $[p]=[p']$ :
              la définition ne dépend pas du choix et $φ' ∘ φ=η$.
              - Toute classe $[p]$ est l'image de $φ(p)$, donc $φ'$ est surjective.
              - $φ'(i_cal(A))=φ'(φ(i_cal(B)))=[i_cal(B)]=i_cal(C)$
              - Si $q=φ(p)$,
                $ φ'(δ_cal(A)(q,σ))=φ'(φ(δ_cal(B)(p,σ)))=[δ_cal(B)(p,σ)]=δ_cal(C)(φ'(q),σ). $
              - $q ∈ F_cal(A) ⟺ p ∈ F_cal(B) ⟺ [p] ∈ F_cal(C) ⟺ φ'(q) ∈ F_cal(C)$
              On définit de même $ψ'(ψ(p))=[p]$. C'est un morphisme et $ψ' ∘ ψ=η$.
            ],
            bareme: 3,
            notation: [Un sixième pour la définition par un antécédent et les égalités de composition, un sixième pour l'indépendance du choix, puis un sixième pour chacune des quatre propriétés : surjectivité, état initial, compatibilité avec les transitions, équivalence sur les finaux. Vérifier ces critères pour les deux morphismes, en acceptant un argument de symétrie explicite.],
          ),
          question(
            [Écrire ```ocaml renomme : int array -> int array``` qui renomme un tableau d'entiers positifs ou nuls
              prenant $ℓ$ valeurs distinctes à l'aide des entiers de $0$ à $ℓ-1$.
              Le premier élément du résultat doit valoir $0$.
              Par exemple, ```ocaml renomme [|4;4;5;0;4;5|]``` peut renvoyer ```ocaml [|0;0;1;2;0;1|]```.
              Préciser la complexité.],
            solution: [
              Chaque valeur reçoit un numéro lors de sa première apparition : la première reçoit donc $0$.
              #code("renomme")
              Pour une longueur $n>0$ et un maximum $M$, le temps et l'espace sont $O(n+M+1)$.
              L'initialisation de ```ocaml code``` interdit de conclure à $O(n)$ pour des valeurs arbitrairement grandes.
              Pour le tableau vide, le coût est constant.
            ],
            bareme: 1.5,
            notation: [25 % pour la mémorisation des numéros déjà attribués, 25 % pour un nouveau numéro à chaque valeur nouvelle, 25 % pour le tableau résultat et le premier numéro $0$, 25 % pour la complexité correcte. Avec une table indexée par les valeurs, compter $O(n+M+1)$, où $M$ est leur maximum.],
          ),
          question(
            [Écrire ```ocaml relation : morphisme -> morphisme -> morphisme``` qui, à partir de $[φ(q)]$ et $[ψ(q)]$,
              renvoie $[η(q)]$, c'est-à-dire un tableau ```ocaml t``` à valeurs entre $0$ et $ℓ-1$ tel que
              ```ocaml t.(p) = t.(q)``` équivaut à $p ≡ q$, et ```ocaml t.(0) = 0```.],
            solution: [
              La relation décrit les composantes connexes du graphe non orienté $G=(S,A)$, où $S=Q_cal(B)$ et une arête relie $p$ à $q$ si $φ(p)=φ(q)$ ou $ψ(p)=ψ(q)$.
              On les parcourt en profondeur en commençant par $0$, dont la classe reçoit le numéro $0$.
              #code("relation")
              Chaque état déclenche une seule exploration de ses $n$ voisins possibles.
              Le temps est $O(n^2)$ et l'espace auxiliaire $O(n)$, pile comprise.
            ],
            bareme: 2.5,
            notation: [25 % pour l'adjacence définie par l'égalité d'au moins une image, 25 % pour l'exploration complète d'une classe, 25 % pour le marquage et la séparation des classes, 25 % pour le tableau résultat avec la classe de $0$ numérotée $0$. Accepter toute construction correcte des classes.],
          ),
        ),
      ),
    )),
    partie(
      "V",
      "Réduction d'automates",
      jury: [« Chacune de ces questions doit être citée dans une argumentation, au moment de leur utilisation. »],
      contenu: (
        partie("V.A", "Existence et unicité", contenu: (
          question(
            [Montrer que, si deux automates accessibles $cal(A)$ et $cal(A)'$ acceptent le même langage,
              on peut construire un automate $cal(C)$ et deux morphismes $φ': cal(A) → cal(C)$ et $ψ': cal(A)' → cal(C)$.],
            solution: [
              Prendre pour $cal(B)$ la partie accessible de $cal(A) × cal(A)'$.
              La question 21 fournit les projections $φ: cal(B) → cal(A)$ et $ψ: cal(B) → cal(A)'$.
              Les questions 25 et 26 donnent alors l'automate accessible $cal(C)$ et les deux morphismes demandés.
            ],
            bareme: 0.5,
            notation: [50 % pour la partie accessible du produit et ses projections, 50 % pour l'application de la construction du diagramme avec les résultats correspondants.],
          ),
          question(
            [Déterminer l'automate $cal(C)$ de la question 29 pour $cal(A)_3$ et $cal(A)_4$ et préciser $φ'$ et $ψ'$.],
            solution: [
              Les classes dans la partie accessible du produit sont
              $ S_0={(E,H),(F,H),(F,I)}, #sep S_1={(G,J),(G,K)}. $
              En effet, $(E,H) ≡ (F,H) ≡ (F,I)$ (état initial) et $(G,J) ≡ (G,K)$ (états finaux).

              L'automate $cal(C)$ obtenu est isomorphe à $cal(A)_2$ :
              #quotient
              On a $φ'(E)=φ'(F)=S_0$, $φ'(G)=S_1$, $ψ'(H)=ψ'(I)=S_0$ et $ψ'(J)=ψ'(K)=S_1$.
            ],
            bareme: 1.5,
            notation: [25 % pour les classes, 25 % pour l'automate quotient, 25 % pour chacun des deux morphismes.],
          ),
          [Soit $L$ un langage régulier et $cal(K)_L$ l'ensemble des automates déterministes complets accessibles qui acceptent $L$. On note $m_L$ leur plus petit nombre d'états.],
          question(
            [Montrer que deux automates de $cal(K)_L$ ayant $m_L$ états sont nécessairement isomorphes.],
            solution: [
              La question 29 donne des morphismes $φ': cal(A) → cal(C)$ et $ψ': cal(A)' → cal(C)$, où $cal(C)$ est accessible. Par la question 13, $cal(C)$ reconnaît $L$, donc $abs(Q_cal(C)) ≥ m_L$.
              La surjectivité de $φ'$ donne l'inégalité inverse. Les trois automates ont donc $m_L$ états.
              Par la question 14, $φ'$ et $ψ'$ sont des isomorphismes, et $(ψ')^(-1) ∘ φ'$ aussi, par la question 15.
            ],
            bareme: 2,
            notation: [25 % pour l'automate commun et les morphismes, 25 % pour la conservation du langage, 25 % pour l'égalité des cardinaux par minimalité et surjectivité, 25 % pour l'isomorphisme obtenu.],
          ),
          question(
            [Montrer que, pour tout $cal(A) ∈ cal(K)_L$, il existe un morphisme $φ: cal(A) → cal(M)_L$,
              où $cal(M)_L$ est un automate de $cal(K)_L$ à $m_L$ états.],
            solution: [
              Comme $L$ est régulier, il est reconnu par un automate déterministe complet. Sa partie accessible appartient à $cal(K)_L$.
              L'ensemble non vide ${abs(Q_cal(A)) | cal(A) ∈ cal(K)_L} ⊂ NN$ admet donc un minimum $m_L$, atteint par un automate $cal(M)_L$.
              Par la question 29, on obtient $φ': cal(A) → cal(C)$ et $ψ': cal(M)_L → cal(C)$.
              Comme précédemment, $cal(C) ∈ cal(K)_L$ et $m_L ≤ abs(Q_cal(C)) ≤ m_L$.
              Donc $ψ'$ est un isomorphisme et $(ψ')^(-1) ∘ φ'$ est le morphisme demandé.
            ],
            bareme: 2,
            notation: [25 % pour l'existence d'un automate minimal, 25 % pour l'automate commun, 25 % pour l'isomorphisme du morphisme issu de l'automate minimal, 25 % pour la composition donnant le morphisme demandé.],
          ),
        )),
        partie("V.B", "Construction d'un automate réduit par fusion d'états", contenu: (
          [On dit que deux états $p,q$ de $cal(A)$ ont été fusionnés dans $cal(A)'$ s'il existe un morphisme $φ: cal(A) → cal(A)'$ tel que $φ(p)=φ(q)$ et $abs(Q_(cal(A)')) < abs(Q_cal(A))$.],
          question(
            [Dessiner un automate $cal(A)_6^(O,P)$ dans lequel les états $O$ et $P$ de $cal(A)_6$
              ont été fusionnés. Donner un morphisme $cal(A)_6 → cal(A)_6^(O,P)$.],
            solution: [
              Fusionner $O$ et $P$ impose de fusionner leurs successeurs par $b$, soit $T$ et $Q$.
              Ces deux fusions suffisent :
              #fusion
              Les étiquettes désignent les ensembles d'antécédents.
              Le morphisme envoie $O,P$ sur ${O,P}$, $Q,T$ sur ${Q,T}$, $R$ sur ${R}$ et $S$ sur ${S}$.
              Il est surjectif, préserve l'état initial $P$ et le caractère final, et commute aux deux transitions comme le montre la figure.
            ],
            bareme: 1.5,
            notation: [Un tiers pour la fusion supplémentaire imposée, un tiers pour l'automate obtenu, un tiers pour le morphisme. Accepter toute fusion valide répondant à l'énoncé.],
          ),
          question(
            [Expliquer brièvement pourquoi on ne peut construire $cal(A)_6^(Q,R)$ muni d'un morphisme
              $ψ: cal(A)_6 → cal(A)_6^(Q,R)$ tel que $ψ(Q)=ψ(R)$.],
            solution: [
              $Q$ et $R$ ne sont pas finaux, mais $δ_(cal(A)_6)(Q,b)=O$ est final, tandis que $δ_(cal(A)_6)(R,b)=S$ ne l'est pas.
              Si $ψ(Q)=ψ(R)$, (3) imposerait $ψ(O)=δ(ψ(Q),b)=δ(ψ(R),b)=ψ(S)$, ce que (4) interdit.
            ],
            bareme: 0.5,
            notation: [50 % pour la fusion des successeurs imposée par les transitions, 50 % pour la contradiction entre leurs caractères finaux.],
          ),
          question(
            [Quels états faut-il encore fusionner dans $cal(A)_6^(O,P)$ pour obtenir un automate à trois états $cal(M)_(L_6)$ reconnaissant le même langage que $cal(A)_6$ ?],
            solution: [
              On fusionne encore $R$ et $S$.
              #minimal
              La projection de chaque état sur sa paire est un morphisme, donc conserve le langage.
              Les trois états sont accessibles par $ε$, $b$ et $b a$.
              La classe ${O,P}$ se distingue des deux autres par $ε$. Les classes ${Q,T}$ et ${R,S}$ se distinguent par $b$.
              Aucun morphisme ne peut donc identifier deux de ces états.
              Le morphisme vers $cal(M)_(L_6)$ fourni par la question 32 est injectif : cet automate est minimal.
            ],
            bareme: 2,
            notation: [25 % pour la fusion de $R$ et $S$, 50 % pour l'automate à trois états, 25 % pour la conservation du langage. La preuve de minimalité n'est pas exigée.],
          ),
          question(
            [
              Soit $cal(A)=⟨ Q,i,δ,F ⟩$ un automate accessible.
              On appelle $P=(S,A)$ le graphe orienté de sommets $S=Q × Q$,
              avec, pour chaque $σ ∈ {a,b}$, un arc de $(p,q)$ vers $(δ(p,σ),δ(q,σ))$.
              Écrire ```ocaml table_de_predecesseurs : automate -> bool array array```
              renvoyant une matrice $n × n$ dont la case $(p,q)$ vaut ```ocaml true```
              si et seulement s'il existe un chemin de $(p,q)$ vers un couple $(p_0,q_0)$ dont exactement un état appartient à $F$.
              On essaiera de ne pas dépasser $O(n^2)$.
            ],
            solution: [
              On construit les listes de prédécesseurs des sommets de $P$, puis on parcourt le graphe à rebours depuis les paires de caractères finaux différents.
              #code("table_de_predecesseurs")
              Une paire est marquée exactement lorsqu'elle peut atteindre dans $P$ une paire contenant un seul état final.
              Les étiquettes du chemin forment un mot qui distingue les états. Le mot vide correspond aux paires initialement marquées.
              On construit $2n^2$ arcs, puis chaque sommet et chaque arc sont visités au plus une fois.
              Temps et espace sont donc $O(n^2)$.
            ],
            bareme: 3.5,
            notation: [25 % pour le graphe des prédécesseurs, 25 % pour les paires initiales de caractères finaux différents, 25 % pour le parcours à rebours et son marquage, 25 % pour la matrice résultat. Si le résultat est correct, retirer 25 % pour un coût supérieur à $O(n^2)$ sans recherche d'une amélioration. Accepter une autre méthode correcte avec un crédit adapté à son efficacité.],
          ),
          question(
            [Décrire le principe, le justifier, puis écrire ```ocaml reduit : automate -> automate```
              qui renvoie l'automate $cal(M)_L$ associé au langage $L$ de l'automate donné.],
            solution: [
              On commence par prendre la partie accessible, ce qui conserve le langage.
              Avec la table $D$ de la question 36 corrigée, définir
              $ p ∼ q ⟺ D[p,q]="faux" ⟺ ∀ w ∈ {a,b}^*, (δ^*(p,w) ∈ F ⟺ δ^*(q,w) ∈ F). $
              Cette relation exprime l'égalité des langages reconnus depuis chaque état : c'est une équivalence.
              Le choix $w=ε$ montre que le caractère final est constant dans une classe.
              Si $p ∼ q$, lire $σ w$ montre que $δ(p,σ) ∼ δ(q,σ)$ pour chaque lettre $σ$.
              Comme à la question 25, on peut donc former le quotient : il est accessible et la projection est un morphisme, donc il reconnaît encore $L$.

              Deux classes distinctes sont distinguées par un mot. Par (∗) et (4), un morphisme ne peut les identifier.
              Le morphisme du quotient vers $cal(M)_L$ fourni par la question 32 est donc injectif, et c'est un isomorphisme.
              Le quotient est minimal.

              On parcourt les états dans l'ordre croissant pour numéroter les classes, celle de l'état initial recevant $0$.
              Un représentant par classe suffit pour calculer les transitions.
              #code("reduit")
              Pour une entrée à $N$ états, dont $n$ accessibles, le temps et l'espace sont $O(N+n^2)$, donc $O(n^2)$ pour un automate accessible à $n$ états.
            ],
            bareme: 4,
            notation: [Repères : un cinquième pour les classes d'états indiscernables, un cinquième pour la construction correcte du quotient, un cinquième pour la conservation du langage, un cinquième pour la minimalité, un cinquième pour une implémentation cohérente. Adapter la répartition à toute autre méthode correcte et aux progrès partiels démontrés.],
          ),
        )),
      ),
    ),
  ),
)

#import "/load.typ": feuille
#let sujet = (titre: ex.meta.titre, exercices: (ex,), bareme: none)
#show: feuille.with(
  type: "concours",
  titre: ex.meta.titre,
  niveau: ex.meta.niveaux.join(" / "),
  concours: ex.meta.concours,
  exercices: sujet.exercices,
  corrige: sys.inputs.at("corrige", default: "false") == "true",
)
