if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

export SYSTEM_OSX='Mac OS X'
export SYSTEM_NIX='Linux'
export SYSTEM_CENTOS='Centos'
export SYSTEM_UBUNTU='Ubuntu'
export SYSTEM_UNKNOWN='Unknown'

source $HOME/.profile.local

# fix less
export PAGER='less'

# Set text editor
if [[ $SYSTEM =~ $SYSTEM_OSX ]]; then
  export EDITOR='mate -w'
  export VISUAL='mate -w'
elif [[ $SYSTEM =~ $SYSTEM_NIX ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
fi

alias edit=$EDITOR
alias e='edit'

#terminal and ls coloring
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export CLICOLOR='yes'
export LSCOLORS=dxfxcxdxbxegedabagacad

# Mac specific PATH
if [[ $SYSTEM =~ $SYSTEM_OSX ]]; then
  # MacPorts
  export PATH=/opt/local/bin:/opt/local/sbin:$PATH
  # Python 2.7
  export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
fi
export PATH="/usr/local/bin:$PATH"

# RubyGems
export PATH=~/.gem/ruby/1.8/bin:$PATH
export RUBYOPT=rubygems 




# Aliases
alias ll='ls -l'
alias la='ls -a'
alias dm="python manage.py"
alias digg="dig +multiline +nocomments +nocmd +noquestion +nostats +search"

alias q='exit'

# Make mkdir recursive
alias mkdir='mkdir -p'

# Screen tools
alias ss='screen -S'
alias sls='screen -list'

# Server control
alias df='df -kH'

alias grep='grep --color=auto'

alias tu='top -o cpu'
alias tm='top -o vsize'

# convert newlines to LF
alias convert_newlines="perl -pi -e 's/\r\n/\n/g'"

# SVN
alias sco='svn co'
alias sup='svn up'
alias sci='svn ci -m'
alias saa='svn status | grep "^\?" | awk "{print \$2}" | xargs svn add'
alias slog="svn log --limit=7"
alias scleann="svn status --no-ignore | grep '^\?' | sed 's/^\?      //'  | xargs rm -rf"


# Red STDERR
# rse <command string>
rse () {
  # We need to wrap each phrase of the command in quotes to preserve arguments that contain whitespace
  # Execute the command, swap STDOUT and STDERR, colour STDOUT, swap back
  ((eval $(for phrase in "$@"; do echo -n "'$phrase' "; done)) 3>&1 1>&2 2>&3 | sed -e "s/^\(.*\)$/$(echo -en \\033)[31;1m\1$(echo -en \\033)[0m/") 3>&1 1>&2 2>&3
}

# Create files as u=rwx, g=rx, o=rx
umask 022

test -r
