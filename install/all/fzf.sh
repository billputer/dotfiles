#!/usr/bin/env bash
#
# installs fzf
#
set -o errexit
set -o pipefail
set -o nounset


if [ -d "$HOME/.fzf" ]; then
  echo "fzf already installed"
else
  echo "installing fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  printf 'y\ny' | ~/.fzf/install
fi
