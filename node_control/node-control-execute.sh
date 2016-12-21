#!/usr/bin/env bash
set -e

case $1 in
    help)
        cat node-control-execute-help.txt
        ;;
    *)
        # Parse parameters
        sequential="false"
        while [ $# -ge 1 ]; do
            case "$1" in
                -s|--sequential)
                    sequential="true"
                    shift
                    ;;
                *)
                    break
                    ;;
            esac
        done

        while read node; do
            if [ "$sequential" = "true" ]; then
                ssh -n root@${node} "${@:1}"
            else
                ssh root@${node} "${@:1}" &
            fi
        done <<< "$nodes"

        wait
        ;;
esac
