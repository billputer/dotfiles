#!/usr/bin/env bash
#
# installs various applications with brew cask, requires brew
#
set -o errexit
set -o pipefail
set -o nounset

echo "installing brew casks"

brew install --cask alfred
brew install --cask appcleaner
brew install --cask bartender
brew install --cask caffeine
brew install --cask font-inconsolata-g-for-powerline
brew install --cask ghostty
brew install --cask firefox
brew install --cask google-chrome
brew install --cask hammerspoon
brew install --cask istat-menus
brew install --cask karabiner-elements
brew install --cask omnidisksweeper
brew install --cask scroll-reverser
brew install --cask spotify
brew install --cask transmission
brew install --cask visual-studio-code
