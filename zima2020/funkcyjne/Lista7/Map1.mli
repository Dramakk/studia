type ('a, _) order1 =
  | Lt : ('a, 'b) order1
  | Eq : ('a, 'a) order1
  | Gt : ('a, 'b) order1

module type Type1 = sig
  type 'a t
end

module type OrderedType1 = sig
  include Type1
  val compare : 'a t -> 'b t -> ('a, 'b) order1
end

module type S = sig
  type 'a key
  type 'a value
  type t
  val empty : t
  val add : 'a key -> 'a value -> t -> t
  val remove : 'a key -> t -> t
  val find : 'a key -> t -> 'a value
end

module Make(Key : OrderedType1)(Value : Type1) : S with type 'a key = 'a Key.t and type 'a value = 'a Value.t