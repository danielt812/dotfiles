#!/bin/zsh

if [[ -d "$HOME/dotfiles" ]]; then
  # Rename contents to $HOME/.dotfiles
  mv "$HOME/dotfiles/" "$HOME/.dotfiles/"
  echo "Renamed 'dotfiles' directory to '.dotfiles'"
elif [[ -d "$HOME/.dotfiles" ]]; then
  echo "Dotfiles in $HOME/.dotfiles"
fi

# Change permissions to execute the scripts below...
chmod +x brew.sh
chmod +x zap.sh

# Run the Homebrew Script
./brew.sh

# Run the Zap Script
./zap.sh

DOTFILES="$HOME/.dotfiles"

cd "$DOTFILES"

for file in .*; do
  if [ -e "$file" ] && [ "$file" != ".git" ] && [ "$file" != ".gitignore" ]; then
    echo "Creating symlink from $DOTFILES/$file to $HOME/$file in home directory."
    # Use force flag to overwrite files
    # echo "$file" "$HOME/$file"
    ln -sf "$DOTFILES/$file" "$HOME/$file"
  fi
done
