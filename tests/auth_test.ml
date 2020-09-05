open Tda_ocaml
open Core

let t_e s1 s2 s3 = 
  let t =
  (Auth.Compat.encode_url s1,
   Auth.Compat.encode_url s2,
   Auth.Compat.encode_url s3
  )
  in
  let response1 = "ThereIsNoEncodingInThis" in
  let response2 = "ThereIs%2ASome%2AEncodingIn%26This" in
  let response3 = "T%24%23HereI%2ASL%28%29otsIfasdnklw%242u9a0d" in
  (fun (k,v,j) ->
    assert ((String.compare k response1)=0);
    assert ((String.compare v response2)=0);
    assert ((String.compare j response3)=0)
  ) t

let encode_test = t_e "ThereIsNoEncodingInThis" "ThereIs*Some*EncodingIn&This" "T$#HereI*SL()otsIfasdnklw$2u9a0d"

let t_d s1 s2 s3 =
  let t = 
  (Auth.Compat.decode_url s1,
   Auth.Compat.decode_url s2,
   Auth.Compat.decode_url s3)
  in
  let response1 = "ThereIsNoEncodingInThis" in
  let response2 = "ThereIs*Some*EncodingIn&This" in
  let response3 = "T$#HereI*SL()otsIfasdnklw$2u9a0d" in
  (fun (k,v,j) ->
    assert ((String.compare k response1)=0);
    assert ((String.compare v response2)=0);
    assert ((String.compare j response3)=0)
  ) t

let decode_test = t_d "ThereIsNoEncodingInThis" "ThereIs%2ASome%2AEncodingIn%26This" "T%24%23HereI%2ASL%28%29otsIfasdnklw%242u9a0d"
(*
  strings = "ThereIsNoEncodingInThis" "ThereIs*Some*EncodingIn&This" "T$#HereI*SL()otsIfasdnklw$2u9a0d"
  responses = "ThereIsNoEncodingInThis" "ThereIs%2ASome%2AEncodingIn%26This" "AT%24%23HereI%2ASL%28%29otsIfasdnklw%242u9a0d"
*)