#use "corrige.ml";;

let verifier nom obtenu attendu =
  if obtenu <> attendu then
    failwith nom

let () =
  verifier "boucle" (forme [|0|]) (0, 1);
  verifier "chemin puis cycle" (forme [|1; 2; 3; 1|]) (1, 3);
  verifier "états inaccessibles" (forme [|1; 0; 3; 2|]) (0, 2);
  verifier "longue queue" (forme [|1; 2; 3; 4; 4|]) (4, 1);
  print_endline "Devoir langages unaires : algorithme de Floyd vérifié."
