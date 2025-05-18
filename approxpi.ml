let n = read_int() 

let () = 
  let p = ref 0 in (* p  is a variable that takes a referecne of 0 *)
  
  for k = 1 to n do (* start of thr for loop *)
    let x =  Random.float 1.0 in 
    let y =  Random.float 1.0 in 
    if x *. x +. y *. y <= 1.0 then (*increases the contents of the reference p if the point (is within the quartr circle, that is, if x2 + y2 ≤ 1 ) *)
      p := !p + 1 
  done; 
  let pi = 4.0 *. float !p /. float n in  (* the float function  defined in Stdlib module is used to convert integers into floats *)
  Printf.printf "%f\n" pi  

