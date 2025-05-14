print_string "hello world\n";; 

(* This is a comment in OCaml *)

(* This is a multi-line comment
   in OCaml *)

(* This is a function that takes two integers and returns their product *)
(* The function is defined using the let keyword, followed by the function name,
   the parameters in parentheses, and the return type after the colon. *)



(* The function body is defined using the equal sign and the expression to be evaluated. *)
(* let calculator (input_one: int) (input_two: int) : int =   
  input_one * input_two;; 

print_int (calculator 4 5);;
print_string "\n";;           *)



(*  This is a function that uses another variable to hold it's function parameters for more operations withnin the function   *)
let calculator (input_one: int) (input_two : int) : int = 
  let product = input_one * input_two in
   product + 1;;

print_int (calculator 4 6);;


let is_zero (x: int) : string = 
  match x with 
  | 0 -> "true" 
  | _ -> "false";; 

  print_string("\n");;
  print_string (is_zero 0);;


let y : int list = [1;2;3];;
(* 
let is_list_empty (1: int list) : int = 
  begin match 1 with 
  | [] -> 1 
  | h::t -> 0 
  end;; 

  1::[2;3] 

 print_int (is_list_empty y);; *)


 