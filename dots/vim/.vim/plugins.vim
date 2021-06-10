" Auto-install plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fJLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins {{{
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale', { 'for': ['python', 'javascript', 'json'] }
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'jmcantrell/vim-virtualenv', { 'for': ['python'] }
" Plug 'joereynolds/sql-lint', {'do': 'npm install -g sql-lint'}
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'kassio/neoterm'
Plug 'majutsushi/tagbar', { 'on': 'Tagbar' }
Plug 'matze/vim-move'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --ts-completer', 'for': ['python', 'javascript']}
Plug 'vim-scripts/dbext.vim'
Plug 'vim-test/vim-test'
Plug 'vim-utils/vim-man'
Plug 'yegappan/mru'
call plug#end()
" }}}

