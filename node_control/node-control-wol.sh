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
    wake)
        if [ -a wol-config.cfg ]; then
            while read line; do
                regex="([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})=([0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F])"
                if [[ "$line" =~ $regex ]]; then
                    node="${BASH_REMATCH[1]}"
                    mac_addr="${BASH_REMATCH[2]}"

                    wol $mac_addr &
                fi
            done < wol-config.cfg
        else
            errecho "No wol-config.cfg file found. Did you forgot to setup"
            errecho "wake-on-lan using 'node-control wol enable'?"
            exit 2
        fi
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        exit 1
esac
