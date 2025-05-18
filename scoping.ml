let x = 10
let y = x + 2
let x = 20 
let () = Printf.printf "x=%d y=%d\n" x y


(* Adding For loop evaluation code *)
let () = 
  for i = (Printf.printf "*"; 0) to (Printf.printf "."; 5) do 
    Printf.printf "%d" i 
  done

(* If the value of e1 is greater than e2 ,the body of the loop never gets executed *)

(* variant of a for construct that goes backwards*)
let () = 
  for  i = 9 downto 0 do 
    Printf.printf "%d\n" i 
  done  