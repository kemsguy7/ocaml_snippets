
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


 