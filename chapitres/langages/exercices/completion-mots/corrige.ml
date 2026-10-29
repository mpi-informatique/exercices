type trie = Noeud of bool * (char * trie) list

let rec fils a branches =
  match branches with
  | [] -> None
  | (b, t) :: suite -> if a = b then Some t else fils a suite

let rec sous_trie u t =
  match u, t with
  | [], _ -> Some t
  | a :: suite, Noeud (_, branches) ->
    match fils a branches with
    | None -> None
    | Some enfant -> sous_trie suite enfant

type adc = {
  initial : int;
  delta : int array array;
  final : bool array
}

let distances a =
  let n = Array.length a.delta in
  let sigma = Array.length a.delta.(0) in
  let pred = Array.make n [] in
  for p = 0 to n - 1 do
    for c = 0 to sigma - 1 do
      let q = a.delta.(p).(c) in
      pred.(q) <- p :: pred.(q)
    done
  done;
  let d = Array.make n (-1) in
  let file = Array.make n 0 in
  let debut = ref 0 in
  let fin = ref 0 in
  for q = 0 to n - 1 do
    if a.final.(q) then begin
      d.(q) <- 0;
      file.(!fin) <- q;
      fin := !fin + 1
    end
  done;
  while !debut < !fin do
    let q = file.(!debut) in
    debut := !debut + 1;
    let rec visiter = function
      | [] -> ()
      | p :: suite ->
        if d.(p) = -1 then begin
          d.(p) <- d.(q) + 1;
          file.(!fin) <- p;
          fin := !fin + 1
        end;
        visiter suite
    in
    visiter pred.(q)
  done;
  d

let completer_adc a d u =
  let rec lire q = function
    | [] -> q
    | c :: suite -> lire a.delta.(q).(c) suite
  in
  let rec construire q =
    if d.(q) = 0 then []
    else begin
      let c = ref 0 in
      while d.(a.delta.(q).(!c)) <> d.(q) - 1 do
        c := !c + 1
      done;
      !c :: construire a.delta.(q).(!c)
    end
  in
  let q = lire a.initial u in
  if d.(q) = -1 then None else Some (construire q)

let completer_dyck u =
  let rec lire pile = function
    | [] -> Some pile
    | '(' :: suite -> lire (')' :: pile) suite
    | '[' :: suite -> lire (']' :: pile) suite
    | ')' :: suite ->
      (match pile with
       | ')' :: reste -> lire reste suite
       | _ -> None)
    | ']' :: suite ->
      (match pile with
       | ']' :: reste -> lire reste suite
       | _ -> None)
    | _ -> None
  in
  lire [] u

type regle = Vide | Lettre of char | Unite of int | Produit of int * int
type grammaire = regle list array

let minimum x y =
  match x, y with
  | None, z -> z
  | z, None -> z
  | Some a, Some b -> Some (if a < b then a else b)

let somme x y =
  match x, y with
  | Some a, Some b -> Some (a + b)
  | _ -> None

let cout d = function
  | Vide -> Some 0
  | Lettre _ -> Some 1
  | Unite y -> d.(y)
  | Produit (y, z) -> somme d.(y) d.(z)

let longueurs (g : grammaire) =
  let m = Array.length g in
  let d = ref (Array.make m None) in
  for h = 1 to m do
    let suivant = Array.copy !d in
    for x = 0 to m - 1 do
      let rec examiner = function
        | [] -> ()
        | r :: suite ->
          suivant.(x) <- minimum suivant.(x) (cout !d r);
          examiner suite
      in
      examiner g.(x)
    done;
    d := suivant
  done;
  !d

