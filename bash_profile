source $HOME/.profile

#terminal and ls coloring

function bashcoloring {
    local CYAN="\[\033[0;36m\]"
    local RED="\[\033[0;31m\]"
    local MAGENTA="\[\033[0;35m\]"
    local YELLOW="\[\033[0;33m\]"
    local NO_COLOR="\[\033[00m\]"
    PS1="${RED}\u${NO_COLOR}@${YELLOW}\h${NO_COLOR}: \[\033[01;34m\]\w\n ${NO_COLOR}\$ "
}
bashcoloring

# history settings
export HISTIGNORE="&:ls:exit"
export HISTSIZE=10000
export HISTFILESIZE=$HISTSIZE
export HISTTIMEFORMAT="%Y-%m-%d %T "
export INPUTRC='~/.inputrc'

# append to the history file, don't overwrite it
shopt -s histappend

# automatically correct mispelled directories when using cd
shopt -s cdspell

# Tab complete for sudo
complete -cf sudo

#prevent overwriting files with cat
set -o noclobber

