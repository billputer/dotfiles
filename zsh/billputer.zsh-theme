
function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}

# Disable the default virtual env prompt so we can set our own
export VIRTUAL_ENV_DISABLE_PROMPT='1'
function python_info {
    [ $VIRTUAL_ENV ] && echo "(%{$reset_color%}"`basename $VIRTUAL_ENV`"%{$reset_color%})"

    # TODO: switch to pyenv
    #
    # PYTHON_VERSION=$(pyenv local 2>&1)
    # if [ $PYTHON_VERSION = "pyenv: no local version configured for this directory" ]; then
    #     PYTHON_VERSION=$(pyenv global 2>&1)
    # fi
    # if [ $VIRTUAL_ENV ]; then
    #     local VIRTUALENV="@"`basename $VIRTUAL_ENV`
    # fi
    # echo "(python-"`basename $PYTHON_VERSION`"${VIRTUALENV}) "
}

function ruby_info {
    echo "[$(rvm-prompt)] "
}

# Git variables
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[green]%}"
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
