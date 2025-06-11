let _ = 42 = 42 (* another way to write this is would be [let _ = (42 = 42)] *)

(* comparing using structural equality *)
let _ = "hi" = "hi";;
(* comparing using physical equality *)
let _ = "hi" == "hi";;
(* comparing using structural equality *)


(* assert 2110 is not structurally equal to 3110 *)
let _ = assert (not (2110 = 3110));; 
let _ = assert (2110 <> 3110);; 

(* if expression that evalutates to 42 of  2 is greater thamn 1  otherwise evaluates to 7 *)
if 2 > 2 then 24 else 7;;

(* write a function double that multiplies it's input by *)
let double x = x * 2;;
(* test the function double using assert *)
let _ = assert (double 7 = 14);; 
let _ = assert ( double 0 = 0);;
let _ = assert (double (-1) = -2);; 
