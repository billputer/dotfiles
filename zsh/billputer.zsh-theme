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

function os_emoji {
    UNAME=$(uname)
    if [[ "$UNAME" == "Darwin" ]]; then
        echo ""
    elif [[ "$UNAME" == "Linux" ]]; then
        echo "🐧 "
    fi
}

function return_code {
    echo "%(?..%F{${RED}}[%?]%{$reset_color%})"
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

# set username color in terminal based on username
function user_color {
    if [[ $USER == bill* ]]; then
        echo ${MAGENTA}
    else
        echo ${ORANGE}
    fi
}

# Git prompt variables
ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 "
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
ZSH_THEME_HG_PROMPT_PREFIX=" \ue0a0 "
ZSH_THEME_HG_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY=""
ZSH_THEME_HG_PROMPT_CLEAN=" %F{${GREEN}}✔"

ZSH_THEME_HG_PROMPT_MODIFIED=" %F{${CYAN}}✹"
ZSH_THEME_HG_PROMPT_ADDED=" %F{${GREEN}}✚"
ZSH_THEME_HG_PROMPT_DELETED=" %F{${RED}}✖"
ZSH_THEME_HG_PROMPT_MISSING=" %F{${BASE0}}!"
ZSH_THEME_HG_PROMPT_UNTRACKED=" %F{${VIOLET}}✭"

# Local variables for prompt parts
local USER_HOST="%F{$(user_color)}%n%F{${BASE0}}@%F{${YELLOW}}%m %F{${GREEN}}$(os_emoji)"
local CURRENT_DIR="%F{${BLUE}}\${PWD/#\$HOME/~}%F{${BASE0}}"
local MERCURIAL_INFO='$(hg_prompt_info)$(hg_prompt_status)%{$reset_color%}'
local GIT_INFO='$(git_prompt_info)$(git_prompt_status)%{$reset_color%}'
local PYTHON_INFO='$(python_info)'
local RUBY_INFO='$(ruby_info)'
local PROMPT_CHARACTER='$'
local DATETIME="%F{${GREEN}}[%*]%{$reset_color%}"

PROMPT="
${USER_HOST} ${CURRENT_DIR} $(return_code) ${GIT_INFO}${MERCURIAL_INFO}
 ${PROMPT_CHARACTER} %{[0m%}"

RPROMPT="${PYTHON_INFO} ${RUBY_INFO} ${DATETIME}"
