#!/bin/bash

git_branch_fzf() {
	local action="" # Default action is checkout
	local flag=""
	local selected_branch
	local base_branch
	local current_branch=$(git rev-parse --abbrev-ref HEAD)

	# Help menu function
	show_help() {
		echo "Usage: gbft [OPTIONS]"
		echo
		echo "OPTIONS:"
		echo "  -c, --checkout      Checkout a branch (default action)"
		echo "  -d, --delete        Delete a branch (requires confirmation)"
		echo "  -r, --remote        Operate on remote branches"
		echo "  -m, --merge         Merge the selected branch into the current branch"
		echo "  -p, --pull          Pull the latest changes for the selected branch after checkout"
		echo "  -s, --stash         Stash changes before switching to another branch"
		echo "  -n, --new-branch    Create and checkout a new branch"
		echo "  -l, --list          List branches (no checkout or other actions)"
		echo "  -h, --help          Show this help message and exit"
		echo
		echo "Examples:"
		echo "  git_branch_fzf -c             Checkout a branch"
		echo "  git_branch_fzf -d             Delete a branch"
		echo "  git_branch_fzf -r -m          Merge a remote branch into the current branch"
		echo "  git_branch_fzf -p             Pull the latest changes after checking out a branch"
	}

	# Process flags first
	while [[ $# -gt 0 ]]; do
		case $1 in
		-c | --checkout)
			action="checkout"
			shift
			;;
		-d | --delete)
			action="delete"
			shift
			;;
		-r | --remote)
			flag="-r"
			shift
			;;
		-m | --merge)
			action="merge"
			shift
			;;
		-p | --pull)
			action="pull"
			shift
			;;
		-s | --stash)
			action="stash"
			shift
			;;
		-n | --new-branch)
			action="new-branch"
			shift
			;;
		-l | --list)
			action="list"
			shift
			;;
		-h | --help)
			show_help
			return 0
			;;
		*) # Unknown flag or no flag
			break
			;;
		esac
	done

	# Function to ask for confirmation with "no" as the default
	confirm_deletion() {
		echo -n "Are you sure you want to delete the branch '$1'? [y/N] "
		read confirmation
		case "$confirmation" in
		[yY][eE][sS] | [yY])
			return 0 # User confirmed with yes
			;;
		*)
			echo "Aborted."
			return 1 # Default to no
			;;
		esac
	}

	# Prevent deletion of master or main branch
	check_protected_branch_for_delete() {
		if [[ "$1" == "master" || "$1" == "main" ]]; then
			echo "Cannot delete the protected branch '$1'."
			return 1
		else
			return 0
		fi
	}

	# Switch to master or main if deleting the current branch
	switch_to_safe_branch() {
		if [[ "$current_branch" == "$1" ]]; then
			if git show-ref --verify --quiet refs/heads/main; then
				echo "Switching to main branch before deletion."
				git checkout main
			elif git show-ref --verify --quiet refs/heads/master; then
				echo "Switching to master branch before deletion."
				git checkout master
			else
				echo "No main or master branch to switch to."
				exit 1
			fi
		fi
	}

	# Handle different actions
	if [[ $flag == "-r" ]]; then
		# Remote branch operations
		selected_branch=$(git branch -r | fzf | tr -d '[:blank:]')
		base_branch=$(echo "$selected_branch" | cut -d / -f 2)

		if [[ -n "$selected_branch" ]]; then
			if [[ $action == "delete" ]]; then
				if confirm_deletion "$base_branch"; then
					git push origin --delete "$base_branch"
				fi
			elif [[ $action == "list" ]]; then
				echo "$selected_branch"
			elif [[ $action == "merge" ]]; then
				git merge "$selected_branch"
			elif [[ $action == "pull" ]]; then
				git checkout "$base_branch" && git pull
			elif [[ $action == "new-branch" ]]; then
				read -p "Enter new branch name: " new_branch_name
				git checkout -b "$new_branch_name"
			else
				git checkout -b "$base_branch" "$selected_branch"
			fi
		fi
	else
		# Local branch operations
		selected_branch=$(git branch --format='%(refname:short)' | fzf | tr -d '[:blank:]')

		if [[ -n "$selected_branch" ]]; then
			# Only prevent deletion of master/main
			if [[ $action == "delete" ]]; then
				if check_protected_branch_for_delete "$selected_branch"; then
					switch_to_safe_branch "$selected_branch"
					if confirm_deletion "$selected_branch"; then
						git branch -D "$selected_branch"
					fi
				fi
			else
				# Allow all other actions (pull, checkout, merge, etc.)
				if [[ $action == "merge" ]]; then
					git merge "$selected_branch"
				elif [[ $action == "list" ]]; then
					echo "$selected_branch"
				elif [[ $action == "pull" ]]; then
					git checkout "$selected_branch" && git pull
				elif [[ $action == "stash" ]]; then
					git stash && git checkout "$selected_branch"
				elif [[ $action == "new-branch" ]]; then
					read -p "Enter new branch name: " new_branch_name
					git checkout -b "$new_branch_name"
				else
					git checkout "$selected_branch"
				fi
			fi
		fi
	fi
}
