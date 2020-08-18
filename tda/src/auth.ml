open Core
open Async
open Cohttp
open Cohttp_async
open Request
open Yojson

let build_auth_body credpath tokenpath grant_type access_type =
  let refresh_token  =
    (fun (_,k,_) -> k) (Credentials.read_tokens tokenpath)
  in
  let cred = Credentials.read_credentials credpath in
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

let imm_handle_resp (resp, body) =
  let code = resp |> Response.status |> Code.code_of_status in
  printf "Response Code: %d\n" code;
  printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_async.Body.to_string >>| fun body ->
  printf "Body of length: %d\n" (String.length body);
  body

let access_token_from_ref ?(credpath="credentials.json") ?(tokenpath="tokens.json") =
  let data = parse_body (build_auth_body credpath tokenpath "refresh_token" "offline") in
  let header = Header.of_list [("Content-Type", "application/x-www-form-urlencoded")] in
  let uri = Uri.of_string "https://api.tdameritrade.com/v1/oauth2/token" in

  let get_tokens json =
    match Yojson.Safe.from_string json with
    | `Assoc kv_list ->
      let find key =
        begin match List.Assoc.find ~equal:String.equal kv_list key with
          | None | Some (`String "") -> None
          | Some s -> Some (Yojson.Safe.to_string s)
        end
      in
      begin match find "access_token" with
        | Some _ as x -> x
        | None ->
          begin match find "refresh_token" with
            | Some _ as y -> y
            | None -> find "expires_in"
          end
      end
    | _ -> None
  in
  
  let make_req data headers uri =
    Client.post ~body:data ~headers:headers uri >>= fun (_,body) -> Cohttp_async.Body.to_string body >>| fun string -> (get_tokens string)
  in
  make_req data header uri
