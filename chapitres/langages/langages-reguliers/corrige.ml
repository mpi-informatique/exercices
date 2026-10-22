let sous_mot u v =
  let n = String.length u and p = String.length v in
  let rec parcourir i j =
    if i = n then true
    else if j = p then false
    else if u.[i] = v.[j] then parcourir (i + 1) (j + 1)
    else parcourir i (j + 1)
  in
  parcourir 0 0

type 'a regexp =
  | Vide | Epsilon | L of 'a
  | Union of 'a regexp * 'a regexp
  | Concat of 'a regexp * 'a regexp
  | Etoile of 'a regexp

let rec epsilon = function
  | Vide | L _ -> false
  | Epsilon | Etoile _ -> true
  | Union (e, f) -> epsilon e || epsilon f
  | Concat (e, f) -> epsilon e && epsilon f

let rec vide = function
  | Vide -> true
  | Epsilon | L _ | Etoile _ -> false
  | Union (e, f) -> vide e && vide f
  | Concat (e, f) -> vide e || vide f

let rec miroir = function
  | Vide -> Vide
  | Epsilon -> Epsilon
  | L a -> L a
  | Union (e, f) -> Union (miroir e, miroir f)
  | Concat (e, f) -> Concat (miroir f, miroir e)
  | Etoile e -> Etoile (miroir e)

module Tests = struct
  let () =
    List.iter (fun (u, v, attendu) -> assert (sous_mot u v = attendu)) [
      ("", "", true); ("", "abc", true); ("a", "", false);
      ("abc", "aabacb", true); ("aa", "a", false); ("ba", "ab", false)
    ];
    List.iter (fun (e, contient, est_vide) ->
      assert (epsilon e = contient);
      assert (vide e = est_vide)
    ) [
      (Vide, false, true); (Epsilon, true, false); (L 'a', false, false);
      (Etoile Vide, true, false); (Union (Vide, Epsilon), true, false);
      (Concat (L 'a', Vide), false, true);
      (Concat (Epsilon, Etoile (L 'a')), true, false);
      (Union (Vide, Vide), false, true)
    ];
    let e = Concat (L 'a', Union (Epsilon, Etoile (L 'b'))) in
    assert (miroir e = Concat (Union (Epsilon, Etoile (L 'b')), L 'a'));
    assert (miroir (miroir e) = e);
    assert (miroir Vide = Vide)
end
