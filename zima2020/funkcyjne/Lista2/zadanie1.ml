(*Dawid Żywczak, Zadanie 1, lista 2*)
let rec append (l1: 'a list list) (l2: 'a list list) (elem: 'a) =
  match l1 with
    | [] -> l2
    | hd::tl -> (append tl ((elem::hd)::l2) elem);;

let rec sublists (list: 'a list) =
  match list with
    | [] -> [[]]
    | hd::tl -> (let ls = (sublists tl) in (append ls ls hd));;