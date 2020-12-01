(*Dawid Żywczak, Zadanie 1, lista 3*)
let length = fun xs -> List.fold_right (fun x y -> y + 1) xs 0;;
let rev = fun xs -> List.fold_left (fun x y -> y::x) [] xs;;
let map = fun f xs -> List.fold_right (fun x y -> (f x)::y) xs [];;
let append = fun xs ys -> List.fold_right (fun x y -> x::y) xs ys;;
let rev_append = fun xs ys -> List.fold_left (fun x y -> y::x) ys xs;;
let filter = fun f xs -> List.fold_right (fun x y -> if (f x) then x::y else y) xs [];;
let rev_map = fun f xs -> List.fold_left (fun x y -> (f y)::x) [] xs;;