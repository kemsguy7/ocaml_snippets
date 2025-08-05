
type service_info = 
 {service_name : string; 
   port : int; 
   protocol : string;};;


let service_info_of_string line =  
  let matches =  
    let pat = "([a-zA-Z]+)[ \t]+([0-9]+)/([a-zA-Z]+)"   in 
    Re.exec (Re.Posix.compile_pat pat) line 
  in 
  { 
    service_name = Re.Group.get matches 1; 
    port = Int.of_string (Re.Group.get matches 2); 
    protocol = Re.Group.get matches 3; 
  };;
