open OUnit2 
open Weekday 

let tests = "test suite for next_weekday" >::: [ 
    "tue_after_mon" >:: (fun _ -> assert_equal Tuesday (next_weekday Monday));
    "wed_after_tue" >:: (fun _ -> assert_equal Wednesday (next_weekday Tuesday));
    "thu_after_wed" >:: (fun _ -> assert_equal Thursday (next_weekday Wednesday));
    "fri_after_thu" >:: (fun _ -> assert_equal Friday (next_weekday Thursday));
 ] 

 let _ = run_test_tt_main tests 
