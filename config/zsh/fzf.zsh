# Completion hooks -------------------------------------------------------------

# Override directory discovery for ** completions — uses fd when available
_fzf_compgen_dir() {
  local base_dir="$1"
  if command -v fd >/dev/null 2>&1; then
    fd --type d --hidden --follow --color=always \
      --exclude ".git" \
      --exclude "node_modules" \
      . "$base_dir"
  else
    command find -L "$base_dir" \
      \( -name .git -o -name node_modules \) -prune -o \
      -type d -print 2>/dev/null
  fi
}

# Picker for unsetting aliases with live previews
_fzf_compgen_unalias() {
  local tmp
  tmp=$(mktemp "${TMPDIR:-/tmp}/zsh-aliases.XXXXXX")
  trap "rm -f '$tmp'" EXIT
  alias > "$tmp"
  local preview_cmd="grep -F --color=always \"{}=\" '$tmp'"
  if command -v bat >/dev/null 2>&1; then
    preview_cmd="$preview_cmd | bat -l zsh --style=plain --color=always"
  fi
  print -l "${(@k)aliases}" | fzf "$@" --preview "$preview_cmd"
}

# Context-aware previews for ** completions based on the active command
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd|pushd|rmdir)
      if command -v eza >/dev/null 2>&1; then
        fzf "$@" --preview 'eza --tree --level=2 --color=always --group-directories-first {} | head -200'
      elif command -v tree >/dev/null 2>&1; then
        fzf "$@" --preview 'tree -C {} | head -200'
      else
        fzf "$@" --preview 'ls -1 --color=always {} | head -200'
      fi
      ;;
    vim|nvim|vi|nano|code|cat|bat|less|more)
      if command -v bat >/dev/null 2>&1; then
        fzf "$@" --preview 'bat --style=numbers --color=always --line-range :500 {}' \
          --preview-window 'top:60%:border-bottom'
      else
        fzf "$@" --preview 'cat {}'
      fi
      ;;
    export|unset|printenv)
      fzf "$@" --preview "printenv {}" --preview-window="top:3:wrap"
      ;;
    kill|pkill)
      fzf "$@" --preview 'ps -fp {1} 2>/dev/null || print "Process not found"' \
        --preview-window="top:20%:wrap"
      ;;
    ssh|telnet)
      fzf "$@" --preview 'cat ~/.ssh/config 2>/dev/null | grep -A 4 "Host {}" || print "System Host: {}"' \
        --preview-window="top:20%:wrap"
      ;;
    git)
      if command -v delta >/dev/null 2>&1; then
        fzf "$@" --preview 'git diff --color=always {} | delta' --preview-window 'right:60%'
      else
        fzf "$@" --preview 'git diff --color=always {}' --preview-window 'right:60%'
      fi
      ;;
    unalias) _fzf_compgen_unalias "$@" ;;
    systemctl)
      fzf "$@" --preview 'systemctl status {1} --no-pager 2>/dev/null || print "Status unavailable"' \
        --preview-window="right:60%:wrap"
      ;;
    *)
      if command -v bat >/dev/null 2>&1; then
        local preview_cmd="if [ -f {} ]; then bat --style=numbers --color=always --line-range :500 {};"
      else
        local preview_cmd="if [ -f {} ]; then cat {};"
      fi
      if command -v tree >/dev/null 2>&1; then
        preview_cmd='tree --dirsfirst --gitignore -C -L 2 {}'
      elif command -v lsd >/dev/null 2>&1; then
        preview_cmd+=" elif [ -d {} ]; then lsd --tree --depth 2 --color always {} | head -200;"
      elif command -v eza >/dev/null 2>&1; then
        preview_cmd+=" elif [ -d {} ]; then eza --tree --level=2 --color=always {} | head -200;"
      else
        preview_cmd+=" elif [ -d {} ]; then ls -1 --color=always {};"
      fi
      preview_cmd+=" else print {}; fi"
      fzf "$@" --preview "$preview_cmd"
      ;;
  esac
}

# Interactive helpers ----------------------------------------------------------

# Add a command to shell history (bash/zsh)
_add_history() {
  # Usage: _add_history "some command"
  if [ -n "${ZSH_VERSION-}" ]; then
    print -s -- "$1"
  elif [ -n "${BASH_VERSION-}" ]; then
    history -s -- "$1"
  fi
}

# Reverse a file to stdout (macOS/Linux)
_reverse_file() {
  # Usage: _reverse_file "$file"
  if command -v tac >/dev/null 2>&1; then
    tac -- "$1"
  elif tail -r "$1" >/dev/null 2>&1; then
    tail -r -- "$1"
  else
    # Fallback: awk reverse (works but slower)
    awk '{a[NR]=$0} END {for(i=NR;i>=1;i--) print a[i]}' -- "$1"
  fi
}

