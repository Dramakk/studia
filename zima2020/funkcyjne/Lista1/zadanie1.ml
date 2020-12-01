(*Zadanie 1 z listy 1, Dawid Żywczak*)
(*Typem fun x->x jest 'a -> 'a*)
(*0*)
let func0 (a: int) = a;;
(*1*)
let funca (a: 'a -> 'b)(b: 'c -> 'a)(c: 'c) = a (b c);;
(*2*)
let funcb (a: 'a)(b: 'b) = a;;
(*3*)
let funcc (a: 'a)(b: 'a) = a;;
(*4*)
let rec f x = f x in f ();;