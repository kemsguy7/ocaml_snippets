(* sample code for adding function traces to debug a program or function*)

let rec fib x = if x <= 1 then 1 else fib (x -1) + fib (x - 2);; 
#trace fib;; 

