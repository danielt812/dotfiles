#!/usr/local/bin/zsh

# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[cursor]:=standout}

# Whether the cursor highlighter should be called or not.
_zsh_highlight_highlighter_cursor_predicate()
{
  # remove cursor highlighting when the line is finished
  [[ $WIDGET == zle-line-finish ]] || _zsh_highlight_cursor_moved
}

# Cursor highlighting function.
_zsh_highlight_highlighter_cursor_paint()
{
  [[ $WIDGET == zle-line-finish ]] && return

  _zsh_highlight_add_highlight $CURSOR $(( $CURSOR + 1 )) cursor
}