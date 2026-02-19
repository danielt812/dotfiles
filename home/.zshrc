ZDOTDIR="$HOME/.config/zsh"
ZPLUGINDIR="$ZDOTDIR/plugins"
SDOTDIR="$HOME/.config/sh"

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
source "$SDOTDIR/exports.sh"
source "$SDOTDIR/aliases.sh"
source "$SDOTDIR/functions.sh"

# Optional init hooks
command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
