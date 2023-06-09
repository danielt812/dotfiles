#!/bin/zsh

# Check if Homebrew is already installed
if ! command -v brew &> /dev/null; then
	echo "Homebrew not found. Installing Homebrew..."
	/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew is already installed."
	echo "Installing formulae..."

	# Array of formulae to install
	formulae=("bat" "black" "cowsay" "csview" "fortune" "fzf" "git" "python@3.11" "speedtest-cli" "lsd" "mas" "htop" "neofetch" "neovim" "node" "nvm" "prettier" "ripgrep" "sass/sass/sass" "tmux" "trash" "wget" "wifi-password" "yarn" "youtube-dl" "zoxide" "zsh")

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
	casks=("1password" "alfred" "appcleaner" "bartender" "brave-browser" "discord" "iterm2" "itsycal" "keka" "maccy" "night-owl" "numi" "pika" "postman" "shottr" "spotify" "studio-3t" "visual-studio-code")

	# Iterate through formulae and install if not already installed
	for cask in "${casks[@]}"; do
		if ! brew list "$cask" &> /dev/null; then
			brew install "$cask"
		else
			echo "$cask is already installed."
		fi
	done
fi