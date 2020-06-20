(* Copyright (C) 2020 Takayuki Goto.
 *
 * MLYacc-Poly/ML is imported from MLton.
 * See the LICENSE file for details.
 *)

structure Main =
struct

fun usage s =
  raise Fail (concat[s, "\n", "Usage: ", CommandLine.name(), " ", "file.grm"])

fun main args =
  case args
    of [file] => ParseGen.parseGen file
     | [] => usage "no file"
     | _ => usage "too many files"

val main = fn () => (
    main (CommandLine.arguments());
    OS.Process.exit OS.Process.success
  ) handle Fail msg => (
    print(concat["Fail: ", msg, "\n"]);
    OS.Process.exit OS.Process.failure
  ) handle exn => (
    print(concat[exnMessage exn, "\n"]);
    OS.Process.exit OS.Process.failure
  )
end
