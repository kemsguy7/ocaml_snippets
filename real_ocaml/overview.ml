

(* TUPLES *)
let a_tuple = (3 , "three");;
let another_tuple=(3,"four",5.);;

(** you can extract the components of a tuple using ocaml's pattern-matching syntax as shown below:  *)

let (x, y) = a_tuple in
x + String.length y;;