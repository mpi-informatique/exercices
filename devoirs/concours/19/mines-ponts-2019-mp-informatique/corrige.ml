type automate = int * (int * int) array * bool array
type morphisme = int array

let a2 : automate = (2, [|(0, 1); (1, 0)|], [|false; true|])

let numero n liste =
  let t = Array.make n (-1) in
  let rec aux position = function
    | [] -> ()
    | q :: suite ->
        t.(q) <- position;
        aux (position + 1) suite
  in
  aux 0 liste;
  t

let etats_accessibles (n, delta, f) =
  let vus = Array.make n false in
  let resultat = ref [] in
  let rec visiter q =
    if not vus.(q) then begin
      vus.(q) <- true;
      resultat := q :: !resultat;
      let succ_a, succ_b = delta.(q) in
      visiter succ_a;
      visiter succ_b
    end
  in
  visiter 0;
  let rec renverser acc = function (* ou List.rev *)
    | [] -> acc
    | q :: suite -> renverser (q :: acc) suite
  in
  renverser [] !resultat

let partie_accessible ((n, delta, f) as a) =
  let accessibles = etats_accessibles a in
  let num = numero n accessibles in
  let n' = List.length accessibles in
  let delta' = Array.make n' (0, 0) in
  let f' = Array.make n' false in
  let copier q =
    let succ_a, succ_b = delta.(q) in
    delta'.(num.(q)) <- (num.(succ_a), num.(succ_b));
    f'.(num.(q)) <- f.(q)
  in
  List.iter copier accessibles;
  (n', delta', f')

let existe_morphisme (n, delta, f) (n', delta', f') =
  let phi = Array.make n (-1) in
  let possible = ref true in
  let rec visiter q q' =
    if !possible then begin
      if phi.(q) <> -1 then begin
        if phi.(q) <> q' then possible := false
      end else if f.(q) <> f'.(q') then
        possible := false
      else begin
        phi.(q) <- q';
        let qa, qb = delta.(q) in
        let qa', qb' = delta'.(q') in
        visiter qa qa';
        visiter qb qb'
      end
    end
  in
  visiter 0 0;
  (!possible, phi)

