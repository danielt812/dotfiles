# If not an interactive shell, don't do interactive-only setup.
case $- in
  *i*) ;;
  *) return ;;
esac

# Ensure XDG default early (macOS often doesn't set it)
: "${XDG_CONFIG_HOME:="$HOME/.config"}"

SH_DIR="$XDG_CONFIG_HOME/bash"
export SH_DIR

# ----------------------------
# History (rough analog to your zsh history file)
# ----------------------------
export HISTFILE="${HISTFILE:-$HOME/.bash_history}"
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend 2>/dev/null || true
# Useful history behavior
export HISTCONTROL=ignoreboth:erasedups
# Timestamps in history (optional)
export HISTTIMEFORMAT='%F %T '

# ----------------------------
# Completion + key bindings
# ----------------------------
# Prefer distro bash-completion if present
if [ -r /usr/share/bash-completion/bash_completion ]; then
  # Linux
  . /usr/share/bash-completion/bash_completion
elif [ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
  # macOS Homebrew (Apple Silicon)
  . /opt/homebrew/etc/profile.d/bash_completion.sh
elif [ -r /usr/local/etc/profile.d/bash_completion.sh ]; then
  # macOS Homebrew (Intel)
  . /usr/local/etc/profile.d/bash_completion.sh
fi

# Make `..` work like `cd ..` (bash doesn't have AUTO_CD)
shopt -s autocd 2>/dev/null || true
# Include dotfiles in globs when you explicitly use globs (closest analog to GLOB_DOTS)
shopt -s dotglob 2>/dev/null || true

# ----------------------------
# FZF (as much as we can mirror)
# ----------------------------
# If you installed fzf with its install script, this usually exists:
if [ -f "$HOME/.fzf.bash" ]; then
  . "$HOME/.fzf.bash"
fi

# If your shared aliases/functions rely on pbcopy on macOS, that’s fine.
# On Linux, you likely want xclip/wl-copy installed; your shared functions file should handle it.

# ----------------------------
# Shared config (bash/zsh compatible)
# ----------------------------
# Only source if present to avoid errors on fresh machines
if [ -f "$SH_DIR/exports.sh" ]; then
  . "$SH_DIR/exports.sh"
fi

if [ -f "$SH_DIR/aliases.sh" ]; then
  . "$SH_DIR/aliases.sh"
fi

if [ -f "$SH_DIR/functions.sh" ]; then
  . "$SH_DIR/functions.sh"
fi

# ----------------------------
# NVM (best-effort)
# ----------------------------
# Your exports.sh sets NVM_DIR; fallback here if not set
: "${NVM_DIR:="$HOME/.nvm"}"

# Homebrew NVM on macOS Apple Silicon (your zshrc logic)
if [ "$(uname -s)" = "Darwin" ] && [ "$(uname -m)" = "arm64" ]; then
  if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    . "/opt/homebrew/opt/nvm/nvm.sh"
  fi
fi

# Standard NVM install (macOS Intel + Linux)
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # You used --no-use in zsh; bash version is just sourcing, then optionally `nvm use`
  . "$NVM_DIR/nvm.sh"
fi

# ----------------------------
# Prompt (starship)
# ----------------------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# ----------------------------
# zoxide
# ----------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# ----------------------------
# Nice-to-haves (safe defaults)
# ----------------------------
# Colored `ls` etc is handled by your aliases.sh; here we just ensure less behaves nicely.
export LESS='-RF'

# Optional: make sure ~/.local/bin is on PATH (often useful on Linux)
if [ -d "$HOME/.local/bin" ]; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
  esac
fi
