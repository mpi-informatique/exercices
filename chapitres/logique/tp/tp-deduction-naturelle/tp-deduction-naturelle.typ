#import "/load.typ": code, est-corrige, exercice, feuille, question
#import code: code-extrait
#import "/load.typ": logique
#import logique: axiome, regles, tableau-regles

#let support = read("dnat.ml")
#let corrige = read("corrige.ml")
#let tests = read("main.ml")

#let sujet = exercice(
  meta: (
    titre: "TP 11 : Preuve automatique en déduction naturelle",
    chapitres: ("logique",),
    algorithmes: ("retour-sur-trace",),
    structures: ("arbre", "liste"),
    langages: ("OCaml",),
    niveaux: ("MPI",),
    difficulte: 3,
  ),
  corrections: [
    L'appel final `Option.iter (afficher_arbre_preuve 1)` est remplacé par `Option.iter afficher_arbre_preuve`, conformément au type de la fonction fournie.
    Les éliminations sont filtrées selon la conclusion à prouver et les sous-formules du contexte, au lieu d’énumérer systématiquement quatre règles par sous-formule.
    La liste des règles candidates est distinguée des règles effectivement applicables. Un échec de recherche bornée ne signifie pas que le séquent est improuvable.
  ],
)[
  Dans ce TP, nous implémentons un prouveur de théorèmes pour la logique minimale en déduction naturelle.

  = Représentation

  Le fichier `dnat.ml` définit les types suivants :
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    align: left + top,
    code-extrait(support, "formule"),
    code-extrait(support, "sequent"),
  )

  Compléter le fichier `main.ml`, qui charge les types et fonctions de `dnat.ml` avec `#mod_use` et `open Dnat`.

  Depuis le dossier du TP, lancer `utop`, puis charger le fichier :
  ```ocaml
  #use "main.ml";;
  ```

  Après chaque modification, recharger le fichier avec cette même commande.
  Pour tester une question, appeler la fonction correspondante, par exemple `test_seq ();;` après la première question.
  Une assertion réussie ne produit aucun message. Une assertion fausse lève `Assert_failure`.
  Les tests ne s'exécutent pas automatiquement au chargement et peuvent donc être utilisés au fil du TP.

  #question[
    Écrire une fonction utilitaire `seq : formule list -> formule -> sequent` renvoyant un séquent $Γ ⊢ φ$ à partir de $Γ$ et $φ$.
  ][#code-extrait(corrige, "seq")]

  #code-extrait(tests, "test_seq")

  #question[
    Écrire une fonction `string_of_formule : formule -> string` avec `F`, `&`, `|`, `!` pour faux, et, ou, non, et `->` pour l'implication.
    On rappelle que `^` sert à concaténer des chaînes en OCaml.
  ][#code-extrait(corrige, "string_of_formule")]

  #code-extrait(tests, "test_string_of_formule")

  #question[
    Écrire une fonction `string_of_sequent : sequent -> string`.
  ][#code-extrait(corrige, "string_of_sequent")]

  #code-extrait(tests, "test_string_of_sequent")

  = Règles et arbres de preuve

  Les types suivants sont définis dans `dnat.ml` :
  #code-extrait(support, ("regle", "arbre_preuve"))

  Par exemple, `ImpliesElim (And (Var "A", Var "B"))` correspond à appliquer la règle d'élimination de l'implication où $X$ est remplacé par $A ∧ B$.

  Les règles utilisées sont données ci-dessous. Le contexte $Γ, X$ est représenté par `X :: gamma`. L’axiome correspond au constructeur `Axiom`.

  #tableau-regles(
    axiome: axiome,
    rempli: true,
    (
      (..regles.implication, condition-introduction: [`ImpliesIntro`], condition-elimination: [`ImpliesElim X`]),
      (..regles.conjonction, condition-introduction: [`AndIntro`], condition-elimination: [`AndElim1 Y` et `AndElim2 X`]),
      (..regles.disjonction, condition-introduction: [`OrIntro1` et `OrIntro2`], condition-elimination: [`OrElim (X, Y)`]),
      (..regles.negation, condition-introduction: [`NotIntro`], condition-elimination: [`NotElim X`]),
    ),
  )

  #question[
    Écrire `appliquer_regle : regle -> sequent -> sequent list option` vérifiant si la règle est applicable au séquent donné, et si oui, renvoyant la liste des prémisses à prouver. Si la règle n'est pas applicable, renvoyer `None`.
    Pour simplifier, on utilise ci-dessous la fonction `parse : string -> sequent` de `dnat.ml` pour construire les séquents.
  ][#code-extrait(corrige, "appliquer_regle")]

  #code-extrait(tests, "test_appliquer_regle")

  = Recherche de preuve

  #question[
    Écrire `sous_formules_f : formule -> formule list` qui renvoie la liste de toutes les sous-formules d'une formule donnée (y compris la formule elle-même).
  ][#code-extrait(corrige, "sous_formules_f")]

  #code-extrait(tests, "test_sous_formules_f")

  #question[
    Écrire `sous_formules_gamma : formule list -> formule list` qui renvoie la liste de toutes les sous-formules présentes dans le contexte `gamma`.
  ][#code-extrait(corrige, "sous_formules_gamma")]

  #code-extrait(tests, "test_sous_formules_gamma")

  #question[
    Écrire `regles_possibles : sequent -> regle list` qui, étant donné un séquent, renvoie une liste de règles candidates pour prouver ce séquent. On utilisera les sous-formules du contexte $Γ$ pour limiter les règles proposées.

    Ainsi, sur un séquent $Γ ⊢ A$ :
    - Ajouter `Axiom` en tête de liste
    - Ajouter les règles d'introduction qui permettent d'obtenir $A$ (exemple : `AndIntro` si $A$ est de la forme $B ∧ C$)
    - Ajouter seulement les éliminations suivantes, selon les sous-formules de $Γ$ :
      - `AndElim1 X` si $A ∧ X$ est une sous-formule
      - `AndElim2 X` si $X ∧ A$ est une sous-formule
      - `ImpliesElim X` si $X → A$ est une sous-formule
      - `NotElim X` si $A = ⊥$ et $¬ X$ est une sous-formule
      - `OrElim (X, Y)` si $X ∨ Y$ est une sous-formule

    Ces règles seront ensuite vérifiées par `appliquer_regle`.
  ][#code-extrait(corrige, "regles_possibles")]

  #code-extrait(tests, "test_regles_possibles")

  #question[
    Écrire `prouver : int -> sequent -> arbre_preuve option` qui, étant donné une profondeur maximale `depth` et un séquent, renvoie un arbre de preuve pour ce séquent s'il en trouve un, et `None` sinon. On utilisera `afficher_arbre_preuve : arbre_preuve -> unit` de `dnat.ml` pour afficher l'arbre de preuve.

    Indications :
    - Cas de base : si `depth <= 0`, renvoyer `None`
    - Sinon, essayer les règles retournées par `regles_possibles` une par une
    - Pour une règle applicable, prouver toutes les prémisses avec profondeur `depth - 1`
    - Si une prémisse échoue, revenir en arrière (_backtracking_) et tester la règle suivante

    Ici, la profondeur compte les nœuds du plus long chemin de la racine à une feuille : une preuve réduite à un axiome a profondeur $1$.
    Un résultat `None` ne permet pas de conclure que le séquent est improuvable.
  ][#code-extrait(corrige, "prouver")]

  #code-extrait(tests, "test_prouver")

  Essayer avec d'autres séquents plus difficiles.

  #question[
    Écrire `prouver_min : int -> sequent -> arbre_preuve option` qui, étant donné une profondeur maximale `max_depth` et un séquent, tente de trouver une preuve de ce séquent avec la plus petite profondeur possible parmi les preuves explorées (inférieure ou égale à `max_depth`).
  ][#code-extrait(corrige, "prouver_min")]

  #code-extrait(tests, "test_prouver_min")

  Quand vous avez fini, vous entraîner sur #link("https://fortierq.github.io/deduction-naturelle").
]

#show: feuille.with(
  type: "tp",
  titre: sujet.meta.titre,
  niveau: "MPI",
  exercices: (sujet,),
  tp: (
    ouvrir: "main.ml",
    squelette: ((source: "main.ml"),),
    ressources: ((source: "dnat.ml"),),
    corrige: ((source: "corrige.ml"),),
  ),
  corrige: est-corrige(),
)
