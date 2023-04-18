" Do not load MacVim colorscheme
let macvim_skip_colorscheme=1
let macvim_skip_cmd_opt_movement = 1
let macvim_hig_shift_movement = 1
" Copy to clipboard
set guioptions+=a

autocmd VimEnter * if (@% == "") | cd ~/notes/notes-private | execute 'VimwikiIndex' | endif
