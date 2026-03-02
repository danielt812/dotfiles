# Copy stdin to clipboard (macOS/Linux)
copy() {
  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy
  elif command -v wl-copy >/dev/null 2>&1; then
    wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then
    xsel --clipboard --input
  else
    return 1
  fi
}

# Reverse a file to stdout (macOS/Linux)
reverse_file() {
  # Usage: reverse_file "$file"
  if command -v tac >/dev/null 2>&1; then
    tac -- "$1"
  elif tail -r "$1" >/dev/null 2>&1; then
    tail -r -- "$1"
  else
    # Fallback: awk reverse (works but slower)
    awk '{a[NR]=$0} END {for(i=NR;i>=1;i--) print a[i]}' -- "$1"
  fi
}

# Markdown Helper --------------------------------------------------------------
md() {
  arg=${1-}
  flag=${2-}

  case "$arg" in
    help|-h|--help|"")
      echo "Usage:"
      echo "  md tmux [flag]        View tmux plugin readmes / config"
      echo
      echo "Flags:"
      echo "  -p   pain_control.tmux"
      echo "  -s   sensible.tmux"
      echo "  -r   resurrect.tmux"
      echo "  -m   continuum.tmux"
      echo "  -y   yank.tmux"
      echo "  -c   copycat.tmux"
      echo "  -g   tmux.conf"
      return 0
      ;;
    tmux)
      if [ -z "$flag" ]; then
        echo "Use a flag option. Try: md tmux -g"
        return 1
      fi

      # require XDG_CONFIG_HOME
      if [ -z "${XDG_CONFIG_HOME-}" ]; then
        echo "XDG_CONFIG_HOME is not set (expected something like \$HOME/.config)."
        return 1
      fi

      case "$flag" in
        -p) file="$XDG_CONFIG_HOME/tmux/plugins/tmux-pain-control/README.md" ;;
        -s) file="$XDG_CONFIG_HOME/tmux/plugins/tmux-sensible/README.md" ;;
        -r) file="$XDG_CONFIG_HOME/tmux/plugins/tmux-resurrect/README.md" ;;
        -m) file="$XDG_CONFIG_HOME/tmux/plugins/tmux-continuum/README.md" ;;
        -y) file="$XDG_CONFIG_HOME/tmux/plugins/tmux-yank/README.md" ;;
        -c) file="$XDG_CONFIG_HOME/tmux/plugins/tmux-copycat/README.md" ;;
        -g) file="$XDG_CONFIG_HOME/tmux/tmux.conf" ;;
        *)  echo "Unknown flag: $flag"; return 1 ;;
      esac

      if [ ! -e "$file" ]; then
        echo "Not found: $file"
        return 1
      fi

      if [ "$flag" = "-g" ]; then
        if command -v bat >/dev/null 2>&1; then
          bat --style=plain -- "$file"
        else
          cat -- "$file"
        fi
      else
        if command -v glow >/dev/null 2>&1; then
          glow -p -- "$file"
        else
          cat -- "$file"
        fi
      fi
      ;;
    *)
      echo "Command not found. Try: md help"
      return 1
      ;;
  esac
}

# Automate git merges/pushes to master and staging branch ----------------------
alameda_push() {
  flag=${1-}

  if ! command -v git >/dev/null 2>&1; then
    echo "git not installed"
    return 1
  fi

  branch=$(git branch --show-current 2>/dev/null)
  if [ -z "$branch" ]; then
    echo "Not in a git repo."
    return 1
  fi

  case "$PWD" in
    */alameda|*/alameda/*) ;;
    *)
      echo "Error: 'alameda' is not in the present working directory"
      return 1
      ;;
  esac

  case "$branch" in
    master|staging)
      echo "Already on master or staging branch"
      return 0
      ;;
  esac

  case "$flag" in
    -h|--help|"")
      echo "Usage:"
      echo "  alameda_push -a   Push/Merge to master and staging"
      echo "  alameda_push -m   Push/Merge to master only"
      echo "  alameda_push -s   Push/Merge to staging only"
      echo "  alameda_push -h   Show help"
      return 0
      ;;
    -a)
      git pull &&
      git push &&
      git checkout master &&
      git pull &&
      git merge "$branch" --no-edit &&
      git push &&
      git checkout staging &&
      git pull &&
      git merge "$branch" --no-edit &&
      git push &&
      git checkout "$branch"
      ;;
    -m)
      git pull &&
      git push &&
      git checkout master &&
      git pull &&
      git merge "$branch" --no-edit &&
      git push &&
      git checkout "$branch"
      ;;
    -s)
      git pull &&
      git push &&
      git checkout staging &&
      git pull &&
      git merge "$branch" --no-edit &&
      git push &&
      git checkout "$branch"
      ;;
    *)
      echo "Invalid flag provided. Try: alameda_push -h"
      return 1
      ;;
  esac
}

# Kill Port (macOS/Linux) ------------------------------------------------------
kp() {
  port=${1-}
  if [ -z "$port" ]; then
    echo "Usage: kp <port>"
    return 1
  fi

  if ! command -v lsof >/dev/null 2>&1; then
    echo "lsof not installed"
    return 1
  fi

  pids=$(lsof -ti :"$port" 2>/dev/null | tr '\n' ' ')
  if [ -z "$pids" ]; then
    echo "No processes found on port $port"
    return 0
  fi

  echo "Killing port $port (PIDs: $pids)..."
  # shellcheck disable=SC2086
  kill $pids
}

# Case conversion (copies result if possible) ----------------------------------
lower() {
  arg=${1-}
  if [ -z "$arg" ]; then
    echo "toLower needs an argument"
    return 1
  fi
  lowercase_arg=$(printf "%s" "$arg" | tr '[:upper:]' '[:lower:]')
  printf "%s" "$lowercase_arg"

  if printf "%s" "$lowercase_arg" | copy_to_clipboard; then
    echo
    echo "Copied to clipboard"
  else
    echo
    echo "(clipboard utility not found)"
  fi
}

upper() {
  arg=${1-}
  if [ -z "$arg" ]; then
    echo "toUpper needs an argument"
    return 1
  fi
  uppercase_arg=$(printf "%s" "$arg" | tr '[:lower:]' '[:upper:]')
  printf "%s" "$uppercase_arg"

  if printf "%s" "$uppercase_arg" | copy_to_clipboard; then
    echo
    echo "Copied to clipboard"
  else
    echo
    echo "(clipboard utility not found)"
  fi
}

