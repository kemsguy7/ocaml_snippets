module type X = sig 
  val x : int
end

module Incx (M : X) =  struct 
  let x = M.x + 1
end


(* Applying the functor above *)
module A = struct let x = 0 end 

module B = Incx(A)

(* B.x will be 1, since A.x is 0 and we increment it by 1 in the functor *)

module C = Incx (B)