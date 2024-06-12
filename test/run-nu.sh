#!/bin/sh

cd "${1}"

if ! command -v nu 1> /dev/null; then
	echo -e nushell not found
	exit 1
fi

exec nu "${1}/${2}.nu"
