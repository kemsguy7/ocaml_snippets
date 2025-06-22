(* These are programs that constructs a trees like the one below *)

(*


           4
          /  \
        2      5           
      /  \    / \    
      1  3    6  7

*)

type 'a tree = 
  | Leaf 
  | Node of 'a * 'a tree * 'a tree 

(* Representataion with Tuples *)
let t = ( 
  Node (4, 
    Node (2, 
      Node (1, Leaf, Leaf), 
      Node (3, Leaf, Leaf)
    ),
    Node(5, 
      Node(6, Leaf, Leaf), 
      Node(7, Leaf, Leaf)
    )
  )
)

