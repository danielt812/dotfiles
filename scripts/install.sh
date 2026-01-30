#!/bin/bash

install_homebrew() {
	# Check if Homebrew is already installed
	if ! command -v brew &>/dev/null; then
		echo "Homebrew not found. Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

		(
			echo
			echo "eval '$(/opt/homebrew/bin/brew shellenv)'"
		) >>~/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		echo "Homebrew is already installed."
	fi
}

install_formulae() {
	echo "Installing formulae..."

	# Array of formulae to install
	formulae=("bat" "btop" "csview" "fd" "fzf" "git" "git-delta" "lazygit" "lazydocker" "lsd" "neovim" "nvm" "ripgrep" "sass/sass/sass" "sd" "starship" "speedtest-cli" "tealdeer" "tmux" "trash" "wifi-password" "yarn" "yazi" "zoxide" "zsh")

	# Iterate through formulae and install if not already installed
	for formula in "${formulae[@]}"; do
		if ! brew list "$formula" &>/dev/null; then
			brew install "$formula"
		else
			echo "$formula is already installed."
		fi
	done
}

install_casks() {
	echo "Installing casks..."

	# Array of casks to install
	casks=("1password" "alfred" "appcleaner" "bartender" "brave-browser" "bruno" "dbeaver-community" "itsycal" "keka" "maccy" "neovide" "numi" "pika" "shottr" "spotify" "studio-3t")

	# Iterate through formulae and install if not already installed
	for cask in "${casks[@]}"; do
		if ! brew list "$cask" &>/dev/null; then
			brew reinstall -f "$cask"
		else
			echo "$cask is already installed."
		fi
	done
}

create_symlinks() {
	dotfiles_dir="$HOME/.dotfiles"

	# List of dotfiles to symlink to home dir
	dotfiles=("bash_profile" "zshrc" "bashrc" "vimrc" "gitconfig") # Add more as needed

	# Change to the dotfiles directory
	cd "$dotfiles_dir" || exit

	# Create symlinks
	for dotfile in "${dotfiles[@]}"; do
		source_file="$dotfiles_dir/.$dotfile"
		target_file="$HOME/.$dotfile"

		ln -sf "$source_file" "$target_file"
		echo "Created symlink: $source_file -> .$dotfile"
	done

	config_dir="$HOME/.config"

	if [ ! -d "$config_dir" ]; then
		echo "Creating config dir at $config_dir"
		mkdir "$HOME"/.config
	fi

	configfiles=("kitty" "ranger" "tmux")
	yamlfiles=("lazygit" "lsd")
	tomlfiles=("neovide starship")

	for configfile in "${configfiles[@]}"; do
		source_dir="$dotfiles_dir/$configfile"
		source_file="$source_dir/$configfile.conf"
		target_dir="$HOME/.config/$configfile"
		target_file="$target_dir/$configfile.conf"
		if [ ! -d "$target_dir" ]; then

			echo "Creating Dir: $target_dir"
			mkdir "$target_dir"

			if [ "$configfile" == "tmux" ]; then
				ln -sf "$source_dir/tmux.conf" "$target_dir/tmux.conf"
				ln -sf "$source_dir/theme.conf" "$target_dir/theme.conf"
			elif [ "$configfile" == "ranger" ]; then
				ln -sf "$source_dir/rc.conf" "$target_dir/rc.conf"
			elif [ "$configfile" == "neovide" ]; then
				ln -sf "$source_dir/config.toml" "$target_dir/config.toml"
			else
				ln -sf "$source_file" "$target_file"
			fi

			echo "Created symlink: $source_file -> $target_file"
		else

			if [ "$configfile" == "tmux" ]; then
				ln -sf "$source_dir/tmux.conf" "$target_dir/tmux.conf"
				ln -sf "$source_dir/theme.conf" "$target_dir/theme.conf"
			elif [ "$configfile" == "ranger" ]; then
				ln -sf "$source_dir/rc.conf" "$target_dir/rc.conf"
			else
				ln -sf "$source_file" "$target_file"
			fi

			echo "Created symlink: $source_file -> $target_file"
		fi
	done

	for yamlfile in "${yamlfiles[@]}"; do
		source_dir="$dotfiles_dir/$yamlfile"
		source_file="$source_dir/$yamlfile.yaml"
		target_dir="$HOME/.config/$yamlfile"
		target_file="$target_dir/$yamlfile.yaml"
		if [ ! -d "$target_dir" ]; then
			echo "Creating Dir: $target_dir"
			mkdir "$target_dir"
			ln -sf "$source_file" "$target_file"
			echo "Created symlink: $source_file -> $target_file"
		else
			ln -sf "$source_file" "$target_file"
			echo "Created symlink: $source_file -> $target_file"
		fi
	done

	for tomlfile in "${tomlfiles[@]}"; do
		source_dir="$dotfiles_dir/$tomlfile"
		source_file="$source_dir/$tomlfile.toml"
		target_dir="$HOME/.config/$tomlfile"
		target_file="$target_dir/$tomlfile.toml"
		if [ ! -d "$target_dir" ]; then
			echo "Creating Dir: $target_dir"
			mkdir "$target_dir"
			ln -sf "$source_file" "$target_file"
			echo "Created symlink: $source_file -> $target_file"
		else
			ln -sf "$source_file" "$target_file"
			echo "Created symlink: $source_file -> $target_file"
		fi
	done
}

init_tpm() {
	tmux_plugins_dir="$HOME/.config/tmux/plugins"

	# Check if already inside tmux
	if [ "$TMUX" != "" ]; then
		echo "Already in tmux. Sourcing tmux.conf..."
		tmux source "$HOME/.config/tmux/tmux.conf"
		return
	fi

	if [ ! -d "$tmux_plugins_dir" ]; then
		echo "Creating tmux plugins dir"
		mkdir -p "$tmux_plugins_dir"
	fi

	tpm_dir="$HOME/.config/tmux/plugins/tpm"
	if [ ! -d "$tpm_dir" ]; then
		git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
	fi

	tmux
	tmux source "$HOME/.config/tmux/tmux.conf"
}

install_tmux_plugins() {
	# Start tmux and send the command to install plugins
	tmux new-session -d -s install_tmux_plugins
	tmux send-keys "tmux source ~/.config/tmux/tmux.conf && ~/.config/tmux/plugins/tpm/bin/install_plugins" C-m
	tmux kill-session -t install_tmux_plugins
}

init_nvm() {
	if [ ! -d "$HOME/.nvm" ]; then
		mkdir "$HOME/.nvm"
	fi

	nvm install --lts
	nvm use --lts
}

install_neovim() {
	if [ ! -d "$HOME/.config/nvim" ]; then
		git clone https://github.com/danielt812/nvim-config ~/.config/nvim
	fi
}

install_vimplug() {
	if [ ! -d "$HOME/.vim/autoload" ]; then
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	fi
}

# install_homebrew
# install_formulae
# install_casks
create_symlinks
# init_tpm
# install_tmux_plugins
# init_nvm
# install_neovim
# install_vimplug
