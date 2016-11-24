#!/usr/bin/env bash
set -e

cd ..
ansible-playbook install.yml -u root
