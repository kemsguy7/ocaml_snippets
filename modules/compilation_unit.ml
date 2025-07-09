(* foo.mli*)
val : int 
val f : int -> int 


(* foo.ml *)
let x = 0
let y = 12 
let f x = x + y  

(*compiling the unit above will have same effect like the code module block below  *)

module Foo : sig 
  val x : int
  val f : int -> int 
end = struct 
  let x = 0 
  let y = 12 
  let f x = x + y 
end  

(* general compilation unit struct *)

module Foo 
  : sig (* insert contents of foo.mli here *) end  
= struct 
  (* insert contents of foo.ml here *)  
end 

(* The above code is a general template for a compilation unit in OCaml. 
   It defines a module `Foo` with a signature that can be filled in with 
   the contents of a corresponding `.mli` file, and the implementation 
   can be filled in with the contents of a `.ml` file. This allows for 
   modular programming and encapsulation of functionality in OCaml. *)
   