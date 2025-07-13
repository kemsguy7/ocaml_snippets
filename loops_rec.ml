let my_list = [1;2;3;4;5;6;7;8];;

let f elem =
   Printf.printf "I'm looking at element %d now\n" elem 
   in 
   List.iter f my_list;; 

let mystring = "aeiouot";;
let s elem = Printf.printf "I am looking for each character in %C\n" elem;;
String.iter s mystring;;
(* This code defines a string `mystring` containing vowels and the letter 't'.
   It then uses `String.iter` to apply the function `s` to each character in the string.
   The function `s` prints a message indicating which character is being processed. *)