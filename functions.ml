
(*Two equvalent ways of squaring 6*)
let square x = x * x;; 
square (inc 5);;

5 |> inc |> square ;;  (*uses the pipeline operato to 5 through the inc function, then send the result of that through the square function *)


(*optional arguments*)
let f ?name:(arg1=8) arg2 = arg1 + arg2;;

(* This function takes an optional argument with a default value of 8, and a required argument. 
   If the optional argument is not provided, it defaults to 8. *)


(* Partial Application

* The following functions are syntatically different but semantically equivalent.
*)

let add x y = x + y;; 
let add x = fun y -> x + y;; 
let add = fun x -> (fun y -> x + y);; 