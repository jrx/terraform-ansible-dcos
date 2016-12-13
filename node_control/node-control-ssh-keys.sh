#!/usr/bin/env bash
set -e

case $1 in
    help)
        echo "node-control ssh [-u=root] COMMAND [OPTIONS]"
        echo
        echo "Available commands:"
        echo
        echo "setup KEY-FILE"
        echo "    Setup ssh key on all remote machines."
        echo "wipe KEY-FILE"
        echo "    Wipes specified key from the list of authorized keys of all"
        echo "    remote machines."
        ;;
    install|wipe)
        key_file="$2"

        if [ -z "$key_file" ]; then
            errecho "No key-file specified."
            exit 1
        fi

        # Filename shall end with .pub, so nobody sends accidentally a private key.
        filename_regex="^.*\.pub$"

        if [[ ! "$key_file" =~ "$filename_regex" ]]
        then
            errecho "Key file does not have .pub ending! For security reasons it's"
            errecho "not allowed, to prevent sending the private key accidentally."
            exit 2
        fi

        # FIXME Currently default user is always root, provide a parameter for user.

        case $1 in
            setup)
                # Setup key on nodes.
                while read node; do
                    echo "Setting up key for node $node..."

                    set +e
                    if ssh root@${node} "bash -s" < ./remote-ssh-keys-install.sh "'$(cat ${key_file})'"; then
                        echo "DONE"
                    fi
                    set -e

                done <<< "$nodes"
                ;;
            wipe)
                # Rescind ssh access on nodes.
                while read node; do
                    echo -n "Wiping key for node $node... "

                    # FIXME Make this job parallel.
                    set +e
                    if ssh root@${node} "bash -s" < ./remote-ssh-keys-wipe.sh "'$(cat ${key_file})'"; then
                        echo "WIPED"
                    fi
                    set -e

                done <<< "$nodes"
                ;;
        esac
        ;;
    *)
        errecho "Invalid argument supplied: $1"
        ;;
esac
