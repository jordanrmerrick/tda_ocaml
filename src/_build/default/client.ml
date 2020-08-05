open Core
open Async
open Cohttp
open Cohttp_async
open Sexplib0.Sexp_conv


let uri = "https://api.tdameritrade.com/v1/oauth2/token"
(*
   Sexp for authentication.
*)

exception InvalidResponse

type data = {
  grant_type : string;
  refresh_token : string;
  access_type : string;
  code : string;
  client_id : string;
  redirect_uri : string;
} [@@deriving fields, sexp]

let preprocess_data d =
  Cohttp_async.Body.of_string (Sexp.to_string (sexp_of_data d))

let access_token_req data conkey =
  let uri = sprintf "%s@AMER.OAUTHAP" conkey |> Uri.of_string in
  let header = Header.of_list [("Content-Type", "application/x-www-form-urlencoded")] in

  let make_req data headers uri =
    Client.post ~body:data uri ~headers:headers >>= fun (resp, body) ->
      match resp with
      | { Cohttp.Response.status = `OK; _ } -> Body.to_string body
      | { Cohttp.Response.status= _; _ } -> raise InvalidResponse
  in
  make_req (preprocess_data data) header uri

