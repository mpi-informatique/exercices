let reconnait_l0 mot =
  let n = String.length mot in
  let i = ref 0 in
  while !i < n && mot.[!i] = 'a' do incr i done;
  let k = !i in
  while !i < n && mot.[!i] = 'b' do incr i done;
  !i = n && n = 2 * k

let reconnait_l0_etoile mot =
  let n = String.length mot in
  let rec blocs i =
    if i = n then true
    else begin
      let j = ref i in
      while !j < n && mot.[!j] = 'a' do incr j done;
      let k = !j in
      while !j < n && mot.[!j] = 'b' do incr j done;
      k > i && !j - k = k - i && blocs !j
    end
  in
  blocs 0

let decompose k n =
  let tab = Array.make n false in
  let r = ref k in
  for i = 0 to n - 1 do
    tab.(i) <- !r mod 2 = 1;
    r := !r / 2
  done;
  tab

let teste_decomposition dans_l mot coupe =
  let n = String.length mot in
  let debut = ref 0 in
  let valide = ref true in
  for i = 0 to n - 1 do
    if !valide && (i = n - 1 || coupe.(i)) then begin
      valide := dans_l (String.sub mot !debut (i - !debut + 1));
      debut := i + 1
    end
  done;
  !valide

let dans_l_etoile dans_l mot =
  let n = String.length mot in
  if n = 0 then true
  else begin
    (* Cette premiere version suppose 2^(n - 1) representable. *)
    let borne = 1 lsl (n - 1) in
    let rec cherche k =
      k < borne &&
      (teste_decomposition dans_l mot (decompose k (n - 1)) || cherche (k + 1))
    in
    cherche 0
  end

let suivant coupe =
  let i = ref 0 in
  while !i < Array.length coupe && coupe.(!i) do
    coupe.(!i) <- false;
    incr i
  done;
  if !i = Array.length coupe then false
  else begin coupe.(!i) <- true; true end

let dans_l_etoile_sans_entiers dans_l mot =
  let n = String.length mot in
  if n = 0 then true
  else begin
    let coupe = Array.make (n - 1) false in
    let rec cherche () =
      teste_decomposition dans_l mot coupe || (suivant coupe && cherche ())
    in
    cherche ()
  end

let dans_l_etoile_2 dans_l mot =
  let n = String.length mot in
  let rec aux debut =
    if debut = n then true
    else if dans_l (String.sub mot debut (n - debut)) then true
    else begin
      let rec cherche fin =
        fin < n - 1 &&
        ((dans_l (String.sub mot debut (fin - debut + 1)) && aux (fin + 1)) || cherche (fin + 1))
      in
      cherche debut
    end
  in
  aux 0

let dans_l_etoile_3 dans_l mot =
  let n = String.length mot in
  if n = 0 then true
  else begin
    let t = Array.make_matrix n n false in
    for longueur = 1 to n do
      for i = 0 to n - longueur do
        let j = i + longueur - 1 in
        t.(i).(j) <- dans_l (String.sub mot i longueur);
        let k = ref i in
        while not t.(i).(j) && !k < j do
          t.(i).(j) <- t.(i).(!k) && t.(!k + 1).(j);
          incr k
        done
      done
    done;
    t.(0).(n - 1)
  end

type fifo = { contenu : int array; mutable debut : int; mutable fin : int }

let creer_file taille =
  { contenu = Array.make taille 0; debut = 0; fin = -1 }

let est_vide f = f.debut > f.fin

let put v f =
  f.fin <- f.fin + 1;
  f.contenu.(f.fin) <- v

let get f =
  let v = f.contenu.(f.debut) in
  f.debut <- f.debut + 1;
  v

let put_circulaire v f =
  f.fin <- f.fin + 1;
  f.contenu.(f.fin mod Array.length f.contenu) <- v

let get_circulaire f =
  let v = f.contenu.(f.debut mod Array.length f.contenu) in
  f.debut <- f.debut + 1;
  v

let dans_l_etoile_4 dans_l mot =
  let n = String.length mot in
  if n = 0 then true
  else begin
    let f = creer_file (n + 1) in
    let vus = Array.make n false in
    put (-1) f;
    while not (est_vide f) && not vus.(n - 1) do
      let s = get f in
      for i = s + 1 to n - 1 do
        if not vus.(i) && dans_l (String.sub mot (s + 1) (i - s)) then begin
          vus.(i) <- true;
          put i f
        end
      done
    done;
    vus.(n - 1)
  end

let () =
  let algos = [dans_l_etoile; dans_l_etoile_sans_entiers; dans_l_etoile_2; dans_l_etoile_3; dans_l_etoile_4] in
  let mots = ref [""] in
  for n = 1 to 7 do
    for k = 0 to (1 lsl n) - 1 do
      mots := String.init n (fun i -> if k land (1 lsl i) = 0 then 'a' else 'b') :: !mots
    done
  done;
  let langages = [
    (fun _ -> false);
    (fun _ -> true);
    (fun w -> w = "");
    (fun w -> w = "a");
    (fun w -> w = "ab" || w = "ba");
    reconnait_l0
  ] in
  List.iter (fun dans_l -> List.iter (fun mot ->
    let attendu = dans_l_etoile_3 dans_l mot in
    List.iter (fun algo -> assert (algo dans_l mot = attendu)) algos;
    if dans_l == reconnait_l0 then assert (attendu = reconnait_l0_etoile mot)
  ) !mots) langages;
  assert (reconnait_l0 "" && reconnait_l0 "aabb" && not (reconnait_l0 "abab"));
  assert (reconnait_l0_etoile "aabbab" && not (reconnait_l0_etoile "aababb"));
  for k = 0 to 15 do
    let bits = decompose k 4 in
    let r = ref 0 in
    for i = 0 to 3 do if bits.(i) then r := !r + (1 lsl i) done;
    assert (!r = k)
  done;
  let coupe = Array.make 4 false in
  for k = 0 to 15 do
    assert (coupe = decompose k 4);
    assert (suivant coupe = (k < 15))
  done;
  let f = creer_file 3 in
  put 4 f; put 7 f;
  assert (get f = 4 && get f = 7 && est_vide f);
  let f = creer_file 3 in
  for i = 0 to 99 do
    put_circulaire i f;
    assert (get_circulaire f = i && est_vide f)
  done;
  (* Le pire cas recursif : tous les prefixes sans le dernier b sont acceptes. *)
  for n = 1 to 10 do
    let appels = ref 0 in
    let dans_l w = incr appels; not (String.contains w 'b') in
    assert (not (dans_l_etoile_2 dans_l (String.make (n - 1) 'a' ^ "b")));
    assert (!appels = (1 lsl n) - 1)
  done;
  print_endline "Centrale 2010 : comparaisons exhaustives jusqu'a 7 lettres et tests des files, coupures et complexites reussis."
