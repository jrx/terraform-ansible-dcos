#!/usr/bin/env bash
set -e

# FIXME Build commands for power-up (using wake-on-LAN).

case "$1" in
    help)
        echo "node-control poweroff [-y] [NODES]"
        echo
        echo "Powers down all connected nodes or all specified NODES. If all master"
        echo "nodes are shutdown, DC/OS is likely not to work any more. In this case"
        echo "a reinstall is needed."
        echo
        echo "-y, --yes"
        echo "    Don't ask for confirmation, just poweroff."
        ;;
    *)
        # Parse parameters
        count=0
        while [ $# -ge 1 ]; do
            case "$1" in
                -y|--yes)
                    dont_ask=true
                    shift
                    ;;
                *)
                    # FIXME Check if node can be found in configuration.
                    # FIXME Allow to pass synonyms, e.g. allow:
                    #       master1, m1, agent3, a3, agent_public12, p12, public_agent12
                    #       public-agent12, agent-public12, ap12, pa12
                    specified_nodes+="$1"$'\n'
                    count=$((count+1))
                    shift
                    ;;
            esac
        done

        if [ -z "$dont_ask" ]; then
            if [ ${count} -eq 0 ]; then
                count="all"
                specified_nodes="$nodes"
            else
                # Strip away trailing \n.
                specified_nodes=${specified_nodes:0:$((${#specified_nodes} - 1))}
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
        ;;
esac
