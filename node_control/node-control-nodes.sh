#!/usr/bin/env bash
set -e

echo "Master nodes:"
cat <<< "$masters"
echo

echo "Agent nodes (private):"
cat <<< "$agents"
echo

echo "Agent nodes (public):"
cat <<< "$agents_public"
echo
