let rec sum xs = 
   match xs with 
   | [] -> 0  
   | h::t -> h + sum t



let rec sum xs = 
   match xs with 
   | [] -> 0  
   | x ::xs' -> x + sum xs' 

  (*both codes above are same can be written in a one-liner too and the first  | after the match keyword is optional *)

  let rec append lst1 lst2 = 
    match lst1 with 
    | [] -> lst2  
     | h::t -> h:: append t lst2;;
(* append function takes two lists and appends the first list to the second list *) 


(* function to determine if a list is empty*) 

let empty lst = 
  match lst with 
  | [] -> true 
  | h :: t -> false 

  (*writing same function without pattern matching *)
  let empty list  = 
    lst = []