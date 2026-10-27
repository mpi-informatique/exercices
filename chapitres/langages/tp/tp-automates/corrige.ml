type adc = {
  initial : int;
  finaux : int list;
  delta : int array array
}

let a1 = {
  initial = 0;
  finaux = [1];
  delta = [|[|1; 0|]; [|0; 1|]|]
}

let a2 = {
  initial = 0;
  finaux = [2];
  delta = [|[|0; 1|]; [|1; 2|]; [|2; 0|]|]
}

let rec delta_etoile a q u = match u with
  | [] -> q
  | x :: suite -> delta_etoile a a.delta.(q).(x) suite

let accepte a u =
  List.mem (delta_etoile a a.initial u) a.finaux

let complementaire a =
  let rec finaux q =
    if q < 0 then []
    else if List.mem q a.finaux then finaux (q - 1)
    else q :: finaux (q - 1) in
  { initial = a.initial; finaux = finaux (Array.length a.delta - 1); delta = a.delta }

let accessibles a =
  let vus = Array.make (Array.length a.delta) false in
  let rec visiter q =
    vus.(q) <- true;
    for x = 0 to Array.length a.delta.(q) - 1 do
      let r = a.delta.(q).(x) in
      if not vus.(r) then visiter r
    done in
  visiter a.initial;
  let rec liste q =
    if q < 0 then []
    else if vus.(q) then q :: liste (q - 1)
    else liste (q - 1) in
  liste (Array.length a.delta - 1)

let vide a =
  not (List.exists (fun q -> List.mem q a.finaux) (accessibles a))

let inter a b =
  let n = Array.length a.delta in
  let p = Array.length b.delta in
  let s = Array.length a.delta.(0) in
  let d = Array.make_matrix (n * p) s 0 in
  let f = ref [] in
  for i = 0 to n - 1 do
    for j = 0 to p - 1 do
      for x = 0 to s - 1 do
        d.(i * p + j).(x) <- a.delta.(i).(x) * p + b.delta.(j).(x)
      done;
      if List.mem i a.finaux && List.mem j b.finaux then
        f := (i * p + j) :: !f
    done
  done;
  { initial = a.initial * p + b.initial; finaux = !f; delta = d }

let inclus a b =
  vide (inter a (complementaire b))

let equivalent a b =
  inclus a b && inclus b a

(* Vérifier les cas limites et la construction du produit. *)
let () =
  assert (delta_etoile a1 0 [] = 0);
  assert (accepte a1 [0; 1]);
  assert (not (accepte a1 [0; 0]));
  assert (accepte a2 [1; 0; 1]);
  assert (accepte (complementaire a1) []);
  assert (List.sort compare (accessibles a2) = [0; 1; 2]);
  assert (vide { a1 with finaux = [] });
  assert (accepte (inter a1 a2) [0; 1; 1]);
  assert (not (inclus a1 a2));
  assert (equivalent a1 (complementaire (complementaire a1)))
