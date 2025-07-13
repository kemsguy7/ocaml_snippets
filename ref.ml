
(* This function takes a value in memory and returns an addition to the previous value in memory when called *)

(* let counter = ref 0 

let next_val = 
  fun () -> 
    counter := !counter + 1 ;
    !counter  *)

(* code above can also be written as below to make the counter variable not exposed to the outside world *)


let next_val = 
  let counter = ref 0 in 
    fun () -> 
    incr counter; 
     !counter 



type point = {x: int; y : int; mutable c: string}
let  p = {x = 0; y = 0; c ="red"}
p.c <- “white”