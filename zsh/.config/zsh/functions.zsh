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
	local selection
	local pid

	# Find PIDs using lsof -i, then pipe to fzf for selection
	selection=$(lsof -i -P -n | awk 'NR>1 {print $1, $2}' | sort -u | fzf --prompt="Select process to kill: ")

	# Extract the PID from the selected line
	pid=$(echo "$selection" | awk '{print $2}')

	# If a PID was selected, kill the process
	if [[ -n "$pid" ]]; then
		echo "Killing PID: $pid"
		kill "$pid"
	else
		echo "No process selected."
	fi
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
