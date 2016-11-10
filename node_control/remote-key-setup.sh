#!/usr/bin/env bash
set -e

key="$1"

# Create necessary directories.
mkdir -p .ssh/

# Create file if not exists.
>> .ssh/authorized_keys
# ... and already set the right mode.
chmod 600 .ssh/authorized_keys

# Check if key already exists.
if grep -q "$key" .ssh/authorized_keys; then
    echo "KEY ALREADY EXISTS"
    exit 1
else
    # Add key to authorized ssh keys.
    echo "$key" >> .ssh/authorized_keys
fi
