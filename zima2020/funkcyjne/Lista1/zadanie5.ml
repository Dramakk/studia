(*Zadanie 5 z listy 1, Dawid Żywczak*)

let zero (f: 'a -> 'a)(x: 'a) = x;;

let succ (n: ('a -> 'a) -> 'a -> 'a)(g: 'a -> 'a)(x: 'a) = g (n g x);;

let add (m: ('a -> 'a) -> 'a -> 'a)(n: ('a -> 'a) -> 'a -> 'a)(f: 'a -> 'a)(x: 'a) = m f (n f x);;

let mul (m: ('a -> 'a) -> 'a -> 'a)(n: ('a -> 'a) -> 'a -> 'a)(f: 'a -> 'a)(x: 'a) = m (n f) x;;

let is_zero (n: ('a -> 'a) -> 'a -> 'a) (x: 'a) (y: 'a) = n (fun x -> y) x;;

let rec cnum_of_int (n: int) = 
  if n = 0 then zero else succ (cnum_of_int (n-1));;

let int_of_cnum (n: (int -> int) -> int -> int) =
  n (fun x -> x + 1) 0;;
