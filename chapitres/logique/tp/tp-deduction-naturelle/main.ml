#mod_use "dnat.ml";;

open Dnat

(* Question 1 *)
let seq (_gamma : formule list) (_phi : formule) : sequent =
  failwith "TODO: seq"

let test_seq () =
  assert (seq [Var "A"] (Var "B") = parse "A |- B")

(* Question 2 *)
let rec string_of_formule (_f : formule) : string =
  failwith "TODO: string_of_formule"

let test_string_of_formule () =
  assert (string_of_formule (And (Var "A", Not (Var "B"))) = "(A & (! B))");
  assert (string_of_formule (parse "A -> (A | B)").phi = "(A -> (A | B))")

(* Question 3 *)
let string_of_sequent (_s : sequent) : string =
  failwith "TODO: string_of_sequent"

let test_string_of_sequent () =
  assert (string_of_sequent (parse "A, A -> B |- B") = "A, (A -> B) |- B")

(* Question 4 *)
let appliquer_regle (_r : regle) (_s : sequent) : sequent list option =
  failwith "TODO: appliquer_regle"

let test_appliquer_regle () =
  assert (appliquer_regle Axiom (parse "A |- A") = Some []);
  assert (appliquer_regle Axiom (parse "A |- B") = None);
  assert (appliquer_regle AndIntro (parse "A |- A & B") = Some [parse "A |- A"; parse "A |- B"]);
  assert (appliquer_regle (NotElim (Var "A")) (parse "A, !A |- F") = Some [parse "A, !A |- !A"; parse "A, !A |- A"]);
  assert (appliquer_regle (OrElim (Var "A", Var "B")) (parse "|- C") = Some [parse "|- A | B"; parse "A |- C"; parse "B |- C"])

(* Question 5 *)
let rec sous_formules_f (_f : formule) : formule list =
  failwith "TODO: sous_formules_f"

let test_sous_formules_f () =
  let a = Var "A" and b = Var "B" and c = Var "C" in
  assert (sous_formules_f (And (a, Or (b, c))) = [And (a, Or (b, c)); a; Or (b, c); b; c]);
  assert (sous_formules_f (Not a) = [Not a; a])

(* Question 6 *)
let sous_formules_gamma (_gamma : formule list) : formule list =
  failwith "TODO: sous_formules_gamma"

let test_sous_formules_gamma () =
  let a = Var "A" and b = Var "B" and c = Var "C" and d = Var "D" in
  assert (sous_formules_gamma [And (a, b); Or (c, d)] = [And (a, b); a; b; Or (c, d); c; d]);
  assert (sous_formules_gamma [] = [])

(* Question 7 *)
let regles_possibles (_s : sequent) : regle list =
  failwith "TODO: regles_possibles"

let test_regles_possibles () =
  assert (regles_possibles (parse "A & B |- A") = [Axiom; AndElim1 (Var "B")]);
  assert (regles_possibles (parse "A & A |- A") = [Axiom; AndElim1 (Var "A"); AndElim2 (Var "A")])

(* Question 8 *)
let rec prouver (_depth : int) (_s : sequent) : arbre_preuve option =
  failwith "TODO: prouver"

let test_prouver () =
  assert (prouver 0 (parse "A |- A") = None);
  assert (prouver 1 (parse "A |- A") <> None);
  assert (prouver 2 (parse "A |- B") = None);
  assert (prouver 2 (parse "F |- A") = None);
  prouver 2 (parse "A & B |- A") |> Option.get |> afficher_arbre_preuve;
  prouver 4 (parse "|- (A & B) -> (B & A)") |> Option.get |> afficher_arbre_preuve

(* Question 9 *)
let prouver_min (_max_depth : int) (_s : sequent) : arbre_preuve option =
  failwith "TODO: prouver_min"

let test_prouver_min () =
  let s = parse "|- (A & B) -> (B & A)" in
  assert (prouver_min 0 s = None);
  assert (prouver_min 3 s = None);
  assert (prouver_min 4 s <> None);
  prouver_min 8 (parse "|- (A & (B | C)) -> ((A & B) | (A & C))") |> Option.get |> afficher_arbre_preuve
