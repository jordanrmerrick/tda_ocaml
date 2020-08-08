open Yojson.Safe.Util
       

let read_from_json j =
  Yojson.Safe.from_file j

let read_credentials json =
  let _json = read_from_json json in
  let cons_key = _json |> member "consumer_key" |> to_string in
  let callback = _json |> member "callback_uri" |> to_string in
  (cons_key, callback)

let read_tokens json =
  let _json = read_from_json json in
  let access = _json |> member "access_token" |> to_string in
  let refresh = _json |> member "refresh_token" |> to_string in
  let expiration = _json |> member "expiration" |> to_string in
  (access, refresh, expiration)

let write_tokens json ~access_token ~refresh_token ~expiration =
  let (j : Yojson.Safe.t) =`Assoc [ ("access_token", `String access_token); ("refresh_token", `String refresh_token); ("expiration", `String expiration) ] in
  Yojson.Safe.to_file json j

let build_url =
  let c = read_credentials "credentials.json" in
  let parse_special_chars data =
    let url data = (fun (k,v) -> Printf.sprintf "redirect_uri=%s&clientid=%s@AMER.OAUTHAP" v k) data in
    (* replace :// with %3A%2F%2F *)
    let replace t = t
      |> Str.global_replace (Str.regexp ":") "%3A"
      |> Str.global_replace (Str.regexp "/") "%2F"
      |> Str.global_replace (Str.regexp "@") "%40"
    in
    Printf.sprintf "https://auth.tdameritrade.com/auth?response_type=code&%s" (replace (url data))
  in
  parse_special_chars c
