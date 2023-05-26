#!/bin/zsh

if [[ -d "$HOME/dotfiles" ]]; then
  # Rename contents to $HOME/.dotfiles
  mv "$HOME/dotfiles/" "$HOME/.dotfiles/"
  echo "Renamed 'dotfiles' directory to '.dotfiles'"
elif [[ -d "$HOME/.dotfiles" ]]; then
  echo "Dotfiles in $HOME/.dotfiles"
fi

# Run the Homebrew Script
./brew.sh

# Run the Sublime Script
./zap.sh