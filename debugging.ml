(* sample code for adding function traces to debug a program or function*)

let rec fib x = if x <= 1 then 1 else fib (x -1) + fib (x - 2);; 
#trace fib;; 


(* sample code for debugging a function that raises an exception *)
(* possibility 1 *)
let random_int bound = 
  assert (bound > 0 && bound < 1 lsl 30); 
  (* proceed wih the implementation of the function *)

(* possibility 2 *)
let random_int bound = 
  if not (bound > 0 && bound < 1 lsl 30) 
  then invalid_arg "bound"; 
  (* proceed with the implementation of the function *)

  (* possibility 3 *)
let random_int bound  = 
  if not (bound > 0 && bound < 1 lsl 30)
  then failwith "bound"; 
  (* proceed with the implementation of the function *)
