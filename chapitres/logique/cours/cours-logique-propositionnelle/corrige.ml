type formule =
  | Top | Bot | Var of int
  | Non of formule
  | Et of formule * formule
  | Ou of formule * formule

let rec eval v = function
  | Top -> true | Bot -> false
  | Var x -> v x
  | Non p -> not (eval v p)
  | Et (p, q) -> eval v p && eval v q
  | Ou (p, q) -> eval v p || eval v q

let rec fnn = function
  | Non Top -> Bot
  | Non Bot -> Top
  | Non (Non p) -> fnn p
  | Non (Et (p, q)) -> Ou (fnn (Non p), fnn (Non q))
  | Non (Ou (p, q)) -> Et (fnn (Non p), fnn (Non q))
  | Et (p, q) -> Et (fnn p, fnn q)
  | Ou (p, q) -> Ou (fnn p, fnn q)
  | p -> p

let rec distribuer p q =
  match p, q with
  | Top, _ | _, Top -> Top
  | Bot, q -> q
  | p, Bot -> p
  | Et (a, b), q -> Et (distribuer a q, distribuer b q)
  | p, Et (a, b) -> Et (distribuer p a, distribuer p b)
  | p, q -> Ou (p, q)

let fnc p =
  let rec convertir = function
    | Et (p, q) -> Et (convertir p, convertir q)
    | Ou (p, q) -> distribuer (convertir p) (convertir q)
    | p -> p
  in
  convertir (fnn p)

let fnd p = fnn (Non (fnc (Non p)))

module Tests = struct
  let rec est_fnn = function
    | Top | Bot | Var _ | Non (Var _) -> true
    | Et (p, q) | Ou (p, q) -> est_fnn p && est_fnn q
    | _ -> false

  let rec clause = function
    | Bot | Var _ | Non (Var _) -> true
    | Ou (p, q) -> clause p && clause q
    | _ -> false

  let rec est_fnc = function
    | Top -> true
    | Et (p, q) -> est_fnc p && est_fnc q
    | p -> clause p

  let rec terme = function
    | Top | Var _ | Non (Var _) -> true
    | Et (p, q) -> terme p && terme q
    | _ -> false

  let rec est_fnd = function
    | Bot -> true
    | Ou (p, q) -> est_fnd p && est_fnd q
    | p -> terme p

  let () =
    let x = Var 0 and y = Var 1 in
    let formules = [Top; Bot; x; Non Top; Non Bot; Non (Non x);
      Non (Ou (x, Non y)); Non (Et (x, y));
      Et (Ou (x, y), Ou (Non x, Non y));
      Ou (Et (x, y), Et (Non x, Non y));
      Ou (Top, x); Ou (x, Top); Ou (Bot, x); Ou (x, Bot);
      Non (Ou (Et (x, Top), Et (y, Bot)))] in
    List.iter (fun p ->
      let n = fnn p and c = fnc p and d = fnd p in
      assert (est_fnn n && est_fnc c && est_fnd d);
      for masque = 0 to 3 do
        let v i = masque land (1 lsl i) <> 0 in
        assert (eval v p = eval v n);
        assert (eval v p = eval v c);
        assert (eval v p = eval v d)
      done
    ) formules
end
