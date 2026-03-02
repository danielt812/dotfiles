# man zshoptions /History

export HISTFILE=$HOME/.zsh_history # History Location
export HISTSIZE=10000              # How many commands zsh will load to memory.
export SAVEHIST=10000              # How many commands history will save on file.
setopt HIST_EXPIRE_DUPS_FIRST      # Ensure that duplicate entries are expired first when writing history
setopt HIST_IGNORE_DUPS            # Ignore consecutive duplicates when adding commands to the history
setopt HIST_IGNORE_ALL_DUPS        # Ignore all duplicates when adding commands to the history
setopt HIST_IGNORE_SPACE           # Ignore commands starting with a space when adding to the history
setopt HIST_FIND_NO_DUPS           # Avoid finding duplicates when searching the history
setopt HIST_SAVE_NO_DUPS           # Do not save duplicate commands to the history
setopt APPEND_HISTORY              # Append new history entries to the history file instead of overwriting it
setopt INC_APPEND_HISTORY          # Immediately append to the history file, instead of waiting until the shell exits
setopt HIST_LEX_WORDS              # Lexically analyze words when searching the history
setopt HIST_REDUCE_BLANKS          # Reduce consecutive blank lines in the history to a single entry
