#!/usr/bin/env bash
set -e

cd ..
ansible-playbook uninstall-all.yml -u root
