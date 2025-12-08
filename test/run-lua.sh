#!/bin/sh

cd "${1}"

if command -v luajit > /dev/null 2>&1; then
	LUA_CMD=luajit
else
	LUA_CMD=lua
fi

LUA_PATH="${3}/?.lua" $LUA_CMD "${1}/${2}.lua"
