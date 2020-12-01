(*Dawid Żywczak, Zadanie 2, lista 4*)

type 'a place = 'a list * 'a list;;

let findNth list place : 'a place =
  let rec aux list prefix counter = 
    match list with
    | [] -> (prefix, [])
    | head::tail -> if counter = place - 1 then (head::prefix, tail) else aux tail (head::prefix) (counter + 1)
  in aux list [] 0;;  


let rec collapse (list: 'a place) =
  match list with
  | ([], wynik) -> wynik
  | (head::tail, wynik) -> collapse (tail, head::wynik);;

let add elem (list: 'a place) : 'a place = 
  match list with
  | (left, right) -> (left, elem::right);;

let del (list: 'a place) : 'a place =
  match list with
  | ([], head::tail) -> ([], tail)
  | (left, []) -> list
  | (left, head::tail) -> (left, tail);;

let next (list: 'a place) : 'a place =
  match list with
  | ([], head::tail) -> ([head], tail)
  | (left, []) -> list
  | (left, headR::tailR) -> (headR::left, tailR);;

  let prev (list: 'a place) : 'a place =
    match list with
    | ([], right) -> ([], right)
    | (head::tail, []) -> (tail, [head])
    | (headL::tailL, right) -> (tailL, headL::right);;