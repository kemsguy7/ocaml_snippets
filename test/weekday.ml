(*This script shows different levels of tdd*)

type day = Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday 

(* most basic , broken version of the function *)
 (* let next_weekday d = failwith "Unimplemented"   *)

 (* revise the function to make test pass *)
 let next_weekday d = 
   match d with 
   | Monday -> Tuesday 
   | Tuesday -> Wednesday
   | Wednesday -> Thursday
   | Thursday -> Friday
   | Friday -> Monday
   | Saturday -> Monday
   | Sunday -> Monday
   (* Adding a case for Sunday to return Monday, as it is the next weekday *)
   (* This will make the test pass, but we can add more tests for unimplemented cases later *)
 