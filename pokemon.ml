(* A script to model a pokemon game *)

(* Building  the types *)
type ptype = TNormal | TFire | TWater 

(* Effectiveness of attack *)

type peff = ENormal |ENotVery | ESuper  
 
(* mult_of_eff *)
let mult_of_eff =  function 
  | ENormal -> 1. 
  | ENotVery -> 0.5 
  | ESuper -> 2.0

let eff = function 
  (* | (TFire, TFire) -> ENotVery  *)
  (* rewriting the pattern above with or syntax *)
  |(TFire, TFire) | (TWater, TWater) | (TFire, TWater)-> ENotVery 
  | (TWater, TFire) -> ESuper 
    | _ ->ENormal
  
  let () =
    Printf.printf "%f\n" (mult_of_eff (eff (TFire, TFire)))
