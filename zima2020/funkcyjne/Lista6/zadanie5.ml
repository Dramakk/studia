(*Dawid Żywczak, Zadanie 5, lista 6*)
type 'a dllist = 'a dllist_data lazy_t
and 'a dllist_data =
  { 
    prev : 'a dllist; 
    elem : 'a; 
    next : 'a dllist
  }

let elem (lazy alist: 'a dllist) = alist.elem
let next (lazy alist: 'a dllist) = alist.next
let prev (lazy alist: 'a dllist) = alist.prev

let of_list list = 
  match list with
  | [] -> invalid_arg "cycle: empty list"
  | hd::tl ->
    let rec ofNext prev xs first =
      match xs with
      | [] -> first
      | hd::tl -> let rec newNode = lazy {prev = prev; elem = hd; next = (ofNext newNode tl first)} in
        newNode
    and back llist xs =
      match xs with
      | [] -> (Lazy.force llist)
      | hd::tl -> back (next llist) tl
    in let rec listStart = lazy {prev = lazy (back listStart tl); elem = hd; next = (ofNext listStart tl listStart)} in 
    listStart