#!/usr/bin/env bash
#
# Install all the things a billputer needs
#
set -o errexit
set -o pipefail
set -o nounset

DOTFILE_DIR="$( cd "$( dirname "$0" )/.." && pwd )"

# mac-specific
if [[ $(uname) = 'Darwin' ]]; then
  $DOTFILE_DIR/install/osx/brew.sh
  $DOTFILE_DIR/install/osx/ns-defaults.sh
fi

# ubuntu-specific
if [ -f "/etc/issue" ] && grep --silent Ubuntu /etc/issue; then
  $DOTFILE_DIR/install/ubuntu/ubuntu.sh
fi

# common install scripts
$DOTFILE_DIR/install/all/fzf.sh
$DOTFILE_DIR/install/all/link-dotfiles.sh
$DOTFILE_DIR/install/all/vim.sh
$DOTFILE_DIR/install/all/zsh.sh
