#use "./chapitres/logique/cours/cours-logique-propositionnelle/cours-logique-propositionnelle-cor.ml";;

type decision =
  | Feuille of bool
  | Noeud of int * decision * decision

let rec non = function
  | Feuille b -> Feuille (not b)
  | Noeud (i, g, d) -> Noeud (i, non g, non d)

let rec et a b =
  match a, b with
  | Feuille false, _ | _, Feuille false -> Feuille false
  | Feuille true, t | t, Feuille true -> t
  | Noeud (i, g1, d1), Noeud (j, g2, d2) ->
    if i = j then Noeud (i, et g1 g2, et d1 d2)
    else if i < j then Noeud (i, et g1 b, et d1 b)
    else Noeud (j, et a g2, et a d2)

let ou a b = non (et (non a) (non b))

let rec formule_vers_decision = function
  | Top -> Feuille true
  | Bot -> Feuille false
  | Var i -> Noeud (i, Feuille false, Feuille true)
  | Non p -> non (formule_vers_decision p)
  | Et (p, q) -> et (formule_vers_decision p) (formule_vers_decision q)
  | Ou (p, q) -> ou (formule_vers_decision p) (formule_vers_decision q)

let rec decision_vers_formule = function
  | Feuille true -> Top
  | Feuille false -> Bot
  | Noeud (i, g, d) ->
    Ou (Et (Non (Var i), decision_vers_formule g),
        Et (Var i, decision_vers_formule d))

let compter n arbre =
  (* prochain est le premier indice qui n'a pas encore reçu de valeur. *)
  let rec aux prochain = function
    | Feuille false -> 0
    | Feuille true -> 1 lsl (n - prochain)
    | Noeud (i, g, d) ->
      (1 lsl (i - prochain)) * (aux (i + 1) g + aux (i + 1) d)
  in
  aux 0 arbre

module Tests = struct
  let valuations n =
    List.init (1 lsl n) (fun masque x -> masque land (1 lsl x) <> 0)

  let equivalent n p q =
    List.for_all (fun v -> eval v p = eval v q) (valuations n)

  let rec eval_decision v = function
    | Feuille b -> b
    | Noeud (i, g, d) -> eval_decision v (if v i then d else g)

  let rec ordonne prochain = function
    | Feuille _ -> true
    | Noeud (i, g, d) ->
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
      Feuille true;
      Feuille false;
      Noeud (2, Feuille false, Feuille true);
      Noeud (0, Feuille true,
        Noeud (1, Noeud (2, Feuille false, Feuille true), Feuille true));
      Noeud (0, Feuille false, Feuille true);
      Noeud (1, Feuille true, Feuille false);
      Noeud (0, Noeud (2, Feuille false, Feuille true), Feuille false);
      Noeud (1, Noeud (2, Feuille true, Feuille false),
        Noeud (3, Feuille false, Feuille true))
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
    assert (compter 0 (Feuille true) = 1);
    assert (compter 0 (Feuille false) = 0);
    let a = List.nth arbres 3 in
    assert (compter 3 a = 7);
    assert (equivalent 3 (decision_vers_formule a) (Ou (Non x, Ou (y, z))))
end
