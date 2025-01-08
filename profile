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

# don't use pager in AWS CLI
export AWS_PAGER=''

# Create files as u=rwx, g=rx, o=rx
umask 022

# Set text editor
if [[ $(uname) = 'Darwin' ]]; then
  export EDITOR='code'
  export VISUAL='code'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

# enable Homebrew, if it existss
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  export HOMEBREW_INSTALL_FROM_API=true
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# use gnu coreutils, if they exist
if [[ -d "/opt/homebrew/opt/coreutils/libexec/gnubin" ]]; then
  PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
  # use man for coreutils first, then system man
  export MANPATH=/opt/homebrew/opt/coreutils/libexec/gnuman:/usr/share/man:/usr/local/share/man
fi
# use gnu findutils, if they exist
if [[ -d "/opt/homebrew/opt/findutils/libexec/gnubin" ]]; then
  PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
fi
# use gnu-sed, if it exists
if [[ -d "/opt/homebrew/opt/gnu-sed/libexec/gnubin" ]]; then
  PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
fi
# use gnu-tar, if it exists
if [[ -d "/opt/homebrew/opt/gnu-tar/libexec/gnubin" ]]; then
  PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
fi
# use gnu-grep, if it exists
if [[ -d "/opt/homebrew/opt/grep/libexec/gnubin" ]]; then
  PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
fi

# set LS_COLORS (generated from dircolors)
if command -v dircolors >/dev/null 2>&1; then
  eval $(dircolors ~/.dir_colors)
fi

###
# language/tool-specific
###

# use rancher, if it exists
if [[ -x "$HOME/.rd/bin" ]]; then
  PATH=$PATH:$HOME/.rd/bin
fi

# use nvm, if it exists
if  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  source "/opt/homebrew/opt/nvm/nvm.sh"
  source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# Enable pyenv, if it exists
if which pyenv > /dev/null; then
  eval "$(pyenv init -)";
fi
export DEFAULT_PYTHON_VERSION=$(python --version 2>&1 | cut -d ' ' -f 2)

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
if [[ -e "/opt/homebrew/opt/chruby/share/chruby/chruby.sh" ]]; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  source /opt/homebrew/opt/chruby/share/chruby/auto.sh
  chruby ruby-3.1.2
fi

# use sdkman, if it exists
if [[ -e "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  source "$HOME/.sdkman/bin/sdkman-init.sh"
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

# use fluxcd autocompletion, if it exists
if [ -n "$ZSH_VERSION" ] && [ $commands[flux] ]; then
  source <(flux completion zsh);
fi

source $HOME/.profile.local
