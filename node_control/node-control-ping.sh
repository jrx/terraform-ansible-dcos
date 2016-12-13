#!/usr/bin/env bash
set -e

case $1 in
    help)
        cat node-control-ping-help.txt
        ;;
    "")
        set +e
        while read node; do
            ssh root@${node} "bash -s" < ./remote-ping.sh "'$node' '$nodes'" &
        done <<< "$nodes"
        set -e

        wait
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        exit 1
        ;;
esac
