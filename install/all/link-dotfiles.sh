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
  bin
  bash_profile
  dir_colors
  gemrc
  gitconfig
  gitignore
  hgrc
  oh-my-zsh
  profile
  slate
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

# copy profile.local instead of symlinking
# so that we can keep local changes out of git
echo "Processing profile.local, special case"

FROM=$DOTFILE_DIR/profile.local
TO=$HOME/.profile.local

if [[ -e $TO ]]; then
  echo -e "\t$TO already exists, no action."
else
  echo -e "\tCopying - $FROM $TO"
  cp $FROM $TO
fi