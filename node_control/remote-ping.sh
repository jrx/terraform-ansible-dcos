#!/usr/bin/env bash
set -e

my_node="$1"
nodes="$2"

exitcode=0

while read node; do
    if ping -c 1 ${node} >/dev/null; then
        echo "$my_node -> $node: OK"
    else
        echo "$my_node -> $node: UNREACHABLE"
        exitcode=1
    fi
done <<< "$nodes"

exit $exitcode
