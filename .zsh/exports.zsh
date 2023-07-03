#!/usr/local/bin/zsh

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.nvm/versions/node/v20.3.1/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$LOCAL/mysql/bin:$PATH"
export DYLD_LIBRARY_PATH=$HOME/instantclient_19_8
export LD_LIBRARY_PATH=${ORACLE_HOME}/lib
export OCI_DIR=$ORACLE_HOME
export OCI_INC_DIR=$HOME/instantclient_19_8/sdk/include
export OCI_LIB_DIR=$HOME/instantclient_19_8
export ORACLE_HOME=$HOME/instantclient_19_8
export PYTHON=$LOCAL/bin/python3.11
export TNS_ADMIN=$ORACLE_HOME/NETWORK/ADMIN

# Env
export TERM="xterm-256color-italic"
export EDITOR="lvim"
export BROWSER="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
export LOCAL="/usr/local"
export CONFIG="$HOME/.config"
export DOTFILES="$HOME/.dotfiles"
export PAGER="less -R"
export BAT_PAGER="less -RF"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Fzf
export FZF_DEFAULT_COMMAND="fd --type f --color=never --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--no-height --color=bg+:#1c1d1e,fg+:#ff005f,gutter:-1,pointer:#ff5f00,info:#0dbc79,hl:#0dbc79,hl+:#23d18b,prompt:#ff5f00"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS=" --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS=" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export STARSHIP_CONFIG=$CONFIG/starship/starship.toml
export STARSHIP_CACHE=$CONFIG/starship/cache

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
