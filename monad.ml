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

(* Deriving and Implementing signature for the writer Monad*)

let inc x = x + 1
let dec x = x - 1   
(*Loggin helper function*)
 let log (name: string) (f: int -> int): int -> int * string = 
   fun x -> (f x, Printf.sprintf "Called %s on %i; " name x)

let loggable (name : string) (f: int -> int) : int * string -> int * string = 
  fun (x , s1) -> 
    let (y, s2) = log name f x in 
    (y , s1 ^ s2) 


let inc' : int * string -> int * string = 
  loggable "inc" inc 

let dec' : int * string -> int * string = 
  loggable "dec" dec  

let id' : int * string -> int * string = 
  inc' >> dec'   (*id' composes inc' and dec' , meanng it will first apply inc' then dec' tp the result *)

 (* Example usage *)
let () = 
  let x = 5 in 
  let (result, log) = id' (x, "") in 
  Printf.printf "Result: %d\nLog: %s\n" result log 
  
id' (5, "")  


(* Writer monad signature proper *)
module Writer : Monad = struct 
  type 'a t = 'a * string 

  let return x = (x, "")

  let (>>=) m f = 
    let (x, s1) = m in 
    let (y, s2) = f x in 
    (y, s1 ^ s2)
end 

(* Monad Laws *)
(*  
Law 1: return x >>= f behaves the same as f x. 

Law 2: m >== return behaves the same as m. 

Law 3: (m >>= f) >>= g behaves the same as m >>= (fun x -> f x >>= g).

*)