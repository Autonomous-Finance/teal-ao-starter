# Starter Kit for *AO* Application Development with *Teal*

This starter kit includes tooling that allows application developers on *AO* to use *Teal* - ***Lua* with strong typing**.

It allows for a workflow similar to that in web development with *Typescript*, while catering to the requirements of *AO* (to have a single `.lua` output file to be loaded into an *AO* process)

## How to Use

1. ```luarocks install tl```
2. Write your code in *Teal* (using `.tl` files)
3. Use `npm run build` to create your `main.lua` output


## How It Works

*Teal* is a superset of *Lua* that allows for typed programming in *Lua*.

*Teal* relates to *Lua* as *Typescript* relates to *Javascript*.

Unfortunately there is no support for ignoring teal errors at the moment.

## AO-native modules and state

Two aspects about AO need to be considered:

1. Native modules like "ao", "json", ".bint", ".utils", ...
2. Native global state like `ao`, `Handlers`, ... 

### Type definitions

It's possible to include type definitions for external packages, similar to the type definitions in *Typescript*.

See the [*Teal* docs](https://github.com/teal-language/tl?tab=readme-ov-file) for more information.

The existence of a file `json.d.tl` at the top level of the source files achieves the goal of making the statement

```lua
local json = require "json"
```

acceptable for the *Teal* compiler. This is achieved even if the type definition file is empty.

On top of that, an actual definition of json reccord type can be provided, to help with autocompletion.

Due to some *Teal* limitations though, the require statement needs to be 

```lua
local json = require "json" as json
```

which won't be reflected in the final `.lua` source code.

For developer convenience this starter kit **includes ao-native global state type definitions**. See `src/ao.d.tl` for details.