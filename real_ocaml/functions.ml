
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
let dist_from_3 = abs_diff 3;; 
dist_from_3 4;; 

(* Using the curried function : partial application *) 