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
set novisualbell
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
set foldmethod=manual
" Visual: <z><f> to make a fold
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

" Keep undo history across sessions. (Vim 7.3+)
if has('persistent_undo')
  set undodir=~/.vim/tmp/undo undofile
endif
set noswapfile
set nobackup

" SpaceVIM! SpaceMACS!
let mapleader = "\<SPACE>"

" Make Y behave like D and C
nnoremap Y y$

" Make clipboard behave on MacOS
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif

" Use Arrow Keys for buffer navigation
map <silent> <up> :tabp<CR>
map <silent> <down> :tabn<CR>
map <silent> <left> :bp<CR>
map <silent> <right> :bn<CR>

" Break Undo sequence
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Avoid the escape key
imap kj <Esc>

" `#$` to realign comment to column 40
nnoremap #$ $?#<CR>D40i <Esc>40<bar>P:s/\s*$//<CR>:nohlsearch<CR>
" nnoremap <leader>w 40i <Esc>39h<CR>:nohlsearch<CR>

" \cc to changedir to current file
nnoremap <leader>cc :cd %:p:h<CR>
" gf to edit files, too
nnoremap gf :e %:h/<cfile><CR>
" Shift-G shows full path
nnoremap <leader>G :echo expand('%:p')<CR>
" Ctrl+C to delete buffer, but keep any split
nnoremap <C-c> :bp\|bd #<CR>
" Ctrl+Z to save
nnoremap <c-z> :w<CR>
inoremap <c-z> <Esc>:w<CR>a
" Toggle Spellchecking
nnoremap <leader>ss :setlocal spell! spelllang=en_us<CR>
" Launch netrw in a little sidebar
nnoremap <leader>pv :Lexplore<CR>
nnoremap <leader>pv :let @/=expand("%:t") <Bar> execute 'Explore' expand("%:h") <Bar> normal n<CR>
" \\ -- open last buffer
nnoremap \\ <C-^>
" \d -- delete current file
nnoremap <Leader>dd :call delete(expand("%")) \| bprevious \| bdelete #<CR>
" \r -- read file, starting in same directory as current file
nnoremap <Leader>r :r <C-R>=expand("%:h") . "/" <CR>
" \e -- edit file, starting in same directory as current file
nnoremap <Leader>e :e <C-R>=expand("%:h") . "/" <CR>
" \sa -- saveas file, starting as current file
nnoremap <Leader>sa :saveas <C-R>=expand("%") <CR>
" \a -- Easy copy matches into register
nnoremap <Leader>a :let @a="" \| g//y A <Left><Left><Left><Left><Left>

" \t -- insert ISO timestamp
vnoremap <Leader>t c<C-R>=strftime("%FT%T%z")<CR><ESC>
" * -- Search for selected text
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>
" \Enter -- Browse to ticket number as URI
xnoremap <Leader><CR> :call system('open ' . $JIRA_SERVER . '/browse/' . shellescape(@*) )<CR>

" Make a new tab
nnoremap <silent> <C-n> :tabnew<CR>
" Cycle to open tabs
nnoremap <silent> \<Left> gT
nnoremap <silent> \<Right> gt
" \0 -- Quickly switch/navigate tabs
nnoremap <silent> \0 :tabnext<CR>
nnoremap <silent> \s :tab split<CR>

" Disable Ex mode
nnoremap Q <nop>
nnoremap q <nop>

" \p -- Toggle insert mode
function! TogglePaste()
    if(&paste == 0)
        set paste
    else
        set nopaste
    endif
endfunction
nnoremap <silent> <Leader>pp :call TogglePaste()<cr>

