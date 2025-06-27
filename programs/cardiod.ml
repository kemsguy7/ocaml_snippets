open Graphics 

let () = open_graph " 300 *200"

let () = 
  moveto 200 150;
  for i = 0 to 200 do  (* use a for loop to vary the and tether between 0 and 2 PI *)
    let th = atan 1. *. float i /. 25. in  (*arctangent is calculated using the function atan of the standard Library Stdlib *)
    let r = 50. *. (1. -. sin th) in 
    lineto (150 + truncate (r *. cos th))
            (150 + truncate (r *. sin th))
  done;
  ignore (read_key ()); 

  