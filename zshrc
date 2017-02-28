#################################################
# ZSH specific configuration
#################################################

# Path to oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
# look for custom zsh plugins/themes in .zsh
ZSH_CUSTOM=$HOME/.files/zsh
# set zsh theme to load
ZSH_THEME="billputer"
# disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"
# disable AUTO_TITLE
DISABLE_AUTO_TITLE="true"
# set our own title
precmd () {
    # print hostname (%m) if SSH_CLIENT variable is set
    if [ $SSH_CLIENT ]; then
        print -Pn "\e]0;%m: %~\a"
    else
        print -Pn "\e]0;%~\a"
    fi
}

plugins=(
  aws
  brew
  bundler
  fabric
  gem
  golang
  history-substring-search
  redis-cli
  pip
  python
  vagrant
)

source $ZSH/oh-my-zsh.sh

# disable spelling correction
unsetopt correct
# prevents from accidentally overwriting a file with >
setopt noclobber
# disables auto-completion of LDAP usernames
unsetopt cdablevars

# history settings
HISTCONTROL=erasedups
HISTFILE=~/.zsh_history
HISTSIZE=9999
SAVEHIST=9999
setopt extendedhistory

# Fix issue where git autocompletion takes forever and eats cpu.
# See http://superuser.com/questions/458906/zsh-tab-completion-of-git-commands-is-very-slow-how-can-i-turn-it-off
__git_files () {
  _wanted files expl 'local files' _files
}

# enable vi-mode
bindkey -v
# set a short KEYTIMEOUT for quickly switching between modes
export KEYTIMEOUT=1

# bind Home and End
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
# bind ctrl-y and ctrl-o to forward and back word
bindkey '' backward-word
bindkey '' forward-word

# utility function for determining whether a name exists
function exists {
  whence -w $1 >/dev/null
}

source $HOME/.profile
