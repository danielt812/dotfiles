" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
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
autocmd BufWritePre * :%s/\s\+$//e

" Highlight search
set hlsearch

" Show partial matches for search
set is

" Ignore case
set ic

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''

" No Swp file
set noswapfile
