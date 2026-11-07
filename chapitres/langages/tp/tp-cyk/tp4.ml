(* TP 4 : Algorithme CYK. Les questions 1 à 5 sont à faire sur papier. *)
type grammaire = {
  n_variables : int;
  regles1 : (int * char) list;
  regles2 : (int * int * int) list;
  epsilon : bool
}

(* 6. Représenter la grammaire de l'énoncé. *)
let g0 : grammaire = failwith "À compléter : g0"

(* 7. Initialiser le tableau pour les facteurs de taille 1 d'un mot non vide. *)
let init (g : grammaire) (u : string) : bool array array array =
  failwith "À compléter : init"

(* 8. Tester l'appartenance au langage de la grammaire, mot vide compris. *)
let cyk (g : grammaire) (u : string) : bool =
  failwith "À compléter : cyk"

(* 9. Justifier le langage engendré par g0, puis tester cyk. *)

type arbre = Vide | Un of int * char | Deux of int * arbre * arbre

(* 10. Construire un arbre de dérivation lorsqu'il en existe un. *)
let arbre_derivation (g : grammaire) (u : string) : arbre option =
  failwith "À compléter : arbre_derivation"
