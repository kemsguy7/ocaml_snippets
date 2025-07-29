let rec fib_slow n =
    if n <= 1 then n 
    else fib_slow (n - 1) + fib_slow (n - 2);; 

(* running the program*)
let () = Printf.printf "fib_slow 35 = %d\n" (fib_slow 35);;