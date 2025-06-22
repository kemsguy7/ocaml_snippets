
let _ = 42 = 42 (* another way to write this is would be [let _ = (42 = 42)] *)

(* program that raise 42 to the power of 7*)
let exp = 42. ** 7. 

(* comparing using structural equality *)
let _ = "hi" = "hi";;

(* comparing using physical equality *)
let _ = "hi" == "hi";;
(* comparing using structural equality *)


(* assert 2110 is not structurally equal to 3110 *)
let _ = assert (not (2110 = 3110));; 
let _ = assert (2110 <> 3110);; 


(* if expression that evalutates to 42 of 2 is greater than 1  otherwise evaluates to 7 *)
if 2 > 2 then 24 else 7;;


(* write a function double that multiplies it's input by *)
let double x = x * 2;;

(* test the function double using assert *)
let _ = assert (double 7 = 14);; 
let _ = assert ( double 0 = 0);;
let _ = assert (double (-1) = -2);; 

(* 
Double fun 
- Define a function that computes the cube of a floating-point number. Test your function by applying ot to a few inputs
*)

let cube x = x *. x *. x;
(*teting with assert *)

let  _ = assert (cube 0. = 0.)
let  _ = assert (cube 1. = 1.)
let  _ = assert (cube 3. = 27.)


(*Define a func that computes a sign 1 0 or -1 of an integer using nested if statements *)
let sign x = 
   if x > 0 then 1 
   else if x < 0 then -1 
   else 0

   (*testing *)

   
let _ = assert (sign 0 = 0)
let _ = assert (sign 10 = 1)
let _ = assert (sign (-10) = -1)


(* Define a function to compute the area of a circle given it's radius, test your function with assert *)