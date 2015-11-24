function in_hg() {
  if [[ -d .hg ]] || $(hg summary > /dev/null 2>&1); then
    echo 1
  fi
}

function hg_get_branch_name() {
  echo $(hg branch)
}

function hg_prompt_info {
  if [ $(in_hg) ]; then
    echo -n "$ZSH_THEME_HG_PROMPT_PREFIX$(hg_get_branch_name)$(hg_dirty)$ZSH_THEME_HG_PROMPT_SUFFIX"
  fi
}

function hg_dirty {
  hg status 2> /dev/null | command grep -Eq '^\s*[ACDIM!?L]'
  if [ $pipestatus[-1] -eq 0 ]; then
    # Grep exits with 0 when "One or more lines were selected", return "dirty".
    echo -n $ZSH_THEME_HG_PROMPT_DIRTY
  else
    # Otherwise, no lines were found, or an error occurred. Return clean.
    echo -n $ZSH_THEME_HG_PROMPT_CLEAN
  fi
}

# Get the status of the working tree
function hg_prompt_status() {
  INDEX=$(command hg status 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^! ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_MISSING$STATUS"
  fi
  if $(echo "$INDEX" | command grep -E '^\? ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^M ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_MODIFIED$STATUS"
  fi

  echo -n "${STATUS}"
}
