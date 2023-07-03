# Print Config Func
pc() {
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
      bat --style=plain $CONFIG/tmux/plugins/tmux-pain-control/pain_control.tmux
    elif [[ $flag == '-s' ]]; then
      bat --style=plain $CONFIG/tmux/plugins/tmux-sensible/sensible.tmux
    elif [[ $flag == '-r' ]]; then
      bat --style=plain $CONFIG/tmux/plugins/tmux-resurrect/resurrect.tmux
    elif [[ $flag == '-m' ]]; then
      bat --style=plain $CONFIG/tmux/plugins/tmux-continuum/continuum.tmux
    elif [[ $flag == '-y' ]]; then
      bat --style=plain $CONFIG/tmux/plugins/tmux-yank/yank.tmux
    elif [[ $flag == '-c' ]]; then
      bat --style=plain $CONFIG/tmux/plugins/tmux-copycat/copycat.tmux
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
    echo 'Command not found type pc help for usage.'
  fi
}

# Automate git merges/pushes to master and staging branch
alameda_push() {
  local branch=$(git branch --show-current 2> /dev/null)
  local flag=$1

  if [[ $branch =~ ^(master|staging)$ ]]; then
    echo 'Already on master or staging branch'
  else
    if [[ $flag == '-a' ]]; then
      gpush && gcom && gm $branch --no-edit && gpush && gcos && gm $branch --no-edit && gpush && gco $branch
    elif [[ $flag == '-m' ]]; then
      gpush && gcom && gm $branch --no-edit && gpush && gco $branch
    elif [[ $flag == '-s' ]]; then
      gpush && gcos && gm $branch --no-edit && gpush && gco $branch
    elif [[ $flag == '-h' ]]; then
      echo 'Usage:'
      echo '-a: Push/Merge to master and staging'
      echo '-m: Push/Merge to master only'
      echo '-s: Push/Merge to staging only'
      echo '-h: Show help information'
    else
      echo 'Invalid flag provided'
    fi
  fi
}

alameda_path() {
  cd $HOME/mcisemi/alameda/www.mcisemi.com
  git checkout master
  git pull
  cd $1
  git checkout $1 2> /dev/null
  git pull

  local url=$(basename $(pwd))
  code .
  open -a $BROWSER "http://mcisemi.alameda.test/$url"
}

batdiff() {
  git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

delete_cron_job() {
  kubectl -n mci-cronies-prod delete cronjob $1
}

cover_letter() {
  cd $HOME/Documents/resume
  sed "s/\[Company Name\]/$1/g" Cover_letter_template.txt > "$1_Cover_Letter.txt" | cat | pbcopy
  cat "$1_Cover_Letter.txt"
}

