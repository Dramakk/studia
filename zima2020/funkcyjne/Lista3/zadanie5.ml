(*Dawid Żywczak, Zadanie 5, lista 3*)
exception My_exception

let for_all pred xs = 
  try 
    List.fold_left (fun acc elem -> if not (pred elem) then (raise (My_exception)) else true) true xs
  with My_exception -> false;;

let mult_list xs =
  try
    List.fold_left (fun acc elem -> if elem = 0 then (raise (My_exception)) else acc*elem) 1 xs
  with My_exception -> 0;;

let sorted xs =
  match xs with
  | [] -> true
  | head::tail ->
    try
      fst (List.fold_left (fun (acc, last) elem -> if elem >= last then (true, elem) else (raise My_exception)) (true, head) tail)
    with My_exception -> false;;