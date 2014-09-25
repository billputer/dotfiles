# billputer's best zsh theme

# Solarized colors
local BASE03="234"
local BASE02="235"
local BASE01="240"
local BASE00="241"
local BASE0="244"
local BASE1="245"
local BASE2="254"
local BASE3="230"
local YELLOW="136"
local ORANGE="166"
local RED="160"
local MAGENTA="125"
local VIOLET="61"
local BLUE="33"
local CYAN="37"
local GREEN="64"

function prompt_char {
    if [ $UID -eq 0 ]; then echo "%F{${RED}}#%{$reset_color%}"; else echo $; fi
}

# Disable the default virtual env prompt so we can set our own
export VIRTUAL_ENV_DISABLE_PROMPT='1'
function python_info {
    PYTHON_VERSION=$(python --version 2>&1 | cut -d ' ' -f 2)
    if [ "$PYTHON_VERSION" != "$DEFAULT_PYTHON_VERSION" ]; then
        local PYTHON_VERSION_DISPLAY="python-$PYTHON_VERSION";
    fi

    if [ "$VIRTUAL_ENV" ]; then
        local VIRTUALENV_DISPLAY="@"$(basename "$VIRTUAL_ENV");
    fi

    if [ "$VIRTUALENV_DISPLAY" ] || [ "$PYTHON_VERSION_DISPLAY" ]; then
        echo "(${PYTHON_VERSION_DISPLAY}${VIRTUALENV_DISPLAY})";
    fi
}

function ruby_info {
    if [[ -x `which rvm-prompt` ]]; then
        local RVM_PROMPT="[$(rvm-prompt i v g)]"
        # show if not using default ruby
        local DEFAULT_RUBY="2.1.1"
        if [[ $RVM_PROMPT != "[ruby-$DEFAULT_RUBY]" ]];
            then echo ${RVM_PROMPT};
        fi;
    fi;
}

# Git variables
ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 %F{${GREEN}"
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

# Local variables for prompt parts
local USER_HOST="%F{${MAGENTA}}%n%F{${BASE0}}@%F{${YELLOW}}%m"
local CURRENT_DIR="%F{${BLUE}}\${PWD/#\$HOME/~}%F{${BASE0}}"
local PYTHON_INFO='$(python_info)'
local RUBY_INFO='$(ruby_info)'
local MERCURIAL_INFO='$(hg_prompt_info)'
local GIT_INFO='$(git_prompt_info)$(git_prompt_status)%{$reset_color%}'
local PROMT_CHARACTER='$(prompt_char)'
local DATETIME="%F{${GREEN}}[%*]%{$reset_color%}"

PROMPT="
${USER_HOST}: ${CURRENT_DIR} ${GIT_INFO}
 ${PROMT_CHARACTER} %{[0m%}"

RPROMPT="${PYTHON_INFO} ${RUBY_INFO} ${DATETIME}"
