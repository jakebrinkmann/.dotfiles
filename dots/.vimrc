filetype indent plugin on
set term=xterm-256color
set t_Co=256
set nu " Line Numbers
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufWritePre *.{py,pro} :%s/^\s*__updated__\zs.*\ze/\=strftime(" = '%Y-%m-%d'")
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
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()
filetype plugin indent on

set foldmethod=indent
set foldlevel=99
nnoremap <space> za

let python_highlight_all=1
syntax on

let g:airline_theme='wombat'
set laststatus=2

nnoremap <C-n> :NERDTreeToggle<CR>

syntax enable
set background=dark
let g:solarized_termcolors=256
let g:solarized_degrade = 0
let g:solarized_bold = 1
let g:solarized_underline = 1
let g:solarized_italic = 1
let g:solarized_contrast = "normal"
let g:solarized_visibility= "normal"
colorscheme solarized
call togglebg#map("<F5>")

set cursorline

