#import "/load.typ": code, est-corrige, exercice, feuille, logique, question, telecharger
#import code: code-extrait
#import logique: arbre, rappel-regles, regles
#import "@preview/curryst:0.6.0": prooftree, rule

#let squelette = read("tp-inference-type.ml")
#let corrige = read("tp-inference-type-cor.ml")

#let kw(mot) = $upright(bold(#mot))$
#let tint = $upright("int")$

#let regle-var = rule(name: [Var], [$Γ, x : t ⊢ x : t$])
#let regle-const = rule(name: [Const], [$Γ ⊢ n : tint$])
#let regle-op = rule(name: [Op], [$Γ ⊢ + : (tint * tint) → tint$])
#let regle-fun-annote = rule(name: [Fun], [$Γ, x : t_1 ⊢ e : t_2$], [$Γ ⊢ (kw("fun") (x : t_1) → e) : t_1 → t_2$])
#let regle-fun = rule(name: [Fun], [$Γ, x : t_1 ⊢ e : t_2$], [$Γ ⊢ (kw("fun") x → e) : t_1 → t_2$])
#let regle-app = rule(name: [App], [$Γ ⊢ e_1 : t' → t$], [$Γ ⊢ e_2 : t'$], [$Γ ⊢ e_1 thick e_2 : t$])
#let regle-couple = rule(name: [Couple], [$Γ ⊢ e_1 : t_1$], [$Γ ⊢ e_2 : t_2$], [$Γ ⊢ (e_1, e_2) : (t_1 * t_2)$])
#let regle-let = rule(name: [Let], [$Γ ⊢ e_1 : t_1$], [$Γ, x : t_1 ⊢ e_2 : t_2$], [$Γ ⊢ (kw("let") x = e_1 kw("in") e_2) : t_2$])
#let regle-let-poly = rule(
  name: [Let],
  [$Γ ⊢ e_1 : t_1$],
  [$Γ, x : upright("Gen")(t_1, Γ) ⊢ e_2 : t_2$],
  [$Γ ⊢ (kw("let") x = e_1 kw("in") e_2) : t_2$],
)
#let regle-var-poly = rule(
  name: [Var],
  [$Γ, x : (∀ a_1 … a_n, thick t) ⊢ x : t[a_1 ← t_1, …, a_n ← t_n]$],
)

