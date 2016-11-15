#!/usr/bin/env bash

errecho() {
    echo "$@" 1>&2;
}

ask_for_confirmation() {
    while true; do
        read -p "$1 " choice
        case "$choice" in
            [Yy]|[Yy][Ee][Ss])
                break
                ;;
            [Nn]|[Nn][Oo])
                if [ -z "$2" ]; then
                    exitcode=0
                else
                    exitcode=$2
                fi
                exit ${exitcode}
                ;;
        esac
    done
}

export -f errecho
export -f ask_for_confirmation

export masters=$(./ansible-ini-parser '../hosts' masters)
export agents=$(./ansible-ini-parser '../hosts' agents)
export agents_public=$(./ansible-ini-parser '../hosts' agents_public)

export nodes="$(echo $masters $agents $agents_public | sed 's/ \+/\n/g')"
