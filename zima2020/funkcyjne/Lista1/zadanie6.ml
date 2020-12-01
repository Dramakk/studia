(*Zadanie 6 z listy 1, Dawid Żywczak*)

type cbool = { cbool : 'a. 'a -> 'a -> 'a }
type cnum = { cnum : 'a. ('a -> 'a) -> 'a -> 'a }

let ctrue = {cbool = fun a b -> a};;
let cfalse = {cbool = fun a b -> b};;

let cand (a:cbool)(b:cbool) = {cbool = fun c d -> a.cbool (b.cbool c d) d};;
let cor (a: cbool)(b: cbool) = {cbool = fun c d -> a.cbool c (b.cbool c d)};;

let cbool_of_bool (a: bool) = if a then ctrue else cfalse;;

let bool_of_cbool (a: cbool) = a.cbool true false;;

(*/////////////////////////////////////////*)
let zero = {cnum = fun f x -> x};;

let succ (n: cnum) = {cnum = fun g x -> g (n.cnum g x)};;

let add (m: cnum)(n: cnum) = {cnum = fun f x -> m.cnum f (n.cnum f x)};;

let mul (m: cnum)(n: cnum) = {cnum = fun f x -> m.cnum (n.cnum f) x};;

let is_zero (n: cnum) = {cbool = fun x y -> n.cnum (fun x -> y) x};;

let rec cnum_of_int (n: int) = 
  if n = 0 then zero else succ (cnum_of_int (n-1));;

let int_of_cnum (n: cnum) =
  n.cnum (fun x -> x + 1) 0;;
