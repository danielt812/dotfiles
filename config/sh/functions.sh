#!/usr/bin/env bash
# bash + zsh compatible (not pure POSIX sh). Source it from your shell rc.

# ----------------------------
# Small cross-platform helpers
# ----------------------------

# Copy stdin to clipboard (macOS/Linux)
copy_to_clipboard() {
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

# Add a command to shell history (bash/zsh)
add_history() {
  # Usage: add_history "some command"
  if [ -n "${ZSH_VERSION-}" ]; then
    print -s -- "$1"
  elif [ -n "${BASH_VERSION-}" ]; then
    history -s -- "$1"
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

# ----------------------------
# Markdown helper
# ----------------------------
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

# ----------------------------
# System update (macOS + Linux)
# ----------------------------
sysup() {
  if command -v softwareupdate >/dev/null 2>&1; then
    softwareupdate --all --install --force
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf upgrade --refresh
  elif command -v apt >/dev/null 2>&1; then
    sudo apt update && sudo apt upgrade
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Syu
  else
    echo "No known system updater found."
    return 1
  fi
}

# ----------------------------
# Alias FZF (copy or execute selected alias)
# ----------------------------
af() {
  flag=${1-}

  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"
    return 1
  fi

  selected_alias=$(
    alias | fzf | sed -E 's/=.*$//' | tr -d '\n'
  )

  if [ -z "$selected_alias" ]; then
    return 0
  fi

  case "$flag" in
    -e|--execute)
      # Execute the alias by name
      eval "$selected_alias"
      # Store the alias name in history (not the expanded command)
      add_history "$selected_alias"
      ;;
    *)
      # Copy alias name to clipboard
      if printf "%s" "$selected_alias" | copy_to_clipboard; then
        :
      else
        echo "$selected_alias"
        echo "(clipboard utility not found)"
        return 1
      fi
      ;;
  esac
}

# ----------------------------
# History fzf (execute or copy)
# ----------------------------
histf() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"
    return 1
  fi

  # Determine history source
  # bash: HISTFILE usually set; zsh: HISTFILE set too
  if [ -z "${HISTFILE-}" ] || [ ! -f "$HISTFILE" ]; then
    echo "HISTFILE is not set or not found."
    return 1
  fi

  mode="copy" # default
  for arg in "$@"; do
    case "$arg" in
      -e|--execute) mode="execute" ;;
      -c|--copy)    mode="copy" ;;
      -h|--help)
        echo "Usage: histf [-e|--execute] [-c|--copy]"
        return 0
        ;;
      *)
        echo "Unknown flag: $arg"
        return 1
        ;;
    esac
  done

  selected_command=$(
    reverse_file "$HISTFILE" | fzf | tr -d '\n'
  )

  if [ -z "$selected_command" ]; then
    return 0
  fi

  if [ "$mode" = "execute" ]; then
    eval "$selected_command"
  else
    if printf "%s" "$selected_command" | copy_to_clipboard; then
      :
    else
      echo "$selected_command"
      echo "(clipboard utility not found)"
      return 1
    fi
  fi
}

# ----------------------------
# Automate git merges/pushes to master and staging branch
# ----------------------------
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

# ----------------------------
# Kill Port (macOS/Linux)
# ----------------------------
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

# ----------------------------
# Case conversion (copies result if possible)
# ----------------------------
toLower() {
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

toUpper() {
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

generateBearer() {
  if ! command -v openssl >/dev/null 2>&1; then
    echo "openssl not installed"
    return 1
  fi
  token="Bearer $(openssl rand -base64 16)"
  echo "$token"
  if printf "%s" "$token" | copy_to_clipboard; then
    :
  else
    echo "(clipboard utility not found)"
  fi
}

# ----------------------------
# cdfzf (macOS/Linux, bash/zsh)
# ----------------------------
cdfzf() {
  depth=0
  hidden=false
  no_ignore=false
  preview=false
  tree=false

  show_help() {
    echo "Usage: cdfzf [OPTIONS]"
    echo
    echo "OPTIONS:"
    echo "  -d, --depth <N>      Max directory depth"
    echo "  -h, --hidden         Include hidden directories"
    echo "  -i, --no-ignore      Don't respect .gitignore (fd only)"
    echo "  -p, --preview        Preview selected directory"
    echo "  -t, --tree           Tree preview (implies --preview)"
    echo "  help, --help         Show help"
  }

  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"
    return 1
  fi

  # Choose list command for preview
  if command -v lsd >/dev/null 2>&1; then
    list_cmd='lsd --group-dirs=first'
  elif command -v eza >/dev/null 2>&1; then
    list_cmd='eza --group-directories-first'
  elif command -v exa >/dev/null 2>&1; then
    list_cmd='exa --group-directories-first'
  else
    # ls color differs: GNU uses --color, BSD uses -G
    if ls --color=always . >/dev/null 2>&1; then
      list_cmd='ls -F --color=always'
    else
      list_cmd='ls -FG'
    fi
  fi

  # Parse flags
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -d|--depth) depth=${2-0}; shift 2 ;;
      -h|--hidden) hidden=true; shift ;;
      -i|--no-ignore) no_ignore=true; shift ;;
      -p|--preview) preview=true; shift ;;
      -t|--tree) tree=true; preview=true; shift ;;
      help|--help) show_help; return 0 ;;
      --) shift; break ;;
      *) break ;;
    esac
  done

  # Build directory list
  if command -v fd >/dev/null 2>&1; then
    cmd="fd -t d"
    if [ "$hidden" = true ]; then
      cmd="$cmd --hidden --exclude .git --exclude node_modules"
    else
      cmd="$cmd --exclude .git --exclude node_modules"
    fi
    if [ "$depth" -ne 0 ] 2>/dev/null; then
      cmd="$cmd -d $depth"
    fi
    if [ "$no_ignore" = true ]; then
      cmd="$cmd --no-ignore"
    fi
    dir_list=$(eval "$cmd" 2>/dev/null)
  else
    # Portable find
    if [ "$depth" -ne 0 ] 2>/dev/null; then
      if [ "$hidden" = true ]; then
        dir_list=$(find . -maxdepth "$depth" -type d 2>/dev/null)
      else
        dir_list=$(find . -maxdepth "$depth" -type d ! -path '*/.*' 2>/dev/null)
      fi
    else
      if [ "$hidden" = true ]; then
        dir_list=$(find . -type d 2>/dev/null)
      else
        dir_list=$(find . -type d ! -path '*/.*' 2>/dev/null)
      fi
    fi
  fi

  if [ -z "$dir_list" ]; then
    echo "No directories found."
    return 1
  fi

  fzf_cmd="fzf --prompt='Select Directory: '"

  if [ "$preview" = true ]; then
    if [ "$tree" = true ] && command -v tree >/dev/null 2>&1; then
      fzf_cmd="$fzf_cmd --preview 'tree -C -L 2 {} | head -n 200'"
    else
      fzf_cmd="$fzf_cmd --preview '$list_cmd {} | head -n 120'"
    fi
  fi

  selected_dir=$(printf "%s\n" "$dir_list" | eval "$fzf_cmd" | tr -d '\n')
  if [ -z "$selected_dir" ]; then
    return 0
  fi

  cd -- "$selected_dir" || return 1
}

