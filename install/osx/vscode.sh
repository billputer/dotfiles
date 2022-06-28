#!/usr/bin/env bash
#
# installs fzf
#
set -o errexit
set -o pipefail
set -o nounset

VSCODE_DIR="$HOME/Library/Application Support/Code/User"


if [ -L "${VSCODE_DIR}/settings.json" ]; then
  echo "VSCode settings already installed"
else
  echo "installing VSCode symlinks"

  mkdir -p ${VSCODE_DIR}
  mv "${VSCODE_DIR}/settings.json" "${VSCODE_DIR}/settings.json.bak" || true
  ln -s ~/.files/vscode/settings.json "${VSCODE_DIR}/settings.json"

  mv "${VSCODE_DIR}/keybindings.json" "${VSCODE_DIR}/keybindings.json.bak" || true
  ln -s ~/.files/vscode/keybindings.json "${VSCODE_DIR}/keybindings.json"

  mv "${VSCODE_DIR}/snippets" "${VSCODE_DIR}/snippets.bak"
  ln -s ~/.files/vscode/snippets "${VSCODE_DIR}/snippets"
fi
