filetype indent plugin on
set term=xterm-256color
set t_Co=256
set nu " Line Numbers
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufWritePre *.{py,pro} :silent! %s/^\s*__updated__\zs.*\ze/\=strftime(" = '%Y-%m-%d'")
set colorcolumn=80
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'nanotech/jellybeans.vim' 
Bundle 'klen/python-mode'

call vundle#end()
filetype plugin indent on

set foldmethod=indent
set foldlevel=99
nnoremap <space> za

let python_highlight_all=1
let mapleader = ","
syntax on

let g:airline_theme='wombat'
set laststatus=2

nnoremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '/'

syntax enable
set background=dark
colorscheme jellybeans

set hlsearch
hi Search ctermbg=1

set cursorline

" Allow easy window control
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>

" Add json prettify
nnoremap <F5> :%!python -m json.tool<CR>
nnoremap <F6> :%!xmllint --format %<CR>
