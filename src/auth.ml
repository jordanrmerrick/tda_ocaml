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
open Credentials
open Cohttp
open Cohttp_async
open Async

module Compat = struct

  let decoded = function
    | "%21" -> "!"
    | "%23" -> "#"
    | "%24" -> "$"
    | "%25" -> "%"
    | "%26" -> "&"
    | "%27" -> "'"
    | "%28" -> "("
    | "%29" -> ")"
    | "%2A" -> "*"
    | "%2B" -> "+"
    | "%2C" -> ","
    | "%2F" -> "/"
    | "%3A" -> ":"
    | "%3B" -> ";"
    | "%3D" -> "="
    | "%3F" -> "?"
    | "%40" -> "@"
    | "%5B" -> "["
    | "%5D" -> "]"
    | _ as k -> k

  let encoded = function
    | "!" -> "%21"
    | "#" -> "%23"
    | "$" -> "%24"
    | "%" -> "%25"
    | "&" -> "%26"
    | "'" -> "%27"
    | "(" -> "%28"
    | ")" -> "%29"
    | "*" -> "%2A"
    | "+" -> "%2B"
    | "," -> "%2C"
    | "/" -> "%2F"
    | ":" -> "%3A"
    | ";" -> "%3B"
    | "=" -> "%3D"
    | "?" -> "%3F"
    | "@" -> "%40"
    | "[" -> "%5B"
    | "]" -> "%5D"
    | _ as k -> k

  let string_to_string_list s =
    List.map ~f:String.of_char (String.to_list s)

  let string_to_string_array s =
    Array.map ~f:String.of_char (String.to_array s)

  let encode_url s =
    String.concat ~sep:"" (List.map ~f:encoded (string_to_string_list s))

  (* Sigh .. This URL decoding function isn't the best and has a couple exceptions that won't be met by the URLs being fed into it, yet is frustrating nonetheless.
     This will probably be replaced by a buffer at some point. *)
  let decode_url s =
    let rec helper ls arr n =
      match n with
      | 0 -> arr.(0)::ls
      | _ ->
        begin
        match arr.(n) with
          | "%" ->
          helper ((String.concat ~sep:"" [arr.(n); arr.(n-1); arr.(n-2)])::ls) arr (n-3)
        | _ as v -> helper (v::ls) arr (n-1)
      end
    in
    let a = string_to_string_array (String.rev s) in
    let s = helper [] a (Array.length a - 1) in
    let map_list = List.map ~f:decoded s in
    String.concat ~sep:"" (List.rev map_list)

end

module Json = struct

  let expected_vals =
    [ "access_token"
    ; "refresh_token"
    ; "token_type"
    ; "expires_in"
    ; "scope"
    ; "refresh_token_expires_in"
    ]
    [@@deprecated "expected_vals will be kept until further notice for compatability but is not actively used."]

  let handle_json ~(json : string) (k : string) =
    match Yojson.Safe.from_string json with
    | `Assoc kv_list ->
      let find key =
        begin match List.Assoc.find ~equal:String.equal kv_list key with
        | None | Some (`String "") -> None
        | Some s -> Some (Yojson.Safe.to_string s)
        end
      in
      begin match find k with
      | Some _ as x -> x
      | None -> Some (k |> sprintf "%s not found")
     end
    | _ -> None
    [@@deprecated "handle_json will be kept until further notice for compatability but is not actively used."]

  let find_all_values ~(json : string) =
    List.map ~f:(handle_json ~json:json) expected_vals
  [@@deprecated]

  let find_all_values_exn ~(json : string)=
    let matcher = function
      | None -> ""
      | Some x -> x
    in
    List.map ~f:matcher (find_all_values ~json:json)
  [@@deprecated]

  let to_json ~(json : string) =
    Yojson.Safe.from_string json

end

