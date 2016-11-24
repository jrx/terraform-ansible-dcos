#!/usr/bin/env bash
set -e

cd ..
ansible-playbook install.yml -u root

# Authenticate via DC/OS CLI.
while read master; do
    # Configure to point to first master.
    dcos config set core.dcos_url http://1.0.10.1
    break
done <<< "$masters"

dcos auth login
