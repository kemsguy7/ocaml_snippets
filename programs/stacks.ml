module type LIST_STACK = sig 
  
  (** [EMPTY] is raised when an operation cannot be applied to an empty stack *)
  exception Empty 

  (** [empty] is the empty stack. *)
  val empty : 'a list  

  (** [is_empty s] is whether [s] is empty *)
  val is_empty  : 'a list -> bool 

  (** [push x s] pushes [x] onto the top of [s]. *)
  val push : 'a-> 'a list -> 'a list 

  (** [peek s] is the top element of [s]. Raises [Empty] is [s] is empty. *)
  val peek : 'a list -> 'a 

  (** [pop s] is all but the top Element of [s]. 
    Raises [Empty] if [s] is empty. *)  
  val pop : 'a list -> 'a list 
end


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