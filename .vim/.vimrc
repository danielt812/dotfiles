" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'lilydjwg/colorizer'
Plug 'mattn/emmet-vim'
Plug 'gko/vim-coloresque'
Plug 'Chiel92/vim-autoformat'
Plug 'jbgutierrez/vim-better-comments'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'pangloss/vim-javascript'
Plug 'tomasr/molokai'
Plug 'terryma/vim-multiple-cursors'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Add code line numbers
set number
" Auto indent next line
set autoindent
set encoding=UTF-8

" Fzf
set rtp+=/user/local/opt/fzf

" NerdTree config
nmap <S-tab> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Emmet config
let g:user_emmet_expandabbr_key='<Tab>'
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
" Autoformat config
au BufWrite * :Autoformat

" Tabs set to 2
set expandtab ts=2 sw=2 ai

" Color Scheme
set termguicolors
let g:panda_iterm_italic = 1
let g:panda_igui_italic = 1
syntax on
colorscheme panda

" Fix to slow scroll
set regexpengine=1

" Remove trailing space on save
autocmd BufWritePre *.py :%s/\s\+$//e

" Highlight search
set hlsearch

nnoremap <F3> :set hlsearch!<CR>

" Show partial matches for search
set is

	" Ignore case
	set ic

" Turn off end of line
set binary
set noeol

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''

" No Swp file
set noswapfile
