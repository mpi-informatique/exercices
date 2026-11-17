type lettre = int
type mot = lettre list
type etat = int
type machine = {n_etats : int; n_lettres : int; delta : etat -> lettre -> etat}
type 'a file = {tab : 'a array; mutable deb : int; mutable fin : int; mutable vide : bool}
type arc = Rien | Vide | Arc of etat * lettre
type un_ou_deux = Un of int | Deux of int * int

(* Codage des singletons, puis des paires : utilisé seulement par les tests.
   L'énoncé suppose les conversions disponibles en temps constant. *)
let set_to_nb n = function
  | Un i -> i
  | Deux (i, j) -> n + i * (2 * n - i - 1) / 2 + j - i - 1
let nb_to_set n q =
  if q < n then Un q else
  let rec ligne i k =
    let taille = n - i - 1 in
    if k < taille then Deux (i, i + 1 + k) else ligne (i + 1) (k - taille)
  in ligne 0 (q - n)

let rec delta_etoile m q w =
  match w with
  | [] -> q
  | x :: xs -> delta_etoile m (m.delta q x) xs

let est_synchronisant m w =
  let candidat = delta_etoile m 0 w in
  let q = ref 1 in
  while !q < m.n_etats && delta_etoile m !q w = candidat do
    incr q
  done;
  !q = m.n_etats

let ajoute f x =
  if Array.length f.tab = 0 || (f.deb = f.fin && not f.vide) then failwith "file pleine";
  f.tab.(f.fin) <- x;
  f.fin <- (f.fin + 1) mod (Array.length f.tab);
  f.vide <- false

let retire f =
  if f.vide then failwith "file vide";
  let resultat = f.tab.(f.deb) in
  f.deb <- (f.deb + 1) mod (Array.length f.tab);
  if f.deb = f.fin then f.vide <- true;
  resultat

let accessibles graphe ens =
  (* initialisation *)
  let n = Array.length graphe in
  let f = {tab = Array.make n 0; deb = 0; fin = 0; vide = true} in
  let inf = -1 in
  let d = Array.make n inf in
  let p = Array.make n Vide in
  let c = ref n in

  (* boucle for *)
  let initialise s =
    ajoute f s;
    d.(s) <- 0;
    p.(s) <- Rien;
    c := !c - 1 in
  List.iter initialise ens;

  (* boucle while *)
  while not f.vide do
    let s = retire f in
    let traite_arc (s', y) =
      if d.(s') = inf then begin
        d.(s') <- d.(s) + 1;
        p.(s') <- Arc (s, y);
        ajoute f s';
        decr c
      end in
    List.iter traite_arc graphe.(s);
  done;

  !c, d, p

let chemin s p =
  let rec aux s chemin =
  match p.(s) with
  | Vide -> failwith "pas de chemin"
  | Rien -> chemin
  | Arc (s', x) -> aux s' (x :: chemin) in
  aux s []

let delta2 m e x =
  let n = m.n_etats in
  match nb_to_set n e with
  | Un i -> set_to_nb n (Un (m.delta i x))
  | Deux (i, j) ->
    let ei = m.delta i x in
    let ej = m.delta j x in
    if ei = ej then set_to_nb n (Un ei)
    else set_to_nb n (Deux (min ei ej, max ei ej))

let retourne_machine m =
  let n = m.n_etats in
  let ntilde = n * (n + 1) / 2 in
  let v = Array.make ntilde [] in
  for q = 0 to ntilde - 1 do
    for x = 0 to m.n_lettres - 1 do
      let q' = delta2 m q x in
      v.(q') <- (q, x) :: v.(q')
    done
  done;
  v

let singletons n =
  let rec aux k =
    if k = n then []
    else set_to_nb n (Un k) :: aux (k + 1) in
  aux 0

let existe_synchronisant m =
  let c, _, _ = accessibles (retourne_machine m) (singletons m.n_etats) in
  c = 0

module Tests = struct
  let m0 = {n_etats = 3; n_lettres = 2;
    delta = fun q x -> [|[|1;1|];[|0;2|];[|0;2|]|].(q).(x)}
  let m1 = {n_etats = 2; n_lettres = 1; delta = fun q _ -> 1 - q}
  let m2 = {n_etats = 4; n_lettres = 4;
    delta = fun q x -> [|[|1;0;3;2|];[|1;0;1;0|];[|2;3;0;1|];[|2;3;2;3|]|].(q).(x)}
  let v0 = [| [(0,1);(3,0);(2,1);(1,0)]; [(1,0);(2,0)];
    [(1,1);(3,1);(4,1)]; [(2,0)]; [(1,0);(5,1)]; [(1,0)] |]
  let echoue f = try f (); false with Failure _ -> true

  let () =
    (* 1. Lecture d'un mot, y compris le mot vide. *)
    assert (delta_etoile m0 2 [] = 2 && delta_etoile m0 0 [1;0] = 0);
    (* 2. Les exemples de synchronisation du sujet. *)
    assert (est_synchronisant m0 [1;0] && est_synchronisant m0 [1;1]);
    assert (not (est_synchronisant m0 []) && not (est_synchronisant m1 [0;0;0]));
    assert (est_synchronisant m2 [0;2;0]);
    (* 3. Arrêt au premier contre-exemple. *)
    let appels = ref 0 in
    let m = {n_etats = 10; n_lettres = 1;
      delta = fun q _ -> incr appels; q} in
    assert (not (est_synchronisant m [0]) && !appels = 2);
    (* 4. File pleine, tour circulaire et extraction en ordre FIFO. *)
    let f = {tab = Array.make 2 0; deb = 0; fin = 0; vide = true} in
    ajoute f 4; ajoute f 5;
    assert (echoue (fun () -> ajoute f 6));
    assert (retire f = 4); ajoute f 6;
    assert (retire f = 5 && retire f = 6 && f.vide);
    assert (echoue (fun () -> ignore (retire f)));
    (* 5. Une capacité nulle refuse l'insertion. *)
    let vide = {tab = [||]; deb = 0; fin = 0; vide = true} in
    assert (echoue (fun () -> ajoute vide 0));
    (* 6. Distances et reconstruction d'un plus court chemin. *)
    let c,d,p = accessibles v0 [0] in
    assert (c = 0 && d = [|0;1;1;1;2;3|]);
    assert (chemin 0 p = [] && chemin 5 p = [1;1;1]);
    (* 7. Sources multiples, sommet inaccessible et graphe vide. *)
    let c,d,p = accessibles [|[(1,0)]; []; []|] [0;1] in
    assert (c = 1 && d = [|0;0;-1|] && p.(0) = Rien && p.(1) = Rien);
    assert (echoue (fun () -> ignore (chemin 2 p)));
    assert (accessibles [||] [] = (0,[||],[||]));
    (* 8. Conversions et transitions des ensembles, singleton ou paire. *)
    for n = 1 to 6 do
      for e = 0 to n * (n + 1) / 2 - 1 do
        assert (set_to_nb n (nb_to_set n e) = e)
      done
    done;
    assert (nb_to_set 3 (delta2 m0 (set_to_nb 3 (Deux (1,2))) 0) = Un 0);
    assert (nb_to_set 3 (delta2 m0 (set_to_nb 3 (Deux (0,1))) 1) = Deux (1,2));
    assert (nb_to_set 3 (delta2 m0 (set_to_nb 3 (Un 0)) 1) = Un 1);
    (* 9. Tous les arcs inversés sont conservés une fois, sans arcs parasites. *)
    let v = retourne_machine m0 in
    let total = Array.fold_left (fun acc arcs -> acc + List.length arcs) 0 v in
    assert (total = 12);
    Array.iteri (fun arrivee arcs ->
      List.iter (fun (depart,x) -> assert (delta2 m0 depart x = arrivee)) arcs) v;
    for q = 0 to 5 do
      for x = 0 to 1 do
        assert (List.mem (q,x) v.(delta2 m0 q x))
      done
    done;
    (* 10. Critère d'existence positif, négatif et cas d'un seul état. *)
    assert (existe_synchronisant m0 && existe_synchronisant m2);
    assert (not (existe_synchronisant m1));
    assert (existe_synchronisant {n_etats = 1; n_lettres = 1; delta = fun _ _ -> 0});
    print_endline "Centrale 2017 : 10 groupes de tests reussis."
end
