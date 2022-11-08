#!/usr/bin/env bash
#
# installs karabiner configuration files
#
set -o errexit
set -o pipefail
set -o nounset

if [ -f "$HOME/.config/karabiner/karabiner.json" ]; then
  echo "karabiner configuration already installed"
else
  echo "installing default karabiner configuration files"
  mkdir -p "$HOME/.config/karabiner/"
  cp "$HOME/.files/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
fi

if [ -f "$HOME/.config/karabiner/assets/complex_modifications/remap_right_command.json" ]; then
  echo "karabiner modifications already installed"
else
  echo "installing karabiner modifications"
  mkdir -p "$HOME/.config/karabiner/assets/complex_modifications/"
  ln -s "$HOME/.files/karabiner/remap_right_command.json" "$HOME/.config/karabiner/assets/complex_modifications/remap_right_command.json"
  ln -s "$HOME/.files/karabiner/tap_control_to_escape.json" "$HOME/.config/karabiner/assets/complex_modifications/tap_control_to_escape.json"
  ln -s "$HOME/.files/karabiner/remap_mission_control.json" "$HOME/.config/karabiner/assets/complex_modifications/remap_mission_control.json"
  ln -s "$HOME/.files/karabiner/remap_control_command_d.json" "$HOME/.config/karabiner/assets/complex_modifications/remap_control_command_d.json"
fi
