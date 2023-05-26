#!/bin/zsh

# Load Zap
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
# Load NVM
[ -f "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh" --no-use

# History
HISTFILE="$HOME/.zsh_history"

# Plugins
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"

# Source
plug "$HOME/.zsh/aliases.zsh"
plug "$HOME/.zsh/exports.zsh"
plug "$HOME/.zsh/prompt.zsh"

# autoload -Uz compinit
# compinit