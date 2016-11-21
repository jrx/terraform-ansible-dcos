#!/usr/bin/env bash
set -e

nmcli connection modify eth0 802-3-ethernet.wake-on-lan magic > /dev/null
nmcli connection up eth0 > /dev/null

regex="eth0 +[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12} +[^ ]* +([^ ]*)"
if [[ $(nmcli connection) =~ $regex ]]; then
    real_interface="${BASH_REMATCH[1]}"
else
    exit 1
fi

regex="GENERAL\.HWADDR: *([0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F])"
if [[ $(nmcli device show ${real_interface}) =~ $regex ]]; then
    echo "${BASH_REMATCH[1]}"
else
    exit 1
fi
