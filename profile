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

export PATH="/usr/local/bin:$PATH"

# use gnu coreutils, if they exist
if [[ -d "/usr/local/opt/coreutils/libexec/gnubin" ]]; then
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  # use man for coreutils first, then system man
  export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:/usr/share/man:/usr/local/share/man
fi
# use gnu findutils, if they exist
if [[ -d "/usr/local/opt/findutils/libexec/gnubin" ]]; then
  PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
fi
# use gnu-sed, if it exists
if [[ -d "/usr/local/opt/gnu-sed/libexec/gnubin" ]]; then
  PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
fi
# use gnu-tar, if it exists
if [[ -d "/usr/local/opt/gnu-tar/libexec/gnubin" ]]; then
  PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
fi

# set LS_COLORS (generated from dircolors)
if command -v dircolors >/dev/null 2>&1; then
  eval $(dircolors ~/.dir_colors)
fi

###
# language/tool-specific
###

# Enable pyenv, if it exists
if which pyenv > /dev/null; then
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
  source /usr/local/opt/chruby/share/chruby/auto.sh
  chruby ruby-2.5.3
fi

# use fzf, if it exists
if [ -n "$ZSH_VERSION" ] && [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif [ -n "$BASH_VERSION" ] && [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
fi
export FZF_TMUX=1

# use kubectl autocompletion, if it exists
if [ -n "$ZSH_VERSION" ] && [ $commands[kubectl] ]; then
  source <(kubectl completion zsh);
fi

source $HOME/.profile.local
