#!/usr/bin/env bash
#
# installs hammerspoon and extra modules
#
set -o errexit
set -o pipefail
set -o nounset

if [ -d "/Applications/Hammerspoon.app" ]; then
  echo "hammerspoon already installed"
else
  echo "installing hammerspoon"
  brew cask install Caskroom/cask/hammerspoon
fi

if [ -d "$HOME/.files/hammerspoon/hs/_asm/undocumented/spaces" ]; then
  echo "hammerspoon hs._asm.undocumented.spaces module already installed"
else
  echo "installing hammerspoon hs._asm.undocumented.spaces module"
  pushd ~/.files/hammerspoon
  curl -OL https://github.com/asmagill/hs._asm.undocumented.spaces/releases/download/v0.5/spaces-v0.5.tar.gz
  tar -xvzf spaces-v0.5.tar.gz
  rm spaces-v0.5.tar.gz
  popd
fi
exit 0
