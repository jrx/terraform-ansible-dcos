#!/usr/bin/env bash
set -e

case "$1" in
    help)
        cat node-control-poweron-help.txt
        ;;
    "")
        ./node-control wol wake
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        exit 1
        ;;
esac
