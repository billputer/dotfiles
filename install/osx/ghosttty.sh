#!/usr/bin/env bash
#
# installs ghostty with brew cask, requires brew
#
set -o errexit
set -o pipefail
set -o nounset

echo "installing ghostty"

# brew install --cask ghostty

GHOSTTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"

if [ -L "${GHOSTTTY_DIR}/config" ]; then
  echo "GhostTTY config already installed"
else
  echo "installing GhostTTY config"

  mkdir -p ${GHOSTTTY_DIR}
  mv "${GHOSTTTY_DIR}/config" "${GHOSTTTY_DIR}/config.bak" || true
  ln -s ~/.files/ghosttty/config "${GHOSTTTY_DIR}/config"
fi