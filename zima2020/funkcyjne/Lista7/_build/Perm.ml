open Map
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end

module type S = sig
  type key
  type t
  (** permutacja jako funkcja *)
  val apply : t -> key -> key
  (** permutacja identycznościowa *)
  val id : t
  (** permutacja odwrotna *)
  val invert : t -> t
  (** permutacja która tylko zamienia dwa elementy miejscami *)
  val swap : key -> key -> t
  (** złożenie permutacji (jako złożenie funkcji) *)
  val compose : t -> t -> t
  (** porównywanie permutacji *)
  val compare : t -> t -> int
  end

module Make(Key : OrderedType) = struct
  module PermType = Map.Make(Key)
  type key = Key.t
  type t = key PermType.t * key PermType.t
  let apply perm k =
    let permFirst = (fst perm) in
      let found = PermType.find_opt k permFirst
        in match found with
        | Some(x) -> x
        | None -> k
  let id = (PermType.empty), (PermType.empty)
  let invert perm = ((snd perm), (fst perm))
  let swap key1 key2 =
      let (pp1, pp2) = id in
        if Key.compare key1 key2 <> 0 then
            let pp1 = PermType.add key1 key2 pp1 in
              let pp1 = PermType.add key2 key1 pp1 in
                let pp2 = PermType.add key1 key2 pp2 in
                  let pp2 = PermType.add key2 key1 pp2 in
                (pp1, pp2)
        else
          (pp1, pp2)      
  let compose perm1 perm2 = 
    let (p11, p12) = perm1 and (p21, p22) = perm2 in
    let f perm key optionInOne optionInTwo =
      match optionInOne, optionInTwo with
      | _, Some(y) -> let found = apply perm y in if Key.compare key found = 0 then None else Some(found)
      | Some(x), None -> optionInOne
      | None, None -> None
    in let merged1 = PermType.merge (f perm1) p11 p21 and merged2 = PermType.merge (f perm2) p22 p12 in merged1, merged2
  let compare perm1 perm2 = PermType.compare (Key.compare) (fst perm1) (fst perm2) 
end;;

(*Zadanie 2*)
module type IsGenerated = sig
  type genType
  val is_generated : genType -> genType list -> bool
end

module Generated(Key : S) = struct
  type genType = Key.t

  module PermSet = Set.Make(Key)

  
  let is_generated perm permList = 
    let rec generatePerms perms xs acc =
      match xs with
      | [] -> acc
      | hd::tail -> generatePerms perms tail (PermSet.union perms (PermSet.map (fun x -> Key.compose x hd) perms))
    and aux perms =
      let newPermsSet = PermSet.union (generatePerms perms (PermSet.elements perms) PermSet.empty) 
      (PermSet.union perms (PermSet.map Key.invert perms))
        in if PermSet.compare perms newPermsSet = 0 then
          match PermSet.find_opt perm newPermsSet with
          | None -> false
          | Some(_) -> true
        else aux newPermsSet
    in aux (PermSet.union (PermSet.of_list permList) (PermSet.singleton Key.id))
end;;

(*Zadanie 3*)

module OrderedList (X : OrderedType) = struct
  type t = X.t list

  let compare val1 val2 =
    let rec aux xs ys =
      match xs, ys with
        | hdx::tlx, hdy::tly -> let compVal = X.compare hdx hdy in
          if compVal = 0 then
            aux tlx tly
          else
            compVal
        | hd::tl, [] -> 1
        | [], hd::tl -> -1
        | [], [] -> 0
    in aux val1 val2
end

module OrderedPair (X : OrderedType) = struct
  type t = X.t * X.t
  
  let compare val1 val2 =
    let compVal = X.compare (fst val1) (fst val2) in
      if compVal = 0 then
        let compVal2 = X.compare (snd val1) (snd val2) in
          compVal2
      else
        compVal
end

module OrderedOption (X : OrderedType) = struct
  type t = X.t option
  
  let compare val1 val2 =
    match val1, val2 with
    | None, None -> 0
    | None, Some(_) -> -1
    | Some(_), None -> 1
    | Some(x), Some(y) -> X.compare x y
end