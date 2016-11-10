#!/usr/bin/env bash
set -e

case $1 in
    help)
        echo "node-control ssh [-u=root] COMMAND [OPTIONS]"
        echo
        echo "Available commands:"
        echo
        echo "setup KEY"
        echo "    Setup ssh key on all remote machines."
        echo "wipe KEY"
        echo "    Wipes specified key from the list of authorized keys of all"
        echo "    remote machines."
        ;;
    *)
        errecho "'$1' is not a valid command."
        ;;
esac
