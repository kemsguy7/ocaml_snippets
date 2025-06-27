(* Normal multi-argument function *)
let add x y = x + y 


(* this is what the function above does *)
let add = fun x -> (fun y -> x + y) 


(* Partial application*)

let add5 = add 5 (* Crates a function that adds 5 to anything *)
let result = add 5 0 (* 8 *)


(* Function composition *)
let double_and_add5 = ( * ) 2 |> add5 
(* Same as : let double_and_add5 x = add5 (x * 2) *)


(* Higher-Order functions *)
List.map (add 10) [1 ; 2; 3] (* 11 ; 13. 13  *)

