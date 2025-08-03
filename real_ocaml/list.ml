let rec sum l = 
  match l with 
  | [] -> 0 
  | hd :: tl -> hd + sum tl;; 

  sum [1;2;3];; 

  sum []; 


(* recursive function and pattern matching list*)
let rec drop_value l to_drop =
  match l with  (* The match expression is used to destructure the list l *)
  | [] -> []  (* If the list is empty, return an empty list *) 
  | to_drop :: tl -> drop_value tl to_drop  (* checks if the first element of the list is exactly to_drop *)
  | hd :: tl -> hd :: drop_value tl to_drop;; 


  (*  case 2 : First element matches to_drop, so we skip it and recursively process the rest of the list *)
  (*
  | to_drop :: tl -> drop_value  : checks if the first element of the list is exactly equal to to_drop 
   - :: separates the first element from the rest of the list 
  
  - tl stands for "tail" (the rest of the list after the first element).  
  
  - drop_value tl to_drop : if the first element matches, we skip it and recursively process the rest of the list  

  
    
  *)
 

  (* Case 3: First Element Doesn't Match
  
  hd:: tl -> hd :: drop_value tl to_drop 

  | hd:tl : This matches any list where the first elemnent (called hd for "head") doesn't match to_drop. 

  -> hd :: drop_value tl to_drop : We keep hd recursively process the rest of the list then combine them . 
   *)


#require "core_bench";; 
(* List.fold *)
List.fold ~init:0 ~f:(+) [1;2;3;];; 

(* using fold to reverese a list in which case the accumulator is itself a list *)
List.fold ~init:[] ~f:(fun acc hd -> hd :: acc) [1;2;3;4];;

(* Using the 3 list functions to conpute maximum colum widths*)
let max_widths header rows = 
  let lengths l = List.map ~f:String.length l in 
  List.fold rows 
    ~init: (lengths header) 
    ~f:(fun acc row ->  
      List.map2_exn ~f:Int.max acc (lengths row));; 


(*Writing the code to generate the line that seperates the header from the rest of the text table *)

let render_separator widths = 
  let pieces = List.map widths  
    ~f:(fun w -> String.make w '-') 
  in 
  "|-" ^ String.concat ~sep:"-+-" pieces ^ "-|";; 

  render_separator [3;6;2];; (* calling the function *)

  (* Function for padding out a string to a specified Length *)
  let pad s length = 
    s ^ String.make (length - String.length s) ' ';;
  pad "hello" 10;; (* calling the function *) 
  
(* Function to render a single row of the table *) 
let render_row row widths = 
  let padded = List.map2_exn row width ~f:pad in
  "| " ^ String.concat ~sep: " | " padded ^ " | ";; 

render_row ["Hello"; "World"] [10;15];; (* calling the function *)

(* Function to render the entire table *)
let render_table header rows =  
  let widths = max_widths header rows in 
  String.concat ~sep:"\n" 
    (render_row header widths  
      :: render_separator widths 
      :: List.map rows ~f:(fun row -> render_row row widths)
    );; 


(*filter*)
  List.filter ~f:(fun x -> x % 2 = 0) [1;2;3;4;5];; 

(* Filter with map *)

let extensions filenames = 
  List.filter_map filenames ~f:(fun fname -> 
    match String.rsplit2 ~on:'.' fname with 
    | None | Some ("",_) -> None 
    | Some (_, ext) -> 
      Some ext )
    |> List.dedup_and_sort ~compare:String.compare;; 

  (*example call*)
  extensions ["foo.c"; "foo.ml"; "ba.ml"; "bar.mli"];; 


  (* Tail Recursion *)
  (*
  
  The only way ton compute the length of an ocaml list is to walk the list from the beginning to the end, counting each element as we go.
  
  A linear opertion and it takes a time linear to the size of the list
  
  *)
    
  (* example 1*) 
  let rec length = function 
      | [] -> 0  
      | _ :: tl -> 1 + length tl;;  
  (* example call *)
  length [1;2;3];; (*will give 3*) 
  
  (* function to make list *)
  let make_list n = List.init ~f:(fun x -> x);;
length (make_list 1000000);;
(*for large lists, the example above will run it a stack overflow error*)


  (* example 2 *) 
let rec length_plus_n l n = 
  match l with 
  | [] -> n 
  | _ :: tl -> length_plus_n tl (n + 1);;

let length l = length_plus_n l 0;; 