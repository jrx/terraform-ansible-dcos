#!/usr/bin/env bash
set -e

# Check if each node is reachable from each other.

set +e
while read node; do
    ssh root@${node} "bash -s" < ./remote-ping.sh "'$node' '$nodes'" &
done <<< "$nodes"
set -e

wait
