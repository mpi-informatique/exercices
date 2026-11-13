#mod_use "dnat.ml";;

open Dnat

(* Question 1 *)
let seq gamma phi = {gamma; phi}

(* Question 2 *)
let rec string_of_formule = function
  | Var v -> v
  | Bot -> "F"
  | And (f1, f2) -> "(" ^ string_of_formule f1 ^ " & " ^ string_of_formule f2 ^ ")"
  | Or (f1, f2) -> "(" ^ string_of_formule f1 ^ " | " ^ string_of_formule f2 ^ ")"
  | Implies (f1, f2) -> "(" ^ string_of_formule f1 ^ " -> " ^ string_of_formule f2 ^ ")"
  | Not f -> "(! " ^ string_of_formule f ^ ")"


(* Question 3 *)
let string_of_sequent s =
  let gamma_str = String.concat ", " (List.map string_of_formule s.gamma) in
  gamma_str ^ " |- " ^ string_of_formule s.phi

(* Question 4 *)
let appliquer_regle r s =
  match r, s.phi with
  | Axiom, _ ->
      if List.mem s.phi s.gamma then Some [] else None
  | AndIntro, And (f1, f2) ->
      Some [seq s.gamma f1; seq s.gamma f2]
  | OrIntro1, Or (f1, _) ->
      Some [seq s.gamma f1]
  | OrIntro2, Or (_, f2) ->
      Some [seq s.gamma f2]
  | ImpliesIntro, Implies (f1, f2) ->
      Some [seq (f1 :: s.gamma) f2]
  | NotIntro, Not f ->
      Some [seq (f :: s.gamma) Bot]
  | ImpliesElim f1, _ ->
      Some [seq s.gamma (Implies (f1, s.phi)); seq s.gamma f1]
  | AndElim1 f2, _ ->
      Some [seq s.gamma (And (s.phi, f2))]
  | AndElim2 f1, _ ->
      Some [seq s.gamma (And (f1, s.phi))]
  | NotElim f, Bot ->
      Some [seq s.gamma (Not f); seq s.gamma f]
  | OrElim (f1, f2), _ ->
      (* Pour prouver phi par OrElim, il faut prouver qu'on a f1 \/ f2, puis que f1 implique phi, et f2 implique phi *)
      Some [
        seq s.gamma (Or (f1, f2));
        seq (f1 :: s.gamma) s.phi;
        seq (f2 :: s.gamma) s.phi
      ]
  | _, _ -> None

(* Question 5 *)
let rec sous_formules_f f =
  match f with
  | And (f1, f2) | Or (f1, f2) | Implies (f1, f2) ->
      f :: (sous_formules_f f1 @ sous_formules_f f2)
  | Not f1 -> f :: sous_formules_f f1
  | _ -> [f]

(* Question 6 *)
let sous_formules_gamma gamma = List.map sous_formules_f gamma |> List.concat

(* Question 7 *)
let regles_possibles s =
  let intros = match s.phi with
    | And _ -> [AndIntro]
    | Or _ -> [OrIntro1; OrIntro2]
    | Implies _ -> [ImpliesIntro]
    | Not _ -> [NotIntro]
    | _ -> []
  in
  let eliminations = function
    | And (x, y) ->
        (if x = s.phi then [AndElim1 y] else []) @
        (if y = s.phi then [AndElim2 x] else [])
    | Implies (x, y) when y = s.phi -> [ImpliesElim x]
    | Not x when s.phi = Bot -> [NotElim x]
    | Or (x, y) -> [OrElim (x, y)]
    | _ -> []
  in
  let elims = List.concat (List.map eliminations (sous_formules_gamma s.gamma)) in
  Axiom :: (intros @ elims)

(* Question 8 *)
let rec prouver depth s =
  if depth <= 0 then None
  else
    let rules = regles_possibles s in
    let rec try_rules = function
      | [] -> None
      | r :: rs ->
          match appliquer_regle r s with
          | None -> try_rules rs
          | Some premises ->
              let rec prove_all = function
                | [] -> Some []
                | p :: ps ->
                    match prouver (depth - 1) p with
                    | None -> None
                    | Some tree ->
                        match prove_all ps with
                        | None -> None
                        | Some trees -> Some (tree :: trees)
              in
              match prove_all premises with
              | None -> try_rules rs
              | Some trees -> Some (Noeud (r, s, trees))
    in
    try_rules rules

(* Question 9 *)
let prouver_min max_depth s =
  let rec iter depth =
    if depth > max_depth then None
    else match prouver depth s with
      | Some arbre -> Some arbre
      | None -> iter (depth + 1)
  in iter 1

module Tests = struct
  let a = Var "A"
  let b = Var "B"
  let c = Var "C"

  let verifier_regles () =
    let g = [a] in
    assert (appliquer_regle Axiom (seq g a) = Some []);
    assert (appliquer_regle Axiom (seq g b) = None);
    assert (appliquer_regle AndIntro (seq g (And (a, b))) =
      Some [seq g a; seq g b]);
    assert (appliquer_regle OrIntro1 (seq g (Or (a, b))) = Some [seq g a]);
    assert (appliquer_regle OrIntro2 (seq g (Or (a, b))) = Some [seq g b]);
    assert (appliquer_regle ImpliesIntro (seq g (Implies (a, b))) =
      Some [seq (a :: g) b]);
    assert (appliquer_regle NotIntro (seq g (Not a)) = Some [seq (a :: g) Bot]);
    assert (appliquer_regle (ImpliesElim a) (seq g b) =
      Some [seq g (Implies (a, b)); seq g a]);
    assert (appliquer_regle (AndElim1 b) (seq g a) = Some [seq g (And (a, b))]);
    assert (appliquer_regle (AndElim2 a) (seq g b) = Some [seq g (And (a, b))]);
    assert (appliquer_regle (NotElim a) (seq g Bot) =
      Some [seq g (Not a); seq g a]);
    assert (appliquer_regle (OrElim (a, b)) (seq [] c) =
      Some [seq [] (Or (a, b)); seq [a] c; seq [b] c]);
    List.iter (fun r -> assert (appliquer_regle r (seq [] a) = None))
      [AndIntro; OrIntro1; OrIntro2; ImpliesIntro; NotIntro; NotElim a]

  (* Chaque sous-arbre doit prouver exactement une prémisse de la règle. *)
  let rec verifier_arbre (Noeud (r, s, arbres)) =
    match appliquer_regle r s with
    | None -> assert false
    | Some premisses ->
        let conclusions = List.map (fun (Noeud (_, s, _)) -> s) arbres in
        assert (conclusions = premisses);
        List.iter verifier_arbre arbres

  let rec profondeur (Noeud (_, _, arbres)) =
    1 + List.fold_left (fun h a -> max h (profondeur a)) 0 arbres

  let verifier_preuve texte hauteur =
    let s = parse texte in
    assert (prouver (hauteur - 1) s = None);
    match prouver_min hauteur s with
    | None -> assert false
    | Some (Noeud (_, conclusion, _) as arbre) ->
        assert (conclusion = s);
        assert (profondeur arbre = hauteur);
        verifier_arbre arbre

  let executer () =
    verifier_regles ();
    assert (string_of_formule (And (a, Not b)) = "(A & (! B))");
    assert (string_of_sequent (seq [a; Implies (a, b)] b) = "A, (A -> B) |- B");
    assert (sous_formules_f (And (a, Or (b, c))) =
      [And (a, Or (b, c)); a; Or (b, c); b; c]);
    assert (sous_formules_gamma [] = []);
    assert (regles_possibles (parse "(A & B) |- A") = [Axiom; AndElim1 b]);
    assert (regles_possibles (parse "(A & A) |- A") =
      [Axiom; AndElim1 a; AndElim2 a]);
    assert (prouver 0 (seq [a] a) = None);
    assert (prouver_min 0 (seq [a] a) = None);
    assert (prouver_min (-1) (seq [a] a) = None);
    assert (prouver_min 2 (parse "A |- B") = None);
    assert (prouver_min 2 (parse "F |- A") = None);
    List.iter (fun (texte, hauteur) -> verifier_preuve texte hauteur) [
      "A |- A", 1;
      "|- A -> A", 2;
      "(A & B) |- A", 2;
      "|- (A & B) -> (B & A)", 4;
      "|- A -> (B -> A)", 3;
      "|- ((A -> B) & A) -> B", 4;
      "|- (A & !A) -> F", 4;
      "|- (A & (B | C)) -> ((A & B) | (A & C))", 6;
    ];
    print_endline "Tests du prouveur : OK"
end

let () = Tests.executer ()
