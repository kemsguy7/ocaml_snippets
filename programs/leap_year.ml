(*let year = read_int  *)

(* rather than reading the  year from the standard input, we can pass it on the command line *)
let year = int_of_string Sys.argv.(1)
let leap =
  (year mod 4 = 0 && year mod 100 <> 0) || year mod 400 = 0 
let msg = if leap then "is" else "is not" 
let () = Printf.printf "%d %s a leap year\n" year msg    (* used to maintain the smae formate in case of expression that do not return a value *)


