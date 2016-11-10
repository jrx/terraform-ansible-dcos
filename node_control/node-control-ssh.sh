#!/usr/bin/env bash
set -e

errecho() {
    echo "$@" 1>&2;
}

case $1 in
    help)
        echo "node-control ssh [-u=root] COMMAND [OPTIONS]"
        echo
        echo "Available commands:"
        echo
        echo "setup KEY"
        echo "    Setup ssh key on all remote machines."
        echo "wipe KEY"
        echo "    Wipes specified key from the list of authorized keys of all"
        echo "    remote machines."
        ;;
    setup)
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

        # Setup key on nodes.
        while read node; do
            echo "Setting up key for node $node..."

            set +e
            if ssh root@${node} "bash -s" < ./remote-key-setup.sh "'$(cat ${key_file})'"; then
                echo "DONE"
            fi
            set -e

        done <<< "$nodes"
        ;;
    *)
        errecho "'$1' is not a valid command."
        ;;
esac
