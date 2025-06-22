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

(*
          2 
        /   \
      1      3 
*)

let rt = Node { 
  value = 2; 
  left =Node {value =1; left = Leaf; right = Leaf};
  right = Node {value=3 ; left = Leaf; right = Leaf}
}

(*Try adding in another level of nesting *)

  (*
           2
          /  \
        1      3           
      /  \        
      5   7    

*)

let rt = 
  Node { 
    value = 2; 
    left = Node {  (* Left subtree: Node 1 with its own left/right *)
      value = 1; 
      left = Node { value = 5; left = Leaf; right = Leaf };  (* Nested left *)
      right = Node {value = 7; left= Leaf; right = Leaf }; 
    }; 
    right = Node { 
      value = 3; 
      left = Leaf; 
      right = Leaf 
    } 
  }


  (*traversing the tress with pattren matching *)
(** [mem x t] is whether [x] is a value at some node in tree [t]. **)

let rec mem x = function 
  | Leaf -> false 
  | Node {value; left; right} -> value = x || mem x left || mem x right