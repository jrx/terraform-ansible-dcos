#!/usr/bin/env bash
set -e

case $1 in
    help)
        echo "The 'chuck-norris' demo runs a web-server that serves jokes about"
        echo "Chuck Norris. The responses also contain additional information"
        echo "like the IP the response came from or the service version, which"
        echo "makes this example very suitable for showing DC/OS capabilities"
        echo "with load-balancing in conjunction with marathon-lb."
        echo
        echo "Requirements:"
        echo "- At least 1 public node"
        echo "- At least 1 private node"
        echo "- Total resources: 4 CPUs, 4GiB RAM"
        ;;

    uninstall)
        ask_for_confirmation "Are you sure you want to uninstall 'chuck-norris' demo? [y/n]"

        set +e
        echo "Removing '/chuck-jokes' services..."
        dcos marathon group remove /chuck-jokes
        echo "Removing '/marathon-lb' service..."
        dcos marathon app remove marathon-lb
        echo "Demo successfully uninstalled."
        set -e
        # FIXME Wait for successful deployment
        ;;
    install)
        confirmation_text="Are you sure you want to install 'chuck-norris' demo? This will use up at "
        confirmation_text+="least 4 CPUs and 4GiB of RAM. [y/n]"
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

        cd chuck-norris

        echo "Deploying '/chuck-jokes' services..."
        sed "s/your\.public\.elb\.amazonaws\.com/$node/g" marathon-configuration.json >> chuck-norris-service.json
        dcos marathon group add chuck-norris-service.json
        rm chuck-norris-service.json

        echo "Waiting for healthy services deployment..."
        dcos-wait-for-service chuck-jokes/database
        dcos-wait-for-service chuck-jokes/service

        echo "Demo successfully deployed! Chuck-Norris-demo runs on"
        echo "http://$node and you can start to experiment with it."
        echo "For example scale service!"
        ;;
    *)
        errecho "Unrecognized parameter: $1"
        ;;
esac
