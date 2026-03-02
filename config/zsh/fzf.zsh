# ── Completion hooks ──────────────────────────────────────────────────────────

# Override directory discovery for ** completions — uses fd when available
_fzf_compgen_dir() {
  local base_dir="$1"
  if (( $+commands[fd] )); then
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
  if (( $+commands[bat] )); then
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
      if (( $+commands[eza] )); then
        fzf "$@" --preview 'eza --tree --level=2 --color=always --group-directories-first {} | head -200'
      elif (( $+commands[tree] )); then
        fzf "$@" --preview 'tree -C {} | head -200'
      else
        fzf "$@" --preview 'ls -1 --color=always {} | head -200'
      fi
      ;;
    vim|nvim|vi|nano|code|cat|bat|less|more)
      if (( $+commands[bat] )); then
        fzf "$@" --preview 'bat --style=numbers --color=always --line-range :500 {}' \
          --preview-window 'right:60%:border-left'
      else
        fzf "$@" --preview 'cat {}'
      fi
      ;;
    export|unset|printenv)
      fzf "$@" --preview "printenv {}" --preview-window="bottom:3:wrap"
      ;;
    kill|pkill)
      fzf "$@" --preview 'ps -fp {1} 2>/dev/null || print "Process not found"' \
        --preview-window="bottom:20%:wrap"
      ;;
    ssh|telnet)
      fzf "$@" --preview 'cat ~/.ssh/config 2>/dev/null | grep -A 4 "Host {}" || print "System Host: {}"' \
        --preview-window="bottom:20%:wrap"
      ;;
    git)
      if (( $+commands[delta] )); then
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
      if (( $+commands[bat] )); then
        local preview_cmd="if [ -f {} ]; then bat --style=numbers --color=always --line-range :500 {};"
      else
        local preview_cmd="if [ -f {} ]; then cat {};"
      fi
      if (( $+commands[eza] )); then
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

  if (( $+commands[eza] )); then
    preview_cmd='eza --tree --level=2 --color=always --group-directories-first --git-ignore {}'
  elif (( $+commands[tree] )); then
    preview_cmd='tree -C -L 2 {} | head -200'
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

  if (( $+commands[fd] )); then
    cmd="fd -t d --exclude .git --exclude node_modules"
    [[ "$hidden" == true ]] && cmd="$cmd --hidden"
    [[ "$depth" -ne 0 ]] 2>/dev/null && cmd="$cmd -d $depth"
    [[ "$no_ignore" == true ]] && cmd="$cmd --no-ignore"
    dir_list=$(eval "$cmd" 2>/dev/null)
  else
    local find_args=()
    [[ "$depth" -ne 0 ]] 2>/dev/null && find_args+=(-maxdepth "$depth")
    [[ "$hidden" != true ]] && find_args+=('!' -path '*/.*')
    dir_list=$(find . "${find_args[@]}" -type d 2>/dev/null)
  fi

  [ -z "$dir_list" ] && { echo "No directories found."; return 1; }

  selected_dir=$(
    printf "%s\n" "$dir_list" \
      | fzf --prompt='cd: ' \
            --preview="$preview_cmd" \
            --preview-window='right:50%:border-left' \
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

  if (( $+commands[bat] )); then
    preview_cmd='echo {} | bat -l zsh --style=plain --color=always'
  else
    preview_cmd='echo {}'
  fi

  selected_alias=$(
    alias \
      | fzf --prompt='Alias: ' \
            --preview="$preview_cmd" \
            --preview-window='bottom:3:wrap' \
      | sed -E 's/=.*$//' \
      | tr -d '\n'
  )
  [ -z "$selected_alias" ] && return 0

  case "$flag" in
    -e|--execute)
      eval "$selected_alias"
      add_history "$selected_alias"
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
  local mode="copy" arg selected_command preview_cmd

  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"; return 1
  fi

  if [ -z "${HISTFILE-}" ] || [ ! -f "$HISTFILE" ]; then
    echo "HISTFILE is not set or not found."; return 1
  fi

  if (( $+commands[bat] )); then
    preview_cmd='echo {} | bat -l zsh --style=plain --color=always'
  else
    preview_cmd='echo {}'
  fi

  for arg in "$@"; do
    case "$arg" in
      -e|--execute) mode="execute" ;;
      -c|--copy)    mode="copy" ;;
      -h|--help)    echo "Usage: histf [-e|--execute] [-c|--copy]"; return 0 ;;
      *)            echo "Unknown flag: $arg"; return 1 ;;
    esac
  done

  selected_command=$(
    reverse_file "$HISTFILE" \
      | fzf --prompt='History: ' \
            --preview="$preview_cmd" \
            --preview-window='bottom:3:wrap' \
      | tr -d '\n'
  )
  [ -z "$selected_command" ] && return 0

  if [ "$mode" = "execute" ]; then
    eval "$selected_command"
  elif ! printf "%s" "$selected_command" | copy; then
    echo "$selected_command"
    echo "(clipboard utility not found)"
    return 1
  fi
}
alias histf="history_fzf"

