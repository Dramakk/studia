(*Dawid Żywczak, Zadanie 5, lista 2*)
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