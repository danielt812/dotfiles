# Ensure XDG defaults early
: ${XDG_CONFIG_HOME:="$HOME/.config"}

ZSH_DIR="$XDG_CONFIG_HOME/zsh"
ZSH_PLUGIN_DIR="$ZSH_DIR/plugins"

SH_DIR="$XDG_CONFIG_HOME/sh"

# ZSH Unplugged (only if git exists)
if command -v git >/dev/null 2>&1; then
  if [[ ! -d "$ZSH_PLUGIN_DIR/zsh_unplugged" ]]; then
    git clone --quiet --depth 1 https://github.com/mattmc3/zsh_unplugged "$ZSH_PLUGIN_DIR/zsh_unplugged"
  fi
  [[ -f "$ZSH_PLUGIN_DIR/zsh_unplugged/zsh_unplugged.zsh" ]] && source "$ZSH_PLUGIN_DIR/zsh_unplugged/zsh_unplugged.zsh"
fi

REPOS=(
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-autosuggestions
)

# plugin-load is provided by zsh_unplugged; only call if it exists
(( $+functions[plugin-load] )) && plugin-load $REPOS

# Fzf (optional)
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# Zsh-only
source "$ZSH_DIR/completions.zsh"
source "$ZSH_DIR/history.zsh"
setopt AUTO_CD GLOB_DOTS NO_BEEP

# Shared
source "$SH_DIR/exports.sh"
source "$SH_DIR/aliases.sh"
source "$SH_DIR/functions.sh"

# Optional init hooks
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
