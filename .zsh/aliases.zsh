#!/usr/local/bin/zsh

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Unix
alias c="clear"

alias ls="lsd"
alias lsa="ls -A"         # Show hidden files
alias lsl="ls -l"         # Show on new line
alias lsla="ls -lA"       # Show hidden files with permissions
alias lst="ls --tree"     # Recurse into directories and present the result as a tree.

alias cp="cp -iv"
alias mv="mv -iv"

alias path='echo -e ${PATH//:/\\n}'     # Show path on new line
alias cpwd="pwd | pbcopy"  # Copy pwd to clipboard

# Grep
alias grep="grep --color=auto"
alias rgrep="rg"

# Term mySQL
alias mysql="mysql -u root -p"

# Homebrew
alias brewup="brew outdated; brew update; brew upgrade; brew cleanup --prune=all; brew doctor"
alias caskup="brew cask outdated; brew cask upgrade"
alias bl="brew list"
alias bi="brew install"
alias bs="brew search"
alias bu="brew uninstall"
alias bd="brew deps --tree --installed"

# Git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gaa="ga ."
alias gc="git commit"
alias gb="git branch"
alias gco="git checkout"
alias gst="git stash"
alias gsta="gst apply"
alias gm="git merge"
alias glog="git log --pretty=format:'%C(green)%h%C(reset) - %C(blue)%ad %C(reset)%s%C(magenta) <%an>%C(yellow)%d' --decorate --date=relative --abbrev-commit --no-merges"
alias gd="git diff"
alias gpush="git push"
alias gpull="git pull"
alias gcom="gco master && gpull"
alias gcos="gco staging && gpull"

# Formulae
alias rm="trash"
alias fortunecookie='echo "$(cowthink -f kitty $(fortune))"'

# Python
alias python="python3.11"
alias py="python3.11"
alias pip="pip3"

# Ruby
alias gemup="sudo gem update --system; sudo gem update; sudo gem cleanup"

# MacOS
alias systemup="softwareupdate --all --install --force"
alias usebash="chsh -s $(which bash)"
alias usezsh="chsh -s $(which zsh)"

# Vim
alias vim="vim"
alias vimrc="vim $HOME/.vimrc"

# Zsh
alias zshrc="$EDITOR ~/.dotfiles/.zsh/"
alias src="source $HOME/.zshrc"

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
alias bdg='cd ~/javatools && open badge-utility-1.0.jar'
alias badge='cd ~/javatools && open badge-utility-1.0.jar'
alias emc='cd ~/javatools && open emcit-2.0.jar'
alias mut='cd ~/javatools && java -jar memberupload-1.0.jar'
# Group Portal
alias groupportal="cd ~/mcisemi/group-portal && gpull && nvm use 18.16.0"
# Member Lookup
alias memberlookup="cd ~/mcisemi/memberlookup && gpull && nvm use 18.16.0"
# Cronies
alias cronies="cd ~/mcisemi/cloud-cronies && gpull && nvm use 10.16.2"
alias getcronjobsactive="cronies && kubectl -n mci-cronies-prod get cronjobs"
alias getcronjobpods="cronies && kubectl -n mci-cronies-prod get pods"
alias getcronjobs="cronies && kubectl -n mci-cronies-prod get cronjobs"
alias deletecronjob="kubectl -n mci-cronies-prod delete cronjob XXX"
# Reg5
alias reg="cd ~/mcisemi/reg5 && nvm use 10.16.2"
alias reg5="cd ~/mcisemi/reg5 && nvm use 10.16.2 && gpull"
alias reg52="cd ~/mcisemi/reg5two && nvm use 10.16.2 && gpull"
alias reg2="cd ~/mcisemi/reg5two && nvm use 10.16.2 && gpull"
alias whippets="cd ~/mcisemi/code-whippets && gpull"
alias init="reg && npm run initial-setup"
alias const="reg && npm run generate-consts-production"
alias consts="reg && npm run generate-consts-production"
alias constants="reg && npm run generate-consts-production"
alias dev="reg && npm run dev-staging"
alias dev-stg="reg && npm run dev-staging"
alias dev-staging="reg && npm run dev-staging"
alias build-dev="reg && npm run build-dev"
alias clean="reg && npm run clean-all"
alias redisstart="brew services start redis"
alias redisstop="brew services stop redis"
alias redisrestart="brew services restart redis"
alias azlogin='az login && az aks get-credentials -g apps01-prod-eastus-aks-rg -n apps01-prod-eastus-aks && az acr login --name mcisemi001'
# Room logic commands
alias rl="cd ~/mcisemi/roomlogic/roomlogic-site-resources/sites && nvm use 7.10.1 && gpull"
alias gp="gulp azpublish"
# Alameda
alias alameda="cd ~/mcisemi/alameda/www.mcisemi.com && gpull"
alias alamedalibs="cd ~/mcisemi/alameda/www.mcisemi.com/libs"
# Metric
alias metric="cd ~/mcisemi/metric && gpull"
# local cfdev environment
alias cfstart="cd ~/mcisemi/docker-stacks/cfdev && docker-compose down && docker-compose up -d && docker-compose start"
alias cfstop="cd ~/mcisemi/docker-stacks/cfdev && docker-compose down && docker-compose stop"
# Confirmation Tool
alias ctm="docker run --rm --init -p 3001:3000 -e DB_HOST=10.128.2.5 -e DB_PORT=1521 -e DB_NAME=jade.prod.db.mcisemi.cloud mcisemi001.azurecr.io/confirmation-tool"
alias cts="docker run --rm --init -p 3001:3000 -e DB_HOST=10.128.2.5 -e DB_PORT=1521 -e DB_NAME=jadestg.stage.db.mcisemi.cloud mcisemi001.azurecr.io/confirmation-tool"
alias sql="cd ~/sqlcsv && nvm use 16.13.1 && node index.js"
