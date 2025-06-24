open Async


(* using bind to replace a file with uppercase versions of it's contents *)

let uppercase_file filename =
  Deferred.bind (Reader.file_contents filename)
    ~f:(fun text ->
      Writer.save filename ~contents:(String.uppercase text))
  (* call the function *)
  uppercase_file "test.txt";;

  Reader.file_contents  "test.txt";;








