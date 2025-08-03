
(* Function Examples*) 

let upcase_first_entry line = 
  let (first :: rest) =  String.split ~on:',' line in
  String.concat ~sep:"," (String.uppercase first :: rest);;

  (* This funcitons takes a list, splits applies string functions to it *)
let transforms = [ String.uppercase; String.lowercase ];;
 List.map ~f:(fun g -> g "Hello World") transforms;;


 (* Functions can be named the same way other variables are named by using let bindings  *)
 let plusone = (fun x -> x + 1);; 

 (* Addung a syntatic sugar for same funciton above (equivalent*)
 let plusone x = x + 1;; 


 (* Multiargumant Functions *)
let abs_diff x y = abs (x - y);; 
abs_diff 3 4;; 

(* rewriting function above in an equivalent form: curried *)
let abs_diff = (fun x -> (fun y -> abs (x - y)));;

(* Using the curried function : partial application *)


(*currying is a technique that allows us to transform a function that takes multiple arguments into a sequence of functions that each take a single argument. This is useful for creating more flexible and reusable functions.*)

let dist_from_3 = abs_diff 3;; 
dist_from_3 4;; 


(* Using Different parts of a tuple as different arguments*)
let abs_diff (x, y) = abs (x - y);; 
abs_diff (3, 4);; 



(* Declaring Functions with functions *)
let  some_or_zero = function 
  | Some x -> x 
  | None -> 0;; 
List.map ~f:some_or_zero [Some 3; None; Some 4];; 

(* The block of code above is equivalent to combining an ordinary function definition with a match *)

let some_or_zero num_opt = 
  match num_opt with 
  | Some x -> x 
  | None -> 0;; 


(* Declaring a two-argument (curried) function with a pattern match on the second argument *)

let some_or_default default = function 
  | Some x -> x 
  | None  -> default;; 
  
some_or_default 3 (Some 5);; 

List.map ~f:(some_or_default 100) [Some 3; None; Some 4];; 


(* Labelled Arguments*)
let ratio ~num ~denom = Float.of_int num /. Float.of_int denom;;   
ratio ~num:3 ~denom:10;; 


(* Labelled arguments allow us to specify the names of the arguments when calling the function, making it clearer what each argument represents. *)

(* Label Punning  *)
let num = 3 in 
let denom = 4 in 
ratio ~num ~denom;;

(*optional arguments : is like a labelled argument that the caller can choose to provide or not provide *)

let concat ?sep x y = 
  let sep  = match sep with None -> "" | Some s -> s in  
  x ^ sep ^ y;; 
concat "Hello" "World";; (* Using the optional argument with a default value : foobar *)
concat ~sep:" " "Hello" "World";; (* Using the optional argument with a specified value : foo:bar*)


(* more concise pattern *)
let concat ?(sep="") x y = x ^ sep ^ y;; 




