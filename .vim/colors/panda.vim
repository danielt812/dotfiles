hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name="panda"

let s:panda_original = 0

hi Boolean         guifg=#AE81FF
hi Character       guifg=#E6DB74
hi Number          guifg=#AE81FF
hi String          guifg=#00ffff
hi Conditional     guifg=#F92672               gui=italic
hi Constant        guifg=#AE81FF               gui=italic
hi Cursor          guifg=#000000 guibg=#F8F8F0
hi iCursor         guifg=#000000 guibg=#F8F8F0
hi Debug           guifg=#BCA3A3               gui=none
hi Define          guifg=#00ffff
hi Delimiter       guifg=#8F8F8F
hi DiffAdd         guibg=#13354A
hi DiffChange      guifg=#89807D guibg=#4C4745
hi DiffDelete      guifg=#960050 guibg=#1E0010
hi DiffText        guibg=#4C4745 gui=italic

hi Directory       guifg=#FD971F             gui=none
hi Error           guifg=#E6DB74 guibg=#1E0010
hi ErrorMsg        guifg=#F92672 guibg=#232526 gui=none
hi Exception       guifg=#F92672            gui=none
hi Float           guifg=#AE81FF
hi FoldColumn      guifg=#465457 guibg=#000000
hi Folded          guifg=#465457 guibg=#000000
hi Function        guifg=#FD971F  gui=italic
hi Identifier      guifg=#FD971F
hi Ignore          guifg=#808080 guibg=bg
hi IncSearch       guifg=#C4BE89 guibg=#000000

hi Keyword         guifg=#F92672               gui=italic
hi Label           guifg=#E6DB74               gui=italic
hi Macro           guifg=#C4BE89               gui=italic
hi SpecialKey      guifg=#00ffff               gui=italic 

hi MatchParen      guifg=#000000 guibg=#FD971F gui=none
hi ModeMsg         guifg=#E6DB74
hi MoreMsg         guifg=#E6DB74
hi Operator        guifg=#F92672

hi Pmenu           guifg=#00ffff guibg=#000000
hi PmenuSel                      guibg=#808080
hi PmenuSbar                     guibg=#080808
hi PmenuThumb      guifg=#00ffff

hi PreCondit       guifg=#FD971F              gui=none
hi PreProc         guifg=#FD971F
hi Question        guifg=#00ffff
hi Repeat          guifg=#F92672               gui=none
hi Search          guifg=#000000 guibg=#FFE792

hi SignColumn      guifg=#A6E22E guibg=#232526
hi SpecialChar     guifg=#F92672               gui=none
hi SpecialComment  guifg=#7E8E91               gui=none
hi Special         guifg=#00ffff guibg=bg      gui=italic
if has("spell")
    hi SpellBad    guisp=#FF0000 gui=undercurl
    hi SpellCap    guisp=#7070F0 gui=undercurl
    hi SpellLocal  guisp=#70F0F0 gui=undercurl
    hi SpellRare   guisp=#FFFFFF gui=undercurl
endif
hi Statement       guifg=#F92672               gui=none
hi StatusLine      guifg=#455354 guibg=fg
hi StatusLineNC    guifg=#808080 guibg=#080808
hi StorageClass    guifg=#FD971F               gui=italic
hi Structure       guifg=#00ffff
hi Tag             guifg=#F92672               gui=italic
hi Title           guifg=#ffffff
hi Todo            guifg=#FFFFFF guibg=bg      gui=none

hi Typedef         guifg=#00ffff
hi Type            guifg=#FFB86C               gui=italic cterm=italic
hi Underlined      guifg=#808080               gui=underline

hi VertSplit       guifg=#808080 guibg=#080808 gui=none
hi VisualNOS                     guibg=#403D3D
hi Visual                        guibg=#403D3D
hi WarningMsg      guifg=#ffffff gui=italic
hi WildMenu        guifg=#00ffff guibg=#000000

hi TabLineFill     guifg=#1B1D1E guibg=#1B1D1E
hi TabLine         guibg=#1B1D1E guifg=#808080 gui=none


hi Normal          guifg=#F8F8F2 guibg=#1B1D1E
hi Comment         guifg=#7E8E91 cterm=italic
hi CursorLine                    guibg=#293739
hi CursorLineNr    guifg=#FD971F             gui=none
hi CursorColumn                  guibg=#293739
hi ColorColumn                   guibg=#232526
hi LineNr          guifg=#465457 guibg=#232526
hi NonText         guifg=#465457
hi SpecialKey      guifg=#465457

hi htmlTag                      guifg=#FD971F guibg=NONE gui=NONE
hi htmlEndTag                   guifg=#FD971F  guibg=NONE gui=NONE

hi javaScriptFunction           guifg=#ffb86c guibg=NONE gui=italic
hi javaScriptRailsFunction      guifg=#65bdff guibg=NONE gui=italic
hi javaScriptBraces             guifg=#FD971F guibg=NONE gui=italic

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark