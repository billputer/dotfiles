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
  brew install hammerspoon
fi

if [ -d "$HOME/.files/hammerspoon/hs/_asm/undocumented/spaces" ]; then
  echo "hammerspoon hs._asm.undocumented.spaces module already installed"
else
  echo "installing hammerspoon hs._asm.undocumented.spaces module"
  mkdir -p "$HOME/src"
  git clone https://github.com/asmagill/hs._asm.undocumented.spaces.git ~/src/hs._asm.undocumented.spaces

  pushd "$HOME/src/hs._asm.undocumented.spaces"
  HS_APPLICATION=/Applications PREFIX=~/.hammerspoon make install-arm64
  popd

  echo "Don't forget to allow Hammerspoon in System Preferences > Security & Privacy > Privacy > Accessibility"
fi
exit 0