#let sujet = exercice(
  meta: (
    titre: "TP 6 – Inférence de type",
    chapitres: ("logique", "deduction-naturelle"),
    structures: ("arbre-binaire-de-recherche", "arbre", "liste"),
    langages: ("OCaml",),
    niveaux: ("MPI",),
    difficulte: 3,
    mots-cles: ("inférence de type", "unification", "algorithme W", "polymorphisme"),
  ),
)[
  Dans ce TP (adapté d'un sujet d'oral d'informatique du CCMP 2025), on implémente progressivement un inféreur de types pour un mini-langage fonctionnel à la OCaml.

  Le fichier à compléter est #telecharger("https://mpi-informatique.github.io/exercices/banque/chapitres/logique/tp/tp-inference-type/tp-inference-type.ml")[`tp-inference-type.ml`]. Il contient les définitions de types ainsi qu'une série de tests commentés à décommenter au fur et à mesure.

  #if est-corrige() [
    Le fichier #telecharger("https://mpi-informatique.github.io/exercices/banque/chapitres/logique/tp/tp-inference-type/tp-inference-type-cor.ml")[`tp-inference-type-cor.ml`] contient le corrigé complet.
  ]

  = Déduction naturelle

  On rappelle les règles de la déduction naturelle :

  #rappel-regles(classique: true)

  #question[
    Donner sur papier une dérivation en déduction naturelle du séquent :
    $ ⊢ ((a → b) ∧ (b → c)) → (a ∨ b) → c. $
  ][
    On note $P = (a → b) ∧ (b → c)$ et $Γ = {P, thick a ∨ b}$.
    #arbre(
      prooftree(
        rule(
          name: [$scripts(→)_i$],
          rule(
            name: [$scripts(→)_i$],
            rule(
              name: [$∨_e$],
              rule(name: [ax], [$Γ ⊢ a ∨ b$]),
              rule(
                name: [$scripts(→)_e$],
                rule(name: [$∧_e^d$], rule(name: [ax], [$Γ, a ⊢ P$]), [$Γ, a ⊢ b → c$]),
                rule(
                  name: [$scripts(→)_e$],
                  rule(name: [$∧_e^g$], rule(name: [ax], [$Γ, a ⊢ P$]), [$Γ, a ⊢ a → b$]),
                  rule(name: [ax], [$Γ, a ⊢ a$]),
                  [$Γ, a ⊢ b$],
                ),
                [$Γ, a ⊢ c$],
              ),
              rule(
                name: [$scripts(→)_e$],
                rule(name: [$∧_e^d$], rule(name: [ax], [$Γ, b ⊢ P$]), [$Γ, b ⊢ b → c$]),
                rule(name: [ax], [$Γ, b ⊢ b$]),
                [$Γ, b ⊢ c$],
              ),
              [$Γ ⊢ c$],
            ),
            [$P ⊢ (a ∨ b) → c$],
          ),
          [$⊢ P → (a ∨ b) → c$],
        ),
      ),
    )
  ]

  = Structure persistante de dictionnaire

  On utilise dans la suite des dictionnaires persistants pour associer un type à chaque variable ou représenter une substitution.

  #question[
    Implémenter une structure persistante de dictionnaire à l'aide d'arbres binaires de recherche dans un type `('a, 'b) dict`, où `'a` est le type des clés et `'b` celui des valeurs. Seules trois opérations sont nécessaires :
    - créer un dictionnaire vide (`creer_dictionnaire`)
    - récupérer la valeur associée à une clé (`trouver`)
    - insérer une paire clé-valeur (`inserer`)

    Préciser la complexité de chaque opération.
  ][
    #code-extrait(corrige, ("dict", "creer_dictionnaire", "trouver", "inserer"))
    La création est en $O(1)$. Les opérations `trouver` et `inserer` sont en $O(h)$ où $h$ est la hauteur de l'arbre, donc en $O(n)$ au pire sans équilibrage (avec $n$ le nombre d'éléments).
  ]

  = Inférence avec annotation des paramètres

  On représente d'abord le langage et ses types par `expression1` et `typ1` :
  #code-extrait(squelette, ("typ1", "expression1"))

  Dans cette première version, le type du paramètre d'une fonction est indiqué explicitement. Le seul type de base est `Int`, correspondant à `int`, et tous les opérateurs `Op` ont le type `(int * int) -> int`.

  #question(label: <q-expr1>)[
    Dans un système de types à la OCaml, l'expression suivante est-elle typable, et si oui de quel type ?
    ```ocaml
    Let ("f",
      Fun ("x", Int, App (Op "+", Couple (Var "x", Const 1))),
      App (Var "f", Const 2))
    ```
  ][
    L'expression correspond à `let f = fun (x : int) -> + (x, 1) in f 2`. La fonction `fun (x : int) -> + (x, 1)` a pour type `int -> int`. On applique ensuite `f` à `2` qui est de type `int`, donc l'expression est typable et de type `int`.
  ]

  On donne les règles suivantes pour dériver des jugements de typage ($x$ désigne une variable, $n$ une constante entière et $+$ un opérateur) :

  #rappel-regles(
    axiome: none,
    selection: (regle-var, regle-const, regle-op, regle-fun-annote, regle-app, regle-couple, regle-let),
  )

  #question[
    Dériver le typage de l'expression de la @q-expr1 dans ce système.
  ][
    #arbre(
      prooftree(
        rule(
          name: [Let],
          rule(
            name: [Fun],
            rule(
              name: [App],
              rule(name: [Op], [$x : tint ⊢ + : (tint * tint) → tint$]),
              rule(
                name: [Couple],
                rule(name: [Var], [$x : tint ⊢ x : tint$]),
                rule(name: [Const], [$x : tint ⊢ 1 : tint$]),
                [$x : tint ⊢ (x, 1) : tint * tint$],
              ),
              [$x : tint ⊢ +(x, 1) : tint$],
            ),
            [$⊢ kw("fun") (x : tint) → +(x, 1) : tint → tint$],
          ),
          rule(
            name: [App],
            rule(name: [Var], [$f : tint → tint ⊢ f : tint → tint$]),
            rule(name: [Const], [$f : tint → tint ⊢ 2 : tint$]),
            [$f : tint → tint ⊢ f thick 2 : tint$],
          ),
          [$⊢ kw("let") f = kw("fun") (x : tint) → +(x, 1) kw("in") f thick 2 : tint$],
        ),
      ),
    )
  ]

  #question[
    Écrire une fonction `print_typ1 : typ1 -> unit` et une fonction `print_expression1 : expression1 -> unit` affichant un type et une expression. L'expression précédente peut par exemple être affichée sous la forme `let f = fun x : int -> (+ (x, 1)) in (f 2)`.
  ][
    #code-extrait(corrige, ("print_typ1", "print_expression1"))
  ]

  #question[
    Écrire une fonction `typ_expr : expression1 -> typ1` renvoyant le type d'une expression, ou levant une erreur si elle n'est pas typable.

    _Indication._ Utiliser une fonction récursive qui suit les règles du système précédent, en encodant l'environnement $Γ$ par un `(string, typ1) dict`.
  ][
    #code-extrait(corrige, ("valeur_associee", "typ_expr"))
  ]

  = Inférence sans annotation

  On retire désormais les annotations de type sur les paramètres des fonctions et on introduit des _variables de type_, représentées par des entiers :
  #code-extrait(squelette, ("typ2", "expression2"))

  #question[
    Écrire les fonctions `print_typ2 : typ2 -> unit` et `print_expression2 : expression2 -> unit` correspondantes.
  ][
    Le principe est identique à la question précédente, avec un cas supplémentaire pour `Tvar`.
    #code-extrait(corrige, ("print_typ2", "print_expression2"))
  ]

  Dans toute la suite de cette partie, on ne considère que des expressions sans `Let`. Les règles du système de typage sont alors :

  #rappel-regles(
    axiome: none,
    selection: (regle-var, regle-const, regle-op, regle-fun, regle-app, regle-couple),
  )

  #question[
    Donner une dérivation du jugement de type :
    $ ⊢ kw("fun") f → kw("fun") g → kw("fun") x → f (g thick x) : (1 → 2) → (0 → 1) → 0 → 2 $
    où $0$, $1$ et $2$ sont des variables de type.
  ][
    On note $Γ = {f : 1 → 2, thick g : 0 → 1, thick x : 0}$.
    #arbre(
      prooftree(
        rule(
          name: [Fun],
          rule(
            name: [Fun],
            rule(
              name: [Fun],
              rule(
                name: [App],
                rule(name: [Var], [$Γ ⊢ f : 1 → 2$]),
                rule(
                  name: [App],
                  rule(name: [Var], [$Γ ⊢ g : 0 → 1$]),
                  rule(name: [Var], [$Γ ⊢ x : 0$]),
                  [$Γ ⊢ g thick x : 1$],
                ),
                [$Γ ⊢ f (g thick x) : 2$],
              ),
              [$f : 1 → 2, thick g : 0 → 1 ⊢ kw("fun") x → f (g thick x) : 0 → 2$],
            ),
            [$f : 1 → 2 ⊢ kw("fun") g → kw("fun") x → f (g thick x) : (0 → 1) → 0 → 2$],
          ),
          [$⊢ kw("fun") f → kw("fun") g → kw("fun") x → f (g thick x) : (1 → 2) → (0 → 1) → 0 → 2$],
        ),
      ),
    )
  ]

  Cette expression admet d'autres types, par exemple $(tint → tint) → (tint → tint) → tint → tint$, qui s'obtiennent tous par substitution des variables de type. Le type $(1 → 2) → (0 → 1) → 0 → 2$ est un _type le plus général_, et c'est un tel type que l'on cherche à inférer.

  Puisque les paramètres ne sont plus annotés, on associe initialement une variable de type _fraîche_ (non encore utilisée) à chaque paramètre de fonction. Les contraintes découvertes ensuite sont mémorisées dans une _substitution_, c'est-à-dire un dictionnaire associant à un numéro de variable de type un type de type `typ2`.

  #question[
    Écrire une fonction `appliquer : (int, typ2) dict -> typ2 -> typ2` qui remplace dans un type chaque variable apparaissant dans la substitution par le type associé.
  ][
    #code-extrait(corrige, "appliquer")
  ]

  Pour résoudre les contraintes de type, on utilise l'algorithme d'_unification_ : étant donnés deux types, il trouve une substitution la plus générale qui les rend égaux, ou détecte qu'ils ne sont pas unifiables. Par exemple, $0 → tint$ et $1 → 2$ s'unifient par la substitution $0 ⟼ 1, thick 2 ⟼ tint$, alors que $0 → tint$ et $1 * 2$ ne sont pas unifiables.

  #question[
    Écrire une fonction récursive `unification : (int, typ2) dict -> typ2 -> typ2 -> (int, typ2) dict` prenant la substitution courante et deux types, et renvoyant la substitution mise à jour (ou levant une erreur s'ils ne sont pas unifiables).

    _Indication._ En notant $t$ un type et $α$ une variable de type, après avoir appliqué la substitution courante aux deux types :
    - sur $t, t$, renvoyer la substitution courante
    - sur $t_1 → t'_1, thick t_2 → t'_2$, unifier $t_1$ et $t_2$, puis $t'_1$ et $t'_2$
    - sur $t_1 * t'_1, thick t_2 * t'_2$, procéder de même
    - sur $α, t$ ou $t, α$, si $α$ apparaît dans $t$ alors échouer, sinon remplacer $α$ par $t$ dans la substitution et y ajouter $α ⟼ t$
    - dans tous les autres cas, échouer
  ][
    On définit des fonctions auxiliaires sur les dictionnaires (`map_dict`), la substitution d'une variable et le test d'occurrence (`variable_libre_dans`), qui empêche de construire un type infini.
    #code-extrait(corrige, ("map_dict", "remplacer_variable", "variable_libre_dans", "ajouter_substitution", "unification"))
  ]

  L'_algorithme W_ infère un type le plus général selon le même principe que `typ_expr`, en attribuant une variable fraîche à chaque paramètre de fonction et en mettant à jour la substitution par unification à chaque application.

  #question[
    Écrire une fonction `w : expression2 -> typ2` implémentant cet algorithme pour les expressions sans `Let`.
  ][
    Dans le corrigé complet, cette première version est nommée `w_sans_polymorphisme` afin de réserver `w` à la version polymorphe finale.
    #code-extrait(corrige, ("compteur_types", "reset_compteur_types", "nouvelle_variable_type", "w_sans_polymorphisme"))
  ]

  = Inférence avec polymorphisme

  Pour typer les constructions `Let`, on généralise le type inféré pour la variable introduite afin que chacune de ses occurrences puisse recevoir une instanciation indépendante. On souhaite par exemple dériver :
  $ ⊢ kw("let") f = kw("fun") x → x kw("in") (f thick 1, f (1, 1)) : tint * (tint * tint). $

  On utilise alors des _schémas de types_ de la forme $∀ a_1 … a_n, thick t$ et l'opération de généralisation $upright("Gen")(t, Γ) = ∀ a_1 … a_n, thick t$, où $a_1, …, a_n$ sont les variables libres de $t$ qui ne sont pas libres dans $Γ$. Les règles du système deviennent :

  #rappel-regles(
    axiome: none,
    selection: (regle-const, regle-op, regle-fun, regle-app, regle-couple, regle-let-poly, regle-var-poly),
  )

  où $t_1, …, t_n$ sont des types quelconques.

  #question[
    Donner une dérivation du jugement de type précédent dans ce système.
  ][
    On type d'abord `fun x -> x` par $a → a$. Comme $a$ n'est pas libre dans l'environnement vide, sa généralisation est $∀ a, thick a → a$. On instancie ensuite $f$ indépendamment à chaque occurrence : en $tint → tint$ pour $f thick 1$, et en $(tint * tint) → (tint * tint)$ pour $f (1, 1)$.

    On note $Γ = {f : ∀ a, thick a → a}$.
    #arbre(
      prooftree(
        rule(
          name: [Let],
          rule(
            name: [Fun],
            rule(name: [Var], [$x : a ⊢ x : a$]),
            [$⊢ kw("fun") x → x : a → a$],
          ),
          rule(
            name: [Couple],
            rule(
              name: [App],
              rule(name: [Var], [$Γ ⊢ f : tint → tint$]),
              rule(name: [Const], [$Γ ⊢ 1 : tint$]),
              [$Γ ⊢ f thick 1 : tint$],
            ),
            rule(
              name: [App],
              rule(name: [Var], [$Γ ⊢ f : (tint * tint) → (tint * tint)$]),
              rule(
                name: [Couple],
                rule(name: [Const], [$Γ ⊢ 1 : tint$]),
                rule(name: [Const], [$Γ ⊢ 1 : tint$]),
                [$Γ ⊢ (1, 1) : tint * tint$],
              ),
              [$Γ ⊢ f (1, 1) : tint * tint$],
            ),
            [$Γ ⊢ (f thick 1, f (1, 1)) : tint * (tint * tint)$],
          ),
          [$⊢ kw("let") f = kw("fun") x → x kw("in") (f thick 1, f (1, 1)) : tint * (tint * tint)$],
        ),
      ),
    )
  ]

  #question[
    Écrire la nouvelle version de `w : expression2 -> typ2` implémentant l'algorithme W polymorphe.
  ][
    On représente un schéma de types par la liste de ses variables quantifiées et son type sous-jacent. On définit les opérations sur les ensembles de variables libres, l'application d'une substitution à un schéma (sans remplacer les variables quantifiées) et à un environnement, puis `generaliser` et `instancier`.
    #code-extrait(
      corrige,
      (
        "fold_dict",
        "schema",
        "ajouter_unique",
        "union",
        "difference",
        "variables_libres_type",
        "variables_libres_schema",
        "variables_libres_env",
        "appliquer_bloquees",
        "appliquer_schema",
        "appliquer_env",
        "generaliser",
        "instancier",
        "w",
      ),
    )
  ]
]

#show: feuille.with(
  type: "tp",
  titre: sujet.meta.titre,
  niveau: "MPI",
  exercices: (sujet,),
  tp: (
    ouvrir: "tp-inference-type.ml",
    squelette: ((source: "tp-inference-type.ml"),),
    corrige: ((source: "tp-inference-type-cor.ml"),),
  ),
  corrige: est-corrige(),
)
