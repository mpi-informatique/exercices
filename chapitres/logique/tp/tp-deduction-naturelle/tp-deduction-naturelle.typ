#import "/load.typ": code, est-corrige, exercice, feuille, question
#import code: code-extrait
#import "@preview/curryst:0.6.0": prooftree, rule

#let support = read("dnat.ml")
#let corrige = read("corrige.ml")

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
  #code-extrait(support, ("formule", "sequent"))

  Compléter le fichier `main.ml`. On utilisera les types et fonctions de `dnat.ml` avec `open Dnat` au début du fichier.

  Compilation et exécution :
  ```sh
  ocamlc dnat.ml main.ml -o tp && ./tp
  ```

  On utilisera aussi `utop` pour les tests, en exécutant `#mod_use "dnat.ml";;` puis `#use "main.ml";;` depuis le dossier du TP.

  #question[
    Écrire une fonction utilitaire `seq : formule list -> formule -> sequent` renvoyant un séquent $Γ ⊢ φ$ à partir de $Γ$ et $φ$.
  ][#code-extrait(corrige, "seq")]

  #question[
    Écrire une fonction `string_of_formule : formule -> string` avec `F`, `&`, `|`, `!` pour faux, et, ou, non, et `->` pour l'implication.
    On rappelle que `^` sert à concaténer des chaînes en OCaml.
  ][#code-extrait(corrige, "string_of_formule")]

  #question[
    Écrire une fonction `string_of_sequent : sequent -> string`.
  ][#code-extrait(corrige, "string_of_sequent")]

  ```ocaml
  string_of_formule (And (Var "A", Not (Var "B")))
  (* "(A & (! B))" *)
  string_of_formule (Implies (Var "A", Or (Var "A", Var "B")))
  (* "(A -> (A | B))" *)

  string_of_sequent {
    gamma = [Var "A"; Implies (Var "A", Var "B")];
    phi = Var "B";
  }
  (* "A, (A -> B) |- B" *)
  ```

  = Règles et arbres de preuve

  Les types suivants sont définis dans `dnat.ml` :
  #code-extrait(support, ("regle", "arbre_preuve"))

  Par exemple, `ImpliesElim (And (Var "A", Var "B"))` correspond à appliquer la règle d'élimination de l'implication où $X$ est remplacé par $A ∧ B$.

  Les règles utilisées sont données ci-dessous. Le contexte $Γ, X$ est représenté par `X :: gamma`.

  #table(
    columns: (auto, 1fr),
    align: (left, center + horizon),
    inset: (x: 0.6em, y: 0.5em),
    stroke: 0.4pt + luma(190),
    table.header([*Règle OCaml*], [*Schéma d'inférence*]),
    [`Axiom`], [#prooftree(rule(name: [ax], [$Γ ⊢ A$])) #h(1em) ($A ∈ Γ$)],
    [`ImpliesIntro`], prooftree(rule(name: [$scripts(→)_i$], [$Γ, X ⊢ Y$], [$Γ ⊢ X → Y$])),
    [`ImpliesElim X`], prooftree(rule(name: [$scripts(→)_e$], [$Γ ⊢ X → A$], [$Γ ⊢ X$], [$Γ ⊢ A$])),
    [`AndIntro`], prooftree(rule(name: [$∧_i$], [$Γ ⊢ X$], [$Γ ⊢ Y$], [$Γ ⊢ X ∧ Y$])),
    [`AndElim1 X`], prooftree(rule(name: [$∧_e^g$], [$Γ ⊢ A ∧ X$], [$Γ ⊢ A$])),
    [`AndElim2 X`], prooftree(rule(name: [$∧_e^d$], [$Γ ⊢ X ∧ A$], [$Γ ⊢ A$])),
    [`OrIntro1`], prooftree(rule(name: [$∨_i^g$], [$Γ ⊢ X$], [$Γ ⊢ X ∨ Y$])),
    [`OrIntro2`], prooftree(rule(name: [$∨_i^d$], [$Γ ⊢ Y$], [$Γ ⊢ X ∨ Y$])),
    [`OrElim (X, Y)`], prooftree(rule(name: [$∨_e$], [$Γ ⊢ X ∨ Y$], [$Γ, X ⊢ A$], [$Γ, Y ⊢ A$], [$Γ ⊢ A$])),
    [`NotIntro`], prooftree(rule(name: [$¬_i$], [$Γ, X ⊢ ⊥$], [$Γ ⊢ ¬ X$])),
    [`NotElim X`], prooftree(rule(name: [$¬_e$], [$Γ ⊢ ¬ X$], [$Γ ⊢ X$], [$Γ ⊢ ⊥$])),
  )

  #question[
    Écrire `appliquer_regle : regle -> sequent -> sequent list option` vérifiant si la règle est applicable au séquent donné, et si oui, renvoyant la liste des prémisses à prouver. Si la règle n'est pas applicable, renvoyer `None`.
    Pour simplifier, on utilise ci-dessous la fonction `parse : string -> sequent` de `dnat.ml` pour construire les séquents.
  ][#code-extrait(corrige, "appliquer_regle")]

  ```ocaml
  appliquer_regle Axiom (parse "A |- A");;
  - : sequent list option = Some []
  appliquer_regle Axiom (parse "A |- B");;
  - : sequent list option = None
  appliquer_regle AndIntro (parse "A |- (A & B)");;
  - : sequent list option =
  Some [{gamma = [Var "A"]; phi = Var "A"};
        {gamma = [Var "A"]; phi = Var "B"}]
  appliquer_regle (NotElim (parse "A | B").phi)
    (parse "B, !A |- F");;
  - : sequent list option =
  Some [{gamma = [Var "B"; Not (Var "A")];
         phi = Not (Or (Var "A", Var "B"))};
        {gamma = [Var "B"; Not (Var "A")];
         phi = Or (Var "A", Var "B")}]
  appliquer_regle (OrElim (Var "A", Var "B")) (parse "|- C");;
  - : sequent list option =
  Some [{gamma = []; phi = Or (Var "A", Var "B")};
        {gamma = [Var "A"]; phi = Var "C"};
        {gamma = [Var "B"]; phi = Var "C"}]
  ```

  = Recherche de preuve

  #question[
    Écrire `sous_formules_f : formule -> formule list` qui renvoie la liste de toutes les sous-formules d'une formule donnée (y compris la formule elle-même).
  ][#code-extrait(corrige, "sous_formules_f")]

  ```ocaml
  sous_formules_f (parse "A & (B | C)").phi;;
  - : formule list =
  [And (Var "A", Or (Var "B", Var "C")); Var "A";
   Or (Var "B", Var "C"); Var "B"; Var "C"]
  ```

  #question[
    Écrire `sous_formules_gamma : formule list -> formule list` qui renvoie la liste de toutes les sous-formules présentes dans le contexte `gamma`.
  ][#code-extrait(corrige, "sous_formules_gamma")]

  ```ocaml
  sous_formules_gamma (parse "(A & B), (C | D) |- A").gamma;;
  - : formule list =
  [And (Var "A", Var "B"); Var "A"; Var "B";
   Or (Var "C", Var "D"); Var "C"; Var "D"]
  ```

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

  ```ocaml
  regles_possibles (parse "(A & B) |- A");;
  - : regle list =
  [Axiom; AndElim1 (Var "B")]
  ```

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

  ```ocaml
  prouver 2 (parse "(A & B) |- A")
    |> Option.iter afficher_arbre_preuve
    [AndElim1(B)] (A & B) |- A
      [Axiom] (A & B) |- (A & B)
  prouver 4 (parse "|- (A & B) -> (B & A)")
    |> Option.iter afficher_arbre_preuve
    [ImpliesIntro]  |- ((A & B) -> (B & A))
      [AndIntro] (A & B) |- (B & A)
        [AndElim2(A)] (A & B) |- B
          [Axiom] (A & B) |- (A & B)
        [AndElim1(B)] (A & B) |- A
          [Axiom] (A & B) |- (A & B)
  ```

  Essayer avec d'autres séquents plus difficiles.

  #question[
    Écrire `prouver_min : int -> sequent -> arbre_preuve option` qui, étant donné une profondeur maximale `max_depth` et un séquent, tente de trouver une preuve de ce séquent avec la plus petite profondeur possible parmi les preuves explorées (inférieure ou égale à `max_depth`).
  ][#code-extrait(corrige, "prouver_min")]

  ```ocaml
  prouver_min 8
    (parse "|- (A & (B | C)) -> ((A & B) | (A & C))")
    |> Option.iter afficher_arbre_preuve
  ```

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
