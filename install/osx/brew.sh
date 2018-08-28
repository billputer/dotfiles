#!/usr/bin/env bash
#
# installs the brew package manager and various packages
#
set -o errexit
set -o pipefail
set -o nounset

if type brew; then
  echo "brew already installed"
else
  echo "installing brew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # the important things
  brew install zsh tmux git
  # vim, but without homebrew ruby
  brew install vim --without-ruby

  # make tmux and pbcopy friends
  brew install reattach-to-user-namespace

  # various utilities
  brew install \
    ack \
    ag \
    awscli \
    bat \
    fd \
    diff-so-fancy \
    htop-osx \
    iperf3 \
    jq \
    mercurial \
    ncdu \
    prettyping \
    rename \
    tldr \
    tree \
    watchman \
    wget \
    ;

  # language tools
  brew install pyenv ruby-install

  # install GNU coreutils, etc, instead of using BSD versions
  brew install coreutils
  brew install findutils --with-default-names
  brew install gnu-getopt --with-default-names
  brew install gnu-indent --with-default-names
  brew install gnu-sed --with-default-names
  brew install gnu-tar --with-default-names

  # install shellcheck linter
  brew install shellcheck
fi
exit 0
