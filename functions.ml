
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


(*Defining an infix operator*)
let ( ^^ ) x y = max x y;; 
2 (^^) 3;; (* This uses the infix operator we just defined to find the maximum of 2 and 3 which will result in number 3 *)

let rec count n = 
  if n = 0 then 0 else 1 + count (n - 1) 

 (* same funciton above but making it tail recursive*) 
let rec count_aux n acc = 
  if n = 0 then acc else count_aux (n -1) (acc + 1) 


(** [fact n] is [n] factorial. *)
let rec fact n = 
  if n = 0 then 1 else n * fact (n - 1) 


(*another example of tail recursive function *)

(* This is a tail recursive version of the factorial function. 
   It uses an accumulator to store the result as it recurses, 
   which allows it to avoid growing the call stack. *)

   (*original*)

let rec fact n = 
  if n = 0 then 1 else n * fact (n - 1);;

 let rec fact_aux n acc = 
         if n = 0 then acc else fact_aux (n - 1) (n * acc) 
     
       let fact_tr n = fact_aux n 1;;
