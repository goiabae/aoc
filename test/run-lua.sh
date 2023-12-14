#!/bin/sh
base=$(pwd)
cd "${1}"
LUA_CMD=lua
which luajit 2> /dev/null && LUA_CMD=luajit
LUA_PATH="${base}/lib/?.lua" exec $LUA_CMD "${1}/main.lua"
