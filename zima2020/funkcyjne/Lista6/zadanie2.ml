(*Zadanko spisane z ćwiczeń C:*)

type ('a , 'b) fixt = { c: ('a, 'b) fixt -> (('a -> 'b) -> 'a -> 'b) -> 'a -> 'b }

let fix f x =
  let ft = { c = fun fx f x -> f (fx.c fx f) x }
  in ft.c ft f x;;

let magic_fix f x =
  let state = ref (fun a b -> a b) in
  let aux: (('a -> 'b) -> 'a -> 'b) -> 'a -> 'b =
    fun f x -> f (Obj.magic !state f) x in
  state := Obj.magic aux;
  aux f x;;