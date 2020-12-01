(*Dawid Żywczak, Zadanie 7, lista 6*)
type 'a llist = LCons of 'a * (unit -> 'a llist)
type 'a my_lazy = {lazy_fun: (unit -> 'a); mutable value: 'a option; mutable is_processed: int}
type 'a llist = LCons of 'a * ('a llist) my_lazy

let force (lValue: 'a my_lazy) = 
  if lValue.is_processed = 0 then
  begin
    lValue.is_processed <- 1;
    let funResult = (lValue.lazy_fun ()) in
    lValue.value <- Some funResult;
    funResult
  end
  else
    match lValue.value with
    | None -> failwith "Not productive"
    | Some a -> a

let rec ltake n lxs =
  match (n, (force lxs)) with
    | 0, _ -> []
    | n, LCons (x, xf) -> x :: ltake (n - 1) xf

let rec fix (fixFunction: 'a my_lazy -> 'a) : 'a my_lazy = 
  let rec myObject = {lazy_fun = (fun () -> fixFunction myObject); value = None; is_processed = 0} in
    myObject

let rec naturalFunction (n: int) (a: 'a my_lazy) =
      LCons(n, fix (naturalFunction (n + 1)))

let primesStream (a: 'a my_lazy)= 
  let rec aux number =
    let rec checkPrimary divisor limit =
      if divisor > limit then
        LCons(number, fix (fun _ -> aux (number + 1)))
      else 
      begin
        if number mod divisor = 0 then
          aux (number + 1)
        else
          checkPrimary (divisor+1) limit
      end
    in checkPrimary 2 (number - 1)
  in aux 2

let rec primesStream_diff n (a: 'a my_lazy)= 
  let rec checkPrimary divisor limit =
    if divisor > limit then
      LCons(n, fix (primesStream_diff (n + 1)))
    else 
      begin
        if n mod divisor = 0 then
          primesStream_diff (n + 1) a
        else
          checkPrimary (divisor+1) limit
      end
  in 
    if n < 2 then
      primesStream_diff (n + 1) a
    else checkPrimary 2 (n - 1)