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

let rec fnn negatif = function
  | Top -> if negatif then Bot else Top
  | Bot -> if negatif then Top else Bot
  | Var x -> if negatif then Non (Var x) else Var x
  | Non p -> fnn (not negatif) p
  | Et (p, q) ->
    if negatif then Ou (fnn true p, fnn true q)
    else Et (fnn false p, fnn false q)
  | Ou (p, q) ->
    if negatif then Et (fnn true p, fnn true q)
    else Ou (fnn false p, fnn false q)

let rec distribuer p q =
  match p, q with
  | Bot, _ | _, Bot -> Bot
  | Top, q -> q
  | p, Top -> p
  | Ou (a, b), q -> Ou (distribuer a q, distribuer b q)
  | p, Ou (a, b) -> Ou (distribuer p a, distribuer p b)
  | p, q -> Et (p, q)

let fnd p =
  let rec convertir = function
    | Ou (p, q) -> Ou (convertir p, convertir q)
    | Et (p, q) -> distribuer (convertir p) (convertir q)
    | p -> p
  in
  convertir (fnn false p)

module Tests = struct
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
      Et (Ou (x, y), Ou (Non x, Non y)); Et (Bot, x);
      Et (Top, x); Et (x, Top); Et (x, Bot)] in
    List.iter (fun p ->
      let q = fnd p in
      assert (est_fnd q);
      for masque = 0 to 3 do
        let v i = masque land (1 lsl i) <> 0 in
        assert (eval v p = eval v q);
        assert (eval v (fnn true p) = not (eval v p))
      done
    ) formules
end
