open Core 
open Async 

(* Copy data from the reader to the writer, using the provided buffer as scratch space *)

let rec copy_blocks buffer r w = 
  match%bind Reader.read r buffer with 
  | `Eof -> return () 
  | `Ok bytes_read -> 
  Writer.write w (Bytes.to_string buffer) ~len:bytes_read; 
  let %bind () = Writer.flushed w in 
  copy_blocks buffer r w 