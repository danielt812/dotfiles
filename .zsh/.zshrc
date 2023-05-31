#!/usr/local/bin/zsh

# Load NVM
[ -f "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh" --no-use

# History
HISTFILE="$HOME/.zsh_history"
DOTFILES="$HOME/.dotfiles"

# Source
source "$DOTFILES/.zsh/exports.zsh"
source "$DOTFILES/.zsh/aliases.zsh"
source "$DOTFILES/.zsh/prompt.zsh"

# Plugins
source "$DOTFILES/.zsh/plugins/completions.zsh"
source "$DOTFILES/.zsh/plugins/vim.zsh"
source "$DOTFILES/.zsh/plugins/autosuggestions.zsh"
source "$DOTFILES/.zsh/plugins/history-substring-search.zsh"
source "$DOTFILES/.zsh/plugins/fast-syntax-highlighting.zsh"
source "$DOTFILES/.zsh/plugins/sudo.zsh"
source "$DOTFILES/.zsh/plugins/you-should-use.zsh"
# TODO Look into this one
# https://github.com/Aloxaf/fzf-tab/tree/master
# source "$DOTFILES/.zsh/plugins/fzf.zsh"

