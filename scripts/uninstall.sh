#!/bin/bash

echo "Running dotfiles uninstall script..."

# Function to check file existence
del_file() {
  local file_name="$1"
  local file_path=$(find ~ -maxdepth 1 -name "$file_name" -type f)

  if [ -z "$file_path" ]; then
    echo "$file_name not found"
    return 1
  else
    echo "deleting $file_name found at: $file_path"
    rm "$file_path"
    return 0
  fi
}

# Function to check dir existence
del_dir() {
  local dir_name="$1"
  local dir_path=$(find ~ -maxdepth 1 -name "$dir_name" -type d)

  if [ -z "$dir_path" ]; then
    echo "$dir_name directory not found"
    return 1
  else
    echo "deleting $dir_name directory found at: $dir_path"
    rm -rf "$dir_path"
    return 0
  fi
}

# List of files and directories to delete
files=(".zshrc" ".zprofile" ".zsh_history" ".zsh_sessions" ".bashrc" ".bash_profile" ".bash_history" ".vimrc" ".gitconfig")
dirs=(".nvm" ".config" ".tmux" ".config")

# Check if Homebrew is installed
if command -v brew &>/dev/null; then
  echo "Homebrew found. Uninstalling..."

  # Uninstall Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"

  if [ $? -eq 0 ]; then
    echo "Homebrew successfully uninstalled."
  else
    echo "Error uninstalling Homebrew."
    exit 1
  fi
else
  echo "Homebrew not found. Nothing to uninstall."
fi

# Loop through files and call del_file function
for file in "${files[@]}"; do
  del_file "$file"
done

# Loop through directories and call del_dir function
for dir in "${dirs[@]}"; do
  del_dir "$dir"
done

# Check exit status and exit if any file is not found
if [ $? -eq 1 ]; then
  exit 1
fi
