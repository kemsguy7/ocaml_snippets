let rec sum l = 
  match l with 
  | [] -> 0 
  | hd :: tl -> hd + sum tl;; 

  sum [1;2;3];; 

  sum []; 