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

# Automate git merges/pushes to master and staging branch
alameda_push() {
	local branch=$(git branch --show-current 2>/dev/null)
	local flag=$1

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

alameda_path() {
	local url
	cd "$HOME/mcisemi/alameda/www.mcisemi.com" || exit
	git checkout master
	git pull
	cd "$1" || exit
	git checkout "$1" 2>/dev/null
	git pull

	url=$(basename "$(pwd)")
	code .
	open -a "$BROWSER" "http://mcisemi.alameda.test/$url"
}

delete_cron_job() {
	kubectl -n mci-cronies-prod delete cronjob "$1"
}

coverletter() {
	cd "$HOME/Documents/resume" || exit
	sed "s/\[Company Name\]/$*/g" Cover_letter_template.txt | cat
	sed "s/\[Company Name\]/$*/g" Cover_letter_template.txt | pbcopy
}

summary() {
	local text='Full Stack Web Developer with 5+ years of expertise known for driving solutions, proven success, and maximizing your organizational growth. I consistently stay up to date with the latest industry trends and technologies to create engaging and user-friendly experiences. Proficient in the MERN Stack (MongoDB | Express | React | Node). I also possess advanced knowledge of JavaScript and have hands-on virtuosity with various libraries and frameworks. In my spare time, I like surfing, playing guitar, spending time with my cat, and expanding knowledge to be a command line power user'

	echo "$text" | pbcopy
	echo "$text" | cat
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
	local alameda="$HOME/mcisemi/alameda/"

	if [[ $flag == -r ]]; then
		selected_branch=$(git branch -r | fzf | tr -d '[:blank:]')
		if [[ -n "$selected_branch" ]]; then
			base_branch=$(echo "$selected_branch" | cut -d / -f 2)
			git checkout -b "$base_branch" "$selected_branch"
			if [[ $(pwd) == *alameda* ]]; then
				cd "$alameda"
				dir="$(fd -t d "$base_branch")"
				if [[ -n $dir ]]; then
					cd "$dir"
				fi
			fi
		fi
	else
		selected_branch=$(git branch --format='%(refname:short)' | fzf | tr -d '[:blank:]')
		if [[ -n "$selected_branch" ]]; then
			git checkout "$selected_branch"
			# git pull
			if [[ $(pwd) == *alameda* ]]; then
				cd "$alameda"
				dir="$(fd -t d $selected_branch)"
				if [[ -n $dir ]]; then
					cd "$dir"
				fi
			fi
		fi
	fi
}

cdf() {
	local arg="$1"
	if [[ $arg == "--no-depth" ]]; then
		cd "$(fd -t d -d . | fzf)"
	else
		cd "$(fd -t d . -d 1 | fzf)"
	fi
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
