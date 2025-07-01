# OCaml Async Programming Guide for Absolute Beginners

## Table of Contents
1. [What is Concurrent Programming?](#what-is-concurrent-programming)
2. [Understanding Async Basics](#understanding-async-basics)
3. [Deferreds: The Heart of Async](#deferreds-the-heart-of-async)
4. [Key Functions: bind, map, and return](#key-functions-bind-map-and-return)
5. [Let Syntax: Making Code Readable](#let-syntax-making-code-readable)
6. [Ivars and Upon: Low-Level Building Blocks](#ivars-and-upon-low-level-building-blocks)
7. [Practical Example: Echo Server](#practical-example-echo-server)
8. [Exception Handling in Async](#exception-handling-in-async)
9. [Timeouts and Cancellation](#timeouts-and-cancellation)
10. [Working with System Threads](#working-with-system-threads)

---

## What is Concurrent Programming?

Imagine you're a chef in a restaurant. In a **sequential** approach, you would:
1. Take order #1
2. Cook it completely
3. Serve it
4. Only then take order #2

But that's inefficient! In a **concurrent** approach, you would:
1. Take order #1, start cooking
2. While order #1 is cooking, take order #2
3. While both are cooking, take order #3
4. Serve whichever finishes first

Concurrent programming is about doing multiple things at the same time, especially when waiting is involved.

### Different Approaches to Concurrency

**System Threads** (like Java/C#):
- Each task gets its own thread
- Operating system decides when to switch between threads
- Can be unpredictable and requires careful synchronization

**Event Loop** (like JavaScript):
- Single thread that reacts to events
- No parallel execution, but can handle many operations
- Control flow can become confusing with callbacks

**Async** (OCaml's approach):
- Combines benefits of both
- Cooperative multitasking with clear control flow
- No unpredictable thread switching

---

## Understanding Async Basics

### Traditional Blocking I/O

```ocaml
open Core;;
```
This imports the Core library, which provides enhanced standard library functions.

```ocaml
Out_channel.write_all "test.txt" ~data:"This is only a test.";;
```
- `Out_channel.write_all` writes data to a file
- `"test.txt"` is the filename
- `~data:"This is only a test."` is a labeled argument containing the content
- This operation **blocks** - your program stops and waits until the file is written

```ocaml
In_channel.read_all "test.txt";;
```
- `In_channel.read_all` reads the entire file content
- Returns a `string` immediately
- This also **blocks** - nothing else can happen while reading

### The Problem with Blocking

When you call `In_channel.read_all`, your program freezes until the file is completely read. If the file is large or on a slow disk, your entire program becomes unresponsive.

### Async's Solution: Deferreds

```ocaml
#require "async";;
open Async;;
```
- `#require "async"` loads the Async library in the REPL
- `open Async` makes Async functions available without prefixing

```ocaml
#show Reader.file_contents;;
```
This shows the type signature:
```ocaml
val file_contents : string -> string Deferred.t
```

**What this means:**
- Takes a `string` (filename) as input
- Returns `string Deferred.t` (a "deferred string")
- A `Deferred.t` is like a "promise" that will eventually contain a value

---

## Deferreds: The Heart of Async

### What is a Deferred?

A `Deferred.t` is like a box that will eventually contain a value. When you create it, the box is empty. Later, when the operation completes, the box gets filled.

```ocaml
let contents = Reader.file_contents "test.txt";;
```
- `contents` is a deferred that will eventually contain the file's contents
- Right now, it's empty (the file hasn't been read yet)

```ocaml
Deferred.peek contents;;
```
- `peek` lets you check if the deferred has a value yet
- Returns `None` if empty, `Some value` if filled
- Initially returns `None` because no actual reading has happened

### The Async Scheduler

In utop (the OCaml REPL), when you type:
```ocaml
contents;;
```
The REPL automatically:
1. Starts the Async scheduler
2. Waits for the deferred to be filled
3. Shows you the final value

After this, if you peek again:
```ocaml
Deferred.peek contents;;
```
You'll see `Some "This is only a test."` because the deferred is now filled.

---

## Key Functions: bind, map, and return

### Understanding bind

```ocaml
#show Deferred.bind;;
val bind : 'a Deferred.t -> f:('a -> 'b Deferred.t) -> 'b Deferred.t
```

**What this signature means:**
- Takes a deferred containing type `'a`
- Takes a function `f` that converts `'a` to a deferred containing `'b`
- Returns a deferred containing type `'b`

**Think of bind as "do this, then when it's done, do that"**

### Example: Uppercase File

```ocaml
let uppercase_file filename =
  Deferred.bind (Reader.file_contents filename)
    ~f:(fun text ->
      Writer.save filename ~contents:(String.uppercase text));;
```

**Line by line:**
1. `Deferred.bind` starts a sequence of operations
2. `Reader.file_contents filename` reads the file (returns `string Deferred.t`)
3. `~f:(fun text -> ...)` is a function that runs when the file is read
4. `text` is the actual file contents (now a regular `string`)
5. `String.uppercase text` converts the text to uppercase
6. `Writer.save filename ~contents:(...)` saves the uppercase text back to the file

### The >>= Operator

```ocaml
let uppercase_file filename =
  Reader.file_contents filename
  >>= fun text ->
  Writer.save filename ~contents:(String.uppercase text);;
```

This is exactly the same as the previous version, but using the infix operator `>>=` instead of `Deferred.bind`. It's more concise and readable.

### Understanding return

```ocaml
#show_val return;;
val return : 'a -> 'a Deferred.t
```

`return` takes a regular value and wraps it in a deferred. It's like putting a value in a box that's already filled.

```ocaml
let three = return 3;;
```
Creates a deferred that immediately contains the value `3`.

### Example: Count Lines (Incorrect)

```ocaml
let count_lines filename =
  Reader.file_contents filename
  >>= fun text ->
  List.length (String.split text ~on:'\n');;
```

**This fails because:**
- `Reader.file_contents filename` returns `string Deferred.t`
- The function after `>>=` must return a `'a Deferred.t`
- But `List.length (String.split text ~on:'\n')` returns just `int`
- We need to wrap it with `return`

### Example: Count Lines (Correct)

```ocaml
let count_lines filename =
  Reader.file_contents filename
  >>= fun text ->
  return (List.length (String.split text ~on:'\n'));;
```

Now it works because `return (...)` creates a deferred containing the result.

### Understanding map

```ocaml
#show Deferred.map;;
val map : 'a Deferred.t -> f:('a -> 'b) -> 'b Deferred.t
```

`map` is like `bind`, but the function doesn't need to return a deferred. It's equivalent to `bind` + `return`.

### Example: Count Lines with map

```ocaml
let count_lines filename =
  Reader.file_contents filename
  >>| fun text ->
  List.length (String.split text ~on:'\n');;
```

- `>>|` is the infix operator for `map`
- The function after `>>|` returns a regular value, not a deferred
- `map` automatically wraps the result in a deferred

---

## Let Syntax: Making Code Readable

OCaml provides special syntax to make working with deferreds look more like regular code.

### Loading Let Syntax

```ocaml
#require "ppx_let";;
```

This enables the special `let%bind` and `let%map` syntax.

### Using let%bind

```ocaml
let count_lines filename =
  let%bind text = Reader.file_contents filename in
  return (List.length (String.split text ~on:'\n'));;
```

**This is equivalent to:**
```ocaml
let count_lines filename =
  Reader.file_contents filename
  >>= fun text ->
  return (List.length (String.split text ~on:'\n'));;
```

### Using let%map

```ocaml
let count_lines filename =
  let%map text = Reader.file_contents filename in
  List.length (String.split text ~on:'\n');;
```

**This is equivalent to:**
```ocaml
let count_lines filename =
  Reader.file_contents filename
  >>| fun text ->
  List.length (String.split text ~on:'\n');;
```

### Why Let Syntax is Better

It makes async code look like regular sequential code:

```ocaml
let process_file filename =
  let%bind content = Reader.file_contents filename in
  let%bind () = Writer.save "backup.txt" ~contents:content in
  let%map lines = return (String.split content ~on:'\n') in
  List.length lines
```

This reads like:
1. Read the file content
2. Save a backup
3. Split into lines
4. Return the line count

---

## Ivars and Upon: Low-Level Building Blocks

### What is an Ivar?

An "ivar" (incremental variable) is like a box that you can fill exactly once. It's the building block that deferreds are made from.

### Three Operations with Ivars

```ocaml
let ivar = Ivar.create ();;
```
Creates an empty ivar.

```ocaml
let def = Ivar.read ivar;;
```
Gets the deferred associated with this ivar.

```ocaml
Deferred.peek def;;
```
Returns `None` because the ivar is still empty.

```ocaml
Ivar.fill ivar "Hello";;
```
Fills the ivar with a value.

```ocaml
Deferred.peek def;;
```
Now returns `Some "Hello"` because the ivar is filled.

### Understanding upon

```ocaml
#show upon;;
val upon : 'a Deferred.t -> ('a -> unit) -> unit
```

`upon` schedules a function to run when a deferred becomes determined, but unlike `bind`, it doesn't create a new deferred.

### Example: Delayer Module

This is a complex example that shows how to use ivars and upon to build synchronization primitives.

```ocaml
module type Delayer_intf = sig
  type t
  val create : Time.Span.t -> t
  val schedule : t -> (unit -> 'a Deferred.t) -> 'a Deferred.t
end;;
```

**This interface defines:**
- `type t` - the type of a delayer
- `create` - creates a delayer with a specific delay
- `schedule` - schedules a function to run after the delay

### The Implementation

```ocaml
module Delayer : Delayer_intf = struct
  type t = { delay: Time.Span.t;
             jobs: (unit -> unit) Queue.t;
           }
  
  let create delay =
    { delay; jobs = Queue.create () }
  
  let schedule t thunk =
    let ivar = Ivar.create () in
    Queue.enqueue t.jobs (fun () ->
      upon (thunk ()) (fun x -> Ivar.fill ivar x));
    upon (after t.delay) (fun () ->
      let job = Queue.dequeue_exn t.jobs in
      job ());
    Ivar.read ivar
end;;
```

**Breaking this down:**
1. `type t` contains a delay and a queue of jobs
2. `create delay` creates a new delayer with the specified delay
3. `schedule t thunk` schedules a job:
   - Creates an ivar to hold the result
   - Adds a job to the queue that will run the thunk and fill the ivar
   - Schedules the queue processing after the delay
   - Returns the deferred from the ivar

---

## Practical Example: Echo Server

Let's build a real server that echoes back whatever clients send to it.

### The copy_blocks Function

```ocaml
open Core
open Async

let rec copy_blocks buffer r w =
  match%bind Reader.read r buffer with
  | `Eof -> return ()
  | `Ok bytes_read ->
    Writer.write w (Bytes.to_string buffer) ~len:bytes_read;
    let%bind () = Writer.flushed w in
    copy_blocks buffer r w
```

**Line by line:**
1. `let rec` - this is a recursive function
2. `buffer` - a byte buffer for reading data
3. `r` - a reader (input stream)
4. `w` - a writer (output stream)
5. `match%bind Reader.read r buffer with` - read data from the reader
6. `| `Eof -> return ()` - if end of file, return unit deferred
7. `| `Ok bytes_read ->` - if we got data, `bytes_read` is how many bytes
8. `Writer.write w (Bytes.to_string buffer) ~len:bytes_read` - write data to output
9. `let%bind () = Writer.flushed w in` - wait until output is sent
10. `copy_blocks buffer r w` - recursively continue copying

### Why This Works

This function provides **pushback** - if writing becomes slow, it stops reading. This prevents memory from growing unboundedly.

### Setting Up the Server

```ocaml
let run () =
  let host_and_port =
    Tcp.Server.create
      ~on_handler_error:`Raise
      (Tcp.Where_to_listen.of_port 8765)
      (fun _addr r w ->
        let buffer = Bytes.create (16 * 1024) in
        copy_blocks buffer r w)
  in
  ignore
    (host_and_port
     : (Socket.Address.Inet.t, int) Tcp.Server.t Deferred.t)
```

**Breaking this down:**
1. `Tcp.Server.create` creates a TCP server
2. `~on_handler_error:`Raise` - raise exceptions if they occur
3. `Tcp.Where_to_listen.of_port 8765` - listen on port 8765
4. `fun _addr r w ->` - function called for each client connection
5. `_addr` - client address (ignored with `_`)
6. `r` - reader for this client
7. `w` - writer for this client
8. `Bytes.create (16 * 1024)` - create a 16KB buffer
9. `copy_blocks buffer r w` - start copying data
10. `ignore` - ignore the server handle (we don't need to shut it down)

### Starting the Server

```ocaml
let () =
  run ();
  never_returns (Scheduler.go ())
```

1. `run ()` - set up the server
2. `Scheduler.go ()` - start the Async scheduler
3. `never_returns` - indicates this function never returns

### Testing the Server

```bash
dune exec -- ./echo.exe &
echo "This is an echo server" | nc 127.0.0.1 8765
```

This starts the server in the background and sends it a message using netcat.

---

## Exception Handling in Async

### The Problem with Regular try/with

```ocaml
let maybe_raise =
  let should_fail = ref false in
  fun () ->
    let will_fail = !should_fail in
    should_fail := not will_fail;
    let%map () = after (Time.Span.of_sec 0.5) in
    if will_fail then raise Exit else ();;
```

This function alternates between succeeding and failing.

```ocaml
let handle_error () =
  try
    let%map () = maybe_raise () in
    "success"
  with _ -> return "failure";;
```

**This doesn't work because:**
- `try/with` only catches exceptions thrown immediately
- `maybe_raise ()` schedules a future computation that might fail
- The exception happens later, after the `try/with` has finished

### Using try_with

```ocaml
let handle_error () =
  match%map try_with (fun () -> maybe_raise ()) with
  | Ok () -> "success"
  | Error _ -> "failure";;
```

**How this works:**
1. `try_with` takes a function that returns a deferred
2. It returns a deferred containing either `Ok result` or `Error exception`
3. `match%map` waits for the result and handles both cases

### Monitors: The Foundation

Monitors are Async's system for handling exceptions. Every Async computation runs within a monitor.

**Key concepts:**
- Every Async job runs in a monitor
- Monitors form a tree (child monitors report to parents)
- You can create custom monitors for specific error handling

### Example: Custom Monitor

```ocaml
let blow_up () =
  let monitor = Monitor.create ~name:"blow up monitor" () in
  within' ~monitor maybe_raise;;
```

This creates a named monitor and runs `maybe_raise` within it.

### Advanced Monitor Usage

```ocaml
let swallow_error () =
  let monitor = Monitor.create () in
  Stream.iter (Monitor.detach_and_get_error_stream monitor)
    ~f:(fun _exn -> printf "an error happened\n");
  within' ~monitor (fun () ->
    let%bind () = after (Time.Span.of_sec 0.25) in
    failwith "Kaboom!");;
```

**This code:**
1. Creates a monitor
2. Detaches it from its parent
3. Gets the stream of errors
4. Prints a message for each error
5. Runs code that will fail

---

## Timeouts and Cancellation

### Waiting for Multiple Events

```ocaml
let string_and_float =
  Deferred.both
    (let%map () = after (sec 0.5) in "A")
    (let%map () = after (sec 0.25) in 32.33);;
```

`Deferred.both` waits for both deferreds to complete and returns both results.

### Waiting for the First Event

```ocaml
Deferred.any
  [ (let%map () = after (sec 0.5) in "half a second")
  ; (let%map () = after (sec 1.0) in "one second")
  ; (let%map () = after (sec 4.0) in "four seconds")
  ];;
```

`Deferred.any` returns as soon as any of the deferreds completes.

### Adding Timeouts

```ocaml
let get_definition_with_timeout ~server ~timeout word =
  Deferred.any
    [ (let%map () = after timeout in
       word, Error "Timed out")
    ; (match%map get_definition ~server word with
       | word, Error _ -> word, Error "Unexpected failure"
       | word, (Ok _ as x) -> word, x)
    ]
```

This races a timeout against the actual operation.

### Proper Cancellation with choose

```ocaml
let get_definition_with_timeout ~server ~timeout word =
  let interrupt = Ivar.create () in
  choose
    [ choice (after timeout) (fun () ->
        Ivar.fill interrupt ();
        word, Error "Timed out")
    ; choice
        (get_definition ~server ~interrupt:(Ivar.read interrupt) word)
        (fun (word, result) ->
          let result' =
            match result with
            | Ok _ as x -> x
            | Error _ -> Error "Unexpected failure"
          in
          word, result')
    ]
```

**How this works:**
1. Creates an interrupt ivar
2. Uses `choose` to pick between timeout and operation
3. If timeout fires, fills the interrupt ivar
4. The operation can check the interrupt and cancel itself

---

## Working with System Threads

### Why System Threads?

Even though Async is single-threaded, sometimes you need system threads for:
1. Operations that have no non-blocking alternative
2. Interfacing with non-OCaml libraries
3. CPU-intensive computations that would block Async

### Using In_thread.run

```ocaml
let def = In_thread.run (fun () -> List.range 1 10);;
```

This runs `List.range 1 10` on a separate thread and returns a deferred with the result.

### Thread Safety Concerns

```ocaml
let busy_loop () =
  let x = ref None in
  for i = 1 to 100_000_000 do x := Some i done;;
```

If you run this on the main thread:
```ocaml
log_delays (fun () -> return (busy_loop ()));;
```

The entire Async scheduler is blocked.

But if you run it on a thread:
```ocaml
log_delays (fun () -> In_thread.run busy_loop);;
```

Async continues to work, but timing becomes unpredictable due to OS scheduling.

### Rules for Thread Safety

1. **No shared mutable state** between threads
2. **No Async calls** from thread functions
3. Use **mutexes** when you must share mutable data

### Example: Thread-Safe Counter

```ocaml
open Core
open Async

let counter = ref 0
let counter_mutex = Mutex.create ()

let increment_counter () =
  Mutex.lock counter_mutex;
  incr counter;
  Mutex.unlock counter_mutex

let get_counter () =
  Mutex.lock counter_mutex;
  let value = !counter in
  Mutex.unlock counter_mutex;
  value
```

This ensures that only one thread can modify the counter at a time.

---

## Summary

### Key Takeaways

1. **Deferreds** are containers for future values
2. **bind** (>>=) sequences operations: "do this, then do that"
3. **map** (>>|) transforms values: "do this, then transform the result"
4. **return** wraps regular values in deferreds
5. **Let syntax** makes async code look like regular code
6. **Exception handling** requires special functions like `try_with`
7. **Timeouts** and **cancellation** require careful design
8. **System threads** are available but require careful handling

### Best Practices

1. **Use let syntax** for readability
2. **Always handle exceptions** in async code
3. **Implement pushback** to prevent memory leaks
4. **Use try_with** instead of try/with for async operations
5. **Be careful with system threads** - avoid shared mutable state
6. **Don't forget to start the scheduler** with `Scheduler.go ()`

OCaml's Async library provides a powerful and safe way to write concurrent programs. By understanding these concepts and following best practices, you can build efficient, responsive applications that handle multiple operations simultaneously without the complexity and pitfalls of traditional threading models.