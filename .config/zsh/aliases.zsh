# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias projects="cd ~/Projects"
alias downloads="cd ~/Downloads"
alias desktop=" cd ~/Desktop"
alias documents="cd ~/Documents"
alias dropbox="cd ~/Dropbox"
alias caskroom="cd /usr/local/Caskroom"
alias cellar="cd /usr/local/Cellar"

# Unix
alias c="clear"
alias lsa="ls -a"     # Show .dotfiles
alias ls1="ls -l1F"   # Show on each line
alias cp="cp -iv"
alias mv="mv -iv"

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

# Formulae
alias rm="trash"
alias wifi="wifi-password"

# Python
alias python="python3"
alias py="python3"
alias pip="pip3"

# Ruby
alias gemup="sudo gem update --system; sudo gem update; sudo gem cleanup"

# MacOS
alias systemup="softwareupdate --all --install --force"
alias usebash="chsh -s (which bash)"
alias usezsh="chsh -s (which zsh)"

# Vim
alias vimrc="code ~/.vimrc"

# Zsh
alias zshrc="code ~/.zshrc"
alias src="source ~/.zshrc"

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
alias showDotFiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hideDotFiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

# Add quit option to finder
alias quitFinderOn="defaults write com.apple.finder QuitMenuItem -bool true; killall Finder"
alias quitFinderOff="defaults write com.apple.finder QuitMenuItem -bool false; killall Finder"

# Put computer into sleep
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Flush dns cache
alias flushDNS="dscacheutil -flushcache"

# Dotfiles
alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Weather
alias weather="curl wttr.in"