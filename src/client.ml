open Core
open Async
open Cohttp
open Cohttp_async

module TDAuth = struct
  let uri = "https://api.tdameritrade.com/v1/oauth2/token"
  (*
     Sexp for authentication.
  *)

  type data = {
    grant_type : string;
    refresh_token : string;
    access_type : string;
    code : string;
    client_id : string;
    redirect_uri : string;
  } [@@deriving sexp]

  let preprocess_data d =
    Cohttp_async.Body.of_string (Sexp.to_string (sexp_of_data d))

  let access_token_req data meth conkey =
    let uri = sprintf "%s@AMER.OAUTHAP" conkey |> Uri.of_string in
    let header = Header.of_list [("Content-Type", "application/x-www-form-urlencoded")] in
    
    let make_req data headers m uri =
      match m with
      | `POST -> [Client.post ~body:(data) uri ~headers:(headers) >>= fun (resp, body) ->
        match resp with
        | { Cohttp.Response.status = `OK; _ } -> Body.to_string body
        | { Cohttp.Response.status= _; _ } -> raise_s (Sexp.of_string "Invalid Status Code")]
      | _ -> []
    in
    make_req (preprocess_data data) header meth uri

  let () =
    let body = { grant_type="adwaidhsd"; refresh_token=""; access_type="acmkadw1124"; code="oooof"; client_id="lacktis"; redirect_uri="https://localhost:8992" } in
    let val_change v = List.map ~f:Deferred.value_exn v in
    List.iter ~f:print_string  (val_change (access_token_req body `POST "2212646"))

end
