ZDOTDIR="$XDG_CONFIG_HOME/zsh"
ZPLUGINDIR="$ZDOTDIR/plugins"

SH_DIR="$XDG_CONFIG_HOME/sh"

if [[ ! -d "$ZPLUGINDIR/zsh_unplugged" ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged "$ZPLUGINDIR/zsh_unplugged"
fi

source "$ZPLUGINDIR/zsh_unplugged/zsh_unplugged.zsh"

REPOS=(
  zsh-users/zsh-completions
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-syntax-highlighting
)

plugin-load "${REPOS[@]}"

# Zsh-only
bindkey "^[[3~" delete-char
source "$ZDOTDIR/completions.zsh"
source "$ZDOTDIR/history.zsh"

setopt AUTO_CD GLOB_DOTS NO_BEEP

# Shared
source "$SH_DIR/exports.sh"
source "$SH_DIR/aliases.sh"
source "$SH_DIR/functions.sh"

# Optional init hooks
command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
