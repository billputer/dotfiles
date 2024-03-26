#!/usr/bin/env bash
#
# installs fzf
#
set -o errexit
set -o pipefail
set -o nounset

K9S_DIR="$HOME/Library/Application Support/k9s"

brew install k9s

if [ -L "${VSCODE_DIR}/config.yaml" ]; then
  echo "k9s settings already installed"
else
  echo "installing k9s settings"
  ln -s ~/.files/k9s "${K9S_DIR}"
fi
