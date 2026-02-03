# Ensure XDG defaults early
: ${XDG_CONFIG_HOME:="$HOME/.config"}

ZDOTDIR="$XDG_CONFIG_HOME/zsh"
ZPLUGINDIR="$ZDOTDIR/plugins"

SH_DIR="$XDG_CONFIG_HOME/sh"

REPOS=(
  zsh-users/zsh-completions
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-syntax-highlighting
)

# Fzf (optional)
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# Zsh-only
bindkey "^[[3~" delete-char
source "$ZDOTDIR/completions.zsh"
source "$ZDOTDIR/history.zsh"
setopt AUTO_CD GLOB_DOTS NO_BEEP

# Shared
source "$SH_DIR/exports.sh"
source "$SH_DIR/aliases.sh"
source "$SH_DIR/functions.sh"

if command -v fnm >/dev/null 2>&1; then
  mkdir -p "$SH_DIR"
  [[ -f "$SH_DIR/fnm.sh" ]] || fnm env > "$SH_DIR/fnm.sh"
  source "$SH_DIR/fnm.sh"
fi

# Optional init hooks
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

plug() {
  local plugin repo commitsha plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}
  for plugin in $@; do
    repo="$plugin"
    clone_args=(-q --depth 1 --recursive --shallow-submodules)
    # Pin repo to a specific commit sha if provided
    if [[ "$plugin" == *'@'* ]]; then
      repo="${plugin%@*}"
      commitsha="${plugin#*@}"
      clone_args+=(--no-checkout)
    fi
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone "${clone_args[@]}" https://github.com/$repo $plugdir
      if [[ -n "$commitsha" ]]; then
        git -C $plugdir fetch -q origin "$commitsha"
        git -C $plugdir checkout -q "$commitsha"
      fi
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file found '$repo'." && continue }
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

plug $REPOS
