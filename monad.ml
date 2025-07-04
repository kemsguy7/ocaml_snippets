(* A monad must match the following signature *)

(* monad is like a box that contains some value 
Value has type 'a 
- the box has type 'a t 
- return puts a value into the box . The input is of type 'a , and the output is of type 'a t
- bind take as input : 
   - a boxed value, which has type 'a t, and 
   - A function that itself takes an unboxed value of type 'a as input and returns a boxed value of type 'b t as output

*)

module type Monad = sig 
  type 'a t  
  val return : 'a -> 'a t 
  val bind : 'a t -> ('a -> 'b t) -> 'b t
end 


