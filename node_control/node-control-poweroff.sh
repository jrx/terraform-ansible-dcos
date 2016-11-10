#!/usr/bin/env bash
set -e

# FIXME Build commands for power-up (using wake-on-LAN).

# Parse parameters
while [ $# -ge 1 ]; do
    case $1 in
        -y|--yes)
            dont_ask=true
            shift
            ;;
        *)
            # FIXME Check if node can be found in configuration.
            # FIXME Allow to pass synonyms, e.g. allow:
            #       master1, m1, agent3, a3, agent_public12, p12, public_agent12
            #       public-agent12, agent-public12, ap12, pa12
            specified_nodes+=("$1")
            shift
            ;;
    esac
done

if [ -z "$dont_ask" ]; then
    if [ ${#specified_nodes[@]} -eq 0 ]; then
        count_string="all"
    else
        count_string="${#specified_nodes[@]}"
    fi

    read -p "Are you sure you want to shutdown $count_string device(s) [y/n]? " choice
    if [ "$choice" != "y" ] && [ "$choice" != "Y" ] && [ "$choice" != "yes" ]; then
        exit
    fi
fi

while read node; do
    echo "Powering down $node..."
    ssh -n root@${node} poweroff &
done <<< "$nodes"
wait
