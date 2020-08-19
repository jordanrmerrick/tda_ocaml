open Core

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

let json_options t =
  match t with
    | `SEARCH -> ["category"; "date"; "exchange"; "isOpen"; "marketType"; "product"; "productName"; "sessionHours";]
    | `GET_INSTRUMENT -> []
    | `HOURS -> []
    | `MOVERS -> []
    | `OPTION_CHAIN -> []
    | `PRICE_HISTORY -> []
    | `GET_QUOTE -> []
    | `GET_QUOTES -> []
    | `CANCEL_ORDER -> []
    | `GET_ORDER -> []
    | `REPLACE_ORDER -> []
    | `GET_ORDERS_BY_PATH -> []
    | `PLACE_ORDER -> []
    | `GET_ORDER_BY_QUERY -> []
    | `CREATE_SAVED_ORDER -> []
    | `GET_SAVED_ORDER_BY_PATH -> []
    | `DELETE_SAVED_ORDER -> []
    | `GET_SAVED_ORDER -> []
    | `REPLACE_SAVED_ORDER -> []
    | `GET_ACCOUNT -> []
    | `GET_ACCOUNTS -> []
    | `POST_ACCESS_TOKEN -> ["access_token";"refresh_token";"token_type";"expires_in";"scope";"refresh_token_expires_in";]
