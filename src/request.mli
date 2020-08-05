val check_search : string -> string
val api_options :
  ?cusip:string ->
  ?index:string ->
  ?symbol:string ->
  ?orderid:string ->
  ?accountid:string ->
  ?savedorderid:string ->
  t:[< `CANCEL_ORDER
     | `CREATE_SAVED_ORDER
     | `DELETE_SAVED_ORDER
     | `GET_ACCOUNT
     | `GET_ACCOUNTS
     | `GET_INSTRUMENT
     | `GET_ORDER
     | `GET_ORDERS_BY_PATH
     | `GET_ORDER_BY_QUERY
     | `GET_QUOTE
     | `GET_QUOTES
     | `GET_SAVED_ORDER
     | `GET_SAVED_ORDER_BY_PATH
     | `HOURS
     | `MOVERS
     | `OPTION_CHAIN
     | `PLACE_ORDER
     | `PRICE_HISTORY
     | `REPLACE_ORDER
     | `REPLACE_SAVED_ORDER
     | `SEARCH ] ->
  string * [> `DELETE | `GET | `POST | `PUT ]
type api_params = {
  cusip : string option;
  index : string option;
  symbol : string option;
  orderid : string option;
  accountid : string option;
  savedorderid : string option;
}
val api_params_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> api_params
val sexp_of_api_params : api_params -> Ppx_sexp_conv_lib.Sexp.t
val parse_get_body : (string * string list) list -> string -> string
val create_uri :
  ?body:(string * string list) list -> uri:string * [> `GET ] -> string
