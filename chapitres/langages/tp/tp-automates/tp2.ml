(* TP : Automates. Exécuter les définitions dans utop avec Maj + Entrée. *)
type afdc = {
  initial : int;
  finaux : int list;
  delta : int array array
}

(* 1. Représenter les deux automates de l'énoncé. *)
let a1 : afdc = failwith "À compléter : a1"
let a2 : afdc = failwith "À compléter : a2"

(* 2. Calculer l'état atteint après lecture d'un mot. *)
let delta_etoile (a : afdc) (q : int) (u : int list) : int =
  failwith "À compléter : delta_etoile"

(* 3. Tester l'appartenance au langage reconnu. *)
let accepte (a : afdc) (u : int list) : bool =
  failwith "À compléter : accepte"

(* 4. Construire l'automate du complémentaire. *)
let complementaire (a : afdc) : afdc =
  failwith "À compléter : complementaire"

(* 5. Déterminer les états accessibles. *)
let accessibles (a : afdc) : int list =
  failwith "À compléter : accessibles"

(* 6. Tester si le langage reconnu est vide. *)
let vide (a : afdc) : bool =
  failwith "À compléter : vide"

(* 7. Construire l'automate produit pour l'intersection. *)
let inter (a : afdc) (b : afdc) : afdc =
  failwith "À compléter : inter"

(* 8. Tester l'inclusion des langages reconnus. *)
let inclus (a : afdc) (b : afdc) : bool =
  failwith "À compléter : inclus"

(* 9. Tester l'équivalence de deux automates. *)
let equivalent (a : afdc) (b : afdc) : bool =
  failwith "À compléter : equivalent"
