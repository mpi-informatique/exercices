(* Question 2 : dictionnaire persistant *)

type ('a, 'b) dict =
  | V (* vide *)
  | N of ('a, 'b) dict * 'a * 'b * ('a, 'b) dict (* nœud *)

let creer_dictionnaire () = V

let rec trouver k = function
  | V -> None
  | N (g, k', v, d) ->
    if k = k' then Some v
    else if k < k' then trouver k g
    else trouver k d

let rec inserer k v = function
  | V -> N (V, k, v, V)
  | N (g, k', v', d) ->
    if k = k' then N (g, k, v, d)
    else if k < k' then N (inserer k v g, k', v', d)
    else N (g, k', v', inserer k v d)

let rec map_dict f = function
  | V -> V
  | N (g, k, v, d) -> N (map_dict f g, k, f v, map_dict f d)

let rec fold_dict f d acc =
  match d with
  | V -> acc
  | N (g, k, v, d) ->
    let acc = fold_dict f g acc in
    let acc = f acc k v in
    fold_dict f d acc

let chercher x d =
  match trouver x d with
  | Some v -> v
  | None -> failwith ("identifiant inconnu : " ^ x)

(* Inférence avec annotation des paramètres *)

type typ1 =
  | Int
  | Arrow of typ1 * typ1
  | Product of typ1 * typ1

type expression1 =
  | Var of string
  | Const of int
  | Op of string
  | Fun of string * typ1 * expression1
  | App of expression1 * expression1
  | Couple of expression1 * expression1
  | Let of string * expression1 * expression1

(* Question 5 *)

let rec print_typ1 = function
  | Int -> Printf.printf "int"
  | Product (g, d) -> Printf.printf "("; print_typ1 g; Printf.printf " * "; print_typ1 d; Printf.printf ")"
  | Arrow (g, d) -> Printf.printf "("; print_typ1 g; Printf.printf " -> "; print_typ1 d; Printf.printf ")"

let rec print_expression1 = function
  | Var x -> Printf.printf "%s" x
  | Const n -> Printf.printf "%d" n
  | Op op -> Printf.printf "%s" op
  | Fun (x, t, e) ->
    Printf.printf "fun %s : " x;
    print_typ1 t;
    Printf.printf " -> ";
    print_expression1 e
  | App (e1, e2) ->
    Printf.printf "("; print_expression1 e1; Printf.printf " "; print_expression1 e2; Printf.printf ")"
  | Couple (e1, e2) ->
    Printf.printf "("; print_expression1 e1; Printf.printf ", "; print_expression1 e2; Printf.printf ")"
  | Let (x, e1, e2) ->
    Printf.printf "let %s = " x;
    print_expression1 e1;
    Printf.printf " in ";
    print_expression1 e2

(* Question 6 *)

let typ_expr e =
  let rec aux env = function (* aux env e renvoie le type de e dans l'environnement env *)
    | Var x -> chercher x env
    | Const _ -> Int
    | Op _ -> Arrow (Product (Int, Int), Int)
    | Fun (x, t, e) -> Arrow (t, aux (inserer x t env) e)
    | App (e1, e2) ->
      let t1 = aux env e1 in
      let t2 = aux env e2 in
      begin
        match t1 with
        | Arrow (arg, res) when arg = t2 -> res
        | Arrow _ -> failwith "argument de type incorrect"
        | _ -> failwith "application d'une expression non fonctionnelle"
      end
    | Couple (e1, e2) -> Product (aux env e1, aux env e2)
    | Let (x, e1, e2) -> aux (inserer x (aux env e1) env) e2
  in
  aux (creer_dictionnaire ()) e

(* Inférence sans annotation *)

type typ2 =
  | Int
  | Arrow of typ2 * typ2
  | Product of typ2 * typ2
  | Tvar of int

type expression2 =
  | Var of string
  | Const of int
  | Op of string
  | Fun of string * expression2
  | App of expression2 * expression2
  | Couple of expression2 * expression2
  | Let of string * expression2 * expression2

(* Question 7 *)

let rec print_typ2 = function
  | Int -> Printf.printf "int"
  | Tvar n -> Printf.printf "%d" n
  | Product (g, d) -> Printf.printf "("; print_typ2 g; Printf.printf " * "; print_typ2 d; Printf.printf ")"
  | Arrow (g, d) -> Printf.printf "("; print_typ2 g; Printf.printf " -> "; print_typ2 d; Printf.printf ")"

let rec print_expression2 = function
  | Var x -> Printf.printf "%s" x
  | Const n -> Printf.printf "%d" n
  | Op op -> Printf.printf "%s" op
  | Fun (x, e) -> Printf.printf "fun %s -> " x; print_expression2 e
  | App (e1, e2) ->
    Printf.printf "("; print_expression2 e1; Printf.printf " "; print_expression2 e2; Printf.printf ")"
  | Couple (e1, e2) ->
    Printf.printf "("; print_expression2 e1; Printf.printf ", "; print_expression2 e2; Printf.printf ")"
  | Let (x, e1, e2) ->
    Printf.printf "let %s = " x;
    print_expression2 e1;
    Printf.printf " in ";
    print_expression2 e2

let cpt = ref 0 (* compteur de variables de type *)

let reset_cpt () = cpt := 0

let nouv_var () =
  let n = !cpt in
  incr cpt;
  n

let rec subst_var v t = function
  | Int -> Int
  | Tvar n when n = v -> t
  | Tvar n -> Tvar n
  | Arrow (g, d) -> Arrow (subst_var v t g, subst_var v t d)
  | Product (g, d) -> Product (subst_var v t g, subst_var v t d)

(* Question 9 *)

let rec appliquer s = function
  | Int -> Int
  | Tvar n ->
    begin
      match trouver n s with
      | None -> Tvar n
      | Some t -> appliquer s t
    end
  | Arrow (g, d) -> Arrow (appliquer s g, appliquer s d)
  | Product (g, d) -> Product (appliquer s g, appliquer s d)

(* Question 10 *)

let rec occ v = function (* occ v t teste si v apparaît dans t *)
  | Int -> false
  | Tvar n -> n = v
  | Arrow (g, d) | Product (g, d) -> occ v g || occ v d

let etendre s v t = (* ajoute v -> t à s en propageant le remplacement *)
  let t = appliquer s t in
  inserer v t (map_dict (subst_var v t) s)

let rec unification s t1 t2 =
  let t1 = appliquer s t1 in
  let t2 = appliquer s t2 in
  if t1 = t2 then s
  else
    match (t1, t2) with
    | Arrow (g1, d1), Arrow (g2, d2) ->
      let s = unification s g1 g2 in
      unification s d1 d2
    | Product (g1, d1), Product (g2, d2) ->
      let s = unification s g1 g2 in
      unification s d1 d2
    | Tvar v, t | t, Tvar v ->
      if occ v t then failwith "types non unifiables"
      else etendre s v t
    | _ -> failwith "types non unifiables"

(* Question 11 *)

let w_mono e =
  let rec infer env s = function
    | Var x -> (s, appliquer s (chercher x env))
    | Const _ -> (s, Int)
    | Op _ -> (s, Arrow (Product (Int, Int), Int))
    | Fun (x, e) ->
      let v = Tvar (nouv_var ()) in
      let s, t = infer (inserer x v env) s e in
      (s, Arrow (appliquer s v, t))
    | App (e1, e2) ->
      let s, t1 = infer env s e1 in
      let s, t2 = infer env s e2 in
      let res = Tvar (nouv_var ()) in
      let s = unification s t1 (Arrow (t2, res)) in
      (s, appliquer s res)
    | Couple (e1, e2) ->
      let s, t1 = infer env s e1 in
      let s, t2 = infer env s e2 in
      (s, Product (appliquer s t1, appliquer s t2))
    | Let _ -> failwith "les expressions Let ne sont pas traitées dans cette version"
  in
  reset_cpt ();
  let _, t = infer (creer_dictionnaire ()) (creer_dictionnaire ()) e in
  t

(* Question 13 : inférence avec polymorphisme *)

type schema = Schema of int list * typ2

let ajout x l = if List.mem x l then l else x :: l

let union l1 l2 = List.fold_left (fun acc x -> ajout x acc) l2 l1

let diff l1 l2 = List.filter (fun x -> not (List.mem x l2)) l1

let rec fv_typ = function (* fv_typ t renvoie les variables libres de t *)
  | Int -> []
  | Tvar n -> [n]
  | Arrow (g, d) | Product (g, d) -> union (fv_typ g) (fv_typ d)

let fv_schema (Schema (vs, t)) = diff (fv_typ t) vs

let fv_env env = fold_dict (fun acc _ sc -> union acc (fv_schema sc)) env []

let rec appliquer_sauf liees s = function (* applique s en ignorant les variables de liees *)
  | Int -> Int
  | Tvar n when List.mem n liees -> Tvar n
  | Tvar n ->
    begin
      match trouver n s with
      | None -> Tvar n
      | Some t -> appliquer_sauf liees s t
    end
  | Arrow (g, d) -> Arrow (appliquer_sauf liees s g, appliquer_sauf liees s d)
  | Product (g, d) -> Product (appliquer_sauf liees s g, appliquer_sauf liees s d)

let appliquer_schema s (Schema (vs, t)) = Schema (vs, appliquer_sauf vs s t)

let appliquer_env s env = map_dict (appliquer_schema s) env

let generaliser env t = Schema (diff (fv_typ t) (fv_env env), t)

let instancier (Schema (vs, t)) =
  let s =
    List.fold_left
      (fun acc v -> inserer v (Tvar (nouv_var ())) acc)
      (creer_dictionnaire ()) vs
  in
  appliquer s t

let w e =
  let rec infer env s = function
    | Var x -> (s, instancier (appliquer_schema s (chercher x env)))
    | Const _ -> (s, Int)
    | Op _ -> (s, Arrow (Product (Int, Int), Int))
    | Fun (x, e) ->
      let v = Tvar (nouv_var ()) in
      let s, t = infer (inserer x (Schema ([], v)) env) s e in
      (s, Arrow (appliquer s v, t))
    | App (e1, e2) ->
      let s, t1 = infer env s e1 in
      let env = appliquer_env s env in
      let s, t2 = infer env s e2 in
      let res = Tvar (nouv_var ()) in
      let s = unification s t1 (Arrow (t2, res)) in
      (s, appliquer s res)
    | Couple (e1, e2) ->
      let s, t1 = infer env s e1 in
      let env = appliquer_env s env in
      let s, t2 = infer env s e2 in
      (s, Product (appliquer s t1, appliquer s t2))
    | Let (x, e1, e2) ->
      let s, t1 = infer env s e1 in
      let env = appliquer_env s env in
      let sc = generaliser env (appliquer s t1) in
      infer (inserer x sc env) s e2
  in
  reset_cpt ();
  let _, t = infer (creer_dictionnaire ()) (creer_dictionnaire ()) e in
  t

module Tests = struct
  let echec f =
    try
      ignore (f ());
      false
    with Failure _ -> true

  (* Normalise les numéros de variables de type pour comparer deux types à renommage près. *)
  let normaliser t =
    let tbl = Hashtbl.create 8 in
    let nxt = ref 0 in
    let rec aux = function
      | Int -> Int
      | Tvar v ->
        let n =
          match Hashtbl.find_opt tbl v with
          | Some n -> n
          | None ->
            let n = !nxt in
            incr nxt;
            Hashtbl.add tbl v n;
            n
        in
        Tvar n
      | Arrow (g, d) ->
        let g = aux g in
        let d = aux d in
        Arrow (g, d)
      | Product (g, d) ->
        let g = aux g in
        let d = aux d in
        Product (g, d)
    in
    aux t

  let exec () =
    (* Dictionnaire *)
    let d0 = creer_dictionnaire () in
    let d1 = inserer "b" 2 (inserer "a" 1 d0) in
    let d2 = inserer "a" 10 d1 in
    assert (trouver "a" d0 = None);
    assert (trouver "a" d1 = Some 1);
    assert (trouver "b" d1 = Some 2);
    assert (trouver "a" d2 = Some 10);

    (* Typage annoté *)
    let e1 : expression1 =
      Let
        ( "f",
          Fun ("x", Int, App (Op "+", Couple (Var "x", Const 1))),
          App (Var "f", Const 2) )
    in
    assert (typ_expr e1 = (Int : typ1));
    let e2 : expression1 =
      Fun
        ( "f",
          Arrow (Int, Int),
          Fun
            ( "g",
              Arrow (Int, Int),
              Fun ("x", Int, App (Var "f", App (Var "g", Var "x"))) ) )
    in
    assert (typ_expr e2 = (Arrow (Arrow (Int, Int), Arrow (Arrow (Int, Int), Arrow (Int, Int))) : typ1));
    assert (echec (fun () -> typ_expr (Fun ("x", Int, App (Var "x", Var "x")) : expression1)));
    let e4 : expression1 =
      App
        ( Fun ("x", Int, Var "x"),
          App
            ( Fun ("x", Product (Int, Int), App (Op "+", Var "x")),
              Couple (Const 1, Const 2) ) )
    in
    assert (typ_expr e4 = (Int : typ1));

    (* Unification *)
    let s1 = unification (creer_dictionnaire ()) (Arrow (Tvar 0, Int)) (Arrow (Tvar 1, Tvar 2)) in
    assert (normaliser (appliquer s1 (Arrow (Tvar 0, Int))) = Arrow (Tvar 0, Int));
    assert (echec (fun () -> unification (creer_dictionnaire ()) (Arrow (Tvar 0, Int)) (Product (Tvar 1, Tvar 2))));
    let s3 = unification (creer_dictionnaire ()) (Arrow (Product (Tvar 0, Tvar 1), Int)) (Arrow (Product (Int, Int), Tvar 3)) in
    assert (appliquer s3 (Arrow (Product (Tvar 0, Tvar 1), Int)) = Arrow (Product (Int, Int), Int));
    let s4 = unification (creer_dictionnaire ()) (Arrow (Tvar 0, Tvar 0)) (Arrow (Int, Tvar 1)) in
    assert (appliquer s4 (Arrow (Tvar 0, Tvar 0)) = Arrow (Int, Int));
    assert (echec (fun () -> unification (creer_dictionnaire ()) (Arrow (Tvar 0, Tvar 0)) (Arrow (Int, Product (Int, Int)))));
    assert (echec (fun () -> unification (creer_dictionnaire ()) (Tvar 0) (Arrow (Tvar 0, Int))));

    (* W sans polymorphisme *)
    assert (normaliser (w_mono (Fun ("x", App (Var "x", Const 2)))) = Arrow (Arrow (Int, Tvar 0), Tvar 0));
    assert (w_mono (Fun ("x", App (Op "+", Couple (Var "x", Var "x")))) = Arrow (Int, Int));
    let comp = Fun ("f", Fun ("g", Fun ("x", App (Var "f", App (Var "g", Var "x"))))) in
    assert (
      normaliser (w_mono comp)
      = Arrow (Arrow (Tvar 0, Tvar 1), Arrow (Arrow (Tvar 2, Tvar 0), Arrow (Tvar 2, Tvar 1))) );
    assert (echec (fun () -> w_mono (App (Fun ("f", App (Op "+", App (Var "f", Const 1))), Fun ("x", Var "x")))));
    assert (echec (fun () -> w_mono (Fun ("x", Couple (App (Var "x", Const 1), App (Var "x", Couple (Const 1, Const 2)))))));

    (* W avec polymorphisme *)
    let id = Fun ("x", Var "x") in
    assert (w (Let ("f", Fun ("x", App (Op "+", Couple (Var "x", Const 1))), App (Var "f", Const 2))) = Int);
    assert (normaliser (w (Let ("f", id, App (Var "f", Var "f")))) = Arrow (Tvar 0, Tvar 0));
    assert (normaliser (w (Let ("f", id, Couple (App (Var "f", id), App (Var "f", Const 2))))) = Product (Arrow (Tvar 0, Tvar 0), Int));
    assert (normaliser (w (Let ("f", id, Couple (App (Var "f", Const 2), App (Var "f", id))))) = Product (Int, Arrow (Tvar 0, Tvar 0)));
    assert (normaliser (w (Let ("f", id, Couple (App (Var "f", Const 2), App (Var "f", Fun ("x", Const 2)))))) = Product (Int, Arrow (Tvar 0, Int)));
    assert (w (Let ("id", id, Couple (App (Var "id", Const 1), App (Var "id", Couple (Const 1, Const 2))))) = Product (Int, Product (Int, Int)));
    assert (
      normaliser (w (Fun ("f", Fun ("x", Let ("y", App (Var "f", Var "x"), Var "y")))))
      = Arrow (Arrow (Tvar 0, Tvar 1), Arrow (Tvar 0, Tvar 1)) );
    assert (
      echec (fun () ->
          w
            (Fun
               ( "x",
                 Let ("z", Var "x", Couple (App (Var "z", Const 1), App (Var "z", Couple (Const 1, Const 2)))) ))) );
    assert (
      echec (fun () ->
          w
            (Let
               ( "distr_pair",
                 Fun ("f", Couple (App (Var "f", Const 1), App (Var "f", Couple (Const 1, Const 2)))),
                 App (Var "distr_pair", id) ))) );
    print_endline "Tests d'inférence de type : OK"
end

let () = Tests.exec ()
