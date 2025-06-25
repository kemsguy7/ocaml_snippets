(* Higher order functions   *)

(* Deriving Map *)

let rec map f = function 
  | [] -> []
  | h :: t -> f h :: map f t 


(* [add1 lst] adds 1 to each element of [slt]. *)
let add1 = map (fun x -> x + 1)
add1 [4;5;5]


(** [concat_bang lst] concatenates "!" to each element of [lst]. *)
let concat_bang = map (fun x -> x ^ "!")
concat_bang [2;4;5]


(* Filter *)
(** [even n] is whether [n] is even. *)
let even n = 
  n mod 2 = 0 

(** [even lst] is the sublist of [lst] containing only even numbers. *)
let rec evens = function 
  | [] -> []
  | h :: t -> if even h then h :: evens t else evens t 

let lst1  = evens [ 1; 2; 3; 4] 


(** [odd n] is whether [n] is odd *)
let odd n = 
  n mod 2 <> 0 


(** [odds lst] is the sublist of [lst] containing only odd numbers. *)
let rec odds = function 
  | [] -> []
  | h ::t -> if odd h then h :: odds t else odds t 

let lst2 = odds [1; 2; 3; 4]



let rec filter p = function 
  | [] -> []
  | h :: t -> if p h then h :: filter p t else filter p t   