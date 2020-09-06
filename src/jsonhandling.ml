  (*{{{ Copyright (C) 2020 Jordan Merrick <jordanmerrick@me.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
  }}}*)

open Core
open Request_types

let json_handle ~json ~order_type =
  let returned_list = (fun (k,_) -> (json_options k)) order_type in
  let json_val = (fun (_,v) -> v) json in
  match Yojson.Safe.from_string json_val with
  | `Assoc kv_list ->
    let find key =
      begin match List.Assoc.find ~equal:String.equal kv_list key with
        | None | Some (`String "") -> None
        | Some s -> Some (Yojson.Safe.to_string s)
      end
    in
    let append ls1 ls2 =
      let rec loop tl ls1 ls2 =
        match ls1, ls2 with
        | [], [] -> List.rev tl
        | [], h :: t -> loop (h :: tl) [] t
        | h :: t, ls -> loop (h :: tl) t ls
      in
      loop [] ls1 ls2
    in
    let rec helper ls1 ls2 =
      match ls1 with
      | [] -> ls2
      | h :: t -> helper t (append [find h] ls2)
    in
    helper returned_list []
  | _ -> []
         
let to_file (json : Yojson.Safe.t) ~(jsonfile : string) =
  Yojson.Safe.to_file jsonfile json

let to_json_file ~(jsonfile : string) (json : Yojson.Safe.t) =
  let is_json_file filename suffix =
    String.is_substring ~substring:suffix filename
  in
  if (is_json_file jsonfile ".json") then
    begin
    to_file json ~jsonfile:jsonfile
    end
  else raise_s (Sexp.of_string "No .json suffix found")

let to_json_raw (json : Yojson.Safe.t)=
  json

let to_string (json : Yojson.Safe.t) =
  Yojson.Safe.to_string json