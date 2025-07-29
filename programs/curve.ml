let n = read_int () 

let read_pair () = 
  let x = read_int () in 
  let y = read_int () in 
  (x, y) 

let data = Array.init n (fun i -> read_pair ())

let compare (x1, y1) (x2, y2) = x1 - x2 
let () = Array.sort compare data  


open Graphics 
let () = 
  open_graph " 200x200";
  set_line_width 3; 
  let (x0, y0) = data.(0) in moveto x0 y0; 
  for i = 1 to n-1 do 
    let (x,y) = data.(i) in 
    lineto x y 
  done; 
  ignore (read_key ())