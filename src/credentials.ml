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

module HandleJson = struct
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

  let read_code json =
    let _json = read_from_json json in
    let code = _json |> member "code" |> to_string in
    let exists = _json |> member "exists" |> to_string in
    (code, exists)

  let write_tokens ?(json="tokens.json") ~access_token ~refresh_token ~expiration =
    let (j : Yojson.Safe.t) =`Assoc [ ("access_token", `String access_token); ("refresh_token", `String refresh_token); ("expiration", `String expiration) ] in
    Yojson.Safe.to_file json j

  let write_code ?(json="code.json") ?(exists="true") ~code =
    let (j : Yojson.Safe.t) = `Assoc [ ("code", `String code); ("exists", `String exists) ] in
    Yojson.Safe.to_file json j

end [@@deprecated "The credentials module doesn't serve a use for now, may be undeprecated in the future"]