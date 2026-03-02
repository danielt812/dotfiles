# Should be called before compinit
zmodload zsh/complist

autoload -Uz compinit
compinit -d ~/.zcompdump
_comp_options+=(globdots) # With hidden files

# setopt GLOB_COMPLETE      # Show autocompletion menu with globs
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

zle -C alias-expension complete-word _generic
bindkey '^Xa' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias

# Allow you to select in a menu
zstyle ':completion:*' menu yes select

bindkey '^[[Z' reverse-menu-complete

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification

# Corrections
zstyle ':completion:*:*:*:*:corrections' format '%F{11}!- %d (errors: %e) -!%f'
# Descriptions
zstyle ':completion:*:*:*:*:descriptions' format '%F{198}-- %D %d --%f'
# Messages
zstyle ':completion:*:*:*:*:messages' format ' %F{93} -- %d --%f'
# Warnings
zstyle ':completion:*:*:*:*:warnings' format ' %F{9}-- no matches found --%f'

# Automatically find new executables in path
zstyle ':completion:*' rehash true

# Colors for files and directory
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS} "ma=48;5;5;5"

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

