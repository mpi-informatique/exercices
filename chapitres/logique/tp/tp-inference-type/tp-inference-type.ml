let echec f = (* vérifie qu'un appel lève une exception *)
  try ignore (f ()); false
  with _ -> true

(* Question 2 : dictionnaire persistant *)

type ('a, 'b) dict = Todo (* à remplacer par un ABR *)

let creer_dictionnaire () : ('a, 'b) dict =
  failwith "TODO: creer_dictionnaire"

let rec trouver (k : 'a) (d : ('a, 'b) dict) : 'b option =
  failwith "TODO: trouver"

let rec inserer (k : 'a) (v : 'b) (d : ('a, 'b) dict) : ('a, 'b) dict =
  failwith "TODO: inserer"

let test_dict () =
  let d = inserer "b" 2 (inserer "a" 1 (creer_dictionnaire ())) in
  assert (trouver "a" (creer_dictionnaire ()) = None);
  assert (trouver "a" d = Some 1);
  assert (trouver "b" d = Some 2);
  assert (trouver "a" (inserer "a" 10 d) = Some 10);
  assert (trouver "a" d = Some 1)

(* Inférence avec annotation des paramètres *)

type typ1 =
  | Int
  | Arrow of typ1 * typ1 (* t1 -> t2 *)
  | Product of typ1 * typ1 (* t1 * t2 *)

type expression1 =
  | Var of string
  | Const of int
  | Op of string (* (int * int) -> int *)
  | Fun of string * typ1 * expression1 (* fun (x : t) -> e *)
  | App of expression1 * expression1 (* e1 e2 *)
  | Couple of expression1 * expression1 (* e1, e2 *)
  | Let of string * expression1 * expression1 (* let x = e1 in e2 *)

(* Question 5 *)

let rec print_typ1 (t : typ1) : unit =
  failwith "TODO: print_typ1"

let rec print_expression1 (e : expression1) : unit =
  failwith "TODO: print_expression1"

let test_print1 () =
  let e = Let ("f", Fun ("x", Int, App (Op "+", Couple (Var "x", Const 1))), App (Var "f", Const 2)) in
  print_expression1 e; print_newline ();
  print_typ1 (Arrow (Product (Int, Int), Int)); print_newline ()

(* Question 6 *)

let typ_expr (e : expression1) : typ1 =
  let rec aux (env : (string, typ1) dict) (e : expression1) : typ1 = (* aux env e renvoie le type de e dans env *)
    match e with
    | Var x -> failwith "TODO"
    | Const _ -> failwith "TODO"
    | Op _ -> failwith "TODO"
    | Fun (x, t, e) -> failwith "TODO"
    | App (e1, e2) -> failwith "TODO"
    | Couple (e1, e2) -> failwith "TODO"
    | Let (x, e1, e2) -> failwith "TODO"
  in
  aux (creer_dictionnaire ()) e

let test_typ_expr () =
  let e1 = Let ("f", Fun ("x", Int, App (Op "+", Couple (Var "x", Const 1))), App (Var "f", Const 2)) in
  assert (typ_expr e1 = Int);
  let e2 =
    Fun ("f", Arrow (Int, Int), Fun ("g", Arrow (Int, Int), Fun ("x", Int, App (Var "f", App (Var "g", Var "x")))))
  in
  assert (typ_expr e2 = Arrow (Arrow (Int, Int), Arrow (Arrow (Int, Int), Arrow (Int, Int))));
  assert (echec (fun () -> typ_expr (Fun ("x", Int, App (Var "x", Var "x")))))

(* Inférence sans annotation *)

type typ2 =
  | Int
  | Arrow of typ2 * typ2
  | Product of typ2 * typ2
  | Tvar of int (* variable de type *)

type expression2 =
  | Var of string
  | Const of int
  | Op of string
  | Fun of string * expression2 (* sans annotation de type *)
  | App of expression2 * expression2
  | Couple of expression2 * expression2
  | Let of string * expression2 * expression2

(* Question 7 *)

let rec print_typ2 (t : typ2) : unit =
  failwith "TODO: print_typ2"

let rec print_expression2 (e : expression2) : unit =
  failwith "TODO: print_expression2"

let test_print2 () =
  print_expression2 (Fun ("x", App (Var "x", Const 2))); print_newline ();
  print_typ2 (Arrow (Arrow (Int, Tvar 0), Tvar 0)); print_newline ()

(* Question 9 *)

let rec appliquer (s : (int, typ2) dict) (t : typ2) : typ2 =
  failwith "TODO: appliquer"

let test_appliquer () =
  let s = inserer 1 Int (inserer 0 (Tvar 1) (creer_dictionnaire ())) in
  assert (appliquer s (Arrow (Tvar 0, Tvar 2)) = Arrow (Int, Tvar 2))

(* Question 10 *)

let rec unification (s : (int, typ2) dict) (t1 : typ2) (t2 : typ2) : (int, typ2) dict =
  failwith "TODO: unification"

let test_unification () =
  let s0 = creer_dictionnaire () in
  let s1 = unification s0 (Arrow (Tvar 0, Int)) (Arrow (Tvar 1, Tvar 2)) in
  assert (match appliquer s1 (Arrow (Tvar 0, Int)) with Arrow (Tvar _, Int) -> true | _ -> false);
  let s2 = unification s0 (Arrow (Tvar 0, Tvar 0)) (Arrow (Int, Tvar 1)) in
  assert (appliquer s2 (Arrow (Tvar 0, Tvar 0)) = Arrow (Int, Int));
  assert (echec (fun () -> unification s0 (Arrow (Tvar 0, Int)) (Product (Tvar 1, Tvar 2))));
  assert (echec (fun () -> unification s0 (Tvar 0) (Arrow (Tvar 0, Int))))

(* Questions 11 et 13 *)

let w (e : expression2) : typ2 =
  failwith "TODO: w"

let test_w () =
  assert (w (Fun ("x", App (Op "+", Couple (Var "x", Var "x")))) = Arrow (Int, Int));
  assert (match w (Fun ("x", App (Var "x", Const 2))) with Arrow (Arrow (Int, Tvar a), Tvar b) -> a = b | _ -> false);
  assert (echec (fun () -> w (App (Fun ("f", App (Op "+", App (Var "f", Const 1))), Fun ("x", Var "x")))));
  assert (echec (fun () -> w (Fun ("x", Couple (App (Var "x", Const 1), App (Var "x", Couple (Const 1, Const 2)))))))

let test_w_poly () =
  let id = Fun ("x", Var "x") in
  assert (w (Let ("f", Fun ("x", App (Op "+", Couple (Var "x", Const 1))), App (Var "f", Const 2))) = Int);
  assert (match w (Let ("f", id, App (Var "f", Var "f"))) with Arrow (Tvar a, Tvar b) -> a = b | _ -> false);
  assert (w (Let ("id", id, Couple (App (Var "id", Const 1), App (Var "id", Couple (Const 1, Const 2))))) = Product (Int, Product (Int, Int)));
  assert (echec (fun () -> w (Fun ("x", Let ("z", Var "x", Couple (App (Var "z", Const 1), App (Var "z", Couple (Const 1, Const 2))))))))
