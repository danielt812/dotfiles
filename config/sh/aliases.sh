#!/bin/bash

# Navigation -------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Unix basics ------------------------------------------------------------------
alias c='clear'

# grep --color=auto
if grep --color=auto "" </dev/null >/dev/null 2>&1; then
  alias grep='grep --color=auto'
fi

# cp/mv interactive
alias cp='cp -i'
alias mv='mv -i'

# optionally add -v only where supported
if cp -v /dev/null /dev/null >/dev/null 2>&1; then
  alias cp='cp -iv'
fi
if mv -v /dev/null /dev/null >/dev/null 2>&1; then
  alias mv='mv -iv'
fi

# Show PATH one entry per line (bash/zsh)
alias path='printf "%s\n" "${PATH//:/\n}"'

# ls / lsd / eza ---------------------------------------------------------------
if command -v lsd >/dev/null 2>&1; then
  alias ls='lsd --group-directories-first'
  alias lsa='lsd -A --group-directories-first'
  alias lsl='lsd -l --group-directories-first'
  alias lsla='lsd -lA --group-directories-first'
  alias lst='lsd --tree --group-directories-first'
  alias lsat='lsd -A --tree --group-directories-first --depth=2'
elif command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias lsa='eza -a'
  alias lsl='eza -l'
  alias lsla='eza -la'
  alias lst='eza --tree'
  alias lsat='eza -a --tree'
else
  alias ls='ls'
  alias lsa='ls -A'
  alias lsl='ls -l'
  alias lsla='ls -lA'
  # No lst/lsat without lsd/eza
fi


# MySQL ------------------------------------------------------------------------
if command -v mysql >/dev/null 2>&1; then
  alias mysql='mysql -u root -p'
fi

# Homebrew ---------------------------------------------------------------------
if command -v brew >/dev/null 2>&1; then
  alias brewup='brew outdated; brew update; brew upgrade; brew cleanup --prune=all; brew doctor'
  alias brewdeps='brew deps --formula --tree --installed'
fi

# Git --------------------------------------------------------------------------
if command -v git >/dev/null 2>&1; then
  alias g='git'
  alias ga='git add'
  alias gaa='git add .'
  alias gb='git branch'
  alias gc='git commit'
  alias gco='git checkout'
  alias gd='git diff'
  alias gm='git merge'
  alias gpull='git pull'
  alias gpush='git push'
  alias gr='git restore'
  alias gs='git status'
  alias gst='git stash'
  alias gsta='git stash apply'
  alias gstp='git stash pop'
  alias glog="git log --pretty=format:'%C(green)%h%C(reset) - %C(blue)%ad %C(reset)%s%C(magenta) <%an>%C(yellow)%d' --decorate --date=local --abbrev-commit --no-merges"
fi

# Lazygit / Lazydocker ---------------------------------------------------------
if command -v lazygit >/dev/null 2>&1; then
  alias lzg='lazygit'
fi

if command -v lazydocker >/dev/null 2>&1; then
  alias lzd='lazydocker'
fi

# Editors / terminal tools -----------------------------------------------------
if command -v nvim >/dev/null 2>&1; then
  alias nv='nvim'
fi

if command -v tmux >/dev/null 2>&1; then
  alias tm='tmux'
fi

# Docker / Kubernetes ----------------------------------------------------------
if command -v docker >/dev/null 2>&1; then
  alias d='docker'
fi

if command -v kubectl >/dev/null 2>&1; then
  alias k='kubectl'
fi

# Python -----------------------------------------------------------------------
if command -v pip3 >/dev/null 2>&1; then
  alias pip='pip3'
fi

if command -v python3.13 >/dev/null 2>&1; then
  alias py='python3.13'
  alias python='python3.13'
elif command -v python3 >/dev/null 2>&1; then
  alias py='python3'
  alias python='python3'
fi

# Login shell switching --------------------------------------------------------
if command -v chsh >/dev/null 2>&1; then
  if command -v bash >/dev/null 2>&1; then
    alias usebash='chsh -s "$(command -v bash)"'
  fi
  if command -v zsh >/dev/null 2>&1; then
    alias usezsh='chsh -s "$(command -v zsh)"'
  fi
fi

# Vimrc convenience ------------------------------------------------------------
if command -v vim >/dev/null 2>&1; then
  if [ -e "$HOME/.vimrc" ]; then
    alias vimrc='vim "$HOME/.vimrc"'
  fi
fi

# Shell reload -----------------------------------------------------------------
if [ -n "${ZSH_VERSION-}" ]; then
  alias src='source "$HOME/.zshrc"'
elif [ -n "${BASH_VERSION-}" ]; then
  alias src='source "$HOME/.bashrc"'
fi

# Dotfiles shortcut ------------------------------------------------------------
if [ -n "${EDITOR-}" ] && [ -n "${DOTFILES-}" ]; then
  alias dotfiles='"$EDITOR" "$DOTFILES"'
fi

# Weather ----------------------------------------------------------------------
if command -v curl >/dev/null 2>&1; then
  alias weather='curl wttr.in'
fi
