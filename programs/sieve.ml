let max = read_int ()  (*store the integer in this value*)

let prime = Array.make (max + 1) true 

let () = 
  prime.(0) <- false;  (*can also write this as Array.set prime 0 false *)
  prime.(1) <- false; 
  let limit = truncate (sqrt (float max)) in 
  for n = 2 to limit do   (* main loop. of the sieve iterates over integers from 2 to limit  testing whether each is prime  *)
    if prime.(n) then begin 
      let m = ref (n * n) in 
      while !m <= max do  
        prime.(!m) <- false; 
        m := !m + n 
      done 
    end 
  done    

let () =  (*Display the prime numbers using this loop *)
  for n = 2 to max do 
    if prime.(n) then Printf.printf "%d\n" n 
  done 



