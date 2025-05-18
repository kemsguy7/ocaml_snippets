let x = 10
let y = x + 2
let x = 20 
let () = Printf.printf "x=%d y=%d\n" x y


(* Adding For loop evaluation code *)
let () = 
  for i = (Printf.printf "*"; 0) to (Printf.printf "."; 5) do 
    Printf.printf "%d" i 
  done