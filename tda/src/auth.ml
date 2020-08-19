open Core
open Async
open Cohttp
open Cohttp_async
open Request
open Yojson
open Credentials
open Jsonhandling

let build_auth_body credpath tokenpath grant_type access_type =
  let refresh_token  =
    (fun (_,k,_) -> k) (read_tokens tokenpath)
  in
  let cred = read_credentials credpath in
  (fun (k, v) ->
  [ ("grant_type", grant_type);
    ("refresh_token", refresh_token);
    ("access_type", access_type);
    ("code", "");
    ("client_id", sprintf "%s@AMER.OAUTHAP" k);
    ("redirect_uri", v)
  ]) cred

let parse_body body = body
  |> List.map ~f:(fun (k, v) -> sprintf {|"%s" : "%s" |} k v)
  |> String.concat ~sep:", "
  |> sprintf "{%s}"
  |> Cohttp_async.Body.of_string

(* turn above to {|name, val|} *)

let json_auth =
  ["access_token";
   "refresh_token";
   "token_type";
   "expires_in";
   "scope";
   "refresh_token_expires_in";]

let auth_json_handle ~json =
  let returned_list = (fun (k,_) -> (json_options k)) json in
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