alias cdf="cdfzf"

# ----------------------------
# Git branch fzf (local/remote checkout/delete/merge/pull/stash/new/list)
# ----------------------------
git_branch_fzf() {
  if ! command -v git >/dev/null 2>&1; then
    echo "git not installed"
    return 1
  fi
  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"
    return 1
  fi

  action="checkout"
  remote=false
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  show_help() {
    echo "Usage: git_branch_fzf [OPTIONS]"
    echo
    echo "OPTIONS:"
    echo "  -c, --checkout      Checkout a branch (default)"
    echo "  -d, --delete        Delete a branch (confirm)"
    echo "  -r, --remote        Operate on remote branches"
    echo "  -m, --merge         Merge selected branch into current"
    echo "  -p, --pull          Checkout then pull"
    echo "  -s, --stash         Stash changes before checkout"
    echo "  -n, --new-branch    Create and checkout a new branch"
    echo "  -l, --list          Print selected branch"
    echo "  -h, --help          Show help"
  }

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -c|--checkout) action="checkout"; shift ;;
      -d|--delete) action="delete"; shift ;;
      -r|--remote) remote=true; shift ;;
      -m|--merge) action="merge"; shift ;;
      -p|--pull) action="pull"; shift ;;
      -s|--stash) action="stash"; shift ;;
      -n|--new-branch) action="new-branch"; shift ;;
      -l|--list) action="list"; shift ;;
      -h|--help) show_help; return 0 ;;
      *) break ;;
    esac
  done

  confirm() {
    printf "Are you sure you want to delete '%s'? [y/N] " "$1"
    IFS= read -r ans
    case "$ans" in
      y|Y|yes|YES) return 0 ;;
      *) echo "Aborted."; return 1 ;;
    esac
  }

  protected_branch() {
    case "$1" in
      master|main) return 0 ;;
      *) return 1 ;;
    esac
  }

  if [ "$remote" = true ]; then
    selected=$(git branch -r | sed 's/^[[:space:]]*//' | grep -v '->' | fzf | tr -d '[:blank:]')
    [ -z "$selected" ] && return 0
    base=${selected#origin/}

    case "$action" in
      delete)
        if protected_branch "$base"; then
          echo "Cannot delete protected branch '$base'."
          return 1
        fi
        if confirm "$base"; then
          git push origin --delete "$base"
        fi
        ;;
      list) echo "$selected" ;;
      merge) git merge "$selected" ;;
      pull) git checkout "$base" && git pull ;;
      new-branch)
        printf "Enter new branch name: "
        IFS= read -r new_branch_name
        [ -z "$new_branch_name" ] && return 1
        git checkout -b "$new_branch_name"
        ;;
      *)
        git checkout -b "$base" "$selected"
        ;;
    esac
  else
    selected=$(git branch --format='%(refname:short)' | fzf | tr -d '[:blank:]')
    [ -z "$selected" ] && return 0

    case "$action" in
      delete)
        if protected_branch "$selected"; then
          echo "Cannot delete protected branch '$selected'."
          return 1
        fi

        # Switch away if deleting current branch
        if [ "$current_branch" = "$selected" ]; then
          if git show-ref --verify --quiet refs/heads/main; then
            git checkout main
          elif git show-ref --verify --quiet refs/heads/master; then
            git checkout master
          else
            echo "No main/master branch to switch to."
            return 1
          fi
        fi

        if confirm "$selected"; then
          git branch -D "$selected"
        fi
        ;;
      list) echo "$selected" ;;
      merge) git merge "$selected" ;;
      pull) git checkout "$selected" && git pull ;;
      stash) git stash && git checkout "$selected" ;;
      new-branch)
        printf "Enter new branch name: "
        IFS= read -r new_branch_name
        [ -z "$new_branch_name" ] && return 1
        git checkout -b "$new_branch_name"
        ;;
      *)
        git checkout "$selected"
        ;;
    esac
  fi
}

alias gbf="gbfzf"
