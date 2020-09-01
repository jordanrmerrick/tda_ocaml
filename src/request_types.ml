  (*{{{ Copyright (C) 2020 Jordan Merrick <jordanmerrick@me.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
  }}}*)

open Core

let api_options ?(cusip="") ?(index="") ?(symbol="") ?(orderid="") ?(accountid="") ?(savedorderid="") t =
  match t with
  | `SEARCH -> "instruments"
  | `GET_INSTRUMENT -> cusip |> sprintf "instruments/%s"
  | `HOURS -> "marketdata/hours"
  | `MOVERS -> index |> sprintf "marketdata/%s/movers"
  | `OPTION_CHAIN -> "marketdata/chains"
  | `PRICE_HISTORY -> symbol |> sprintf "marketdata/%s/pricehistory"
  | `GET_QUOTE -> symbol |> sprintf "marketdata/%s/quotes"
  | `GET_QUOTES -> "marketdata/quotes"
  | `CANCEL_ORDER
  | `GET_ORDER
  | `REPLACE_ORDER -> accountid |> sprintf "accounts/%s/orders/%s" orderid
  | `GET_ORDERS_BY_PATH -> accountid |> sprintf "accounts/%s/orders"
  | `PLACE_ORDER -> accountid |> sprintf "accounts/%s/orders"
  | `GET_ORDER_BY_QUERY -> "orders"
  | `CREATE_SAVED_ORDER
  | `GET_SAVED_ORDER_BY_PATH -> accountid |> sprintf "accounts/%s/savedorders"
  | `DELETE_SAVED_ORDER
  | `GET_SAVED_ORDER
  | `REPLACE_SAVED_ORDER -> accountid |> sprintf "accounts/%s/savedorders/%s" savedorderid
  | `GET_ACCOUNT -> accountid |> sprintf "accounts/%s"
  | `GET_ACCOUNTS -> "accounts"

let api_to_string t =
  match t with
  | `SEARCH -> "search"
  | `GET_INSTRUMENT -> "get_instrument"
  | `HOURS -> "hours"
  | `MOVERS -> "movers"
  | `OPTION_CHAIN -> "option_chain"
  | `PRICE_HISTORY -> "price_history"
  | `GET_QUOTE -> "get_quote"
  | `GET_QUOTES -> "get_quotes"
  | `CANCEL_ORDER -> "cancel_order"
  | `GET_ORDER -> "get_order"
  | `REPLACE_ORDER -> "replace_order"
  | `GET_ORDERS_BY_PATH -> "get_orders_by_path"
  | `PLACE_ORDER -> "place_order"
  | `GET_ORDER_BY_QUERY -> "get_order_by_query"
  | `CREATE_SAVED_ORDER -> "create_saved_order"
  | `GET_SAVED_ORDER_BY_PATH -> "get_saved_order_by_path"
  | `DELETE_SAVED_ORDER -> "delete_saved_order"
  | `GET_SAVED_ORDER -> "get_saved_order"
  | `REPLACE_SAVED_ORDER -> "replace_saved_order"
  | `GET_ACCOUNT -> "get_account"
  | `GET_ACCOUNTS -> "get_accounts"

let string_to_api s =
  match String.lowercase s with
  | "search" -> `SEARCH
  | "get_instrument" -> `GET_INSTRUMENT
  | "hours" -> `HOURS
  | "movers" -> `MOVERS
  | "option_chain" -> `OPTION_CHAIN
  | "price_history" -> `PRICE_HISTORY
  | "get_quote" -> `GET_QUOTE
  | "get_quotes" -> `GET_QUOTES
  | "cancel_order" -> `CANCEL_ORDER
  | "get_order" -> `GET_ORDER
  | "replace_order" -> `REPLACE_ORDER
  | "get_orders_by_path"  -> `GET_ORDERS_BY_PATH
  | "place_order" -> `PLACE_ORDER
  | "get_order_by_query" -> `GET_ORDER_BY_QUERY
  | "create_saved_order" -> `CREATE_SAVED_ORDER
  | "get_saved_order_by_path" -> `GET_SAVED_ORDER_BY_PATH
  | "delete_saved_order" -> `DELETE_SAVED_ORDER
  | "get_saved_order" -> `GET_SAVED_ORDER
  | "replace_saved_order" -> `REPLACE_SAVED_ORDER
  | "get_account" -> `GET_ACCOUNT
  | "get_accounts" -> `GET_ACCOUNTS
  | _ as k -> let no_such = k |> sprintf " no such %s" in raise_s (Sexp.of_string no_such)

(* Temp function to satisfy external dependencies *)
let json_options t =
  match t with
  | _ as k -> k