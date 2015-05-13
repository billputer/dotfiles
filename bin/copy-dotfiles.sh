#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

set -v

SERVER="${1}"

rsync -ae ssh ~/.files/ ${SERVER}:~/.files/
ssh ${SERVER} -C ~/.files/install.sh
