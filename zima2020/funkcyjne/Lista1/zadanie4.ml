(*Zadanie 4 z listy 1, Dawid Żywczak*)
let ctrue (a: 'a)(b: 'a) = a;;
let cfalse (a: 'a)(b: 'a) = b;;

let cand (a: 'a -> 'a -> 'a)(b: 'a -> 'a -> 'a)(c: 'a) (d: 'a) = a (b c d) d;;
let cor (a: 'a -> 'a -> 'a)(b: 'a -> 'a -> 'a)(c: 'a) (d: 'a) = a c (b c d);;

let cbool_of_bool (a: bool) = if a then ctrue else cfalse;;

let bool_of_cbool (a: bool -> bool -> bool) = a true false;;


