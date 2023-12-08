#!/bin/sh
base=$(pwd)
cd "${1}"
LUA_PATH="${base}/lib/?.lua" exec lua "${1}/main.lua"
