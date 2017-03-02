#!/usr/bin/env bash
#
# force_zsh, for shells with chsh, force zsh to be default shell
#
set -o errexit
set -o pipefail
set -o nounset

if [ ! $SHELL = "/bin/zsh" ]; then
  echo "changing shell to zsh"
  sudo chsh $USER -s /bin/zsh
else
  echo "zsh is already the default shell"
fi

# setup zgen
source ~/.files/zsh/zgen-setup

# remove old oh-my-zsh
rm -rf ~/.files/oh-my-zsh
