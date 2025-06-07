
(*Two equvalent ways of squaring 6*)
let square x = x * x;; 
square (inc 5);;

5 |> inc |> square ;;  (*uses the pipeline operato to 5 through the inc function, then send the result of that through the square function *)


