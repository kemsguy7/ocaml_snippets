(* A monad must match the following signature *)

(* monad is like a box that contains some value 
Value has type 'a 
- the box has type 'a t 
- return puts a value into the box . The input is of type 'a , and the output is of type 'a t
- bind take as input : 
   - a boxed value, which has type 'a t, and 
   - A function that itself takes an unboxed value of type 'a as input and returns a boxed value of type 'b t as output
- Bind applies it's second argument to the first. That requires taking the 'a value out of it's box, applying the function to it , and returning the result. 

*)

module type Monad = sig 
  type 'a t  
  val return : 'a -> 'a t 
  (* val bind : 'a t -> ('a -> 'b t) -> 'b t *)

  val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
end 


(* Implementation of the monad signature for the maybe monad *)

module Maybe : Monad = struct 
  type 'a t = 'a option 
  
  let return x = Some x 

  let (>>=) m f = 
    match m with 
    | None -> None 
    | Some x -> f x 
end 
    

