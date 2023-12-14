#!/bin/zsh

# declare global configuration variables

: ${HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,bold,fg=white,bold'}
: ${HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,bold,fg=white,bold'}
: ${HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'}
: ${HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=''}
: ${HISTORY_SUBSTRING_SEARCH_FUZZY=''}
: ${HISTORY_SUBSTRING_SEARCH_PREFIXED=''}

# declare internal global variables

typeset -g BUFFER MATCH MBEGIN MEND CURSOR
typeset -g _history_substring_search_refresh_display
typeset -g _history_substring_search_query_highlight
typeset -g _history_substring_search_result
typeset -g _history_substring_search_query
typeset -g -a _history_substring_search_query_parts
typeset -g -a _history_substring_search_raw_matches
typeset -g -i _history_substring_search_raw_match_index
typeset -g -a _history_substring_search_matches
typeset -g -i _history_substring_search_match_index
typeset -g -A _history_substring_search_unique_filter
typeset -g -i _history_substring_search_zsh_5_9

# the main ZLE widgets

history-substring-search-up() {
  _history-substring-search-begin

  _history-substring-search-up-history ||
  _history-substring-search-up-buffer ||
  _history-substring-search-up-search

  _history-substring-search-end
}

history-substring-search-down() {
  _history-substring-search-begin

  _history-substring-search-down-history ||
  _history-substring-search-down-buffer ||
  _history-substring-search-down-search

  _history-substring-search-end
}

zle -N history-substring-search-up
zle -N history-substring-search-down

# implementation details

zmodload -F zsh/parameter
autoload -Uz is-at-least

if is-at-least 5.9 $ZSH_VERSION; then
  _history_substring_search_zsh_5_9=1
fi

#
# We have to "override" some keys and widgets if the
# zsh-syntax-highlighting plugin has not been loaded:
#
# https://github.com/nicoulaj/zsh-syntax-highlighting
#
if [[ $+functions[_zsh_highlight] -eq 0 ]]; then
  #
  # Dummy implementation of _zsh_highlight() that
  # simply removes any existing highlights when the
  # user inserts printable characters into $BUFFER.
  #
  _zsh_highlight() {
    if [[ $KEYS == [[:print:]] ]]; then
      region_highlight=()
    fi
  }

  #
  # Check if $1 denotes the name of a callable function, i.e. it is fully
  # defined or it is marked for autoloading and autoloading it at the first
  # call to it will succeed. In particular, if $1 has been marked for
  # autoloading but is not available in $fpath, then it will return 1 (false).
  #
  # This is based on the zsh-syntax-highlighting plugin.
  #
  _history-substring-search-function-callable() {
    if (( ${+functions[$1]} )) && ! [[ "$functions[$1]" == *"builtin autoload -X"* ]]; then
      return 0 # already fully loaded
    else
      # "$1" is either an autoload stub, or not a function at all.
      # We expect 'autoload +X' to return non-zero if it fails to fully load
      # the function.
      ( autoload -U +X -- "$1" 2>/dev/null )
      return $?
    fi
  }

  if [[ $_history_substring_search_zsh_5_9 -eq 1 ]] && _history-substring-search-function-callable add-zle-hook-widget; then
    autoload -U add-zle-hook-widget

    _history-substring-search-zle-line-finish() {
      () {
        local -h -r WIDGET=zle-line-finish
        _zsh_highlight
      }
    }

    _history-substring-search-zle-line-pre-redraw() {
      if [[ $+ZSH_HIGHLIGHT_VERSION -eq 1 ]]; then
        autoload -U add-zle-hook-widget
        add-zle-hook-widget -d zle-line-pre-redraw _history-substring-search-zle-line-pre-redraw
        add-zle-hook-widget -d zle-line-finish _history-substring-search-zle-line-finish
        return 0
      fi
      true && _zsh_highlight "$@"
    }

    if [[ -o zle ]]; then
      add-zle-hook-widget zle-line-pre-redraw _history-substring-search-zle-line-pre-redraw
      add-zle-hook-widget zle-line-finish _history-substring-search-zle-line-finish
    fi
  else
    # Rebind all ZLE widgets to make them invoke _zsh_highlights.
    _zsh_highlight_bind_widgets()
    {
      # Load ZSH module zsh/zleparameter, needed to override user defined widgets.
      zmodload zsh/zleparameter 2>/dev/null || {
        echo 'zsh-syntax-highlighting: failed loading zsh/zleparameter.' >&2
        return 1
      }

      # Override ZLE widgets to make them invoke _zsh_highlight.
      local cur_widget
      for cur_widget in ${${(f)"$(builtin zle -la)"}:#(.*|_*|orig-*|run-help|which-command|beep|yank*)}; do
        case $widgets[$cur_widget] in

          # Already rebound event: do nothing.
          user:$cur_widget|user:_zsh_highlight_widget_*);;

          # User defined widget: override and rebind old one with prefix "orig-".
          user:*) eval "zle -N orig-$cur_widget ${widgets[$cur_widget]#*:}; \
                        _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                        zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

          # Completion widget: override and rebind old one with prefix "orig-".
          completion:*) eval "zle -C orig-$cur_widget ${${widgets[$cur_widget]#*:}/:/ }; \
                              _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                              zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

          # Builtin widget: override and make it call the builtin ".widget".
          builtin) eval "_zsh_highlight_widget_$cur_widget() { builtin zle .$cur_widget -- \"\$@\" && _zsh_highlight }; \
                         zle -N $cur_widget _zsh_highlight_widget_$cur_widget;;

          # Default: unhandled case.
          *) echo "zsh-syntax-highlighting: unhandled ZLE widget '$cur_widget'" >&2 ";;
        esac
      done
    }
    #-------------->8------------------->8------------------->8-----------------
    # SPDX-SnippetEnd

    _zsh_highlight_bind_widgets
  fi

  unfunction _history-substring-search-function-callable
