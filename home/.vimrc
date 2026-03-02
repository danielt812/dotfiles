" Helps force plugins to load correctly when it is turned back on below
filetype on

call plug#begin()
" tpope essentials
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'         " :S substitutions, case coercions (crs, crm, crc, cru)
Plug 'tpope/vim-eunuch'          " :Rename, :Move, :Delete, :SudoWrite, etc.
Plug 'tpope/vim-vinegar'         " Enhanced netrw (- to open, I for help)
Plug 'tpope/vim-obsession'       " Session management that plays nice with tmux
Plug 'tpope/vim-speeddating'     " C-a/C-x on dates, times, ordinals
Plug 'tpope/vim-rsi'             " Readline bindings in insert/command mode
Plug 'tpope/vim-dispatch'        " Async :Make and :Dispatch
Plug 'tpope/vim-projectionist'   " Project-aware alternate files and navigation
" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'         " GitHub handler for fugitive (:GBrowse)
Plug 'mhinz/vim-signify'
" ui
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'sainnhe/gruvbox-material'
call plug#end()

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

" Don't try to be vi compatible
set nocompatible

let mapleader = " "

" Security
set modelines=0

" Show line numbers
set number
set relativenumber

" Blink cursor on error instead of beeping
set visualbell

" Encoding
set encoding=utf-8

" Use sys clipboard
set clipboard=unnamedplus

" Whitespace
set textwidth=80
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:>
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Allow mouse scrolling
set mouse=a

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr>

" Remap help key
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
map <leader>l :set list!<CR>

" Fugitive
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gl :Git log --oneline<CR>

" Dispatch
nnoremap <leader>m :Make<CR>
nnoremap <leader>d :Dispatch<CR>

" Color scheme
set t_Co=256
set background=dark
set termguicolors
set t_ut=
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_enable_italic = 1
colorscheme gruvbox-material

" Lightline uses gruvbox-material
let g:lightline = {'colorscheme': 'gruvbox_material'}
