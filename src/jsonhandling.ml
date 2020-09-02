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

type t =
  | Raw of Yojson.Safe.t
  | Json of unit
  | String_object of string

let handle_json ~(outfile : string) ~(jsonfile : string) (json : Yojson.Safe.t) =
  match outfile with
  | "raw" -> Raw (to_json_raw json)
  | "json" -> Json (to_json_file ~jsonfile:jsonfile json)
  | "string" -> String_object (to_string json)
  | _ -> raise_s (Sexp.of_string "Invalid output option, choose \"raw\", \"json\", or \"string\"")
