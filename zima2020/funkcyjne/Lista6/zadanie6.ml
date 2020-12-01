(*Dawid Żywczak, Zadanie 6, lista 6*)

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

let integers = 
  let rec auxNext prev elem =
    let rec newNode = lazy {prev = prev; elem = elem; next = (auxNext newNode (elem + 1))} in
      newNode
  and auxBack next elem =
    let rec newNode = lazy {prev = (auxBack newNode (elem - 1)); elem = elem; next = next} in
      newNode
  in let rec x = lazy {prev = (auxBack x (-1)); elem = 0; next = (auxNext x 1)} in x