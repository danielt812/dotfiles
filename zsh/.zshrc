ZDOTDIR="$HOME/.config/zsh"
ZPLUGINDIR="$ZDOTDIR/plugins"

# ZSH Unplugged
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
	git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi

source "$ZPLUGINDIR/zsh_unplugged/zsh_unplugged.zsh"

REPOS=(
	zsh-users/zsh-syntax-highlighting
	zsh-users/zsh-history-substring-search
	zsh-users/zsh-autosuggestions
)

plugin-load $REPOS

# Source config files
source "$ZDOTDIR/completions.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/exports.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/options.zsh"

# FZF functions
source "$ZDOTDIR/fzf/cd.zsh"
source "$ZDOTDIR/fzf/git_branch.zsh"

# Check if zoxide command exists before evaluating its initialization script
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh)"
fi

# Check if starship command exists before evaluating its initialization script
if command -v starship &>/dev/null; then
	eval "$(starship init zsh)"
fi
