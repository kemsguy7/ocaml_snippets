let print_stat name num =
    print_string name; 
    print_string ": "; 
    print_float num; 
    print_newline ();;

print_stat "Mean" 3.14;;
print_stat "Variance" 1.59