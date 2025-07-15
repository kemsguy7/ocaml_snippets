let rec list_max xs = 
  match xs with 
  | [] -> failwith "list_max called on empty list"
  | [x] -> (* single element list: return the element *)x 
  |x :: remainder ->  (* multiple element list: recursive case*) max x (list_max remainder);; 