# Fuzzy cd
cd_fzf() {
  local depth=0 hidden=false no_ignore=false
  local cmd dir_list preview_cmd selected_dir

  show_help() {
    echo "Usage: cd_fzf [OPTIONS]"
    echo
    echo "OPTIONS:"
    echo "  -d, --depth <N>      Max directory depth"
    echo "  -h, --hidden         Include hidden directories"
    echo "  -i, --no-ignore      Don't respect .gitignore (fd only)"
    echo "  help, --help         Show help"
  }

  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"; return 1
  fi

  if command -v tree >/dev/null 2>&1; then
    preview_cmd='tree --dirsfirst --gitignore -C -L 2 {}'
  elif command -v lsd >/dev/null 2>&1; then
    preview_cmd='lsd --tree --depth 2 --color always --group-directories-first {}'
  elif command -v eza >/dev/null 2>&1; then
    preview_cmd='eza --tree --level=2 --color=always --group-directories-first --git-ignore {}'
  else
    preview_cmd='ls -la --color=always {}'
  fi

  while [ $# -gt 0 ]; do
    case "$1" in
      -d|--depth)     depth=${2-0}; shift 2 ;;
      -h|--hidden)    hidden=true; shift ;;
      -i|--no-ignore) no_ignore=true; shift ;;
      help|--help)    show_help; return 0 ;;
      --)             shift; break ;;
      *)              break ;;
    esac
  done

  local _ignore=(
    .git node_modules vendor
    __pycache__ .venv venv .mypy_cache
    target dist build
    .cache .yarn
  )

  if command -v fd >/dev/null 2>&1; then
    cmd="fd -t d"
    for _dir in "${_ignore[@]}"; do cmd="$cmd --exclude $_dir"; done
    [[ "$hidden" == true ]] && cmd="$cmd --hidden"
    [[ "$depth" -ne 0 ]] 2>/dev/null && cmd="$cmd -d $depth"
    [[ "$no_ignore" == true ]] && cmd="$cmd --no-ignore"
    dir_list=$(eval "$cmd" 2>/dev/null)
  else
    local find_args=()
    [[ "$depth" -ne 0 ]] 2>/dev/null && find_args+=(-maxdepth "$depth")
    [[ "$hidden" != true ]] && find_args+=('!' -path '*/.*')
    for _dir in "${_ignore[@]}"; do find_args+=('!' -path "*/$_dir/*" '!' -name "$_dir"); done
    dir_list=$(find . "${find_args[@]}" -type d 2>/dev/null)
  fi
  unset _dir _ignore

  [ -z "$dir_list" ] && { echo "No directories found."; return 1; }

  selected_dir=$(
    printf "%s\n" "$dir_list" \
      | fzf --prompt='cd: ' \
            --preview="$preview_cmd" \
            --preview-window='top:80%:border-bottom' \
      | tr -d '\n'
  )
  [ -z "$selected_dir" ] && return 0
  cd -- "$selected_dir" || return 1
}
alias cdf="cd_fzf"

# Fuzzy alias picker — copy or execute
alias_fzf() {
  local flag=${1-} selected_alias preview_cmd

  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"; return 1
  fi

  if command -v bat >/dev/null 2>&1; then
    preview_cmd='echo {} | bat -l zsh --style=plain --color=always'
  else
    preview_cmd='echo {}'
  fi

  selected_alias=$(
    alias \
      | fzf --prompt='Alias: ' \
            --preview="$preview_cmd" \
            --preview-window='top:3:wrap' \
      | sed -E 's/=.*$//' \
      | tr -d '\n'
  )
  [ -z "$selected_alias" ] && return 0

  case "$flag" in
    -e|--execute)
      eval "$selected_alias"
      _add_history "$selected_alias"
      ;;
    *)
      if ! printf "%s" "$selected_alias" | copy; then
        echo "$selected_alias"
        echo "(clipboard utility not found)"
        return 1
      fi
      ;;
  esac
}
alias af="alias_fzf"

