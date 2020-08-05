val uri : string
type auth_data = {
  grant_type : string;
  refresh_token : string;
  access_type : string;
  code : string;
  client_id : string;
  redirect_uri : string;
}
val auth_data_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> auth_data
val sexp_of_auth_data : auth_data -> Ppx_sexp_conv_lib.Sexp.t
val preprocess_data : auth_data -> Cohttp_async.Body.t
val access_token_req :
  auth_data -> string -> Base.string Async_kernel__Deferred.t
