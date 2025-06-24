# OCaml Learning Roadmap for Dune's Fiber and Memo Systems

## Syntax and Language Features Found in the Documentation

### Core Syntax Patterns

#### Type Definitions
```ocaml
(* Phantom/parameterized types *)
type 'a t
type 'a fiber := 'a t

(* Variant types *)
type 'a outcome =
  | Cancelled of 'a
  | Not_cancelled

(* Record types *)
type 'a t =
  { ivar : 'a Fiber.Ivar.t
  ; dag_node : Lazy_dag_node.t
  }

(* GADT-style existential types *)
type packed = T : (_, _) t -> packed [@@unboxed]

(* Module type constraints *)
type ('input, 'output) t
```

**Learning Resources:**
- **OCaml Manual**: [Types and Type Expressions](https://ocaml.org/manual/types.html)
- **Real World OCaml**: [Chapter 6 - Variants](https://dev.realworldocaml.org/variants.html)
- **Real World OCaml**: [Chapter 7 - Records](https://dev.realworldocaml.org/records.html)
- **Interactive Tutorial**: [Try OCaml - Types](https://try.ocaml.pro/learn/description/main/tour/01_00_basic_types)
- **Video**: [OCaml MOOC - Week 2](https://www.youtube.com/playlist?list=PLF05CcVXrQYo8oIRh2xUEq6TsRY6h2g7P)

#### Infix Operators
```ocaml
val ( >>> ) : unit t -> 'a t -> 'a t
val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t  
val ( >>| ) : 'a t -> ('a -> 'b) -> 'b t
val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
val ( let+ ) : 'a t -> ('a -> 'b) -> 'b t
val ( and* ) : 'a t -> 'b t -> ('a * 'b) t
val ( and+ ) : 'a t -> 'b t -> ('a * 'b) t
```

**Learning Resources:**
- **OCaml Manual**: [Operators](https://ocaml.org/manual/expr.html#ss:expr-operators)
- **Real World OCaml**: [Chapter 2 - Operators](https://dev.realworldocaml.org/variables-and-functions.html#operators)
- **Tutorial**: [Custom Operators in OCaml](https://ocaml.org/learn/tutorials/custom_operators.html)
- **Blog Post**: [Let Syntax and Monads](https://blog.janestreet.com/let-syntax-and-why-you-should-use-it/)
- **GitHub**: [ppx_let examples](https://github.com/janestreet/ppx_let/tree/master/example)

#### Pattern Matching
```ocaml
match x with
| true -> y ()
| false -> return ()

match res with
| Ok res -> Fiber.return (Ok res)
| Error errors -> Error errors

let+ stack = get_call_stack () in
match stack with
| [] -> Ok (), edges_added
| frame :: stack -> (* ... *)
```

**Learning Resources:**
- **OCaml Manual**: [Pattern Matching](https://ocaml.org/manual/patterns.html)
- **Real World OCaml**: [Chapter 3 - Pattern Matching](https://dev.realworldocaml.org/lists-and-patterns.html)
- **Interactive**: [Learn X in Y Minutes - OCaml](https://learnxinyminutes.com/docs/ocaml/)
- **Practice**: [99 Problems - Pattern Matching](https://ocaml.org/learn/tutorials/99problems.html)
- **Video**: [Pattern Matching Deep Dive](https://www.youtube.com/watch?v=kDlXIjXJwVg)

#### Function Types and Signatures
```ocaml
(* Higher-order functions *)
val map : 'a t -> f:('a -> 'b) -> 'b t
val bind : 'a t -> f:('a -> 'b t) -> 'b t

(* Functions with labeled arguments *)
val create : 'a -> name:string -> 'a t
val set : 'a t -> 'a -> Invalidation.t

(* Optional arguments *)
val create
  :  ?cutoff:('a -> 'a -> bool)
  -> ?name:string  
  -> (unit -> 'a memo)
  -> 'a t

(* Functions returning functions *)
val fork_and_join : (unit -> 'a t) -> (unit -> 'b t) -> ('a * 'b) t
```

**Learning Resources:**
- **OCaml Manual**: [Function Types](https://ocaml.org/manual/types.html#s%3Atype-expr)
- **Real World OCaml**: [Chapter 2 - Functions](https://dev.realworldocaml.org/variables-and-functions.html)
- **Tutorial**: [Labeled and Optional Arguments](https://ocaml.org/learn/tutorials/labels.html)
- **CS3110**: [Higher-Order Functions](https://cs3110.github.io/textbook/chapters/hop/intro.html)
- **Practice**: [Exercism OCaml Track](https://exercism.org/tracks/ocaml)

### Module System Features

#### Module Signatures
```ocaml
module type Input = sig
  type t
  include Table.Key with type t := t
end

module type S = sig
  include Monad.S
  val of_memo : 'a memo -> 'a t
end
```

**Learning Resources:**
- **OCaml Manual**: [Module Expressions](https://ocaml.org/manual/modules.html)
- **Real World OCaml**: [Chapter 9 - Functors](https://dev.realworldocaml.org/functors.html)
- **Real World OCaml**: [Chapter 10 - First-Class Modules](https://dev.realworldocaml.org/first-class-modules.html)
- **Tutorial**: [Module System Tutorial](https://ocaml.org/learn/tutorials/modules.html)
- **Advanced**: [Modular Implicits Paper](https://arxiv.org/abs/1512.01895)

#### Module Implementations
```ocaml
module O : sig
  val ( >>> ) : unit t -> 'a t -> 'a t
  val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
end

module List = struct
  include Monad.List (Fiber)
  let map = parallel_map
end
```

**Learning Resources:**
- **OCaml.org**: [Module System Basics](https://ocaml.org/docs/modules)
- **CS3110**: [Modules Chapter](https://cs3110.github.io/textbook/chapters/modules/intro.html)
- **Jane Street**: [Effective ML](https://blog.janestreet.com/effective-ml-video/)
- **Book**: "Developing Applications With OCaml" - Chapter 7
- **GitHub**: [Base Library Structure](https://github.com/janestreet/base/tree/master/src)

#### Functors
```ocaml
module Make_parallel_map (S : sig
    type 'a t
    type key
    val empty : _ t
    val is_empty : _ t -> bool
    val to_list : 'a t -> (key * 'a) list
    val mapi : 'a t -> f:(key -> 'a -> 'b) -> 'b t
  end) : sig
  val parallel_map : 'a S.t -> f:(S.key -> 'a -> 'b t) -> 'b S.t t
end
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 9 - Functors](https://dev.realworldocaml.org/functors.html)
- **OCaml Manual**: [Functors](https://ocaml.org/manual/modules.html#s%3Afunctor-modules)
- **Tutorial**: [Functors Explained](https://ocaml.org/learn/tutorials/functors.html)
- **Video**: [Xavier Leroy on Modules](https://www.youtube.com/watch?v=3X4h8J2OIxI)
- **Paper**: [A Modular Module System](https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.pdf)

#### First-Class Modules
```ocaml
val create
  :  string
  -> input:(module Input with type t = 'i)
  -> ('i -> 'o t)
  -> ('i, 'o) Table.t

let (module Input : Store_intf.Input with type t = i) = node.spec.input in
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 10 - First-Class Modules](https://dev.realworldocaml.org/first-class-modules.html)
- **Blog**: [First-Class Modules in Practice](https://blog.janestreet.com/first-class-modules/)
- **Tutorial**: [Dynamic Modules](https://ocaml.org/learn/tutorials/first_class_modules.html)
- **Paper**: [First-Class Modules: Hidden Power](https://www.cl.cam.ac.uk/~jdy22/papers/first-class-modules-hidden-power.pdf)
- **Example**: [Dune's Implementation](https://github.com/ocaml/dune/blob/main/src/dune_engine/memo.ml)

#### Recursive Modules
```ocaml
module rec Cached_value : sig
  type 'a t = { ... }
end = Cached_value

and State : sig
  type 'a t = 
    | Cached_value of 'a Cached_value.t
    | Out_of_date of { old_value : 'a Cached_value.t Option.Unboxed.t }
end = State
```

**Learning Resources:**
- **OCaml Manual**: [Recursive Modules](https://ocaml.org/manual/modules.html#s%3Arecmodules)
- **Real World OCaml**: [Recursive Modules Section](https://dev.realworldocaml.org/files-modules-and-programs.html#recursive-modules)
- **Tutorial**: [Recursive Modules Tutorial](https://ocaml.org/learn/tutorials/modules.html#recursive-modules)
- **Blog**: [When to Use Recursive Modules](https://blog.janestreet.com/recursive-modules/)
- **Example**: [Compiler Implementation](https://github.com/ocaml/ocaml/blob/trunk/typing/typemod.ml)

### Advanced Type System Features

#### Polymorphic Variants
```ocaml
type 'a step =
  | Done of 'a
  | Stalled of 'a stalled
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 6 - Polymorphic Variants](https://dev.realworldocaml.org/variants.html#polymorphic-variants)
- **OCaml Manual**: [Polymorphic Variants](https://ocaml.org/manual/polyvariant.html)
- **Tutorial**: [Polymorphic Variants Explained](https://ocaml.org/learn/tutorials/polyn_variants.html)
- **Paper**: [Programming with Polymorphic Variants](https://caml.inria.fr/pub/papers/garrigue-polymorphic_variants-ml98.pdf)
- **Blog**: [Variants vs Polymorphic Variants](https://blog.janestreet.com/variants-and-polymorphic-variants/)

#### Existential Types and GADTs
```ocaml
type fill = Fill : 'a Ivar.t * 'a -> fill

type ('i, 'o) t =
  { witness : 'i Type_eq.Id.t
  ; input : (module Store_intf.Input with type t = 'i)
  ; f : 'i -> 'o Fiber.t
  }
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 14 - GADTs](https://dev.realworldocaml.org/gadts.html)
- **OCaml Manual**: [GADTs](https://ocaml.org/manual/gadts.html)
- **Tutorial**: [GADTs by Example](https://ocaml.org/learn/tutorials/gadts.html)
- **Paper**: [GADTs Meet Their Match](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/08/gadtpm.pdf)
- **Video**: [GADTs in Practice](https://www.youtube.com/watch?v=6wvMKLnXz28)
- **Blog**: [Existential Types Explained](https://blog.janestreet.com/existential-types-in-ocaml/)

#### Type Constraints and Equalities
```ocaml
include Table.Key with type t := t
include Monad.S with type 'a t := 'a t

val as_instance_of : t -> of_:('input, _) Table.t -> 'input option
```

**Learning Resources:**
- **OCaml Manual**: [Type Constraints](https://ocaml.org/manual/modtypes.html#s%3Amodtype-constraints)
- **Real World OCaml**: [Chapter 9 - Sharing Constraints](https://dev.realworldocaml.org/functors.html#sharing-constraints)
- **Tutorial**: [Advanced Module Features](https://ocaml.org/learn/tutorials/modules.html#sharing-constraints)
- **CS3110**: [Module Type Constraints](https://cs3110.github.io/textbook/chapters/modules/module_type_constraints.html)
- **Paper**: [Understanding Type Constraints](https://caml.inria.fr/pub/papers/remy-vouillon-objective-ml-tapos98.pdf)

#### Mutable Types
```ocaml
type t = 
  { mutable last_validated_at : Run.t
  ; mutable deps : Dep_node.packed Deps.t
  }

let cleaners = ref []
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 8 - Imperative Programming](https://dev.realworldocaml.org/imperative-programming.html)
- **OCaml Manual**: [Mutable Fields](https://ocaml.org/manual/expr.html#ss%3Aexpr-records)
- **Tutorial**: [References and Mutable Fields](https://ocaml.org/learn/tutorials/mutable_fields.html)
- **CS3110**: [Mutability Chapter](https://cs3110.github.io/textbook/chapters/mut/intro.html)
- **Best Practices**: [When to Use Mutation](https://blog.janestreet.com/when-to-use-mutation/)

### Exception Handling
```ocaml
exception Non_reproducible of exn
exception E of t

val with_error_handler
  :  (unit -> 'a t)
  -> on_error:(Exn_with_backtrace.t -> Nothing.t t)
  -> 'a t

val collect_errors : (unit -> 'a t) -> ('a, Exn_with_backtrace.t list) Result.t t
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 7 - Error Handling](https://dev.realworldocaml.org/error-handling.html)
- **OCaml Manual**: [Exception Handling](https://ocaml.org/manual/coreexamples.html#s%3Atut-exceptions)
- **Tutorial**: [Exceptions vs Results](https://ocaml.org/learn/tutorials/error_handling.html)
- **Blog**: [Error Handling in OCaml](https://blog.janestreet.com/how-to-choose-between-exceptions-and-results/)
- **Library**: [Result Documentation](https://ocaml.github.io/dune/ocaml-dune-doc/dune-engine/Dune_engine/Result/index.html)

### Advanced Patterns

#### Option and Result Types
```ocaml
val peek : 'a t -> 'a option fiber
type ('a, 'b) result = Ok of 'a | Error of 'b

Option.Unboxed.match_
  !t
  ~some:(fun dag_node -> (* ... *))
  ~none:(fun () -> (* ... *))
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 7 - Error Handling](https://dev.realworldocaml.org/error-handling.html)
- **OCaml Manual**: [Option Type](https://ocaml.org/api/Option.html)
- **Tutorial**: [Option and Result](https://ocaml.org/learn/tutorials/error_handling.html)
- **Library**: [Base.Option](https://ocaml.janestreet.com/ocaml-core/latest/doc/base/Base/Option/index.html)
- **Practice**: [Option Exercises](https://github.com/ocaml-community/learn-ocaml-corpus/tree/master/exercises/smelodesousa/F2/2-option)

#### Polymorphic Records and Variants
```ocaml
module Poly (Function : sig
    type 'a input
    type 'a output
    val eval : 'a input -> 'a output t
    val id : 'a input -> 'a Type_eq.Id.t
  end) : sig
  val eval : 'a Function.input -> 'a Function.output t
end
```

**Learning Resources:**
- **Advanced OCaml**: [Polymorphic Programming](https://ocaml.org/learn/tutorials/polymorphism.html)
- **Paper**: [Polymorphic Programming in ML](https://www.cs.cmu.edu/~rwh/papers/polymorphism/popl97.pdf)
- **Blog**: [Advanced Polymorphism Techniques](https://blog.janestreet.com/of-syntax-and-semantics/)
- **Example**: [Type_equal Implementation](https://github.com/janestreet/type_equal/blob/master/src/type_equal.ml)

## Topics Covered in the Documentation

### Concurrency and Parallelism

**Core Concepts:**
- **Structured concurrency** - Fibers with clear lifecycle
- **Cooperative multitasking** - Yield points and scheduling  
- **Synchronization primitives** - Ivars, Mvars, Svars
- **Resource management** - Throttling, mutexes
- **Error propagation** - Handling failures across concurrent tasks
- **Cancellation** - Stopping long-running computations

**Learning Resources:**
- **Paper**: [Structured Concurrency](https://vorpus.org/blog/notes-on-structured-concurrency-or-go-statement-considered-harmful/)
- **Book**: "Concurrent Programming in ML" by John Reppy
- **Tutorial**: [Lwt Programming Guide](https://ocsigen.org/lwt/latest/manual/manual)
- **Blog**: [Async vs Lwt](https://blog.janestreet.com/async-or-lwt/)
- **Video**: [Concurrency in Functional Languages](https://www.youtube.com/watch?v=yi_HPmIKyD4)
- **Course**: [CS 3110 - Concurrency](https://cs3110.github.io/textbook/chapters/mut/concurrency.html)

### Memoization and Caching

**Core Concepts:**
- **Dependency tracking** - Automatic detection of dependencies
- **Incremental computation** - Recompute only what changed
- **Cache invalidation** - Smart cache clearing strategies
- **Cycle detection** - Preventing infinite dependency loops
- **Early cutoff** - Skip recomputation when results are equivalent
- **Error caching** - Memoizing both successes and failures

**Learning Resources:**
- **Paper**: [Build Systems à la Carte](https://www.microsoft.com/en-us/research/uploads/prod/2018/03/build-systems.pdf)
- **Blog**: [Incremental Computation](https://blog.janestreet.com/introducing-incremental/)
- **Library**: [Incremental Library](https://github.com/janestreet/incremental)
- **Paper**: [Adaptive Functional Programming](https://www.cs.cmu.edu/~guyb/papers/popl02.pdf)
- **Tutorial**: [Memoization Patterns](https://ocaml.org/learn/tutorials/performance_and_profiling.html)
- **Video**: [Incremental Computing](https://www.youtube.com/watch?v=G6a5G5i4gQU)

### Functional Programming Patterns

**Core Concepts:**
- **Monadic composition** - Sequencing computations with >>=
- **Applicative functors** - Parallel composition with and*
- **Higher-order functions** - Functions that take/return functions
- **Immutable data structures** - Persistent data with structural sharing
- **Algebraic data types** - Sum and product types for modeling

**Learning Resources:**
- **Book**: "Learn You a Haskell" (concepts transfer to OCaml)
- **Tutorial**: [Monads in OCaml](https://ocaml.org/learn/tutorials/monads.html)
- **Paper**: [Monads for Functional Programming](https://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf)
- **Blog**: [Applicative Functors](https://blog.janestreet.com/applicative-functors/)
- **Course**: [CIS 194 - Haskell](https://www.seas.upenn.edu/~cis194/spring13/) (concepts apply)
- **Library**: [Base Monad Documentation](https://ocaml.janestreet.com/ocaml-core/latest/doc/base/Base/Monad/index.html)

### System Design Patterns

**Core Concepts:**
- **Event-driven architecture** - Responding to file system changes
- **Producer-consumer patterns** - Streams and queues
- **Observer pattern** - State variables with watchers
- **Command pattern** - Invalidation actions
- **Strategy pattern** - Pluggable storage backends

**Learning Resources:**
- **Book**: "Design Patterns" by Gang of Four
- **Blog**: [Functional Design Patterns](https://blog.janestreet.com/effective-ml-revisited/)
- **Paper**: [Functional Reactive Programming](https://wiki.haskell.org/Functional_Reactive_Programming)
- **Tutorial**: [OCaml Design Patterns](https://ocaml.org/learn/tutorials/design_patterns.html)
- **Video**: [Architecture the Functional Way](https://www.youtube.com/watch?v=US8QG9I1XW0)

## OCaml Learning Path with Resources

### Beginner Level (Essential for Basic Usage)

#### 1. Core Language Basics

**Topics to Learn:**
```ocaml
(* Variables and basic types *)
let x = 42
let message = "hello"
let numbers = [1; 2; 3]

(* Functions *)
let add x y = x + y
let square x = x * x

(* Pattern matching *)
let describe_list lst =
  match lst with
  | [] -> "empty"
  | [x] -> "single element"
  | x :: xs -> "multiple elements"
```

**Learning Resources:**
- **Primary**: [Real World OCaml - Chapter 1](https://dev.realworldocaml.org/guided-tour.html)
- **Interactive**: [Try OCaml](https://try.ocaml.pro/)
- **Video Course**: [OCaml MOOC](https://www.france-universite-numerique.fr/courses/detail/61002)
- **Book**: "OCaml from the Very Beginning" by John Whitington
- **Practice**: [Learn OCaml Platform](https://learn-ocaml.org/)

**Why needed**: Fundamental for reading any OCaml code.

#### 2. Option and Result Types

**Topics to Learn:**
```ocaml
type 'a option = None | Some of 'a
type ('a, 'b) result = Ok of 'a | Error of 'b

let safe_divide x y =
  if y = 0 then None else Some (x / y)

let handle_result r =
  match r with
  | Ok value -> Printf.printf "Success: %d\n" value
  | Error msg -> Printf.printf "Error: %s\n" msg
```

**Learning Resources:**
- **Tutorial**: [Error Handling in OCaml](https://ocaml.org/learn/tutorials/error_handling.html)
- **Real World OCaml**: [Chapter 7 - Error Handling](https://dev.realworldocaml.org/error-handling.html)
- **Blog**: [Option vs Exception](https://blog.janestreet.com/how-to-choose-between-exceptions-and-results/)
- **Practice**: [Result Exercises](https://github.com/ocaml-community/learn-ocaml-corpus)
- **Library**: [Result Library Docs](https://ocaml.github.io/ocaml-re/result/index.html)

**Why needed**: Fiber and Memo extensively use Options for nullable values and Results for error handling.

#### 3. Records and Variants

**Topics to Learn:**
```ocaml
type person = { name : string; age : int }

type shape = 
  | Circle of float
  | Rectangle of float * float
  | Triangle of float * float * float

let area = function
  | Circle r -> 3.14 *. r *. r
  | Rectangle (w, h) -> w *. h  
  | Triangle (a, b, c) -> (* Heron's formula *)
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 6 - Variants](https://dev.realworldocaml.org/variants.html)
- **Real World OCaml**: [Chapter 7 - Records](https://dev.realworldocaml.org/records.html)
- **CS3110**: [Data and Types](https://cs3110.github.io/textbook/chapters/data/intro.html)
- **Tutorial**: [Data Types](https://ocaml.org/learn/tutorials/data_types_and_matching.html)
- **Video**: [Algebraic Data Types](https://www.youtube.com/watch?v=YR5WdGrpoug)

**Why needed**: Core data modeling used throughout both systems.

### Intermediate Level (Required for Effective Use)

#### 4. Higher-Order Functions

**Topics to Learn:**
```ocaml
let map f lst = List.map f lst
let filter pred lst = List.filter pred lst

let compose f g x = f (g x)
let apply_twice f x = f (f x)

(* Functions as values *)
let operations = [( + ); ( * ); max]
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 2 - Variables and Functions](https://dev.realworldocaml.org/variables-and-functions.html)
- **CS3110**: [Higher-Order Programming](https://cs3110.github.io/textbook/chapters/hop/intro.html)
- **Tutorial**: [Functional Programming](https://ocaml.org/learn/tutorials/functional_programming.html)
- **Video**: [Higher-Order Functions](https://www.youtube.com/watch?v=k53lzZ9b_1I)
- **Practice**: [HOP Exercises](https://cs3110.github.io/textbook/chapters/hop/exercises.html)

**Why needed**: Fiber and Memo are built around higher-order functions like `map`, `bind`, etc.

#### 5. Module System Basics

**Topics to Learn:**
```ocaml
module Counter = struct
  type t = { mutable count : int }
  
  let create () = { count = 0 }
  let increment t = t.count <- t.count + 1
  let get t = t.count
end

module type Comparable = sig
  type t
  val compare : t -> t -> int
end
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 4 - Files, Modules, and Programs](https://dev.realworldocaml.org/files-modules-and-programs.html)
- **OCaml Manual**: [Module System](https://ocaml.org/manual/modules.html)
- **CS3110**: [Modules](https://cs3110.github.io/textbook/chapters/modules/intro.html)
- **Tutorial**: [Module System](https://ocaml.org/learn/tutorials/modules.html)
- **Video**: [Modules Explained](https://www.youtube.com/watch?v=a4IfUsAKKmQ)

**Why needed**: Both systems are organized as modules with signatures.

#### 6. Parameterized Types and Polymorphism

**Topics to Learn:**
```ocaml
type 'a stack = 'a list

let empty = []
let push x stack = x :: stack
let pop = function
  | [] -> None
  | x :: xs -> Some (x, xs)

(* Polymorphic functions *)
let identity x = x
let const x y = x
```

**Learning Resources:**
- **Real World OCaml**: [Chapter 5 - Lists and Patterns](https://dev.realworldocaml.org/lists-and-patterns.html)
- **OCaml Manual**: [Polymorphism](https://ocaml.org/manual/polymorphism.html)
- **Tutorial**: [Parametric Polymorphism](https://ocaml.org/learn/tutorials/polymorphism.html)
- **CS3110**: [Parametric Polymorphism](https://cs3110.github.io/textbook/chapters/data/polymorphism.html)
- **Paper**: [Principal Type Schemes](https://web.cs.wpi.edu/~cs4536/c12/milner-damas_principal_types.pdf)

**Why needed**: `'a Fiber.t` and `'a Memo.t` are parameterized types.

#### 7. Infix Operators

**Topics to Learn:**
```ocaml
let ( |> ) x f = f x
let ( @@ ) f x = f x
let ( >> ) f g x = g (f x)

(* Usage *)
let result = 
  [1; 2; 3; 4]
  |> List.map (fun x -> x * 2)
  |> List.filter (fun x -> x > 4)
```

**Learning Resources:**
- **Tutorial**: [Custom Operators](https://ocaml.org/learn/tutorials/custom_operators.html)
- **Real World OCaml**: [Operators](https://dev.realworldocaml.org/variables-and-functions.html#operators)
- **Blog**: [Operator Precedence](https://blog.janestreet.com/operator-precedence/)
- **Reference**: [OCaml Operator Precedence](https://ocaml.org/manual/expr.html#ss:precedence-and-associativity)
- **Library**: [Base Operators](https://ocaml.janestreet.com/ocaml-core/latest/doc/base/Base/index.html#operators)

**Why needed**: Fiber uses many custom infix operators like `>>=`, `>>|`, etc.

### Advanced Level (For Deep Understanding and Extension)

#### 8. Functors

**Learning Resources:**
- **Real World OCaml**: [Chapter 9 - Functors](https://dev.realworldocaml.org/functors.html)
- **OCaml Manual**: [Functors](https://ocaml.org/manual/modules.html#s%3Afunctor-modules)
- **CS3110**: [Functors](https://cs3110.github.io/textbook/chapters/modules/functors.html)
- **Tutorial**: [Advanced Modules](https://ocaml.org/learn/tutorials/functors.html)
- **Video**: [Functors in Practice](https://www.youtube.com/watch?v=sT6VJdVCmSI)
- **Example**: [Map Implementation](https://github.com/ocaml/ocaml/blob/trunk/stdlib/map.ml)

**Why needed**: Both systems use functors for parameterized modules.

#### 9. First-Class Modules

**Learning Resources:**
- **Real World OCaml**: [Chapter 10 - First-Class Modules](https://dev.realworldocaml.org/first-class-modules.html)
- **Tutorial**: [First-Class Modules](https://ocaml.org/learn/tutorials/first_class_modules.html)
- **Blog**: [First-Class Modules](https://blog.janestreet.com/first-class-modules/)
- **Paper**: [Modular Type Classes](https://people.mpi-sws.org/~dreyer/papers/mtc/main-long.pdf)
- **Video**: [Dynamic Modules](https://www.youtube.com/watch?v=XR2SrkK0BCw)

**Why needed**: Memo.create takes first-class modules as input specifications.

#### 10. GADTs and Existential Types

**Learning Resources:**
- **Real World OCaml**: [Chapter 14 - GADTs](https://dev.realworldocaml.org/gadts.html)
- **OCaml Manual**: [GADTs](https://ocaml.org/manual/gadts.html)
- **Tutorial**: [GADTs Tutorial](https://ocaml.org/learn/tutorials/gadts.html)
- **Paper**: [GADTs Meet Their Match](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/08/gadtpm.pdf)
- **Video**: [GADTs Explained](https://www.youtube.com/watch?v=6wvMKLnXz28)
- **Blog**: [When to Use GADTs](https://blog.janestreet.com/why-gadts-matter-for-performance/)

**Why needed**: Used for type-safe existential packaging in both systems.

#### 11. Mutable State and References

**Learning Resources:**
- **Real World OCaml**: [Chapter 8 - Imperative Programming](https://dev.realworldocaml.org/imperative-programming.html)
- **CS3110**: [Mutability](https://cs3110.github.io/textbook/chapters/mut/intro.html)
- **Tutorial**: [Mutable Data Structures](https://ocaml.org/learn/tutorials/mutable_fields.html)
- **Blog**: [Mutation Guidelines](https://blog.janestreet.com/when-to-use-mutation/)
- **Video**: [Functional vs Imperative](https://www.youtube.com/watch?v=dMMwSdafPW4)

**Why needed**: Implementation details use mutable state for performance.

#### 12. Exception Handling

**Learning Resources:**
- **Real World OCaml**: [Chapter 7 - Error Handling](https://dev.realworldocaml.org/error-handling.html)
- **OCaml Manual**: [Exceptions](https://ocaml.org/manual/coreexamples.html#s%3Atut-exceptions)
- **Tutorial**: [Exception Handling](https://ocaml.org/learn/tutorials/error_handling.html)
- **Blog**: [Exceptions vs Results](https://blog.janestreet.com/how-to-choose-between-exceptions-and-results/)
- **CS3110**: [Exceptions](https://cs3110.github.io/textbook/chapters/data/exceptions.html)

**Why needed**: Both systems have sophisticated error handling with custom exceptions.

### Expert Level (For Contributors and Deep Debugging)

#### 13. Recursive Modules

**Learning Resources:**
- **OCaml Manual**: [Recursive Modules](https://ocaml.org/manual/modules.html#s%3Arecmodules)
- **Real World OCaml**: [Recursive Modules](https://dev.realworldocaml.org/files-modules-and-programs.html#recursive-modules)
- **Paper**: [A Modular Module System](https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.pdf)
- **Blog**: [Recursive Module Patterns](https://blog.janestreet.com/recursive-modules/)
- **Example**: [Recursive Module Usage](https://github.com/ocaml/dune/blob/main/src/dune_engine/memo.ml)

**Why needed**: Memo implementation uses recursive modules for mutually dependent types.

#### 14. Type Witnesses and Equality

**Learning Resources:**
- **Blog**: [Type Equality Witnesses](https://blog.janestreet.com/more-expressive-gadt-type-inference/)
- **Paper**: [Advanced Types](https://caml.inria.fr/pub/papers/garrigue-advanced_types-appsem.pdf)
- **Library**: [Type_equal Documentation](https://ocaml.janestreet.com/ocaml-core/latest/doc/type_equal/Type_equal/index.html)
- **Tutorial**: [Type Equality](https://ocaml.org/learn/tutorials/comparison_of_standard_containers.html)
- **Video**: [Advanced Type Systems](https://www.youtube.com/watch?v=sjN1uEX5ECQ)

**Why needed**: Advanced type safety in Memo's polymorphic functions.

## Recommended Learning Sequence with Resources

### Phase 1: OCaml Fundamentals (2-3 weeks)

**Primary Resources:**
- **Book**: [Real World OCaml](https://dev.realworldocaml.org/) - Chapters 1-3
- **Interactive**: [Try OCaml](https://try.ocaml.pro/)
- **Course**: [CS 3110](https://cs3110.github.io/textbook/) - First 3 chapters
- **Practice**: [Learn OCaml](https://learn-ocaml.org/)

**Topics:**
1. Basic syntax and types
2. Functions and pattern matching  
3. Lists and basic data structures
4. Option and Result types

### Phase 2: Functional Programming (2-3 weeks)

**Primary Resources:**
- **Book**: [Real World OCaml](https://dev.realworldocaml.org/) - Chapters 4-5
- **Course**: [CS 3110 - Higher-Order Programming](https://cs3110.github.io/textbook/chapters/hop/intro.html)
- **Tutorial**: [OCaml Functional Programming](https://ocaml.org/learn/tutorials/functional_programming.html)
- **Practice**: [99 Problems](https://ocaml.org/learn/tutorials/99problems.html)

**Topics:**
1. Higher-order functions
2. Map, filter, fold patterns
3. Composition and currying
4. Immutable data structures

### Phase 3: Module System (1-2 weeks)

**Primary Resources:**
- **Book**: [Real World OCaml](https://dev.realworldocaml.org/) - Chapters 9-10
- **Course**: [CS 3110 - Modules](https://cs3110.github.io/textbook/chapters/modules/intro.html)
- **Tutorial**: [OCaml Modules](https://ocaml.org/learn/tutorials/modules.html)
- **Examples**: [Base Library](https://github.com/janestreet/base)

**Topics:**
1. Module definitions and signatures
2. Module inclusion and constraints
3. Basic functors
4. First-class modules

### Phase 4: Advanced Types (2-3 weeks)  

**Primary Resources:**
- **Book**: [Real World OCaml](https://dev.realworldocaml.org/) - Chapters 6, 14
- **Tutorial**: [GADTs Tutorial](https://ocaml.org/learn/tutorials/gadts.html)
- **Paper**: [GADTs Meet Their Match](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/08/gadtpm.pdf)
- **Examples**: [Type_equal Library](https://github.com/janestreet/type_equal)

**Topics:**
1. Parameterized types
2. Variant types and GADTs
3. Existential types
4. Type witnesses

### Phase 5: System Integration (1-2 weeks)

**Primary Resources:**
- **Dune Source**: [Fiber Implementation](https://github.com/ocaml/dune/blob/main/src/fiber/fiber.ml)
- **Dune Source**: [Memo Implementation](https://github.com/ocaml/dune/blob/main/src/dune_engine/memo.ml)
- **Blog**: [Dune Architecture](https://dune.build/blog/)
- **Paper**: [Build Systems à la Carte](https://www.microsoft.com/en-us/research/uploads/prod/2018/03/build-systems.pdf)

**Topics:**
1. Error handling patterns
2. Mutable state when needed
3. Performance considerations
4. Debugging techniques

## Additional Resources

### Essential Libraries to Study
- **[Base](https://github.com/janestreet/base)** - Jane Street's standard library replacement
- **[Lwt](https://github.com/ocsigen/lwt)** - Lightweight threads (similar to Fiber)
- **[Incremental](https://github.com/janestreet/incremental)** - Incremental computation (similar to Memo)
- **[Async](https://github.com/janestreet/async)** - Jane Street's concurrency library

### Practice Projects
1. **Simple Calculator** with proper error handling - [Tutorial](https://ocaml.org/learn/tutorials/basics.html)
2. **Basic Cache** with invalidation - [Guide](https://blog.janestreet.com/introducing-incremental/)
3. **Concurrent Task Runner** - [Lwt Tutorial](https://ocsigen.org/lwt/latest/manual/manual)
4. **Dependency Tracker** for a build system - [Build Systems Paper](https://www.microsoft.com/en-us/research/uploads/prod/2018/03/build-systems.pdf)

### Community Resources
- **[OCaml Discourse](https://discuss.ocaml.org/)** - Community forum
- **[OCaml Planet](https://ocaml.org/community/)** - Blog aggregator  
- **[r/ocaml](https://www.reddit.com/r/ocaml/)** - Reddit community
- **[OCaml Discord](https://discord.gg/ocaml)** - Chat community

This comprehensive learning path with specific resources will take you from OCaml beginner to someone who can effectively work with (and potentially contribute to) Dune's sophisticated concurrency and memoization systems.