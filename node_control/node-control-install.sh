#!/usr/bin/env bash
set -e

case $1 in
    help)
        cat node-control-install-help.txt
        ;;
    "")
        cd ..
        ansible-playbook install.yml -u root

        # Authenticate via DC/OS CLI.
        while read master; do
            # Configure to point to first master.
            dcos config set core.dcos_url http://${master}
            break
        done <<< "$masters"

        dcos auth login
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        exit 1
        ;;
esac
