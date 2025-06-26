
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
    if i > n then sum  (*loop checks if i has passed n, return the accumulated sum *)
    else loop (i + 1) (sum + i * 1)   (* first is getting the next number second is adding the square of the reent num to sum  *)
  in loop 0 0  (*start the loop with i =0 and sum = 0 *)


(* using high order functions *) 

(* Helper functions *)
let rec ( -- ) i j = if i > j then [] else i :: i + 1 -- j  (* This creates a custom operator that generats a list of numbers from i to j *)


(*
  is says  if start i > end j, return rmpty list

  else

  make a list starting with i, followed by numbers from i +j to j e.g  0 --2 creats [0; 1;  2];;
*)
let square x = x * x 
let sum = List.fold_left ( + ) 0 




(* Final implementation with higher order funcions *)
let sum_sq n = 
  0 -- n                   (*  [0;1; 2;...;n]     *)
  |> List.map square       (*  [0; 1; 4;....;n*n] *) (* squares each *)
  |> sum                   (* 0+1+4+...+n*n.    *)  (* Adds them *)



  (* rewriting the higher order implementtino inside sum_sq but less readable *)

  let sum_sq n = 
    let rec ( -- ) i j = if i > j then [] else i :: (i + 1 -- j) in 
    let square x = x * x in 
    let sum = List.fold_left ( + ) 0 in 
    0 -- n |> List.map square |> sum 