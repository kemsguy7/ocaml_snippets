(* Higher order functions   *)

(* Deriving Map *)

let rec map f = function 
  | [] -> []
  | h :: t -> f h :: map f t 


(* [add1 lst] adds 1 to each element of [slt]. *)
let add1 = map (fun x -> x + 1)


(** [concat_bang lst] concatenates "!" to each element of [lst]. *)
let concat_bang = map (fun x -> x ^ "!")



