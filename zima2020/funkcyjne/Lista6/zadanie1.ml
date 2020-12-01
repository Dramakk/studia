(*Dawid Żywczak, Zadanie 1, lista 6*)
open Hashtbl

let rec fix f x = f (fix f) x
let fib_f fib n =
  if n <= 1 then n
  else fib (n-1) + fib (n-2)
let fib = fix fib_f

let rec fix_with_limit n f x = 
  if n <= 0 then
    failwith "To many tries"
  else f (fix_with_limit (n - 1) f) x

let fix_memo f x =
  let cache = create 0 in
  let rec aux f x =
    let value = find_opt cache x in
      match value with
      | Some a -> a
      | None -> let result = f (aux f) x in
                add cache x result;
                result
    in aux f x