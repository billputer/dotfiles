#!/usr/bin/env zsh

#################################################
# ZSH specific configuration
#################################################

# don't automatically update oh-my-zsh
DISABLE_AUTO_UPDATE=true

if [ -f $HOME/.zsh/zgen-setup ]; then
  source $HOME/.zsh/zgen-setup
fi

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

# disable spelling correction
unsetopt correct
# prevents from accidentally overwriting a file with >
setopt noclobber
# disables auto-completion of LDAP usernames
unsetopt cdablevars

# history settings
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
# see https://linux.die.net/man/1/zshoptions
setopt append_history
setopt extendedhistory
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt share_history

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
# bind up and down to use history substring searching
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# utility function for determining whether a name exists
function exists {
  whence -w $1 >/dev/null
}

source $HOME/.profile
