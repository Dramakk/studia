(* let of_list alist =
  let rec aux alist current =
    match alist with
    | [] -> current
    | hd::tail -> let currentVal = (Lazy.force_val current) in
     aux tail (lazy {prev = currentVal.prev; elem = hd; next = currentVal.next})
  in let rec x = lazy {prev=x; elem=List.hd alist; next=x} in
    aux (List.tl alist) x;; *)
    (* type 'a llist = LNil | LCons of 'a * 'a llist Lazy.t
    let cycle = function
    | [] -> invalid_arg "cycle: empty list"
    | hd::tl ->
      let rec result =
        LCons (hd, lazy (aux tl))
      and aux = function
        | [] -> result
        | x::xs -> LCons (x, lazy (aux xs)) in
      result *)
      let dlist_of_list list = 
        let rec aux prev list =
          match list with 
          | [] -> x
          | h :: t -> let rec node = lazy {prev = prev; elem = h; next = aux node t} in 
                      node
        and
        x = lazy {prev=x; elem=List.hd list; next = (aux x (List.tl list))} in
          x;;
  
  let of_list list = 
    let first = List.hd list and last = List.hd (List.rev list) in
      let rec firstNode = lazy {prev = lastNode; elem = first; next = (aux firstNode (List.tl list))} and
      lastNode = lazy {prev = firstNode; elem = last; next = firstNode} and
      aux prev list=
        match list with 
        | [] -> firstNode
        | h :: t -> let rec node = lazy {prev = prev; elem = h; next = aux prev t} in 
                    node
        in
        firstNode;;
  (* let cycle list = 
    let rec find_last alist first = 
      if (Lazy.force_val alist).next == first then alist else find_last (Lazy.force_val alist).next first
    in
    match list with
  | [] -> invalid_arg "cycle: empty list"
  | hd::tl ->
    let rec result =
      lazy {prev = (aux tl); elem = hd ; next = (aux tl)}
    and aux list =
      match list with
      | [] -> result
      | x::xs -> (lazy {prev = result; elem = x; next = (aux xs)}) in
      let xd = (find_last result result) in
      lazy {prev = xd; elem = (Lazy.force_val result).elem; next = (Lazy.force_val result).next};; *)
    (* let forced = Lazy.force_val result in 
      lazy {prev = !z; elem = forced.elem; next = forced.next};; *)
  
  data DList a = DLNode (DList a) a (DList a)
  
  mkDList :: [a] -> DList a
  
  mkDList [] = error "must have at least one element"
  mkDList xs = let (first,last) = go last xs first
               in  first
  
    where go :: DList a -> [a] -> DList a -> (DList a, DList a)
          go prev []     next = (next,prev)
          go prev (x:xs) next = let this        = DLNode prev x rest
                                    (rest,last) = go this xs next
                                in  (this,last)
  
  takeF :: Integer -> DList a -> [a]
  takeF 0     _                 = []
  takeF n (DLNode _ x next)     = x : (takeF (n-1) next)
  
  takeR :: Show a => Integer -> DList a -> [a]
  takeR 0     _                 = []
  takeR n (DLNode prev x _)     = x : (takeR (n-1) prev)
  (* let fix_memo f =
    let rec fix = lazy (memoize (fun x -> f (Lazy.force fix) x)) in
    Lazy.force fix *)