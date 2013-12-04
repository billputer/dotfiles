
function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
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
        if [[ $RVM_PROMPT != "[ruby-2.0.0]" ]];
            then echo ${RVM_PROMPT};
        fi;
    fi;
}

# Git variables
ZSH_THEME_GIT_PROMPT_PREFIX="on %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Local variables for prompt parts
local USER_HOST='%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}'
local CURRENT_DIR='%{$fg_bold[blue]%}${PWD/#$HOME/~}%{$reset_color%}'
local PYTHON_INFO='$(python_info)'
local RUBY_INFO='$(ruby_info)'
local MERCURIAL_INFO='$(hg_prompt_info)'
local GIT_INFO='$(git_prompt_info)'
local PROMT_CHARACTER='$(prompt_char)'
local DATETIME='%{$fg[green]%}[%*]%{$reset_color%}'

PROMPT="
${USER_HOST}: ${CURRENT_DIR} ${GIT_INFO}
 ${PROMT_CHARACTER} "

RPROMPT="${PYTHON_INFO} ${RUBY_INFO} ${DATETIME}"
