if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

# Reset PATH to keep it from being clobbered in tmux
if [ -x /usr/libexec/path_helper ]; then
    PATH=''
    source /etc/profile
fi

source $HOME/.profile.local

export SYSTEM=$(uname)

# fix less
export PAGER='less'

# Set text editor
if [[ $SYSTEM = 'Darwin' ]]; then
  export EDITOR='subl --new-window --wait'
  export VISUAL='subl --new-window --wait'
  alias e='subl --new-window'
else
  export EDITOR='vim'
  export VISUAL='vim'
  alias e='vim'
fi

# set default Vagrant provider
export VAGRANT_DEFAULT_PROVIDER='vmware_fusion'

# Mac specific PATH
if [[ $SYSTEM = 'Darwin' ]]; then
  # HomeBrew
  export PATH=/usr/local/sbin:$PATH
fi
export PATH="/usr/local/bin:$PATH"

# use gnu coreutils, if they exist
if [[ -d "/usr/local/opt/coreutils/libexec/gnubin" ]]; then
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  # use man gor coreutils first, then system man
  export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:/usr/share/man:/usr/local/share/man
fi

# Enable pyenv, if it exists
if [[ -x $(which pyenv) ]]; then
  eval "$(pyenv init -)";
fi
export DEFAULT_PYTHON_VERSION=$(python --version 2>&1 | cut -d ' ' -f 2)

# add npm binaries to path
if [[ -d "/usr/local/share/npm/bin" ]]; then
  export PATH="/usr/local/share/npm/bin:$PATH";
fi

# add Heroku Toolbelt to path
if [[ -d "/usr/local/heroku/bin" ]]; then
  export PATH="/usr/local/heroku/bin:$PATH";
fi

if [[ -x "$HOME/.rvm/scripts/rvm" ]]; then
  # Add RVM to PATH for scripting
  PATH=$PATH:$HOME/.rvm/bin
  # Load RVM into a shell session *as a function*
  source "$HOME/.rvm/scripts/rvm";
fi

# use chruby, if it exists
if [[ -e "/usr/local/share/chruby/chruby.sh" ]]; then
  source /usr/local/share/chruby/chruby.sh
  chruby ruby-2.1.2
fi


# set LS_COLORS (generated from dircolors)
eval $(dircolors ~/.dir_colors)

# use a download cache for pip
export PIP_DOWNLOAD_CACHE=$HOME/.pip-download-cache

# Red STDERR
# rse <command string>
rse () {
  # We need to wrap each phrase of the command in quotes to preserve arguments that contain whitespace
  # Execute the command, swap STDOUT and STDERR, colour STDOUT, swap back
  ((eval $(for phrase in "$@"; do echo -n "'$phrase' "; done)) 3>&1 1>&2 2>&3 | sed -e "s/^\(.*\)$/$(echo -en \\033)[31;1m\1$(echo -en \\033)[0m/") 3>&1 1>&2 2>&3
}

# Create files as u=rwx, g=rx, o=rx
umask 022

