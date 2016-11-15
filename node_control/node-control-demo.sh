#!/usr/bin/env bash
set -e

demo="$1"

if [ -z "$demo" ]; then
    errecho "No demo specified."
    exit 1
fi

cd demos
bash $demo-demo.sh "${@:2}"
