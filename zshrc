# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# look for custom zsh plugins/themes in .zsh
ZSH_CUSTOM=$HOME/.files/zsh

# set zsh theme to load
ZSH_THEME="billputer"



# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Disable AUTO_TITLE
DISABLE_AUTO_TITLE="true"
# Set our own title
precmd () {
    # print hostname (%m) if SSH_CLIENT variable is set
    if [ $SSH_CLIENT ]; then
        print -Pn "\e]0;%m: %~\a"
    else
        print -Pn "\e]0;%~\a"
    fi
}

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(cap git git-flow knife osx pip python svn vagrant)


source $ZSH/oh-my-zsh.sh

unsetopt correctall

source $HOME/.profile


# Fix issue where git autocompletion takes forever and eats cpu.
# See http://superuser.com/questions/458906/zsh-tab-completion-of-git-commands-is-very-slow-how-can-i-turn-it-off
__git_files () {
  _wanted files expl 'local files' _files
}

# disables auto-completion of LDAP usernames
unsetopt cdablevars

# history settings
HISTCONTROL=erasedups
HISTFILE=~/.zsh_history
HISTSIZE=9999
SAVEHIST=9999
setopt extendedhistory
