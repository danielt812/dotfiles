#!/bin/bash

# Navigation -------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Unix basics ------------------------------------------------------------------
alias c='clear'

# Unix -------------------------------------------------------------------------
alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias rm='rm -i'

alias mkdir='mkdir -pv'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# ls / lsd / eza ---------------------------------------------------------------
if command -v lsd >/dev/null 2>&1; then
  alias ls='lsd --group-directories-first'
  alias lsa='lsd -A --group-directories-first'
  alias lsl='lsd -l --group-directories-first'
  alias lsla='lsd -lA --group-directories-first'
  alias lst='lsd --tree --group-directories-first'
  alias lsat='lsd -A --tree --group-directories-first --depth=2'
elif command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias lsa='eza -a --group-directories-first'
  alias lsl='eza -l --group-directories-first'
  alias lsla='eza -la --group-directories-first'
  alias lst='eza --tree --group-directories-first'
  alias lsat='eza -a --tree --group-directories-first --level=2'
else
  alias ls='ls'
  alias lsa='ls -A'
  alias lsl='ls -l'
  alias lsla='ls -lA'
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

# Lazygit ----------------------------------------------------------------------
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'
# Lazydocker -------------------------------------------------------------------
command -v lazydocker >/dev/null 2>&1 && alias ld='lazydocker'
# Neovim -----------------------------------------------------------------------
command -v nvim >/dev/null 2>&1 && alias nv='nvim'
# Tmux -------------------------------------------------------------------------
command -v tmux >/dev/null 2>&1 && alias tm='tmux'
# Docker -----------------------------------------------------------------------
command -v docker >/dev/null 2>&1 && alias d='docker'
# Kubernetes -------------------------------------------------------------------
command -v kubectl >/dev/null 2>&1 && alias k='kubectl'
# Python -----------------------------------------------------------------------
command -v pip3 >/dev/null 2>&1 && alias pip='pip3'

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
