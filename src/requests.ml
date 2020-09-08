open Core
open Cohttp
open Cohttp_async
open Async

(* For now, we will only focus on urlencoded bodies, not json objects *)
let build_body ls =
  let parse_body s (k,v) = sprintf "%s&%s=%s" s k v in
  let rec bls s ls =
    match ls with
    | [] -> s
    | x::xs -> bls (parse_body s x) xs in
  (bls "" ls)

let bearer ls =
  let if_bearer (k,v) = 
    if (String.compare "Authorization" k) = 0 then
      match (String.compare "Bearer" v) with
      | 0 -> (k,v)
      | _ -> let s = sprintf "%s%s" "Bearer " v in (k,s)
    else (k,v)
  in
  List.map ~f:if_bearer ls

let build_header ls =
  Header.of_list (bearer ls)

let rt_t_m (k,v) body headers =
  match v with
   `GET -> 
    let get_body url body =
      Uri.of_string (sprintf "%s%s?%s" "https://api.tdameritrade.com/v1/" url (build_body body))
    in
    let headers = build_header headers in
    Client.call ~headers: headers v (get_body k body)
  | `POST | `DELETE | `PUT -> 
    let body = Body.of_string (build_body body) in
    let headers = build_header headers in
    let uri = Uri.of_string (sprintf "%s%s" "https://api.tdameritrade.com/v1/" k) in
    Client.call ~body:body ~headers:headers v uri 
  | _ -> raise_s (Sexp.of_string "That HTTP method is not a valid way to access TDAmeritrade's API. Please use `GET, `POST, `DELETE, or `PUT.")

let handle_response (cbt : (Response.t * Cohttp_async.Body.t) Async_kernel.Deferred.t) =
  cbt >>= fun (resp, body) -> 
    match Cohttp.Response.(resp.status) with
    | #Code.success_status ->
      Body.to_string body >>| fun s -> s
    | _ -> raise_s (Response.sexp_of_t resp)

module Exposed = struct
  (* Temporary function to build upon *)
  let make_request ~(body : (string * string) list) ~(headers : (string * string) list) request_type =
    (body, headers, request_type)
end