module Authentication = struct

  type auth_post =
    { grant_type : string [@default "authentication_code"]
    ; refresh_token : string
    ; access_type : string [@default "offline"]
    ; code : string
    ; client_id : string
    ; redirect_uri : string
    } [@@deriving sexp]

  let parse_body body =
    sprintf "grant_type=%s&refresh_token=%s&access_type=%s&code=%s&client_id=%s&redirect_uri=%s"
    body.grant_type
    body.refresh_token
    body.access_type
    body.code
    body.client_id
    body.redirect_uri
    |> Body.of_string

  let get_first_element ls =
    match ls with
    | [] -> ""
    | x::_ -> x

  let get_first_element_rev ls =
    match List.rev ls with
    | [] -> ""
    | x::_ -> x

  (* Exposed API for initial authorization *)
  let sent_url ?(redirecturi="") ?(clientid="") ~(m : string) =
    let meth m =
      match String.lowercase m with
      | "json" -> let c = read_credentials "credentials.json" in c
      | "string" -> (clientid, redirecturi)
      | _ -> raise_s (Sexp.of_string "Invalid_argument")
    in
    let parse_special_chars data =
      let url data =(fun (k,v) -> sprintf "redirect_uri=%s&clientid=%s@AMER.OAUTHAP" v k) data in
      sprintf "https://auth.tdameritrade.com/auth?response_type=code&%s" (Compat.encode_url (url data))
    in
    parse_special_chars (meth m)
      
  (* Exposed API for initial authorization *)
  let get_code_info (s : string) = 
    printf "Open this url in your browser and login:\n%s" s;
    print_endline "\n\nEnter the returned url into \"code.json\"\n\n";
    print_endline "Change the \"exists\" entry to \"true\". Initial authorization is complete!\n\n"

  let build_code ~(file_name : string)= 
    let element = get_first_element_rev (Str.split (Str.regexp "code=?") ((fun (k,_) -> k) (Credentials.read_code file_name))) in
    Compat.decode_url element

  let request_body ~refresh_token ~code ~client_id ~redirect_uri ~initial =
    match initial with
    | true -> 
      { grant_type = "authorization_code"
      ; refresh_token = ""
      ; access_type = "offline"
      ; code = code
      ; client_id = client_id
      ; redirect_uri = redirect_uri
      }
    | false -> 
      { grant_type = "refresh_token"
      ; refresh_token = refresh_token
      ; access_type = ""
      ; code = code
      ; client_id = client_id
      ; redirect_uri = redirect_uri
      }

  let initial_access_token_f ~(client_id : string) ~(redirect_uri : string) (code : string) =
    let uri = Uri.of_string "https://api.tdameritrade.com/v1/oauth2/token" in
    let headers = [("Content-Type", "application/x-www-form-urlencoded")] in
    let headers = Header.of_list headers in
    let build_body =
      request_body 
      ~refresh_token:""  
      ~code:code
      ~client_id:client_id
      ~redirect_uri:redirect_uri
      ~initial:true
    in
    let body = parse_body build_body in
    Cohttp_async.Client.post ~body:body ~headers:headers uri >>= fun (_, body) -> Cohttp_async.Body.to_string body >>| fun string -> (Json.to_json ~json:string)

  let access_token_f ~(refresh_token : string) ~(client_id : string) ~(redirect_uri : string) (code : string) =
    let uri = Uri.of_string "https://api.tdameritrade.com/v1/oauth2/token" in
    let headers = [("Content-Type", "application/x-www-form-urlencoded")] in
    let headers = Header.of_list headers in
    let build_body = 
      request_body 
      ~refresh_token:refresh_token 
      ~code:code
      ~client_id:client_id
      ~redirect_uri:redirect_uri
      ~initial:false
    in
    let body = parse_body build_body in
    Cohttp_async.Client.post ~body:body ~headers:headers uri >>= fun (_, body) -> Cohttp_async.Body.to_string body >>| fun string -> (Json.to_json ~json:string)

  let access_token ~(refresh_token : string) ~(client_id : string) ~(redirect_uri : string) ~(code : string) =
    let requests = [code] in
    let cycle s = List.map ~f:(Jsonhandling.to_string) s in
    Deferred.all (List.map ~f:(access_token_f ~refresh_token:refresh_token ~client_id:client_id ~redirect_uri:redirect_uri) requests) >>| fun results -> get_first_element (cycle results)

  let access_token_initial ~(client_id : string) ~(redirect_uri : string) ~(code : string) =
    let requests = [code] in
    let cycle s = List.map ~f:(Jsonhandling.to_string) s in
    Deferred.all (List.map ~f:(initial_access_token_f ~client_id:client_id ~redirect_uri:redirect_uri) requests) >>| fun results -> get_first_element (cycle results)

end 