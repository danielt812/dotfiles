# Force Bar Cursor Before Each Prompt (Ghostty + Nvim Cursor-Shape Fix) --------
_restore_bar_cursor() { printf '\e[6 q' }
precmd_functions+=(_restore_bar_cursor)

# open (macOS-style) -----------------------------------------------------------
if [[ "$OSTYPE" == linux* ]] && command -v xdg-open >/dev/null 2>&1; then
  unalias open 2>/dev/null
  open() { (xdg-open "$@" &>/dev/null &) }
fi

# Copy stdin to clipboard ------------------------------------------------------
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

  if printf "%s" "$lowercase_arg" | copy; then
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

  if printf "%s" "$uppercase_arg" | copy; then
    echo
    echo "Copied to clipboard"
  else
    echo
    echo "(clipboard utility not found)"
  fi
}

# Convert timestamp to local time -----------------------------------------------
ltime() {
  ts=${1-}
  if [ -z "$ts" ]; then
    echo "Usage: tz <timestamp>"
    echo "  Accepts: ISO 8601, epoch seconds/ms, or date strings"
    echo "  Example: tz 2026-03-18T14:30:00Z"
    echo "  Example: tz 1742310600"
    return 1
  fi

  # epoch milliseconds → seconds
  if printf "%s" "$ts" | grep -qE '^[0-9]{13}$'; then
    ts=$(( ts / 1000 ))
  fi

  # epoch seconds
  if printf "%s" "$ts" | grep -qE '^[0-9]{9,10}$'; then
    if date -r "$ts" '+%A %d %b %Y  %I:%M:%S %p %Z' 2>/dev/null; then
      return 0
    elif date -d "@$ts" '+%A %d %b %Y  %I:%M:%S %p %Z' 2>/dev/null; then
      return 0
    fi
    echo "Failed to convert epoch: $ts"
    return 1
  fi

  # date/ISO string
  if date -jf '%Y-%m-%dT%H:%M:%S%z' "$ts" '+%A %d %b %Y  %I:%M:%S %p %Z' 2>/dev/null; then
    return 0
  elif date -jf '%Y-%m-%dT%H:%M:%SZ' "$ts" '+%A %d %b %Y  %I:%M:%S %p %Z' 2>/dev/null; then
    return 0
  elif date -d "$ts" '+%A %d %b %Y  %I:%M:%S %p %Z' 2>/dev/null; then
    return 0
  fi

  echo "Could not parse: $ts"
  return 1
}

