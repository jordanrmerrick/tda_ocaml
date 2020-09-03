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

  let build_code = 
    let element = get_first_element (Str.split (Str.regexp "code=?") ((fun (k,_) -> k) (Credentials.read_code "code.json"))) in
    Compat.decode_url element

  let request_body ~grant_type ~refresh_token ~access_type ~code ~client_id ~redirect_uri =
    { grant_type = grant_type
    ; refresh_token = refresh_token
    ; access_type = access_type
    ; code = code
    ; client_id = client_id
    ; redirect_uri = redirect_uri
    }

  let initial_access_token (code : string) =
    let uri = Uri.of_string "https://api.tdameritrade.com/v1/oauth2/token" in
    let headers = [("Content-Type", "application/x-www-form-urlencoded")] in
    let headers = Header.of_list headers in
    let build_body =
      let build = (fun (k,v) -> ((sprintf "%s@AMER.OAUTHAP" k), v)) (read_credentials "credentials.json") in
      let req c r = 
        request_body 
        ~grant_type:"authorization_code" 
        ~refresh_token:"" 
        ~access_type:"offline" 
        ~code:code 
        ~client_id:c 
        ~redirect_uri:r in
      (fun (k,v) -> req k v) build
    in
    let body = parse_body build_body in
    Cohttp_async.Client.post ~body:body ~headers:headers uri >>= fun (_, body) -> Cohttp_async.Body.to_string body >>| fun string -> (Json.to_json ~json:string)


  let access_token ?(token_source="tokens.json") ?(credentials_source="credentials.json") (code : string)=
    let uri = Uri.of_string "https://api.tdameritrade.com/v1/oauth2/token" in
    let headers = [("Content-Type", "application/x-www-form-urlencoded")] in
    let headers = Header.of_list headers in
    let build_body = 
      let creds = (fun (k,v) -> ((sprintf "%s@AMER.OAUTHAP" k), v)) (read_credentials credentials_source) in
      let tokens = read_tokens token_source in
      let req ~client_id ~redirect ~refresh_token = 
        request_body 
        ~grant_type:"refresh_token" 
        ~refresh_token:refresh_token 
        ~access_type:"" 
        ~code:code
        ~client_id:client_id
        ~redirect_uri:redirect in
      req ~client_id:((fun (k,_) -> k) creds) ~redirect:((fun (_,v) -> v) creds) ~refresh_token:((fun (_,j,_) -> j) tokens)
    in
    let body = parse_body build_body in
    Cohttp_async.Client.post ~body:body ~headers:headers uri >>= fun (_, body) -> Cohttp_async.Body.to_string body >>| fun string -> (Json.to_json ~json:string)

  let get_tokens_reg ?(filename="generic.json") requests ~(output : string) =
    let cycle s = List.map ~f:(Jsonhandling.handle_json ~jsonfile:filename ~outfile:output) s in
    match List.length requests with
    | 0 -> raise_s (Sexp.of_string "Expected 1 argument, got 0")
    | 1 -> Deferred.all (List.map requests ~f:access_token) >>| fun results -> cycle results
    | _ as k -> let n = k |> sprintf "Expected 1 argument, got %d" in raise_s (Sexp.of_string n)

  let get_tokens_initial requests =
    match List.length requests with
    | 0 -> raise_s (Sexp.of_string "Expected 1 argument, got 0")
    | 1 -> Deferred.all (List.map requests ~f:initial_access_token) >>| fun results -> results
    | _ as k -> let n = k |> sprintf "Expected 1 argument, got %d" in raise_s (Sexp.of_string n)

end
