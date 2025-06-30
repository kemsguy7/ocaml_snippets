let max = read_int () 

let prime = Array.make (max + 1) true 

let () = 
  prime.(0) <- false; 
  prime.(1) <- false; 
  let limit = truncate (sqrt (float max)) in 
  for n = 2 to limit do 
    if prime.(n) then begin 
      let m = ref (n * n) in 
      while !m <= max do  
        prime.(!m) <- false; 
        m := !m + n 
       