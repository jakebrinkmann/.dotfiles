" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" (aka "enter current millenium")
set nocompatible
" enable builtin plugins
filetype plugin on
" sane text files
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8
scriptencoding utf-8
" (default is 4000 ms = 4 s)
set updatetime=50
" greater than 50ms will count as separate keys
set timeout ttimeoutlen=50
" Highlight current cursor-line
set cursorline
set noerrorbells
" Line Numbers
set number
" Relative to current line
set norelativenumber
set nowrap
" Search should be case insensitive unless containing uppercase characters.
set ignorecase
set smartcase
set infercase
" Turn on highlighting search-hits
set hlsearch
" Start searching right away
set incsearch
" always show the status bar
set laststatus=2
" configure termial title to look like: .vimrc (~) [+]
set title
set titlestring=%t%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%r%m%)
set titlelen=70
" enable 256 colors
set t_Co=256
set t_ut=
" search into subdirectories
set path+=**
" lazy file name tab completion
set wildmode=longest,list,full
set wildmenu
set wildignorecase
" ignore files vim doesnt use
set wildignore+=.git,.hg,.svn
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
set wildignore+=*.mp3,*.oga,*.ogg,*.wav,*.flac
set wildignore+=*.eot,*.otf,*.ttf,*.woff
set wildignore+=*.doc,*.pdf,*.cbr,*.cbz
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
set wildignore+=*.swp,.lock,.DS_Store,._*
" set splits more naturally
set splitbelow
set splitright
" dont auto-resize windows
set noequalalways
" Set scroll offset so the active line stays towards the center.
set scrolloff=8
" make backspace behave in a sane manner
set backspace=indent,eol,start
" code folding (:help folds)
set foldenable
set foldmethod=indent
set foldlevelstart=1
set foldnestmax=1
" set foldcolumn=1
" allow hidding unsaved buffers
set hidden
" To use Vim Modelines (file specific overrides):
set modeline
set modelines=5
" merge signcolumn and number column into one
set signcolumn=number
" show matching brackets/parenthesis
set showmatch
" syntax highlighting
syntax on
set synmaxcol=512
" coffee pasta
set clipboard^=unnamedplus
" disable startup message
set shortmess+=I

" Enable persistent undo.
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/undodir')
  silent !mkdir ~/.vim/undodir > /dev/null 2>&1
elseif has('persistent_undo')
  set undodir=~/.vim/undodir undofile
endif
set noswapfile
set nobackup

" Set the text width to 88 and create a vertical bar in 89th column. Some
" filetypes such as gitcommit have a custom width defined and we use autocmd
" here so our textwidth value takes precedence.
autocmd FileType * setlocal textwidth=88
set colorcolumn=89
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Allow Ctrl-A and Ctrl-X to increment and decrement alphabetical characters.
" Do
" not treat numbers that begin with 0 as octal.
set nrformats+=alpha nrformats-=octal

" Trailing whitespace is an ERROR
match Error /\s\+$/

" Try to highlight spelling mistakes
hi clear SpellBad
hi SpellBad ctermfg=NONE ctermbg=NONE cterm=underline

" Show dots for spaces (listchars)
set list
set listchars=eol:↵,tab:▸\ ,trail:★,precedes:←,extends:→,space:·

" SpaceVIM! SpaceMACS!
let mapleader = " "

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
Plug 'itchyny/lightline.vim'
Plug 'jmcantrell/vim-virtualenv'
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
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --ts-completer' }
Plug 'vim-test/vim-test'
Plug 'vim-utils/vim-man'
Plug 'w0rp/ale'
call plug#end()
" }}}

" Setup cursor for Windows Terminal
if &term =~ '^xterm'
    " normal mode (blinking block = 0)
    let &t_EI = "\e[1 q"
    " insert mode (steady bar = 6)
    let &t_SI = "\e[6 q"
endif

try
    colorscheme gruvbox
catch
    colorscheme desert
endtry
set background=dark
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'gruvbox',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component': {
    \   'filename': '%t ¦ ᵇ%n'
    \ },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead'
    \ },
    \ 'inactive': { 'left': [['modified']] },
\ }

if executable('rg')
    let g:rg_derive_root = 'true'
endif

" Make a new vertical split
nnoremap <silent> <leader>n :vnew<CR>
" Show only this window
nnoremap <silent> <leader>o :only<CR>
" Make a new tab
nnoremap <silent> <C-n> :tabnew<CR>
" Cycle to open tabs
nnoremap <silent> <leader><Left> gT
nnoremap <silent> <leader><Right> gt
" Launch netrw in a little sidebar
nnoremap <leader>pv :wincmd v<bar> :Explore <bar> :wincmd r <bar> :vertical resize 30<CR>
" Edit and source WITH RICE
nnoremap <leader>ve :vsplit $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

