# Complete Beginner's Guide to Dune's Fiber and Memo Systems

## Table of Contents
1. [Introduction](#introduction)
2. [Fiber System - Structured Concurrency](#fiber-system---structured-concurrency)
3. [Memo System - Smart Caching](#memo-system---smart-caching)
4. [How They Work Together](#how-they-work-together)

## Introduction

Dune (OCaml's build system) has two main systems that make it fast and reliable:

1. **Fiber** - A concurrency system that lets multiple tasks run "at the same time"
2. **Memo** - A smart caching system that remembers results to avoid redoing work

Think of it like this:
- **Fiber** = A restaurant kitchen where multiple chefs can work simultaneously
- **Memo** = A recipe book that remembers what dishes were made and their ingredients

## Fiber System - Structured Concurrency

### What is a Fiber?

```ocaml
type 'a t
```

A `Fiber.t` is like a "lightweight thread" - imagine it as a task that can be paused and resumed. The `'a` tells us what type of result this task will produce when it's done.

**Real-world analogy**: Think of fibers like cooking multiple dishes:
- You can start boiling water (one fiber)
- While that's happening, chop vegetables (another fiber)  
- Both can run "concurrently" even though you're one person

### Basic Fiber Operations

#### Creating Fibers

```ocaml
val return : 'a -> 'a t
```
**What it does**: Creates a fiber that's already finished with a result.
**Example**: `return 42` creates a fiber that immediately gives you the number 42.

```ocaml
val never : 'a t
```
**What it does**: Creates a fiber that never finishes (useful for servers that run forever).

#### Sequencing Operations

```ocaml
val ( >>> ) : unit t -> 'a t -> 'a t
```
**What it does**: "Do A, then do B" - runs two fibers in sequence.
**Example**: `cook_rice >>> serve_meal` means "cook rice first, then serve the meal"

```ocaml
val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
```
**What it does**: "Do A, use its result to decide what B should be"
**Example**: `get_weather >>= fun weather -> if weather = Sunny then go_picnic else stay_home`

```ocaml
val ( >>| ) : 'a t -> ('a -> 'b) -> 'b t
```
**What it does**: "Do A, then transform its result"
**Example**: `read_temperature >>| fun temp -> temp * 9 / 5 + 32` (convert Celsius to Fahrenheit)

### Parallel Operations

```ocaml
val fork_and_join : (unit -> 'a t) -> (unit -> 'b t) -> ('a * 'b) t
```
**What it does**: Runs two tasks in parallel and waits for both to finish.
**Kitchen analogy**: 
- Chef 1: Boil pasta
- Chef 2: Make sauce
- Result: (cooked_pasta, finished_sauce)

```ocaml
val parallel_map : 'a list -> f:('a -> 'b t) -> 'b list t
```
**What it does**: Takes a list of things, processes each one in parallel.
**Example**: If you have `[file1; file2; file3]`, this can compile all three files simultaneously.

### Synchronization Tools

#### Ivar (Write-once variables)
```ocaml
module Ivar : sig
  type 'a t
  val create : unit -> 'a t
  val read : 'a t -> 'a fiber
  val fill : 'a t -> 'a -> unit fiber
end
```

**What it is**: Like a mailbox that can only receive one letter, ever.
**Example use**:
```ocaml
let mailbox = Ivar.create () in
(* One fiber puts a value in *)
Ivar.fill mailbox "Hello World"
(* Another fiber reads it *)
Ivar.read mailbox (* Gets "Hello World" *)
```

#### Mvar (Mailbox variables)
```ocaml
module Mvar : sig
  type 'a t
  val create : unit -> 'a t
  val read : 'a t -> 'a fiber  (* Takes value out *)
  val write : 'a t -> 'a -> unit fiber  (* Puts value in *)
end
```

**What it is**: Like a mailbox that can be emptied and refilled.
**Example**: Perfect for passing messages between different parts of your program.

#### Throttle (Rate limiting)
```ocaml
module Throttle : sig
  type t
  val create : int -> t  (* Create throttle that allows N concurrent operations *)
  val run : t -> f:(unit -> 'a fiber) -> 'a fiber
end
```

**What it does**: Limits how many things can run at once.
**Example**: `Throttle.create 3` means "only 3 download tasks can run simultaneously"

### Error Handling

```ocaml
val with_error_handler
  :  (unit -> 'a t)
  -> on_error:(Exn_with_backtrace.t -> Nothing.t t)
  -> 'a t
```

**What it does**: Catches errors and lets you decide what to do with them.
**Example**: Like having a safety net when doing dangerous operations.

## Memo System - Smart Caching

### What is Memo?

The Memo system is like a super-smart cache that:
1. **Remembers results** of expensive computations
2. **Tracks dependencies** between computations  
3. **Automatically invalidates** outdated results
4. **Detects cycles** to prevent infinite loops

### Basic Memo Concepts

#### Memo Type
```ocaml
type 'a t
```
This represents a "memoized computation" - a computation whose result will be cached.

#### Creating Memoized Functions

```ocaml
val create
  :  string                                    (* Name for debugging *)
  -> input:(module Input with type t = 'i)     (* What type of input *)
  -> ?cutoff:('o -> 'o -> bool)               (* When to skip updates *)
  -> ('i -> 'o t)                             (* The actual function *)
  -> ('i, 'o) Table.t                         (* Returns a memoized version *)
```

**What it does**: Converts a regular function into a memoized one.

**Example breakdown**:
```ocaml
let compile_file_memo = 
  Memo.create 
    "compile-file"                    (* Name for debugging *)
    ~input:(module Filename)          (* Input is a filename *)
    ~cutoff:String.equal             (* Skip if output filename is same *)
    (fun filename ->                 (* The function to memoize *)
      (* ... actual compilation logic ... *)
      Memo.return compiled_result)
```

#### Executing Memoized Functions

```ocaml
val exec : ('i, 'o) Table.t -> 'i -> 'o t
```

**What it does**: Runs a memoized function with given input.
**Example**: `Memo.exec compile_file_memo "main.ml"` will compile main.ml (or return cached result).

### Advanced Memo Features

#### Dependency Tracking

When you run `function_A` which calls `function_B`, Memo automatically remembers:
- "function_A depends on function_B"  
- If function_B's result changes, function_A needs to be recomputed

#### Cycle Detection

```ocaml
module Cycle_error : sig
  type t
  exception E of t
  val get : t -> Stack_frame.t list
end
```

**What it prevents**: Infinite loops like:
- Function A depends on Function B
- Function B depends on Function A  
- This would run forever!

Memo detects this and raises a `Cycle_error` instead.

#### Invalidation System

```ocaml
module Invalidation : sig
  type t
  val clear_caches : reason:Reason.t -> t
  val invalidate_cache : reason:Reason.t -> _ Table.t -> t
end
```

**What it does**: Tells Memo "forget this cached result, it's outdated"

**Example reasons**:
- `Path_changed of Path.t` - A file was modified
- `Event_queue_overflow` - Too many changes happened at once

#### Variables

```ocaml
module Var : sig
  type 'a t
  val create : ?cutoff:('a -> 'a -> bool) -> 'a -> name:string -> 'a t
  val set : 'a t -> 'a -> Invalidation.t
  val read : 'a t -> 'a memo
end
```

**What it is**: A memoized variable that can be changed and will trigger recomputation.

**Example**:
```ocaml
let compiler_flags = Memo.Var.create ~name:"compiler-flags" ["-O2"] in

(* Later, if flags change: *)
let invalidation = Memo.Var.set compiler_flags ["-O3"; "-g"] in
Memo.reset invalidation  (* This makes all dependent computations rerun *)
```

### Key Data Structures

#### Stack Frames
```ocaml
module Stack_frame : sig
  type t
  val name : t -> string option
  val input : t -> Dyn.t
end
```

**What it is**: Like a call stack, but for memoized functions. Helps with debugging.

#### Tables  
```ocaml
module Table : sig
  type ('input, 'output) t
end
```

**What it is**: The data structure that holds cached results for a memoized function.

#### Cells
```ocaml
module Cell : sig
  type ('i, 'o) t
  val read : (_, 'o) t -> 'o memo
  val invalidate : reason:Invalidation.Reason.t -> _ t -> Invalidation.t
end
```

**What it is**: A single cached computation result. Like one entry in the cache.

## How They Work Together

### The Big Picture

1. **Fiber handles concurrency**: Multiple build tasks can run simultaneously
2. **Memo handles caching**: Results are cached to avoid repeated work
3. **Together**: You get a fast, parallel build system that's also smart about not redoing work

### Example: Building a Project

```ocaml
(* Step 1: Create memoized functions *)
let compile_file = Memo.create "compile" ~input:(module String) 
  (fun filename -> 
    (* This is a Fiber that compiles the file *)
    Fiber.Process.run ["ocamlc"; filename])

let link_files = Memo.create "link" ~input:(module String_list)
  (fun filenames ->
    Fiber.Process.run (["ocamlc"; "-o"; "main"] @ filenames))

(* Step 2: Use them in parallel *)
let build_project files = 
  (* Compile all files in parallel *)
  Memo.parallel_map files ~f:(Memo.exec compile_file)
  >>= fun compiled_files ->
  (* Link them together *)
  Memo.exec link_files compiled_files

(* Step 3: Run with Fiber *)
let result = Fiber.run (build_project ["a.ml"; "b.ml"; "c.ml"]) ~iter:(fun () -> [])
```

### What Happens:

1. **First run**: 
   - All three files compile in parallel (Fiber)
   - Results are cached (Memo)
   - Files are linked
   - Total result is cached

2. **Second run** (no files changed):
   - Memo sees cached results are still valid
   - Skips compilation entirely
   - Returns cached final result
   - Build is nearly instant!

3. **Third run** (one file changed):
   - Memo detects file change
   - Only recompiles the changed file (Fiber runs this)
   - Relinks with new object file
   - Other files stay cached

### Error Scenarios

#### Cycle Detection
```ocaml
(* BAD: This would create an infinite loop *)
let bad_func_a = Memo.create "func-a" ~input:(module Unit)
  (fun () -> Memo.exec bad_func_b ())

let bad_func_b = Memo.create "func-b" ~input:(module Unit)  
  (fun () -> Memo.exec bad_func_a ())

(* Memo detects this and raises Cycle_error.E instead of hanging *)
```

#### Error Propagation
```ocaml
let may_fail = Memo.create "may-fail" ~input:(module String)
  (fun filename ->
    if Sys.file_exists filename 
    then Fiber.return (read_file filename)
    else Fiber.fail (Failure "File not found"))

(* Memo handles errors gracefully and can cache them too *)
```

## Key Takeaways

### For Fiber:
- **Structured concurrency**: Tasks have clear start/end points
- **Composable**: Small concurrent pieces combine into larger ones
- **Safe**: No data races or deadlocks when used correctly

### For Memo:  
- **Automatic dependency tracking**: You don't manually specify what depends on what
- **Incremental computation**: Only recompute what actually changed
- **Cycle detection**: Prevents infinite loops
- **Smart invalidation**: Knows exactly what needs to be recomputed

### Together:
- **Fast parallel builds**: Multiple things happen at once
- **Smart caching**: Don't redo work unnecessarily  
- **Reliable**: Handles errors, cycles, and complex dependencies correctly
- **Incremental**: Perfect for build systems where small changes shouldn't trigger full rebuilds

This is why Dune is so fast - it combines the best of parallel execution (Fiber) with intelligent caching (Memo) to create a build system that's both fast on the first run and blazingly fast on subsequent runs.