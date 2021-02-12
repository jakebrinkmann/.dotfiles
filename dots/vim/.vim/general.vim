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
" never ring the bell for any reason
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
set foldlevelstart=20
set foldnestmax=20
" set foldopen=all
" set foldclose=all
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
" indent wrapped lines to match start
set breakindent
set breakindentopt=shift:2
" allow cursor to move where there is no text in visual block mode
set virtualedit=block
" <BS>/h/l/<Left>/<Right>/<Space>/~ can cross lines
set whichwrap=b,h,l,s,<,>,[,],~

" Allow Ctrl-A and Ctrl-X to increment and decrement alphabetical characters.
" Do not treat numbers that begin with 0 as octal.
set nrformats+=alpha nrformats-=octal

" SpaceVIM! SpaceMACS!
let mapleader = "\<SPACE>"

" gf to edit files, too
nnoremap gf :e <cfile><CR>
" Shift-G shows full path
nnoremap G :echo expand('%:p')<CR>
" Ctrl+Z to save
nnoremap <c-z> :w<CR>
inoremap <c-z> <Esc>:w<CR>a
" Make a new vertical split
nnoremap <silent> <leader>vn :vnew<CR>
" Show only this window
nnoremap <silent> <leader>vo :only<CR>
" Veritcal Split
nnoremap <silent> <leader>vs :vsplit<CR>
" Make a new tab
nnoremap <silent> <C-n> :tabnew<CR>
" Cycle to open tabs
nnoremap <silent> \<Left> gT
nnoremap <silent> \<Right> gt
" Toggle Spellchecking
nnoremap <leader>s :setlocal spell! spelllang=en_us<CR>
" Launch netrw in a little sidebar
nnoremap <leader>pv :wincmd v<bar> :Explore <bar> :wincmd r <bar> :vertical resize 30<CR>
" \\ -- open last buffer
nnoremap \\ <C-^>
" \r -- read file, starting in same directory as current file
nnoremap <Leader>r :r <C-R>=expand("%:p:h") . "/" <CR>
" \e -- edit file, starting in same directory as current file
nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
" \w -- Easy save
nnoremap <Leader>w :w<CR>
" * -- Search for selected text
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>

" \p -- Toggle insert mode
function! TogglePaste()
    if(&paste == 0)
        set paste
    else
        set nopaste
    endif
endfunction
nnoremap <silent> <Leader>pp :call TogglePaste()<cr>

augroup python_snippets
  autocmd!
  autocmd FileType python
      \ inoreabbrev <buffer> pdb import pdb; pdb.set_trace()# --- BREAKPOINT ---|
      \ inoreabbrev <buffer> raisenot raise NotImplementedError()|
      \ inoreabbrev <buffer> ass assert
augroup end

augroup js_snippets
  autocmd!
  autocmd FileType javascript
      \ inoreabbrev <buffer> dbg debugger; // --- BREAKPOINT ---|
      \ inoreabbrev <buffer> clog console.log()|
      \ inoreabbrev <buffer> raise throw "HANDS IN THE AIR"|
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
  " copy from WSL to clip.exe on yank
  if executable("clip.exe")
    autocmd TextYankPost *
          \ if v:event.operator ==# 'y' |
          \ call system('echo '
          \             .shellescape(join(v:event.regcontents, "\<CR>"))
          \             .' |  clip.exe') |
          \ endif
  endif
augroup end

augroup fancy_files
  autocmd!
  " Turn off display in QuickFixes
  autocmd FileType qf setlocal nonumber colorcolumn=
  autocmd FileType neoterm setlocal nonumber colorcolumn= nolist
  " Spaces instead of Tabs to take over da world
  autocmd FileType * setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab smartindent
  autocmd FileType yaml setlocal autoindent cursorcolumn
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 autoindent
  autocmd FileType make setlocal noexpandtab
  " Highlight commit message overflow
  autocmd FileType gitcommit setlocal textwidth=72
augroup end

augroup AutoMkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END
