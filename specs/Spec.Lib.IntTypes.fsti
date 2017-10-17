module Spec.Lib.IntTypes

type inttype = 
 | U8 | U16 | U32 | U64 | U128 

let maxint (t:inttype) = 
  match t with
  | U8 -> 0xff
  | U16 -> 0xffff
  | U32 -> 0xffffffff
  | U64 -> 0xffffffffffffffff
  | U128 -> 0xffffffffffffffffffffffffffffffff

unfold 
let bits (n:inttype) = 
  match n with
  | U8 -> 8
  | U16 -> 16
  | U32 -> 32
  | U64 -> 64
  | U128 -> 128

unfold 
let size (n:inttype) = 
  match n with
  | U8 -> 1
  | U16 -> 2
  | U32 -> 4
  | U64 -> 8
  | U128 -> 16
  
val uint: Type0
val ty: uint -> GTot inttype
type uint_t (t:inttype) = 
     u:uint {ty u = t}
val uint_v: u:uint -> GTot nat

type uint8 = u:uint_t U8
type uint16 = uint_t U16
type uint32 = uint_t U32
type uint64 = uint_t U64
type uint128 = uint_t U128
val u8: (n:nat{n <= maxint U8}) -> u:uint8{uint_v u = n}
val u16: (n:nat{n <= maxint U16}) -> u:uint16{uint_v u = n}
val u32: (n:nat{n <= maxint U32}) -> u:uint32{uint_v u = n}
val u64: (n:nat{n <= maxint U64}) -> u:uint64{uint_v u = n}
val u128: (n:nat{n <= maxint U128}) -> u:uint128{uint_v u = n}

val add_mod: #t:inttype -> a:uint_t t -> b:uint_t t -> uint_t t 

val add: #t:inttype -> a:uint_t t -> b:uint_t t -> Pure (uint_t t)
  (requires (uint_v a + uint_v b < pow2 (bits t)))
  (ensures (fun _ -> True))

val mul_mod: #t:inttype{t <> U128} -> a:uint_t t -> b:uint_t t -> uint_t t

val mul: #t:inttype{t <> U128} -> a:uint_t t -> b:uint_t t -> Pure (uint_t t)
  (requires (uint_v a `op_Multiply` uint_v b < pow2 (bits t)))
  (ensures (fun _ -> True))

val sub_mod: #t:inttype -> a:uint_t t -> b:uint_t t -> uint_t t
val sub: #t:inttype -> a:uint_t t -> b:uint_t t -> Pure (uint_t t)
  (requires (uint_v a >= uint_v b ))
  (ensures (fun _ -> True))

val logxor: #t:inttype -> a:uint_t t  -> b:uint_t t -> uint_t t 
val logand: #t:inttype -> a:uint_t t  -> 
b:uint_t t -> uint_t t 
val logor: #t:inttype -> a:uint_t t  -> 
b:uint_t t -> uint_t t 
val lognot: #t:inttype -> a:uint_t t -> uint_t t 

val shift_right: #t:inttype -> a:uint_t t -> b:uint32 -> Pure (uint_t t )
  (requires (uint_v b < bits t))
  (ensures (fun _ -> True))

val shift_left: #t:inttype -> a:uint_t t -> b:uint32 -> Pure (uint_t t )
  (requires (uint_v b < bits t))
  (ensures (fun _ -> True))

val rotate_right: #t:inttype -> a:uint_t t -> b:uint32 -> Pure (uint_t t )
  (requires (uint_v b > 0 /\ uint_v b < bits t))
  (ensures (fun _ -> True))

val rotate_left: #t:inttype -> a:uint_t t -> b:uint32 -> Pure (uint_t t )
  (requires (uint_v b > 0 /\ uint_v b < bits t))
  (ensures (fun _ -> True))

val eq_mask: #t:inttype -> a:uint_t t  -> b:uint_t t -> uint_t t

val neq_mask: #t:inttype -> a:uint_t t  -> b:uint_t t -> uint_t t

val gte_mask:  #t:inttype -> a:uint_t t  -> b:uint_t t -> uint_t t

val gt_mask:  #t:inttype -> a:uint_t t  -> b:uint_t t -> uint_t t

val lt_mask:  #t:inttype -> a:uint_t t  -> b:uint_t t -> uint_t t

val lte_mask:  #t:inttype -> a:uint_t t  -> b:uint_t t -> uint_t t

let (+!) = add
let (+.) = add_mod
let ( *! ) = mul
let ( *. ) = mul_mod
let ( -! ) = sub
let ( -. ) = sub_mod
let ( >>. ) = shift_right
let ( <<. ) = shift_left
let ( >>>. ) = rotate_right
let ( <<<. ) = rotate_left
let ( ^. ) = logxor
let ( |. ) = logor
let ( &. ) = logand
let ( ~. ) = lognot

type index32 = UInt32.t


val bignum: Type0
val bn_v: bignum -> GTot nat
val bn: nat -> bignum
val bn_add: bignum -> bignum -> bignum
val bn_mul: bignum -> bignum -> bignum
val bn_sub: a:bignum -> b:bignum{bn_v a >= bn_v b} -> bignum
val bn_mod: bignum -> b:bignum{bn_v b <> 0} -> bignum
val bn_div: bignum -> b:bignum{bn_v b <> 0} -> bignum
