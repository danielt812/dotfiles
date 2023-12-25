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

# Formulae
alias rm="trash"

# Python
alias pip="pip3"
alias py="python3.11"
alias python="python3.11"

# MacOS
alias sysup="softwareupdate --all --install --force"
alias usebash="chsh -s $(which bash)"
alias usezsh="chsh -s $(which zsh)"

# Vim
alias vimrc="vim $HOME/.vimrc"

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

# MCI
alias mci="cd ~/mcisemi"
alias sshadd="ssh-add ~/.ssh/id_rsa"
alias hotel="cd ~/javatools && java -jar HotelImageSetup.jar"
alias bdg="cd ~/javatools && open badge-utility-1.0.jar"
alias badge="cd ~/javatools && open badge-utility-1.0.jar"
alias emc="cd ~/javatools && open emcit-2.0.jar"
alias mut="cd ~/javatools && java -jar memberupload-1.0.jar"

# Group Portal
alias groupportal="cd ~/mcisemi/group-portal && nvm use 20.10.0 && gpull"
# Member Lookup
alias memberlookup="cd ~/mcisemi/memberlookup && nvm use 20.10.0 && gpull"
# Cvent Snippets
alias css="cd ~/mcisemi/code-snippet-server && nvm use 20.10.0 && gpull"
alias whippets="cd ~/mcisemi/code-whippets && gpull"
# Cronies
alias cronies="cd ~/mcisemi/cloud-cronies && nvm use 20.10.0 && gpull"
alias getcronjobpods="k -n mci-cronies-prod get pods"
alias getcronjobs="k -n mci-cronies-prod get cronjobs"
alias deletecronjob="k -n mci-cronies-prod delete cronjob"
alias azlogin="az login && az aks get-credentials -g apps01-prod-eastus-aks-rg -n apps01-prod-eastus-aks && az acr login --name mcisemi001"
# Alameda
alias mcisemi="cd ~/mcisemi/alameda/www.mcisemi.com"
alias mcievents="cd ~/mcisemi/alameda/www.mcievents.com"
# Port redirection
alias mciportredirect="sudo -b socat TCP4-LISTEN:80,reuseaddr,fork,su=nobody TCP4:localhost:8585"
# Local cfdev environment
alias cfstart="cd ~/mcisemi/docker-stacks/cfdev && docker-compose down && docker-compose up -d && docker-compose start"
alias cfstop="cd ~/mcisemi/docker-stacks/cfdev && docker-compose down && docker-compose stop"
# Confirmation Tool
alias ctm="docker run --rm --init -p 3001:3000 -e DB_HOST=10.128.2.5 -e DB_PORT=1521 -e DB_NAME=jade.prod.db.mcisemi.cloud mcisemi001.azurecr.io/confirmation-tool"
alias cts="docker run --rm --init -p 3001:3000 -e DB_HOST=10.128.2.5 -e DB_PORT=1521 -e DB_NAME=jadestg.stage.db.mcisemi.cloud mcisemi001.azurecr.io/confirmation-tool"
alias sql="cd ~/sqlcsv && node index.js"
