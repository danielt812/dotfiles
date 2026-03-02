# Env
export COLORTERM="truecolor"
export EDITOR="nvim"
export LOCAL="/usr/local"
export CONFIG="$HOME/.config"
export DOTFILES="$HOME/.dotfiles"
export PAGER="less -RF"
export BAT_PAGER="less -RF"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NVM_DIR="$HOME/.nvm"

export TMUX_PLUGIN_MANAGER_PATH="$XDG_CONFIG_HOME/tmux/plugins"

if command -v xdg-open >/dev/null 2>&1; then
  export BROWSER="xdg-open"
elif command -v open >/dev/null 2>&1; then
  export BROWSER="open"
fi

# Path (quote $PATH)
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$LOCAL/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Docker
export DOCKER_DEFAULT_PLATFORM="linux/amd64"

# Ripgrep
export RIPGREP_CONFIG_PATH="$CONFIG/ripgrep/.ripgreprc"

# Fzf
export FZF_DEFAULT_COMMAND="fd --type f --color=never --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--no-height --color=bg+:#1c1d1e,fg+:#ff005f,gutter:-1,pointer:#ff5f00,info:#0dbc79,hl:#0dbc79,hl+:#23d18b,prompt:#ff5f00"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS=" --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# pbcopy is macOS; use xclip if present; otherwise drop the binding
if command -v pbcopy >/dev/null 2>&1; then
  _fzf_copy_cmd='pbcopy'
elif command -v xclip >/dev/null 2>&1; then
  _fzf_copy_cmd='xclip -selection clipboard'
else
  _fzf_copy_cmd=''
fi

if [ -n "$_fzf_copy_cmd" ]; then
  export FZF_CTRL_R_OPTS=" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview' --bind \"ctrl-y:execute-silent(echo -n {2..} | $_fzf_copy_cmd)+abort\" --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
else
  export FZF_CTRL_R_OPTS=" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
fi

unset _fzf_copy_cmd

export STARSHIP_CONFIG="$CONFIG/starship/starship.toml"
export STARSHIP_CACHE="$CONFIG/starship/cache"
