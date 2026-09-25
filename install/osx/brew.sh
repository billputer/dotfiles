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
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.profile.local
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # the important things
  brew install zsh tmux git
  # vim
  brew install vim

  # various utilities
  brew install \
    ack \
    ag \
    awscli \
    bat \
    chezmoi \
    fastfetch \
    fd \
    diff-so-fancy \
    htop-osx \
    k9s \
    iperf3 \
    jq \
    ncdu \
    prettyping \
    rename \
    tree \
    wget \
    ;

  # language tools
  brew install pyenv ruby-install

  # install GNU coreutils, etc, instead of using BSD versions
  brew install \
    coreutils \
    findutils \
    gnu-sed \
    gnu-tar \
    ;

  # install shellcheck linter
  brew install shellcheck

fi
exit 0
