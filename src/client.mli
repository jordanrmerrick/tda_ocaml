val uri : string
exception InvalidResponse
type data = {
  grant_type : string;
  refresh_token : string;
  access_type : string;
  code : string;
  client_id : string;
  redirect_uri : string;
}
val redirect_uri : data -> string
val client_id : data -> string
val code : data -> string
val access_type : data -> string
val refresh_token : data -> string
val grant_type : data -> string
module Fields_of_data :
  sig
    val names : string list
    val redirect_uri :
      ([< `Read | `Set_and_create ], data, string)
      Fieldslib.Field.t_with_perm
    val client_id :
      ([< `Read | `Set_and_create ], data, string)
      Fieldslib.Field.t_with_perm
    val code :
      ([< `Read | `Set_and_create ], data, string)
      Fieldslib.Field.t_with_perm
    val access_type :
      ([< `Read | `Set_and_create ], data, string)
      Fieldslib.Field.t_with_perm
    val refresh_token :
      ([< `Read | `Set_and_create ], data, string)
      Fieldslib.Field.t_with_perm
    val grant_type :
      ([< `Read | `Set_and_create ], data, string)
      Fieldslib.Field.t_with_perm
    val make_creator :
      grant_type:(([< `Read | `Set_and_create ], data, string)
                  Fieldslib.Field.t_with_perm -> 'a -> ('b -> string) * 'c) ->
      refresh_token:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> 'c -> ('b -> string) * 'd) ->
      access_type:(([< `Read | `Set_and_create ], data, string)
                   Fieldslib.Field.t_with_perm -> 'd -> ('b -> string) * 'e) ->
      code:(([< `Read | `Set_and_create ], data, string)
            Fieldslib.Field.t_with_perm -> 'e -> ('b -> string) * 'f) ->
      client_id:(([< `Read | `Set_and_create ], data, string)
                 Fieldslib.Field.t_with_perm -> 'f -> ('b -> string) * 'g) ->
      redirect_uri:(([< `Read | `Set_and_create ], data, string)
                    Fieldslib.Field.t_with_perm -> 'g -> ('b -> string) * 'h) ->
      'a -> ('b -> data) * 'h
    val create :
      grant_type:string ->
      refresh_token:string ->
      access_type:string ->
      code:string -> client_id:string -> redirect_uri:string -> data
    val map :
      grant_type:(([< `Read | `Set_and_create ], data, string)
                  Fieldslib.Field.t_with_perm -> string) ->
      refresh_token:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> string) ->
      access_type:(([< `Read | `Set_and_create ], data, string)
                   Fieldslib.Field.t_with_perm -> string) ->
      code:(([< `Read | `Set_and_create ], data, string)
            Fieldslib.Field.t_with_perm -> string) ->
      client_id:(([< `Read | `Set_and_create ], data, string)
                 Fieldslib.Field.t_with_perm -> string) ->
      redirect_uri:(([< `Read | `Set_and_create ], data, string)
                    Fieldslib.Field.t_with_perm -> string) ->
      data
    val iter :
      grant_type:(([< `Read | `Set_and_create ], data, string)
                  Fieldslib.Field.t_with_perm -> unit) ->
      refresh_token:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> unit) ->
      access_type:(([< `Read | `Set_and_create ], data, string)
                   Fieldslib.Field.t_with_perm -> unit) ->
      code:(([< `Read | `Set_and_create ], data, string)
            Fieldslib.Field.t_with_perm -> unit) ->
      client_id:(([< `Read | `Set_and_create ], data, string)
                 Fieldslib.Field.t_with_perm -> unit) ->
      redirect_uri:(([< `Read | `Set_and_create ], data, string)
                    Fieldslib.Field.t_with_perm -> unit) ->
      unit
    val fold :
      init:'a ->
      grant_type:('a ->
                  ([< `Read | `Set_and_create ], data, string)
                  Fieldslib.Field.t_with_perm -> 'b) ->
      refresh_token:('b ->
                     ([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> 'c) ->
      access_type:('c ->
                   ([< `Read | `Set_and_create ], data, string)
                   Fieldslib.Field.t_with_perm -> 'd) ->
      code:('d ->
            ([< `Read | `Set_and_create ], data, string)
            Fieldslib.Field.t_with_perm -> 'e) ->
      client_id:('e ->
                 ([< `Read | `Set_and_create ], data, string)
                 Fieldslib.Field.t_with_perm -> 'f) ->
      redirect_uri:('f ->
                    ([< `Read | `Set_and_create ], data, string)
                    Fieldslib.Field.t_with_perm -> 'g) ->
      'g
    val map_poly :
      ([< `Read | `Set_and_create ], data, 'a) Fieldslib.Field.user ->
      'a list
    val for_all :
      grant_type:(([< `Read | `Set_and_create ], data, string)
                  Fieldslib.Field.t_with_perm -> bool) ->
      refresh_token:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> bool) ->
      access_type:(([< `Read | `Set_and_create ], data, string)
                   Fieldslib.Field.t_with_perm -> bool) ->
      code:(([< `Read | `Set_and_create ], data, string)
            Fieldslib.Field.t_with_perm -> bool) ->
      client_id:(([< `Read | `Set_and_create ], data, string)
                 Fieldslib.Field.t_with_perm -> bool) ->
      redirect_uri:(([< `Read | `Set_and_create ], data, string)
                    Fieldslib.Field.t_with_perm -> bool) ->
      bool
    val exists :
      grant_type:(([< `Read | `Set_and_create ], data, string)
                  Fieldslib.Field.t_with_perm -> bool) ->
      refresh_token:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> bool) ->
      access_type:(([< `Read | `Set_and_create ], data, string)
                   Fieldslib.Field.t_with_perm -> bool) ->
      code:(([< `Read | `Set_and_create ], data, string)
            Fieldslib.Field.t_with_perm -> bool) ->
      client_id:(([< `Read | `Set_and_create ], data, string)
                 Fieldslib.Field.t_with_perm -> bool) ->
      redirect_uri:(([< `Read | `Set_and_create ], data, string)
                    Fieldslib.Field.t_with_perm -> bool) ->
      bool
    val to_list :
      grant_type:(([< `Read | `Set_and_create ], data, string)
                  Fieldslib.Field.t_with_perm -> 'a) ->
      refresh_token:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> 'a) ->
      access_type:(([< `Read | `Set_and_create ], data, string)
                   Fieldslib.Field.t_with_perm -> 'a) ->
      code:(([< `Read | `Set_and_create ], data, string)
            Fieldslib.Field.t_with_perm -> 'a) ->
      client_id:(([< `Read | `Set_and_create ], data, string)
                 Fieldslib.Field.t_with_perm -> 'a) ->
      redirect_uri:(([< `Read | `Set_and_create ], data, string)
                    Fieldslib.Field.t_with_perm -> 'a) ->
      'a list
    module Direct :
      sig
        val iter :
          data ->
          grant_type:(([< `Read | `Set_and_create ], data, string)
                      Fieldslib.Field.t_with_perm -> data -> string -> unit) ->
          refresh_token:(([< `Read | `Set_and_create ], data, string)
                         Fieldslib.Field.t_with_perm ->
                         data -> string -> unit) ->
          access_type:(([< `Read | `Set_and_create ], data, string)
                       Fieldslib.Field.t_with_perm -> data -> string -> unit) ->
          code:(([< `Read | `Set_and_create ], data, string)
                Fieldslib.Field.t_with_perm -> data -> string -> unit) ->
          client_id:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> data -> string -> unit) ->
          redirect_uri:(([< `Read | `Set_and_create ], data, string)
                        Fieldslib.Field.t_with_perm -> data -> string -> 'a) ->
          'a
        val fold :
          data ->
          init:'a ->
          grant_type:('a ->
                      ([< `Read | `Set_and_create ], data, string)
                      Fieldslib.Field.t_with_perm -> data -> string -> 'b) ->
          refresh_token:('b ->
                         ([< `Read | `Set_and_create ], data, string)
                         Fieldslib.Field.t_with_perm -> data -> string -> 'c) ->
          access_type:('c ->
                       ([< `Read | `Set_and_create ], data, string)
                       Fieldslib.Field.t_with_perm -> data -> string -> 'd) ->
          code:('d ->
                ([< `Read | `Set_and_create ], data, string)
                Fieldslib.Field.t_with_perm -> data -> string -> 'e) ->
          client_id:('e ->
                     ([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> data -> string -> 'f) ->
          redirect_uri:('f ->
                        ([< `Read | `Set_and_create ], data, string)
                        Fieldslib.Field.t_with_perm -> data -> string -> 'g) ->
          'g
        val for_all :
          data ->
          grant_type:(([< `Read | `Set_and_create ], data, string)
                      Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          refresh_token:(([< `Read | `Set_and_create ], data, string)
                         Fieldslib.Field.t_with_perm ->
                         data -> string -> bool) ->
          access_type:(([< `Read | `Set_and_create ], data, string)
                       Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          code:(([< `Read | `Set_and_create ], data, string)
                Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          client_id:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          redirect_uri:(([< `Read | `Set_and_create ], data, string)
                        Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          bool
        val exists :
          data ->
          grant_type:(([< `Read | `Set_and_create ], data, string)
                      Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          refresh_token:(([< `Read | `Set_and_create ], data, string)
                         Fieldslib.Field.t_with_perm ->
                         data -> string -> bool) ->
          access_type:(([< `Read | `Set_and_create ], data, string)
                       Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          code:(([< `Read | `Set_and_create ], data, string)
                Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          client_id:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          redirect_uri:(([< `Read | `Set_and_create ], data, string)
                        Fieldslib.Field.t_with_perm -> data -> string -> bool) ->
          bool
        val to_list :
          data ->
          grant_type:(([< `Read | `Set_and_create ], data, string)
                      Fieldslib.Field.t_with_perm -> data -> string -> 'a) ->
          refresh_token:(([< `Read | `Set_and_create ], data, string)
                         Fieldslib.Field.t_with_perm -> data -> string -> 'a) ->
          access_type:(([< `Read | `Set_and_create ], data, string)
                       Fieldslib.Field.t_with_perm -> data -> string -> 'a) ->
          code:(([< `Read | `Set_and_create ], data, string)
                Fieldslib.Field.t_with_perm -> data -> string -> 'a) ->
          client_id:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> data -> string -> 'a) ->
          redirect_uri:(([< `Read | `Set_and_create ], data, string)
                        Fieldslib.Field.t_with_perm -> data -> string -> 'a) ->
          'a list
        val map :
          data ->
          grant_type:(([< `Read | `Set_and_create ], data, string)
                      Fieldslib.Field.t_with_perm -> data -> string -> string) ->
          refresh_token:(([< `Read | `Set_and_create ], data, string)
                         Fieldslib.Field.t_with_perm ->
                         data -> string -> string) ->
          access_type:(([< `Read | `Set_and_create ], data, string)
                       Fieldslib.Field.t_with_perm ->
                       data -> string -> string) ->
          code:(([< `Read | `Set_and_create ], data, string)
                Fieldslib.Field.t_with_perm -> data -> string -> string) ->
          client_id:(([< `Read | `Set_and_create ], data, string)
                     Fieldslib.Field.t_with_perm -> data -> string -> string) ->
          redirect_uri:(([< `Read | `Set_and_create ], data, string)
                        Fieldslib.Field.t_with_perm ->
                        data -> string -> string) ->
          data
        val set_all_mutable_fields : 'a -> unit
      end
  end
val data_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> data
val sexp_of_data : data -> Ppx_sexp_conv_lib.Sexp.t
val preprocess_data : data -> Cohttp_async.Body.t
val access_token_req : data -> string -> Base.string Async_kernel__Deferred.t
