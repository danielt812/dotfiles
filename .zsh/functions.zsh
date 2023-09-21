# Markdown
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

summary() {
  cd $HOME/Documents
  cat summary_template.txt
  cat summary_template.txt | pbcopy
}

li() {
  cd $HOME/Documents
  gsed "s/\[NAME\]/$1/g; s/\[POSITION\]/$2/g; s/\[PLATFORM\]/$3/g" linkedin_message_template.txt | cat
  gsed "s/\[NAME\]/$1/g; s/\[POSITION\]/$2/g; s/\[PLATFORM\]/$3/g" linkedin_message_template.txt | pbcopy
}

cl() {
  cd $HOME/Documents
  gsed "s/\[COMPANY\]/$1/g; s/\[POSITION\]/$2/g" cover_letter_template.txt | cat
  gsed "s/\[COMPANY\]/$1/g; s/\[POSITION\]/$2/g" cover_letter_template.txt | pbcopy
}

summary() {
  local text='Full Stack Web Developer with 5+ years of expertise known for driving solutions, proven success, and maximizing your organizational growth. I consistently stay up to date with the latest industry trends and technologies to create engaging and user-friendly experiences. Proficient in the MERN Stack (MongoDB | Express | React | Node). I also possess advanced knowledge of JavaScript and have hands-on virtuosity with various libraries and frameworks. In my spare time, I like surfing, playing guitar, spending time with my cat, and expanding knowledge to be a command line power user'

  echo "$text" | pbcopy
  echo "$text" | cat
}

batdiff() {
  git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

# Kill Port
kp() {
  local port=$1
  echo "Killing port ${port}..."
  lsof -i :"${port}" | awk '{print $2}' | grep -v PID | xargs kill
}

# Alias FZF
af() {
  local flag=$1
  if [[ $flag == -e ]]; then
    local selected_alias=$(alias | fzf | cut -d '=' -f 1)
    if [[ -n $selected_alias ]]; then
      eval "$selected_alias"
      print -s !$
    fi
  else
    local selected_alias=$(alias | fzf | cut -d '=' -f 1 | tr -d '\n')
    if [[ -n $selected_alias ]]; then
      echo -n "$selected_alias" | pbcopy
    fi
  fi
}
