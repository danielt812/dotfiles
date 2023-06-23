#!/usr/local/bin/zsh

# Path
export PATH="$HOME/.nvm/versions/node/v20.3.1/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export ORACLE_HOME=$HOME/instantclient_19_8
export OCI_LIB_DIR=$HOME/instantclient_19_8
export OCI_DIR=$ORACLE_HOME
export OCI_INC_DIR=$HOME/instantclient_19_8/sdk/include
export DYLD_LIBRARY_PATH=$HOME/instantclient_19_8
export LD_LIBRARY_PATH=${ORACLE_HOME}/lib
export TNS_ADMIN=$ORACLE_HOME/NETWORK/ADMIN

# Env
export TERM="xterm-256color-italic"
export EDITOR="nvim"
export BROWSER="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
export LOCAL="/usr/local"
export CONFIG="$HOME/.config"
export DOTFILES="$HOME/.dotfiles"
export PAGER="less -R"
# export BAT_PAGER="less -RF"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# https://linuxhint.com/ls_colors_bash/
# Directory Colors Linux
LS_COLORS=''
LS_COLORS+='di=1;34:' # Directory
LS_COLORS+='ln=1;35:' # Symbolic link
LS_COLORS+='so=1;33:' # Socket
LS_COLORS+='pi=1;33:' # Pipe
LS_COLORS+='ex=1;36:' # Executable
LS_COLORS+='bd=1;33:' # Block special
LS_COLORS+='cd=1;33:' # Character special
LS_COLORS+='su=1;33:' # Executable with setuid bit set
LS_COLORS+='sg=1;33:' # Executable with setgid bit set
LS_COLORS+='tw=1;33:' # Directory writable to others, with sticky bit
LS_COLORS+='ow=1;33:' # Directory writable to others, without sticky bit
export LS_COLORS

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
