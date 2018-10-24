#!/usr/bin/env bash
#
# installs dotfiles, making backups of files before overwriting
#
set -o errexit
set -o pipefail
set -o nounset

DOTFILE_DIR="$( cd "$( dirname "$0" )/../.." && pwd )"
FILES="
  ackrc
  bash_profile
  bin
  dir_colors
  gemrc
  gitconfig
  gitignore
  hammerspoon
  hgignore
  hgrc
  hyper.js
  profile
  slate.js
  tmux.conf
  vim
  vimrc
  zsh
  zshrc
"
BACKUP_DIR=backup-$(date +"%Y%m%d_%H%M%S")

echo "Linking dotfiles in $HOME/"
for file in $FILES
do
  echo "Processing $file"
  FROM=$DOTFILE_DIR/$file
  TO=$HOME/.$file

  # backup existing files
  if [[ -e $TO && ! -h $TO ]]; then
    echo -e "\t$TO exists, moved to $BACKUP_DIR/."
    mkdir -p $BACKUP_DIR
    mv $TO $BACKUP_DIR/
  fi;

  if [[ -h $TO ]]; then
    echo -e "\t$TO exists, as a symlink, no action."
  else
    echo -e "\tLink added - $FROM -> $TO"
    ln -s $FROM $TO
  fi;

done

# create local config files for local customizations
touch $HOME/.profile.local
touch $HOME/.gitconfig.local
