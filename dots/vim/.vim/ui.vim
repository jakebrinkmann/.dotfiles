" (default is 4000 ms = 4 s)
set updatetime=50
" Highlight current cursor-line
set cursorline
" Turn on highlighting search-hits
set hlsearch
" Start searching right away
set incsearch
" always show the status bar
set laststatus=2
" " configure termial title to look like: ~/.v/.vimrc [+]
set title
set titlestring=%{substitute(expand(\"%:~:h\"),\"\\\\(/\\\\.\\\\?.\\\\)[^/]*\",\"\\\\1\",\"g\")}%{\"/\".expand(\"%:t\")}%(\ %a%r%m%)
set titlelen=72
set titleold=
" enable 256 colors
set t_Co=256
set t_ut=
" set splits more naturally
set splitbelow
set splitright
" dont auto-resize windows
set noequalalways
" Set scroll offset so the active line stays towards the center.
set scrolloff=999
set sidescrolloff=999
" merge signcolumn and number column into one
set signcolumn=number
" show matching brackets/parenthesis
set showmatch
" syntax highlighting
syntax on
" only highlight first N characters of very long lines
set synmaxcol=512
" remove all guioptions
set guioptions=

" Don't redraw while executing macros (good performance config)
set lazyredraw
set updatetime=4000

" Set the text width to 120 and create a vertical bar in 121th column. Some
" filetypes such as gitcommit have a custom width defined and we use autocmd
" here so our textwidth value takes precedence.
set nowrap
set colorcolumn=121
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Trailing whitespace is an ERROR
match Error '\s\+$'
" highlight smart quotes
match Error '[“”]'

" Show dots for spaces (listchars)
set list
set listchars=eol:↵,tab:▸\ ,trail:★,precedes:←,extends:→,space:·

" Setup cursor for Windows Terminal
if &term =~ '^xterm'
    " normal mode (blinking block = 0)
    let &t_EI = "\e[1 q"
    " insert mode (steady bar = 6)
    let &t_SI = "\e[6 q"
endif

" Window Resizing
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>
nnoremap <silent> <leader>. :resize +5<CR>
nnoremap <silent> <leader>, :resize -5<CR>
" move through split windows
nnoremap <silent> <leader><Up> :wincmd K<CR>
nnoremap <silent> <leader><Down> :wincmd J<CR>
nnoremap <silent> <leader><Left> :wincmd H<CR>
nnoremap <silent> <leader><Right> :wincmd L<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
nnoremap <silent> == :wincmd =<CR>
" Re-select visual block after indenting
vnoremap < <gv
vnoremap > >gv

" turn hybrid line numbers on when not INSERT
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &number && mode() != "i" | set relativenumber   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &number                  | set norelativenumber | endif
augroup END

" Make my own custom syntax for my task list
function! PomoHighlighter()
  syntax match GruvboxFg0 /\[ \].*/ containedin=ALL " (White) pending or planned
  syntax match GruvboxPurple  /\[%\].*/ containedin=ALL " (Purple) started but not completed
  syntax match GruvboxBlue /\[\*\].*/ containedin=ALL " (Blue) in progress right now
  syntax match GruvboxGreen /\[x\].*/ containedin=ALL " (Green) task done
  syntax match GruvboxGreen /{x}.*/ containedin=ALL " (Green) task done
  syntax match GruvboxYellow /\[\.\].*/ containedin=ALL " (Yellow) paused by me
  syntax match GruvboxOrange /\[:\].*/ containedin=ALL " (Orange) blocked by external condition
  syntax match GruvboxRed /\[?\].*/ containedin=ALL " (Red) stalled by lack of info
  syntax match GruvboxAqua /\[-\].*/ containedin=ALL " (Aqua) removed
  syntax match GruvboxGray /\[>\].*/ containedin=ALL " (LightGrey) bumped to next week
  syntax match GruvboxBg0 /{ }.*/ containedin=ALL " (Grey) stretch goal
  syntax match Error /!\?!.*/ containedin=ALL " (Red) emergency/unexpected task
  highlight def link htmlH1 Ignore
  highlight def link htmlH2 Ignore
endfunction
augroup PomodoroTodoList
    autocmd BufReadPost,BufEnter *TODOS.md call PomoHighlighter()
augroup END

function! AdaptColorscheme()
   highlight Normal ctermbg=none
endfunction
augroup MakeVimTransparent
  autocmd ColorScheme * call AdaptColorscheme()
augroup END
