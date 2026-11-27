(* Implémentation de dictionnaire *)


(* Inférence avec annotation de paramètre *)

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

(* Tests partie 3 *)

(*
let test1 e =
  print_expression1 e;
  print_newline ();
  begin
    try print_typ1 (typ_expr e)
    with _ -> print_string "terme non typable"
  end;
  print_newline ()

let () =
  let e =
    Let
      ( "f",
        Fun ("x", Int, App (Op "+", Couple (Var "x", Const 1))),
        App (Var "f", Const 2) )
  in
  test1 e
(* type attendu : int *)

let () =
  let e =
    Fun
      ( "f",
        Arrow (Int, Int),
        Fun
          ( "g",
            Arrow (Int, Int),
            Fun ("x", Int, App (Var "f", App (Var "g", Var "x"))) ) )
  in
  test1 e
(* type attendu : (int -> int) -> (int -> int) -> int -> int *)

let () =
  let e = Fun ("x", Int, App (Var "x", Var "x")) in
  test1 e
(* non typable *)

let () =
  let e =
    App
      ( Fun ("x", Int, Var "x"),
        App
          ( Fun ("x", Product (Int, Int), App (Op "+", Var "x")),
            Couple (Const 1, Const 2) ) )
  in
  test1 e
(* int *)
*)

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

(* Tests unification *)

(*
let test_unif t1 t2 =
  print_string "t1 : ";
  print_typ2 t1;
  print_newline ();
  print_string "t2 : ";
  print_typ2 t2;
  print_newline ();
  begin
    try
      let s = unification (creer_dictionnaire ()) t1 t2 in
      print_string "unification : ";
      print_typ2 (appliquer s t1)
    with _ -> print_string "types non unifiables"
  end;
  print_newline ()

let () =
  let t1 = Arrow (Tvar 0, Int) in
  let t2 = Arrow (Tvar 1, Tvar 2) in
  test_unif t1 t2
(* 1 -> int *)

let () =
  let t1 = Arrow (Tvar 0, Int) in
  let t2 = Product (Tvar 1, Tvar 2) in
  test_unif t1 t2
(* échec *)

let () =
  let t1 = Arrow (Product (Tvar 0, Tvar 1), Int) in
  let t2 = Arrow (Product (Int, Int), Tvar 3) in
  test_unif t1 t2
(* (int * int) -> int *)

let () =
  let t1 = Arrow (Tvar 0, Tvar 0) in
  let t2 = Arrow (Int, Tvar 1) in
  test_unif t1 t2
(* int -> int *)

let () =
  let t1 = Arrow (Tvar 0, Tvar 0) in
  let t2 = Arrow (Int, Product (Int, Int)) in
  test_unif t1 t2
(* échec *)
*)

(* Tests W sans polymorphisme *)

(*
let test2 e =
  print_expression2 e;
  print_newline ();
  begin
    try print_typ2 (w e)
    with _ -> print_string "terme non typable"
  end;
  print_newline ()

let () =
  let e = Fun ("x", App (Var "x", Const 2)) in
  test2 e
(* (int -> 1) -> 1 *)

let () =
  let e = Fun ("x", App (Op "+", Couple (Var "x", Var "x"))) in
  test2 e
(* int -> int *)

let () =
  let e = Fun ("f", Fun ("g", Fun ("x", App (Var "f", App (Var "g", Var "x"))))) in
  test2 e
(* (3 -> 4) -> ((2 -> 3) -> (2 -> 4)) *)

let () =
  let e =
    App
      ( Fun ("f", App (Op "+", App (Var "f", Const 1))),
        Fun ("x", Var "x") )
  in
  test2 e
(* échec *)

let () =
  let e =
    Fun
      ( "x",
        Couple (App (Var "x", Const 1), App (Var "x", Couple (Const 1, Const 2))) )
  in
  test2 e
(* échec *)
*)

(* Inférence avec polymorphisme *)

(* Tests avec polymorphisme *)

(*
let () =
  let e =
    Let
      ( "f",
        Fun ("x", App (Op "+", Couple (Var "x", Const 1))),
        App (Var "f", Const 2) )
  in
  test2 e
(* int *)

let id = Fun ("x", Var "x")

let () =
  let e = Let ("f", id, App (Var "f", Var "f")) in
  test2 e
(* 2 -> 2 *)

let () =
  let e =
    Let ("f", Fun ("x", Var "x"), Couple (App (Var "f", id), App (Var "f", Const 2)))
  in
  test2 e
(* (4 -> 4) * int *)

let () =
  let e =
    Let ("f", Fun ("x", Var "x"), Couple (App (Var "f", Const 2), App (Var "f", id)))
  in
  test2 e
(* int * (2 -> 2) *)

let () =
  let e =
    Let
      ( "f",
        Fun ("x", Var "x"),
        Couple (App (Var "f", Const 2), App (Var "f", Fun ("x", Const 2))) )
  in
  test2 e
(* int * (2 -> int) *)

let () =
  let e =
    Let
      ( "id",
        Fun ("x", Var "x"),
        Couple (App (Var "id", Const 1), App (Var "id", Couple (Const 1, Const 2))) )
  in
  test2 e
(* int * (int * int) *)

let () =
  let e = Fun ("f", Fun ("x", Let ("y", App (Var "f", Var "x"), Var "y"))) in
  test2 e
(* (1 -> 2) -> (1 -> 2) *)

let () =
  let e =
    Fun
      ( "x",
        Let
          ( "z",
            Var "x",
            Couple (App (Var "z", Const 1), App (Var "z", Couple (Const 1, Const 2))) ) )
  in
  test2 e
(* échec *)

let () =
  let e =
    Let
      ( "distr_pair",
        Fun
          ( "f",
            Couple
              (App (Var "f", Const 1), App (Var "f", Couple (Const 1, Const 2))) ),
        App (Var "distr_pair", Fun ("x", Var "x")) )
  in
  test2 e
(* échec *)
*)
