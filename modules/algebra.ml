module type Ring = sig  
  type t 
  val zero : t 
  val one : t 
  val ( + ) : t -> t-> t 
  val ( * ) : t -> t -> t 
  val ( ~- ) : t -> t 
  val string : t -> string 
end 


module IntRingRep  = struct  
  type t  = int
  let zero = 0 
  let one = 1 
  let ( + ) = Stdlib.( + ) 
  let ( * ) = Stdlib.( * )
  let ( ~- ) = Stdlib.( ~- )
  let string = string_of_int 
end

(* The IntRigRep module implements the Ring signature for integers, providing 
   basic arithmetic operations and a string representation. *)

(* The IntRing module is an alias for IntRigRep, allowing it to be used as a Ring type. This is useful for consistency in naming and usage across the codebase. *)  

module IntRing : Ring = IntRingRep (* sealing the implementation of Ring in this new module, will return type <abstr> if you try accesing it *)