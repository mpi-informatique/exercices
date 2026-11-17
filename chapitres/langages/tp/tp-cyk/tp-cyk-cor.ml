type grammaire = {
  n_variables : int;
  regles1 : (int * char) list;
  regles2 : (int * int * int) list;
  epsilon : bool
}

let g0 = {
  n_variables = 5;
  regles1 = [(0, 'b'); (1, 'a'); (2, 'b'); (4, 'a')];
  regles2 = [(0, 1, 2); (0, 2, 1); (0, 3, 1); (1, 1, 4); (3, 1, 2)];
  epsilon = false
}

let init g u =
  let n = String.length u in
  let k = g.n_variables in
  let t = Array.init (n + 1) (fun _ -> Array.make_matrix n k false) in
  List.iter (fun (i, a) ->
    for d = 0 to n - 1 do
      if u.[d] = a then t.(1).(d).(i) <- true
    done
  ) g.regles1;
  t

let cyk g u =
  let n = String.length u in
  if n = 0 then g.epsilon
  else begin
    let t = init g u in
    for l = 2 to n do
      for d = 0 to n - l do
        List.iter (fun (i, j, k) ->
          for p = 1 to l - 1 do
            if t.(p).(d).(j) && t.(l - p).(d + p).(k)
            then t.(l).(d).(i) <- true
          done
        ) g.regles2
      done
    done;
    t.(n).(0).(0)
  end

type arbre = Vide | Un of int * char | Deux of int * arbre * arbre

let arbre_derivation g u : arbre option =
  let n = String.length u in
  if n = 0 then (if g.epsilon then Some Vide else None)
  else begin
    let k = g.n_variables in
    let t = Array.init (n + 1) (fun _ -> Array.make_matrix n k None) in
    List.iter (fun (i, a) ->
      for d = 0 to n - 1 do
        if u.[d] = a then t.(1).(d).(i) <- Some (Un (i, a))
      done
    ) g.regles1;
    for l = 2 to n do
      for d = 0 to n - l do
        List.iter (fun (i, j, k) ->
          for p = 1 to l - 1 do
            match t.(p).(d).(j), t.(l - p).(d + p).(k) with
            | Some a1, Some a2 -> t.(l).(d).(i) <- Some (Deux (i, a1, a2))
            | _ -> ()
          done
        ) g.regles2
      done
    done;
    t.(n).(0).(0)
  end

let exemples = [
  cyk g0 "aab";
  cyk g0 "aabb";
  cyk g0 "abaa";
  cyk g0 "aababa"
]

module Tests = struct
  let () =
    List.iter (fun epsilon ->
      let g = { g0 with epsilon } in
      assert (cyk g "" = epsilon);
      assert (arbre_derivation g "" = (if epsilon then Some Vide else None));
      assert (cyk g "b");
      assert (not (cyk g "aaa"))
    ) [false; true]

  let () =
    assert (exemples = [true; false; true; false]);
    assert (cyk g0 "b");
    assert (not (cyk g0 "aaa"));
    let t = init g0 "aba" in
    assert (t.(1).(0) = [|false; true; false; false; true|]);
    assert (t.(1).(1) = [|true; false; true; false; false|]);
    assert (t.(1).(2) = t.(1).(0));
    t.(2).(0).(0) <- true;
    assert (not t.(1).(0).(0));
    assert (not t.(2).(1).(0));
    assert (arbre_derivation g0 "aabb" = None)

  let racine = function
    | Vide -> 0
    | Un (i, _) | Deux (i, _, _) -> i

  let rec verifier g = function
    | Vide -> assert g.epsilon; ""
    | Un (i, a) ->
      assert (List.mem (i, a) g.regles1);
      String.make 1 a
    | Deux (i, gauche, droite) ->
      assert (List.mem (i, racine gauche, racine droite) g.regles2);
      verifier g gauche ^ verifier g droite

  let () =
    List.iter (fun u ->
      match arbre_derivation g0 u with
      | None -> assert false
      | Some arbre ->
        assert (racine arbre = 0);
        assert (verifier g0 arbre = u)
    ) ["b"; "aab"; "abaa"]
end
