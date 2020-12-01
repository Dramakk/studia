(*Dawid Żywczak, Zadanie 2, lista 4*)

open Logic;;

let p = Var "p";;
let q = Var "q";;
let r = Var "r";;

let t1 = imp_i p (by_assumption p);;
let t2 = imp_i p (imp_i q (by_assumption p));;

let tmp1 = Implication(p, Implication(q, r));;
let tmp2 = Implication(p, q);;
let tmp3 = imp_e (by_assumption tmp2) (by_assumption p);;
let tmp4 = imp_e (by_assumption tmp1) (by_assumption p);;
let tmp5 = imp_e tmp4 tmp3;;
let t3 = imp_i tmp1 (imp_i tmp2 (imp_i p tmp5));;

let t4 = imp_i False (bot_e p (by_assumption False));;