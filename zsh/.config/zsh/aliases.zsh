#!/bin/bash

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Unix
alias c="clear"
alias grep="grep --color=auto"

# Ls Deluxe
alias ls="lsd"
alias lsa="ls -A"
alias lsl="ls -l"
alias lsla="ls -lA"
alias lst="ls --tree"
alias lsat="ls -A --tree"

alias cp="cp -iv"
alias mv="mv -iv"

# Git
alias g="git"
alias ga="g add"
alias gaa="ga ."
alias gb="g branch"
alias gc="g commit"
alias gco="g checkout"
alias gd="g diff"
alias glog="g log --pretty=format:'%C(green)%h%C(reset) - %C(blue)%ad %C(reset)%s%C(magenta) <%an>%C(yellow)%d' --decorate --date=local --abbrev-commit --no-merges"
alias gm="g merge"
alias gpull="g pull"
alias gpush="g push"
alias gr="g restore"
alias gs="g status"
alias gst="g stash"
alias gsta="gst apply"
alias gstp="gst pop"
alias gcom="gco master && gpull"
alias gcos="gco staging && gpull"

# Lazygit
alias lg="lazygit"

# Nvim
alias nv="nvim"

# Tmux
alias tm="tmux"

# Kubernetes
alias k="kubectl"

# Docker
alias d="docker"

alias usebash="chsh -s $(which bash)"
alias usezsh="chsh -s $(which zsh)"

# Zsh
alias src="source $HOME/.zshrc"

alias dotfiles="$EDITOR $DOTFILES"

# Weather
alias weather="curl wttr.in"
