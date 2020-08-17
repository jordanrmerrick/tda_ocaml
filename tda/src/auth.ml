open Core
open Async
open Cohttp
open Cohttp_async

let build_auth_body json grant_type ?(refresh_token="") access_type =
  let cred = Credentials.read_credentials json in
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

let access_token_req data =

  let header = Header.of_list [("Content-Type", "application/x-www-form-urlencoded")] in
  let uri = Uri.of_string "https://api.tdameritrade.com/v1/oauth2/token" in

  let make_req data headers uri =
    Client.post ~body:data ~headers:headers uri >>= fun (resp,body) ->
    imm_handle_resp (resp, body)
  in
  make_req data header uri

let extract n =
  match n with
  | None -> "_"
  | Some x -> sprintf "AHHHH %s" x
