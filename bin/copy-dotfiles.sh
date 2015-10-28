#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

set -v

function rsync_dotfiles {
  SERVER=$1
  rsync -ae 'ssh -o StrictHostKeyChecking=no' ~/.files/ ${SERVER}:~/.files/
  ssh ${SERVER} -C '~/.files/install.sh'
}

for server in "$@"
do
  rsync_dotfiles $server
done
