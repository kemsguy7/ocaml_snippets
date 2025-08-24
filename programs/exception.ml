 let test x y = 
  try let q = x / y in Printf.printf "quotient = %d\n" q 
  with Division_by_zero -> Printf.printf "error\n";; 


let () = Printf.printf "Testing division: %d / %d\n" 10 2; test 10 2;


Printf.printf "Testing division: %d / %d\n" 10 0;
  test 10 0
