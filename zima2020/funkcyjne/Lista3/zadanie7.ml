(*Dawid Żywczak, Zadanie 7, lista 3*)
let rec fold_left_cps f x xs k = 
  let rec aux ff x xs k =
    match xs with
        | [] -> k x
        | [elem] -> ff x elem k
        | hd::tl -> aux (fun a b k -> ff a hd (fun a -> f a b k)) x tl k
  in aux f x xs k;;

let for_all_cps f xs = fold_left_cps (fun a x k -> if not (f x) then false else k a) true xs (fun x -> x);;
let mult_list_cps xs = fold_left_cps (fun a x k -> if x = 0 then 0 else k (a * x)) 1 xs (fun x -> x);;
let sorted_cps xs =
  match xs with
  | [] -> true
  | head::tail -> fold_left_cps (fun a elem k -> if elem >= a then k elem else false) head tail (fun _ -> true);;