#!/usr/local/bin/zsh

# Path
export PATH="$HOME/.nvm/versions/node/v20.2.0/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"

# Env
export TERM="xterm-256color-italic"
export EDITOR="vim"
export BROWSER="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
export LOCAL="/usr/local"
export CONFIG="$HOME/.config"

# Directory Colors MacOS
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

export CLICOLOR=1