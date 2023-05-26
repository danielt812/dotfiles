#!/bin/zsh

# Check if Homebrew is already installed
if ! command -v brew &> /dev/null; then
	echo "Homebrew not found. Installing Homebrew..."
	/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew is already installed."
	echo "Installing formulae..."

	# Array of formulae to install
	formulae=("cowsay" "fortune" "fzf" "python@3.11" "speedtest-cli" "trash" "tree" "wifi-password" "git" "wget" "tmux" "youtube-dl" "mas" "htop" "nvm" "yarn" "zsh")

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
	casks=("1password" "alfred" "appcleaner" "bartender" "brave-browser" "discord" "iterm2" "itsycal" "keka" "maccy" "night-owl" "numi" "pika" "postman" "shottr" "spotify" "spotmenu" "studio-3t" "visual-studio-code")

	# Iterate through formulae and install if not already installed
	for cask in "${casks[@]}"; do
		if ! brew list "$cask" &> /dev/null; then
			brew install "$cask --cask"
		else
			echo "$cask is already installed."
		fi
	done
fi

if [[ -d $ZSH_CUSTOM/themes/zap ]]; then
	echo "zap-zsh is already installed."
fi