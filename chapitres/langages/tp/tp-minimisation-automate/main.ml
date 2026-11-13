(* Dans utop, depuis le dossier du TP :
   #require "mpi-informatique";;
   #use "main.ml";;
   La fonction dessiner nécessite aussi la commande dot de Graphviz. *)

type adc = {
  initial : int;
  finaux : int list;
  delta : int array array;
}

let nb_etats a = Array.length a.delta

let nb_lettres a = Array.length a.delta.(0)

let delta_etoile a q mot =
  List.fold_left (fun etat lettre -> a.delta.(etat).(lettre)) q mot

let accepte a mot =
  List.mem (delta_etoile a a.initial mot) a.finaux

(* Les colonnes correspondent aux lettres a = 0 et b = 1. *)
let exemple = {
  initial = 0;
  finaux = [5];
  delta = [|
    [|1; 2|];
    [|3; 4|];
    [|4; 5|];
    [|4; 5|];
    [|5; 4|];
    [|5; 5|];
  |];
}

(* Exporter un dessin SVG à l'aide de la bibliothèque MPI et de Graphviz.
   Par exemple : dessiner "exemple" exemple crée exemple.svg. *)
let dessiner nom a =
  let transitions = ref [] in
  Array.iteri (fun q ligne ->
    Array.iteri (fun lettre destination ->
      transitions := (q, Some lettre, destination) :: !transitions) ligne) a.delta;
  let automate = Mpi.Automate.creer
    ~nb_etats:(nb_etats a) ~initiaux:[a.initial] ~finaux:a.finaux
    ~transitions:(List.rev !transitions)
  in
  let symbole x = if x = 0 then "a" else if x = 1 then "b" else string_of_int x in
  let fichier_dot = nom ^ ".dot" in
  let fichier_svg = nom ^ ".svg" in
  Mpi.Dot.ecrire fichier_dot (Mpi.Dot.automate ~symbole automate);
  let commande = Printf.sprintf "dot -Tsvg %s -o %s"
    (Filename.quote fichier_dot) (Filename.quote fichier_svg)
  in
  if Sys.command commande <> 0 then
    failwith "Impossible de dessiner l'automate : vérifier l'installation de Graphviz.";
  let chemin = if Filename.is_relative fichier_svg then Filename.concat (Sys.getcwd ()) fichier_svg else fichier_svg in
  Printf.printf "Image créée : %s\n%!" chemin

let classes_initiales _a =
  failwith "À compléter"

let signature _a _classes _q =
  failwith "À compléter"

let raffine _a _classes =
  failwith "À compléter"

let classes_equivalence _a =
  failwith "À compléter"

let quotient _a _classes =
  failwith "À compléter"

let rec mots_de_taille alphabet n =
  if n = 0 then [[]]
  else
    List.concat_map
      (fun mot -> List.init alphabet (fun lettre -> lettre :: mot))
      (mots_de_taille alphabet (n - 1))

let mots_jusqua alphabet n =
  List.concat_map (mots_de_taille alphabet) (List.init (n + 1) Fun.id)

let equivalent_jusqua a b n =
  List.for_all
    (fun mot -> accepte a mot = accepte b mot)
    (mots_jusqua (nb_lettres a) n)

let minimiser _a =
  failwith "À compléter"

(* Exemples à exécuter après avoir complété les fonctions correspondantes.
dessiner "exemple" exemple;;
let c0 = classes_initiales exemple;;
assert (c0 = [|0; 0; 0; 0; 0; 1|]);;
assert (signature exemple c0 0 = [0; 0; 0]);;
let c1 = raffine exemple c0;;
assert (c1 = [|0; 0; 1; 1; 2; 3|]);;
let c = classes_equivalence exemple;;
assert (raffine exemple c = c);;
let minimal = minimiser exemple;;
assert (nb_etats minimal = 5);;
dessiner "minimal" minimal;;
assert (equivalent_jusqua exemple minimal 12);;
*)
