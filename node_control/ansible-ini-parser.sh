#!/usr/bin/env bash
set -e

errecho() {
    echo "$@" 1>&2;
}

if [ -z "$1" ]; then
    errecho "No file provided."
    exit 1
elif [ -z "$2" ]; then
    errecho "No section provided."
    exit 2
fi

file=$1
section=$2

regex="\[$section\]([^\[]*)"

if [[ $(cat ${file}) =~ $regex ]]
then
    # Get content of section.
    output="${BASH_REMATCH[1]}"
    # Remove empty lines.
    output=$(echo "${output}" | sed "/^\s*$/d")
    echo "${output}"
else
    errecho "Given section '$section' does not exist."
    exit 3
fi
