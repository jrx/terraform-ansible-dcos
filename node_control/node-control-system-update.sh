#!/usr/bin/env bash
set -e

case $1 in
    help)
        cat node-control-system-update-help.txt
        ;;
    "")
        while read node; do
            echo "Requesting package updates for $node..."
            ssh -n root@${node} "yum update -y" >/dev/null &
        done <<< "$nodes"

        wait

        echo "All nodes up-to-date."
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        exit 1
        ;;
esac
