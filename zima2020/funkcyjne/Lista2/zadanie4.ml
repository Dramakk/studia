(*Dawid Żywczak, Zadanie 4, lista 2*)
let rec insert x list =
  match list with
  | [] -> [[x]]
  | h::t -> 
    (x::list)::(List.map (fun el -> h::el) (insert x t));;

let rec permutations list =
  match list with
  | [] -> [list]
  | h::t -> 
    List.flatten (List.map (insert h) (permutations t));;
