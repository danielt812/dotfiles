#!/bin/bash

batdiff() {
	git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

# Markdown
md() {
	local arg=$1
	local flag=$2
	if [[ $arg == 'help' || $arg == '--help' || $arg == '-h' ]]; then
		echo 'Usage:'
		echo 'tmux [options]: show tmux keybinds/options'
		echo '-h, --help    Show help information"'
	elif [[ $arg == 'tmux' ]]; then
		if [[ $flag == '' ]]; then
			echo 'Use flag option'
			echo '-p "pain_control.tmux"'
			echo '-s "sensible.tmux"'
			echo '-r "resurrect.tmux"'
			echo '-m "continuum.tmux"'
			echo '-y "yank.tmux"'
			echo '-c "copycat.tmux"'
			echo '-g "config"'
		elif [[ $flag == '-p' ]]; then
			glow -p "$CONFIG/tmux/plugins/tmux-pain-control/README.md"
		elif [[ $flag == '-s' ]]; then
			glow -p "$CONFIG/tmux/plugins/tmux-sensible/README.md"
		elif [[ $flag == '-r' ]]; then
			glow -p "$CONFIG/tmux/plugins/tmux-resurrect/README.md"
		elif [[ $flag == '-m' ]]; then
			glow -p "$CONFIG/tmux/plugins/tmux-continuum/README.md"
		elif [[ $flag == '-y' ]]; then
			glow -p "$CONFIG/tmux/plugins/tmux-yank/README.md"
		elif [[ $flag == '-c' ]]; then
			glow -p "$CONFIG/tmux/plugins/tmux-copycat/README.md"
		elif [[ $flag == '-g' ]]; then
			bat --style=plain "$CONFIG/tmux/tmux.conf"
		fi
	else
		echo 'Command not found type md help for usage.'
	fi
}

# Python Utils
pyu() {
	local arg=$1
	local pythonUtilsDir="$HOME/PythonUtils"
	if [[ $arg == 'str' ]]; then
		py "$pythonUtilsDir/str.py" "$@"
	elif [[ $arg == 'clean' ]]; then
		py "$pythonUtilsDir/clean.py" "$@"
	elif [[ $arg == 'sec' ]]; then
		py "$pythonUtilsDir/generateSecret.py"
	else
		echo "Available scripts:"
		echo "pyu str -h --help"
		echo "pyu clean -h --help"
		echo "pyu sec -h --help"
	fi
}

# Alias FZF
af() {
	local flag=$1
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
			echo -n "$selected_alias" | pbcopy
		fi
	fi
}

histf() {
	local selected_command
	local copy_to_clipboard=false

	# Loop through all arguments
	for arg in "$@"; do
		case "$arg" in
		-e | --execute)
			# Flag to execute the selected command
			selected_command=$(tail -r $HISTFILE | fzf | tr -d '\n')
			eval "$selected_command"
			return
			;;
		-c | --copy)
			# Flag to copy the selected command to clipboard (Assuming pbcopy is available or xclip for Linux)
			copy_to_clipboard=true
			;;
		*)
			# Handle unknown options
			echo "Unknown flag: $arg"
			return 1
			;;
		esac
	done

	if [[ "$copy_to_clipboard" == true ]]; then
		selected_command=$(tail -r $HISTFILE | fzf | tr -d '\n')
		# Check if running on macOS or Linux and use appropriate clipboard utility
		if [[ "$(uname)" == "Darwin" ]]; then
			echo "$selected_command" | pbcopy
		elif [[ "$(uname)" == "Linux" ]]; then
			echo "$selected_command" | xclip -selection clipboard
		else
			echo "Clipboard functionality not supported on this OS."
			return 1
		fi
	fi
}

# Automate git merges/pushes to master and staging branch
alameda_push() {
	local branch=$(git branch --show-current 2>/dev/null)
	local flag=$1

	if [[ ! "$PWD" =~ /alameda(/|$) ]]; then
		echo "Error: 'alameda' is not in the present working directory"
		return 1
	fi

	if [[ $branch =~ ^(master|staging)$ ]]; then
		echo 'Already on master or staging branch'
	else
		if [[ $flag == '-a' ]]; then
			gpull && gpush && gcom && gm $branch --no-edit && gpush && gcos && gm $branch --no-edit && gpush && gco $branch
		elif [[ $flag == '-m' ]]; then
			gpull && gpush && gcom && gm $branch --no-edit && gpush && gco $branch
		elif [[ $flag == '-s' ]]; then
			gpull && gpush && gcos && gm $branch --no-edit && gpush && gco $branch
		elif [[ $flag == '-h' ]]; then
			echo 'Usage:'
			echo '-a: Push/Merge to master and staging'
			echo '-m: Push/Merge to master only'
			echo '-s: Push/Merge to staging only'
			echo '-h: Show help information'
		else
			echo 'Invalid flag provided'
		fi
	fi
}

delete_cron_job() {
	kubectl -n mci-cronies-prod delete cronjob "$1"
}

cronjobs() {
	# Initialize variables
	local flag=""
	local arg=""
	local usage="Usage: cronjobs [-a arg] | [--awk arg]"

	# Parse options using getopts
	while [[ "$#" -gt 0 ]]; do
		case "$1" in
		-a | --awk)
			flag="--awk"
			if [[ -n "$2" && "$2" != "-"* ]]; then
				arg="$2"
				shift 2
			else
				echo "Error: Argument for $flag is required."
				echo "$usage"
				return 1
			fi
			;;
		-h | --help)
			echo "$usage"
			return 0
			;;
		*)
			echo "Unknown option: $1"
			echo "$usage"
			return 1
			;;
		esac
	done

	# Execute the appropriate command based on the flag
	if [[ "$flag" == "--awk" ]]; then
		kubectl get cronjob -n mci-cronies-prod | awk "NR==1 || /$arg/"
	else
		kubectl get cronjob -n mci-cronies-prod
	fi
}

# Kill Port
kp() {
	local port=$1
	echo "Killing port ${port}..."
	lsof -i :"${port}" | awk '{print $2}' | grep -v PID | xargs kill
}

toLower() {
	local arg="$1"
	if [[ -n "$arg" ]]; then
		echo "Converting $arg to lowercase"
		local lowercase_arg=$(echo "$arg" | tr "[:upper:]" "[:lower:]")
		echo -n "$lowercase_arg" | pbcopy
		echo "$lowercase_arg copied to clipboard"
	else
		echo "toLower needs an argument"
	fi
}

toUpper() {
	local arg="$1"
	if [[ -n "$arg" ]]; then
		echo "Converting $arg to uppercase"
		local uppercase_arg=$(echo "$arg" | tr "[:lower:]" "[:upper:]")
		echo -n "$uppercase_arg" | pbcopy
		echo "$uppercase_arg copied to clipboard"
	else
		echo "toUpper needs an argument"
	fi
}

generateBearer() {
	local OS=$(uname -s)
	local copy_command

	case "$OS" in
	Linux)
		copy_command="xclip -selection clipboard"
		;;

	Darwin)
		copy_command="pbcopy"
		;;
	esac

	echo "Bearer $(openssl rand -base64 16)"
	echo "Bearer $(openssl rand -base64 16)" | "$copy_command"
}