function! YankText()
  if executable("clip.exe")
     call system('printf "%s" ' . shellescape(@") . ' |  clip.exe')
  elseif executable("xclip")
    call system('printf "%s" ' . shellescape(@") . ' |  xclip -i')
  endif
endfunction

augroup autofancy
  autocmd!
  " Automatically source vimrc on save.
  autocmd BufWritePost *.vimrc,*.vim nested source $MYVIMRC | redraw
  " resize the split panes to become equal
  autocmd VimResized * wincmd =
  " jump to the last position when reopening a file
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g`\"" | endif
  nnoremap <silent> <leader>y yy :call YankText()<CR>
  vnoremap <silent> <leader>y y :call YankText()<CR>
augroup end

augroup vim_terminal
  autocmd!
  " Open a new terminal window
  set shell=bash\ -l
  nnoremap <leader>tt :botright terminal<CR>
  nnoremap <leader>tr yy \| :call term_sendkeys(term_list()[0], @")<CR>
  vnoremap <leader>tr y \| :call term_sendkeys(term_list()[0], @")<CR>

  " Allow vim-style navigation to work from terminal window
  tnoremap <silent> <Esc><Esc> <C-\><C-N><CR>
  tnoremap <silent> <C-v> <C-W>""<CR>
  tnoremap <silent> <C-k> <C-W>k<CR>
  tnoremap <silent> <C-j> <C-W>j<CR>
  tnoremap <silent> <C-h> <C-W>h<CR>
  tnoremap <silent> <C-l> <C-W>l<CR>
  tnoremap <silent> \\ <C-W>:bnext<CR>

  " Dont wait too long for more keypresses
  setlocal ttimeoutlen=50

  " Turn off numbers in Terminal
  autocmd TerminalOpen * setlocal nolist nonumber colorcolumn=
augroup end

augroup fancy_files
  autocmd!
  " Turn off display in QuickFixes
  autocmd FileType qf setlocal nonumber colorcolumn=
  " Spaces instead of Tabs to take over da world
  autocmd FileType * setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab smartindent
  " 1 tab == 4 spaces
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 autoindent
  " Highlight commit message overflow
  autocmd FileType gitcommit setlocal textwidth=72
  " Syntax of these languages is fussy over tabs/spaces
  autocmd FileType make setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd FileType Makefile setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd FileType yml setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab autoindent cursorcolumn
  autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab autoindent cursorcolumn
augroup end

" create file parent directories if they don't exist
if !exists('*s:MkNonExDir')
    function s:MkNonExDir(file, buf)
        if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
            let l:dir=fnamemodify(a:file, ':h')
            if !isdirectory(l:dir)
                call mkdir(l:dir, 'p')
            endif
        endif
    endfunction
endif

augroup AutoMkdir
  autocmd!
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

augroup AutoSpellCheck
    autocmd FileType markdown,txt,tex setlocal spell spelllang=en_us
    autocmd FileType markdown,txt,tex setlocal wrap linebreak 
augroup END

" Replace abbreviations as I type
augroup python_snippets
  autocmd!
  autocmd FileType python
      \ inoreabbrev <buffer> pdb breakpoint()|
      \ inoreabbrev <buffer> raisenot raise NotImplementedError()|
      \ inoreabbrev <buffer> ass assert|
      \ inoreabbrev <buffer> brea breakpoint()
augroup end

augroup js_snippets
  autocmd!
  autocmd FileType javascript
      \ inoreabbrev <buffer> dbg debugger;|
      \ inoreabbrev <buffer> con console.log()|
      \ inoreabbrev <buffer> raise throw "HANDS IN THE AIR"|
augroup end

" Modified header
 function! LastModified()
    if &modified
       let save_cursor = getpos(".")
       let n = min([20, line("$")])
       keepjumps exe '1,' . n . 's#^\(.\{,5}Modified:\s\+\).*#\1' .
          \ strftime("%c") . '#e'
       call histdel('search', -1)
       call setpos('.', save_cursor)
    endif
 endfun
 autocmd BufWritePre * call LastModified()

" File header (Skeleton/Boilerplate)
" Modify file skeleton/boilerplate keywords
function! HeaderSetup()
  normal 1G
  exe "%s/@AUTHOR@/Jake J Brinkmann <jake.brinkmann@gmail.com>/ge"
  exe "%s/@COPYRIGHT@/" . strftime("%Y") . "/ge"
  exe "%s/@DATE@/" . strftime("%c") . "/ge"
  exe "%s/@FILE@/" . expand("%:t") . "/ge"
  exe "%s/@FILEBASE@/" . expand("%:t:r") . "/ge"
  exe "%s/@VERSION@/0.1.0/ge"
  normal G
  normal dd
  normal 1G
endfunction

" Add Markdown code-block delimiters to begin and end of current visual group.
function! s:MarkCodeBlock() abort
    call append(line("'<")-1, '```')
    call append(line("'>"), '```')
endfunction
autocmd FileType markdown,vimwiki xnoremap <Leader>_ :<c-u>call <sid>MarkCodeBlock()<CR>

augroup skeletons
  " :help skeleton
  "  :autocmd BufNewFile  *.java	0r ~/vim/skeleton.java
  " au BufNewFile * :silent! exec ":0r ".$VIMHOME."templates/".&ft
  autocmd BufNewFile *.pu,*.uml,*.plantuml,*.puml,*.iuml 0r ~/.vim/templates/skeleton.plantuml
  autocmd BufNewFile *docs/adr/*.md 0r ~/.vim/templates/skeleton.adr
  autocmd BufNewFile *.jsx 0r ~/.vim/templates/skeleton.jsx
  autocmd BufNewFile *.test.js 0r ~/.vim/templates/skeleton.test.js
  autocmd BufNewFile *.test.jsx 0r ~/.vim/templates/skeleton.test.jsx
  autocmd BufNewFile *.gitlab-ci.yml 0r ~/.vim/templates/skeleton.gitlab-ci.yml
  autocmd BufNewFile *.sh 0r ~/.vim/skeletons/sh.skel
  autocmd BufNewFile *.bash 0r ~/.vim/skeletons/sh.skel
  autocmd BufNewFile *.subr 0r ~/.vim/skeletons/sh.skel
  autocmd BufNewFile *.cpp 0r ~/.vim/skeletons/cpp.skel
  autocmd BufNewFile *.html,*.htm 0r ~/.vim/skeletons/html.skel
  autocmd BufNewFile *.js 0r ~/.vim/skeletons/js.skel
  autocmd BufNewFile *.json 0r ~/.vim/skeletons/json.skel
  autocmd BufNewFile *Makefile* 0r ~/.vim/skeletons/mkfile.skel
  autocmd BufNewFile *.py 0r ~/.vim/skeletons/python.skel
  autocmd BufNewFile *.spec 0r ~/.vim/skeletons/rpmspec.skel
  autocmd BufNewFile *.sql,*.pgsql 0r ~/.vim/skeletons/sql.skel
  autocmd BufNewFile *.cfg,*.config,*.conf 0r ~/.vim/skeletons/text.skel
  autocmd BufNewFile *.{yaml,yml} 0r ~/.vim/skeletons/yaml.skel
  autocmd BufNewFile env.json 0r ~/.vim/templates/skeleton.env.json
  autocmd BufNewFile CHANGELOG.md 0r ~/.vim/templates/skeleton.Changelog.md
augroup END
