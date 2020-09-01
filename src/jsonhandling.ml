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