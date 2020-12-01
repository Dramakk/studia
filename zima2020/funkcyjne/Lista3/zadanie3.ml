(*Dawid Żywczak, Zadanie 3, lista 3*)
let polynomial xs x = List.fold_left (fun a b -> x*.a +. b) 0. xs;;
let polynomial_rec xs x =
  let rec aux xs x acc =
    match xs with
    | [] -> acc
    | head::tail -> aux tail x ((x*.acc) +. head)
  in aux xs x 0.;;