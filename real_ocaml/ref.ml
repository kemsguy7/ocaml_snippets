(** [fact n] is [n!]. 

  Requires: [n >= 0]. *)

  (* This is a recursive function that calculates the factorial of a number. 
   It checks if the number is zero, and if so, returns 1. Otherwise, it multiplies the number by the factorial of the number minus one. *)
let rec fact n = 
  if n = 0 then 1 
    else n * fact (n -1) 

(* This is a recursive function that calculates the power of a number. *)
 let rec pow x y = 
  if y = 0 then 1 
  else x * pow x (y - 1)    