# History Location
export HISTFILE=$HOME/.zsh_history

# How many commands zsh will load to memory.
export HISTSIZE=10000

# How many commands history will save on file.
export SAVEHIST=10000

# man zshoptions /History
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
# setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_LEX_WORDS
setopt HIST_REDUCE_BLANKS