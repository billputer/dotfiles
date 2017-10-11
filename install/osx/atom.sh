#!/usr/bin/env bash
#
# installs atom configuration files
#
set -o errexit
set -o pipefail
set -o nounset

if [ -d "$HOME/.atom" ]; then
  echo "atom configuration already installed"
else
  echo "installing atom configuration files"
  git clone git@bitbucket.org:billputer/atom-settings.git ~/.atom

  # necessary for linter-flake8
  pip install flake8
fi
