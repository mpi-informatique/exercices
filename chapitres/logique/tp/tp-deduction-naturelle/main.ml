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

(* Tests à lancer une fois les fonctions complétées. *)
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
