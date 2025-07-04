(* A monad must match the following signature *)

module type Monad = sig 
  type 'a t 
  val return : 'a -> 'a t 
  val bind : 'a t -> ('a -> 'b t) -> 'b t
end 


