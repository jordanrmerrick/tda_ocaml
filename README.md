[![Build Status](https://travis-ci.com/tottenhamjm/tda_ocaml.svg?branch=master)](https://travis-ci.com/tottenhamjm/tda_ocaml)

# TDA_OCaml

## An OCaml wrapper for the [TDAmeritrade API](https://developer.tdameritrade.com/)

## Usage
tda_ocaml is a fully function wrapper for TDAmeritrade's API, built in an effort to get more people interested in OCaml and make it slightly more accessible to the community.

## What This Wrapper Does
- Provides a far easier initial experience in getting your access/refresh tokens, doing all the heavy lifting for you and only requiring you to enter a few bits of information
- Handles the entire authentication flow, including automatically refreshing tokens when they are expired (30 minutes for access tokens and 90 days for refresh tokens).
- Gives you a highly modular way to access the API, giving you as much customization and freedom as possible without compromising reliability and performance.
- Runs a full suite of built-in tests whenever you want.
- Handles API output and sends the data to a JSON file. This can also be changed to send the data to wherever you'd like (e.g. a database, another function to process the data, etc.)

## What This Wrapper Doesn't Do
- Automate trading in any way.
- Make API calls without your explicit permission - requesting data from one API will never request from another.

## TODO
### Change Command.Spec() to Command.Param()
- Command.Spec() is outdated and is a lot more complex. Changing to Command.Param() will allow for external variables to be applied to `access_token_reg` and `access_token_initial`.

### Write Tokens to JSON
- Use `Credentials.write_tokens` to write tokens (Deferred.t string list) to token_list.
- Pattern match list values

### Better 