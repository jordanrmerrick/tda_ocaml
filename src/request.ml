open Core


let check_search str =
  sprintf "%sX" str
    
let api_options ?(cusip="") ?(index="") ?(symbol="") ?(orderid="") ?(accountid="") ?(savedorderid="") ~t =
  match t with
  | `SEARCH -> "instruments"
  | `GET_INSTRUMENT -> cusip |> sprintf "instruments/%s"
  | `HOURS -> "marketdata/hours"
  | `MOVERS -> index |> sprintf "marketdata/%s/movers"
  | `OPTION_CHAIN -> "marketdata/chains"
  | `PRICE_HISTORY -> symbol |> sprintf "marketdata/%s/pricehistory"
  | `GET_QUOTE -> symbol |> sprintf "marketdata/%s/quotes"
  | `GET_QUOTES -> "marketdata/quotes"
  | `CANCEL_ORDER | `GET_ORDER | `REPLACE_ORDER -> accountid |> sprintf "accounts/%s/orders/%s"  orderid
  | `GET_ORDERS_BY_PATH | `PLACE_ORDER -> accountid |> sprintf "accounts/%s/orders"
  | `GET_ORDER_BY_QUERY -> "orders"
  | `CREATE_SAVED_ORDER | `GET_SAVED_ORDER_BY_PATH -> accountid |> sprintf "accounts/%s/savedorders"
  | `DELETE_SAVED_ORDER | `GET_SAVED_ORDER | `REPLACE_SAVED_ORDER -> accountid |> sprintf "accounts/%s/savedorders/%s" savedorderid
  | `GET_ACCOUNT -> accountid |> sprintf "accounts/%s"
  | `GET_ACCOUNTS -> "accounts"
(* TODO: Add watchlist, userinfo, and transaction history APIs *)


let build_req ?(cusip="") ?(index="") ?(symbol="") ?(orderid="") ?(accountid="") ?(savedorderid="") api_call  =
  let url = sprintf "https://api.tdameritrade.com/v1/%s" (api_options ~t:api_call ~cusip:cusip ~index:index ~symbol:symbol ~orderid:orderid ~accountid:accountid ~savedorderid:savedorderid)
  in
  url
