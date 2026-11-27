#use "./chapitres/logique/cours/cours-logique-propositionnelle/cours-logique-propositionnelle-cor.ml";;

type decision =
  | F of bool
  | N of int * decision * decision

let rec non = function
  | F b -> F (not b)
  | N (i, g, d) -> N (i, non g, non d)

let rec et a b =
  match a, b with
  | F false, _ | _, F false -> F false
  | F true, t | t, F true -> t
  | N (i, g1, d1), N (j, g2, d2) ->
    if i = j then N (i, et g1 g2, et d1 d2)
    else if i < j then N (i, et g1 b, et d1 b)
    else N (j, et a g2, et a d2)

let ou a b = non (et (non a) (non b))

let rec formule_vers_decision = function
  | Top -> F true
  | Bot -> F false
  | Var i -> N (i, F false, F true)
  | Non p -> non (formule_vers_decision p)
  | Et (p, q) -> et (formule_vers_decision p) (formule_vers_decision q)
  | Ou (p, q) -> ou (formule_vers_decision p) (formule_vers_decision q)

let rec decision_vers_formule = function
  | F true -> Top
  | F false -> Bot
  | N (i, g, d) ->
    Ou (Et (Non (Var i), decision_vers_formule g),
        Et (Var i, decision_vers_formule d))

let compter n arbre =
  (* p est le premier indice qui n'a pas encore reçu de valeur ; 1 lsl k vaut 2^k. *)
  let rec aux p = function
    | F false -> 0
    | F true -> 1 lsl (n - p)
    | N (i, g, d) ->
      (1 lsl (i - p)) * (aux (i + 1) g + aux (i + 1) d)
  in
  aux 0 arbre

module Tests = struct
  let valuations n =
    List.init (1 lsl n) (fun masque x -> masque land (1 lsl x) <> 0)

  let equivalent n p q =
    List.for_all (fun v -> eval v p = eval v q) (valuations n)

  let rec eval_decision v = function
    | F b -> b
    | N (i, g, d) -> eval_decision v (if v i then d else g)

  let rec ordonne prochain = function
    | F _ -> true
    | N (i, g, d) ->
      prochain <= i && ordonne (i + 1) g && ordonne (i + 1) d

  let x = Var 0
  let y = Var 1
  let z = Var 2
  let exemple = Ou (Et (x, Non y), Non (Ou (y, z)))
  let exemples = [
    Top; Bot; x; Non x; Et (x, Non x); Ou (x, Non x);
    Et (Ou (Non x, y), Et (x, Non y));
    exemple;
    Non (Et (Ou (x, y), Non z));
    Et (Ou (x, y), Ou (Non x, z))
  ]

  let () =
    List.iter (fun p ->
      let a = formule_vers_decision p in
      assert (ordonne 0 a);
      List.iter (fun v -> assert (eval_decision v a = eval v p)) (valuations 3)
    ) exemples;
    let arbres = [
      F true;
      F false;
      N (2, F false, F true);
      N (0, F true,
        N (1, N (2, F false, F true), F true));
      N (0, F false, F true);
      N (1, F true, F false);
      N (0, N (2, F false, F true), F false);
      N (1, N (2, F true, F false),
        N (3, F false, F true))
    ] in
    List.iter (fun arbre ->
      let p = decision_vers_formule arbre in
      let attendu = List.length (List.filter (fun v -> eval_decision v arbre) (valuations 4)) in
      assert (compter 4 arbre = attendu);
      let negatif = non arbre in
      assert (ordonne 0 negatif);
      List.iter (fun v ->
        assert (eval v p = eval_decision v arbre);
        assert (eval_decision v negatif = not (eval_decision v arbre))
      ) (valuations 4);
      List.iter (fun autre ->
        let conjonction = et arbre autre in
        let disjonction = ou arbre autre in
        assert (ordonne 0 conjonction);
        assert (ordonne 0 disjonction);
        List.iter (fun v ->
          assert (eval_decision v conjonction = (eval_decision v arbre && eval_decision v autre));
          assert (eval_decision v disjonction = (eval_decision v arbre || eval_decision v autre))
        ) (valuations 4)
      ) arbres
    ) arbres;
    assert (compter 0 (F true) = 1);
    assert (compter 0 (F false) = 0);
    let a = List.nth arbres 3 in
    assert (compter 3 a = 7);
    assert (equivalent 3 (decision_vers_formule a) (Ou (Non x, Ou (y, z))))
end
