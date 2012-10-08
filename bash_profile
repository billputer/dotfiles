source $HOME/.profile

#terminal and ls coloring
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export CLICOLOR='yes'
export LSCOLORS=dxfxcxdxbxegedabagacad

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
