#!/bin/bash

cdfzf() {
	local depth=0
	local hidden=false
	local no_ignore=false
	local preview=false

	# Help menu function
	show_help() {
		echo "Usage: cdf [OPTIONS]"
		echo
		echo "OPTIONS:"
		echo "  -d, --depth <N>      Specify the maximum directory depth to search"
		echo "  -h, --hidden         Include hidden directories in the search"
		echo "  -i, --no-ignore      Don't respect .gitignore files"
		echo "  -p, --preview        Show a preview of the selected directory's contents"
		echo "  --help               Show this help message and exit"
		echo
		echo "Examples:"
		echo "  cdf -d 2             Search directories up to 2 levels deep"
		echo "  cdf -h               Include hidden directories"
		echo "  cdf -p               Show a preview of the selected directory's contents"
		return 0
	}

	# Check if fd is installed; if not, fall back to find
	if command -v fd >/dev/null 2>&1; then
		fd_installed=true
	else
		fd_installed=false
	fi

	# Check if lsd is installed; if not, fall back to ls
	if command -v lsd >/dev/null 2>&1; then
		lsd_installed=true
	else
		lsd_installed=false
	fi

	# Process flags first
	while [[ $# -gt 0 ]]; do
		case $1 in
		-d | --depth)
			depth="$2"
			shift 2 # Shift past the flag and its argument
			;;
		-h | --hidden)
			hidden=true
			shift # Only shift past the flag (no argument for -h)
			;;
		-i | --no-ignore)
			no_ignore=true
			shift
			;;
		-p | --preview)
			preview=true
			shift
			;;
		--help)
			show_help
			return 0
			;;
		--) # End of flags
			shift
			break
			;;
		*)
			break
			;;
		esac
	done

	# Construct the command based on whether fd is installed
	if [[ $fd_installed == true ]]; then
		# Use fd
		if [[ $hidden == true ]]; then
			fd_command="fd -t d --hidden . --exclude node_modules"
		else
			fd_command="fd -t d . --exclude node_modules"
		fi

		# Append depth if provided
		if [[ $depth != 0 ]]; then
			fd_command="$fd_command -d $depth"
		fi

		# Append no-ignore if provided
		if [[ $no_ignore == true ]]; then
			fd_command="$fd_command --no-ignore"
		fi
	else
		# Fall back to find
		if [[ $hidden == true ]]; then
			find_command="find . -type d -name '.*'"
		else
			find_command="find . -type d"
		fi

		# Append depth if provided
		if [[ $depth != 0 ]]; then
			find_command="$find_command -maxdepth $depth"
		fi
		fd_command=$find_command
	fi

	# Construct the fzf command
	fzf_command="fzf --prompt='Select Directory: '"

	# If the preview option is enabled, add a preview of files and directories
	if [[ $preview == true ]]; then
		# Use lsd if available, otherwise fall back to ls
		if [[ $lsd_installed == true ]]; then
			fzf_command="$fzf_command --preview 'lsd --icon=always --group-dirs=first --color=always {} | head -n 100'"
		else
			fzf_command="$fzf_command --preview 'ls -F --color=always {} | head -n 100'"
		fi
	fi

	# Execute the fd or find command and pipe it to fzf
	cd "$(eval $fd_command | eval $fzf_command)"
}
