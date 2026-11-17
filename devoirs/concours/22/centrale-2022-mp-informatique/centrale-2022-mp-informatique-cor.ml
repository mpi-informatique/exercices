type automate = {
  nb : int;
  init : int list;
  final : int list;
  trans : (int * char * int) list
}

let a1 = {
  nb = 3; init = [0]; final = [2];
  trans = [(0, 'a', 0); (0, 'a', 1); (0, 'b', 0);
           (1, 'b', 2); (2, 'a', 2)]
}

let transpose a =
  { nb = a.nb; init = a.final; final = a.init;
    trans = List.map (fun (p, c, q) -> (q, c, p)) a.trans }

let palindrome s =
  let n = String.length s in
  let rec teste i =
    i >= n / 2 || (s.[i] = s.[n - 1 - i] && teste (i + 1))
  in
  teste 0

let a2 = {
  nb = 4; init = [0]; final = [3];
  trans = [(0, 'b', 0); (0, 'a', 1); (1, 'b', 0);
           (0, 'b', 2); (2, 'a', 3)]
}

let rec supprimer = function
  | [] -> []
  | x :: xs ->
      if List.mem x xs then supprimer xs
      else x :: supprimer xs

let pow =
  let t = Array.make 21 1 in
  for i = 1 to 20 do
    t.(i) <- t.(i - 1) * 2
  done;
  t

let est_dans q k = (k / pow.(q)) mod 2 = 1

let numero l =
  let rec ajoute k = function
    | [] -> k
    | q :: qs ->
        ajoute (if est_dans q k then k else k + pow.(q)) qs
  in
  ajoute 0 l

let rec intersecte l k =
  match l with
  | [] -> false
  | q :: qs -> est_dans q k || intersecte qs k

let etat_suivant k transitions =
  let ajoute q x = if est_dans q x then x else x + pow.(q) in
  let rec parcours ka kb = function
    | [] -> (ka, kb)
    | (p, c, q) :: ts ->
        if not (est_dans p k) then parcours ka kb ts
        else if c = 'a' then parcours (ajoute q ka) kb ts
        else parcours ka (ajoute q kb) ts
  in
  parcours 0 0 transitions

let rec cherche k = function
  | [] -> -1
  | (x, v) :: xs -> if x = k then v else cherche k xs

let determinise a =
  let depart = numero a.init in
  let noms = ref [(depart, 0)] in
  let nombre = ref 1 in
  let attente = ref [depart] in
  let transitions = ref [] in
  let finaux = ref [] in
  let nom k =
    let v = cherche k !noms in
    if v <> -1 then v
    else begin
      let v = !nombre in
      incr nombre;
      noms := (k, v) :: !noms;
      attente := k :: !attente;
      v
    end
  in
  while !attente <> [] do
    match !attente with
    | [] -> ()
    | k :: suite ->
        attente := suite;
        let v = cherche k !noms in
        if intersecte a.final k then finaux := v :: !finaux;
        let ka, kb = etat_suivant k a.trans in
        let va = nom ka in
        let vb = nom kb in
        transitions := (v, 'a', va) :: (v, 'b', vb) :: !transitions
  done;
  { nb = !nombre; init = [0]; final = !finaux; trans = !transitions }

let minimal a = determinise (transpose (determinise (transpose a)))

type exprat =
  | Vide
  | Epsilon
  | Lettre of char
  | Union of exprat * exprat
  | Concat of exprat * exprat
  | Etoile of exprat

let rec lettre = function
  | Vide | Epsilon -> 0
  | Lettre _ -> 1
  | Union (e, f) | Concat (e, f) -> lettre e + lettre f
  | Etoile e -> lettre e

let rec est_vide = function
  | Vide -> true
  | Epsilon | Lettre _ | Etoile _ -> false
  | Union (e, f) -> est_vide e && est_vide f
  | Concat (e, f) -> est_vide e || est_vide f

let su = function
  | Union (Vide, e) | Union (e, Vide) -> e
  | e -> e

