
# man zshoptions /History

# History Location
export HISTFILE=$HOME/.zsh_history

# How many commands zsh will load to memory.
export HISTSIZE=10000

# How many commands history will save on file.
export SAVEHIST=10000

# Ensure that duplicate entries are expired first when writing history
setopt HIST_EXPIRE_DUPS_FIRST

# Ignore consecutive duplicates when adding commands to the history
setopt HIST_IGNORE_DUPS

# Ignore all duplicates when adding commands to the history
setopt HIST_IGNORE_ALL_DUPS

# Ignore commands starting with a space when adding to the history
setopt HIST_IGNORE_SPACE

# Avoid finding duplicates when searching the history
setopt HIST_FIND_NO_DUPS

# Do not save duplicate commands to the history
setopt HIST_SAVE_NO_DUPS

# Append new history entries to the history file instead of overwriting it
setopt APPEND_HISTORY

# Immediately append to the history file, instead of waiting until the shell exits
setopt INC_APPEND_HISTORY

# Lexically analyze words when searching the history
setopt HIST_LEX_WORDS

# Reduce consecutive blank lines in the history to a single entry
setopt HIST_REDUCE_BLANKS

