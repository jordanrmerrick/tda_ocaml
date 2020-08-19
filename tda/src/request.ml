open! Core
open! Async
open Cohttp
open Cohttp_async
open Api
    

let parse_get_body ~body ~uri =
  Uri.add_query_params uri body

let parse_body body = body
  |> List.map ~f:(fun (k, v) -> sprintf {|"%s" : "%s" |} k (String.concat ~sep:", " v))
  |> String.concat ~sep:", "
  |> sprintf "{%s}"
  |> Cohttp_async.Body.of_string
                            
let create_uri ?(body=[]) ~uri =
  let static = Uri.of_string ((fun (k, _) -> sprintf "https://api.tdameritrade.com/v1/%s" k) uri) in
  match uri with
  | (_, `GET) -> parse_get_body ~body:body ~uri:static
  | (_, _) -> static
  
let make_request ~uri ~body ~headers =
  let imm_handle_resp (resp, body) =
    let code = resp |> Response.status |> Code.code_of_status in
      printf "Response Code: %d\n" code;
      body |> Cohttp_async.Body.to_string >>| fun body ->
      body
  in
  let uri_ = create_uri ~body:body ~uri:uri in
  let header = Header.of_list headers in
  let body_ = parse_body body in
  match uri with
  | (_, `GET) -> Client.get ~headers:header uri_ >>= fun (resp, body) -> imm_handle_resp (resp, body)
  | (_, `POST) -> Client.post ~body:body_ ~headers:header uri_ >>= fun (resp, body) -> imm_handle_resp (resp, body)
  | (_, `PUT) -> Client.put ~body:body_ ~headers:header uri_ >>= fun (resp, body) -> imm_handle_resp (resp, body)
  | (_, `DELETE) -> Client.delete ~headers:header uri_ >>= fun (resp, body) -> imm_handle_resp (resp, body)
  | (_, _) -> raise_s (Sexp.of_string "Invalid method, how did you do this?!")