let produit (n, delta, f) (n', delta', f') =
  let delta_prod = Array.make (n * n') (0, 0) in
  let f_prod = Array.make (n * n') false in
  for q = 0 to n - 1 do
    for q' = 0 to n' - 1 do
      let qa, qb = delta.(q) in
      let qa', qb' = delta'.(q') in
      let k = q + n * q' in
      delta_prod.(k) <- (qa + n * qa', qb + n * qb');
      f_prod.(k) <- f.(q) && f'.(q')
    done
  done;
  (n * n', delta_prod, f_prod)

let renomme t =
  let n = Array.length t in
  if n = 0 then [||]
  else begin
    let maximum = ref t.(0) in
    for i = 1 to n - 1 do
      maximum := max !maximum t.(i)
    done;
    let code = Array.make (!maximum + 1) (-1) in
    let resultat = Array.make n 0 in
    let prochain = ref 0 in
    for i = 0 to n - 1 do
      let valeur = t.(i) in
      if code.(valeur) = -1 then begin
        code.(valeur) <- !prochain;
        incr prochain
      end;
      resultat.(i) <- code.(valeur)
    done;
    resultat
  end

let relation phi psi =
  let n = Array.length phi in
  let eta = Array.make n (-1) in
  let rec visiter p classe =
    if eta.(p) = -1 then begin
      eta.(p) <- classe;
      for q = 0 to n - 1 do
        if phi.(p) = phi.(q) || psi.(p) = psi.(q) then
          visiter q classe
      done
    end
  in
  let prochaine = ref 0 in
  for p = 0 to n - 1 do
    if eta.(p) = -1 then begin
      visiter p !prochaine;
      incr prochaine
    end
  done;
  eta

let table_de_predecesseurs (n, delta, f) =
  let pred = Array.make_matrix n n [] in
  for p = 0 to n - 1 do
    for q = 0 to n - 1 do
      let pa, pb = delta.(p) in
      let qa, qb = delta.(q) in
      pred.(pa).(qa) <- (p, q) :: pred.(pa).(qa);
      pred.(pb).(qb) <- (p, q) :: pred.(pb).(qb)
    done
  done;
  let d = Array.make_matrix n n false in
  let rec visiter (p, q) =
    if not d.(p).(q) then begin
      d.(p).(q) <- true;
      List.iter visiter pred.(p).(q)
    end
  in
  for p = 0 to n - 1 do
    for q = 0 to n - 1 do
      if f.(p) <> f.(q) then visiter (p, q)
    done
  done;
  d

let reduit aut =
  let (n, delta, f) = partie_accessible aut in
  let d = table_de_predecesseurs (n, delta, f) in
  let classe = Array.make n (-1) in
  let representant = Array.make n 0 in
  let nombre = ref 0 in
  for p = 0 to n - 1 do
    if classe.(p) = -1 then begin
      representant.(!nombre) <- p;
      for q = p to n - 1 do
        if not d.(p).(q) then classe.(q) <- !nombre
      done;
      incr nombre
    end
  done;
  let delta' = Array.make !nombre (0, 0) in
  let f' = Array.make !nombre false in
  for k = 0 to !nombre - 1 do
    let p = representant.(k) in
    let pa, pb = delta.(p) in
    delta'.(k) <- (classe.(pa), classe.(pb));
    f'.(k) <- f.(p)
  done;
  (!nombre, delta', f')

(* TESTS COPIES
{
  "verifications": "Tests",
  "tests": {
    "1.5": {"code": "let a2 = {1.5}", "appel": "Tests.test_a2 a2"},
    "1.6": {"code": "{1.6}", "appel": "Tests.test_numero numero"},
    "1.7": {"code": "{1.7}", "appel": "Tests.test_etats_accessibles etats_accessibles"},
    "1.8": {"code": "{1.7}\n{1.8}", "appel": "Tests.test_partie_accessible partie_accessible"},
    "1.17": {"code": "{1.17}", "appel": "Tests.test_existe_morphisme existe_morphisme"},
    "1.19": {"code": "{1.7}\n{1.19}", "appel": "Tests.test_produit etats_accessibles produit"},
    "1.27": {"code": "{1.27}", "appel": "Tests.test_renomme renomme"}
  },
  "references": {"1.7": "etats_accessibles"}
}
*)

module Tests = struct
  let verifie message condition = if not condition then failwith message
  let a1 = (2, [|(1, 1); (0, 0)|], [|false; true|])
  let a2_reference = (2, [|(0, 1); (1, 0)|], [|false; true|])
  let a3 = (3, [|(1, 2); (1, 2); (2, 1)|], [|false; false; true|])
  let a4 = (4, [|(1, 2); (0, 3); (3, 0); (2, 1)|], [|false; false; true; true|])
  (* Ordre P, O, Q, R, S, T de la figure 6 ; P est initial. *)
  let a6 = (6, [|(0, 2); (0, 5); (3, 1); (2, 4); (5, 4); (3, 0)|],
               [|true; true; false; false; false; false|])

  (* Oracle indépendant : comparer les langages depuis deux états par
     parcours du produit vers l'avant, jusqu'à un désaccord de finalité. *)
  let equivalents (_, d, f) p (_, d', f') q =
    let vus = Hashtbl.create 16 in
    let rec visiter = function
      | [] -> true
      | (p, q) :: suite when Hashtbl.mem vus (p, q) -> visiter suite
      | (p, q) :: suite ->
          Hashtbl.add vus (p, q) ();
          let pa, pb = d.(p) and qa, qb = d'.(q) in
          f.(p) = f'.(q) && visiter ((pa, qa) :: (pb, qb) :: suite)
    in visiter [p, q]

  let est_morphisme (n, d, f) (m, d', f') phi =
    let image = Array.make m false in
    let ok = ref (Array.length phi = n && phi.(0) = 0) in
    for p = 0 to n - 1 do
      let q = phi.(p) in
      if q < 0 || q >= m then ok := false
      else begin
        image.(q) <- true;
        let pa, pb = d.(p) and qa, qb = d'.(q) in
        if f.(p) <> f'.(q) || phi.(pa) <> qa || phi.(pb) <> qb then ok := false
      end
    done;
    !ok && Array.for_all (fun x -> x) image

  let test_a2 a2 =
    verifie "automate a2" (a2 = a2_reference)

  let test_numero numero =
    let liste = [3; 2; 0; 3] in
    let resultat = numero 5 liste in
    verifie "numero" (resultat.(1) = -1 && resultat.(4) = -1 &&
      List.nth liste resultat.(0) = 0 && List.nth liste resultat.(2) = 2 &&
      List.nth liste resultat.(3) = 3 && numero 0 [] = [||])

  let test_etats_accessibles etats_accessibles =
    verifie "ordre DFS" (etats_accessibles a6 = [0; 2; 3; 4; 5; 1])

  let test_partie_accessible partie_accessible =
    let trou = (4, [|(2, 2); (1, 1); (3, 0); (3, 2)|], [|false; true; false; true|]) in
    let attendu = (3, [|(1, 1); (2, 0); (2, 1)|], [|false; false; true|]) in
    verifie "partie accessible" (partie_accessible trou = attendu)

  let test_existe_morphisme existe_morphisme =
    let ok, phi = existe_morphisme a3 a2_reference in
    verifie "morphisme" (ok && est_morphisme a3 a2_reference phi);
    let non1, _ = existe_morphisme a1 a2_reference in
    let non2, _ = existe_morphisme (1, [|(0, 0)|], [|true|]) (1, [|(0, 0)|], [|false|]) in
    verifie "absence de morphisme" (not non1 && not non2)

  let test_produit etats_accessibles produit =
    let prod = produit a3 a4 in
    verifie "produit" (List.length (etats_accessibles prod) = 5 &&
      equivalents prod 0 a2_reference 0)

  let test_renomme renomme =
    verifie "renomme" (renomme [|4; 4; 5; 0; 4; 5|] = [|0; 0; 1; 2; 0; 1|] &&
      renomme [||] = [||])

  let test_relation relation =
    verifie "relation" (relation [|0; 1; 1; 2; 2|] [|0; 0; 1; 2; 3|] = [|0; 0; 0; 1; 1|])

  let test_table_de_predecesseurs table_de_predecesseurs =
    let contre_exemple = (2, [|(1, 1); (1, 1)|], [|false; true|]) in
    verifie "sens des prédécesseurs"
      (table_de_predecesseurs contre_exemple = [|[|false; true|]; [|true; false|]|]);
    let d = table_de_predecesseurs a6 in
    for p = 0 to 5 do
      for q = 0 to 5 do
        verifie "table exacte" (d.(p).(q) = not (equivalents a6 p a6 q))
      done
    done

  let test_reduit reduit etats_accessibles =
    let verifie_reduction aut taille =
      let ((n, _, _) as minimal) = reduit aut in
      verifie "nombre minimal d'états" (n = taille);
      verifie "conservation exacte du langage" (equivalents aut 0 minimal 0);
      verifie "accessibilité" (List.length (etats_accessibles minimal) = n);
      for p = 0 to n - 1 do
        for q = p + 1 to n - 1 do
          verifie "états distincts distinguables" (not (equivalents minimal p minimal q))
        done
      done
    in
    verifie_reduction a6 3;
    let trou = (4, [|(2, 2); (1, 1); (3, 0); (3, 2)|], [|false; true; false; true|]) in
    verifie_reduction trou 3;
    verifie_reduction (3, [|(1, 2); (2, 0); (0, 1)|], [|false; false; false|]) 1;
    verifie_reduction (3, [|(1, 2); (2, 0); (0, 1)|], [|true; true; true|]) 1
end

let () =
  Tests.test_a2 a2;
  Tests.test_numero numero;
  Tests.test_etats_accessibles etats_accessibles;
  Tests.test_partie_accessible partie_accessible;
  Tests.test_existe_morphisme existe_morphisme;
  Tests.test_produit etats_accessibles produit;
  Tests.test_renomme renomme;
  Tests.test_relation relation;
  Tests.test_table_de_predecesseurs table_de_predecesseurs;
  Tests.test_reduit reduit etats_accessibles;
  print_endline "Mines-Ponts 2019 : 10 groupes de tests réussis."
