open Core
open Async
open Cohttp
open Cohttp_async
   
let api_options ?(cusip="") ?(index="") ?(symbol="") ?(orderid="") ?(accountid="") ?(savedorderid="") t =
    match t with
    | `SEARCH -> ("instruments", `GET)
    | `GET_INSTRUMENT -> ((cusip |> sprintf "instruments/%s"), `GET)
    | `HOURS -> ("marketdata/hours", `GET)
    | `MOVERS -> ((index |> sprintf "marketdata/%s/movers"), `GET)
    | `OPTION_CHAIN -> ("marketdata/chains", `GET)
    | `PRICE_HISTORY -> ((symbol |> sprintf "marketdata/%s/pricehistory"), `GET)
    | `GET_QUOTE -> ((symbol |> sprintf "marketdata/%s/quotes"), `GET)
    | `GET_QUOTES -> ("marketdata/quotes", `GET)
    | `CANCEL_ORDER ->(( accountid |> sprintf "accounts/%s/orders/%s" orderid), `DELETE)
    | `GET_ORDER -> ((accountid |> sprintf "accounts/%s/orders/%s" orderid), `GET)
    | `REPLACE_ORDER -> ((accountid |> sprintf "accounts/%s/orders/%s" orderid), `PUT)
    | `GET_ORDERS_BY_PATH -> ((accountid |> sprintf "accounts/%s/orders"), `GET)
    | `PLACE_ORDER -> ((accountid |> sprintf "accounts/%s/orders"), `POST)
    | `GET_ORDER_BY_QUERY -> ("orders", `GET)
    | `CREATE_SAVED_ORDER -> ((accountid |> sprintf "accounts/%s/savedorders"), `POST)
    | `GET_SAVED_ORDER_BY_PATH -> ((accountid |> sprintf "accounts/%s/savedorders"), `GET)
    | `DELETE_SAVED_ORDER -> ((accountid |> sprintf "accounts/%s/savedorders/%s" savedorderid), `DELETE)
    | `GET_SAVED_ORDER -> ((accountid |> sprintf "accounts/%s/savedorders/%s" savedorderid), `GET)
    | `REPLACE_SAVED_ORDER -> ((accountid |> sprintf "accounts/%s/savedorders/%s" savedorderid), `PUT)
    | `GET_ACCOUNT -> ((accountid |> sprintf "accounts/%s"), `GET)
    | `GET_ACCOUNTS -> ("accounts", `GET)
  (* TODO: Add watchlist, userinfo, and transaction history APIs *)

let parse_get_body body = body
  |> List.map ~f:(fun (k, v) -> sprintf "?%s=%s" k v)
  |> String.concat ~sep:""

let parse_body body = body
  |> List.map ~f:(fun (k, v) -> sprintf {|"%s" : "%s" |} k v)
  |> String.concat ~sep:", "
  |> sprintf "{%s}"
  |> Cohttp_async.Body.of_string
                            
let create_uri ?(body=[]) ~uri =
  let static = (fun (k, _) -> sprintf "https://api.tdameritrade.com/v1/%s" k) uri in
  match uri with
  | (_, `GET) -> sprintf "%s%s" static (parse_get_body body)
  | (_, _) -> static

let imm_handle_resp (resp, body) =
  match resp with
  | { Cohttp.Response.status = `OK; _ } -> Body.to_string body
  | { Cohttp.Response.status= _; _ } -> raise_s (Sexp.of_string "Invalid resp")

let make_client_req ~uri ~body ~headers =
  let uri_ = Uri.of_string (create_uri ~body:body ~uri:uri) in
  let header = Header.of_list headers in
  let body_ = parse_body body in
  match uri with
  | (_, `GET) -> Client.get ~headers:header uri_ >>= fun (resp, body) -> imm_handle_resp (resp, body)
  | (_, `POST) -> Client.post ~body:body_ ~headers:header uri_ >>= fun (resp, body) -> imm_handle_resp (resp, body)
  | (_, `PUT) -> Client.put ~body:body_ ~headers:header uri_ >>= fun (resp, body) -> imm_handle_resp (resp, body)
  | (_, `DELETE) -> Client.delete ~headers:header uri_ >>= fun (resp, body) -> imm_handle_resp (resp, body)
  | (_, _) -> raise_s (Sexp.of_string "Invalid method, how did you do this?!")

let () =
  let uri = (api_options ~symbol:"AAPL" `PRICE_HISTORY) in
  let body = [("apikey", "asndiw1902139hdsa");
              ("markets", "EQUITY,FUTURE,FOREX");
              ("date", "2020-08-06")] in
  let headers = [("Authorization", "Adasiodiidbasd")] in
  let mc = (make_client_req ~uri:uri ~body:body ~headers:headers) in
  upon mc
    (fun line -> print_endline line)


