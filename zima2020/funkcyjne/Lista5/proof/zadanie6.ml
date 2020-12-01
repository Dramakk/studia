#install_printer Proof.pp_print_proof;;
#install_printer Proof.pp_print_goal;;
#install_printer Logic.pp_print_formula;;
#install_printer Logic.pp_print_theorem;;
open Proof;;
open Logic;;
let p = Var "p";;
let pqr = Implication (p, Implication (Var "q", Var "r"));;
let pq = Implication (p, Var "q");;
let pr = Implication (p, Var "r");;
let proof1 = proof [] (Implication (pqr, Implication (pq, pr)));;
let proofOfProof1 = focus 0 proof1 |> intro "P1" |> intro "P2" |> intro "P3" |> 
apply_assm "P1" |> focus 0 |> apply_assm "P3" |> focus 0 |> apply_assm "P2" |> focus 0 |> apply_assm "P3" |> qed;;

let proof2 = proof [] (Implication(Implication(Implication(Implication(p, False),p),p), Implication(Implication(Implication(p, False),False),p)));;
let proofOfProof2 = proof2 |> focus 0 |> intro "P1" |> intro "P2" |> apply_assm "P1" |> focus 0 
|> intro "P3" |> apply_assm "P2" |> focus 0 |> apply_assm "P3" |> qed;;

let proof3 = proof [] (Implication(Implication(Implication(Implication(p, False), False),p), Implication(Implication(Implication(p, False),p),p)));;
let proofOfProof3 = proof3 |> focus 0 |> intro "P1" |> intro "P2" |> apply_assm "P1" |> focus 0 |> intro "P3" |> apply_assm "P3" 
|> focus 0 |> apply_assm "P2" |> focus 0 |> apply_assm "P3" |> qed;;


