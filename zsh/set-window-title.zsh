# use tabset to set color based on current directory
# see: https://www.npmjs.com/package/iterm2-tab-set
function set-tab-color {
  current_dir=$1
  case ${current_dir} in
    "~/workspace/terraform")
      tabset --color solarized_cyan;
      ;;
    "~/workspace/relight")
      tabset --color solarized_blue;
      ;;
    "~/workspace/docker-utility")
      tabset --color solarized_violet;
      ;;
    "~/workspace/lpx-ansible")
      tabset --color solarized_orange;
      ;;
    "~/workspace/lpx-app")
      tabset --color solarized_yellow;
      ;;
    *)
      tabset --color default_grey;
  esac
}

# set window title to current directory
function set-window-title {
  current_dir=$(dirs -p | head -n 1)
  echo -ne "\e]1;${current_dir}\a"

  # set tab color if tabset is installed
  if type tabset > /dev/null; then
    set-tab-color ${current_dir}
  fi
}

set-window-title
add-zsh-hook precmd set-window-title
