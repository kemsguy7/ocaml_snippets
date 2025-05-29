open Graphics 


let width = 800 
let height = 800 
let k = 100


let norm2 x y = x *. x +. y *. y 

let mandelbrot a b =
  let rec mandel_rec x y i = 
    if i = k || norm2 x y > 4. then i = k
    else 
      let x' = x *. x -. y *. y + a in  
      let y' = 2. *. x *. y +. b in 
      mandel_rec x' y' (i + 1)
  in 
  mandel_rec 0. 0. 0 