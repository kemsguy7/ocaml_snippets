open OUnit2 
open Weekday 
(* 
let tests = "test suite for next_weekday" >::: [ 
    "tue_after_mon" >:: (fun _ -> assert_equal Tuesday (next_weekday Monday));
    "wed_after_tue" >:: (fun _ -> assert_equal Wednesday (next_weekday Tuesday));
    "thu_after_wed" >:: (fun _ -> assert_equal Thursday (next_weekday Wednesday));
    "fri_after_thu" >:: (fun _ -> assert_equal Friday (next_weekday Thursday));
 ]  *)



 (* Abstracting a function that creates test cases for next_weekday to avoid repetion*)
 
let make_next_weekday_test name expected_output input = 
    name >:: (fun _ ->  assert_equal expected_output (next_weekday input))

let tests = "test suite for next_weekday" >::: [ 
    make_next_weekday_test "tue_after_mon" Tuesday Monday;
    make_next_weekday_test "wed_after_tue" Wednesday Tuesday;
    make_next_weekday_test "thu_after_wed" Thursday Wednesday;
    make_next_weekday_test "fri_after_thu" Friday Thursday;
    make_next_weekday_test "sat_after_fri" Saturday Friday;
    make_next_weekday_test "sun_after_sat" Sunday Saturday;

    (* handling weekends *)

   make_next_weekday_test "mon_fter_fri" Monday Friday; 
   make_next_weekday_test "mon_after_sat" Monday Saturday; 
   make_next_weekday_test "mon_after_sun" Monday Sunday;

    (* Adding a test for an unimplemented case *)
    (* This will fail until we implement the case in the next_weekday function *)

    (* Adding a test for the unimplemented case *)
    "unimplemented_case" >:: (fun _ -> assert_raises (Failure "Unimplemented") (fun () -> next_weekday Sunday));
]

let _ = run_test_tt_main tests 