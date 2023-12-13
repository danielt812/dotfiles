#!/bin/bash

# Aliases
#----------------------------------------------------------------------------------
# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias projects="cd ~/Projects"
alias downloads="cd ~/Downloads"
alias desktop="cd ~/Desktop"
alias db="cd ~/Dropbox"
alias documents="cd ~/Documents"

# Unix
alias sbp="source ~/.bash_profile"
alias c="clear"
alias lsa="ls -a"
alias ls1="ls -l1F"
alias cp="cp -iv"
alias mv="mv -iv"

# Term mySQL
alias mysql="mysql -u root -p"

# Show dot files
alias showDotFiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hideDotFiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

# Add quit option to finder
alias quitFinderOn="defaults write com.apple.finder QuitMenuItem -bool true; killall Finder"
alias quitFinderOff="defaults write com.apple.finder QuitMenuItem -bool false; killall Finder"

# Flush dns cache
alias flushDNS="dscacheutil -flushcache"

# Homebrew
alias brewup="brew outdated; brew update; brew upgrade; brew cleanup; brew doctor"
alias caskup="brew cask outdated; brew cask upgrade"
alias bl="brew list"
alias bi="brew install"
alias bs="brew search"
alias bu="brew uninstall"
alias bd="brew deps --tree --installed"

# Formulae
alias rm="trash"
alias wifi="wifi-password"

# MacOS
alias systemup="softwareupdate --all --install --force"
alias usebash="chsh -s $(which bash)"
alias usezsh="chsh -s $(which zsh)"

# Weather
alias weather="curl wttr.in"

# Yarn
alias yi="yarn install"
alias ya="yarn add"
alias yr="yarn remove"
alias yga="yarn global add"
alias ygr="yarn global remove"
alias ygl="yarn global list"

# Dotfiles
alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update="sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup"

# Python
alias python="python3"
alias py="python3"
alias pip="pip3"

# Bash
alias profile="code ~/.bash_profile"
alias bashrc="code ~/.bashrc"
alias vimrc="code ~/.vimrc"

# Paths
# --------------------------------------------------------------------------------------------
export PATH="$HOME/.nvm/versions/node/v20.2.0/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export BASH_SILENCE_DEPRECATION_WARNING=1
export TERM="xterm-256color-italic"

# Profile
# --------------------------------------------------------------------------------------------
# Reset
Reset="\033[0m\]" # Text Reset

# Regular Colors
Black="\033[0;30m\]"  # Black
Red="\033[0;31m\]"    # Red
Green="\033[0;32m\]"  # Green
Yellow="\033[0;33m\]" # Yellow
Blue="\033[0;34m\]"   # Blue
Purple="\033[0;35m\]" # Purple
Cyan="\033[0;36m\]"   # Cyan
White="\033[0;37m\]"  # White

# Bold
BBlack="\033[1;30m\]"  # Black
BRed="\033[1;31m\]"    # Red
BGreen="\033[1;32m\]"  # Green
BYellow="\033[1;33m\]" # Yellow
BBlue="\033[1;34m\]"   # Blue
BPurple="\033[1;35m\]" # Purple
BCyan="\033[1;36m\]"   # Cyan
BWhite="\033[1;37m\]"  # White

# Underline
UBlack="\033[4;30m\]"  # Black
URed="\033[4;31m\]"    # Red
UGreen="\033[4;32m\]"  # Green
UYellow="\033[4;33m\]" # Yellow
UBlue="\033[4;34m\]"   # Blue
UPurple="\033[4;35m\]" # Purple
UCyan="\033[4;36m\]"   # Cyan
UWhite="\033[4;37m\]"  # White

# Background
On_Black="\033[40m\]"  # Black
On_Red="\033[41m\]"    # Red
On_Green="\033[42m\]"  # Green
On_Yellow="\033[43m\]" # Yellow
On_Blue="\033[44m\]"   # Blue
On_Purple="\033[45m\]" # Purple
On_Cyan="\033[46m\]"   # Cyan
On_White="\033[47m\]"  # White

# High Intensity
IBlack="\033[0;90m\]"  # Black
IRed="\033[0;91m\]"    # Red
IGreen="\033[0;92m\]"  # Green
IYellow="\033[0;93m\]" # Yellow
IBlue="\033[0;94m\]"   # Blue
IPurple="\033[0;95m\]" # Purple
ICyan="\033[0;96m\]"   # Cyan
IWhite="\033[0;97m\]"  # White

# Bold High Intensity
BIBlack="\033[1;90m\]"  # Black
BIRed="\033[1;91m\]"    # Red
BIGreen="\033[1;92m\]"  # Green
BIYellow="\033[1;93m\]" # Yellow
BIBlue="\033[1;94m\]"   # Blue
BIPurple="\033[1;95m\]" # Purple
BICyan="\033[1;96m\]"   # Cyan
BIWhite="\033[1;97m\]"  # White

# High Intensity backgrounds
On_IBlack="\033[0;100m\]"  # Black
On_IRed="\033[0;101m\]"    # Red
On_IGreen="\033[0;102m\]"  # Green
On_IYellow="\033[0;103m\]" # Yellow
On_IBlue="\033[0;104m\]"   # Blue
On_IPurple="\033[0;105m\]" # Purple
On_ICyan="\033[0;106m\]"   # Cyan
On_IWhite="\033[0;107m\]"  # White

# Italics
sitm="\e[3m"  # Italic Start
ritm="\e[23m" # Italic

# Git branch in prompt.
parse_git_branch() {
	git branch 2>/dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/"
}

# Set the terminal title and prompt.
PS1=""
PS1+="\[${Blue}\]\T "                        # Timestamp
PS1+="\[${Yellow}\]> "                       # Prompt
PS1+="\[${Purple}\]\[${sitm}\]\w\[${ritm}\]" # Working Directory
PS1+="\[${White}\]\[\$(parse_git_branch)\]"  # Branch
PS1+="\[${Green}\] "
export PS1

# Directory Colors
LSCOLORS=ExFxBxDxCxegedabagacad
LSCOLORS=""
LSCOLORS+="Ex" # Directory
LSCOLORS+="Fx" # Symbolic link
LSCOLORS+="Bx" # Socket
LSCOLORS+="Dx" # Pipe
LSCOLORS+="Cx" # Executable
LSCOLORS+="eg" # Block special
LSCOLORS+="ed" # Character special
LSCOLORS+="ab" # Executable with setuid bit set
LSCOLORS+="ag" # Executable with setgid bit set
LSCOLORS+="ac" # Directory writable to others, with sticky bit
LSCOLORS+="ad" # Directory writable to others, without sticky bit

export LSCOLORS
export CLICOLOR=1 # Set CLICOLOR to true
export EDITOR="vim"
