(* BEGIN forme *)
let forme delta =
  let tortue = ref delta.(0) in
  let lievre = ref delta.(delta.(0)) in
  while !tortue <> !lievre do
    tortue := delta.(!tortue);
    lievre := delta.(delta.(!lievre))
  done;
  tortue := 0;
  let mu = ref 0 in
  while !tortue <> !lievre do
    tortue := delta.(!tortue);
    lievre := delta.(!lievre);
    incr mu
  done;
  let lambda = ref 1 in
  lievre := delta.(!tortue);
  while !tortue <> !lievre do
    lievre := delta.(!lievre);
    incr lambda
  done;
  (!mu, !lambda)
(* END forme *)
