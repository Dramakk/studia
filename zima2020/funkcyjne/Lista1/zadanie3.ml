(*Zadanie 3 z listy 1, Dawid Żywczak*)
let s (a: int) = a;;

let hd (s: int -> 't) = s 0;;
let tl (s: int -> 't) = fun a -> s (a+1);;

let add (s: int -> 't)(a: 't) = fun b -> (s b)+a;;

let map (s: int -> 't)(f: 't -> 'a) = fun a -> f (s a);;

let map2 (s1: int -> 't)(s2: int -> 't)(f: 't -> 't -> 'a) = fun a -> f (s1 a)(s2 a);;

let replace (s: int -> 't)(n: int)(a: 't) = fun b -> if (b + 1) mod n = 0 then a else s b;;

let take (s: int -> 't)(n: int) = fun a -> s (a*n);;

let rec scan (s: int -> 'b)(f: 'a -> 'b -> 'a)(a: 'a) = fun b -> if b = 0 then f a (s 0) else f (scan s f a (x-1)) (s x);;

let rec tabulate ?(st = 0) e s = if st = e then [s st] else (s st) :: (tabulate ~st:(st+1) e s);;

let z (a: 't)(b: 't) = a + b;;
let x = tabulate 2 s in x;;