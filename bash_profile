source $HOME/.profile

# history setings
export HISTIGNORE="&:ls:exit"
export HISTSIZE=10000
export HISTFILESIZE=$HISTSIZE
export INPUTRC='~/.inputrc'

shopt -s cdspell

# Tab complete for sudo
complete -cf sudo

#prevent overwriting files with cat
set -o noclobber

#stops ctrl+d from logging me out
set -o ignoreeof

#Treat undefined variables as errors
set -o nounset
