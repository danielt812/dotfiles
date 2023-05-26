# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1)/p'
}

# https://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png -> Color Codes
NEW_LINE=$'\n'
COLOR_MAIN=$'\e[1;33m'
COLOR_END=$'\e[0m'
COLOR_DEF=$'%F{46}'
COLOR_TIME=$'%F{93}'
COLOR_PWD=$'%F{198}'
COLOR_GIT=$'%F{15}'
COLOR_PROMPT=$'%F{202}'
DATE_12_HR=$'%D{%I:%M:%S}'
ITALIC_START=$'\e[3m'
ITALIC_END=$'\e[23m'

setopt PROMPT_SUBST

PS1=''
# Time
PS1+='${COLOR_TIME}${DATE_12_HR} '
# PWD
PS1+='${COLOR_PWD}${ITALIC_START}%~${ITALIC_END} '
# Git
PS1+='${COLOR_GIT}$(parse_git_branch)'
PS1+='${NEW_LINE}'
# Prompt
PS1+='${COLOR_PROMPT}> '
PS1+='${COLOR_DEF}'
export PS1

# Directory Colors
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