#!/usr/bin/env bash
set -e

cd ..
ansible-playbook uninstall-all.yml -u root

# Restore eth0 network interface again, as it's turned inactive somehow by
# uninstall.
echo "Restoring eth0 network interface..."
while read node; do
    ssh -n root@${node} "nmcli c up eth0" &
done <<< "$nodes"

wait
