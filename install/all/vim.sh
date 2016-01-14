#!/usr/bin/env bash
#
# installs vim-specific fun stuff
#
set -o errexit
set -o nounset

yes | vim +PluginInstall +qall now
