(*

To limit scope of variables, we use cna use this expression : 
M.(e) 
Inside e. all the names from M are in scope.

exampels below
*)

(* remove surrounding whitespace from. [s] and convert it to lower case  *)
let s = "BigRed "
let s' = s |> String.trim |> String.lowercase_ascii (* long way *)
let s'' = String.(s |> trim |> lowercase_ascii) (* short way *) 


(* To bring the above module into scope for an entire function or large code block, you can use the expression. let open M in e  *)

(** [lower_trim s] is [s] in lower case with whitespace removed  *)
let lower_trim s = 
  let open String in  
  s |> trim |> lowercase_ascii