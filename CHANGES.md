# Changes are explained in detail here.

## cbb8a9ae
- `auth.ml` changed to only output a string list Deferred.t which contains a string type of a JSON object.
- `jsonhandling.ml` had its ADT `t` removed because it was a terrible design. It also had its `json_handling` function removed because it didn't make any sense to have it.
- `.json` files were moved around.
- `tests/auth_test.ml` had a comment removed.