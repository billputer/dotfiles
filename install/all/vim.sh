#!/usr/bin/env bash
#
# installs vim-specific fun stuff
#
set -o errexit
set -o nounset

echo "installing vim plugins"
yes | vim +PluginInstall +qall now &> /dev/null
