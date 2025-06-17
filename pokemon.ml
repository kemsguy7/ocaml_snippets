(* A script to model a pokemon game *)

(* Building the types *)
type ptype = TNormal | TFire | TWater 

(* Effectiveness of attack *)
type peff = ENormal | ENotVery | ESuper  
 
(* mult_of_eff *)
let mult_of_eff = function 
  | ENormal -> 1. 
  | ENotVery -> 0.5 
  | ESuper -> 2.0

let eff = function 
  | (TFire, TFire) | (TWater, TWater) | (TFire, TWater) -> ENotVery 
  | (TWater, TFire) -> ESuper 
  | _ -> ENormal
  
let () =
  (* Using all constructors to silence warnings *)
  let _ = TNormal in  (* This line just shows we're aware of TNormal *)
  Printf.printf "Fire vs Fire: %f\n" (mult_of_eff (eff (TFire, TFire)));
  Printf.printf "Water vs Fire: %f\n" (mult_of_eff (eff (TWater, TFire)));
  Printf.printf "Normal vs Water: %f\n" (mult_of_eff (eff (TNormal, TWater)))