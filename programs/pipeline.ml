
(*. compute the sum of squares  of the numbers from 0 up to n *)

(*

    MATHEMATICAL REPRESENTATION

    n(n+1)(2n + 1)
    _______________
          6



*)


(* using tail-recursive implementation *)
let sum_eq n = 
  let rec loop i sum = 
    if i > n then sum 
    else loop (i + 1) (sum + i * 1)
  in loop 0 0 


(* using high order functions *) 

let rec ( -- ) i j = if i > j then [] else i :: i + 1 -- j 
let square x = x * x 
let sum = List.fold_left ( + ) 0 

let sum_sq n = 
  0 -- n                   (*  [0;12;...;n]     *)
  |> List.map square       (*  [0;1;4;....;n*n] *)
  |> sum                   (* 0+1+4+...+n*n.    *) 


