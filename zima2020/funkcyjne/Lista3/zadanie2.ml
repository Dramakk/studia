(*Dawid Żywczak, Zadanie 2, lista 3*)
let list_to_int = fun xs -> 
  match xs with
  | [] -> 0
  | xs -> List.fold_left (fun x y -> (x * 10) + y) 0 xs;;

let list_to_int_rec xs = 
  let rec aux xs acc =
    match xs with
    | [] -> acc
    | head::tail -> aux tail ((acc * 10) + head)
  in aux xs 0;;