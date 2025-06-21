type primary_color = Red | Green | Blue 

let r = Red 

type point = float * float  

type shape = 
  | Circle of {center  : point; radius : float}
  | Rectangle of  {lower_left : point; upper_right : point} 
  | Point of point

  let c1  = Circle {center = (0., 0.); radius = 1. }
  let r1 = Rectangle { lower_left = (-1., -1.);  upper_right = (1., 1.)}  

  let p1 = Point (31., 10.)

  let avg a b = 
    (a +. b) /. 2. 

    (*figure out what the center of the shape is *)
(* let center s = 
  match s with  
  | Circle {center; radius} -> center 
  | Rectangle {lower_left; upper_right} ->  
    let (x_ll , y_ll) = lower_left in 
    let (x_ur, y_ur) = upper_right in 
    (avg x_ll x_ur, avg y_ll y_ur) *)


    let center s = 
  match s with  
  | Circle {center; radius} -> center 
  | Rectangle {lower_left = (x_ll, y_ll);  
               upper_right = (x_ur, y_ur)} ->  
    
    (avg x_ll x_ur, avg y_ll y_ur) 
    | Point (x, y) -> (x, y)

(* A couple of functions that could use the shape type *)
let area = function 
  | Point  _ -> 0.0
  | Circle (_, r) -> Float.pi *. (r ** 2.0)  
  | Rect ((x1, y1), (x2, y2)) ->  
      let w = x2 -. x1 in  
      let h  = y2 -. y1 in  
      w *. h 

let center = function 
    | Point p -> p 
    | Circle (p, _) -> p
    | Rect ((x1, y1), (x2, y2)) -> ((x2 +. x1) /. 2.0, (y2 +. y1) /. 2.0 )