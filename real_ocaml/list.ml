let rec sum l = 
  match l with 
  | [] -> 0 
  | hd :: tl -> hd + sum tl;; 

  sum [1;2;3];; 

  sum []; 


(* recursive function and pattern matching list*)
let rec drop_value l to_drop =
  match l with  (* The match expression is used to destructure the list l *)
  | [] -> []  (* If the list is empty, return an empty list *) 
  | to_drop :: tl -> drop_value tl to_drop  (* checks if the first element of the list is exactly to_drop *)
  | hd :: tl -> hd :: drop_value tl to_drop;; 


  (*  case 2 : First element matches to_drop, so we skip it and recursively process the rest of the list *)
  (*
  | to_drop :: tl -> drop_value  : checks if the first element of the list is exactly equal to to_drop 
   - :: separates the first element from the rest of the list 
  
  - tl stands for "tail" (the rest of the list after the first element).  
  
  - drop_value tl to_drop : if the first element matches, we skip it and recursively process the rest of the list  

  
    
  *)
 

  (* Case 3: First Element Doesn't Match
  
  hd:: tl -> hd :: drop_value tl to_drop 

  | hd:tl : This matches any list where the first elemnent (called hd for "head") doesn't match to_drop. 

  -> hd :: drop_value tl to_drop : We keep hd recursively process the rest of the list then combine them . 
   *)


#require "core_bench";; 
(* List.fold *)
List.fold ~init:0 ~f:(+) [1;2;3;];; 

(* using fold to reverese a list in which case the accumulator is itself a list *)
List.fold ~init:[] ~f:(fun acc hd -> hd :: acc) [1;2;3;4];;

(* Using the 3 list functions to conpute maximum colum widths*)
let max_widths header rows = 
  let lengths l = List.map ~f:String.length l in 
  List.fold rows 
    ~init: (lengths header) 
    ~f:(fun acc row ->  
      List.map2_exn ~f:Int.max acc (lengths row));; 





