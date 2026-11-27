(* Question 2 : dictionnaire persistant *)

type ('a, 'b) dict =
  | Empty
  | Node of ('a, 'b) dict * 'a * 'b * ('a, 'b) dict

let creer_dictionnaire () = Empty

let rec trouver cle = function
  | Empty -> None
  | Node (gauche, cle_noeud, valeur, droite) ->
    if cle = cle_noeud then Some valeur
    else if cle < cle_noeud then trouver cle gauche
    else trouver cle droite

let rec inserer cle valeur = function
  | Empty -> Node (Empty, cle, valeur, Empty)
  | Node (gauche, cle_noeud, valeur_noeud, droite) ->
    if cle = cle_noeud then Node (gauche, cle, valeur, droite)
    else if cle < cle_noeud then
      Node (inserer cle valeur gauche, cle_noeud, valeur_noeud, droite)
    else
      Node (gauche, cle_noeud, valeur_noeud, inserer cle valeur droite)

let rec map_dict f = function
  | Empty -> Empty
  | Node (gauche, cle, valeur, droite) ->
    Node (map_dict f gauche, cle, f valeur, map_dict f droite)

let rec fold_dict f dictionnaire accumulateur =
  match dictionnaire with
  | Empty -> accumulateur
  | Node (gauche, cle, valeur, droite) ->
    let accumulateur = fold_dict f gauche accumulateur in
    let accumulateur = f accumulateur cle valeur in
    fold_dict f droite accumulateur

let valeur_associee nom dictionnaire =
  match trouver nom dictionnaire with
  | Some valeur -> valeur
  | None -> failwith ("identifiant inconnu : " ^ nom)

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
  | Int -> print_string "int"
  | Product (g, d) -> print_string "("; print_typ1 g; print_string " * "; print_typ1 d; print_string ")"
  | Arrow (g, d) -> print_string "("; print_typ1 g; print_string " -> "; print_typ1 d; print_string ")"

let rec print_expression1 = function
  | Var nom -> print_string nom
  | Const n -> print_int n
  | Op op -> print_string op
  | Fun (nom, typ, corps) ->
    Printf.printf "fun %s : " nom;
    print_typ1 typ;
    print_string " -> ";
    print_expression1 corps
  | App (f, arg) ->
    print_string "("; print_expression1 f; print_string " "; print_expression1 arg; print_string ")"
  | Couple (g, d) ->
    print_string "("; print_expression1 g; print_string ", "; print_expression1 d; print_string ")"
  | Let (nom, valeur, corps) ->
    Printf.printf "let %s = " nom;
    print_expression1 valeur;
    print_string " in ";
    print_expression1 corps

(* Question 6 *)

let typ_expr expression =
  let rec aux env = function
    | Var nom -> valeur_associee nom env
    | Const _ -> Int
    | Op _ -> Arrow (Product (Int, Int), Int)
    | Fun (nom, typ_arg, corps) ->
      let env = inserer nom typ_arg env in
      Arrow (typ_arg, aux env corps)
    | App (fonction, argument) ->
      let typ_fonction = aux env fonction in
      let typ_argument = aux env argument in
      begin
        match typ_fonction with
        | Arrow (attendu, resultat) when attendu = typ_argument -> resultat
        | Arrow _ -> failwith "argument de type incorrect"
        | _ -> failwith "application d'une expression non fonctionnelle"
      end
    | Couple (gauche, droite) -> Product (aux env gauche, aux env droite)
    | Let (nom, valeur, corps) ->
      let typ_valeur = aux env valeur in
      aux (inserer nom typ_valeur env) corps
  in
  aux (creer_dictionnaire ()) expression

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
  | Int -> print_string "int"
  | Tvar n -> print_int n
  | Product (g, d) -> print_string "("; print_typ2 g; print_string " * "; print_typ2 d; print_string ")"
  | Arrow (g, d) -> print_string "("; print_typ2 g; print_string " -> "; print_typ2 d; print_string ")"

let rec print_expression2 = function
  | Var nom -> print_string nom
  | Const n -> print_int n
  | Op op -> print_string op
  | Fun (nom, corps) -> Printf.printf "fun %s -> " nom; print_expression2 corps
  | App (f, arg) ->
    print_string "("; print_expression2 f; print_string " "; print_expression2 arg; print_string ")"
  | Couple (g, d) ->
    print_string "("; print_expression2 g; print_string ", "; print_expression2 d; print_string ")"
  | Let (nom, valeur, corps) ->
    Printf.printf "let %s = " nom;
    print_expression2 valeur;
    print_string " in ";
    print_expression2 corps

