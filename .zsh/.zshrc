#!/usr/local/bin/zsh

# Load NVM
[ -f "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh" --no-use

# Enable Zoxide
eval "$(zoxide init zsh)"

ZDOTDIR="$HOME/.dotfiles/.zsh"

# Source
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/exports.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/prompt.zsh"

# Plugins
source "$ZDOTDIR/plugins/completions.zsh"
source "$ZDOTDIR/plugins/vim.zsh"
source "$ZDOTDIR/plugins/autosuggestions.zsh"
source "$ZDOTDIR/plugins/history-substring-search.zsh"
source "$ZDOTDIR/plugins/fast-syntax-highlighting.zsh"
source "$ZDOTDIR/plugins/you-should-use.zsh"