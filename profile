if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

# Reset PATH to keep it from being clobbered in tmux
if [ -x /usr/libexec/path_helper ]; then
    PATH=''
    source /etc/profile
fi

source $HOME/.files/aliases

# fix less
export PAGER='less'

# Create files as u=rwx, g=rx, o=rx
umask 022

# Set text editor
if [[ $(uname) = 'Darwin' ]]; then
  export EDITOR='atom'
  export VISUAL='atom'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

# Mac specific PATH
if [[ $(uname) = 'Darwin' ]]; then
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

# set LS_COLORS (generated from dircolors)
eval $(dircolors ~/.dir_colors)

###
# language/tool-specific
###

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
  chruby ruby-2.3.1
fi

# use fzf, if it exists
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.profile.local
