module Low.Regional

open FStar.All
open FStar.Integers
open FStar.Classical
open LowStar.Modifies

module HH = FStar.Monotonic.HyperHeap
module HS = FStar.HyperStack
module HST = FStar.HyperStack.ST
module MHS = FStar.Monotonic.HyperStack

/// Regionality

type erid = rid:HH.rid{HST.is_eternal_region rid}

// Motivation: we want to ensure that all stateful operations for a value of
// type `a` are within the `region_of` the value.
noeq type regional a =
| Rgl:
    region_of: (a -> GTot HH.rid) ->

    // A non-stateful chosen value of type `a`.
    // Note that the value doesn't need to satisfy the stateful invariant.
    cv: a ->

    // A representation type of `a` and a corresponding conversion function
    repr: Type0 ->
    r_repr: (HS.mem -> a -> GTot repr) ->

    // An invariant we want to maintain for each operation.
    // For example, it may include `live` and `freeable` properties
    // for related objects.
    r_inv: (HS.mem -> a -> GTot Type0) ->
    r_inv_reg:
      (h:HS.mem -> v:a ->
      Lemma (requires (r_inv h v))
	    (ensures (MHS.live_region h (region_of v)))) ->

    // A core separation lemma, saying that the invariant and represenation
    // are preserved when an orthogonal state transition happens.
    r_sep:
      (v:a -> p:loc -> h:HS.mem -> h':HS.mem ->
      Lemma (requires (r_inv h v /\
		      loc_disjoint 
			(loc_all_regions_from false (region_of v)) p /\
		      modifies p h h'))
	    (ensures (r_inv h' v /\ r_repr h v == r_repr h' v))) ->

    // Construction
    irepr: Ghost.erased repr ->
    r_init_p: (a -> GTot Type0) ->
    r_init: (r:erid ->
      HST.ST a
	(requires (fun h0 -> true))
	(ensures (fun h0 v h1 ->
	  Set.subset (Map.domain (HS.get_hmap h0))
	  	     (Map.domain (HS.get_hmap h1)) /\
	  modifies loc_none h0 h1 /\ 
	  r_init_p v /\ r_inv h1 v /\ region_of v = r /\
	  r_repr h1 v == Ghost.reveal irepr))) ->

    // Destruction
    r_free: (v:a ->
      HST.ST unit
	(requires (fun h0 -> r_inv h0 v))
	(ensures (fun h0 _ h1 ->
	  modifies (loc_all_regions_from false (region_of v)) h0 h1))) ->
    regional a
