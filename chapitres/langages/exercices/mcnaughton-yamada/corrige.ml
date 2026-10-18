type 'a regexp =
  | Vide | Epsilon | L of 'a
  | Union of 'a regexp * 'a regexp
  | Concat of 'a regexp * 'a regexp
  | Etoile of 'a regexp

type 'a automate = {
  n : int;
  finaux : int list;
  transitions : (int * 'a * int) list;
}

let to_regexp a =
  let n = a.n in
  let l = Array.make_matrix n n Vide in
  (* initialisation *)
  for i = 0 to n - 1 do l.(i).(i) <- Epsilon done;
  List.iter (fun (i, c, j) -> l.(i).(j) <- Union (l.(i).(j), L c)) a.transitions;
  for k = 0 to n - 1 do (* récurrence Q2 *)
    let ligne = Array.copy l.(k) in
    let colonne = Array.init n (fun i -> l.(i).(k)) in
    let boucle = Etoile l.(k).(k) in
    for i = 0 to n - 1 do
      for j = 0 to n - 1 do
        l.(i).(j) <- Union (l.(i).(j), Concat (colonne.(i), Concat (boucle, ligne.(j))))
      done
    done
  done;
  let e = ref Vide in
  List.iter (fun f -> e := Union (!e, l.(0).(f))) a.finaux;
  !e

let accepte_regexp e mot =
  let rec positions e i =
    match e with
    | Vide -> []
    | Epsilon -> [i]
    | L c -> if i < String.length mot && mot.[i] = c then [i + 1] else []
    | Union (e, f) -> List.sort_uniq compare (positions e i @ positions f i)
    | Concat (e, f) -> List.sort_uniq compare (List.concat_map (positions f) (positions e i))
    | Etoile e ->
        let rec boucle vus = function
          | [] -> vus
          | j :: reste ->
              let nouveaux = List.filter (fun k -> not (List.mem k vus)) (positions e j) in
              boucle (nouveaux @ vus) (nouveaux @ reste)
        in
        boucle [i] [i]
  in
  List.mem (String.length mot) (positions e 0)

let accepte_automate a mot =
  let rec parcours i p =
    if p = String.length mot then List.mem i a.finaux
    else match List.find_opt (fun (j, c, _) -> j = i && c = mot.[p]) a.transitions with
    | None -> false
    | Some (_, _, j) -> parcours j (p + 1)
  in
  parcours 0 0

let rec mots n =
  if n = 0 then [""]
  else "" :: List.concat_map (fun w -> ["a" ^ w; "b" ^ w]) (mots (n - 1))

let exemples = [
  { n = 1; finaux = []; transitions = [] };
  { n = 1; finaux = [0]; transitions = [] };
  { n = 1; finaux = [0]; transitions = [0, 'a', 0] };
  { n = 1; finaux = [0]; transitions = [0, 'a', 0; 0, 'b', 0] };
  { n = 2; finaux = [1]; transitions = [0, 'a', 1] };
  { n = 2; finaux = [1]; transitions = [0, 'a', 1; 0, 'b', 1] };
  { n = 2; finaux = [0]; transitions = [0, 'a', 1; 1, 'a', 0] };
  { n = 3; finaux = [2]; transitions = [0, 'a', 1; 1, 'b', 2; 2, 'a', 1] };
  { n = 3; finaux = [0; 2]; transitions = [0, 'a', 2; 2, 'b', 1; 1, 'a', 0] };
  { n = 3; finaux = [1]; transitions = [0, 'a', 0; 0, 'b', 1; 1, 'b', 1; 2, 'a', 2] };
]

let () =
  List.iteri (fun i a ->
    let e = to_regexp a in
    List.iter (fun mot ->
      if accepte_regexp e mot <> accepte_automate a mot then
        failwith (Printf.sprintf "Automate %d, mot %S" i mot)
    ) (mots 4)
  ) exemples;
  let (_ : int regexp) = to_regexp { n = 1; finaux = [0]; transitions = [0, 42, 0] } in
  print_endline "10 automates : équivalence vérifiée sur tous les mots de taille au plus 4 ; polymorphisme vérifié."
