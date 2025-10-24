#!/bin/bash

cdfzf() {
  local depth=0
  local hidden=false
  local no_ignore=false
  local preview=false
  local tree=false

  show_help() {
    echo "Usage: cdf [OPTIONS]"
    echo
    echo "OPTIONS:"
    echo "  -d, --depth <N>      Specify the maximum directory depth to search"
    echo "  -h, --hidden         Include hidden directories in the search"
    echo "  -i, --no-ignore      Don't respect .gitignore files"
    echo "  -p, --preview        Show a preview of the selected directory's contents"
    echo "  -t, --tree           Show preview as a tree view (implies --preview)"
    echo "  help, --help         Show this help message and exit"
    echo
    echo "Examples:"
    echo "  cdf -d 2             Search directories up to 2 levels deep"
    echo "  cdf -p               Show a preview of each directory"
    echo "  cdf -t               Show a tree-style preview of directories"
    return 0
  }

  # Detect fd or fallback
  if command -v fd >/dev/null 2>&1; then
    fd_installed=true
  else
    fd_installed=false
  fi

  # Determine best list command
  if command -v lsd >/dev/null 2>&1; then
    list_cmd="lsd --icon=always --group-dirs=first --color=always"
  elif command -v exa >/dev/null 2>&1; then
    list_cmd="exa --icons --group-directories-first --color=always"
  elif command -v eza >/dev/null 2>&1; then
    list_cmd="eza --icons --group-directories-first --color=always"
  else
    list_cmd="ls -F --color=always"
  fi

  # Parse flags
  while [[ $# -gt 0 ]]; do
    case $1 in
    -d | --depth)
      depth="$2"
      shift 2
      ;;
    -h | --hidden)
      hidden=true
      shift
      ;;
    -i | --no-ignore)
      no_ignore=true
      shift
      ;;
    -p | --preview)
      preview=true
      shift
      ;;
    -t | --tree)
      tree=true
      preview=true
      shift
      ;;
    help | --help)
      show_help
      return 0
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
    esac
  done

  # Build fd/find command
  if [[ $fd_installed == true ]]; then
    find_command="fd -t d"
    [[ $hidden == true ]] && find_command="$find_command --hidden --exclude node_modules" || find_command="$find_command --exclude node_modules"
    [[ $depth != 0 ]] && find_command="$find_command -d $depth"
    [[ $no_ignore == true ]] && find_command="$find_command --no-ignore"
  else
    find_command="find . -type d"
    [[ $hidden == false ]] && find_command="$find_command ! -path '*/.*'"
    [[ $depth != 0 ]] && find_command="$find_command -maxdepth $depth"
    find_command=$find_command
  fi

  # Build fzf command
  fzf_command="fzf --prompt='Select Directory: '"

  if [[ $preview == true ]]; then
    if [[ $tree == true ]]; then
      # tree preview (use tree option if supported)
      if [[ $list_cmd == lsd* ]]; then
        fzf_command="$fzf_command --preview '$list_cmd --tree {} | head -n 200'"
      elif [[ $list_cmd == exa* ]]; then
        fzf_command="$fzf_command --preview '$list_cmd --tree {} | head -n 200'"
      elif command -v tree >/dev/null 2>&1; then
        fzf_command="$fzf_command --preview 'tree -C -L 2 {} | head -n 200'"
      else
        fzf_command="$fzf_command --preview '$list_cmd {} | head -n 100'"
      fi
    else
      fzf_command="$fzf_command --preview '$list_cmd {} | head -n 100'"
    fi
  fi

  # Execute search and cd
  cd "$(eval "$find_command" | eval "$fzf_command")"
}