" hide gitignored files from netrw <- Doesn't work for me :(
" let g:netrw_list_hide= netrw_gitignore#Hide()
" define what a hidden file is
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
" hide hidden by default
let g:netrw_hide = 1
" directory banner is mostly useless
let g:netrw_banner = 0
" tree list view
let g:netrw_liststyle = 3
" open files in current pane
let g:netrw_browse_split = 0
" width of the directory explorer
let g:netrw_winsize = 25

" Netrw comes with lots of mappings that can lead to unintentional, accidental
" changes. We will unmap everything and map only the functions that we need.
function! NetrwMapping()
    mapclear <buffer>
    " Ctrl-R to refresh listing
    nnoremap <silent><nowait><buffer> <C-R>
                \ :call netrw#Call('NetrwRefresh', 1,
                \                  netrw#Call('NetrwBrowseChgDir', 1, './'))<CR>
    " Left to go up the directory tree
    nnoremap <silent><nowait><buffer> <Left>
                \ :call netrw#Call('NetrwBrowseUpDir', 1)<CR>
    " Right||Enter to open a directory
    nnoremap <silent><nowait><buffer> <Right>
                \ :call netrw#LocalBrowseCheck(netrw#Call('NetrwBrowseChgDir', 1,
                \                              netrw#Call('NetrwGetWord')))<CR>
    nmap <silent><nowait><buffer> <CR> <Right>
    " o to create a new file
    nnoremap <silent><nowait><buffer> o
                \ :call netrw#Call('NetrwOpenFile', 1)<CR>
    " d to make a new directory
    nnoremap <silent><nowait><buffer> d
                \ :call netrw#Call('NetrwMakeDir', "")<CR>
    " D||Delete to delete
    nnoremap <silent><nowait><buffer> D
                \ :call netrw#Call('NetrwLocalRm', b:netrw_curdir)<CR>
    nmap <silent><nowait><buffer> <DEL> D
    " P to open in previous window
    nnoremap <silent><nowait><buffer> P
                \ :call netrw#Call('NetrwPrevWinOpen', 1)<CR>
    " . to toggle showing hidden files
    nnoremap <silent><nowait><buffer> .
                \ :call netrw#Call('NetrwHidden', 1)<CR>
endfunction
augroup netrw_mappings
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup end

" Configure ALE Linters and Fixers
let g:ale_linters = {
    \'python': ['flake8'],
    \'javascript': ['eslint']
\}
" $ cat ~/.config/flake8
" [flake8]
" max-line-length=88
let g:ale_fixers = {
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
    \'python': ['black', 'isort'],
    \'javascript': ['prettier'],
    \'css': ['prettier']
\}
let g:ale_python_isort_options = '--multi-line=3 --trailing-comma --use-parentheses --line-width=88'
" Only run linters when specified
let g:ale_linters_explicit = 1
let g:ale_set_loclist = 0
let g:ale_sign_error = "◉"
let g:ale_sign_warning = '•'
let g:ale_sign_info = '⌇'
let g:ale_sign_style_error = g:ale_sign_error
let g:ale_sign_style_warning = g:ale_sign_warning

" Hmmm setting up YCM for python...
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
" Trigger semantic completion
let g:ycm_key_invoke_completion = '<C-Space>'
" Start autocompletion after 4 chars
let g:ycm_min_num_of_chars_for_completion = 4
let g:ycm_min_num_identifier_candidate_chars = 4
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_complete_in_comments = 0
" Don't show YCM's preview window
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
" Turn off the auto-popup window
let g:ycm_auto_hover = ""
" Auto close preview window
let g:ycm_autoclose_preview_window_after_completion=1
" write YCM error into the console so we can see wtf is going on
let g:ycm_server_use_vim_stdout = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_semantic_triggers = {
    \'css': [ 're!^', 're!^\s+', ': ' ],
    \'html': [ 're!<\/' ],
\}
" select the completion with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" close preview on completion complete
augroup completionhide
  autocmd!
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end
" To restart YCM: call YcmRestartServer
nnoremap <silent> <leader>gt :YcmCompleter GoTo<CR>

" enable all syntax highlighting
let g:python_highlight_all = 1
" allow for local virtualenvs
let g:virtualenv_directory = $PWD
nnoremap <leader>tv :VirtualEnvActivate .virtualenv<CR>
nnoremap <leader>te :Dotenv .env<CR>
" force vim-test to use pytest
let test#python#runner = 'pytest'
" running tests on different granularities
nmap <silent> <leader>tp :TestNearest --pdb<CR>
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tg :TestVisit<CR>
let test#strategy = "terminal"
nnoremap <silent> <leader>tr :TREPLSendLine<CR>
vnoremap <silent> <leader>tr :TREPLSendSelection<CR>

