#!/bin/bash

batdiff() {
	git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

detect_clipboard_utility() {
	if command -v pbcopy &>/dev/null; then
		echo "pbcopy"
	elif command -v xclip &>/dev/null; then
		echo "xclip"
	elif command -v wl-copy &>/dev/null; then
		echo "wl-copy"
	else
		echo "none"
	fi
}

# Alias FZF
af() {
	local flag=$1
	local clipboard_utility=$(detect_clipboard_utility)
	local selected_alias

	if [[ $flag == -e ]]; then
		selected_alias="$(alias | fzf | cut -d '=' -f 1)"
		if [[ -n $selected_alias ]]; then
			eval "$selected_alias"
			print -s !$
		fi
	else
		selected_alias="$(alias | fzf | cut -d '=' -f 1 | tr -d '\n')"
		if [[ -n $selected_alias ]]; then
			if [[ $clipboard_utility == "none" ]]; then
				echo "Clipboard functionality not supported on this OS."
				return 1
			else
				echo -n "$selected_alias" | $clipboard_utility ${clipboard_utility== "xclip" && echo "-selection clipboard"}
			fi
		fi
	fi
}

histf() {
	local clipboard_utility=$(detect_clipboard_utility)
	local selected_command
	local copy_to_clipboard=false

	for arg in "$@"; do
		case "$arg" in
		-e | --execute)
			selected_command=$(tail -r $HISTFILE | fzf | tr -d '\n')
			eval "$selected_command"
			return
			;;
		-c | --copy)
			copy_to_clipboard=true
			;;
		*)
			echo "Unknown flag: $arg"
			return 1
			;;
		esac
	done

	if [[ "$copy_to_clipboard" == true ]]; then
		selected_command=$(tail -r $HISTFILE | fzf | tr -d '\n')
		if [[ $clipboard_utility == "none" ]]; then
			echo "Clipboard functionality not supported on this OS."
			return 1
		else
			echo "$selected_command" | $clipboard_utility ${clipboard_utility== "xclip" && echo "-selection clipboard"}
		fi
	fi
}

# Kill Port
kp() {
	local port=$1
	echo "Killing port ${port}..."
	lsof -i :"${port}" | awk '{print $2}' | grep -v PID | xargs kill
}

# Git Branch FZF
gbf() {
	local flag=$1
	local selected_branch
	local base_branch
	local dir

	if [[ $flag == -r ]]; then
		selected_branch=$(git branch -r | fzf | tr -d '[:blank:]')
		if [[ -n "$selected_branch" ]]; then
			base_branch=$(echo "$selected_branch" | cut -d / -f 2)
			git checkout -b "$base_branch" "$selected_branch"
		fi
	else
		selected_branch=$(git branch --format='%(refname:short)' | fzf | tr -d '[:blank:]')
		if [[ -n "$selected_branch" ]]; then
			git checkout "$selected_branch"
			# git pull
		fi
	fi
}

cdf() {
	local depth=""
	local hidden=""

	# Parse the flags
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-a | --all)
			hidden="--hidden"
			shift
			;;
		-d | --depth)
			depth="$2"
			shift 2
			;;
		*)
			shift
			;;
		esac
	done

	# Run the fd command with the appropriate flags
	if [[ -n "$depth" ]]; then
		cd "$(fd -t d $hidden -d "$depth" | fzf)"
	else
		cd "$(fd -t d $hidden | fzf)"
	fi
}

generateBearer() {
	local clipboard_utility=$(detect_clipboard_utility)

	if [[ $clipboard_utility == "none" ]]; then
		echo "Clipboard functionality not supported on this OS."
		return 1
	fi

	local bearer_token="Bearer $(openssl rand -base64 16)"
	echo "$bearer_token"
	echo "$bearer_token" | $clipboard_utility ${clipboard_utility== "xclip" && echo "-selection clipboard"}
}