let compteur_types = ref 0

let reset_compteur_types () = compteur_types := 0

let nouvelle_variable_type () =
  let resultat = !compteur_types in
  incr compteur_types;
  resultat

let rec remplacer_variable variable remplacement = function
  | Int -> Int
  | Tvar numero when numero = variable -> remplacement
  | Tvar numero -> Tvar numero
  | Arrow (g, d) ->
    Arrow (remplacer_variable variable remplacement g, remplacer_variable variable remplacement d)
  | Product (g, d) ->
    Product (remplacer_variable variable remplacement g, remplacer_variable variable remplacement d)

(* Question 9 *)

let rec appliquer substitution = function
  | Int -> Int
  | Tvar numero ->
    begin
      match trouver numero substitution with
      | None -> Tvar numero
      | Some typ -> appliquer substitution typ
    end
  | Arrow (gauche, droite) -> Arrow (appliquer substitution gauche, appliquer substitution droite)
  | Product (gauche, droite) -> Product (appliquer substitution gauche, appliquer substitution droite)

(* Question 10 *)

let rec variable_libre_dans variable = function
  | Int -> false
  | Tvar numero -> numero = variable
  | Arrow (gauche, droite) | Product (gauche, droite) ->
    variable_libre_dans variable gauche || variable_libre_dans variable droite

let ajouter_substitution substitution variable typ =
  let typ = appliquer substitution typ in
  let substitution = map_dict (remplacer_variable variable typ) substitution in
  inserer variable typ substitution

let rec unification substitution typ_gauche typ_droite =
  let typ_gauche = appliquer substitution typ_gauche in
  let typ_droite = appliquer substitution typ_droite in
  if typ_gauche = typ_droite then substitution
  else
    match (typ_gauche, typ_droite) with
    | Arrow (g1, d1), Arrow (g2, d2) ->
      let substitution = unification substitution g1 g2 in
      unification substitution d1 d2
    | Product (g1, d1), Product (g2, d2) ->
      let substitution = unification substitution g1 g2 in
      unification substitution d1 d2
    | Tvar variable, typ | typ, Tvar variable ->
      if variable_libre_dans variable typ then failwith "types non unifiables"
      else ajouter_substitution substitution variable typ
    | _ -> failwith "types non unifiables"

(* Question 11 *)

let w_sans_polymorphisme expression =
  let rec inferer env substitution = function
    | Var nom -> (substitution, appliquer substitution (valeur_associee nom env))
    | Const _ -> (substitution, Int)
    | Op _ -> (substitution, Arrow (Product (Int, Int), Int))
    | Fun (nom, corps) ->
      let variable = Tvar (nouvelle_variable_type ()) in
      let env = inserer nom variable env in
      let substitution, typ_corps = inferer env substitution corps in
      (substitution, Arrow (appliquer substitution variable, typ_corps))
    | App (fonction, argument) ->
      let substitution, typ_fonction = inferer env substitution fonction in
      let substitution, typ_argument = inferer env substitution argument in
      let resultat = Tvar (nouvelle_variable_type ()) in
      let substitution = unification substitution typ_fonction (Arrow (typ_argument, resultat)) in
      (substitution, appliquer substitution resultat)
    | Couple (gauche, droite) ->
      let substitution, typ_gauche = inferer env substitution gauche in
      let substitution, typ_droite = inferer env substitution droite in
      (substitution, Product (appliquer substitution typ_gauche, appliquer substitution typ_droite))
    | Let _ -> failwith "les expressions Let ne sont pas traitées dans cette version"
  in
  reset_compteur_types ();
  let _, typ = inferer (creer_dictionnaire ()) (creer_dictionnaire ()) expression in
  typ

(* Question 13 : inférence avec polymorphisme *)

type schema = Schema of int list * typ2

let ajouter_unique element liste =
  if List.mem element liste then liste else element :: liste

let union liste1 liste2 =
  List.fold_left (fun acc element -> ajouter_unique element acc) liste2 liste1

let difference liste1 liste2 =
  List.filter (fun element -> not (List.mem element liste2)) liste1

let rec variables_libres_type = function
  | Int -> []
  | Tvar numero -> [numero]
  | Arrow (gauche, droite) | Product (gauche, droite) ->
    union (variables_libres_type gauche) (variables_libres_type droite)

let variables_libres_schema (Schema (variables_quantifiees, typ)) =
  difference (variables_libres_type typ) variables_quantifiees

let variables_libres_env env =
  fold_dict
    (fun acc _ schema -> union acc (variables_libres_schema schema))
    env []

