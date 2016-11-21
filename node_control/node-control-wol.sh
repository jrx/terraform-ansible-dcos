#!/usr/bin/env bash
set -e

case $1 in
    enable)
        # Truncate config file.
        : > wol-config.cfg

        while read node; do
            echo "Enabling Wake-on-LAN on $node..."
            if mac_addr=$(ssh root@${node} "bash -s" < ./remote-wol-enable.sh); then
                echo "$node=$mac_addr" >> wol-config.cfg
            fi

        done <<< "$nodes"
        ;;
    disable)
        while read node; do
            echo "Disabling Wake-on-LAN on $node..."
            ssh root@${node} "bash -s" < ./remote-wol-disable.sh &
        done <<< "$nodes"

        if [ -a wol-config.cfg ]; then
            echo "Removing Wake-on-LAN config file (wol-config.cfg)..."
            rm wol-config.cfg
        fi

        wait
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        exit 1
esac