# Fuzzy git branch picker
git_fzf() {
  local action="checkout" flag="-p" selected_branch base_branch current_branch
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
    echo "  -l, --list          List branches"
    echo "  -h, --help          Show this help"
  }

  while [[ $# -gt 0 ]]; do
    case $1 in
      -c|--checkout)   action="checkout";   shift ;;
      -d|--delete)     action="delete";     shift ;;
      -l|--list)       action="list";       shift ;;
      -m|--merge)      action="merge";      shift ;;
      -n|--new-branch) action="new-branch"; shift ;;
      -p|--pull)       action="pull";       shift ;;
      -r|--remote)     flag="-r";           shift ;;
      -s|--stash)      action="stash";      shift ;;
      -h|--help)       show_help; return 0 ;;
      *) break ;;
    esac
  done

  confirm_deletion() {
    echo -n "Are you sure you want to delete '$1'? [y/N] "
    read -r confirmation
    case "$confirmation" in
      [yY][eE][sS]|[yY]) return 0 ;;
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

  local branch_preview='git log --oneline --graph --color=always --decorate -15 {}'

  if [[ $flag == "-r" ]]; then
    selected_branch=$(
      git branch -r \
        | fzf --prompt='Remote branch: ' \
              --preview="$branch_preview" \
              --preview-window='right:60%:border-left' \
        | tr -d '[:blank:]'
    )
    base_branch=${selected_branch#origin/}
    [[ -z "$selected_branch" ]] && return 0
    case "$action" in
      delete)     confirm_deletion "$base_branch" && git push origin --delete "$base_branch" ;;
      list)       echo "$selected_branch" ;;
      merge)      git merge "$selected_branch" ;;
      pull)       git checkout "$base_branch" && git pull ;;
      new-branch) read -rp "Enter new branch name: " new_branch_name; git checkout -b "$new_branch_name" ;;
      *)          git checkout -b "$base_branch" "$selected_branch" ;;
    esac
  else
    selected_branch=$(
      git branch --format='%(refname:short)' \
        | fzf --prompt='Branch: ' \
              --preview="$branch_preview" \
              --preview-window='right:60%:border-left' \
        | tr -d '[:blank:]'
    )
    [[ -z "$selected_branch" ]] && return 0
    case "$action" in
      delete)
        check_protected_branch_for_delete "$selected_branch" || return 1
        switch_to_safe_branch "$selected_branch"
        confirm_deletion "$selected_branch" && git branch -D "$selected_branch"
        ;;
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
            --preview-window='bottom:4:wrap'
  )

  [ -z "$selected" ] && return 0

  pids=$(printf "%s\n" "$selected" | awk '{print $1}' | tr '\n' ' ')
  echo "Sending SIG${signal} to PID(s): $pids"
  # shellcheck disable=SC2086
  kill -"$signal" $pids
}
alias kf="kill_fzf"

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
