#!/usr/bin/env bash
set -e

case "$1" in
    help)
        cat node-control-reinstall-help.txt
        ;;
    "")
        ./node-control uninstall
        ./node-control install
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        exit 1
        ;;
esac
