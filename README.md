# Starter Kit for *AO* Application Development with *Teal*

This starter kit includes tooling that allows application developers on *AO* to use *Teal* - ***Lua* with strong typing**.

It allows for a workflow similar to that in web development with *Typescript*, while catering to the requirements of *AO* (to have a single `.lua` output file to be loaded into an *AO* process)

## How to Use

1. ```luarocks install tl```
2. Write your code in *Teal* (using `.tl` files)
3. Use `npm run build` to create your `main.lua` output


## Background

*Teal* is a superset of *Lua* that allows for typed programming in *Lua*.

*Teal* relates to *Lua* as *Typescript* relates to *Javascript*.

It's possible to include type definitions for external packages, similar to the type definitions in *Typescript*.

See the [Teal docs](https://github.com/teal-language/tl?tab=readme-ov-file) for more information.
