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
setopt SHARE_HISTORY               # Import new commands from the history file and append typed commands to it; replaces INC_APPEND_HISTORY and gives cross-shell visibility

# Force a full rewrite of $HISTFILE after every command. The in-memory list is
# already deduped (HIST_IGNORE_ALL_DUPS), so this keeps the file deduped too --
# SHARE_HISTORY's per-command appends never trigger HIST_SAVE_NO_DUPS on their own.
autoload -Uz add-zsh-hook
_zsh_history_dedup_write() { fc -W }
add-zsh-hook precmd _zsh_history_dedup_write
setopt HIST_LEX_WORDS              # Lexically analyze words when searching the history
setopt HIST_REDUCE_BLANKS          # Reduce consecutive blank lines in the history to a single entry

# Don't save lines whose command isn't resolvable (typos, missing binaries).
# Skips leading VAR=value assignments and checks the first real word with
# `whence`, which matches aliases, functions, builtins, reserved words, and
# anything on $PATH.
zshaddhistory() {
  # Reject lines not starting with an alpha character (after leading whitespace).
  local trimmed="${1#"${1%%[![:space:]]*}"}"
  [[ $trimmed == [a-zA-Z]* ]] || return 1

  local -a words=( ${(z)1} )
  local word
  for word in $words; do
    [[ $word == *=* ]] && continue
    whence -- "$word" &>/dev/null && return 0 || return 1
  done
  return 1
}
