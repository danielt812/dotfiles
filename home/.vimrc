set nocompatible
syntax on
filetype plugin indent on

" --- Essentials ---
set undofile
set confirm
set autoread
set ttimeout ttimeoutlen=100
set noswapfile

" --- Editing ---
set tabstop=2 shiftwidth=2 expandtab
set autoindent
set backspace=indent,eol,start
set list listchars=tab:▸\ ,trail:·

" --- Search ---
set ignorecase smartcase
set incsearch hlsearch

" --- UI ---
set number
set scrolloff=5
set laststatus=2
set wildmenu
set mouse=a
let &fillchars = "eob: "
colorscheme habamax

" --- Folds ---
set foldmethod=indent foldlevelstart=99

" --- Navigation ---
set splitbelow splitright

" --- Cursor ---
let &t_EI = "\e[2 q"
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"

" --- Keymaps ---
" Shift lines (single key; visual keeps selection)
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

" Move by display lines
nnoremap j gj
nnoremap k gk

" Blank line below / above, cursor stays put
nnoremap <silent> go :<C-u>call append(line('.'),   repeat([''], v:count1))<CR>
nnoremap <silent> gO :<C-u>call append(line('.')-1, repeat([''], v:count1))<CR>

" Esc clears search highlight
nnoremap <silent> <Esc> :nohlsearch<CR>

" Alt-hjkl: move lines / indent
if !has('gui_running')
  execute "set <M-h>=\eh"
  execute "set <M-j>=\ej"
  execute "set <M-k>=\ek"
  execute "set <M-l>=\el"
endif
nnoremap <silent> <M-j> :m .+1<CR>==
nnoremap <silent> <M-k> :m .-2<CR>==
nnoremap <silent> <M-h> <<
nnoremap <silent> <M-l> >>
xnoremap <silent> <M-j> :m '>+1<CR>gv=gv
xnoremap <silent> <M-k> :m '<-2<CR>gv=gv
xnoremap <silent> <M-h> <gv
xnoremap <silent> <M-l> >gv

" --- Autocmds ---
augroup vimrc
  autocmd!
  autocmd VimEnter * silent execute "!printf '\e[2 q'"
  autocmd VimLeave * silent execute "!printf '\e[5 q'"
  autocmd FileType * setlocal formatoptions-=r formatoptions-=o
augroup END
