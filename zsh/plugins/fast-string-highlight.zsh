#!/bin/zsh

# vim:ft=zsh:sw=4:sts=4

#
# $1 - PREBUFFER
# $2 - BUFFER
#
function -fast-highlight-string-process {
    emulate -LR zsh
    setopt extendedglob warncreateglobal typesetsilent

    local -A pos_to_level level_to_pos pair_map final_pairs
    local input=$1$2 _mybuf=$1$2 __style __quoting
    integer __idx=0 __pair_idx __level=0 __start __end
    local -a match mbegin mend

    pair_map=( "(" ")" "{" "}" "[" "]" )

    while [[ $_mybuf = (#b)([^"{}()[]\\\"'"]#)((["({[]})\"'"])|[\\](*))(*) ]]; do
        if [[ -n ${match[4]} ]] {
            __idx+=${mbegin[2]}

            [[ $__quoting = \' ]] && _mybuf=${match[4]} || { _mybuf=${match[4]:1}; (( ++ __idx )); }
        } else {
            __idx+=${mbegin[2]}
            [[ -z $__quoting && -z ${_FAST_COMPLEX_BRACKETS[(r)$((__idx-${#PREBUFFER}-1))]} ]] && {
                if [[ ${match[2]} = ["({["] ]]; then
                    pos_to_level[$__idx]=$(( ++__level ))
                    level_to_pos[$__level]=$__idx
                elif [[ ${match[2]} = ["]})"] ]]; then
                    if (( __level > 0 )); then
                        __pair_idx=${level_to_pos[$__level]}
                        pos_to_level[$__idx]=$(( __level -- ))
                        [[ ${pair_map[${input[__pair_idx]}]} = ${input[__idx]} ]] && {
                            final_pairs[$__idx]=$__pair_idx
                            final_pairs[$__pair_idx]=$__idx
                        }
                    else
                        pos_to_level[$__idx]=-1
                    fi
                fi
            }

            if [[ ${match[2]} = \" && $__quoting != \' ]] {
                [[ $__quoting = '"' ]] && __quoting="" || __quoting='"';
            }
            if [[ ${match[2]} = \' && $__quoting != \" ]] {
                if [[ $__quoting = ("'"|"$'") ]] {
                    __quoting=""
                } else {
                    if [[ $match[1] = *\$ ]] {
                        __quoting="\$'";
                    } else {
                        __quoting="'";
                    }
                }
            }
            _mybuf=${match[5]}
        }
    done

    for __idx in ${(k)pos_to_level}; do
        (( ${+final_pairs[$__idx]} )) && __style=${FAST_THEME_NAME}bracket-level-$(( ( (pos_to_level[$__idx]-1) % 3 ) + 1 )) || __style=${FAST_THEME_NAME}unknown-token
        (( __start=__idx-${#PREBUFFER}-1, __end=__idx-${#PREBUFFER}, __start >= 0 )) && \
            reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}")
    done

    # If cursor is on a bracket, then highlight corresponding bracket, if any.
    if [[ $WIDGET != zle-line-finish ]]; then
        __idx=$(( CURSOR + 1 ))
        if (( ${+pos_to_level[$__idx]} )) && (( ${+final_pairs[$__idx]} )); then
            (( __start=final_pairs[$__idx]-${#PREBUFFER}-1, __end=final_pairs[$__idx]-${#PREBUFFER}, __start >= 0 )) && \
                reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}paired-bracket]}") && \
                reply+=("$CURSOR $__idx ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}paired-bracket]}")
        fi
    fi
    return 0
}