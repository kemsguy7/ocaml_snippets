module ListStack  = struct 
  type 'a stack = 'a list 
  
  let empty = []

  let push x s = 
    x :: s 

  let peek = function 
    | [] -> failwith "Empty"
    |  x :: _ -> x 

  let pop = function 
    | [] -> failwith "Empty"
    | _ :: s -> s 

end 

let x = ListStack.peek (ListStack.push 42 ListStack.empty)

(* Another way to write scope will be using the pipe operator *)
let y = ListStack.(empty |> push 42 |> peek )


(* let open M in e make the names from  [M] be in scope in [e] *) (*M stands for module name *)

(* The code above can also be rewritten using a local open *)
let = w 
  let open ListStack in
  empty |> push 42 |> peek  

 (* can also be rewritten using a global open *) 
 open ListStack 
  let v = empty |> push 42 |> peek  