#!/usr/bin/env bash
set -e

case $1 in
    help)
        echo "The 'ghost' demo runs ghost, which is a blogging platform."
        echo
        echo "Requirements:"
        echo "- At least 1 public node"
        echo "- At least 1 private node"
        echo "- Total resources: 4 CPUs, 3GiB RAM, 500MiB disk."
        ;;

    uninstall)
        ask_for_confirmation "Are you sure you want to uninstall 'ghost' demo? [y/n]"

        set +e
        echo "Removing '/ghost/blog' service..."
        dcos marathon app remove /ghost/blog
        echo "Removing '/ghost/mysql' service..."
        dcos marathon app remove /ghost/mysql
        echo "Removing '/ghost' group..."
        dcos marathon group remove /ghost
        echo "Removing '/marathon-lb' service..."
        dcos marathon app remove marathon-lb
        echo "Demo successfully uninstalled."
        set -e
        # FIXME Wait for successful deployment
        ;;
    install)
        confirmation_text="Are you sure you want to install 'ghost' demo? This will use up at "
        confirmation_text+="least 4 CPUs, 3GiB RAM and 500MiB disk. [y/n]"
        ask_for_confirmation "$confirmation_text"

        # Waits for a single dcos-service to get healthy.
        function dcos-wait-for-service {
            regex="/$1 *[0-9]+ *[0-9.]+ *[0-9]+/[0-9]+ *([0-9]+)/[0-9]+"
            while true; do
                if [[ $(dcos marathon app list) =~ $regex ]]; then
                    # Get health values.
                    healthy="${BASH_REMATCH[1]}"

                    if [ ${healthy} -eq 0 ]; then
                        # No running service yet, continue watching.
                        sleep 0.5
                        continue
                    fi

                    break
                else
                    sleep 0.5
                fi
            done
        }

        cd ghost

        echo "Deploying '/marathon-lb' service..."
        dcos package install marathon-lb > /dev/null <<< "yes"

        echo "Waiting for healthy marathon-lb deployment..."
        dcos-wait-for-service marathon-lb

        # Query IP address of node which runs marathon-lb.
        regex="marathon-lb *([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) *[^ ]* *R"
        if [[ $(dcos task) =~ $regex ]]; then
            node="${BASH_REMATCH[1]}"
        else
            errecho "marathon-lb wasn't started successfully somehow."
            exit 1
        fi

        echo "Deploying '/ghost/mysql' service..."
        dcos marathon app add mysql-local.json

        echo "Deploying '/ghost/blog' service..."
        sed "s/ghost\.jrx\.de/$node/g" ghost.json >> ghost-service.json
        dcos marathon app add ghost-service.json
        rm ghost-service.json

        echo "Waiting for healthy services deployment..."
        dcos-wait-for-service ghost/mysql
        dcos-wait-for-service ghost/blog

        echo "Demo successfully deployed! Ghost blog runs on http://$node and you can"
        echo "start to experiment with it. For example scale the blog service!"
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        ;;
esac