module Tests = struct
  let chars s = List.init (String.length s) (String.get s)

  let rec mots alphabet n =
    if n = 0 then [[]]
    else
      let courts = mots alphabet (n - 1) in
      [] :: List.concat_map (fun a -> List.map (fun w -> a :: w) courts) alphabet

  (* Construction mathématique des questions 15 et 16, pour la vérifier
     sur une grammaire dont les complétions se calculent indépendamment. *)
  let quotient g axiome u =
    let prefixe = Array.of_list u in
    let n = Array.length prefixe in
    let k = n + 2 in
    let m = Array.length g in
    let id p x q = (p * m + x) * k + q in
    let h = Array.make (m * k * k) [] in
    let ajouter p x q r =
      let i = id p x q in
      h.(i) <- r :: h.(i)
    in
    let delta p a =
      if p = n || p = n + 1 then p
      else if a = prefixe.(p) then p + 1 else n + 1
    in
    Array.iteri (fun x regles -> List.iter (function
      | Vide -> for p = 0 to k - 1 do ajouter p x p Vide done
      | Lettre a ->
        for p = 0 to k - 1 do
          ajouter p x (delta p a) (if p < n then Vide else Lettre a)
        done
      | Unite y ->
        for p = 0 to k - 1 do
          for q = 0 to k - 1 do ajouter p x q (Unite (id p y q)) done
        done
      | Produit (y, z) ->
        for p = 0 to k - 1 do
          for q = 0 to k - 1 do
            for r = 0 to k - 1 do
              ajouter p x q (Produit (id p y r, id r z q))
            done
          done
        done) regles) g;
    h, id 0 axiome n

  let lancer () =
    let feuille = Noeud (true, []) in
    let t = Noeud (false, ['a', Noeud (false, ['b', feuille]); 'c', Noeud (false, ['b', feuille])]) in
    assert (sous_trie [] t = Some t);
    assert (sous_trie ['a'] t = sous_trie ['c'] t);
    assert (sous_trie ['a'; 'b'] t = Some feuille);
    assert (sous_trie ['b'] t = None);
    let a = {
      initial = 0;
      delta = [|[|1; 0|]; [|1; 2|]; [|3; 3|]; [|3; 3|]|];
      final = [|false; false; true; false|]
    } in
    let d = distances a in
    assert (d = [|2; 1; 0; -1|]);
    assert (completer_adc a d [] = Some [0; 1]);
    assert (completer_adc a d [1; 0] = Some [1]);
    assert (completer_adc a d [0; 1] = Some []);
    assert (completer_adc a d [0; 1; 0] = None);
    (* Comparaison à la recherche exhaustive, y compris sans état final. *)
    for masque = 0 to 7 do
      let final = Array.init 3 (fun q -> masque land (1 lsl q) <> 0) in
      for transitions = 0 to 728 do
        let code = ref transitions in
        let delta = Array.init 3 (fun _ -> Array.init 2 (fun _ -> let q = !code mod 3 in code := !code / 3; q)) in
        let b = {initial = 0; delta; final} in
        let db = distances b in
        let rec accepte q = function
          | [] -> final.(q)
          | c :: reste -> accepte delta.(q).(c) reste
        in
        let candidats = List.sort (fun u v -> let c = compare (List.length u) (List.length v) in if c = 0 then compare u v else c) (mots [0; 1] 2) in
        for q = 0 to 2 do
          let attendu = List.find_opt (accepte q) candidats in
          assert (completer_adc {b with initial = q} db [] = attendu)
        done
      done
    done;
    assert (completer_dyck [] = Some []);
    assert (completer_dyck (chars "([()") = Some (chars "])"));
    assert (completer_dyck (chars "([)]") = None);
    assert (completer_dyck (chars ")(") = None);
    let rec dyck pile = function
      | [] -> pile = []
      | '(' :: reste -> dyck (')' :: pile) reste
      | '[' :: reste -> dyck (']' :: pile) reste
      | a :: reste -> (match pile with b :: suite when a = b -> dyck suite reste | _ -> false)
    in
    List.iter (fun u ->
      match completer_dyck u with
      | None -> assert (not (List.exists (fun v -> dyck [] (u @ v)) (mots [')'; ']'] 4)))
      | Some v ->
        assert (dyck [] (u @ v));
        assert (not (List.exists (fun w -> List.length w < List.length v && dyck [] (u @ w)) (mots [')'; ']'] 4))))
      (mots ['('; '['; ')'; ']'] 4);
    (* Cycle stérile, effacement, cycle productif et dérivations doublantes. *)
    assert (longueurs [|[Unite 0]|] = [|None|]);
    assert (longueurs [|[Unite 1]; [Unite 0; Vide]|] = [|Some 0; Some 0|]);
    assert (longueurs [|[Produit (0, 0); Lettre 'a']|] = [|Some 1|]);
    assert (longueurs [|[Produit (1, 1)]; [Produit (2, 2)]; [Lettre 'a']|] = [|Some 4; Some 2; Some 1|]);
    assert (longueurs [|[Produit (1, 2)]; [Vide]; [Unite 2]|] = [|None; Some 0; None|]);
    assert (longueurs [|[Unite 1; Lettre 'b']; [Unite 2]; [Vide]|] = [|Some 0; Some 0; Some 0|]);
    let g = [|[Vide; Produit (1, 2)]; [Lettre 'a']; [Produit (0, 3)]; [Lettre 'b']|] in
    let attendu u =
      let rec lire balance ferme = function
        | [] -> Some balance
        | 'a' :: reste when not ferme -> lire (balance + 1) false reste
        | 'b' :: reste when balance > 0 -> lire (balance - 1) true reste
        | _ -> None
      in
      lire 0 false u
    in
    List.iter (fun u ->
      let h, axiome = quotient g 0 u in
      assert ((longueurs h).(axiome) = attendu u)) (mots ['a'; 'b'] 4);
    let h, axiome = quotient [|[Unite 0; Vide]|] 0 ['a'] in
    assert ((longueurs h).(axiome) = None);
    print_endline "Tests de complétion : OK"
end

let () = if not !Sys.interactive then Tests.lancer ()
