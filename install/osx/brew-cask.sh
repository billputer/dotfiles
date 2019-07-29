#!/usr/bin/env bash
#
# installs various applications with brew cask, requires brew
#
set -o errexit
set -o pipefail
set -o nounset

echo "installing brew casks"

brew cask install alfred
brew cask install appcleaner
brew cask install atom
brew cask install bartender
brew cask install caffeine
brew cask install docker
brew cask install google-chrome
brew cask install gpgtools
brew cask install hammerspoon
brew cask install istat-menus
brew cask install iterm2
brew cask install karabiner-elements
brew cask install omnidisksweeper
brew cask install scroll-reverser
brew cask install slack
brew cask install the-unarchiver
brew cask install transmission
brew cask install 1password
