
(** remove surrounding whitespace from [s] and convert it to lower case *)

let s = "BigRed" 
let s' = s |> String.trim |> String.lowercase_ascii (*long way *)
let s'' = String.(s |> trim |> lowercase_ascii ) (* short way*)



(* bringing a module into the scope *)
(** [lower_trim s] is [s] in lower case with whitespace removed *)
let lower_trim = 
  let open String in 
  s |> trim |> lowercase_ascii 



