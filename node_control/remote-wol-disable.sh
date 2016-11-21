#!/usr/bin/env bash
set -e

nmcli connection modify eth0 802-3-ethernet.wake-on-lan default > /dev/null
nmcli connection up eth0 > /dev/null
