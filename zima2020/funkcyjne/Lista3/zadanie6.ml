(*Dawid Żywczak, Zadanie 6, lista 3*)
let rec fold_left_cps f x xs k = 
  let rec aux ff x xs k =
    match xs with
        | [] -> k x
        | [elem] -> ff x elem k
        | hd::tl -> aux (fun a b k -> ff a hd (fun a -> f a b k)) x tl k
  in aux f x xs k;;

let fold_left f a l =
  let cf a b c = c (f a b) in
    fold_left_cps cf a l (fun x -> x)