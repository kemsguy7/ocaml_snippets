let year = read_int ()
let leap =
  (year mod 4 = 0 && year mod 100 <> 0) || year mod 400 = 0 
let msg = if leap then "is" else "is not" 
let () = Printf.printf "%d %s a leap year\n" year msg   


