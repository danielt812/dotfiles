#!/bin/bash

# Function to detect the operating system
detect_os() {
	uname
}

# Function to detect the package manager
get_package_manager() {
	if command -v apt &>/dev/null; then
		echo "apt"
	elif command -v dnf &>/dev/null; then
		echo "dnf"
	elif command -v pacman &>/dev/null; then
		echo "pacman"
	elif command -v brew &>/dev/null; then
		echo "brew"
	else
		echo "unknown"
	fi
}

# Function to install a package
install_package() {
	local package=$1
	echo "Installing $package..."
	case $PACKAGE_MANAGER in
	apt) sudo apt install -y "$package" ;;
	dnf) sudo dnf install -y "$package" ;;
	pacman) sudo pacman -S --noconfirm "$package" ;;
	brew) brew install "$package" ;;
	*)
		echo "Package manager not supported: $PACKAGE_MANAGER"
		exit 1
		;;
	esac
}

# Function to enable repositories for RedHat-based systems
enable_copr_repos() {
	local repos=$1
	for repo in $repos; do
		echo "Enabling COPR Repository: $repo"
		sudo dnf copr enable "atim/$repo" -y
	done
}

# Install packages
install_packages() {
	echo "Package Manager: $PACKAGE_MANAGER"

	for PKG in $PACKAGES; do
		install_package "$PKG"
	done
}

# Change shell to zsh
change_shell() {
	if [ "$SHELL" = "/bin/bash" ] || [ "$SHELL" = "/usr/bin/bash" ]; then
		# Change the shell to Zsh if it's available
		if command -v zsh &>/dev/null; then
			sudo chsh -s "$(which zsh)"
			exec zsh
		else
			echo "Zsh not found. Exiting install script"
			exit 1
		fi
	fi
}

# Create symlinks using GNU Stow
stow_dotfiles() {
	if command -v stow &>/dev/null; then
		echo "Stowing dotfiles..."
		stow */
	else
		echo "Stow not installed. Exiting install script."
		exit 1
	fi
}

source_zshrc() {
	source "$HOME/.zshrc"
}

# Install TPM (Tmux Plugin Manager)

install_tpm() {
	if ! command -v tmux &>/dev/null; then
		echo "Tmux not found. Exiting install script."
		exit 1
	fi

	if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
		echo "TPM not found. Installing..."
		git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
		echo "TPM installed successfully."
	else
		echo "TPM is already installed. Skipping installation."
	fi

	# Check if inside a tmux session
	if [ -z "$TMUX" ]; then
		echo "Not in a tmux session. Starting tmux and sourcing the configuration."
		tmux new-session -d -s my_session "tmux source-file $HOME/.config/tmux/tmux.conf; exec bash"
		tmux attach-session -t my_session
	else
		echo "Already in a tmux session. Sourcing the configuration."
		tmux source-file "$HOME/.config/tmux/tmux.conf"
	fi

	"$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
}

download_latest_release() {
	# Check if sufficient arguments are provided
	if [ "$#" -ne 2 ]; then
		echo "Usage: download_latest_release <repository> <file_name>"
		return 1
	fi

	# Assign arguments to variables
	REPO=$1
	FILE=$2

	# Fetch the latest release version from GitHub API
	LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

	if [ -z "$LATEST_VERSION" ]; then
		echo "Failed to fetch the latest version."
		return 1
	fi

	# Construct the download URL
	DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/$FILE"

	# Download the file
	echo "Downloading $FILE from $REPO (version $LATEST_VERSION)..."
	curl -LO "$DOWNLOAD_URL"

	if [ $? -eq 0 ]; then
		echo "Downloaded $FILE from $REPO (version $LATEST_VERSION) successfully."
	else
		echo "Failed to download $FILE from $REPO."
		return 1
	fi

	# Return the download URL (useful for further actions)
	echo "$DOWNLOAD_URL"
}

install_font() {
	# Install the font from a downloaded zip file
	FILE=$1

	# Create fonts directory if it doesn't exist
	FONT_DIR="$HOME/.local/share/fonts"

	# Unzip the downloaded file into the fonts directory
	echo "Installing fonts to $FONT_DIR..."
	unzip -o "$FILE" -d "$FONT_DIR"

	if [ $? -eq 0 ]; then
		echo "Fonts installed successfully."
	else
		echo "Failed to install fonts."
		return 1
	fi

	# Update font cache
	echo "Updating font cache..."
	fc-cache -fv

	if [ $? -eq 0 ]; then
		echo "Font cache updated successfully."
	else
		echo "Failed to update font cache."
		return 1
	fi

	# Clean up the downloaded zip file
	rm "$FILE"
	echo "Cleaned up the downloaded zip file."
}

# Main script logic
OS=$(detect_os)
PACKAGE_MANAGER=$(get_package_manager)
PACKAGES="bat bottom fd-find fzf git-delta kitty lazygit lsd neofetch neovim ripgrep sd starship stow tealdeer tmux zoxide zsh"

if [ "$OS" == "Linux" ]; then
	echo "Operating System: Linux"

	if [ -f /etc/debian_version ]; then
		echo "Debian Version: $(cat /etc/debian_version)"
	elif [ -f /etc/redhat-release ]; then
		echo "RedHat Version: $(cat /etc/redhat-release)"
		enable_copr_repos "bottom lazygit starship"
	fi
elif [ "$OS" == "Darwin" ]; then
	echo "Operating System: macOS"
fi

install_packages
change_shell
stow_dotfiles
install_tpm
