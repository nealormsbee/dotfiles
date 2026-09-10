" I mostly used neovim these days.
" This is kept largely for historical purposes and will be removed from the
" repo eventually.

" Disable compatibility with vi.
set nocompatible

" File formatting and encoding.
set fileformat=unix
set encoding=utf-8

" Enable file type detection, and use file type-specific indentation and
" plugins.
filetype plugin indent on

" Enable syntax highlighting.
syntax on

" Show line numbers.
set number
" set relativenumber # show numbers relative to current position instead of line numbers. Maybe worth experimenting with.

" Don't wrap text.
set nowrap

" Line highlighting.
set cursorline 

" Show a gutter for errors to the left of numbers.
set signcolumn=yes

" Default indent/tab settings.
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
set smartindent
set smarttab

" No backup or swap files while editing, but keep a record of undos that persist across sessions.
set nobackup
set noswapfile
set undodir=~/.vim/undodir
set undofile

" No error sound when hitting line end, typing wrong command, etc.
set noerrorbells visualbell t_vb=

" Highlight matching characters during search.
set incsearch

" Case-insensitive search, unless capital letters are used.
set ignorecase
set smartcase

" Show matching words during search.
set showmatch

" Use search highlighting.
set hlsearch
nnoremap <CR> :noh<CR><CR>:<backspace>

" Show in-progress commands while typing.
set showcmd

" Show active mode (on by default).
set showmode

" BASH-like command autocompletion
set wildmenu
set wildmode=list:longest

" Tell wildmenu to ignore files that we shouldn't edit with vim (non-text
" files).
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" PLUGINS ---------------------------------------------------------------- {{{
" Plugins managed with vim-plug: https://github.com/junegunn/vim-plug

call plug#begin()

" Color schemes
Plug 'ajmwagar/vim-deus'
Plug 'Badacadabra/vim-archery'
Plug 'jacoborus/tender.vim'
Plug 'tomasiser/vim-code-dark'

" Linting via Async Lint Engine
Plug 'dense-analysis/ale'

" Typescript and React syntax highlighting
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" NERDTree
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin' " Git plugin for NERDTree
Plug 'ryanoasis/vim-devicons' " NERDTree file icons
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Colors for file icons

call plug#end()

" }}}

" Configure colorscheme
set termguicolors
colors tender

" ALE Config
let g:ale_lint_delay=0
let g:ale_lint_on_text_changed=0
let g:ale_lint_on_insert_leave=0
let g:ale_lint_on_save=1

" NERDTree config
" Automatically open NERDTree when Vim is opened with no args.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" MAPPINGS --------------------------------------------------------------- {{{

" Set Leader
let mapleader = ','

" Exit INSERT mode without pressing the escape key.
inoremap jj <esc>

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Easy use of go-to-definition capability
nnoremap <leader>, :ALEGoToDefinition<CR>

" NERDTree mappings
nnoremap <C-n> :NERDTreeFocus<CR>
nnoremap <leader>n :NERDTreeToggleVCS<CR><C-w>l
nnoremap <leader>f :NERDTreeFind<CR>

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" Only show highlighted line/cursor in the active buffer.
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline
    autocmd WinEnter * set cursorline
augroup END

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}
