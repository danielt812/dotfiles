# Shortcuts to read markdown files
md() {
  local arg=$1
  local flag=$2
  if [[ $arg == 'help' ]]; then
    echo 'Usage:'
    echo 'tmux [options]: show tmux keybinds/options'
    echo 'lvim [options]: show lvim keybinds/options'
    echo 'help: show help information'
  elif [[ $arg == 'tmux' ]]; then
    if [[ $flag == '' ]]; then
      echo 'Use flag option'
      echo '-p "pain_control.tmux"'
      echo '-s "sensible.tmux"'
      echo '-r "resurrect.tmux"'
      echo '-m "continuum.tmux"'
      echo '-y "yank.tmux"'
      echo '-c "copycat.tmux"'
      echo '-g "conf"'
    elif [[ $flag == '-p' ]]; then
      glow -p $CONFIG/tmux/plugins/tmux-pain-control/README.md
    elif [[ $flag == '-s' ]]; then
      glow -p $CONFIG/tmux/plugins/tmux-sensible/README.md
    elif [[ $flag == '-r' ]]; then
      glow -p $CONFIG/tmux/plugins/tmux-resurrect/README.md
    elif [[ $flag == '-m' ]]; then
      glow -p $CONFIG/tmux/plugins/tmux-continuum/README.md
    elif [[ $flag == '-y' ]]; then
      glow -p $CONFIG/tmux/plugins/tmux-yank/README.md
    elif [[ $flag == '-c' ]]; then
      glow -p $CONFIG/tmux/plugins/tmux-copycat/README.md
    elif [[ $flag == '-g' ]]; then
      bat --style=plain $CONFIG/tmux/tmux.conf
    fi
  elif [[ $arg == 'lvim' ]]; then
    if [[ $flag == '' ]]; then
      echo 'Use flag option'
      echo '-k "keymappings.lua"'
      echo '-s "settings.lua"'
    elif [[ $flag == '-k' ]]; then
      bat $HOME/.local/share/lunarvim/lvim/lua/lvim/keymappings.lua
    elif [[ $flag == '-s' ]]; then
      bat $HOME/.local/share/lunarvim/lvim/lua/lvim/config/settings.lua
    fi
  else
    echo 'Command not found try help'
  fi
}

batdiff() {
  git diff --name-only --relative --diff-filter=d | xargs bat --diff
}
