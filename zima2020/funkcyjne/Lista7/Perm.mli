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

module Make(Key : OrderedType) : S with type key = Key.t
(*Zadanie 2*)
module type IsGenerated = sig
  type genType
  val is_generated : genType -> genType list -> bool
end
module Generated(Key : S) : IsGenerated with type genType = Key.t
(*Zadanie 3*)
module OrderedList (X : OrderedType) : OrderedType with type t = X.t list
module OrderedPair (X : OrderedType) : OrderedType with type t = X.t * X.t
module OrderedOption (X : OrderedType) : OrderedType with type t = X.t option