let se = function
  | Etoile Vide | Etoile Epsilon -> Epsilon
  | Etoile (Etoile e) -> Etoile e
  | e -> e

let sc = function
  | Concat (Vide, _) | Concat (_, Vide) -> Vide
  | Concat (Epsilon, e) | Concat (e, Epsilon) -> e
  | e -> e

let rec simplifie = function
  | Union (e, f) -> su (Union (simplifie e, simplifie f))
  | Concat (e, f) -> sc (Concat (simplifie e, simplifie f))
  | Etoile e -> se (Etoile (simplifie e))
  | e -> e

type mat = exprat array array

let somme a b =
  let n = Array.length a in
  let p = Array.length a.(0) in
  Array.init n (fun i -> Array.init p (fun j -> Union (a.(i).(j), b.(i).(j))))

let produit a b =
  let n = Array.length a in
  let p = Array.length b in
  let q = Array.length b.(0) in
  let c = Array.make_matrix n q Vide in
  for i = 0 to n - 1 do
    for j = 0 to q - 1 do
      for k = 0 to p - 1 do
        c.(i).(j) <- Union (c.(i).(j), Concat (a.(i).(k), b.(k).(j)))
      done
    done
  done;
  c

(* Fonctions fournies par l'énoncé, implémentées pour exécuter le corrigé. *)
let decouper m n1 n2 =
  let bloc i0 j0 n p =
    Array.init n (fun i -> Array.init p (fun j -> m.(i0 + i).(j0 + j)))
  in
  (bloc 0 0 n1 n1, bloc 0 n1 n1 n2,
   bloc n1 0 n2 n1, bloc n1 n1 n2 n2)

let recoller a b c d =
  let n1 = Array.length a and n2 = Array.length d in
  Array.init (n1 + n2) (fun i ->
    Array.init (n1 + n2) (fun j ->
      if i < n1 then
        if j < n1 then a.(i).(j) else b.(i).(j - n1)
      else if j < n1 then c.(i - n1).(j)
      else d.(i - n1).(j - n1)))

let rec etoile m =
  let n = Array.length m in
  if n = 1 then [|[|Etoile m.(0).(0)|]|]
  else begin
    let n1 = n / 2 in
    let a, b, c, d = decouper m n1 (n - n1) in
    let sa = etoile a in
    let sd = etoile d in
    let sab = produit sa b in
    let sdc = produit sd c in
    let ap = etoile (somme a (produit b sdc)) in
    let dp = etoile (somme d (produit c sab)) in
    recoller ap (produit sab dp) (produit sdc ap) dp
  end

let langage a =
  if a.nb = 0 then Vide
  else begin
    let m = Array.make_matrix a.nb a.nb Vide in
    List.iter (fun (i, c, j) ->
      m.(i).(j) <- Union (m.(i).(j), Lettre c)) a.trans;
    let fermeture = etoile m in
    let resultat = ref Vide in
    List.iter (fun i ->
      List.iter (fun j ->
        resultat := Union (!resultat, fermeture.(i).(j))) a.final) a.init;
    !resultat
  end

module Tests = struct
  let verifie message condition = if not condition then failwith message

  let rec mots n =
    if n = 0 then [""]
    else "" :: List.concat_map (fun w -> ["a" ^ w; "b" ^ w]) (mots (n - 1))

  let accepte a w =
    let etats = ref a.init in
    String.iter (fun c ->
      etats := List.sort_uniq compare
        (List.filter_map (fun (p, d, q) ->
          if c = d && List.mem p !etats then Some q else None) a.trans)) w;
    List.exists (fun q -> List.mem q a.final) !etats

  let miroir s = String.init (String.length s) (fun i -> s.[String.length s - 1 - i])

  let suivant a q c =
    match List.filter (fun (p, d, _) -> p = q && c = d) a.trans with
    | [(_, _, r)] -> r
    | _ -> failwith "Automate non déterministe ou incomplet"

  (* Équivalence exacte de deux états déterministes par parcours du produit. *)
  let equivalents a p b q =
    let vus = Hashtbl.create 16 in
    let rec explore = function
      | [] -> true
      | (p, q) :: suite when Hashtbl.mem vus (p, q) -> explore suite
      | (p, q) :: suite ->
          Hashtbl.add vus (p, q) ();
          (List.mem p a.final = List.mem q b.final) &&
          explore ((suivant a p 'a', suivant b q 'a') ::
                   (suivant a p 'b', suivant b q 'b') :: suite)
    in
    explore [p, q]

  (* Sémantique indépendante des expressions : reconnaissance des sous-chaînes.
     Pour une étoile, ne consommer que des facteurs non vides assure la terminaison,
     y compris lorsque l'expression étoilée accepte epsilon. *)
  let reconnait expression mot =
    let memo = Hashtbl.create 128 in
    let rec lit e i j =
      match Hashtbl.find_opt memo (e, i, j) with
      | Some b -> b
      | None ->
          let existe lo hi f =
            let rec boucle k = k <= hi && (f k || boucle (k + 1)) in
            boucle lo
          in
          let resultat = match e with
            | Vide -> false
            | Epsilon -> i = j
            | Lettre c -> j = i + 1 && mot.[i] = c
            | Union (a, b) -> lit a i j || lit b i j
            | Concat (a, b) -> existe i j (fun k -> lit a i k && lit b k j)
            | Etoile a -> i = j || existe (i + 1) j (fun k -> lit a i k && lit e k j)
          in
          Hashtbl.add memo (e, i, j) resultat;
          resultat
    in
    lit expression 0 (String.length mot)

  let () =
    List.iter (fun w ->
      verifie "Palindromes" (palindrome w = (w = miroir w));
      verifie "Transposition" (accepte (transpose a1) w = accepte a1 (miroir w))) (mots 8);
    verifie "Palindromes longs" (palindrome (String.make 100000 'a'));
    verifie "Numéro avec doublons" (numero [1;5;2;5;2;5;2;2;1;2;1] = 38);
    verifie "Bit maximal" (est_dans 19 (numero [19;19]));
    verifie "Suppression" (List.sort compare (supprimer [2;1;2;3;1]) = [1;2;3]);
    verifie "Ensembles vides" (numero [] = 0 && not (intersecte [] 0));
    verifie "Successeurs, pas prédécesseurs"
      (etat_suivant 1 [(0,'a',1);(0,'a',1);(0,'b',2);(2,'a',3)] = (2,4));
    let vide = { nb=0; init=[]; final=[]; trans=[] } in
    verifie "Langage de l'automate vide" (langage vide = Vide);
    let det_vide = determinise vide in
    verifie "Déterminisé du langage vide" (det_vide.nb = 1 && det_vide.final = []);
    let boucles = { nb=1; init=[0]; final=[0]; trans=[0,'a',0;0,'b',0] } in
    verifie "État initial final et boucles" (determinise boucles = boucles);
    let a3 = determinise (transpose a2) in
    let a4 = minimal a2 in
    let table3 = { nb=5; init=[0]; final=[3;4]; trans=[
      0,'a',1;0,'b',2;1,'a',2;1,'b',3;2,'a',2;2,'b',2;
      3,'a',2;3,'b',4;4,'a',3;4,'b',4] } in
    let table4 = { nb=5; init=[0]; final=[4]; trans=[
      0,'a',1;0,'b',2;1,'a',3;1,'b',0;2,'a',4;2,'b',2;
      3,'a',3;3,'b',3;4,'a',3;4,'b',0] } in
    verifie "Table Q14" (a3.nb=5 && equivalents a3 0 table3 0);
    verifie "Table Q15" (a4.nb=5 && equivalents a4 0 table4 0);

    (* Tous les automates à deux états sur a,b, avec tous les choix I et F. *)
    let sous_ensemble masque = List.filter (fun q -> masque land (1 lsl q) <> 0) [0;1] in
    for masque = 0 to 255 do
      let transitions = ref [] in
      for i = 0 to 7 do
        if masque land (1 lsl i) <> 0 then
          transitions := (i / 4, (if (i / 2) mod 2 = 0 then 'a' else 'b'), i mod 2)
                         :: !transitions
      done;
      for init = 0 to 3 do
        for fin = 0 to 3 do
          let a = { nb=2; init=sous_ensemble init; final=sous_ensemble fin;
                    trans= !transitions } in
          let d = determinise a in
          List.iter (fun w -> verifie "Déterminisation" (accepte a w = accepte d w)) (mots 4);
          let m = minimal a in
          verifie "Brzozowski préserve le langage" (equivalents d 0 m 0);
          for p = 0 to m.nb - 1 do
            for q = p + 1 to m.nb - 1 do
              verifie "Brzozowski est minimal" (not (equivalents m p m q))
            done
          done
        done
      done
    done;

    let la = Lettre 'a' and lb = Lettre 'b' in
    let e = Union (Union (Concat (Etoile la, lb),
      Concat (la, Concat (lb, Concat (lb, Concat (la, Etoile (Union (la,Epsilon))))))), Vide) in
    verifie "Exemple Q30" (lettre e = 7);
    verifie "Langages vides" (est_vide (Concat (e,Vide)) && not (est_vide (Etoile Vide)));
    verifie "Étoile du vide" (se (Etoile Vide) = Epsilon);
    let rec en n = if n=0 then Vide else Concat (lb, en (n-1)) in
    verifie "Simplification E4" (simplifie (Union (la,en 4)) = la);
    let expressions = [Vide; Epsilon; e; Etoile Vide;
      Etoile (Etoile (Union (Vide,la))); Concat (Union (Vide,lb),Epsilon);
      Concat (Vide,Etoile la); Etoile (Union (Epsilon,Concat (la,lb)))] in
    List.iter (fun expression -> List.iter (fun w ->
      verifie "Simplification conserve le langage"
        (reconnait expression w = reconnait (simplifie expression) w)) (mots 4)) expressions;

    let rect_a = [|[|la; Epsilon; lb|]; [|Vide; lb; la|]|] in
    let rect_b = [|[|Epsilon; lb|];[|la; Vide|];[|lb; la|]|] in
    let rect_c = produit rect_a rect_b in
    List.iter (fun w -> for i=0 to 1 do for j=0 to 1 do
      let attendu = Union (Concat(rect_a.(i).(0),rect_b.(0).(j)),
        Union(Concat(rect_a.(i).(1),rect_b.(1).(j)),Concat(rect_a.(i).(2),rect_b.(2).(j)))) in
      verifie "Produit rectangulaire" (reconnait rect_c.(i).(j) w = reconnait attendu w)
    done done) (mots 3);

    (* Tailles paires, impaires et cas de base : comparer Conway à la simulation. *)
    Random.init 2022;
    let cas = ref [a1; a2; boucles; {nb=1;init=[0];final=[0];trans=[]}] in
    for n=1 to 5 do
      for _essai=1 to 3 do
        let transitions = ref [] in
        for i=0 to n-1 do for j=0 to n-1 do
          List.iter (fun c -> if Random.int 4=0 then
            transitions := (i,c,j):: !transitions) ['a';'b']
        done done;
        cas := {nb=n;init=[0];final=[n-1];trans= !transitions} :: !cas
      done
    done;
    List.iter (fun a ->
      let expression = langage a in
      List.iter (fun w -> verifie "Conway" (accepte a w = reconnait expression w)) (mots 4)) !cas;

    (* L'automate dessiné en Q45, avec E=0, bE=1, a=2, epsilon=3. *)
    let expression = Concat (Etoile (Union (Concat(la,lb),lb)),Concat(lb,la)) in
    List.iter (fun w -> verifie "Automate d'Antimirov Q45"
      (reconnait expression w = accepte a2 w)) (mots 8);
    Printf.printf "OCaml : 4096 automates, minimalité, palindromes, simplifications, matrices et Conway vérifiés.\n"
end
