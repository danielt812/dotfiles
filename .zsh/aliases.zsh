#!/usr/local/bin/zsh

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Unix
alias c="clear"

alias ls="lsd --group-directories-first"
alias lst="ls --tree"     # Recurse into directories and present the result as a tree.
alias lsa="ls -A"         # Show hidden files
alias lsla="ls -lA"       # Show hidden files with permissions
alias lsl="ls -l"         # Show on new line

alias cp="cp -iv"
alias mv="mv -iv"

alias path="echo -e ${PATH//:/\\n}"     # Show path on new line
alias cpwd="pwd | tr -d "\n" | pbcopy"  # Copy pwd to clipboard

alias grep="grep --color=auto"

# Term mySQL
alias mysql="mysql -u root -p"

# Homebrew
alias brewup="brew outdated; brew update; brew upgrade; brew cleanup --prune=all; brew doctor"
alias caskup="brew cask outdated; brew cask upgrade"
alias bl="brew list"
alias blf="brew list --formula"
alias blc="brew list --cask"
alias bi="brew install"
alias bs="brew search"
alias bu="brew uninstall"
alias bd="brew deps --tree --installed"

# Git
alias gs="git status"
alias ga="git add"
alias gaa="ga ."
alias gaaa="ga -A"
alias gc="git commit"
alias gb="git branch"
alias gco="git checkout"
alias gclone="git clone"
alias gst="git stash"
alias gsta="gst apply"
alias gstp="gst pop"
alias gstl="gst list"
alias gm="git merge"
alias gr="git reset"
alias grb="git rebase"
alias gl="git log --oneline --decorate --graph"
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
alias gd="git diff --color --color-words --abbrev"
alias gdc="git diff --cached"
alias gbl="git blame"
alias gpush="git push"
alias gpull="git pull"

# Formulae
alias rm="trash"
alias wifi="wifi-password"
alias diff="colordiff"
alias cowsay="cowsay -f kitty"
alias cowthink="cowthink -f kitty"

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
alias vimrc="$EDITOR $HOME/.config/nvim"

# Zsh
alias zshrc="$EDITOR ~/.zsh/.zshrc"
alias src="source $HOME/.zshrc"

# Yarn
alias yi="yarn install"
alias ya="yarn add"
alias yr="yarn remove"
alias yga="yarn global add"
alias ygr="yarn global remove"
alias ygl="yarn global list"

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update="sudo softwareupdate -i -a; brewup; npm install npm -g; npm update -g; gemup"

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
