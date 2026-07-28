#!/usr/bin/env bash
#
# installs asdf with brew, requires brew
#
set -o errexit
set -o pipefail
set -o nounset

if which asdf >/dev/null 2>&1; then
  echo "asdf already installed"
else
  echo "installing asdf"

  brew install asdf

  # prepare completions
  mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
fi
