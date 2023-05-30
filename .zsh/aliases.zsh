#!/usr/local/bin/zsh

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias projects="cd $HOME/Projects"
alias downloads="cd $HOME/Downloads"
alias desktop="cd $HOME/Desktop"
alias documents="cd $HOME/Documents"
alias dropbox="cd $HOME/Dropbox"
alias caskroom="cd $LOCAL/Caskroom"
alias cellar="cd $LOCAL/Cellar"

# Unix
alias c="clear"
alias md="mkdir"
alias mdcd='() { md $1 && cd $_ }' # Make Directory and cd into it

alias lsa="ls -a"     # Show hidden files
alias lsl="ls -l1F"   # Show on new line
alias ll="ls -lh"     # Show symbolic links and permissions

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
alias gaa="git add ."
alias gaaa="git add -A"
alias gc="git commit"
alias gcm="git commit -m"
alias gb="git branch"
alias gbr="git branch -r"
alias gbd="git branch -d"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gclone="git clone"
alias gst="git stash"
alias gsta="git stash apply"
alias gstp="git stash pop"
alias gstl="git stash list"
alias gm="git merge"
alias gr="git reset"
alias grb="git rebase"
alias gl="git log --oneline --decorate --graph"
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
alias glga="git log --graph --oneline --all --decorate"
alias gb="git branch"
alias gs="git status"
alias gd="diff --color --color-words --abbrev"
alias gdc="git diff --cached"
alias gbl="git blame"
alias gpush="git push"
alias gpull="git pull"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gco="git checkout"

# Formulae
alias rm="trash"
alias wifi="wifi-password"
alias diff='colordiff'

# Python
alias python="python3"
alias py="python3"
alias pip="pip3"

# Ruby
alias gemup="sudo gem update --system; sudo gem update; sudo gem cleanup"

# MacOS
alias systemup="softwareupdate --all --install --force"
alias usebash="chsh -s $(which bash)"
alias usezsh="chsh -s $(which zsh)"

# Vim
alias vimrc="vim $HOME/.vimrc"

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

# Dotfiles
alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Weather
alias weather="curl wttr.in"