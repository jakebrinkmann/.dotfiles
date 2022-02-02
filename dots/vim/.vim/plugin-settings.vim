try
    colorscheme gruvbox
catch
    colorscheme desert
endtry
set background=dark
set noshowmode

" Highlight spelling mistakes
hi clear SpellBad
hi SpellBad ctermfg=Red

" ======================================================================================
" ┏━┓╺┳╸┏━┓╺┳╸╻ ╻┏━┓╻  ╻┏┓╻┏━╸
" ┗━┓ ┃ ┣━┫ ┃ ┃ ┃┗━┓┃  ┃┃┗┫┣╸
" ┗━┛ ╹ ╹ ╹ ╹ ┗━┛┗━┛┗━╸╹╹ ╹┗━╸
" github.com/xero/dotfiles
let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ [ 'filename' ],
  \             [ 'linter',  'gitbranch' ] ],
  \   'right': [ [ 'percent', 'lineinfo' ],
  \              [ 'fileencoding', 'filetype' ] ]
  \ },
  \ 'inactive': { 'left': [['filename']] },
  \ 'component_function': {
  \   'modified': 'WizMod',
  \   'readonly': 'WizRO',
  \   'gitbranch': 'WizGit',
  \   'filename': 'WizName',
  \   'filetype': 'WizType',
  \   'fileencoding': 'WizEncoding',
  \   'mode': 'WizMode',
  \ },
  \ 'component_expand': {
  \   'linter': 'WizErrors',
  \ },
  \ 'component_type': {
  \   'readonly': 'error',
  \   'linter': 'error'
  \ },
  \ 'separator': { 'left': '▊▋▌▍▎', 'right': '▎▍▌▋▊' },
  \ 'subseparator': { 'left': '▏', 'right': '▕' }
  \ }

function! WizMod()
  return &ft =~ 'help\|vimfiler' ? '' : &modified ? '» ' : &modifiable ? '' : ''
endfunction

function! WizRO()
  return &ft !~? 'help\|vimfiler' && &readonly ? ' ' : ''
endfunction

function! WizGit()
  return !IsTree() ? exists('*fugitive#head') || exists('*FugitiveHead') ? fugitive#head() : '' : ''
endfunction

function! WizName()
  return !IsTree() ? ('' != WizRO() ? WizRO() : WizMod()) . ('' != expand('%:t') ? expand('%:t') : '[none]') . ('' != WizPaste() ? WizPaste() : '') : ''
endfunction

function! WizType()
  return winwidth(0) > 70 ? (strlen(&filetype) ? ' ' . &filetype : '') : ''
endfunction

function! WizEncoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &enc : &enc) : ''
endfunction

function! WizErrors()
  if exists('*ale#statusline#Count') || exists(':ALELint')
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '' : printf(
          \   '• %d ✘ %d',
          \   all_non_errors,
          \   all_errors
          \)
  else
    return ''
  endif
endfunction

function! WizPaste()
  return &ft =~ 'help\|vimfiler' ? '' : &paste ? ' ⎀' : ''
endfunction

function! IsTree()
  let l:name = expand('%:t')
  return l:name =~ 'NetrwTreeListing\|undotree' ? 1 : 0
endfunction

augroup alestatus
  au!
  autocmd User ALELintPost call lightline#update()
augroup end
" ======================================================================================

" hide gitignored files from netrw <- Doesn't work for me :(
" let g:netrw_list_hide= netrw_gitignore#Hide()
" define what a hidden file is
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
" hide hidden by default
let g:netrw_hide = 1
" directory banner is mostly useless
let g:netrw_banner = 0
" open files in (0: current pane, 4: previous window "P")
let g:netrw_browse_split = 0
" width of the directory explorer
let g:netrw_winsize = 15
" tree list view (0: thin, 1: info, 2: columns, 3: tree)
let g:netrw_liststyle = 3
" Sort files (time|name / normal|reverse)
let g:netrw_sort_by="name"
let g:netrw_sort_direction="normal"

" Netrw comes with lots of mappings that can lead to unintentional, accidental
" changes. We will unmap everything and map only the functions that we need.
function! NetrwMapping()
    mapclear <buffer>
    " Ctrl-R to refresh listing
    nnoremap <silent><nowait><buffer> <C-R>
                \ :call netrw#Call('NetrwRefresh', 1,
                \                  netrw#Call('NetrwBrowseChgDir', 1, './'))<CR>
    " Backspace to go up the directory tree
    nnoremap <silent><nowait><buffer> <Backspace>
                \ :call netrw#Call('NetrwBrowseUpDir', 1)<CR>
    " Enter to open a directory
    nnoremap <silent><nowait><buffer> <CR>
                \ :call netrw#LocalBrowseCheck(netrw#Call('NetrwBrowseChgDir', 1,
                \                              netrw#Call('NetrwGetWord')))<CR>
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

augroup CloudformationLint
  au!
  au BufRead,BufNewFile *template.yaml set filetype=yaml.cloudformation
augroup end

" Pretty-print ALE
nnoremap =a :ALEFix<CR>

