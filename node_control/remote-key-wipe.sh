#!/usr/bin/env bash
set -e

key="$1"

# Remove occurrences of key.
sed -i -e "s/$key//g" .ssh/authorized_keys
