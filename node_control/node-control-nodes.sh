#!/usr/bin/env bash
set -e

case $1 in
    help)
        cat node-control-nodes-help.txt
        ;;
    "")
        echo "Master nodes:"
        cat <<< "$masters"
        echo

        echo "Agent nodes (private):"
        cat <<< "$agents"
        echo

        echo "Agent nodes (public):"
        cat <<< "$agents_public"
        echo
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        exit 1
        ;;
esac
