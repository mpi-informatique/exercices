type adc = {
  initial : int;
  finaux : int list;
  delta : int array array;
}

let nb_etats a = Array.length a.delta

let nb_lettres a = Array.length a.delta.(0)

let delta_etoile a q mot =
  List.fold_left (fun etat lettre -> a.delta.(etat).(lettre)) q mot

let accepte a mot =
  List.mem (delta_etoile a a.initial mot) a.finaux

(* Les colonnes correspondent aux lettres a = 0 et b = 1. *)
let exemple = {
  initial = 0;
  finaux = [5];
  delta = [|
    [|1; 2|];
    [|3; 4|];
    [|4; 5|];
    [|4; 5|];
    [|5; 4|];
    [|5; 5|];
  |];
}

let classes_initiales a =
  let est_final = Array.make (nb_etats a) false in
  List.iter (fun q -> est_final.(q) <- true) a.finaux;
  Array.init (nb_etats a) (fun q ->
    if est_final.(q) = est_final.(0) then 0 else 1)

let signature a classes q =
  classes.(q)
  :: Array.to_list
       (Array.map (fun destination -> classes.(destination)) a.delta.(q))

let raffine a classes =
  let numeros = Hashtbl.create (nb_etats a) in
  let prochaine_classe = ref 0 in
  Array.init (nb_etats a) (fun q ->
    let s = signature a classes q in
    match Hashtbl.find_opt numeros s with
    | Some classe -> classe
    | None ->
        let classe = !prochaine_classe in
        Hashtbl.add numeros s classe;
        incr prochaine_classe;
        classe)

let classes_equivalence a =
  let rec jusquau_point_fixe classes =
    let nouvelles_classes = raffine a classes in
    if nouvelles_classes = classes then classes
    else jusquau_point_fixe nouvelles_classes
  in
  jusquau_point_fixe (classes_initiales a)

let quotient a classes =
  let nombre_classes = 1 + Array.fold_left max (-1) classes in
  let representants = Array.make nombre_classes (-1) in
  Array.iteri (fun q classe -> representants.(classe) <- q) classes;
  let delta =
    Array.init nombre_classes (fun classe ->
      let q = representants.(classe) in
      Array.map (fun destination -> classes.(destination)) a.delta.(q))
  in
  {
    initial = classes.(a.initial);
    finaux = List.sort_uniq Int.compare (List.map (fun q -> classes.(q)) a.finaux);
    delta;
  }

let rec mots_de_taille alphabet n =
  if n = 0 then [[]]
  else
    List.concat_map
      (fun mot -> List.init alphabet (fun lettre -> lettre :: mot))
      (mots_de_taille alphabet (n - 1))

let mots_jusqua alphabet n =
  List.concat_map (mots_de_taille alphabet) (List.init (n + 1) Fun.id)

let equivalent_jusqua a b n =
  List.for_all
    (fun mot -> accepte a mot = accepte b mot)
    (mots_jusqua (nb_lettres a) n)

let minimiser a =
  quotient a (classes_equivalence a)

module Tests = struct
  let executer () =
    List.iteri (fun q mot -> assert (delta_etoile exemple 0 mot = q))
      [ []; [0]; [1]; [0; 0]; [0; 1]; [1; 1] ];
    assert (not (List.mem (delta_etoile exemple 0 [0; 1]) exemple.finaux));
    assert (List.mem (delta_etoile exemple 1 [0; 1]) exemple.finaux);
    let p0 = classes_initiales exemple in
    assert (p0 = [|0; 0; 0; 0; 0; 1|]);
    assert (signature exemple p0 0 = [0; 0; 0]);
    assert (signature exemple p0 2 = [0; 0; 1]);
    let p1 = raffine exemple p0 in
    assert (p1 = [|0; 0; 1; 1; 2; 3|]);
    assert (raffine exemple p1 = [|0; 1; 2; 2; 3; 4|]);
    assert (classes_equivalence exemple = [|0; 1; 2; 2; 3; 4|]);
    let minimal = minimiser exemple in
    assert (nb_etats minimal = 5);
    assert (minimal.initial = 0);
    assert (minimal.finaux = [4]);
    assert (minimal.delta = [|[|1; 2|]; [|2; 3|]; [|3; 4|]; [|4; 3|]; [|4; 4|]|]);
    assert (equivalent_jusqua exemple minimal 12);
    (* L'état initial n'est pas nécessairement celui de numéro 0. *)
    let deux_etats = {initial = 1; finaux = [1]; delta = [|[|1|]; [|0|]|]} in
    assert (classes_initiales deux_etats = [|0; 1|]);
    let minimal = minimiser deux_etats in
    assert (minimal.initial = 1);
    assert (nb_etats minimal = 2);
    assert (equivalent_jusqua deux_etats minimal 6);
    List.iter (fun finaux ->
      let a = {deux_etats with finaux} in
      assert (classes_initiales a = [|0; 0|]);
      let minimal = minimiser a in
      assert (nb_etats minimal = 1);
      assert (equivalent_jusqua a minimal 6)) [ []; [0; 1] ]
end

let () = Tests.executer ()
