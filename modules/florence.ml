module Hello = struct 
  let message = "Hello from Florence"
  let print () = print_endline message 
end 

let print_goodbye () = print_endline "Goodbye" 


(* Submodules with signatures *)

(*.To determine a submodule's interfac, we can provide a module signature *)
module Hello : sig 
  val print: unit -> unit 
end = struct 
  let message = "Hello"
  let print () = print_endline message 
end 


let print_goodbye () = print_endline "Goodbye"