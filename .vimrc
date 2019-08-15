set nocompatible
filetype off
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'gko/vim-coloresque'
Plug 'Chiel92/vim-autoformat'
Plug 'jbgutierrez/vim-better-comments'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'pangloss/vim-javascript'
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

" Color Scheme
set termguicolors
let g:panda_iterm_italic = 1
let g:panda_igui_italic = 1
syntax on
colorscheme panda

" Highlight search
set hls

" Show partial matches for search
set is

" Ignore case
set ic
