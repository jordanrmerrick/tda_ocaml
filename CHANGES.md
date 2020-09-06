# Changes are explained in detail here.

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