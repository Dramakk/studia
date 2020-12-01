(*Dawid Żywczak, Zadanie 4, lista 3*)
let rec polynomial_rec xs x =
  match xs with
  | [] -> 0.
  | head::tail -> x *. (polynomial_rec tail x) +. head;;

let polynomial xs x = List.fold_right (fun a b -> x*.b +. a) xs 0.;;

let polynomial_tail xs x = 
  let rec aux xs x exp acc =
    match xs with
    | [] -> acc
    | head::tail -> aux tail x (exp*.x) (acc +. head*.exp)
  in aux xs x 1. 0.;;

let polynomial_fold xs x =
  fst (List.fold_left (fun (acc, exp) elem -> (acc +. exp *. elem, exp *. x)) (0., 1.) xs);;
