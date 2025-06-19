 let rec list_max = function 
  | [] -> None 
  | h :: t -> begin 
     match list_max t with  
        | None -> Some h 
        | Some m -> Some (max h m)
      end;;   

