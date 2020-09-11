# UPDATE: I am currently in the process of switching computers so commits/pushes will slow down for the next few days.

# TDA_OCaml

### Release Version
[![Build Status](https://travis-ci.com/tottenhamjm/tda_ocaml.svg?branch=master)](https://travis-ci.com/tottenhamjm/tda_ocaml)

### Dev Version
[![Build Status](https://travis-ci.com/tottenhamjm/tda_ocaml.svg?branch=dev)](https://travis-ci.com/tottenhamjm/tda_ocaml)


## An OCaml wrapper for the [TDAmeritrade API](https://developer.tdameritrade.com/)

## Usage
tda_ocaml is a fully function wrapper for TDAmeritrade's API, built in an effort to get more people interested in OCaml and make it slightly more accessible to the community.

## What This Wrapper Does
- Provides a far easier initial experience in getting your access/refresh tokens, doing all the heavy lifting for you and only requiring you to enter a few bits of information
- Handles the entire authentication flow, including automatically refreshing tokens when they are expired (30 minutes for access tokens and 90 days for refresh tokens).
- Gives you a highly modular way to access the API, giving you as much customization and freedom as possible without compromising reliability and performance.
- Runs a full suite of built-in tests whenever you want.
- Handles API output and sends the data to a JSON file. This can also be changed to send the data to wherever you'd like (e.g. a database, another function to process the data, etc.)

## FAQ
### How do I access the exposed APIs?
The endpoints are coming soon<sup>TM</sup>, and they will look something like:

    let foo = TDA.make_request ~output:Json_file ~filename:"filename.json" `MARKET_MOVERS

When you want to output the response to a file, or:

    let bar = TDA.make_request ~output:Raw ~MARKET_MOVERS

When you want to output the response as an object that can be passed into another function.

### Where is the documentation?
Documenting this library is an ongoing project, it will soon be found in `documentation.md`! It's going to go a step further than normal OCaml documentation of the basic how-to for its APIs and will be siginficantly more in-depth.

### How does this handle the initial authentication?
Once you enter your credentials into `credentials.json` or pass them as string arguments into `TDA.build_code`, which will print out the URL to login to and a couple of easy steps to follow. Once they're done, everything else it taken care of!

## TODO
<h3> Change `Command.Spec()` to `Command.Param()` </h3>
- Command.Spec() is outdated and is a lot more complex. Changing to Command.Param() will allow for external variables to be applied to `access_token_reg` and `access_token_initial`.

<h3> <del> Write Tokens to JSON </del> </h3>

- [x] Use `Credentials.write_tokens` to write tokens (Deferred.t string list) to token_list.
- [x] - Pattern match list values