type formule =
  | T | F | Var of int
  | Non of formule
  | Et of formule * formule
  | Ou of formule * formule

let rec eval v = function
  | T -> true
  | F -> false
  | Var x -> v x
  | Non p -> not (eval v p)
  | Et (p, q) -> eval v p && eval v q
  | Ou (p, q) -> eval v p || eval v q
