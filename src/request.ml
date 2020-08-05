open Core

let check_search str =
  sprintf "%sX" str
    
let api_options ?(cusip="") ?(index="") ?(symbol="") ?(orderid="") ?(accountid="") ?(savedorderid="") ~t =
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

(*let parse_api_type apio =
  match apio with
  | (x, `POST) -> Client.post *)
                       
type api_params =
  { cusip : string option;
    index : string option;
    symbol : string option;
    orderid : string option;
    accountid : string option;
    savedorderid : string option;
  } [@@deriving sexp]


let parse_get_body body uri = body
  |> List.map ~f:(fun (k, v) -> sprintf "?%s=%s" k (String.concat ~sep:"," v))
  |> String.concat ~sep:""
  |> sprintf "%s%s" uri


let create_uri ?(body=[]) ~uri =
  let static = (fun (k, _) -> sprintf "https://api.tdameritrade.com/v1/%s" k) uri in
  match uri with
  | (_, `GET) -> parse_get_body body static
  | (_, _) -> static
