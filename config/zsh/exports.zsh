# Env
export COLORTERM="truecolor"
if [[ "$OSTYPE" == linux* ]]; then
  export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
fi
export EDITOR="nvim"
export PAGER="less -RF"
export BAT_PAGER="less -RF"
export BAT_THEME="Everforest Dark"
if command -v bat >/dev/null 2>&1; then
  export LESSOPEN="| bat --color=always --style=numbers %s"
  export LESS="-R"
fi
if command -v nvim >/dev/null 2>&1; then
  export MANPAGER="nvim +Man!"
elif command -v bat >/dev/null 2>&1; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
else
  export MANPAGER="less -RF"
fi
export NVM_DIR="$HOME/.nvm"

# Tpm
export TMUX_PLUGIN_MANAGER_PATH="$XDG_CONFIG_HOME/tmux/plugins"

if command -v xdg-open >/dev/null 2>&1; then
  export BROWSER="xdg-open"
elif command -v open >/dev/null 2>&1; then
  export BROWSER="open"
fi

# Path (quote $PATH)
export PATH="/usr/local/bin:$PATH"
export PATH="/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Docker
export DOCKER_DEFAULT_PLATFORM="linux/amd64"

# Ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/.ripgreprc"

# Starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship/cache"

# Fzf
export FZF_DEFAULT_COMMAND="fd --type f --color=never --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--no-height --color=bg+:#1c1d1e,fg+:#ff005f,gutter:-1,pointer:#ff5f00,info:#0dbc79,hl:#0dbc79,hl+:#23d18b,prompt:#ff5f00"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS=" --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS=" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | copy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
