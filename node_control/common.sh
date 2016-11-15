#!/usr/bin/env bash

export masters=$(./ansible-ini-parser '../hosts' masters)
export agents=$(./ansible-ini-parser '../hosts' agents)
export agents_public=$(./ansible-ini-parser '../hosts' agents_public)

export nodes="$(echo $masters $agents $agents_public | sed 's/ \+/\n/g')"
