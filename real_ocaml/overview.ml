

(* TUPLES *)
let a_tuple = (3 , "three");;
let another_tuple=(3,"four",5.);;

(** you can extract the components of a tuple using ocaml's pattern-matching syntax as shown below:  *)

let (x, y) = a_tuple in
x + String.length y;; 

(* Function for compmuting the distance between 2 points rr *)
let distance (x1,y1) (x2, y2) = 
  Float.sqrt ((x1 -. x2) ** 2. +. (y1 -. y2) ** 2.);; 