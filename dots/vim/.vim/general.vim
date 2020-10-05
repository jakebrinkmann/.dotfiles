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
" greater than 50ms will count as separate keys
set timeout ttimeoutlen=50
set noerrorbells
" Search should be case insensitive unless containing uppercase characters.
set ignorecase
set smartcase
set infercase
" search into subdirectories
set path+=**
" lazy file name tab completion
set wildmode=longest:full,full
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
" coffee pasta
set clipboard^=unnamedplus
" disable startup message
set shortmess+=I

" Allow Ctrl-A and Ctrl-X to increment and decrement alphabetical characters.
" Do not treat numbers that begin with 0 as octal.
set nrformats+=alpha nrformats-=octal

" SpaceVIM! SpaceMACS!
let mapleader = " "

" Ctrl+Z to save
nnoremap <c-z> :w<CR>
inoremap <c-z> <Esc>:w<CR>a
" Make a new vertical split
nnoremap <silent> <leader>n :vnew<CR>
" Show only this window
nnoremap <silent> <leader>o :only<CR>
" Make a new tab
nnoremap <silent> <C-n> :tabnew<CR>
" Cycle to open tabs
nnoremap <silent> <leader><Left> gT
nnoremap <silent> <leader><Right> gt
" Toggle Spellchecking
nnoremap <leader>s :setlocal spell! spelllang=en_us<CR>
" Launch netrw in a little sidebar
nnoremap <leader>pv :wincmd v<bar> :Explore <bar> :wincmd r <bar> :vertical resize 30<CR>
" Edit and source WITH RICE
nnoremap <leader>ve :vsplit $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

augroup python_snippets
  autocmd!
  autocmd FileType python
      \ inoreabbrev <buffer> pdb import pdb; pdb.set_trace()# --- BREAKPOINT ---|
      \ inoreabbrev <buffer> raisenot raise NotImplementedError()<left>|
      \ inoreabbrev <buffer> ass assert
augroup end

augroup js_snippets
  autocmd!
  autocmd FileType javascript
      \ inoreabbrev <buffer> dbg debugger; // --- BREAKPOINT ---|
augroup end

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
