#!/usr/bin/env bash
#
# ubuntu and debian-specific setup
#
set -o errexit
set -o pipefail
set -o nounset

read -p 'Do you want to `apt-get install` utilities ? ' -n 1 -r choice
echo # move to a new line
if [[ $choice =~ ^[Yy]$ ]]; then

  # install various utilities
  sudo apt-get install -y \
    ack-grep \
    curl \
    htop \
    iftop \
    iotop \
    iperf3 \
    jq \
    ncdu \
    nmap \
    rename \
    tcpdump \
    tmux \
    tree \
    vim \
    zsh \
    ;

fi
