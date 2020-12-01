(*Dawid Żywczak, Zadanie 3, lista 2*)
(*1*)
let rec merge cmp xs ys = 
  match (xs,ys) with
  | ([],_) -> ys
  | (_,[]) -> xs
  | (hdx::ltx, hdy::lty) ->
    if cmp hdx hdy then hdx::(merge cmp ltx ys) else hdy::(merge cmp xs lty);;
(*2*)
let marge_tail_rev cmp l1 l2 = 
  let rec aux xs ys acc =
     match xs,ys with
      | [],[] -> acc
      | [], hd::tl | hd::tl, [] -> aux [] tl (hd::acc)
      | hdx::ltx, hdy::lty ->
      if cmp hdx hdy then aux ltx ys (hdx::acc) else aux xs lty (hdy::acc)
    in List.rev (aux l1 l2 []);;
(*3*)
let halve list =
  let rec aux acc list counter = 
      match counter with
      | [] | [_] -> (List.rev acc), list 
      | hd::tail -> aux (List.hd list::acc) (List.tl list) (List.tl tail)   
  in aux [] list list;;
(*4*)
let rec mergesort list = 
  match list with
  | [] -> []
  | hd::[] -> list
  | _ -> let (h1, h2) = halve list in
          merge (<=) (mergesort h1) (mergesort h2);; 
(*5*)
let merge_tail cmp l1 l2 = 
  let rec aux xs ys acc =
     match xs,ys with
      | [],[] -> acc
      | [], hd::tl | hd::tl, [] -> aux [] tl (hd::acc)
      | hdx::ltx, hdy::lty ->
      if cmp hdx hdy then aux ltx ys (hdx::acc) else aux xs lty (hdy::acc)
    in aux l1 l2 [];;

let rec mergesort_v2 list = 
  match list with
  | [] -> []
  | hd::[] -> list
  | _ -> let (h1, h2) = halve list in
          List.rev (merge_tail (<=) (mergesort h1) (mergesort h2));; 
