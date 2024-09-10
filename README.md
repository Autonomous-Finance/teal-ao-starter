# Starter Kit for *AO* Application Development with *Teal*

This starter kit includes tooling that allows application developers on *AO* to use *Teal* - ***Lua* with strong typing**.

It allows for a workflow similar to that in web development with *Typescript*, while catering to the requirements of *AO* (to have a single `.lua` output file to be loaded into an *AO* process)

## How to Use

1. `luarocks install tl && luarocks install cyan && luarocks install amalg` 
2. Write your code in *Teal* (using `.tl` files)
3. Add your modules into the Squishy file (used to generate the final amalgamation)
4. Use `npm run build` to create your `main.lua` output



## How It Works

[Teal](https://github.com/teal-language/tl) is a superset of *Lua* that allows for typed programming in *Lua*.

*Teal* relates to *Lua* as *Typescript* relates to *Javascript*.

[Cyan](https://github.com/teal-language/cyan) is the official build tool for teal.

[Squish](https://github.com/LuaDist/squish) is a tool that allows for the amalgamation of multiple *Lua* files into a single *Lua* file.

This project seeks to provide a workflow similar to that in web development with *Typescript*, while catering to the requirements of *AO* (to have a single `.lua` output file to be loaded into an *AO* process via AOform/Aoconnect)

## AO-native modules and state

Two aspects about AO need to be considered:

1. Native modules like "ao", "json" ...
2. Native global state like `ao`, `Handlers`, ... 

This project includes an ao type definition for ao globals.

### Adding more type definitions

It's possible to include type definitions for external packages, similar to the type definitions in *Typescript*.

See the [*Teal* docs](https://github.com/teal-language/tl?tab=readme-ov-file) for more information.

Many packages already have existing type definitions: See the [Teal-types](https://github.com/teal-language/teal-types/) repo for more information.

You can grab a type defintion from there and place it into src/<your project>/typedefs

For developer convenience this starter kit **includes ao-native global state type definitions**. See `src/ao.d.tl` for details.

### Using you own Lua modules
If you wish to use packages/modules that are not natively typed you can place the lua file alongside a teal type defintion inside packages/<package name>/

You can then require them inside your teal project as usual via `require("yourmodule.yourfile")`. Teal will use the type definition for checks while copying the actual lua file during the build process.

To prevent Cyan from pruning these packages, add them into tlconfig.lua under the dont_prune section. Otherwise Cyan will warn about foreign files in the build dir and even prune/delete them if ran with the --prune flag.

### Amalgamations
For easier development we use squishy to produce a single output file in lua. Add your modules into the squishy file to configure this (optional).

### Batteries included
This project includes a [Teal bint](https://github.com/AutonomousResearch/teal-bint) implementation with typing support and increased type safety for big integer math and also a teal native implementation of the ao utils.
