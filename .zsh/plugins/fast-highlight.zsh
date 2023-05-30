#!/usr/local/bin/zsh

# -*- mode: sh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-

typeset -gA __fast_highlight_main__command_type_cache FAST_BLIST_PATTERNS
typeset -g FAST_WORK_DIR
: ${FAST_WORK_DIR:=$FAST_BASE_DIR}
FAST_WORK_DIR=${~FAST_WORK_DIR}
() {
  # We must not use emulate -o if we want to keep compatibility with Zsh < v.5.0
  # See https://github.com/zdharma-continuum/fast-syntax-highlighting/pull/7
  emulate -L zsh
  setopt extendedglob
  local -A map
  map=( "XDG:"    "${XDG_CONFIG_HOME:-$HOME/.config}/fsh/"
        "LOCAL:"  "/usr/local/share/fsh/"
        "HOME:"   "$HOME/.fsh/"
        "OPT:"    "/opt/local/share/fsh/"
  )
  FAST_WORK_DIR=${${FAST_WORK_DIR/(#m)(#s)(XDG|LOCAL|HOME|OPT):(#c0,1)/${map[${MATCH%:}:]}}%/}
}

# Define default styles. You can set this after loading the plugin in
# Zshrc and use 256 colors via numbers, like: fg=150
# https://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png
# $custom
typeset -gA FAST_HIGHLIGHT_STYLES
: ${FAST_HIGHLIGHT_STYLES[default]:=none}
: ${FAST_HIGHLIGHT_STYLES[unknown-token]:=fg=9} # unknown ex: asdf
: ${FAST_HIGHLIGHT_STYLES[reserved-word]:=fg=yellow}
: ${FAST_HIGHLIGHT_STYLES[subcommand]:=fg=yellow}
: ${FAST_HIGHLIGHT_STYLES[alias]:=fg=10} # alias ex: brewup
: ${FAST_HIGHLIGHT_STYLES[suffix-alias]:=fg=green}
: ${FAST_HIGHLIGHT_STYLES[global-alias]:=bg=blue}
: ${FAST_HIGHLIGHT_STYLES[builtin]:=fg=10} # bash commands ex: echo
: ${FAST_HIGHLIGHT_STYLES[function]:=fg=10} # parse_git_branch
: ${FAST_HIGHLIGHT_STYLES[command]:=fg=10} # touch
: ${FAST_HIGHLIGHT_STYLES[precommand]:=fg=green}
: ${FAST_HIGHLIGHT_STYLES[commandseparator]:=none}
: ${FAST_HIGHLIGHT_STYLES[hashed-command]:=fg=green}
: ${FAST_HIGHLIGHT_STYLES[path]:=fg=magenta}
: ${FAST_HIGHLIGHT_STYLES[path-to-dir]:=fg=198,underline} # ~/Desktop
: ${FAST_HIGHLIGHT_STYLES[path_pathseparator]:=}
: ${FAST_HIGHLIGHT_STYLES[globbing]:=fg=blue,bold}
: ${FAST_HIGHLIGHT_STYLES[globbing-ext]:=fg=13}
: ${FAST_HIGHLIGHT_STYLES[history-expansion]:=fg=blue,bold}
: ${FAST_HIGHLIGHT_STYLES[single-hyphen-option]:=fg=cyan}
: ${FAST_HIGHLIGHT_STYLES[double-hyphen-option]:=fg=cyan}
: ${FAST_HIGHLIGHT_STYLES[back-quoted-argument]:=none}
: ${FAST_HIGHLIGHT_STYLES[single-quoted-argument]:=fg=11} # '$HOME'
: ${FAST_HIGHLIGHT_STYLES[double-quoted-argument]:=fg=11} # "$HOME"
: ${FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]:=fg=11} # $'HOME'
: ${FAST_HIGHLIGHT_STYLES[back-or-dollar-double-quoted-argument]:=fg=cyan}
: ${FAST_HIGHLIGHT_STYLES[back-dollar-quoted-argument]:=fg=cyan}
: ${FAST_HIGHLIGHT_STYLES[assign]:=none}
: ${FAST_HIGHLIGHT_STYLES[redirection]:=none}
: ${FAST_HIGHLIGHT_STYLES[comment]:=fg=black,bold}
: ${FAST_HIGHLIGHT_STYLES[variable]:=fg=15} # ex: $HOME
: ${FAST_HIGHLIGHT_STYLES[mathvar]:=fg=blue,bold}
: ${FAST_HIGHLIGHT_STYLES[mathnum]:=fg=magenta}
: ${FAST_HIGHLIGHT_STYLES[matherr]:=fg=9}
: ${FAST_HIGHLIGHT_STYLES[assign-array-bracket]:=fg=green}
: ${FAST_HIGHLIGHT_STYLES[for-loop-variable]:=none}
: ${FAST_HIGHLIGHT_STYLES[for-loop-operator]:=fg=yellow}
: ${FAST_HIGHLIGHT_STYLES[for-loop-number]:=fg=magenta}
: ${FAST_HIGHLIGHT_STYLES[for-loop-separator]:=fg=yellow,bold}
: ${FAST_HIGHLIGHT_STYLES[here-string-tri]:=fg=yellow}
: ${FAST_HIGHLIGHT_STYLES[here-string-text]:=bg=18}
: ${FAST_HIGHLIGHT_STYLES[here-string-var]:=fg=cyan,bg=18}
: ${FAST_HIGHLIGHT_STYLES[case-input]:=fg=blue}
: ${FAST_HIGHLIGHT_STYLES[case-parentheses]:=fg=yellow}
: ${FAST_HIGHLIGHT_STYLES[case-condition]:=bg=blue}
: ${FAST_HIGHLIGHT_STYLES[paired-bracket]:=bg=blue}
: ${FAST_HIGHLIGHT_STYLES[bracket-level-1]:=fg=green,bold}
: ${FAST_HIGHLIGHT_STYLES[bracket-level-2]:=fg=yellow,bold}
: ${FAST_HIGHLIGHT_STYLES[bracket-level-3]:=fg=cyan,bold}
: ${FAST_HIGHLIGHT_STYLES[single-sq-bracket]:=fg=green}
: ${FAST_HIGHLIGHT_STYLES[double-sq-bracket]:=fg=green}
: ${FAST_HIGHLIGHT_STYLES[double-paren]:=fg=yellow}
: ${FAST_HIGHLIGHT_STYLES[correct-subtle]:=fg=12}
: ${FAST_HIGHLIGHT_STYLES[incorrect-subtle]:=fg=9}
: ${FAST_HIGHLIGHT_STYLES[subtle-separator]:=fg=green}
: ${FAST_HIGHLIGHT_STYLES[subtle-bg]:=bg=18}
: ${FAST_HIGHLIGHT_STYLES[secondary]:=free}

# This can overwrite some of *_STYLES fields
[[ -r $FAST_WORK_DIR/theme_overlay.zsh ]] && source $FAST_WORK_DIR/theme_overlay.zsh

typeset -gA __FAST_HIGHLIGHT_TOKEN_TYPES

__FAST_HIGHLIGHT_TOKEN_TYPES=(

  # Precommand

  'builtin'     1
  'command'     1
  'exec'        1
  'nocorrect'   1
  'noglob'      1
  'pkexec'      1 # immune to #121 because it's usually not passed --option flags

  # Control flow
  # Tokens that, at (naively-determined) "command position", are followed by
  # a de jure command position.  All of these are reserved words.

  $'\x7b'   2 # block '{'
  $'\x28'   2 # subshell '('
  '()'      2 # anonymous function
  'while'   2
  'until'   2
  'if'      2
  'then'    2
  'elif'    2
  'else'    2
  'do'      2
  'time'    2
  'coproc'  2
  '!'       2 # reserved word; unrelated to $histchars[1]

  # Command separators

  '|'   3
  '||'  3
  ';'   3
  '&'   3
  '&&'  3
  '|&'  3
  '&!'  3
  '&|'  3
  # ### 'case' syntax, but followed by a pattern, not by a command
  # ';;' ';&' ';|'
)

# A hash instead of multiple globals
typeset -gA FAST_HIGHLIGHT

# Brackets highlighter active by default
: ${FAST_HIGHLIGHT[use_brackets]:=1}

FAST_HIGHLIGHT+=(
  chroma-fast-theme    →chroma/-fast-theme.ch
  chroma-alias         →chroma/-alias.ch
  chroma-autoload      →chroma/-autoload.ch
  chroma-autorandr     →chroma/-autorandr.ch
  chroma-docker        →chroma/-docker.ch
  chroma-example       →chroma/-example.ch
  chroma-ionice        →chroma/-ionice.ch
  chroma-make          →chroma/-make.ch
  chroma-nice          →chroma/-nice.ch
  chroma-nmcli         →chroma/-nmcli.ch
  chroma-node          →chroma/-node.ch
  chroma-perl          →chroma/-perl.ch
  chroma-printf        →chroma/-printf.ch
  chroma-ruby          →chroma/-ruby.ch
  chroma-scp           →chroma/-scp.ch
  chroma-ssh           →chroma/-ssh.ch

  chroma-git           →chroma/main-chroma.ch%git
  chroma-hub           →chroma/-hub.ch
  chroma-lab           →chroma/-lab.ch
  chroma-svn           →chroma/-subversion.ch
  chroma-svnadmin      →chroma/-subversion.ch
  chroma-svndumpfilter →chroma/-subversion.ch

  chroma-egrep         →chroma/-grep.ch
  chroma-fgrep         →chroma/-grep.ch
  chroma-grep          →chroma/-grep.ch

  chroma-awk           →chroma/-awk.ch
  chroma-gawk          →chroma/-awk.ch
  chroma-goawk         →chroma/-awk.ch
  chroma-mawk          →chroma/-awk.ch

  chroma-source        →chroma/-source.ch
  chroma-.             →chroma/-source.ch

  chroma-bash          →chroma/-sh.ch
  chroma-fish          →chroma/-sh.ch
  chroma-sh            →chroma/-sh.ch
  chroma-zsh           →chroma/-sh.ch

  chroma-whatis        →chroma/-whatis.ch
  chroma-man           →chroma/-whatis.ch

  chroma--             →chroma/-precommand.ch
  chroma-xargs         →chroma/-precommand.ch
  chroma-nohup         →chroma/-precommand.ch
  chroma-strace        →chroma/-precommand.ch
  chroma-ltrace        →chroma/-precommand.ch

  chroma-hg            →chroma/-subcommand.ch
  chroma-cvs           →chroma/-subcommand.ch
  chroma-pip           →chroma/-subcommand.ch
  chroma-pip2          →chroma/-subcommand.ch
  chroma-pip3          →chroma/-subcommand.ch
  chroma-gem           →chroma/-subcommand.ch
  chroma-bundle        →chroma/-subcommand.ch
  chroma-yard          →chroma/-subcommand.ch
  chroma-cabal         →chroma/-subcommand.ch
  chroma-npm           →chroma/-subcommand.ch
  chroma-nvm           →chroma/-subcommand.ch
  chroma-yarn          →chroma/-subcommand.ch
  chroma-brew          →chroma/-subcommand.ch
  chroma-port          →chroma/-subcommand.ch
  chroma-yum           →chroma/-subcommand.ch
  chroma-dnf           →chroma/-subcommand.ch
  chroma-tmux          →chroma/-subcommand.ch
  chroma-pass          →chroma/-subcommand.ch
  chroma-aws           →chroma/-subcommand.ch
  chroma-apt           →chroma/-subcommand.ch
  chroma-apt-get       →chroma/-subcommand.ch
  chroma-apt-cache     →chroma/-subcommand.ch
  chroma-aptitude      →chroma/-subcommand.ch
  chroma-keyctl        →chroma/-subcommand.ch
  chroma-systemctl     →chroma/-subcommand.ch
  chroma-asciinema     →chroma/-subcommand.ch
  chroma-ipfs          →chroma/-subcommand.ch
  chroma-zinit       →chroma/main-chroma.ch%zinit
  chroma-aspell        →chroma/-subcommand.ch
  chroma-bspc          →chroma/-subcommand.ch
  chroma-cryptsetup    →chroma/-subcommand.ch
  chroma-diskutil      →chroma/-subcommand.ch
  chroma-exercism      →chroma/-subcommand.ch
  chroma-gulp          →chroma/-subcommand.ch
  chroma-i3-msg        →chroma/-subcommand.ch
  chroma-openssl       →chroma/-subcommand.ch
  chroma-solargraph    →chroma/-subcommand.ch
  chroma-subliminal    →chroma/-subcommand.ch
  chroma-svnadmin      →chroma/-subcommand.ch
  chroma-travis        →chroma/-subcommand.ch
  chroma-udisksctl     →chroma/-subcommand.ch
  chroma-xdotool       →chroma/-subcommand.ch
  chroma-zmanage       →chroma/-subcommand.ch
  chroma-zsystem       →chroma/-subcommand.ch
  chroma-zypper        →chroma/-subcommand.ch

  chroma-fpath+=\(     →chroma/-fpath_peq.ch
  chroma-fpath=\(      →chroma/-fpath_peq.ch
  chroma-FPATH+=       →chroma/-fpath_peq.ch
  chroma-FPATH=        →chroma/-fpath_peq.ch
  #chroma-which        →chroma/-which.ch
  #chroma-vim          →chroma/-vim.ch
)

if [[ $OSTYPE == darwin* ]] {
  noglob unset FAST_HIGHLIGHT[chroma-man] FAST_HIGHLIGHT[chroma-whatis]
}

# Assignments seen, to know if math parameter exists
typeset -gA FAST_ASSIGNS_SEEN

# Exposing tokens found on command position,
# for other scripts to process
typeset -ga ZLAST_COMMANDS

# Get the type of a command.
#
# Uses the zsh/parameter module if available to avoid forks, and a
# wrapper around 'type -w' as fallback.
#
# Takes a single argument.
#
# The result will be stored in REPLY.
-fast-highlight-main-type() {
  REPLY=$__fast_highlight_main__command_type_cache[(e)$1]
  [[ -z $REPLY ]] && {

  if zmodload -e zsh/parameter; then
    if (( $+aliases[(e)$1] )); then
      REPLY=alias
    elif (( ${+galiases[(e)${(Q)1}]} )); then
      REPLY="global alias"
    elif (( $+functions[(e)$1] )); then
      REPLY=function
    elif (( $+builtins[(e)$1] )); then
      REPLY=builtin
    elif (( $+commands[(e)$1] )); then
      REPLY=command
    elif (( $+saliases[(e)${1##*.}] )); then
      REPLY='suffix alias'
    elif (( $reswords[(Ie)$1] )); then
      REPLY=reserved
    # zsh 5.2 and older have a bug whereby running 'type -w ./sudo' implicitly
    # runs 'hash ./sudo=/usr/local/bin/./sudo' (assuming /usr/local/bin/sudo
    # exists and is in $PATH).  Avoid triggering the bug, at the expense of
    # falling through to the $() below, incurring a fork.  (Issue #354.)
    #
    # The second disjunct mimics the isrelative() C call from the zsh bug.
    elif [[ $1 != */* || ${+ZSH_ARGZERO} = "1" ]] && ! builtin type -w -- $1 >/dev/null 2>&1; then
      REPLY=none
    fi
  fi

  [[ -z $REPLY ]] && REPLY="${$(LC_ALL=C builtin type -w -- $1 2>/dev/null)##*: }"

  [[ $REPLY = "none" ]] && {
    [[ -n ${FAST_BLIST_PATTERNS[(k)${${(M)1:#/*}:-$PWD/$1}]} ]] || {
      [[ -d $1 ]] && REPLY="dirpath" || {
        for cdpath_dir in $cdpath; do
          [[ -d $cdpath_dir/$1 ]] && { REPLY="dirpath"; break; }
        done
      }
    }
  }

  __fast_highlight_main__command_type_cache[(e)$1]=$REPLY

  }
}

# Below are variables that must be defined in outer
# scope so that they are reachable in *-process()
-fast-highlight-fill-option-variables() {
  if [[ -o ignore_braces ]] || eval '[[ -o ignore_close_braces ]] 2>/dev/null'; then
    FAST_HIGHLIGHT[right_brace_is_recognised_everywhere]=0
  else
    FAST_HIGHLIGHT[right_brace_is_recognised_everywhere]=1
  fi

  if [[ -o path_dirs ]]; then
    FAST_HIGHLIGHT[path_dirs_was_set]=1
  else
    FAST_HIGHLIGHT[path_dirs_was_set]=0
  fi

  if [[ -o multi_func_def ]]; then
    FAST_HIGHLIGHT[multi_func_def]=1
  else
    FAST_HIGHLIGHT[multi_func_def]=0
  fi

  if [[ -o interactive_comments ]]; then
    FAST_HIGHLIGHT[ointeractive_comments]=1
  else
    FAST_HIGHLIGHT[ointeractive_comments]=0
  fi
}

# Main syntax highlighting function.
-fast-highlight-process()
{
  emulate -L zsh
  setopt extendedglob bareglobqual nonomatch typesetsilent

  [[ $CONTEXT == "select" ]] && return 0

  (( FAST_HIGHLIGHT[path_dirs_was_set] )) && setopt PATH_DIRS
  (( FAST_HIGHLIGHT[ointeractive_comments] )) && local interactive_comments= # _set_ to empty

  # Variable declarations and initializations
  # in_array_assignment true between 'a=(' and the matching ')'
  # braces_stack: "R" for round, "Q" for square, "Y" for curly
  # _mybuf, cdpath_dir are used in sub-functions
  local _start_pos=$3 _end_pos __start __end highlight_glob=1 __arg __style in_array_assignment=0 MATCH expanded_path braces_stack __buf=$1$2 _mybuf __workbuf cdpath_dir active_command alias_target _was_double_hyphen=0 __nul=$'\0' __tmp
  # __arg_type can be 0, 1, 2 or 3, i.e. precommand, control flow, command separator
  # __idx and _end_idx are used in sub-functions
  # for this_word and next_word look below at commented integers and at state machine description
  integer __arg_type=0 MBEGIN MEND in_redirection __len=${#__buf} __PBUFLEN=${#1} already_added offset __idx _end_idx this_word=1 next_word=0 __pos  __asize __delimited=0 itmp iitmp
  local -a match mbegin mend __inputs __list

  # This comment explains the numbers:
  # BIT_for - word after reserved-word-recognized `for'
  # BIT_afpcmd - word after a precommand that can take options, like `command' and `exec'
  # integer BIT_start=1 BIT_regular=2 BIT_sudo_opt=4 BIT_sudo_arg=8 BIT_always=16 BIT_for=32 BIT_afpcmd=64
  # integer BIT_chroma=8192

  integer BIT_case_preamble=512 BIT_case_item=1024 BIT_case_nempty_item=2048 BIT_case_code=4096

  # Braces stack
  # T - typeset, local, etc.

  # State machine
  #
  # The states are:
  # - :__start:      Command word
  # - :sudo_opt:   A leading-dash option to sudo (such as "-u" or "-i")
  # - :sudo_arg:   The argument to a sudo leading-dash option that takes one,
  #                when given as a separate word; i.e., "foo" in "-u foo" (two
  #                words) but not in "-ufoo" (one word).
  # - :regular:    "Not a command word", and command delimiters are permitted.
  #                Mainly used to detect premature termination of commands.
  # - :always:     The word 'always' in the «{ foo } always { bar }» syntax.
  #
  # When the kind of a word is not yet known, $this_word / $next_word may contain
  # multiple states.  For example, after "sudo -i", the next word may be either
  # another --flag or a command name, hence the state would include both :__start:
  # and :sudo_opt:.
  #
  # The tokens are always added with both leading and trailing colons to serve as
  # word delimiters (an improvised array); [[ $x == *:foo:* ]] and x=${x//:foo:/}
  # will DTRT regardless of how many elements or repetitions $x has..
  #
  # Handling of redirections: upon seeing a redirection token, we must stall
  # the current state --- that is, the value of $this_word --- for two iterations
  # (one for the redirection operator, one for the word following it representing
  # the redirection target).  Therefore, we set $in_redirection to 2 upon seeing a
  # redirection operator, decrement it each iteration, and stall the current state
  # when it is non-zero.  Thus, upon reaching the next word (the one that follows
  # the redirection operator and target), $this_word will still contain values
  # appropriate for the word immediately following the word that preceded the
  # redirection operator.
  #
  # The "the previous word was a redirection operator" state is not communicated
  # to the next iteration via $next_word/$this_word as usual, but via
  # $in_redirection.  The value of $next_word from the iteration that processed
  # the operator is discarded.
  #

  # Command exposure for other scripts
  ZLAST_COMMANDS=()
  # Restart observing of assigns
  FAST_ASSIGNS_SEEN=()
  # Restart function's gathering
  FAST_HIGHLIGHT[chroma-autoload-elements]=""
  # Restart FPATH elements gathering
  FAST_HIGHLIGHT[chroma-fpath_peq-elements]=""
  # Restart svn zinit's ICE gathering
  FAST_HIGHLIGHT[chroma-zinit-ice-elements-svn]=0
  FAST_HIGHLIGHT[chroma-zinit-ice-elements-id-as]=""

  [[ -n $ZCALC_ACTIVE ]] && {
    _start_pos=0; _end_pos=__len; __arg=$__buf
    -fast-highlight-math-string
    return 0
  }

  # Processing buffer
  local proc_buf=$__buf needle
  for __arg in ${interactive_comments-${(z)__buf}} \
             ${interactive_comments+${(zZ+c+)__buf}}; do

    # Initialize $next_word to its default value?
    (( in_redirection = in_redirection > 0 ? in_redirection - 1 : in_redirection ));
    (( next_word = (in_redirection == 0) ? 2 : next_word )) # else Stall $next_word.
    (( next_word = next_word | (this_word & (BIT_case_code|8192)) ))

    # If we have a good delimiting construct just ending, and '{'
    # occurs, then respect this and go for alternate syntax, i.e.
    # treat '{' (\x7b) as if it's on command position
    [[ $__arg = '{' && $__delimited = 2 ]] && { (( this_word = (this_word & ~2) | 1 )); __delimited=0; }

    __asize=${#__arg}

    # Reset state of working variables
    already_added=0
    __style=${FAST_THEME_NAME}unknown-token
    (( this_word & 1 )) && { in_array_assignment=0; [[ $__arg == 'noglob' ]] && highlight_glob=0; }

    # Compute the new $_start_pos and $_end_pos, skipping over whitespace in $__buf.
    if [[ $__arg == ';' ]] ; then
      braces_stack=${braces_stack#T}
      __delimited=0

      # Both ; and \n are rendered as a ";" (SEPER) by the ${(z)..} flag.
      needle=$';\n'
      [[ $proc_buf = (#b)[^$needle]#([$needle]##)* ]] && offset=${mbegin[1]}-1
      (( _start_pos += offset ))
      (( _end_pos = _start_pos + __asize ))

      # Prepare next loop cycle
      (( this_word & BIT_case_item )) || { (( in_array_assignment )) && (( this_word = 2 | (this_word & BIT_case_code) )) || { (( this_word = 1 | (this_word & BIT_case_code) )); highlight_glob=1; }; }
      in_redirection=0

      # Chance to highlight ';'
      [[ ${proc_buf[offset+1]} != $'\n' ]] && {
        [[ ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}commandseparator]} != "none" ]] && \
          (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && \
            reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}commandseparator]}")
      }

      proc_buf=${proc_buf[offset + __asize + 1,__len]}
      _start_pos=$_end_pos
      continue
    else
      offset=0
      if [[ $proc_buf = (#b)(#s)(([[:space:]]|\\[[:space:]])##)* ]]; then
          # The first, outer parenthesis
          offset=${mend[1]}
      fi
      (( _start_pos += offset ))
      (( _end_pos = _start_pos + __asize ))

      # No-hit will result in value 0
      __arg_type=${__FAST_HIGHLIGHT_TOKEN_TYPES[$__arg]}
    fi

    (( this_word & 1 )) && ZLAST_COMMANDS+=( $__arg );

    proc_buf=${proc_buf[offset + __asize + 1,__len]}

    # Handle the INTERACTIVE_COMMENTS option.
    #
    # We use the (Z+c+) flag so the entire comment is presented as one token in $__arg.
    if [[ -n ${interactive_comments+'set'} && $__arg == ${histchars[3]}* ]]; then
      if (( this_word & 3 )); then
        __style=${FAST_THEME_NAME}comment
      else
        __style=${FAST_THEME_NAME}unknown-token # prematurely terminated
      fi
      # ADD
      (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}")
      _start_pos=$_end_pos
      continue
    fi

    # Redirection?
    [[ $__arg == (<0-9>|)(\<|\>)* && $__arg != (\<|\>)$'\x28'* && $__arg != "<<<" ]] && \
      in_redirection=2

    # Special-case the first word after 'sudo'.
    if (( ! in_redirection )); then
      (( this_word & 4 )) && [[ $__arg != -* ]] && (( this_word = this_word ^ 4 ))

      # Parse the sudo command line
      if (( this_word & 4 )); then
        case $__arg in
          # Flag that requires an argument
          '-'[Cgprtu])
                       (( this_word = this_word & ~1 ))
                       (( next_word = 8 | (this_word & BIT_case_code) ))
                       ;;
          # This prevents misbehavior with sudo -u -otherargument
          '-'*)
                       (( this_word = this_word & ~1 ))
                       (( next_word = next_word | 1 | 4 ))
                       ;;
        esac
      elif (( this_word & 8 )); then
        (( next_word = next_word | 4 | 1 ))
      elif (( this_word & 64 )); then
        [[ $__arg = -[pvV-]## && $active_command = "command" ]] && (( this_word = (this_word & ~1) | 2, next_word = (next_word | 65) & ~2 ))
        [[ $__arg = -[cla-]## && $active_command = "exec" ]] && (( this_word = (this_word & ~1) | 2, next_word = (next_word | 65) & ~2 ))
        [[ $__arg = \{[a-zA-Z_][a-zA-Z0-9_]#\} && $active_command = "exec" ]] && {
          # Highlight {descriptor} passed to exec
          (( this_word = (this_word & ~1) | 2, next_word = (next_word | 65) & ~2 ))
          (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}exec-descriptor]}")
          already_added=1
        }
      fi
   fi

   (( this_word & 8192 )) && {
     __list=( ${(z@)${aliases[$active_command]:-${active_command##*/}}##[[:space:]]#(command|builtin|exec|noglob|nocorrect|pkexec)[[:space:]]#} )
     ${${FAST_HIGHLIGHT[chroma-${__list[1]}]}%\%*} ${(M)FAST_HIGHLIGHT[chroma-${__list[1]}]%\%*} 0 "$__arg" $_start_pos $_end_pos 2>/dev/null && continue
   }

   (( this_word & 1 )) && {
     # !in_redirection needed particularly for exec {A}>b {C}>d
     (( !in_redirection )) && active_command=$__arg
     _mybuf=${${aliases[$active_command]:-${active_command##*/}}##[[:space:]]#(command|builtin|exec|noglob|nocorrect|pkexec)[[:space:]]#}
     [[ "$_mybuf" = (#b)(FPATH+(#c0,1)=)* ]] && _mybuf="${match[1]} ${(j: :)${(s,:,)${_mybuf#FPATH+(#c0,1)=}}}"
     [[ -n ${FAST_HIGHLIGHT[chroma-${_mybuf%% *}]} ]] && {
       __list=( ${(z@)_mybuf} )
       if (( ${#__list} > 1 )) || [[ $active_command != $_mybuf ]]; then
         __style=${FAST_THEME_NAME}alias
         (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}")

         ${${FAST_HIGHLIGHT[chroma-${__list[1]}]}%\%*} ${(M)FAST_HIGHLIGHT[chroma-${__list[1]}]%\%*} 1 "${__list[1]}" "-100000" $_end_pos 2>/dev/null || \
           (( this_word = next_word, next_word = 2 ))

         for _mybuf in "${(@)__list[2,-1]}"; do
           (( next_word = next_word | (this_word & (BIT_case_code|8192)) ))
           ${${FAST_HIGHLIGHT[chroma-${__list[1]}]}%\%*} ${(M)FAST_HIGHLIGHT[chroma-${__list[1]}]%\%*} 0 "$_mybuf" "-100000" $_end_pos 2>/dev/null || \
             (( this_word = next_word, next_word = 2 ))
         done

         # This might have been done multiple times in chroma, but
         # as _end_pos doesn't change, it can be done one more time
         _start_pos=$_end_pos

         continue
       else
         ${${FAST_HIGHLIGHT[chroma-${__list[1]}]}%\%*} ${(M)FAST_HIGHLIGHT[chroma-${__list[1]}]%\%*} 1 "$__arg" $_start_pos $_end_pos 2>/dev/null && continue
       fi
     } || (( 1 ))
   }

   expanded_path=""

   # The Great Fork: is this a command word?  Is this a non-command word?
   if (( this_word & 16 )) && [[ $__arg == 'always' ]]; then
     # try-always construct
     __style=${FAST_THEME_NAME}reserved-word # de facto a reserved word, although not de jure
     (( next_word = 1 | (this_word & BIT_case_code) ))
   elif (( (this_word & 1) && (in_redirection == 0) )) || [[ $braces_stack = T* ]]; then # T - typedef, etc.
     if (( __arg_type == 1 )); then
      __style=${FAST_THEME_NAME}precommand
      [[ $__arg = "command" || $__arg = "exec" ]] && (( next_word = next_word | 64 ))
     elif [[ $__arg = (sudo|doas) ]]; then
      __style=${FAST_THEME_NAME}precommand
      (( next_word = (next_word & ~2) | 4 | 1 ))
     else
       _mybuf=${${(Q)__arg}#\"}
       if (( ${+parameters} )) && \
          [[ $_mybuf = (#b)(*)(*)\$([a-zA-Z_][a-zA-Z0-9_]#|[0-9]##)(*) || \
             $_mybuf = (#b)(*)(*)\$\{([a-zA-Z_][a-zA-Z0-9_:-]#|[0-9]##)(*) ]] && \
         (( ${+parameters[${match[3]%%:-*}]} ))
       then
         -fast-highlight-main-type ${match[1]}${match[2]}${(P)match[3]%%:-*}${match[4]#\}}
       elif [[ $braces_stack = T* ]]; then # T - typedef, etc.
         REPLY=none
       else
         : ${expanded_path::=${~_mybuf}}
         -fast-highlight-main-type $expanded_path
       fi

      case $REPLY in
        reserved)       # reserved word
                        [[ $__arg = "[[" ]] && __style=${FAST_THEME_NAME}double-sq-bracket || __style=${FAST_THEME_NAME}reserved-word
                        if [[ $__arg == $'\x7b' ]]; then # Y - '{'
                          braces_stack='Y'$braces_stack

                        elif [[ $__arg == $'\x7d' && $braces_stack = Y* ]]; then # Y - '}'
                          # We're at command word, so no need to check right_brace_is_recognised_everywhere
                          braces_stack=${braces_stack#Y}
                          __style=${FAST_THEME_NAME}reserved-word
                          (( next_word = next_word | 16 ))

                        elif [[ $__arg == "[[" ]]; then  # A - [[
                          braces_stack='A'$braces_stack

                          # Counting complex brackets (for brackets-highlighter): 1. [[ as command
                          _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN + 1 )) )
                        elif [[ $__arg == "for" ]]; then
                          (( next_word = next_word | 32 )) # BIT_for

                        elif [[ $__arg == "case" ]]; then
                          (( next_word = BIT_case_preamble ))

                        elif [[ $__arg = (typeset|declare|local|float|integer|export|readonly) ]]; then
                          braces_stack='T'$braces_stack
                        fi
                        ;;
        'suffix alias') __style=${FAST_THEME_NAME}suffix-alias;;
        'global alias') __style=${FAST_THEME_NAME}global-alias;;

        alias)
                          if [[ $__arg = ?*'='* ]]; then
                            # The so called (by old code) "insane_alias"
                            __style=${FAST_THEME_NAME}unknown-token
                          else
                            __style=${FAST_THEME_NAME}alias
                            (( ${+aliases} )) && alias_target=${aliases[$__arg]} || alias_target="${"$(alias -- $__arg)"#*=}"
                            [[ ${__FAST_HIGHLIGHT_TOKEN_TYPES[$alias_target]} = "1" && $__arg_type != "1" ]] && __FAST_HIGHLIGHT_TOKEN_TYPES[$__arg]="1"
                          fi
                        ;;

        builtin)        [[ $__arg = "[" ]] && {
                          __style=${FAST_THEME_NAME}single-sq-bracket
                          _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) )
                        } || __style=${FAST_THEME_NAME}builtin
                        # T - typeset, etc. mode
                        [[ $__arg = (typeset|declare|local|float|integer|export|readonly) ]] && braces_stack='T'$braces_stack
                        [[ $__arg = eval ]] && (( next_word = next_word | 256 ))
                        ;;

        function)       __style=${FAST_THEME_NAME}function;;

        command)        __style=${FAST_THEME_NAME}command;;

        hashed)         __style=${FAST_THEME_NAME}hashed-command;;

        dirpath)        __style=${FAST_THEME_NAME}path-to-dir;;

        none)           # Assign?
                        if [[ $__arg == [a-zA-Z_][a-zA-Z0-9_]#(|\[[^\]]#\])(|[^\]]#\])(|[+])=* || $__arg == [0-9]##(|[+])=* || ( $braces_stack = T* && ${__arg_type} != 3 ) ]] {
                          __style=${FAST_THEME_NAME}assign
                          FAST_ASSIGNS_SEEN[${__arg%%=*}]=1

                          # Handle array assignment
                          [[ $__arg = (#b)*=(\()*(\))* || $__arg = (#b)*=(\()* ]] && {
                              (( __start=_start_pos-__PBUFLEN+${mbegin[1]}-1, __end=__start+1, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}assign-array-bracket]}")
                              # Counting complex brackets (for brackets-highlighter): 2. ( in array assign
                              _FAST_COMPLEX_BRACKETS+=( $__start )
                              (( mbegin[2] >= 1 )) && {
                                (( __start=_start_pos-__PBUFLEN+${mbegin[2]}-1, __end=__start+1, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}assign-array-bracket]}")
                                # Counting complex brackets (for brackets-highlighter): 3a. ) in array assign
                                _FAST_COMPLEX_BRACKETS+=( $__start )
                              } || in_array_assignment=1
                          } || { [[ ${braces_stack[1]} != 'T' ]] && (( next_word = (next_word | 1) & ~2 )); }

                          # Handle no-string highlight, string "/' highlight, math mode highlight
                          local ctmp="\"" dtmp="'"
                          itmp=${__arg[(i)$ctmp]}-1 iitmp=${__arg[(i)$dtmp]}-1
                          integer jtmp=${__arg[(b:itmp+2:i)$ctmp]} jjtmp=${__arg[(b:iitmp+2:i)$dtmp]}
                          (( itmp < iitmp && itmp <= __asize - 1 )) && (( jtmp > __asize && (jtmp = __asize), 1 > 0 )) && \
                              (( __start=_start_pos-__PBUFLEN+itmp, __end=_start_pos-__PBUFLEN+jtmp, __start >= 0 )) && \
                                  reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-quoted-argument]}") && \
                                      { itmp=${__arg[(i)=]}; __arg=${__arg[itmp,__asize]}; (( _start_pos += itmp - 1 ));
                                        -fast-highlight-string; (( _start_pos = _start_pos - itmp + 1, 1 > 0 )); } || \
                          {
                              (( iitmp <= __asize - 1 )) && (( jjtmp > __asize && (jjtmp = __asize), 1 > 0 )) && \
                                  (( __start=_start_pos-__PBUFLEN+iitmp, __end=_start_pos-__PBUFLEN+jjtmp, __start >= 0 )) && \
                                      reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}single-quoted-argument]}")
                          } || \
                            {
                                itmp=${__arg[(i)=]}; __arg=${__arg[itmp,__asize]}; (( _start_pos += itmp - 1 ));
                                [[ ${__arg[2,4]} = '$((' ]] && { -fast-highlight-math-string;
                                   (( __start=_start_pos-__PBUFLEN+2, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}")
                                   # Counting complex brackets (for brackets-highlighter): 4. $(( in assign argument
                                   _FAST_COMPLEX_BRACKETS+=( $__start $(( __start + 1 )) )
                                   (( jtmp = ${__arg[(I)\)\)]}-1, jtmp > 0 )) && {
                                     (( __start=_start_pos-__PBUFLEN+jtmp, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}")
                                     # Counting complex brackets (for brackets-highlighter): 5. )) in assign argument
                                     _FAST_COMPLEX_BRACKETS+=( $__start $(( __start + 1 )) )
                                   }
                                } || -fast-highlight-string;
                                (( _start_pos = _start_pos - itmp + 1, 1 > 0 ))
                            }

                        } elif [[ $__arg = ${histchars[1]}* && -n ${__arg[2]} ]] {
                          __style=${FAST_THEME_NAME}history-expansion

                        } elif [[ $__arg == ${histchars[2]}* ]] {
                          __style=${FAST_THEME_NAME}history-expansion

                        } elif (( __arg_type == 3 )) {
                          # This highlights empty commands (semicolon follows nothing) as an error.
                          # Zsh accepts them, though.
                          (( this_word & 3 )) && __style=${FAST_THEME_NAME}commandseparator

                        } elif [[ $__arg[1,2] == '((' ]] {
                          # Arithmetic evaluation.
                          #
                          # Note: prior to zsh-5.1.1-52-g4bed2cf (workers/36669), the ${(z)...}
                          # splitter would only output the '((' token if the matching '))' had
                          # been typed.  Therefore, under those versions of zsh, BUFFER="(( 42"
                          # would be highlighted as an error until the matching "))" are typed.
                          #
                          # We highlight just the opening parentheses, as a reserved word; this
                          # is how [[ ... ]] is highlighted, too.

                          # ADD
                          (( __start=_start_pos-__PBUFLEN, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}")
                          already_added=1

                          # Counting complex brackets (for brackets-highlighter): 6. (( as command
                          _FAST_COMPLEX_BRACKETS+=( $__start $(( __start + 1 )) )

                          -fast-highlight-math-string

                          # ADD
                          [[ $__arg[-2,-1] == '))' ]] && {
                            (( __start=_end_pos-__PBUFLEN-2, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}")
                            (( __delimited = __delimited ? 2 : __delimited ))

                            # Counting complex brackets (for brackets-highlighter): 7. )) for as-command ((
                            _FAST_COMPLEX_BRACKETS+=( $__start $(( __start + 1 )) )
                          }

                        } elif [[ $__arg == '()' ]] {
                          _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN + 1 )) )
                          # anonymous function
                          __style=${FAST_THEME_NAME}reserved-word
                        } elif [[ $__arg == $'\x28' ]] {
                          # subshell '(', stack: letter 'R'
                          __style=${FAST_THEME_NAME}reserved-word
                          braces_stack='R'$braces_stack

                        } elif [[ $__arg == $'\x29' ]] {
                          # ')', stack: letter 'R' for subshell
                          [[ $braces_stack = R* ]] && { braces_stack=${braces_stack#R}; __style=${FAST_THEME_NAME}reserved-word; }

                        } elif (( this_word & 14 )) {
                          __style=${FAST_THEME_NAME}default

                        } elif [[ $__arg = (';;'|';&'|';|') ]] && (( this_word & BIT_case_code )) {
                          (( next_word = (next_word | BIT_case_item) & ~(BIT_case_code+3) ))
                          __style=${FAST_THEME_NAME}default

                        } elif [[ $__arg = \$\([^\(]* ]] {
                          already_added=1
                        }
                        ;;
        *)
                        # ADD
                        # (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end commandtypefromthefuture-$REPLY")
                        already_added=1
                        ;;
      esac
     fi
   # in_redirection || BIT_regular || BIT_sudo_opt || BIT_sudo_arg
   elif (( in_redirection + this_word & 14 ))
   then # $__arg is a non-command word
      case $__arg in
        ']]')
                 # A - [[
                 [[ $braces_stack = A* ]] && {
                   __style=${FAST_THEME_NAME}double-sq-bracket
                   (( __delimited = __delimited ? 2 : __delimited ))
                   # Counting complex brackets (for brackets-highlighter): 8a. ]] for as-command [[
                   _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN+1 )) )
                 } || {
                   [[ $braces_stack = *A* ]] && {
                      __style=${FAST_THEME_NAME}unknown-token
                      # Counting complex brackets (for brackets-highlighter): 8b. ]] for as-command [[
                      _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN+1 )) )
                   } || __style=${FAST_THEME_NAME}default
                 }
                 braces_stack=${braces_stack#A}
                 ;;
        ']')
                 __style=${FAST_THEME_NAME}single-sq-bracket
                 _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) )
                 ;;
        $'\x28')
                 # '(' inside [[
                 __style=${FAST_THEME_NAME}reserved-word
                 braces_stack='R'$braces_stack
                 ;;
        $'\x29') # ')' - subshell or end of array assignment
                 if (( in_array_assignment )); then
                   in_array_assignment=0
                   (( next_word = next_word | 1 ))
                   (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}assign-array-bracket]}")
                   already_added=1
                   # Counting complex brackets (for brackets-highlighter): 3b. ) in array assign
                   _FAST_COMPLEX_BRACKETS+=( $__start )
                 elif [[ $braces_stack = R* ]]; then
                   braces_stack=${braces_stack#R}
                   __style=${FAST_THEME_NAME}reserved-word
                 # Zsh doesn't tokenize final ) if it's just single ')',
                 # but logically what's below is correct, so it is kept
                 # in case Zsh will be changed / fixed, etc.
                 elif [[ $braces_stack = F* ]]; then
                   __style=${FAST_THEME_NAME}builtin
                 fi
                 ;;
        $'\x28\x29') # '()' - possibly a function definition
                 # || false # TODO: or if the previous word was a command word
                 (( FAST_HIGHLIGHT[multi_func_def] )) && (( next_word = next_word | 1 ))
                 __style=${FAST_THEME_NAME}reserved-word
                 _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN + 1 )) )
                 # Remove possible annoying unknown-token __style, or misleading function __style
                 reply[-1]=()
                 __fast_highlight_main__command_type_cache[$active_command]="function"
                 ;;
        '--'*)   [[ $__arg == "--" ]] && { _was_double_hyphen=1; __style=${FAST_THEME_NAME}double-hyphen-option; } || {
                   (( !_was_double_hyphen )) && {
                     [[ "$__arg" = (#b)(--[a-zA-Z0-9_]##)=(*) ]] && {
                       (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && \
                         reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-hyphen-option]}")
                       (( __start=_start_pos-__PBUFLEN+1+mend[1], __end=_end_pos-__PBUFLEN, __start >= 0 )) && \
                        reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}optarg-${${${(M)match[2]:#<->}:+number}:-string}]}")
                       already_added=1
                     } || __style=${FAST_THEME_NAME}double-hyphen-option
                   } || __style=${FAST_THEME_NAME}default
                 }
                 ;;
        '-'*)    (( !_was_double_hyphen )) && __style=${FAST_THEME_NAME}single-hyphen-option || __style=${FAST_THEME_NAME}default;;
        \$\'*)
                 (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}dollar-quoted-argument]}")
                 -fast-highlight-dollar-string
                 already_added=1
                 ;;
        [\"\']*|[^\"\\]##([\\][\\])#\"*|[^\'\\]##([\\][\\])#\'*)
                 # 256 is eval-mode
                 if (( this_word & 256 )) && [[ $__arg = [\'\"]* ]]; then
                   (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && \
                     reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}recursive-base]}")
                   if [[ -n ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]} ]]; then
                     __idx=1
                     _mybuf=$FAST_THEME_NAME
                     FAST_THEME_NAME=${${${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]}:t:r}#(XDG|LOCAL|HOME|OPT):}
                     (( ${+FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}default]} )) || source $FAST_WORK_DIR/secondary_theme.zsh
                   else
                     __idx=0
                   fi
                   (( _start_pos-__PBUFLEN >= 0 )) && \
                     -fast-highlight-process "$PREBUFFER" "${${__arg%[\'\"]}#[\'\"]}" $(( _start_pos + 1 ))
                   (( __idx )) && FAST_THEME_NAME=$_mybuf
                   already_added=1
                 else
                   [[ $__arg = *([^\\][\#][\#]|"(#b)"|"(#B)"|"(#m)"|"(#c")* && $highlight_glob -ne 0 ]] && \
                     (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && \
                       reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}globbing-ext]}")
                   # Reusing existing vars, treat this code like C++ STL
                   # header, full of underscores and unhelpful var names
                   itmp=0 __workbuf=$__arg __tmp="" cdpath_dir=$__arg
                   while [[ $__workbuf = (#b)[^\"\'\\]#(([\"\'])|[\\](*))(*) ]]; do
                     [[ -n ${match[3]} ]] && {
                       itmp+=${mbegin[1]}
                       # Optionally skip 1 quoted char
                       [[ $__tmp = \' ]] && __workbuf=${match[3]} || { itmp+=1; __workbuf=${match[3]:1}; }
                     } || {
                       itmp+=${mbegin[1]}
                       __workbuf=${match[4]}
                       # Toggle quoting
                       [[ ( ${match[1]} = \" && $__tmp != \' ) || ( ${match[1]} = \' && $__tmp != \" ) ]] && {
                         [[ $__tmp = [\"\'] ]] && {
                           # End of quoting
                           (( __start=_start_pos-__PBUFLEN+iitmp-1, __end=_start_pos-__PBUFLEN+itmp, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}${${${__tmp#\'}:+double-quoted-argument}:-single-quoted-argument}]}")
                           already_added=1

                           [[ $__tmp = \" ]] && {
                             __arg=${cdpath_dir[iitmp+1,itmp-1]}
                             (( _start_pos += iitmp - 1 + 1 ))
                             -fast-highlight-string
                             (( _start_pos = _start_pos - iitmp + 1 - 1 ))
                           }
                           # The end-of-quoting proper algorithm action
                           __tmp=
                         } || {
                           # Beginning of quoting
                           iitmp=itmp
                           # The beginning-of-quoting proper algorithm action
                           __tmp=${match[1]}
                         }
                       }
                     }
                   done
                   [[ $__tmp = [\"\'] ]] && {
                     (( __start=_start_pos-__PBUFLEN+iitmp-1, __end=_start_pos-__PBUFLEN+__asize, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}${${${__tmp#\'}:+double-quoted-argument}:-single-quoted-argument}]}")
                     already_added=1

                     [[ $__tmp = \" ]] && {
                       __arg=${cdpath_dir[iitmp+1,__asize]}
                       (( _start_pos += iitmp - 1 + 1 ))
                       -fast-highlight-string
                       (( _start_pos = _start_pos - iitmp + 1 - 1 ))
                     }
                   }
                 fi
                 ;;
        \$\(\(*)
                 already_added=1
                 -fast-highlight-math-string
                 # ADD
                 (( __start=_start_pos-__PBUFLEN+1, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}")
                 # Counting complex brackets (for brackets-highlighter): 9. $(( as argument
                 _FAST_COMPLEX_BRACKETS+=( $__start $(( __start + 1 )) )
                 # ADD
                 [[ $__arg[-2,-1] == '))' ]] && (( __start=_end_pos-__PBUFLEN-2, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}")
                 # Counting complex brackets (for brackets-highlighter): 10. )) for as-argument $((
                 _FAST_COMPLEX_BRACKETS+=( $__start $(( __start + 1 )) )
                 ;;
        '`'*)
                 (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && \
                   reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}back-quoted-argument]}")
                 if [[ -n ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]} ]]; then
                   __idx=1
                   _mybuf=$FAST_THEME_NAME
                   FAST_THEME_NAME=${${${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]}:t:r}#(XDG|LOCAL|HOME|OPT):}
                   (( ${+FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}default]} )) || source $FAST_WORK_DIR/secondary_theme.zsh
                 else
                   __idx=0
                 fi
                 (( _start_pos-__PBUFLEN >= 0 )) && \
                   -fast-highlight-process "$PREBUFFER" "${${__arg%[\`]}#[\`]}" $(( _start_pos + 1 ))
                 (( __idx )) && FAST_THEME_NAME=$_mybuf
                 already_added=1
          ;;
        '((')    # 'F' - (( after for
                 (( this_word & 32 )) && {
                   braces_stack='F'$braces_stack
                   __style=${FAST_THEME_NAME}double-paren
                   # Counting complex brackets (for brackets-highlighter): 11. (( as for-syntax
                   _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN+1 )) )
                   # This is set after __arg_type == 2, and also here,
                   # when another alternate-syntax capable command occurs
                   __delimited=1
                 }
                 ;;
        '))')    # 'F' - (( after for
                 [[ $braces_stack = F* ]] && {
                   braces_stack=${braces_stack#F}
                   __style=${FAST_THEME_NAME}double-paren
                   # Counting complex brackets (for brackets-highlighter): 12. )) as for-syntax
                   _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN+1 )) )
                   (( __delimited = __delimited ? 2 : __delimited ))
                 }
                 ;;
        '<<<')
                 (( next_word = (next_word | 128) & ~3 ))
                 [[ ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-tri]} != "none" ]] && (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-tri]}")
                 already_added=1
                 ;;
        *)       # F - (( after for
                 if [[ $braces_stack = F* ]]; then
                   -fast-highlight-string
                   _mybuf=$__arg
                   __idx=_start_pos
                   while [[ $_mybuf = (#b)[^a-zA-Z\{\$]#([a-zA-Z][a-zA-Z0-9]#)(*) ]]; do
                     (( __start=__idx-__PBUFLEN+${mbegin[1]}-1, __end=__idx-__PBUFLEN+${mend[1]}+1-1, __start >= 0 )) && \
                       reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}for-loop-variable]}")
                     __idx+=${mend[1]}
                     _mybuf=${match[2]}
                   done

                   _mybuf=$__arg
                   __idx=_start_pos
                   while [[ $_mybuf = (#b)[^+\<\>=:\*\|\&\^\~-]#([+\<\>=:\*\|\&\^\~-]##)(*) ]]; do
                     (( __start=__idx-__PBUFLEN+${mbegin[1]}-1, __end=__idx-__PBUFLEN+${mend[1]}+1-1, __start >= 0 )) && \
                       reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}for-loop-operator]}")
                     __idx+=${mend[1]}
                     _mybuf=${match[2]}
                   done

                   _mybuf=$__arg
                   __idx=_start_pos
                   while [[ $_mybuf = (#b)[^0-9]#([0-9]##)(*) ]]; do
                     (( __start=__idx-__PBUFLEN+${mbegin[1]}-1, __end=__idx-__PBUFLEN+${mend[1]}+1-1, __start >= 0 )) && \
                       reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}for-loop-number]}")
                     __idx+=${mend[1]}
                     _mybuf=${match[2]}
                   done

                   if [[ $__arg = (#b)[^\;]#(\;)[\ ]# ]]; then
                     (( __start=_start_pos-__PBUFLEN+${mbegin[1]}-1, __end=_start_pos-__PBUFLEN+${mend[1]}+1-1, __start >= 0 )) && \
                       reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}for-loop-separator]}")
                   fi

                   already_added=1
                 elif [[ $__arg = *([^\\][\#][\#]|"(#b)"|"(#B)"|"(#m)"|"(#c")* ]]; then
                   (( highlight_glob )) && __style=${FAST_THEME_NAME}globbing-ext || __style=${FAST_THEME_NAME}default
                 elif [[ $__arg = ([*?]*|*[^\\][*?]*) ]]; then
                   (( highlight_glob )) && __style=${FAST_THEME_NAME}globbing || __style=${FAST_THEME_NAME}default
                 elif [[ $__arg = \$* ]]; then
                   __style=${FAST_THEME_NAME}variable
                 elif [[ $__arg = $'\x7d' && $braces_stack = Y* && ${FAST_HIGHLIGHT[right_brace_is_recognised_everywhere]} = "1" ]]; then
                   # right brace, i.e. $'\x7d' == '}'
                   # Parsing rule: # {
                   #
                   #     Additionally, `tt(})' is recognized in any position if neither the
                   #     tt(IGNORE_BRACES) option nor the tt(IGNORE_CLOSE_BRACES) option is set."""
                   braces_stack=${braces_stack#Y}
                   __style=${FAST_THEME_NAME}reserved-word
                   (( next_word = next_word | 16 ))
                 elif [[ $__arg = (';;'|';&'|';|') ]] && (( this_word & BIT_case_code )); then
                   (( next_word = (next_word | BIT_case_item) & ~(BIT_case_code+3) ))
                   __style=${FAST_THEME_NAME}default
                 elif [[ $__arg = ${histchars[1]}* && -n ${__arg[2]} ]]; then
                   __style=${FAST_THEME_NAME}history-expansion
                 elif (( __arg_type == 3 )); then
                   __style=${FAST_THEME_NAME}commandseparator
                 elif (( in_redirection == 2 )); then
                   __style=${FAST_THEME_NAME}redirection
                 elif (( ${+galiases[(e)${(Q)__arg}]} )); then
                   __style=${FAST_THEME_NAME}global-alias
                 else
                   if [[ ${FAST_HIGHLIGHT[no_check_paths]} != 1 ]]; then
                     if [[ ${FAST_HIGHLIGHT[use_async]} != 1 ]]; then
		       if -fast-highlight-check-path noasync; then
			 # ADD
			 (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}")
                         already_added=1

                         # TODO: path separators, optimize and add to async code-path
                         [[ -n ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path_pathseparator]} && ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path]} != ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path_pathseparator]} ]] && {
                           for (( __pos = _start_pos; __pos <= _end_pos; __pos++ )) ; do
                             # ADD
                             [[ ${__buf[__pos]} == "/" ]] && (( __start=__pos-__PBUFLEN, __start >= 0 )) && reply+=("$(( __start - 1 )) $__start ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path_pathseparator]}")
                           done
                         }
                       else
                         __style=${FAST_THEME_NAME}default
		       fi
		     else
		       if [[ -z ${FAST_HIGHLIGHT[cache-path-${(q)__arg}-${_start_pos}]} || $(( EPOCHSECONDS - FAST_HIGHLIGHT[cache-path-${(q)__arg}-${_start_pos}-born-at] )) -gt 8 ]]; then
			 if [[ $LASTWIDGET != *-or-beginning-search ]]; then
			   exec {PCFD}< <(-fast-highlight-check-path; sleep 5)
			   command sleep 0
			   FAST_HIGHLIGHT[path-queue]+=";$_start_pos $_end_pos;"
			   is-at-least 5.0.6 && __pos=1 || __pos=0
			   zle -F ${${__pos:#0}:+-w} $PCFD fast-highlight-check-path-handler
                           already_added=1
                         else
                           __style=${FAST_THEME_NAME}default
			 fi
		       elif [[ ${FAST_HIGHLIGHT[cache-path-${(q)__arg}-${_start_pos}]%D} -eq 1 ]]; then
                         (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path${${(M)FAST_HIGHLIGHT[cache-path-${(q)__arg}-${_start_pos}]%D}:+-to-dir}]}")
			 already_added=1
		       else
			 __style=${FAST_THEME_NAME}default
		       fi
                     fi
                   else
                     __style=${FAST_THEME_NAME}default
                   fi
                 fi
                 ;;
      esac
    elif (( this_word & 128 ))
    then
      (( next_word = (next_word | 2) & ~129 ))
      [[ ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-text]} != "none" ]] && (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-text]}")
      -fast-highlight-string ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-var]:#none}
      already_added=1
    elif (( this_word & (BIT_case_preamble + BIT_case_item) ))
    then
      if (( this_word & BIT_case_preamble )); then
        [[ $__arg = "in" ]] && {
          __style=${FAST_THEME_NAME}reserved-word
          (( next_word = BIT_case_item ))
        } || {
          __style=${FAST_THEME_NAME}case-input
          (( next_word = BIT_case_preamble ))
        }
      else
        if (( this_word & BIT_case_nempty_item == 0 )) && [[ $__arg = "esac" ]]; then
          (( next_word = 1 ))
          __style=${FAST_THEME_NAME}reserved-word
        elif [[ $__arg = (\(*\)|\)|\() ]]; then
          [[ $__arg = *\) ]] && (( next_word = BIT_case_code | 1 )) || (( next_word = BIT_case_item | BIT_case_nempty_item ))
          _FAST_COMPLEX_BRACKETS+=( $(( _start_pos-__PBUFLEN )) )
          (( ${#__arg} > 1 )) && {
            _FAST_COMPLEX_BRACKETS+=( $(( _start_pos+${#__arg}-1-__PBUFLEN )) )
            (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && \
              reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}case-parentheses]}")
            (( __start=_start_pos+1-__PBUFLEN, __end=_end_pos-1-__PBUFLEN, __start >= 0 )) && \
              reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}case-condition]}")
            already_added=1
          } || {
            __style=${FAST_THEME_NAME}case-parentheses
          }
        else
          (( next_word = BIT_case_item | BIT_case_nempty_item ))
          __style=${FAST_THEME_NAME}case-condition
        fi
      fi
    fi
    if [[ $__arg = (#b)*'#'(([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])|([0-9a-fA-F])([0-9a-fA-F])([0-9a-fA-F]))(|[^[:alnum:]]*) || $__arg = (#b)*'rgb('(([0-9a-fA-F][0-9a-fA-F](#c0,1)),([0-9a-fA-F][0-9a-fA-F](#c0,1)),([0-9a-fA-F][0-9a-fA-F](#c0,1)))* ]]; then
      if [[ -n $match[2] ]]; then
        if [[ $match[2] = ?? || $match[3] = ?? || $match[4] = ?? ]]; then
          (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end bg=#${(l:2::0:)match[2]}${(l:2::0:)match[3]}${(l:2::0:)match[4]}")
        else
          (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end bg=#$match[2]$match[3]$match[4]")
        fi
      else
        (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end bg=#$match[5]$match[6]$match[7]")
      fi
      already_added=1
    fi

    # ADD
    (( already_added == 0 )) && [[ ${FAST_HIGHLIGHT_STYLES[$__style]} != "none" ]] && (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}")

    if (( (__arg_type == 3) && ((this_word & (BIT_case_preamble|BIT_case_item)) == 0) )); then
      if [[ $__arg == ';' ]] && (( in_array_assignment )); then
        # literal newline inside an array assignment
        (( next_word = 2 | (next_word & BIT_case_code) ))
      elif [[ -n ${braces_stack[(r)A]} ]]; then
        # 'A' in stack -> inside [[ ... ]]
        (( next_word = 2 | (next_word & BIT_case_code) ))
      else
        braces_stack=${braces_stack#T}
        (( next_word = 1 | (next_word & BIT_case_code) ))
        highlight_glob=1
        # A new command means that we should not expect that alternate
        # syntax will occur (this is also in the ';' short-path), but
        # || and && mean going down just 1 step, not all the way to 0
        [[ $__arg != ("||"|"&&") ]] && __delimited=0 || (( __delimited = __delimited == 2 ? 1 : __delimited ))
      fi
    elif (( ( (__arg_type == 1) || (__arg_type == 2) ) && (this_word & 1) )); then # (( __arg_type == 1 || __arg_type == 2 )) && (( this_word & 1 ))
        __delimited=1
        (( next_word = 1 | (next_word & (64 | BIT_case_code)) ))
    elif [[ $__arg == "repeat" ]] && (( this_word & 1 )); then
      __delimited=1
      # skip the repeat-count word
      in_redirection=2
      # The redirection mechanism assumes $this_word describes the word
      # following the redirection.  Make it so.
      #
      # That word can be a command word with shortloops (`repeat 2 ls`)
      # or a command separator (`repeat 2; ls` or `repeat 2; do ls; done`).
      #
      # The repeat-count word will be handled like a redirection target.
      (( this_word = 3 ))
    fi
    _start_pos=$_end_pos
    # This is the default/common codepath.
    (( this_word = in_redirection == 0 ? next_word : this_word )) #else # Stall $this_word.
  done

  # Do we have whole buffer? I.e. start at zero
  [[ $3 != 0 ]] && return 0

  # The loop overwrites ")" with "x", except those from $( ) substitution
  #
  # __pos: current nest level, starts from 0
  # __workbuf: copy of __buf, with limit on 250 characters
  # __idx: index in whole command line buffer
  # __list: list of coordinates of ) which shouldn't be ovewritten
  _mybuf=${__buf[1,250]} __workbuf=$_mybuf __idx=0 __pos=0 __list=()

  while [[ $__workbuf = (#b)[^\(\)]#([\(\)])(*) ]]; do
    if [[ ${match[1]} == \( ]]; then
      __arg=${_mybuf[__idx+${mbegin[1]}-1,__idx+${mbegin[1]}-1+2]}
      [[ $__arg = '$('[^\(] ]] && __list+=( $__pos )
      [[ $__arg = '$((' ]] && _mybuf[__idx+${mbegin[1]}-1]=x
      # Increase parenthesis level
      __pos+=1
    else
      # Decrease parenthesis level
      __pos=__pos-1
      [[ -z ${__list[(r)$__pos]} ]] && [[ $__pos -gt 0 ]] && _mybuf[__idx+${mbegin[1]}]=x
    fi
    __idx+=${mbegin[2]}-1
    __workbuf=${match[2]}
  done

  # Run on fake buffer with replaced parentheses: ")" into "x"
  if [[ "$_mybuf" = *$__nul* ]]; then
    # Try to avoid conflict with the \0, however
    # we have to split at *some* character - \7
    # is ^G, so one cannot have null and ^G at
    # the same time on the command line
    __nul=$'\7'
  fi

  __inputs=( ${(ps:$__nul:)${(S)_mybuf//(#b)*\$\(([^\)]#)(\)|(#e))/${mbegin[1]};${mend[1]}${__nul}}%$__nul*} )
  if [[ "${__inputs[1]}" != "$_mybuf" && -n "${__inputs[1]}" ]]; then
    if [[ -n ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]} ]]; then
      __idx=1
      __tmp=$FAST_THEME_NAME
      FAST_THEME_NAME=${${${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]}:t:r}#(XDG|LOCAL|HOME|OPT):}
      (( ${+FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}default]} )) || source $FAST_WORK_DIR/secondary_theme.zsh
    else
      __idx=0
    fi
    for _mybuf in $__inputs; do
      (( __start=${_mybuf%%;*}-__PBUFLEN-1, __end=${_mybuf##*;}-__PBUFLEN, __start >= 0 )) && \
        reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${__tmp}recursive-base]}")
      # Pass authentic buffer for recursive analysis
      -fast-highlight-process "$PREBUFFER" "${__buf[${_mybuf%%;*},${_mybuf##*;}]}" $(( ${_mybuf%%;*} - 1 ))
    done
    # Restore theme
    (( __idx )) && FAST_THEME_NAME=$__tmp
  fi

  return 0
}

-fast-highlight-check-path()
{
  (( _start_pos-__PBUFLEN >= 0 )) || \
    { [[ $1 != "noasync" ]] && print -r -- "- $_start_pos $_end_pos"; return 1; }
  [[ $1 != "noasync" ]] && {
    print -r -- ${sysparams[pid]}
    # This is to fill cache
    print -r -- $__arg
  }

  : ${expanded_path:=${(Q)~__arg}}
  [[ -n ${FAST_BLIST_PATTERNS[(k)${${(M)expanded_path:#/*}:-$PWD/$expanded_path}]} ]] && { [[ $1 != "noasync" ]] && print -r -- "- $_start_pos $_end_pos"; return 1; }

  [[ -z $expanded_path ]] && { [[ $1 != "noasync" ]] && print -r -- "- $_start_pos $_end_pos"; return 1; }
  [[ -d $expanded_path ]] && { [[ $1 != "noasync" ]] && print -r -- "$_start_pos ${_end_pos}D" || __style=${FAST_THEME_NAME}path-to-dir; return 0; }
  [[ -e $expanded_path ]] && { [[ $1 != "noasync" ]] && print -r -- "$_start_pos $_end_pos" || __style=${FAST_THEME_NAME}path; return 0; }

  # Search the path in CDPATH, only for CD command
  [[ $active_command = "cd" ]] && for cdpath_dir in $cdpath; do
    [[ -d $cdpath_dir/$expanded_path ]] && { [[ $1 != "noasync" ]] && print -r -- "$_start_pos ${_end_pos}D" || __style=${FAST_THEME_NAME}path-to-dir; return 0; }
    [[ -e $cdpath_dir/$expanded_path ]] && { [[ $1 != "noasync" ]] && print -r -- "$_start_pos $_end_pos" || __style=${FAST_THEME_NAME}path; return 0; }
  done

  # It's not a path.
  [[ $1 != "noasync" ]] && print -r -- "- $_start_pos $_end_pos"
  return 1
}

-fast-highlight-check-path-handler() {
  local IFS=$'\n' pid PCFD=$1 line stripped val
  integer idx

  if read -r -u $PCFD pid; then
    if read -r -u $PCFD val; then
      if read -r -u $PCFD line; then
        stripped=${${line#- }%D}
        FAST_HIGHLIGHT[cache-path-${(q)val}-${stripped%% *}-born-at]=$EPOCHSECONDS
        idx=${${FAST_HIGHLIGHT[path-queue]}[(I)$stripped]}
        (( idx > 0 )) && {
          if [[ $line != -* ]]; then
            FAST_HIGHLIGHT[cache-path-${(q)val}-${stripped%% *}]="1${(M)line%D}"
            region_highlight+=("${line%% *} ${${line##* }%D} ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path${${(M)line%D}:+-to-dir}]}")
          else
            FAST_HIGHLIGHT[cache-path-${(q)val}-${stripped%% *}]=0
          fi
          val=${FAST_HIGHLIGHT[path-queue]}
          val[idx-1,idx+${#stripped}]=""
          FAST_HIGHLIGHT[path-queue]=$val
          [[ ${FAST_HIGHLIGHT[cache-path-${(q)val}-${stripped%% *}]%D} = 1 && ${#val} -le 27 ]] && zle -R
        }
      fi
    fi
    kill -9 $pid 2>/dev/null
  fi

  zle -F -w ${PCFD}
  exec {PCFD}<&-
}

zle -N -- fast-highlight-check-path-handler -fast-highlight-check-path-handler

# Highlight special blocks inside double-quoted strings
#
# The while [[ ... ]] pattern is logically ((A)|(B)|(C)|(D)|(E))(*), where:
# - A matches $var[abc]
# - B matches ${(...)var[abc]}
# - C matches $
# - D matches \$ or \" or \'
# - E matches \*
#
# and the first condition -n ${match[7] uses D to continue searching when
# backslash-something (not ['"$]) is occured.
#
# $1 - additional style to glue-in to added style
-fast-highlight-string()
{
  (( _start_pos-__PBUFLEN >= 0 )) || return 0
  _mybuf=$__arg
  __idx=_start_pos

  #                                                                                                                                                                                                    7   8
  while [[ $_mybuf = (#b)[^\$\\]#((\$(#B)([#+^=~](#c1,2))(#c0,1)(#B)([a-zA-Z_:][a-zA-Z0-9_:]#|[0-9]##)(#b)(\[[^\]]#\])(#c0,1))|(\$[{](#B)([#+^=~](#c1,2))(#c0,1)(#b)(\([a-zA-Z0-9_:@%#]##\))(#c0,1)[a-zA-Z0-9_:#]##(\[[^\]]#\])(#c0,1)[}])|\$|[\\][\'\"\$]|[\\](*))(*) ]]; do
    [[ -n ${match[7]} ]] && {
      # Skip following char – it is quoted. Choice is
      # made to not highlight such quoting
      __idx+=${mbegin[1]}+1
      _mybuf=${match[7]:1}
    } || {
      __idx+=${mbegin[1]}-1
      _end_idx=__idx+${mend[1]}-${mbegin[1]}+1
      _mybuf=${match[8]}

      # ADD
      (( __start=__idx-__PBUFLEN, __end=_end_idx-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${${1:+$1}:-${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}back-or-dollar-double-quoted-argument]}}")

      __idx=_end_idx
    }
  done
  return 0
}

# Highlight math and non-math context variables inside $(( )) and (( ))
#
# The while [[ ... ]] pattern is logically ((A)|(B)|(C)|(D))(*), where:
# - A matches $var[abc]
# - B matches ${(...)var[abc]}
# - C matches $
# - D matches words [a-zA-Z]## (variables)
#
# Parameters used: _mybuf, __idx, _end_idx, __style
-fast-highlight-math-string()
{
  (( _start_pos-__PBUFLEN >= 0 )) || return 0
  _mybuf=$__arg
  __idx=_start_pos

  #                                                                                                                                                                                                                       7
  while [[ $_mybuf = (#b)[^\$_a-zA-Z0-9]#((\$(#B)(+|)(#B)([a-zA-Z_:][a-zA-Z0-9_:]#|[0-9]##)(#b)(\[[^\]]##\])(#c0,1))|(\$[{](#B)(+|)(#b)(\([a-zA-Z0-9_:@%#]##\))(#c0,1)[a-zA-Z0-9_:#]##(\[[^\]]##\])(#c0,1)[}])|\$|[a-zA-Z_][a-zA-Z0-9_]#|[0-9]##)(*) ]]; do
    __idx+=${mbegin[1]}-1
    _end_idx=__idx+${mend[1]}-${mbegin[1]}+1
    _mybuf=${match[7]}

    [[ ${match[1]} = [0-9]* ]] && __style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}mathnum]} || {
      [[ ${match[1]} = [a-zA-Z_]* ]] && {
        [[ ${+parameters[${match[1]}]} = 1 || ${FAST_ASSIGNS_SEEN[${match[1]}]} = 1 ]] && \
            __style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}mathvar]} || \
            __style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}matherr]}
      } || {
        [[ ${match[1]} = "$"* ]] && {
          match[1]=${match[1]//[\{\}+]/}
          if [[ ${match[1]} = "$" || ${FAST_ASSIGNS_SEEN[${match[1]:1}]} = 1 ]] || \
            { eval "[[ -n \${(P)\${match[1]:1}} ]]" } 2>> /dev/null; then
                __style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}back-or-dollar-double-quoted-argument]}
          else
            __style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}matherr]}
          fi
        }
      }
    }

    # ADD
    [[ $__style != "none" && -n $__style ]] && (( __start=__idx-__PBUFLEN, __end=_end_idx-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end $__style")

    __idx=_end_idx
  done
}

# Highlight special chars inside dollar-quoted strings
-fast-highlight-dollar-string()
{
  (( _start_pos-__PBUFLEN >= 0 )) || return 0
  local i j k __style
  local AA
  integer c

  # Starting dollar-quote is at 1:2, so __start parsing at offset 3 in the string.
  for (( i = 3 ; i < _end_pos - _start_pos ; i += 1 )) ; do
    (( j = i + _start_pos - 1 ))
    (( k = j + 1 ))

    case ${__arg[$i]} in
      "\\") __style=${FAST_THEME_NAME}back-dollar-quoted-argument
            for (( c = i + 1 ; c <= _end_pos - _start_pos ; c += 1 )); do
              [[ ${__arg[$c]} != ([0-9xXuUa-fA-F]) ]] && break
            done
            AA=$__arg[$i+1,$c-1]
            # Matching for HEX and OCT values like \0xA6, \xA6 or \012
            if [[    "$AA" == (#m)(#s)(x|X)[0-9a-fA-F](#c1,2)
                  || "$AA" == (#m)(#s)[0-7](#c1,3)
                  || "$AA" == (#m)(#s)u[0-9a-fA-F](#c1,4)
                  || "$AA" == (#m)(#s)U[0-9a-fA-F](#c1,8)
               ]]; then
              (( k += MEND ))
              (( i += MEND ))
            else
              if (( __asize > i+1 )) && [[ $__arg[i+1] == [xXuU] ]]; then
                # \x not followed by hex digits is probably an error
                __style=${FAST_THEME_NAME}unknown-token
              fi
              (( k += 1 )) # Color following char too.
              (( i += 1 )) # Skip parsing the escaped char.
            fi
            ;;
      *) continue ;;

    esac
    # ADD
    (( __start=j-__PBUFLEN, __end=k-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}")
  done
}

-fast-highlight-init() {
  _FAST_COMPLEX_BRACKETS=()
  __fast_highlight_main__command_type_cache=()
}

typeset -ga FSH_LIST
-fsh_sy_h_shappend() {
    FSH_LIST+=( "$(( $1 - 1 ));;$(( $2 ))" )
}

functions -M fsh_sy_h_append 2 2 -fsh_sy_h_shappend 2>/dev/null

zle_highlight=('paste:none')

# vim:ft=zsh:sw=2:sts=2