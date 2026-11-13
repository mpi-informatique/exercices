open Dnat

(* Question 1 *)
let seq (_gamma : formule list) (_phi : formule) : sequent =
  failwith "TODO: seq"

(* Question 2 *)
let rec string_of_formule (_f : formule) : string =
  failwith "TODO: string_of_formule"

(* Question 3 *)
let string_of_sequent (_s : sequent) : string =
  failwith "TODO: string_of_sequent"

(* Question 4 *)
let appliquer_regle (_r : regle) (_s : sequent) : sequent list option =
  failwith "TODO: appliquer_regle"

(* Question 5 *)
let rec sous_formules_f (_f : formule) : formule list =
  failwith "TODO: sous_formules_f"

(* Question 6 *)
let sous_formules_gamma (_gamma : formule list) : formule list =
  failwith "TODO: sous_formules_gamma"

(* Question 7 *)
let regles_possibles (_s : sequent) : regle list =
  failwith "TODO: regles_possibles"

(* Question 8 *)
let rec prouver (_depth : int) (_s : sequent) : arbre_preuve option =
  failwith "TODO: prouver"

(* Question 9 *)
let prouver_min (_max_depth : int) (_s : sequent) : arbre_preuve option =
  failwith "TODO: prouver_min"