# Fuzzy history picker — copy or execute
history_fzf() {
  local mode="print" arg selected_command preview_cmd

  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"; return 1
  fi

  if [ -z "${HISTFILE-}" ] || [ ! -f "$HISTFILE" ]; then
    echo "HISTFILE is not set or not found."; return 1
  fi

  if command -v bat >/dev/null 2>&1; then
    preview_cmd='echo {} | bat -l zsh --style=plain --color=always'
  else
    preview_cmd='echo {}'
  fi

  for arg in "$@"; do
    case "$arg" in
      -e|--execute) mode="execute" ;;
      -c|--copy)    mode="copy" ;;
      -d|--delete)  mode="delete" ;;
      -p|--print)   mode="print" ;;
      -h|--help)    echo "Usage: histf [-p|--print] [-e|--execute] [-c|--copy] [-d|--delete]"; return 0 ;;
      *)            echo "Unknown flag: $arg"; return 1 ;;
    esac
  done

  if [ "$mode" = "delete" ]; then
    local selected line
    local -a all_lines kept_lines
    local -A drop

    selected=$(
      _reverse_file "$HISTFILE" \
        | fzf --multi \
              --prompt='Delete (Tab to mark): ' \
              --preview="$preview_cmd" \
              --preview-window='top:3:wrap'
    )
    [ -z "$selected" ] && return 0

    local -a removed_lines
    all_lines=( "${(@f)$(<$HISTFILE)}" )
    while IFS= read -r line; do
      drop[$line]=1
    done <<< "$selected"
    for line in "${all_lines[@]}"; do
      if [[ -n ${drop[$line]} ]]; then
        removed_lines+=( "$line" )
      else
        kept_lines+=( "$line" )
      fi
    done

    print -rl -- "${kept_lines[@]}" > "$HISTFILE"
    chmod 600 "$HISTFILE"
    fc -p "$HISTFILE"
    if (( ${#removed_lines} == 1 )); then
      echo "removed: ${removed_lines[1]}"
    else
      echo "removed ${#removed_lines} lines"
    fi
    return 0
  fi

  selected_command=$(
    _reverse_file "$HISTFILE" \
      | fzf --prompt='History: ' \
            --preview="$preview_cmd" \
            --preview-window='top:3:wrap' \
      | tr -d '\n'
  )
  [ -z "$selected_command" ] && return 0

  if [ "$mode" = "execute" ]; then
    eval "$selected_command"
  elif [ "$mode" = "copy" ]; then
    if ! printf "%s" "$selected_command" | copy; then
      echo "$selected_command"
      echo "(clipboard utility not found)"
      return 1
    fi
  else
    print -r -- "$selected_command"
  fi
}
alias histf="history_fzf"

# Fuzzy git picker
git_fzf() {
  local action="checkout" flag="-p" graph=false selected_branch base_branch current_branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  show_help() {
    echo "Usage: git_fzf [OPTIONS]"
    echo
    echo "OPTIONS:"
    echo "  -c, --checkout      Checkout a branch (default)"
    echo "  -d, --delete        Delete a branch"
    echo "  -r, --remote        Operate on remote branches"
    echo "  -m, --merge         Merge selected branch into current"
    echo "  -p, --pull          Pull after checkout"
    echo "  -s, --stash         Stash before switching"
    echo "  -n, --new-branch    Create and checkout a new branch"
    echo "  -g, --graph         Show graph in branch preview"
    echo "  -D, --diff          Diff selected branch against current"
    echo "  -S, --show          Show latest commit on selected branch"
    echo "  -l, --list          List branches"
    echo "  -h, --help          Show this help"
  }

  while [[ $# -gt 0 ]]; do
    case $1 in
      -c|--checkout)   action="checkout";   shift ;;
      -d|--delete)     action="delete";     shift ;;
      -D|--diff)       action="diff";       shift ;;
      -l|--list)       action="list";       shift ;;
      -m|--merge)      action="merge";      shift ;;
      -n|--new-branch) action="new-branch"; shift ;;
      -p|--pull)       action="pull";       shift ;;
      -g|--graph)      graph=true;          shift ;;
      -r|--remote)     flag="-r";           shift ;;
      -s|--stash)      action="stash";      shift ;;
      -S|--show)       action="show";       shift ;;
      -h|--help)       show_help; return 0 ;;
      *) break ;;
    esac
  done

  confirm_deletion() {
    echo -n "Are you sure you want to delete '$1'? [y/N] "
    read -r confirmation
    case "$confirmation" in
      [yY]) return 0 ;;
      *) echo "Aborted."; return 1 ;;
    esac
  }

  check_protected_branch_for_delete() {
    if [[ "$1" == "master" || "$1" == "main" ]]; then
      echo "Cannot delete the protected branch '$1'."
      return 1
    fi
  }

  switch_to_safe_branch() {
    if [[ "$current_branch" == "$1" ]]; then
      if git show-ref --verify --quiet refs/heads/main; then
        echo "Switching to main before deletion."
        git checkout main
      elif git show-ref --verify --quiet refs/heads/master; then
        echo "Switching to master before deletion."
        git checkout master
      else
        echo "No main or master branch to switch to."
        return 1
      fi
    fi
  }

  local branch_preview="git log --color=always --date=format:'%Y-%m-%d %H:%M' --format='%C(green)%h%C(reset) - %C(blue)%ad %C(magenta)%an %C(reset)%s%C(yellow)%d'"
  [[ "$graph" == true ]] && branch_preview+=" --graph"
  branch_preview+=" {}"
  local fzf_multi=()
  [[ "$action" == "delete" ]] && fzf_multi=(--multi --header='TAB to select multiple')

  if [[ $flag == "-r" ]]; then
    selected_branch=$(
      git branch -r --sort=-committerdate --format='%(refname:short)' \
        | fzf --prompt='remote branch: ' \
              "${fzf_multi[@]}" \
              --preview="$branch_preview" \
              --preview-window='top:70%:border-bottom' \
        | tr -d '[:blank:]'
    )
    [[ -z "$selected_branch" ]] && return 0
    case "$action" in
      delete)
        echo "Selected for deletion:"
        while IFS= read -r b; do
          printf "  %s\n" "${b#origin/}"
        done <<< "$selected_branch"
        echo
        echo -n "Are you sure? [y/N] "
        read -r confirmation
        case "$confirmation" in
          [yY])
            while IFS= read -r b; do
              git push origin --delete "${b#origin/}"
            done <<< "$selected_branch"
            ;;
          *) echo "Aborted."; return 0 ;;
        esac
        ;;
      diff)       git diff "$current_branch"..."$selected_branch" ;;
      show)       git show "$selected_branch" ;;
      list)       echo "$selected_branch" ;;
      merge)      git merge "$selected_branch" ;;
      pull)       base_branch=${selected_branch#origin/}; git checkout "$base_branch" && git pull ;;
      new-branch) read -rp "enter new branch name: " new_branch_name; git checkout -b "$new_branch_name" ;;
      *)          base_branch=${selected_branch#origin/}; git checkout -b "$base_branch" "$selected_branch" ;;
    esac
  else
    selected_branch=$(
      git branch --sort=-committerdate --format='%(refname:short)' \
        | fzf --prompt='branch: ' \
              "${fzf_multi[@]}" \
              --preview="$branch_preview" \
              --preview-window='top:80%:border-bottom' \
        | tr -d '[:blank:]'
    )
    [[ -z "$selected_branch" ]] && return 0
    case "$action" in
      delete)
        local branches_to_delete=()
        while IFS= read -r b; do
          check_protected_branch_for_delete "$b" || continue
          branches_to_delete+=("$b")
        done <<< "$selected_branch"
        [[ ${#branches_to_delete[@]} -eq 0 ]] && return 0
        echo "Selected for deletion:"
        printf "  %s\n" "${branches_to_delete[@]}"
        echo
        echo -n "Are you sure? [y/N] "
        read -r confirmation
        case "$confirmation" in
          [yY])
            for b in "${branches_to_delete[@]}"; do
              switch_to_safe_branch "$b"
              git branch -D "$b"
            done
            ;;
          *) echo "Aborted."; return 0 ;;
        esac
        ;;
      diff)       git diff "$current_branch"..."$selected_branch" ;;
      show)       git show "$selected_branch" ;;
      merge)      git merge "$selected_branch" ;;
      list)       echo "$selected_branch" ;;
      pull)       git checkout "$selected_branch" && git pull ;;
      stash)      git stash && git checkout "$selected_branch" ;;
      new-branch) read -rp "Enter new branch name: " new_branch_name; git checkout -b "$new_branch_name" ;;
      *)          git checkout "$selected_branch" ;;
    esac
  fi
}
alias gf="git_fzf"

