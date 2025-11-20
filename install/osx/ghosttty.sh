#!/usr/bin/env bash
#
# installs ghostty with brew cask, requires brew
#
set -o errexit
set -o pipefail
set -o nounset

echo "installing ghostty"

brew install --cask ghostty

GHOSTTY_DIR="$HOME/Library/Application\ Support/com.mitchellh.ghostty"

if [ -L "${GHOSTTY_DIR}/config" ]; then
  echo "ghostty config already installed"
else
  echo "installing ghostty config"

  mkdir -p ${GHOSTTY_DIR}
  mv "${GHOSTTY_DIR}/config" "${GHOSTTY_DIR}/config.bak" || true
  ln -s ~/.files/ghostty/config "${GHOSTTY_DIR}/config"
fi