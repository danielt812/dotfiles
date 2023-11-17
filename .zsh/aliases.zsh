#!/usr/local/bin/zsh

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

alias path='echo -e ${PATH//:/\\n}'     # Show path on new line
alias cpwd="pwd | pbcopy"               # Copy pwd to clipboard

# Term mySQL
alias mysql="mysql -u root -p"

# Homebrew
alias brewup="brew outdated; brew update; brew upgrade; brew cleanup --prune=all; brew doctor"
alias bl="brew list"
alias bi="brew install"
alias bs="brew search"
alias bu="brew uninstall"
alias bd="brew deps --formula --tree --installed"

# Git
alias g="git"
alias ga="git add"
alias gaa="ga ."
alias gb="g branch"
alias gc="g commit"
alias gco="g checkout"
alias gcp="g cherry-pick"
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

# Lazygit
alias lg="lazygit"

# Tmux
alias tm="tmux"

# Lazygit
alias lg="lazygit"

# Kubernetes
alias k="kubectl"

# Docker
alias d="docker"

# Formulae
alias rm="trash"

# Python
alias python="python3.11"
alias py="python3.11"
alias pip="pip3"

# MacOS
alias sysup="softwareupdate --all --install --force"
alias usebash="chsh -s $(which bash)"
alias usezsh="chsh -s $(which zsh)"

# Vim
alias vimrc="vim $HOME/.vimrc"

# Nvim
alias nv="nvim"

# Tmux
alias tm="tmux"

# Zsh
alias src="source $HOME/.zshrc"

alias dotfiles="$EDITOR $DOTFILES"

# Show dot files in finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

# Add quit option to finder
alias quitFinderOn="defaults write com.apple.finder QuitMenuItem -bool true; killall Finder"
alias quitFinderOff="defaults write com.apple.finder QuitMenuItem -bool false; killall Finder"

# Flush dns cache
alias flushDNS="dscacheutil -flushcache"

# Weather
alias weather="curl wttr.in"
