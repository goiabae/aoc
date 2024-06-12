#!/bin/sh

cd "${1}"

if ! command -v python3 1> /dev/null; then
	echo -e python3 not found
	exit 1
fi

exec python3 "${1}/${2}.py"
