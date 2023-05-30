#!/usr/local/bin/zsh

# Load NVM
[ -f "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh" --no-use

# History
HISTFILE="$HOME/.zsh_history"

# Plugins
source "$HOME/.zsh/plugins/completions.zsh"
source "$HOME/.zsh/plugins/vim.zsh"
source "$HOME/.zsh/plugins/autosuggestions.zsh"
source "$HOME/.zsh/plugins/history-substring-search.zsh"
# TODO see which syntax highlighting I like better
source "$HOME/.zsh/plugins/fast-syntax-highlighting.zsh"
# source "$HOME/.zsh/plugins/syntax-highlighting.zsh"
source "$HOME/.zsh/plugins/sudo.zsh"
source "$HOME/.zsh/plugins/you-should-use.zsh"
# TODO Look into this one
# https://github.com/Aloxaf/fzf-tab/tree/master
# source "$HOME/.zsh/plugins/fzf.zsh"

# Source
source "$HOME/.zsh/aliases.zsh"
source "$HOME/.zsh/exports.zsh"
source "$HOME/.zsh/prompt.zsh"