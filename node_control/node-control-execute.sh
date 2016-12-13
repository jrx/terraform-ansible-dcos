#!/usr/bin/env bash
set -e

case $1 in
    help)
        cat node-control-execute-help.txt
        ;;
    *)
        while read node; do
            ssh root@${node} "${@:1}" &
        done <<< "$nodes"

        wait
        ;;
esac
