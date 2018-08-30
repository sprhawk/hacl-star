module Hacl.Hash.Common

module U8 = FStar.UInt8
module U32 = FStar.UInt32
module U64 = FStar.UInt64
module HS = FStar.HyperStack
module ST = FStar.HyperStack.ST

module M = LowStar.Modifies
module B = LowStar.Buffer
module Spec = Spec.Hash.Padding

open Spec.Hash.Helpers

(** We need to reveal the definition of the internal state for clients to use it *)

let word (a: hash_alg) =
  match a with
  | MD5 | SHA1 | SHA2_224 | SHA2_256 -> U32.t
  | SHA2_384 | SHA2_512 -> U64.t

type state (a: hash_alg) =
  b:B.buffer (word a) { B.length b = size_hash_w a }

inline_for_extraction
let pad_t (a: hash_alg) = len:len_t a -> dst:B.buffer U8.t ->
  ST.Stack unit
    (requires (fun h ->
      len_v a len < max_input8 a /\
      B.live h dst /\
      B.length dst = pad_length a (len_v a len)))
    (ensures (fun h0 _ h1 ->
      M.(modifies (loc_buffer dst) h0 h1) /\
      B.as_seq h1 dst == Spec.pad a (len_v a len)))

let hash_t (a: hash_alg) = b:B.buffer U8.t { B.length b = size_hash a }

inline_for_extraction
let finish_t (a: hash_alg) = s:state a -> dst:hash_t a -> ST.Stack unit
  (requires (fun h ->
    B.disjoint s dst /\
    B.live h s /\
    B.live h dst))
  (ensures (fun h0 _ h1 ->
    M.(modifies (loc_buffer dst) h0 h1) /\
    B.as_seq h1 dst == Spec.finish a (B.as_seq h0 s)))