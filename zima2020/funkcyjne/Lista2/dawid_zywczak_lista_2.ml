(*Zadanie 1, lista 2*)
let rec append (l1: 'a list list) (l2: 'a list list) (elem: 'a) =
  match l1 with
    | [] -> l2
    | hd::tl -> (append tl ((elem::hd)::l2) elem);;

let rec sublists (list: 'a list) =
  match list with
    | [] -> [[]]
    | hd::tl -> (let ls = (sublists tl) in (append ls ls hd));;

(*Zadanie 2, lista 2*)
let cycle lst n = 
  let rec iter head tail = 
      if n = List.length tail
      then tail @ head
      else iter (head @ [List.hd tail]) (List.tl tail)
      in
  iter [] lst;;

(*Zadanie 3, lista 2*)
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
          List.rev (merge_tail (<) (mergesort h1) (mergesort h2));; 

(*Zadanie 4, lista 2*)
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

(*Zadanie 5, lista 2*)
let sufixes xs = 
  let rec iter xs acc = 
    match xs with
      | [] -> acc @ [[]]
      | head::tail -> iter tail (acc @ [xs]) in
  iter xs [];;

  let rec prefixes xs =
    match xs with 
      | [] -> [[]]
      | hd::tl -> []::List.map (fun li -> hd::li) (prefixes tl);; 
(*Zadanie 6, lista 2*)
type 'a clist = { clist : 'z. ('a -> 'z -> 'z) -> 'z -> 'z }
let cnil = { clist = (fun f elem -> elem) };;
let ccons c cl = {clist = fun f z -> f c (cl.clist f z) };; 
let cmap (g: 'a -> 'b) cl = {clist = fun f elem -> cl.clist (fun x -> f (g x)) elem};;
let cappend xs ys = {
    clist = fun g elem -> xs.clist g (ys.clist g elem)
};;
let clist_to_list cl = cl.clist (fun x y -> x::y) [];;
let rec clist_of_list xs =
  match xs with
  | [] -> cnil
  | head::tail -> ccons head (clist_of_list tail);;
let prod xs ys = {clist = fun f x -> xs.clist (fun a -> ys.clist (fun b -> f (a,b))) x};;