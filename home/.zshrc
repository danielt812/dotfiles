# Profiling: run with ZPROF=1 zsh to enable
# ZPROF=1
if [[ "$ZPROF" == 1 ]]; then
  zmodload zsh/zprof
  zmodload zsh/datetime
  _zprof_start=$EPOCHREALTIME
fi

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

plug() {
  local repo="$1" name dir init
  name="${repo##*/}"
  dir="$XDG_CONFIG_HOME/zsh/plugins/$name"
  [[ -d "$dir" ]] || git clone --quiet --depth=1 "https://github.com/$repo" "$dir"
  for init in "$dir/$name.plugin.zsh" "$dir/$name.zsh" "$dir/init.zsh"; do
    [[ -f "$init" ]] && { source "$init"; return; }
  done
}

plug zsh-users/zsh-completions
plug zsh-users/zsh-autosuggestions
plug zsh-users/zsh-history-substring-search
plug zsh-users/zsh-syntax-highlighting

source "$XDG_CONFIG_HOME/zsh/options.zsh"
source "$XDG_CONFIG_HOME/zsh/history.zsh"
source "$XDG_CONFIG_HOME/zsh/completions.zsh"
source "$XDG_CONFIG_HOME/zsh/keybindings.zsh"
source "$XDG_CONFIG_HOME/zsh/exports.zsh"
source "$XDG_CONFIG_HOME/zsh/colors.zsh"
source "$XDG_CONFIG_HOME/zsh/aliases.zsh"
source "$XDG_CONFIG_HOME/zsh/functions.zsh"
source "$XDG_CONFIG_HOME/zsh/fzf.zsh"
source "$XDG_CONFIG_HOME/zsh/profile.zsh"

# Optional init hooks
command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

if [[ "$ZPROF" == 1 ]]; then
  _zprof_report
  unset ZPROF
  unset _zprof_report
fi
