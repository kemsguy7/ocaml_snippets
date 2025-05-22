let numbers = [|1; 2; 3; 4; 5 |];;

(* modifying the array *)
numbers.(2) <- 2;; 

(* Working with Refs*)

let x = { contents = 0};; 
x.contents <- x.contents + 1;; 

