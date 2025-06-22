(* These are programs that constructs a trees like the one below *)

(*


           4
          /  \
        2      5           
      /  \    / \    
      1  3    6  7

*)

type 'a tree =  (* Alpha type shows that this type can be a string , int or float *)
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


(* Rewriting binary tree with Records *)
type 'a tree = 
  | Leaf  (* Lead will always be empty *)
  | Node of 'a node 

and 'a node = { 
  value : 'a;
  left: 'a tree; 
  right : 'a tree
}

let rt = Node { 
  value = 2; 
  left = Node {value =1; left = Leaf; right = Leaf};
  right = Node {value=3 ; left = Leaf; right = Leaf}
}
(*Try adding in another level of nesting *)



