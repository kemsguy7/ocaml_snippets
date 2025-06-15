open OUnit2 
open Sum 

(* test cases for teh sum function *)
(* let tests = "test suit for sum" >::: [ 
  "empty" >:: (fun _ -> assert_equal 0 (sum []));
  "singleton" >:: (fun _ -> assert_equal 1 (sum [1]));
  "two_elements" >:: (fun _ -> assert_equal 3 (sum [1; 2]));
] *)



(*rewriting test suite to print better error messages *)
let tests = "test suit for sum" >::: [ 
  "empty" >:: (fun _ -> assert_equal 0 (sum []) ~printer:string_of_int);
  "singleton" >:: (fun _ -> assert_equal 1 (sum [1]) ~printer:string_of_int);
  (* using ~printer to print the expected and actual values in case of failure *)
  "two_elements" >:: (fun _ -> assert_equal 3 (sum [1; 2]) ~printer:string_of_int);
]


let _ = run_test_tt_main tests  
