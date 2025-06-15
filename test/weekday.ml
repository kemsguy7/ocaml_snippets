(*This script shows different levels of tdd*)

type day = Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday 

(* most basic , broken version of the function *)
 (* let next_weekday d = failwith "Unimplemented"   *)

 (* revise the function to make test pass *)
 let next_weekday d = 
   match d with 
   | Monday -> Tuesday 
   | _ -> failwith "Unimplemented"
 