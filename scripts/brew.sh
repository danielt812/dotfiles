#!/bin/zsh

# Check if Homebrew is already installed
if ! command -v brew &> /dev/null; then
	echo "Homebrew not found. Installing Homebrew..."
	/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew is already installed."
	echo "Installing formulae..."

	# Array of formulae to install
	formulae=("bat" "bottom" "cowsay" "fd" "fortune" "fzf" "git" "git-delta" "python@3.11" "speedtest-cli" "lolcat" "lsd" "macchina" "neovim" "nvm" "ranger" "ripgrep" "sd" "tealdeer" "tmux" "trash" "wget" "wifi-password" "yarn" "zoxide" "zsh")

	# Iterate through formulae and install if not already installed
	for formula in "${formulae[@]}"; do
		if ! brew list "$formula" &> /dev/null; then
			brew install "$formula"
		else
			echo "$formula is already installed."
		fi
	done

	echo "Installing casks..."

	# Array of casks to install
	casks=("1password" "alfred" "appcleaner" "bartender" "brave-browser" "dbeaver-community" "discord" "iterm2" "itsycal" "keka" "maccy" "numi" "pika" "postman" "shottr" "spotify" "studio-3t")

	# Iterate through formulae and install if not already installed
	for cask in "${casks[@]}"; do
		if ! brew list "$cask" &> /dev/null; then
			brew install "$cask"
		else
			echo "$cask is already installed."
		fi
	done
fi
