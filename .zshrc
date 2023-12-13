#!/usr/local/bin/zsh

# Load Nvm
# Check if running on Intel Mac
if [ "$(uname -m)" == "x86_64" ]; then
  [ -f "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh" --no-use
fi

# Check if running on M1 (Apple Silicon) Mac
if [ "$(uname -m)" == "arm64" ]; then
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
fi

# Load Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

ZDOTDIR="$HOME/.dotfiles/.zsh"

# Source
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/exports.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"

# Plugins
source "$ZDOTDIR/plugins/completions.zsh"
source "$ZDOTDIR/plugins/vim.zsh"
source "$ZDOTDIR/plugins/autosuggestions.zsh"
source "$ZDOTDIR/plugins/history-substring-search.zsh"
source "$ZDOTDIR/plugins/fast-syntax-highlighting.zsh"
source "$ZDOTDIR/plugins/you-should-use.zsh"

# Check if zoxide command exists before evaluating its initialization script
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Check if starship command exists before evaluating its initialization script
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi
