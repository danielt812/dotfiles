#!/usr/local/bin/zsh

# $(cowthink -f kitty $(fortune))

# Git branch in prompt.
function parse_git_branch() {
	local branch=$(git branch --show-current 2> /dev/null)
	if [[ -n $branch ]]; then
		echo "($branch)"
	fi
}

# https://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png
COLOR_TIME=$'%F{6}'
DATE_12_HR=$'%D{%I:%M:%S}'
COLOR_PWD=$'%F{5}'
ITALIC_START=$'\e[3m'
ITALIC_END=$'\e[23m'
COLOR_GIT=$'%F{7}'
NEW_LINE=$'\n'
COLOR_PROMPT=$'%F{3}'
COLOR_DEF=$'%F{2}'

setopt PROMPT_SUBST

PROMPT=''
# Time
PROMPT+='${COLOR_TIME}${DATE_12_HR} '
# PWD
PROMPT+='${COLOR_PWD}${ITALIC_START}%~${ITALIC_END} '
# Git
PROMPT+='${COLOR_GIT}$(parse_git_branch)'
PROMPT+='${NEW_LINE}'
# Prompt
PROMPT+='${COLOR_PROMPT}> '
PROMPT+='${COLOR_DEF}'
export PROMPT