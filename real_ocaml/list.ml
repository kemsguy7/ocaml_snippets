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

   


