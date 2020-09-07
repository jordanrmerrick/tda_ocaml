# Changes are explained in detail here.

### 0668c63
- All `.json` files removed because their use has been deprecated.
- `credentials.ml` has been deprecated and is no longer in use. All functions have been moved into `module HandleJson` which has been deprecated. The file has also been removed from `tda_ocaml.ml`, so it will no longer be automatically compiled. File will be removed by 1.0.
- Functions used as part of the first-time authentication process have been moved to `module Exposed`.
- `Authentication.request_body` has been changed to pattern match a new argument, `initial` which tells the function whether or not this is the initial authentication process. It will build the request body based on whether the argument is true or false.
- `include Authentication` was removed from `Auth.Exposed` because it exposed all of the endpoints, which was dumb of me.
- `Request_types` has been updated to return `(string * Code.meth)`, which is the url extension and the method used for that API. A variant has also had its name updated to reflect TDA documentation; `api_to_string` and `string_to_api` have been updated accordingly.
- `request.ml` has been created to handle the actual API requests! Functions to build headers, bodies, and make the HTTP requests have been built. The handling of the requests will come next.

### 8f839a8
- module `Exposed` added for exposed authentication APIs. `include Exposed` added to EOF to expose them.
- `request_body` had a `|` removed from the pattern match to keep the syntax consistent.

### 1bca6d4
- `Auth.Authentication` -> `access_token` changed to `access_token_f` and now takes string arguments that are directly passed to the request body. This replaces a string argument which opened a json file from `jsonhandling.ml`.
- `get_access_token` changed to `access_token` and now takes additional string arguments to be passed to `access_token_f`.
- `get_access_token` no longer takes a `string list` as an argument, replaced with argument `code`. It also outputs a `string Deferred.t`, replacing a `string list Deferred.t`.

### cbb8a9ae
- `Auth.Authentication.get_access_token` changed to only output a string list Deferred.t which contains a string type of a JSON object.
- `jsonhandling.ml` had its ADT `t` removed because it was a terrible design. It also had its `json_handling` function removed because it didn't make any sense to have it.
- `.json` files were moved around.
- `tests/auth_test.ml` had a comment removed.