# Fuzzy process killer
kill_fzf() {
  local signal="TERM" selected pids

  show_help() {
    echo "Usage: kill_fzf [OPTIONS]"
    echo
    echo "OPTIONS:"
    echo "  -9, --force    Send SIGKILL instead of SIGTERM"
    echo "  -h, --help     Show help"
  }

  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"; return 1
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -9|--force) signal="KILL"; shift ;;
      -h|--help)  show_help; return 0 ;;
      *) break ;;
    esac
  done

  selected=$(
    {
      ps -eo pid,user,pcpu,pmem,comm --no-headers 2>/dev/null \
        || ps -eo pid,user,pcpu,pmem,comm 2>/dev/null | tail -n +2
    } | fzf --multi \
            --prompt='Kill process: ' \
            --header='TAB to select multiple' \
            --preview='ps -fp {1} 2>/dev/null' \
            --preview-window='top:4:wrap'
  )

  [ -z "$selected" ] && return 0

  pids=$(printf "%s\n" "$selected" | awk '{print $1}' | tr '\n' ' ')
  echo "Sending SIG${signal} to PID(s): $pids"
  # shellcheck disable=SC2086
  kill -"$signal" $pids
}
alias kf="kill_fzf"

# Fuzzy remove
rm_fzf() {
  local recursive=false force=false include_dirs=false
  local cmd entries dir_preview file_preview preview_cmd selected entry

  show_help() {
    echo "Usage: rm_fzf [OPTIONS]"
    echo
    echo "OPTIONS:"
    echo "  -d, --dirs       Include directories"
    echo "  -r, --recursive  Remove directories recursively (implies -d)"
    echo "  -f, --force      Skip confirmation prompt"
    echo "  -h, --help       Show help"
  }

  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"; return 1
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -d|--dirs)      include_dirs=true; shift ;;
      -r|--recursive) recursive=true; include_dirs=true; shift ;;
      -f|--force)     force=true; shift ;;
      -h|--help)      show_help; return 0 ;;
      *) break ;;
    esac
  done

  if command -v fd >/dev/null 2>&1; then
    cmd="fd --color always --exclude .git"
    [[ "$include_dirs" == true ]] && cmd="$cmd --type f --type d" || cmd="$cmd --type f"
    entries=$(eval "$cmd" 2>/dev/null)
  else
    if [[ "$include_dirs" == true ]]; then
      entries=$(find . -mindepth 1 ! -path './.git/*' 2>/dev/null)
    else
      entries=$(find . -type f ! -path './.git/*' 2>/dev/null)
    fi
  fi

  [ -z "$entries" ] && { echo "No files found."; return 1; }

  if command -v tree >/dev/null 2>&1; then
    preview_cmd='tree --dirsfirst --gitignore -C -L 2 {}'
  elif command -v lsd >/dev/null 2>&1; then
    dir_preview='lsd --tree --depth 2 --color always --group-dirs first {}'
  elif command -v eza >/dev/null 2>&1; then
    dir_preview='eza --tree --level=2 --color=always --group-directories-first {}'
  else
    dir_preview='ls -la --color=always {}'
  fi

  if command -v bat >/dev/null 2>&1; then
    file_preview='bat --style=numbers --color=always --line-range :200 {}'
  else
    file_preview='cat {}'
  fi

  preview_cmd="if [ -d {} ]; then $dir_preview; else $file_preview; fi"

  selected=$(
    printf "%s\n" "$entries" \
      | fzf --multi \
            --prompt='Remove: ' \
            --header='TAB to select multiple' \
            --preview="$preview_cmd" \
            --preview-window='top:80%:border-bottom'
  )

  [ -z "$selected" ] && return 0

  echo "Selected for removal:"
  printf "  %s\n" "${(f)selected}"
  echo

  if [[ "$force" == false ]]; then
    echo -n "Confirm removal? [y/N] "
    read -r confirmation
    case "$confirmation" in
      [yY]) ;;
      *) echo "Aborted."; return 0 ;;
    esac
  fi

  local rm_args=(-i)
  [[ "$recursive" == true ]] && rm_args=(-r)
  [[ "$force" == true ]] && rm_args+=(-f)

  while IFS= read -r entry; do
    rm "${rm_args[@]}" -- "$entry"
  done <<< "$selected"
}
alias rmf="rm_fzf"

# ── Shell integration ─────────────────────────────────────────────────────────

if command -v fzf >/dev/null 2>&1; then
  if fzf --zsh >/dev/null 2>&1; then
    # fzf >= 0.48: built-in portable integration
    source <(fzf --zsh)
  else
    # Fallback: check common install paths (Linux distros + macOS Homebrew)
    for _fzf_dir in \
      /usr/share/fzf \
      /usr/share/doc/fzf/examples \
      /usr/share/fzf/shell \
      /opt/homebrew/opt/fzf/shell \
      /usr/local/opt/fzf/shell \
      "$HOME/.fzf/shell"
    do
      [[ -f "$_fzf_dir/completion.zsh"   ]] && source "$_fzf_dir/completion.zsh"
      [[ -f "$_fzf_dir/key-bindings.zsh" ]] && source "$_fzf_dir/key-bindings.zsh"
      [[ -d "$_fzf_dir" ]] && break
    done
    unset _fzf_dir
  fi
fi

unset _add_history
unset _reverse_file
