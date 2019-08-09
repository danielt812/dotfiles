" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'codehearts/mascara-vim'
Plug 'mattn/emmet-vim'
Plug 'gko/vim-coloresque'
Plug 'Chiel92/vim-autoformat'
Plug 'jbgutierrez/vim-better-comments'
Plug 'markvincze/panda-vim'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

set encoding=UTF-8

" NerdTree config
nmap <S-tab> :NERDTreeToggle<CR>

" Emmet config

let g:user_emmet_expandabbr_key='<Tab>'
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
" Autoformat config
au BufWrite * :Autoformat

" Add numbers
set number

" Tabs set to 2
set expandtab ts=2 sw=2 ai

" Enable italic font
set t_ZH=^[[3m
set t_ZR=^[[23m

" Mascara config
let g:mascara_apply_at_startup = 1
let g:mascara_italic = [ 'Comment', 'Conditional', 'Identifier', 'Repeat', 'Statement', 'Type', 'htmlItalic', 'markdownItalic' ]

" Syntax on
syntax on

" Color Scheme Panda Sytnax
colorscheme panda

set term=xterm-256color