" Configure ALE Linters and Fixers
let g:ale_linters = {
    \'python': ['flake8', 'mypy'],
    \'javascript': ['eslint'],
    \'cloudformation': ['cloudformation'],
    \'yaml': ['yamllint'],
\}
" $ cat ~/.config/flake8
" [flake8]
" max-line-length=88
let g:ale_fixers = {
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
    \'python': ['isort', 'black'],
    \'javascript': ['eslint', 'prettier'],
    \'html': ['prettier'],
    \'json': ['jq'],
    \'css': ['eslint'],
    \'sql': ['pgformatter']
\}
" let g:ale_python_isort_options = '--sp ~/.isort.cfg --virtual-env .venv'
" let g:ale_python_black_options = '--line-length=80'
" let g:ale_python_flake8_options = '--max-line-length 80'
" let g:ale_python_mypy_options = '--strict --warn-unreachable --warn-return-any --follow-imports=normal'
" let g:ale_python_mypy_options = '--ignore-missing-imports --follow-imports=silent --show-column-numbers --strict'
let g:ale_python_mypy_show_notes = 1
let g:ale_python_pyupgrade_options = '--py38-plus'
let g:ale_javascript_prettier_options = '--single-quote --print-width 120'
let g:ale_json_jq_options = ''
let g:ale_json_jq_filters = '.'
let g:ale_yaml_yamllint_options = '-d "{extends: relaxed, rules: {line-length: disable}}"'
let g:ale_sql_pgformatter_options = '--no-extra-line --function-case 2 --wrap-after 4'
" Only run linters when specified
let g:ale_linters_explicit = 1
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 1 " use localation list, :lopen
let g:ale_sign_error = "✘"
let g:ale_sign_warning = '•'
let g:ale_sign_info = '⌇'
let g:ale_sign_style_error = g:ale_sign_error
let g:ale_sign_style_warning = g:ale_sign_warning
" Useful for debugging, disable for performance
let g:ale_hisory_enabled = 0
let g:ale_history_log_output = 0

let g:ycm_key_list_select_completion   = ['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
let g:ycm_key_list_stop_completion = ['<Enter>']

" :UltiSnips Trigger Configuration
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsSnippetDirectories = [ "UltiSnips" ]

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
" Turn off the auto-popup window
let g:ycm_auto_hover = ""
" Auto close preview window
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
" write YCM error into the console so we can see wtf is going on
let g:ycm_server_use_vim_stdout = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_semantic_triggers = {
    \'css': [ 're!^', 're!^\s+', ': ' ],
    \'html': [ 're!<\/' ],
\}
" To restart YCM: call YcmRestartServer
nnoremap <silent> <leader>gt :YcmCompleter GoTo<CR>

" enable all syntax highlighting
let g:python_highlight_all = 1
" allow for local virtualenvs
let g:virtualenv_directory = $PWD
nnoremap <leader>tv :VirtualEnvActivate .venv<CR>
nnoremap <leader>te :Dotenv .env<CR>
" force vim-test to use pytest
let test#strategy = "vimterminal"
let test#python#runner = 'pytest'
let test#javascript#runner = 'jest'
" could also use "--inspect=9229" for "chrome://inspect" dedicated DevTools
let g:test#javascript#jest#executable =
      \'node inspect node_modules/.bin/jest --runInBand --config ./jest.config.json'
" running tests on different granularities
nmap <silent> <leader>tp :TestNearest --pdb -vv -s<CR>
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>tl :TestLast<CR>

if executable('rg')
    let g:rg_derive_root = 'true'
    " Search the project (globs: -g "folder/**.yaml")
    nnoremap <leader>ps :Rg<SPACE>
    " Find files
    nnoremap <leader>pf :Files<CR>
    " Find tracked files
    nnoremap <leader>pg :GFiles<CR>
    " Make switching buffers easier
    nnoremap <Leader>b :Buffers<CR>
endif

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
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gh :Ghdiffsplit<CR>
nnoremap <leader>gd :Gdiff!<CR>
nnoremap <leader>gn :Git difftool --name-status origin/development<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>go :diffget<SPACE>
nnoremap <leader>gp :diffput<SPACE>

" NeoTERM REPLs
"""""""""""""""
let g:neoterm_default_mod = 'botright'
let g:neoterm_autoinsert = 1
let g:neoterm_auto_repl_cmd = 0

" Open a new terminal window
set shell=bash\ -l
nnoremap <silent> <leader>tt :Ttoggle()<CR>
tnoremap <silent> <leader>tt <C-W>:Ttoggle()<CR>
tnoremap <silent> \\ <C-W>:Tnext<CR>
" Send selected text to terminal window
nnoremap <silent> <leader>tr :TREPLSendLine<CR>
vnoremap <silent> <leader>tr :TREPLSendSelection<CR>

" This makes :TREPLSendLine work for Python
let g:neoterm_repl_python =
  \ ['poetry run python']
let g:neoterm_repl_command = add(g:neoterm_repl_python, '')

" Pretty-print JSON
nnoremap =j :%!python3 -m json.tool<CR>

" (SHIFT) moves lines and selections in a more visual manner
let g:move_key_modifier='S'

" markdown-preview (:MarkdownPreview)
let g:mkdp_refresh_slow = 1
let g:mkdp_page_title = '「 ${name} 」'
let g:mkdp_auto_close = 0

" Vim Wiki
""""""""""
let g:vimwiki_list = [{'path': '~/wiki/', 'syntax': 'markdown'}]
au FileType vimwiki setlocal shiftwidth=6 tabstop=6 noexpandtab
let g:vimwiki_listsyms = '.:%*x'
command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    " automatically update links on read diary
    autocmd BufWinEnter diary.wiki VimwikiDiaryGenerateLinks
    autocmd BufWinEnter index.wiki VimwikiRebuildTags
augroup end
autocmd FileType vimwiki nnoremap <buffer> <Leader>wx :VimwikiToggleListItem<CR>
autocmd FileType vimwiki nnoremap <buffer> <Leader>ws VimwikiSearchTags //
autocmd FileType vimwiki command! Jira ::%s/\s\(ENG\w*-\d\+\)/\=" [".submatch(1)."](".expand($JIRA_SERVER)."\/browse\/".submatch(1).") "/g
