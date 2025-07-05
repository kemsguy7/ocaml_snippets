(* freq.ml
   A simple program to count the frequency of lines from standard input.
   It outputs the top 10 most frequent lines along with their counts. *)
(* This program reads lines from standard input, counts their occurrences,
  open Base
open Stdio
*)
open Base
open Stdio

let build_counts () = (*defines a function with no arguments, hence empty parentheses *)
  In_channel.fold_lines In_channel.stdin ~init:[] ~f:(fun counts line ->
      let count =
        match List.Assoc.find ~equal:String.equal counts line with
        | None -> 0
        | Some x -> x
      in
      List.Assoc.add ~equal:String.equal counts line (count + 1))

let () =
  build_counts ()
  |> List.sort ~compare:(fun (_, x) (_, y) -> Int.descending x y)
  |> (fun l -> List.take l 10)
  |> List.iter ~f:(fun (line, count) -> printf "%3d: %s\n" count line)


(* The program reads lines from standard input, counts their occurrences,
   sorts them in descending order by count, takes the top 10, and prints them.
   It uses Base and Stdio libraries for functional programming constructs and I/O operations. *)


(* 
sample test with dune and grep : rectory: ./build/default/freq.exe
mac@Kemsguy7 programs % grep -Eo '[[:alpha:]]+' freq.ml | dune exec ./freq.exe

*)