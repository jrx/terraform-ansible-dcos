#!/usr/bin/env bash
set -e

# Update nodes.

while read node; do
    echo "Requesting package updates for $node..."
    ssh -n root@${node} "yum update -y" >/dev/null &
done <<< "$nodes"

wait

echo "All nodes up-to-date."
