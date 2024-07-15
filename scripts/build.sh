#!/bin/bash

if [[ "$(uname)" == "Linux" ]]; then
    BIN_PATH="$HOME/.luarocks/bin"
else
    BIN_PATH="/opt/homebrew/bin"
fi

# GENERATE LUA in /build-lua
tl build

cd build-lua

# LINT & AMALGAMATE
$BIN_PATH/luacheck main.lua greeter.lua
$BIN_PATH/amalg.lua -s main.lua -o ../build/main.lua greeter

# FINAL RESULT is build/main.lua