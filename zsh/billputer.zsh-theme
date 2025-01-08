#
# billputer's best zsh theme
#

# Solarized colors
BASE03="234"
BASE02="235"
BASE01="240"
BASE00="241"
BASE0="244"
BASE1="245"
BASE2="254"
BASE3="230"
YELLOW="136"
ORANGE="166"
RED="160"
MAGENTA="125"
VIOLET="61"
BLUE="33"
CYAN="37"
GREEN="64"

# Git prompt variables
ZSH_THEME_GIT_PROMPT_PREFIX="\ue0a0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{${RED}}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{${GREEN}}✔"

ZSH_THEME_GIT_PROMPT_ADDED=" %F{${YELLOW}}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %F{${YELLOW}}✹"
ZSH_THEME_GIT_PROMPT_DELETED=" %F{${RED}}✖"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %F{${YELLOW}}✭"
ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
ZSH_THEME_GIT_PROMPT_AHEAD=" ⬆"
ZSH_THEME_GIT_PROMPT_BEHIND=" ⬇"
ZSH_THEME_GIT_PROMPT_DIVERGED=" ⬍"

# Mercurial prompt variables
ZSH_THEME_HG_PROMPT_PREFIX="\ue0a0 "
ZSH_THEME_HG_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY=""
ZSH_THEME_HG_PROMPT_CLEAN=" %F{${GREEN}}✔"

ZSH_THEME_HG_PROMPT_MODIFIED=" %F{${CYAN}}✹"
ZSH_THEME_HG_PROMPT_ADDED=" %F{${GREEN}}✚"
ZSH_THEME_HG_PROMPT_DELETED=" %F{${RED}}✖"
ZSH_THEME_HG_PROMPT_MISSING=" %F{${BASE0}}!"
ZSH_THEME_HG_PROMPT_UNTRACKED=" %F{${VIOLET}}✭"

UNAME=$(uname)
HOSTNAME=$(hostname)


prompt_user_host() {
  print -n "%F{${MAGENTA}}%n" # user
  print -n "%F{${BASE0}}@"    # @ symbol
  print -n "%F{${YELLOW}}%m"  # hostname
  print -n "%{$reset_color%} "
}

prompt_current_dir() {
  print -n "%F{${BLUE}}\${PWD/#\$HOME/~}%{$reset_color%} "
}

prompt_os_emoji() {
  print -n "%F{${GREEN}}"
  if [[ "$HOSTNAME" == "bdub-dev" ]]; then
    print -n "🍕🐐 "
  elif [[ "$HOSTNAME" == "df-"* ]]; then
    print -n "🐶 "
  elif [[ "$HOSTNAME" == "cf-"* ]]; then
    print -n "😺 "
  elif [[ "$HOSTNAME" == "lp-"* ]]; then
    print -n "⛔️ 😱 ⛔️ "
  elif [[ "$HOSTNAME" == "prod-"* ]]; then
    print -n "⛔️ 😱 ⛔️ "
  elif [[ "$UNAME" == "Darwin" ]]; then
    print -n "%F{${GREEN}}"
  elif [[ "$UNAME" == "Linux" ]]; then
    print -n "🐧 "
  fi
  print -n "%{$reset_color%} "
}

prompt_return_code() {
  print -n "%(?..%F{${RED}}[%?] %{$reset_color%})"
}

prompt_git_info() {
  print -n "$(git_prompt_info)$(git_prompt_status)%{$reset_color%}"
}

prompt_aws_profile() {
  if [ -n "${AWS_PROFILE}" ]; then
    print -n "%F{${VIOLET}}(${AWS_PROFILE})%{$reset_color%} "
  fi
}

prompt_lp_current_role() {
  if whence -w lp-assume-role >/dev/null; then
    if [ $(lp-current-role) != "none" ]; then
      print -n "%F{${VIOLET}}("
      lp-current-role
      print -n ")%{$reset_color%} "
    fi
  fi
}

prompt_vi_mode(){
  VI_INSERT_MODE="%F{${YELLOW}}[% INSERT]% %{$reset_color%} "
  VI_NORMAL_MODE="%F{${BASE0}}[% NORMAL]% %{$reset_color%} "
  print -n "${${KEYMAP/vicmd/$VI_NORMAL_MODE}/(main|viins)/$VI_INSERT_MODE}"
}

# Disable the default virtual env prompt so we can set our own
export VIRTUAL_ENV_DISABLE_PROMPT='1'
prompt_python_info() {
  PYTHON_VERSION=$(python --version 2>&1 | cut -d ' ' -f 2)
  if [ "$PYTHON_VERSION" != "$DEFAULT_PYTHON_VERSION" ]; then
    local PYTHON_VERSION_DISPLAY="python-$PYTHON_VERSION";
  fi

  if [ "$VIRTUAL_ENV" ]; then
    local VIRTUALENV_DISPLAY="@"$(basename "$VIRTUAL_ENV");
  fi

  if [ "$VIRTUALENV_DISPLAY" ] || [ "$PYTHON_VERSION_DISPLAY" ]; then
    print -n "(${PYTHON_VERSION_DISPLAY}${VIRTUALENV_DISPLAY}) ";
  fi
}

prompt_ruby_info() {
  if [[ -x `which rvm-prompt` ]]; then
    local RVM_PROMPT="[$(rvm-prompt i v g)]"
    # show if not using default ruby
    local DEFAULT_RUBY="2.4.2"
    if [[ $RVM_PROMPT != "[ruby-$DEFAULT_RUBY]" ]]; then
      print -n "${RVM_PROMPT} ";
    fi;
  fi;
}

prompt_datetime() {
  print -n "%F{${GREEN}}[%*]%{$reset_color%}"
}

prompt_billputer() {
  print ""
  prompt_user_host
  prompt_os_emoji
  prompt_current_dir
  prompt_return_code
  prompt_git_info
  print -n "\n $ %f"
}

rprompt_billputer() {
  prompt_python_info
  prompt_ruby_info
  prompt_aws_profile
  prompt_lp_current_role
  prompt_vi_mode
  prompt_datetime
}

prompt_billputer_precmd() {
  PROMPT="$(prompt_billputer)"
  RPROMPT="$(rprompt_billputer)"
}

zle-line-init() {
  RPS1="$(rprompt_billputer)"
  zle reset-prompt
}

zle-keymap-select() {
  RPS1="$(rprompt_billputer)"
  zle reset-prompt
}

prompt_billputer_setup() {
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd prompt_billputer_precmd

  # updates vi-mode in RPS1
  zle -N zle-line-init
  zle -N zle-keymap-select
}

prompt_billputer_setup "$@"