let rec appliquer_bloquees bloquees substitution = function
  | Int -> Int
  | Tvar numero when List.mem numero bloquees -> Tvar numero
  | Tvar numero ->
    begin
      match trouver numero substitution with
      | None -> Tvar numero
      | Some typ -> appliquer_bloquees bloquees substitution typ
    end
  | Arrow (g, d) ->
    Arrow (appliquer_bloquees bloquees substitution g, appliquer_bloquees bloquees substitution d)
  | Product (g, d) ->
    Product (appliquer_bloquees bloquees substitution g, appliquer_bloquees bloquees substitution d)

let appliquer_schema substitution (Schema (variables_quantifiees, typ)) =
  Schema (variables_quantifiees, appliquer_bloquees variables_quantifiees substitution typ)

let appliquer_env substitution env = map_dict (appliquer_schema substitution) env

let generaliser env typ =
  let variables = difference (variables_libres_type typ) (variables_libres_env env) in
  Schema (variables, typ)

let instancier (Schema (variables, typ)) =
  let substitution =
    List.fold_left
      (fun acc variable -> inserer variable (Tvar (nouvelle_variable_type ())) acc)
      (creer_dictionnaire ()) variables
  in
  appliquer substitution typ

let w expression =
  let rec inferer env substitution = function
    | Var nom ->
      let schema = valeur_associee nom env in
      (substitution, instancier (appliquer_schema substitution schema))
    | Const _ -> (substitution, Int)
    | Op _ -> (substitution, Arrow (Product (Int, Int), Int))
    | Fun (nom, corps) ->
      let variable = Tvar (nouvelle_variable_type ()) in
      let env = inserer nom (Schema ([], variable)) env in
      let substitution, typ_corps = inferer env substitution corps in
      (substitution, Arrow (appliquer substitution variable, typ_corps))
    | App (fonction, argument) ->
      let substitution, typ_fonction = inferer env substitution fonction in
      let env = appliquer_env substitution env in
      let substitution, typ_argument = inferer env substitution argument in
      let resultat = Tvar (nouvelle_variable_type ()) in
      let substitution = unification substitution typ_fonction (Arrow (typ_argument, resultat)) in
      (substitution, appliquer substitution resultat)
    | Couple (gauche, droite) ->
      let substitution, typ_gauche = inferer env substitution gauche in
      let env = appliquer_env substitution env in
      let substitution, typ_droite = inferer env substitution droite in
      (substitution, Product (appliquer substitution typ_gauche, appliquer substitution typ_droite))
    | Let (nom, valeur, corps) ->
      let substitution, typ_valeur = inferer env substitution valeur in
      let env = appliquer_env substitution env in
      let schema = generaliser env (appliquer substitution typ_valeur) in
      inferer (inserer nom schema env) substitution corps
  in
  reset_compteur_types ();
  let _, typ = inferer (creer_dictionnaire ()) (creer_dictionnaire ()) expression in
  typ

module Tests = struct
  let echec f =
    try
      ignore (f ());
      false
    with Failure _ -> true

  (* Normalise les numéros de variables de type pour comparer deux types à renommage près. *)
  let normaliser typ =
    let table = Hashtbl.create 8 in
    let prochain = ref 0 in
    let rec aux = function
      | Int -> Int
      | Tvar v ->
        let n =
          match Hashtbl.find_opt table v with
          | Some n -> n
          | None ->
            let n = !prochain in
            incr prochain;
            Hashtbl.add table v n;
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
    aux typ

  let executer () =
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
    assert (normaliser (w_sans_polymorphisme (Fun ("x", App (Var "x", Const 2)))) = Arrow (Arrow (Int, Tvar 0), Tvar 0));
    assert (w_sans_polymorphisme (Fun ("x", App (Op "+", Couple (Var "x", Var "x")))) = Arrow (Int, Int));
    let comp = Fun ("f", Fun ("g", Fun ("x", App (Var "f", App (Var "g", Var "x"))))) in
    assert (
      normaliser (w_sans_polymorphisme comp)
      = Arrow (Arrow (Tvar 0, Tvar 1), Arrow (Arrow (Tvar 2, Tvar 0), Arrow (Tvar 2, Tvar 1))) );
    assert (echec (fun () -> w_sans_polymorphisme (App (Fun ("f", App (Op "+", App (Var "f", Const 1))), Fun ("x", Var "x")))));
    assert (echec (fun () -> w_sans_polymorphisme (Fun ("x", Couple (App (Var "x", Const 1), App (Var "x", Couple (Const 1, Const 2)))))));

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

let () = Tests.executer ()
