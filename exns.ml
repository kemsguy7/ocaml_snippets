let safe_div x y = 
  try x / y with 
  | Division_by_zero -> 0 