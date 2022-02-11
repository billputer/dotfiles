#!/usr/bin/env bash
#
# installs various applications with brew cask, requires brew
#
set -o errexit
set -o pipefail
set -o nounset

echo "installing brew casks"

# TODO: https://gist.github.com/t-io/8255711

brew install --cask 1password
brew install --cask alfred
brew install --cask appcleaner
brew install --cask atom
brew install --cask bartender
brew install --cask caffeine
brew install --cask docker
brew install --cask google-chrome
brew install --cask hammerspoon
brew install --cask istat-menus
brew install --cask iterm2
brew install --cask karabiner-elements
brew install --cask omnidisksweeper
brew install --cask scroll-reverser
brew install --cask slack
brew install --cask the-unarchiver
brew install --cask transmission

brew tap homebrew/cask-drivers
brew install --cask yubico-authenticator

# required to install font-inconsolata-g-for-powerline
brew install svn
brew tap homebrew/cask-fonts
brew install font-inconsolata-g-for-powerline
