#!/usr/bin/env bash
#
# installs sublime text configuration files
#
set -o errexit
set -o pipefail
set -o nounset

if [ -d "$HOME/.sublime-text-3" ]; then
  echo "sublime text configuration already installed"
else
  echo "installing sublime text configuration files"
  git clone https://github.com/billputer/sublime-text-3-config.git ~/.sublime-text-3
  SUBLIME_CONFIG="$HOME/Library/Application Support/Sublime Text 3"
  echo "moving old sublime text config to $SUBLIME_CONFIG.bak"
  mv ${SUBLIME_CONFIG} ${SUBLIME_CONFIG}.bak
  ln -s ~/.sublime-text-3 ${SUBLIME_CONFIG}
fi
