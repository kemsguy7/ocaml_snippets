open OUnit2 
open Weekday 

let tests = "test suite for next_weekday" >::: [ 
    "tue_after_mon" >:: (fun _ -> assert_equal Tuesday (next_weekday Monday));
 ] 

 let _ = run_test_tt_main tests