fi

_history-substring-search-begin() {
  setopt localoptions extendedglob

  _history_substring_search_refresh_display=
  _history_substring_search_query_highlight=

  if [[ -n $BUFFER && $BUFFER == ${_history_substring_search_result:-} ]]; then
    return;
  fi

  # Clear the previous result.
  _history_substring_search_result=''

  if [[ -z $BUFFER ]]; then

    _history_substring_search_query=
    _history_substring_search_query_parts=()
    _history_substring_search_raw_matches=()

  else
    # For the purpose of highlighting we keep a copy of the original
    # query string.
    _history_substring_search_query=$BUFFER

    # compose search pattern
    if [[ -n $HISTORY_SUBSTRING_SEARCH_FUZZY ]]; then
      # `=` split string in arguments
      _history_substring_search_query_parts=(${=_history_substring_search_query})
    else
      _history_substring_search_query_parts=(${==_history_substring_search_query})
    fi

    local search_pattern="${(j:*:)_history_substring_search_query_parts[@]//(#m)[\][()|\\*?#<>~^]/\\$MATCH}*"

    if [[ -z $HISTORY_SUBSTRING_SEARCH_PREFIXED ]]; then
      search_pattern="*${search_pattern}"
    fi

    _history_substring_search_raw_matches=(${(k)history[(R)(#$HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS)${search_pattern}]})
  fi

  _history_substring_search_raw_match_index=0
  _history_substring_search_matches=()
  _history_substring_search_unique_filter=()

  if [[ $WIDGET == history-substring-search-down ]]; then
     _history_substring_search_match_index=1
  else
    _history_substring_search_match_index=0
  fi
}

_history-substring-search-end() {
  setopt localoptions extendedglob

  local highlight_memo=
  _history_substring_search_result=$BUFFER

  if [[ $_history_substring_search_zsh_5_9 -eq 1 ]]; then
    highlight_memo='memo=history-substring-search'
  fi

  # the search was successful so display the result properly by clearing away
  # existing highlights and moving the cursor to the end of the result buffer
  if [[ $_history_substring_search_refresh_display -eq 1 ]]; then
    if [[ -n $highlight_memo ]]; then
      region_highlight=( "${(@)region_highlight:#*${highlight_memo}*}" )
    else
      region_highlight=()
    fi
    CURSOR=${#BUFFER}
  fi

  # highlight command line using zsh-syntax-highlighting
  _zsh_highlight

  # highlight the search query inside the command line
  if [[ -n $_history_substring_search_query_highlight ]]; then
    # highlight first matching query parts
    local highlight_start_index=0
    local highlight_end_index=0
    local query_part
    for query_part in $_history_substring_search_query_parts; do
      local escaped_query_part=${query_part//(#m)[\][()|\\*?#<>~^]/\\$MATCH}
      # (i) get index of pattern
      local query_part_match_index="${${BUFFER:$highlight_start_index}[(i)(#$HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS)${escaped_query_part}]}"
      if [[ $query_part_match_index -le ${#BUFFER:$highlight_start_index} ]]; then
        highlight_start_index=$(( $highlight_start_index + $query_part_match_index ))
        highlight_end_index=$(( $highlight_start_index + ${#query_part} ))
        region_highlight+=(
          "$(($highlight_start_index - 1)) $(($highlight_end_index - 1)) ${_history_substring_search_query_highlight}${highlight_memo:+,$highlight_memo}"
        )
      fi
    done
  fi

  return 0
}

_history-substring-search-up-buffer() {
  local buflines XLBUFFER xlbuflines
  buflines=(${(f)BUFFER})
  XLBUFFER=$LBUFFER"x"
  xlbuflines=(${(f)XLBUFFER})

  if [[ $#buflines -gt 1 && $CURSOR -ne $#BUFFER && $#xlbuflines -ne 1 ]]; then
    zle up-line-or-history
    return 0
  fi

  return 1
}

_history-substring-search-down-buffer() {
  local buflines XRBUFFER xrbuflines
  buflines=(${(f)BUFFER})
  XRBUFFER="x"$RBUFFER
  xrbuflines=(${(f)XRBUFFER})

  if [[ $#buflines -gt 1 && $CURSOR -ne $#BUFFER && $#xrbuflines -ne 1 ]]; then
    zle down-line-or-history
    return 0
  fi

  return 1
}

_history-substring-search-up-history() {
  if [[ -z $_history_substring_search_query ]]; then

    if [[ $HISTNO -eq 1 ]]; then
      BUFFER=

    else
      zle up-line-or-history
    fi

    return 0
  fi

  return 1
}

_history-substring-search-down-history() {
  if [[ -z $_history_substring_search_query ]]; then

    if [[ $HISTNO -eq 1 && -z $BUFFER ]]; then
      BUFFER=${history[1]}
      _history_substring_search_refresh_display=1

    else
      zle down-line-or-history
    fi

    return 0
  fi

  return 1
}

_history_substring_search_process_raw_matches() {
  while [[ $_history_substring_search_raw_match_index -lt $#_history_substring_search_raw_matches ]]; do
    _history_substring_search_raw_match_index+=1
    local index=${_history_substring_search_raw_matches[$_history_substring_search_raw_match_index]}

    if [[ ! -o HIST_IGNORE_ALL_DUPS && -n $HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE ]]; then
      local entry=${history[$index]}

      if [[ -z ${_history_substring_search_unique_filter[$entry]} ]]; then
        _history_substring_search_unique_filter[$entry]=1
        _history_substring_search_matches+=($index)

        return 0
      fi

    else
      _history_substring_search_matches+=($index)
      return 0
    fi

  done

  return 1
}

_history-substring-search-has-next() {

  if  [[ $_history_substring_search_match_index -lt $#_history_substring_search_matches ]]; then
    return 0

  else
    _history_substring_search_process_raw_matches
    return $?
  fi
}

_history-substring-search-has-prev() {

  if [[ $_history_substring_search_match_index -gt 1 ]]; then
    return 0

  else
    return 1
  fi
}

_history-substring-search-found() {
  BUFFER=$history[$_history_substring_search_matches[$_history_substring_search_match_index]]
  _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
}

_history-substring-search-not-found() {
  BUFFER=$_history_substring_search_query
  _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
}

_history-substring-search-up-search() {
  _history_substring_search_refresh_display=1

  if [[ $_history_substring_search_match_index -gt $#_history_substring_search_matches ]]; then
    _history-substring-search-not-found
    return
  fi

  if _history-substring-search-has-next; then
    _history_substring_search_match_index+=1
    _history-substring-search-found

  else
    _history_substring_search_match_index+=1
    _history-substring-search-not-found
  fi

  if [[ -o HIST_IGNORE_ALL_DUPS || -n $HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE ]]; then
    return
  fi

  if [[ -o HIST_FIND_NO_DUPS && $BUFFER == $_history_substring_search_result ]]; then
    _history-substring-search-up-search
  fi
}

_history-substring-search-down-search() {
  _history_substring_search_refresh_display=1

  if [[ $_history_substring_search_match_index -lt 1 ]]; then
    _history-substring-search-not-found
    return
  fi

  if _history-substring-search-has-prev; then
    _history_substring_search_match_index+=-1
    _history-substring-search-found

  else
    _history_substring_search_match_index+=-1
    _history-substring-search-not-found
  fi

  if [[ -o HIST_IGNORE_ALL_DUPS || -n $HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE ]]; then
    return
  fi

  if [[ -o HIST_FIND_NO_DUPS && $BUFFER == $_history_substring_search_result ]]; then
    _history-substring-search-down-search
  fi
}

# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et

# $custom
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down