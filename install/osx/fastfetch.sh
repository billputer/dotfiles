#!/usr/bin/env bash
#
# installs fastfetch with brew cask, requires brew
#
set -o errexit
set -o pipefail
set -o nounset

echo "installing fastfetch"

# brew install fastfetch

FASTFETCH_DIR="$HOME/.config/fastfetch"

if [ -L "${FASTFETCH_DIR}/config.jsonc" ]; then
  echo "fastfetch config already installed"
else
  echo "installing fastfetch config"
  mkdir -p ${FASTFETCH_DIR}
  mv "${FASTFETCH_DIR}/config.jsonc" "${FASTFETCH_DIR}/config.jsonc.bak" || true
  ln -s ~/.files/fastfetch/config.jsonc "${FASTFETCH_DIR}/config.jsonc"
fi