(*Dawid Żywczak, Zadanie 4, lista 6*)
type 'a llist = LCons of 'a * (unit -> 'a llist)
let rec ltake n lxs =
  match (n, lxs) with
  | 0, _ -> []
  | n, LCons (x, xf) -> x :: ltake (n - 1) (xf ())

let leibniz =
  let rec aux n sign calculatedValue () =
    if sign = 0 then
      let newCalculatedValue = (calculatedValue +. (4. /. n)) in
      LCons (newCalculatedValue, (aux (n +. 2.) 1 newCalculatedValue))
    else
      let newCalculatedValue = (calculatedValue -. (4. /. n)) in
      LCons (newCalculatedValue, (aux (n +. 2.) 0 newCalculatedValue))
  in
  LCons (4., aux 3. 1 4.)

let rec transform f stream =
  match stream with
  | LCons (x, cont) ->
    match cont () with
    | LCons (x2, cont2) ->
      match cont2 () with
      | LCons (x3, cont3) -> LCons ((f x x2 x3), (fun () -> (transform f (cont ()))))

let euler_transform x y z =
  z -. (((y -. z) *. (y -. z)) /. (x -. (2. *. y) +. z))

let betterPi = transform euler_transform leibniz