augroup python_snippets
  autocmd!
  autocmd FileType python
      \ inoreabbrev <buffer> pdb import pdb; pdb.set_trace()# --- BREAKPOINT ---|
      \ inoreabbrev <buffer> raisenot raise NotImplementedError()<left>|
      \ inoreabbrev <buffer> ass assert
augroup end

nnoremap <leader>tb :TagbarToggle<CR>
nnoremap <leader>u :UndotreeShow<CR>
" Use Rip-Grep!
nnoremap <leader>ps :Rg<SPACE>
" FZF file files
nnoremap <leader>pf :Files<CR>
" Make switching buffers easier
nnoremap <Leader>b :Buffers<CR>
" Ctrl-D to close current buffer (:bufdelete)
nnoremap <silent> <C-d> :Sayonara<CR>
" Ctrl-C to close current window (:close)
nnoremap <silent> <C-c> :Sayonara!<CR>

" speed optimizations
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_max_signs = 1500
let g:gitgutter_diff_args = '-w'
" custom symbols
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = ':'
highlight clear SignColumn
highlight GitGutterAdd ctermfg=darkgreen
highlight GitGutterChange ctermfg=magenta
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=red

" Fugitive Mappings
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gh :Ghdiffsplit<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>go :diffget<SPACE>
nnoremap <leader>gp :diffput<SPACE>
nnoremap <leader>gl :GV<SPACE>

nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>
nnoremap <silent> <leader>. :resize +5<CR>
nnoremap <silent> <leader>, :resize -5<CR>

" Toggle Spellchecking
nnoremap <leader>s :setlocal spell! spelllang=en_us<CR>

" Make a new terminal window
set shell=bash\ -l
nnoremap <leader>tt :botright terminal<CR>
tnoremap <silent> <C-x> i
tnoremap <silent> <C-x> <C-\><C-N><CR>
tnoremap <silent> <C-v> <C-W>""<CR>
tnoremap <silent> <C-k> <C-W>k<CR>
tnoremap <silent> <C-j> <C-W>j<CR>
tnoremap <silent> <C-h> <C-W>h<CR>
tnoremap <silent> <C-l> <C-W>l<CR>

" NeoTERM REPLs
nnoremap <leader>tt :Ttoggle<CR>
tnoremap <leader>tt <C-W>:Ttoggle<CR>
let g:neoterm_default_mod = 'botright'
let g:neoterm_autoinsert = 1
let g:neoterm_repl_python =
  \ ['source .virtualenv/bin/activate', 'python']
let g:neoterm_repl_command = add(g:neoterm_repl_python, '')

" Pretty-print JSON
nnoremap =j :%!python3 -m json.tool<CR>
" Pretty-print ALE
nnoremap =a :ALEFix<CR>

" (SHIFT) moves lines and selections in a more visual manner
let g:move_key_modifier='S'

" move through split windows
nnoremap <silent> <C-Up> :wincmd K<CR>
nnoremap <silent> <C-Down> :wincmd J<CR>
nnoremap <silent> <C-Left> :wincmd H<CR>
nnoremap <silent> <C-Right> :wincmd L<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
" Re-select visual block after indenting
vnoremap < <gv
vnoremap > >gv
" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" Ctrl+Z to save
nmap <c-z> :w<CR>
imap <c-z> <Esc>:w<CR>a

augroup autofancy
  autocmd!
  " Automatically source vimrc on save.
  autocmd! bufwritepost $MYVIMRC source $MYVIMRC
  " resize the split panes to become equal
  autocmd VimResized * wincmd =
  " jump to the last position when reopening a file
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g`\"" | endif
augroup end

augroup fancy_files
  autocmd!
  " Turn off display in QuickFixes
  autocmd FileType qf setlocal nonumber colorcolumn=
  autocmd FileType neoterm setlocal nonumber colorcolumn= nolist
  " Wrap long line even if the initial line is longer than textwidth.
  autocmd FileType * setlocal formatoptions-=b formatoptions-=l
  " Spaces instead of Tabs to take over da world
  autocmd FileType * setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab smartindent
  autocmd FileType yaml setlocal autoindent cursorcolumn
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 autoindent
  autocmd FileType make setlocal noexpandtab
  " Highlight commit message overflow
  autocmd FileType gitcommit setlocal textwidth=72
augroup end

" remove trailing white space
command Nows :%s/\s\+$//
" remove blank lines
command Nobl :g/^\s*$/d
" make current buffer executable
command Chmodx :!chmod a+x %
" fix syntax highlighting
command FixSyntax :syntax sync fromstart
" Usually, trying to write (not fzf#vim#windows)
command W :w
